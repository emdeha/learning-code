#lang racket

; A graph defined as a list of neighbours
(define G
 '((1 2 3)
   (2 4)
   (3 5)
   (4)
   (5 1 6)
   (6)))

(define (vertices g)
 (map car g))

(define (neighbours g v)
 (cdar (filter (lambda (e) (= (car e) v)) g)))

(define (neighbours-assoc g v) (cdr (assoc v G)))

(define (edges g)
 (append (map (lambda (a) (map ((curry cons) (car a)) (cdr a))) g)))
