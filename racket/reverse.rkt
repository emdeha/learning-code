#lang racket

(define (count-digits n)
 (if (< n 10) 1
  (+ 1 (count-digits (quotient n 10)))))

(define (sum-digits n)
 (if (< n 10) n
  (+ (remainder n 10) (sum-digits (quotient n 10)))))

(define (reverse-number n)
 (if (< n 10) n
  (+ (* (remainder n 10) (expt 10 (- (count-digits n) 1))) (reverse-number (quotient n 10)))))
