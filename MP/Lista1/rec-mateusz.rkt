#lang racket
;; wykorzystałem fragmenty kodu liczącego pierwiastek kwadratowy z wykładu

(define (dist x y)
  (abs (- x y)))

(define (square x)
  (* x x))

(define (cube x)
  (* x x x))
;; to są dość ogólne procedury, więc zostawiłem je poza cube-root

(define (cube-root x)
  (define (improve approx)
     (define (upper approx)
      (+ (* 2 approx) (/ x (square approx))))
    (/ (upper approx) 3))
   
  (define (good-enough? approx)
    (< (dist x (cube approx)) 0.00001))
  
  (define (iter approx)
    (cond
      [(good-enough? approx) approx]
      [else                  (iter (improve approx))]))
  
  (iter 1.0))
;;testy
(cube-root 27)
(cube-root 64)
(cube-root 0)
(cube-root 10000000400023)
(cube-root 0.0000000060001)