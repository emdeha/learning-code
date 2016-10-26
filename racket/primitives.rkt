#lang racket

(define (at? a) (not (list? a)))

(define (lat? ls)
 (if (null? ls)
  #t
  (and (at? (car ls)) (lat? (cdr ls)))))
