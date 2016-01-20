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

;
; От тук почва програмата.
; Опитваме се да определим прости факти за човека, а също така и какъв е по
; професия - Бедняк, Бизнесмен или Студент.
(defrule determine-type
  (initial-fact)
=>
  (printout t "What's your name?" crlf)
  (assert (name (read)))

  (printout t "What's your age?" crlf)
  (bind ?age (read))
  (if (and (>= ?age 2) (<= ?age 150))
      then
      (assert (age ?age))
      else
      (printout t "Age must be between 2 and 150" crlf)
      (return))

  (printout t "What's your gender: M/F?" crlf)
  (bind ?g (read))
  (if (or (eq ?g M) (eq ?g F))
      then
      (assert (gender ?g))
      else
      (printout t "Gender must be either M or F" crlf)
      (return))

  (printout t "What's your current occupation: Poor/Businessman/Student?" crlf)
  (bind ?o (read))
  (if (or (eq ?o Businessman) (eq ?o Poor) (eq ?o Student))
      then 
      (assert (occupation ?o))
      else
      (printout t "Occupation must be either Poor/Businessman/Student" crlf)
      (return))

  (assert (type-determined))
)

;
; Следващите правила препоръчват книга на бизнесмен.
;
; Това правило дохарактеризира бизнесмен.
(defrule determine-business
  (occupation Businessman)
  ?td <- (type-determined)
=>
  (printout t "Business determined." crlf)
  (retract ?td)
  (assert (business-determined))
)

; Това правило проверява данните от характеристиката на бизнесмен.
(defrule check-input-business
  ?bd <- (business-determined)
=>
  (printout t "Business input checked." crlf)
  (retract ?bd)
  (assert (suggest-book))
)

;
; Следващите правила препоръчват книга на студент.
;
; Това правило дохарактеризира студент.
(defrule determine-student
  (occupation Student)
  ?td <- (type-determined)
=>
  (retract ?td)
  (assert (student-determined))
)

(defrule check-input-student
  (student-determined)
=>
  (retract student-determined)
  (assert (suggest-book))
)

;
; Следващите правила препоръчват книга на бедняк.
;
; Това правило характеризира бедняк.
(defrule determine-poor
  (occupation Poor)
  ?td <- (type-determined)
=>
  (printout t "How many worries do you have?" crlf)
  (bind ?w (read))
  (if (numberp ?w)
      then
      (assert (worries ?w))
      else
      (printout t "Worries must be a number" crlf)
      (return))

  (printout t "How much debth do you have?" crlf)
  (bind ?d (read))
  (if (numberp ?d)
      then
      (assert (debth ?d)) 
      else
      (printout t "Debth must be a number" crlf)
      (return))

  (retract ?td)
  (assert (poor-determined))
)

; Това правило проверява входа от характеризацията на бедняка.
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

; Тази функция определя евристиката за препоръчване на книга на бедняк.
(deffunction poor-query (?b ?debth ?worries)
  (bind ?authenticity (send ?b get-authenticity))
  (bind ?difficulty (send ?b get-difficulty))
  (bind ?timeToRead (send ?b get-time-to-read))

  (and (<= ?timeToRead ?worries) 
       (<= (/ ?debth 1000) (* ?authenticity ?difficulty))
  )
)

; Това правило препоръчва книга на бедняк.
(defrule determine-book-poor
  ?sb <- (suggest-book)
  (poor p)
=>
  (bind ?books (find-all-instances ((?b Book)) 
    (poor-query ?b (send [p] get-debth) (send [p] get-worries))))
  (bind ?n (random 1 (length ?books)))

  (printout t "Possible books: " (length ?books) crlf)
  (send (nth$ ?n ?books) print)
)
