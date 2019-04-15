#lang racket
;; zadanie 11
(define (average x y)
  (/ (+ x y) 2))
(define (dec x)
  (- x 1))
(define (inc x)
  (+ x 1))
(define (identity x)
  x)
(define (compose f g)
  (lambda (x) (f (g x))))
(define (repeated p n)
  (if (= n 0)
      identity
      (compose p (repeated p (dec n)))))
(define (close-enough? x y)
  (< (abs (- x y)) 0.001))
(define (fixed-point f x0)
  (let ((x1 (f x0)))
    (if (close-enough? x0 x1)
        x0
        (fixed-point f x1))))
(define (average-damp f)
  (lambda (x) (average x (f x))))
(define (nth-root x n)
  (fixed-point ((repeated average-damp (good? n 5 1))(lambda (y) (/ x (nth-1 y n)))) 1.0))
(define (nth-1 x n) ;;potega n-1 stopnia do funkcji pierwiastka
  (if (= n 2)
      x
      (* x (nth-1 x (dec n)))))
(define (good? n x i) ;;okresla ilokrotne zlozenie funkcji ma wykonac average-damp
  (if (< n x)
      i
      (good? n (- (* 2 x) 1) (inc i))))
(nth-root 512 512)




























