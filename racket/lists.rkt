#lang racket

(define (list-digits n)
 (define (helper n ls)
   (cond ((= n 0) ls)
         (else (helper (quotient n 10) (cons (remainder n 10) ls)))))
 (helper n '()))

(define (any? pred? ls)
 (if (null? ls) #f
     (or (pred? (car ls)) (any? pred? (cdr ls)))))

(define (all? pred? ls)
 (if (null? ls) #t
     (and (pred? (car ls)) (all? pred? (cdr ls)))))

(define (list-length . lists)
 (map length lists))
 
(define (nmap . fns)
 (lambda (ls) (map (lambda (x) (foldl (lambda (f acc) (f acc)) x fns)) ls)))

(define (zip l1 l2)
 (cond ((null? l1) '())
       ((null? l2) '())
       (else (cons (cons (car l1) (car l2)) (zip (cdr l1) (cdr l2))))))

; List - inductive definition
; '()              is a list
; cons <atom> <list>  is a list

(define (insertion-sort l)
 (define (insert x ls)
  (cond ((null? ls) (list x))
        ((< x (car ls)) (cons x ls))
        (else (cons (car ls) (insert x (cdr ls))))))
 (if (null? l) '()
     (insert (car l) (insertion-sort (cdr l)))))
