#lang racket
;;1
(define (make-rat n d)
  (list n d))
(define (rat-num x)
  (let ((g (gcd (car x) (car (cdr x)))))
     (/ (car x) g)))
(define (rat-den x)
  (let ((g (gcd (car x) (car (cdr x)))))
    (/ (car (cdr x)) g)))
(rat-num (make-rat 2 4))
(rat-den (make-rat 2 4))
;;2
(define (append xs ys)
  (if (null? xs)
      ys
      (cons (car xs) (append (cdr xs) ys))))
(append (list 1 2 3) (list 4 5 6))
 
