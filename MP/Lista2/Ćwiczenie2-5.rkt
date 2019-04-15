#lang racket
;;ogólne 
(define (compose f g)
  (lambda (x) (f (g x))))
(define (square x)
  (* x x))
(define (inc x)
  (+ x 1))
(define (dec x)
  (- x 1))
(define (identity x)
  x)
(define (prod x y)
  (* x y))
;; Cwiczenie 3
(define (repeated p n)
  (if (= n 0)
      identity
      (if (= n 1)
          p
          (compose p (repeated p (dec n))))))
;; Cwiczenie 4
;; recursion
(define (t x)
  (* (/ x (+ x 1)) (/ (+ x 2) (+ x 1))))
(define (product term next a b)
  (if (> a b)
      1
      (* (term a) (product term next (next a) b))))
(product square (lambda (x) (+ x 2)) 1 4)
;; iter
(define (product2 term next a b)
  (define (product-iter term next a b res)
  (if (> a b)
      res
      (product-iter term next (next a) b (* res (term a)))))
  (product-iter term next a b 1))
(* (product t (lambda (x) (+ x 2)) 2.0 10000) 4)
(* (product2 t (lambda (x) (+ x 2)) 2.0 10000) 4)
;; sum
;; recursion
(define (sum term next a b)
  (if (> a b)
      0
      (+ (term a) (sum term next (next a) b))))
;; iter
(define (sum2 term next a b)
  (define (sum-iter term next a b res)
    (if (> a b)
        res
        (sum-iter term next (next a) b (+ res (term a)))))
  (sum-iter term next a b 0))
(sum square (lambda (x) (+ x 2)) 1 4)
(sum2 square (lambda (x) (+ x 2)) 1 4)

;; Cwiczenie 5
;; recursion
(define (accumulate combiner null-value term next a b)
  (if (> a b)
      null-value
      (combiner (term a) (accumulate combiner null-value term next (next a) b))))
;; iter
(define (accumulate-iter combiner null-value term next a b)
  (if (> a b)
      null-value
      (accumulate-iter combiner (combiner null-value (term a)) term next (next a) b)))
(accumulate (lambda (a b) (+ a b)) 0 square (lambda (x) (+ x 2)) 1 4) ;; 1+9
(* (accumulate-iter (lambda (a b) (* a b)) 1 t (lambda (x) (+ x 2)) 2.0 10000) 4) ;; PI
;; Cwiczenie 6
;; iter
;(define (cont-frac-iter num den k)
  ;(define (cont-frac2 num den i k res)
    ;(if (= i k)
      ;  (/ (num (- (* i 2) 1)) (den (- (* i 2) 1)))
      ;  (/ (num (- (* i 2) 1)) (+ (den (- (* i 2) 1)) (cont-frac2 num den (+ i 1) k )))))
 ; (cont-frac2 num den 1 k))
;( cont-frac-iter ( lambda ( i ) 1.0) ( lambda ( i ) 1.0) 100 ) ;; złoty podział
;; recursion
(define (cont-frac num den i k)
  (if (= k 0)
      0
      (/ (num (- (* i 2) 1)) (+ (den (- (* i 2) 1)) (cont-frac num den (+ i 1) (- k 1))))))
(cont-frac ( lambda ( i ) 1.0) ( lambda ( i ) 1.0) 1 100)
;; Cwiczenie 7
;; recursion
(+ (cont-frac ( lambda ( i ) (square i)) ( lambda ( i ) 6.0) 1 100) 3)
;; iter
;(+ (cont-frac-iter ( lambda ( i ) (square i)) ( lambda ( i ) 6.0) 100) 3)
;; Cwiczenie 8
;;Cwiczenie 9
(define (build n d b)
  (/ n (+ d b)))
(build 4.0 2 (build 4 2 2))



      
      





   