#lang racket
;; zadanie 10
(define (square x)
  (* x x))
(define (close-enough?  f g)
  (< (/ (abs (- f g)) f) 0.0001)) ;; g to następne przybliżenie f sprawdzamy czy jest już dostatecznie bliskie
(define (A num den A-2 A-1 n)
  (+ (* (den n) A-1) (* (num n) A-2)))
(define (B num den B-2 B-1 n)
  (+ (* (den n) B-1) (* (num n) B-2))) ;; wyznacza obecne An i Bn
(define (next-function num den A-2 A-1 B-2 B-1 n)
  (/ (A num den A-1 (A num den A-2 A-1 n) (+ n 1)) (B num den B-1 (B num den B-2 B-1 n) (+ n 1))))
(define (f-iter num den A-2 A-1 B-2 B-1 n f)
  (if (close-enough? f (next-function num den A-2 A-1 B-2 B-1 n))
      f
      (f-iter num den A-1 (A num den A-2 A-1 n) B-1 (B num den B-2 B-1 n) (+ n 1) (next-function num den A-2 A-1 B-2 B-1 n)))) ;; następna iteracja zwiększamy n o 1 zmieniamy A-2 A-1, B-2 B-1 liczymy następny f
(+ (f-iter (lambda (x) (square (- (* 2 x) 1))) (lambda (x) 6.0) 1 0 0 1 1 (/ (* ((lambda (x) (square x)) 1) 1) (* ((lambda (x) 6.0) 1) 1))) 3)  ;; zaczynamy zawsze od n=1 liczy PI 
(f-iter (lambda (x) 1.0) (lambda (x) 1.0) 1 0 0 1 1 1) ;; złoty podział
(f-iter (lambda (x) (square (* x 2.0))) (lambda (x) (- (* 2.0 x) 1)) 1 0 0 1 1 4) ;; arctan 2