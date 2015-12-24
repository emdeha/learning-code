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

(defrule example
  (data ?x)
  (value ?y)
  (test (>= (abs (- ?y ?x)) 3))
=>
  (printout t "Successful test" crlf)
)
