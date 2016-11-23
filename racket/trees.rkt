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
