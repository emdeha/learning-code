; Removes the first occurence of the atom a in the list lat
(define (rember a lat)
 (cond
  ((null? lat) lat)                                                                                 
  ((eq? a (car lat)) (cdr lat))
  (else (cons (car lat) (rember a (cdr lat)))))

; Gets the first elements from each list in the list of lists
(define (firsts ls)
 (cond
  ((null? ls) '())
  ((null? (car ls)) '())
  (else (cons (car (car ls)) (first (cdr ls))))))
