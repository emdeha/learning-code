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

  def holt(data: RDD[Int], alpha: Double, beta: Double): DataFrame = {
    val sqlCtx = SQLContext.getOrCreate(data.sparkContext)
    import sqlCtx.implicits._

    val holtDF = data.toDF("numbers")
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
