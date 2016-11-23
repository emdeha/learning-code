#lang racket

(define empty-tree? null?)
(define root car)
(define left cadr)
(define right caddr)

(define (make-tree root left right)
 (list root left right))

(define test-tree (make-tree 0
                   (make-tree 1
                    (make-tree 2
                     (make-tree 3 '() '())
                     (make-tree 4 '() '()))
                    (make-tree 2
                     (make-tree 5 '() '())
                     '()))
                   '()))

(define (sum-tree tree)
 (cond
    ((empty-tree? tree) 0)
    (else (+ (root tree)
           (sum-tree (left tree))
           (sum-tree (right tree))))))

(define (level tree l)
 (define (helper c curr-level)
  (cond
   ((empty-tree? curr-level) '())
   ((= c l) (list (root curr-level)))
   (else (append (helper (+ c 1) (left curr-level)) (helper (+ c 1) (right curr-level))))))
 (helper 0 tree))

(define (map-tree f tree)
 (cond
  ((null? tree) '())
   (else (make-tree (f (root tree))
            (map-tree f (left tree))
            (map-tree f (right tree))))))

(define (fold-tree f init tree)
 (cond
  ((empty-tree? tree) init)
   (else (f (root tree) (fold-tree f init (left tree)) (fold-tree f init (right tree))))))

;
; Scheme interpreter for arithmetic expressions
(define expr1 '(2 + 3))
(define expr2 '((7 + 4) - (2 * 3)))
(define expr3 '(1 - (2 * 6)))
(define expr4 '((3 * 4) - 2))

(define (build-tree expr)
 (cond
  ((not (list? expr)) expr)
  (else
   (let ([l-op (car expr)]
         [r-op (caddr expr)]
         [op (cadr expr)])
     (make-tree op (build-tree l-op) (build-tree r-op))))))

(define (eval-tree expr-tree)
 (cond
  ((number? expr-tree) expr-tree)
  (else
   (let ([l-op (left expr-tree)]
         [r-op (right expr-tree)]
         [op (eval (root expr-tree))])
     (op (eval-tree l-op) (eval-tree r-op))))))
