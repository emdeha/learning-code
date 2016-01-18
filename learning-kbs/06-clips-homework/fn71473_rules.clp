; NOT-INCLUDE: Written in Bulgarian in order to generate the docs more easily.
;
; Следната система основана на знания има за цел да препоръчва книги на 
; определени типове хора.  Хората могат да са в три категории - бизнесмени,
; студенти или бедняци.  Всеки човек се определя от някакви полезни за него
; характеристики, на базата на които се прави заключение за това каква книга 
; би му била полезна.  Нормално е за някой тип хора, например студентите, 
; които не учат и ходят твърде често на партита, системата да не може да
; препоръча книга.  В крайна сметка, това не би направило щастливи този тип
; хора.
;
; Препоръката на книга ще става на базата на следните правила:
; \begin{itemize}
;   \item determine-type - определя типа на човека; оттук стартираме
;   \item determine-business - доспецифицира бизнес човек
;   \item determine-student - доспецифицира студент
;   \item determine-poor - доспецифицира бедняк
;   \item determine-book - на базата на информацията от предишните правила, препоръчва книга
; \end{itemize}
;

(defrule determine-type
  (initial-fact)
=>
  (printout t "What's your name?" crlf)
  (assert (name (read)))
  (printout t "What's your age?" crlf)
  (assert (age (read)))
  (printout t "What's your gender: M/F?" crlf)
  (assert (gender (read)))
  (printout t "What's your current occupation: Poor/Businessman/Student?" crlf)
  (assert (occupation (read)))
  (assert (type-determined))
)

(defrule check-input-type
  ?td <- (type-determined)
  (age ?age)
  (gender ?g)
  (occupation ?o)
  (test (and (>= ?age 2) (<= ?age 150)))
  (test (or (eq ?g M) (eq ?g F)))
  (test (or (eq ?o Businessman) (eq ?o Poor) (eq ?o Student)))
=>
  (printout t "Input checked." crlf)
  (retract ?td)
  (assert (type-checked))
)

(defrule determine-business
  (occupation Businessman)
  ?tc <- (type-checked)
=>
  (printout t "Business determined." crlf)
  (retract ?tc)
  (assert (business-determined))
)

(defrule check-input-business
  ?bd <- (business-determined)
=>
  (printout t "Business input checked." crlf)
  (retract ?bd)
  (assert (suggest-book))
)

; (defrule determine-student
;   (occupation Student)
;   (type-checked)
; =>
;   (retract type-checked)
;   (assert student-determined)
; )
; 
; (defrule check-input-student
;   (student-determined)
; =>
;   (retract student-determined)
;   (assert suggest-book)
; )
; 
(defrule determine-poor
  (occupation Poor)
  ?tc <- (type-checked)
=>
  (printout t "How many worries do you have?" crlf)
  (assert (worries (read)))
  (printout t "How much debth do you have?" crlf)
  (assert (debth (read)))

  (retract ?tc)
  (assert (poor-determined))
)

(defrule check-input-poor
  ?pd <- (poor-determined)
  (worries ?w & :(numberp ?w))
  (debth ?d & :(numberp ?d))
  (age ?age)
  (gender ?g)
  (occupation ?o)
  (name ?n)
=>
  (make-instance p of Poor
    (age ?age)
    (debth ?d)
    (gender ?g)
    (name_ ?n)
    (worries ?w))
  (assert (poor p))

  (printout t "Poor input checked." crlf)

  (retract ?pd)
  (assert (suggest-book))
)

(defrule determine-book-poor
  ?sb <- (suggest-book)
  (poor ?p)
=>
  (do-for-instance ((?b Book)) 
   (numberp 1)
   (progn (printout t "Book suggested." crlf) (send ?b print)))
)

; (deffunction poor-query (?b ?debth ?worries)
;   
; )
