#lang racket

(define (member? x ls)
 (if (list? (member x ls)) #t #f))

(define (f-members f ls)
 (filter (lambda (x) (member? (f x) ls)) ls))

(define test-tree '(10 (8 (6 () ()) (9 () ())) (20 () ())))

(define (left tree) (cadr tree))
(define (right tree) (caddr tree))
(define (root tree) (car tree))

(define (insert t x)
 (cond ((null? (left t)) (cons (root t) (list (list x '() '()) (right t))))
       ((null? (right t)) (cons (root t) (list (left t) (list x '() '()))))
       ((< x (root t)) (cons (root t) (list (insert (left t) x) (right t))))
       (else (cons (root t) (list (left t) (insert (right t) x))))))

(define test-graph '(
 (1 2)
 (3 2)
 (2 1 3)
 (5 4 6 7)))

(define (vertices g) (map car g))

(define (find-odd-g g)
 (vertices (filter (lambda (v) (odd? (length (cdr v)))) g)))
