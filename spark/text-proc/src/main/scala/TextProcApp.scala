/* TextProcApp.scala */
import org.apache.spark._
import org.apache.spark.rdd._
import org.apache.spark.streaming._
import org.apache.spark.streaming.dstream._
import org.apache.spark.sql._
import scala.util.Try

object TextProcApp {
  val hwAlpha = 0.26
  val hwBeta = 0.19

  def holtWintersGrowth(y: Array[Row], alpha: Double, beta: Double): (Array[Double], Array[Double]) = {
    val n = y.length
    val alphac = 1 - alpha
    val betac = 1 - beta
    val l = Array.fill(n)(0.0)
    l(0) = y(0).getDouble(0)
    val b = Array.fill(n)(0.0)
    b(0) = y(1).getDouble(0) - y(0).getDouble(0)

    for (i <- 1 to n) {
      l(i) = (alpha * y(i).getDouble(0)) * (alphac * (l(i-1) + b(i-1)))
      val ldelta = l(i) - l(i-1)
      b(i) = (beta * ldelta) + (betac * b(i-1))
    }

    return (l, b)
  }

  def holt(data: RDD[Int], alpha: Double, beta: Double): DataFrame = {
    val sqlCtx = SQLContext.getOrCreate(data.sparkContext)
    import sqlCtx.implicits._

    val holtDF = data.toDF("numbers", "Level", "Growth")
    val y = holtDF.collect()
    val (l, b) = holtWintersGrowth(y, alpha, beta)
    holtDF.withColumn("Level", l)
    holtDF.withColumn("Growth", b)
    return holtDF
  }

  def main(args: Array[String]) {
    val conf = new SparkConf().setMaster("local[2]").setAppName("TextProcApp")
    val ssc = new StreamingContext(conf, Seconds(10))

    val lines = ssc.socketTextStream("localhost", 1337)
    val numbers = lines.flatMap(_.split(" ")).map(n => Try(n.toInt)).filter(_.isSuccess).map(_.get)
    numbers.foreachRDD { rdd =>
      val holtDF = holt(rdd, hwAlpha, hwBeta)

      holtDF.show()
    }

    ssc.start()
    ssc.awaitTermination()
  }
}
