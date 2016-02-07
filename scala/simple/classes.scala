class Dog(br: String) {
  var breed: String = br

  def bark = "Woof, woof!"

  private def sleep(hours: Int) = 
    println(s"I'm sleeping for $hours hours")
}

val myDog = new Dog("greyhound")
println(myDog.breed)
println(myDog.bark)

case class Person(name: String, phoneNumber: String)

val george = Person("George", "1234")
val kate = Person("Kate", "1235")
val valen = Person("Valen", "345")


println(george == kate)

def personMatch(person: Person): String = person match {
  case Person("George", number) => "We found George: " + number
  case Person("Kate", number) => "We found Kate: " + number
  case Person(name, number) => "We found " + name + ": " + number
}

println(personMatch(george))
println(personMatch(valen))
