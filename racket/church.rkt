#lang racket


(define (cprint cn)
 ((cn (lambda (x) (+ x 1))) 0))

(define (repeat n f x)
 (if (eq? n 0)
  x
  (f (repeat (- n 1) f x))))


(define (c n)
 (lambda (f)
  (lambda (x) (repeat n f x))))

(define (cSucc cn)
 (lambda (f)
  (lambda (x)
   (f ((cn f) x)))))

(define (cPlus cn)
 (lambda (cm)
  (lambda (f)
   (lambda (x)
    ((cm f) ((cn f) x))))))

(define (cMult cn)
 (lambda (cm)
  (lambda (f)
   (lambda (x)
    ((cm (cn f)) x)))))

(define (cExp cn)
 (lambda (cm)
  (lambda (f)
   (lambda (x)
    (((cn cm) f) x)))))
