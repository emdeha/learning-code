#lang racket

(define (prod init a b)
 (define (prod-step i res)
  (if (> i b) res
   (prod-step (+ i 1) (* res i))))
 (prod-step a init))

(define (go sub #:mode mode)
 (display "going with\n")
 (display sub)
 (display mode))
