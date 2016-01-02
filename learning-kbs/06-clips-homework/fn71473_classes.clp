; Sat Jan 02 12:14:32 EET 2016
; 
;+ (version "3.5")
;+ (build "Build 663")


(defclass %3ACLIPS_TOP_LEVEL_SLOT_CLASS "Fake class to save top-level slot information"
	(is-a USER)
	(role abstract)
	(single-slot free_time
;+		(comment "Represents the time a Working Student can spend each day for activities other than work and university.")
		(type INTEGER)
		(range 1 24)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot book-name
;+		(comment "Represents the name of a Book.")
		(type STRING)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot network_size
;+		(comment "Represents the number of people a Businessman knows and can rely on. Again, some businessmen may prefer not to share this information.")
		(type INTEGER)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot disco_time
;+		(comment "Represents the time spent partying each month in hours. Its maximum amount is 4 weeks * 168 hours a week.\n\nThe default value is based on an old chalga song. The lyrics go like this: 'Only 8 hours we study, only 8 hours we sleep, and the remaining 8 we go after girlfriends.' So, given 5 work days a week * 4 weeks * 8 hours of girlfriends = 160 hours for party.")
		(type INTEGER)
		(range 0 672)
		(default 160)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot count_exams
;+		(comment "The amount of exams a student has to take.")
		(type INTEGER)
		(range 0 %3FVARIABLE)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot worries
;+		(comment "Accumulated worries in worry/day.")
		(type INTEGER)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot genre
;+		(comment "Represents the genre of a Book.")
		(type SYMBOL)
		(allowed-values Fiction Science-Fiction Philosophy Classic Fairy-tale Biography Speech Self-help Horror Technical Exploration Romance Business-self-help Management)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot gender
;+		(comment "Represents the gender of a Person.")
		(type SYMBOL)
		(allowed-values M F)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot time-to-read
;+		(comment "Represents the time in hours needed to read a Book.")
		(type INTEGER)
		(range 1 %3FVARIABLE)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot time_spent_studying
;+		(comment "Represents the time in hours per day the student spends on studying.")
		(type INTEGER)
		(range 1 24)
		(default 8)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot year
;+		(comment "Represent the current year of studying the student attends.")
		(type INTEGER)
		(range 1 8)
		(default 1)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot debth
;+		(comment "Accumulated debth in dollars.")
		(type INTEGER)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot speech_skill
;+		(comment "Represents how good a student is at convincing people to do things for him.")
		(type FLOAT)
		(range 0.0 100.0)
		(default 20.0)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(multislot degree
;+		(comment "Represents the degree of a Student. A Student can pursue up to 3 degrees at the same time, because he can attend up to 3 universities.")
		(type SYMBOL)
		(allowed-values Masters Bachelor Doctor)
		(default Bachelor)
		(cardinality 1 3)
		(create-accessor read-write))
	(single-slot yearly-income
;+		(comment "Represents the money a Business earns each year. Some businessmen may prefer not to share this information.")
		(type INTEGER)
		(range 1 %3FVARIABLE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot difficulty
;+		(comment "Represents how difficult it is to read a Book in a 1 to 5 scale.")
		(type INTEGER)
		(range 1 5)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot type
;+		(comment "Represents the type of business a Businessman can have. It's not a problem for a Businessman to run multiple types of businesses.")
		(type SYMBOL)
		(allowed-values Investment Trading Psychology IT Manufacturing Architecture Banking)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(multislot university
;+		(comment "The university which a Student attends. A student can attend at most 3 universities at the same time.")
		(type SYMBOL)
		(allowed-values SU TU UNWE NBU)
		(cardinality 1 3)
		(create-accessor read-write))
	(single-slot age
;+		(comment "Represents the age of a Person.")
		(type INTEGER)
		(range 2 150)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot invested
;+		(comment "Represents money invested in the startup.")
		(type INTEGER)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot authenticity
;+		(comment "If the book is nonfiction, this represents how authentic and trustworthy is the content of the Book in a scale from 1 to 10.")
		(type INTEGER)
		(range 1 10)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(multislot business
;+		(comment "The businesses a Businessman has.")
		(type INSTANCE)
;+		(allowed-classes Business)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(single-slot yearly_income
;+		(comment "Represents the money a Businessman earns each year. Some businessmen may prefer not to share this information.")
		(type INTEGER)
		(range 1 %3FVARIABLE)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot name_
;+		(comment "The name of the Person.")
		(type STRING)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(multislot business_type
;+		(comment "Represents the type of business a Businessman can have. It's not a problem for a Businessman to run multiple types of businesses.")
		(type SYMBOL)
		(allowed-values Investment Trading Psychology IT Manufacturing Architecture Banking)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(multislot author
;+		(comment "Represents the name of the author of the Book. A book can have multiple authors.")
		(type STRING)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(single-slot money_per_month
;+		(comment "Represents the amount of money given to an Ordinary Student each month by his parents.")
		(type INTEGER)
		(range 1 %3FVARIABLE)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass Person "The class `Person` represents a human with basic properties like: `name`, `gender` and `age`."
	(is-a USER)
	(role abstract)
	(single-slot gender
;+		(comment "Represents the gender of a Person.")
		(type SYMBOL)
		(allowed-values M F)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot name_
;+		(comment "The name of the Person.")
		(type STRING)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot age
;+		(comment "Represents the age of a Person.")
		(type INTEGER)
		(range 2 150)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass Student "The Student is a Person who attends a specific `university`, pursues a specific `degree` and is in a `year` of studying."
	(is-a Person)
	(role concrete)
	(single-slot year
;+		(comment "Represent the current year of studying the student attends.")
		(type INTEGER)
		(range 1 8)
		(default 1)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(multislot university
;+		(comment "The university which a Student attends. A student can attend at most 3 universities at the same time.")
		(type SYMBOL)
		(allowed-values SU TU UNWE NBU)
		(cardinality 1 3)
		(create-accessor read-write))
	(multislot degree
;+		(comment "Represents the degree of a Student. A Student can pursue up to 3 degrees at the same time, because he can attend up to 3 universities.")
		(type SYMBOL)
		(allowed-values Masters Bachelor Doctor)
		(default Bachelor)
		(cardinality 1 3)
		(create-accessor read-write)))

(defclass Working "A Working Student has `free_time` in hours per day."
	(is-a Student)
	(role concrete)
	(single-slot free_time
;+		(comment "Represents the time a Working Student can spend each day for activities other than work and university.")
		(type INTEGER)
		(range 1 24)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass Ordinary "An Ordinary Student has `money` which is given to him each month by his parents and `disco_time` he spends partying."
	(is-a Student)
	(role concrete)
	(single-slot disco_time
;+		(comment "Represents the time spent partying each month in hours. Its maximum amount is 4 weeks * 168 hours a week.\n\nThe default value is based on an old chalga song. The lyrics go like this: 'Only 8 hours we study, only 8 hours we sleep, and the remaining 8 we go after girlfriends.' So, given 5 work days a week * 4 weeks * 8 hours of girlfriends = 160 hours for party.")
		(type INTEGER)
		(range 0 672)
		(default 160)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot money_per_month
;+		(comment "Represents the amount of money given to an Ordinary Student each month by his parents.")
		(type INTEGER)
		(range 1 %3FVARIABLE)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass Studying "A Studying Student has `time_spent_studying`."
	(is-a Ordinary)
	(role concrete)
	(single-slot time_spent_studying
;+		(comment "Represents the time in hours per day the student spends on studying.")
		(type INTEGER)
		(range 1 24)
		(default 8)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass NotStudying "A NotStudying Student has `count_exams` he has to take and `speech_skill` level which determines how good he is at convincing professors he has to pass."
	(is-a Ordinary)
	(role concrete)
	(single-slot speech_skill
;+		(comment "Represents how good a student is at convincing people to do things for him.")
		(type FLOAT)
		(range 0.0 100.0)
		(default 20.0)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot count_exams
;+		(comment "The amount of exams a student has to take.")
		(type INTEGER)
		(range 0 %3FVARIABLE)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass Businessman "Businessman is a Person who has a `business`, and the `network_size` of people he knows."
	(is-a Person)
	(role concrete)
	(single-slot network_size
;+		(comment "Represents the number of people a Businessman knows and can rely on. Again, some businessmen may prefer not to share this information.")
		(type INTEGER)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(multislot business
;+		(comment "The businesses a Businessman has.")
		(type INSTANCE)
;+		(allowed-classes Business)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write)))

(defclass StartupFounder "A StartupFounder is a Businessman who has founded a startup while being a Student. He has `invested` money in the founded startup.C"
	(is-a Student Businessman)
	(role concrete)
	(single-slot invested
;+		(comment "Represents money invested in the startup.")
		(type INTEGER)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass Poor "A Poor Person has only accumulated `debth` and accumulated `worries`. A person who has only `debth` or only `worries` is not considered poor."
	(is-a Person)
	(role concrete)
	(single-slot debth
;+		(comment "Accumulated debth in dollars.")
		(type INTEGER)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot worries
;+		(comment "Accumulated worries in worry/day.")
		(type INTEGER)
;+		(cardinality 1 1)
		(create-accessor read-write)))

(defclass Business "A Business has a `type` and an `yearly_income`."
	(is-a USER)
	(role concrete)
	(single-slot type
;+		(comment "Represents the type of business a Businessman can have. It's not a problem for a Businessman to run multiple types of businesses.")
		(type SYMBOL)
		(allowed-values Investment Trading Psychology IT Manufacturing Architecture Banking)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot yearly-income
;+		(comment "Represents the money a Business earns each year. Some businessmen may prefer not to share this information.")
		(type INTEGER)
		(range 1 %3FVARIABLE)
;+		(cardinality 0 1)
		(create-accessor read-write)))

(defclass Book "A Book is represented by its `name`, `author`, `genre`, `time-to-read`, `difficulty` and `authenticity`."
	(is-a USER)
	(role concrete)
	(single-slot difficulty
;+		(comment "Represents how difficult it is to read a Book in a 1 to 5 scale.")
		(type INTEGER)
		(range 1 5)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot authenticity
;+		(comment "If the book is nonfiction, this represents how authentic and trustworthy is the content of the Book in a scale from 1 to 10.")
		(type INTEGER)
		(range 1 10)
;+		(cardinality 0 1)
		(create-accessor read-write))
	(single-slot book-name
;+		(comment "Represents the name of a Book.")
		(type STRING)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(multislot author
;+		(comment "Represents the name of the author of the Book. A book can have multiple authors.")
		(type STRING)
		(cardinality 1 ?VARIABLE)
		(create-accessor read-write))
	(single-slot genre
;+		(comment "Represents the genre of a Book.")
		(type SYMBOL)
		(allowed-values Fiction Science-Fiction Philosophy Classic Fairy-tale Biography Speech Self-help Horror Technical Exploration Romance Business-self-help Management)
;+		(cardinality 1 1)
		(create-accessor read-write))
	(single-slot time-to-read
;+		(comment "Represents the time in hours needed to read a Book.")
		(type INTEGER)
		(range 1 %3FVARIABLE)
;+		(cardinality 1 1)
		(create-accessor read-write)))