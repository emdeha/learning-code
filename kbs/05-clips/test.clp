;(deffacts init (data 1 red)
;               (data 1 red blue)
;               (data 1 red blue 0.9))

; (defrule find-data-1
;   (data $?x $?y)
; =>
;   (printout t "?x = " ?x crlf
;               "?y = " ?y crlf
;               "------" crlf)
; )

; (defrule pred
;   (data ?x&:(numberp ?x))
; =>
;   (printout t "number")
; )

; (defrule example
;   (data ?x)
;   (value ?y)
;   (test (>= (abs (- ?y ?x)) 3))
; =>
;   (printout t "Successful test" crlf)
; )

;(defrule read-input
;  (initial-fact)
;=>
;  (printout t "Name a color" crlf)
;  (assert (color (read)))
;)
;
;(defrule good-input
;  ?color <- (color ?color-read &red|blue|yellow)
;=>
;  (printout t "Correct" crlf)
;)
;
;(defrule bad-input
;  (color ?color not &red|blue|yellow)
;=>
;  (printout t "Incorrect" crlf)
;)

;(defrule test-readline
;  (initial-fact)
;=>
;  (printout t "Enter input" crlf)
;  (bind ?string (readline))
;  (assert-string (str-cat "(" ?string ")"))
;)

;(defrule rule1
;  (logical (a))
;  (logical (b))
;  (c)
;=>
;  (assert (g) (h))
;)
;
;(defrule rule2
;  (logical (d))
;  (logical (e))
;  (f)
;=>
;  (assert (g) (h))
;)

(deffunction print-args
  (?a ?b $?c)
  (printout t ?a " " ?b " and " (length ?c) " extras: " ?c crlf)
)

(deffunction factorial (?n)
  (if (or (not (integerp ?n)) (< ?n 0))
   then (printout t "Factorial must be a pos integer" crlf)
   else 
     (if (= ?n 0) then 1
        else (* ?n (factorial (- ?n 1)))
     )
  )
)

(defmethod +
  (($?any INTEGER
      (evenp ?current-argument)))
  (div (call-next-method) 2)
)
