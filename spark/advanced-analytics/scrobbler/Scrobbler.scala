import org.apache.spark.rdd.RDD
import org.apache.spark.broadcast.Broadcast
import scala.collection.Map
import org.apache.spark.mllib.recommendation._
import org.apache.spark.sql.{DataFrame, Dataset, SparkSession}

def getArtistByID(rawArtistData: RDD[String]) = {
  rawArtistData.flatMap { line =>
    val (id, name) = line.span(_ != '\t')
    if (name.isEmpty) {
      None
    } else {
      try {
        Some((id.toInt, name.trim))
      } catch {
        case e: NumberFormatException => None
      }
    }
  }
}

def getArtistAlias(rawArtistAlias: RDD[String]) = {
  rawArtistAlias.flatMap { line =>
    val tokens = line.split('\t')
    if (tokens(0).isEmpty) {
      None
    } else {
      Some((tokens(0).toInt, tokens(1).toInt))
    }
  }.collectAsMap()
}

def getTrainData(rawUserArtistData: RDD[String],
                 bArtistAlias: Broadcast[Map[Int, Int]]) = {
  rawUserArtistData.map { line =>
    val Array(userID, artistID, count) = line.split(' ').map(_.toInt)
    val finalArtistID = bArtistAlias.value.getOrElse(artistID, artistID)
    Rating(userID, finalArtistID, count)
  }.cache()
}

def getArtistsForUser(rawUserArtistData: RDD[String],
                      artistByID: RDD[(Int, String)],
                      userId: Int) = {
  val rawArtistsForUser = rawUserArtistData.map(_.split(' ')).filter {
    case Array(user, _, _) => user.toInt == userId
  }
  val existingProducts = rawArtistsForUser.map {
    case Array(_, artist, _) => artist.toInt
  }.collect().toSet
  artistByID.filter {
    case (id, name) => existingProducts.contains(id)
  }.values.collect()
}

def areaUnderCurve(
    spark: SparkSession,
    positiveData: DataFrame,
    bAllArtistIDs: Broadcast[Array[Int]],
    predictFunction: (DataFrame => DataFrame)): Double = {

  import spark.implicits._

  // What this actually computes is AUC, per user. The result is actually something
  // that might be called "mean AUC".

  // Take held-out data as the "positive".
  // Make predictions for each of them, including a numeric score
  val positivePredictions = predictFunction(positiveData.select("user", "artist")).
    withColumnRenamed("prediction", "positivePrediction")

  // BinaryClassificationMetrics.areaUnderROC is not used here since there are really lots of
  // small AUC problems, and it would be inefficient, when a direct computation is available.

  // Create a set of "negative" products for each user. These are randomly chosen
  // from among all of the other artists, excluding those that are "positive" for the user.
  val negativeData = positiveData.select("user", "artist").
    map(row => (row.getInt(0), row.getInt(1))).
    groupByKey { case (user, _) => user }.
    flatMapGroups { case (userID, userIDAndPosArtistIDs) =>
      val random = new Random()
      val posItemIDSet = userIDAndPosArtistIDs.map { case (_, artist) => artist }.toSet
      val negative = new ArrayBuffer[Int]()
      val allArtistIDs = bAllArtistIDs.value
      var i = 0
      // Make at most one pass over all artists to avoid an infinite loop.
      // Also stop when number of negative equals positive set size
      while (i < allArtistIDs.length && negative.size < posItemIDSet.size) {
        val artistID = allArtistIDs(random.nextInt(allArtistIDs.length))
        // Only add new distinct IDs
        if (!posItemIDSet.contains(artistID)) {
          negative += artistID
        }
        i += 1
      }
      // Return the set with user ID added back
      negative.map(artistID => (userID, artistID))
    }.toDF("user", "artist")

  // Make predictions on the rest:
  val negativePredictions = predictFunction(negativeData).
    withColumnRenamed("prediction", "negativePrediction")

  // Join positive predictions to negative predictions by user, only.
  // This will result in a row for every possible pairing of positive and negative
  // predictions within each user.
  val joinedPredictions = positivePredictions.join(negativePredictions, "user").
    select("user", "positivePrediction", "negativePrediction").cache()

  // Count the number of pairs per user
  val allCounts = joinedPredictions.
    groupBy("user").agg(count(lit("1")).as("total")).
    select("user", "total")
  // Count the number of correctly ordered pairs per user
  val correctCounts = joinedPredictions.
    filter(col("positivePrediction") > col("negativePrediction")).
    groupBy("user").agg(count("user").as("correct")).
    select("user", "correct")

  // Combine these, compute their ratio, and average over all users
  val meanAUC = allCounts.join(correctCounts, "user").
    select(col("user"), (col("correct") / col("total")).as("auc")).
    agg(mean("auc")).
    as[Double].first()

  joinedPredictions.unpersist()

  meanAUC
}
