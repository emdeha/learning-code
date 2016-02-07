(deffacts init (letter T) (letter W) (letter O) (letter F) (letter U) (letter R)
               (digit 0) (digit 1) (digit 2) (digit 3) (digit 4)
               (digit 5) (digit 6) (digit 7) (digit 8) (digit 9)
)


(defrule combineAll
  (letter ?l) (digit ?d)
=>
  (assert (possible ?l ?d))
)

(defrule solve
  (possible O ?o)
  (possible W ?w &~ ?o)
  (possible T ?t &~ ?o &~ ?w)
  (possible R ?r &~ ?t &~ ?o &~ ?w)
  (possible U ?u &~ ?r &~ ?t &~ ?o &~ ?w)
  (test (= (* 2 (+ (* ?t 100) (* ?w 10) ?o))
           (+ 1000 (* ?o 100) (* ?u 10) ?r))
  )
=>
  (printout t "T is " ?t crlf
            "W is " ?w crlf
            "O is " ?o crlf
            "F is " 1 crlf
            "U is " ?u crlf
            "R is " ?r crlf crlf)
)
