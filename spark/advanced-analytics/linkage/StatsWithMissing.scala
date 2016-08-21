import org.apache.spark.util.StatCounter
import org.apache.spark.rdd.RDD

class NAStatCounter extends StatCounter {
  val stats: StatCounter = new StatCounter()
  var missing: Long = 0

  def add(x: Double): NAStatCounter = {
    if (java.lang.Double.isNaN(x)) {
      missing += 1
    } else {
      stats.merge(x)
    }
    this
  }

  def merge(other: NAStatCounter): NAStatCounter = {
    stats.merge(other.stats)
    missing += other.missing
    this
  }

  override def toString = {
    "stats: " + stats.toString + " NaN: " + missing
  }
}

object NAStatCounter extends Serializable {
  def apply(x: Double) = new NAStatCounter().add(x)
}

def statsWithMissing(rdd: RDD[Array[Double]]): Array[NAStatCounter] = {
  val nastats = rdd.mapPartitions((iter: Iterator[Array[Double]]) => {
    val nas: Array[NAStatCounter] = iter.next().map(d => NAStatCounter(d))
    iter.foreach(arr => {
      nas.zip(arr).foreach { case (n, d) => n.add(d) }
    })
    Iterator(nas)
  })
  nastats.reduce((n1, n2) => {
    n1.zip(n2).map { case (a, b) => a.merge(b) }
  })
}

case class MatchData(id1: Int, id2: Int, scores: Array[Double], matched: Boolean)

def toDouble(s: String) = {
  if ("?".equals(s)) Double.NaN else s.toDouble
}

def isHeader(line: String) = {
  line.contains("id_1")
}

def parse(line: String) = {
  val pieces = line.split(',')
  val id1 = pieces(0).toInt
  val id2 = pieces(1).toInt
  val scores = pieces.slice(2, 11).map(toDouble)
  val matched = pieces(11).toBoolean
  MatchData(id1, id2, scores, matched)
}

def naz(d: Double) = if (Double.NaN.equals(d)) 0.0 else d

case class Scored(md: MatchData, score: Double)

def score(parsed: RDD[MatchData]) = {
  parsed.map(md => {
    val score = Array(2, 5, 6, 7, 8).map(i => naz(md.scores(i))).sum
    Scored(md, score)
  })
}
