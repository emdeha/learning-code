/* TextProcApp.scala */
import org.apache.spark._
import org.apache.spark.streaming._
import scala.util.Try

object TextProcApp {
  def main(args: Array[String]) {
    val conf = new SparkConf().setMaster("local[2]").setAppName("TextProcApp")
    val ssc = new StreamingContext(conf, Seconds(1))

    val lines = ssc.socketTextStream("localhost", 1337)
    val numbers = lines.flatMap(_.split(" ")).map(n => Try(n.toInt)).filter(_.isSuccess).map(_.get)

    numbers.print()

    ssc.start()
    ssc.awaitTermination()
  }
}
