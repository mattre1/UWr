#lang racket
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
;; Cwiczenie 3
(define (make-vect point-begin rel-dir length)
  (cons point-begin (cons rel-dir length)))
(define (vect-begin v)
  (car v))
(define (vect-rel-dir v)
  (cdr v))
(define (make-point x y)
  (cons x y))
(define (vect-length v)
  (cdr (cdr v)))
(define (vect-scale v k)
  ((vect-begin v) (vect-rel-dir v) (* (vect-length v) k)))
(define (vect-translate v p)
  ( p (vect-rel-dir v) (vect-length v)))
;; Cwiczenie 4
;;recursion
(define (append lis1 lis2)
  (if (null? lis1)
      lis2
      (cons (car lis1) (append (cdr lis1) lis2))))
(append (list 1 2 3) (list 4 5 6))
(define (reverse-list seq)
  (if (null? seq)
      null
      (append (reverse-list (cdr seq)) (list (car seq)))))
(reverse-list (list 1 2 3 4 5))
;; iter
(define (reverse-list-iter seq)
  (define (reverse2 seq res)
    (if (null? seq)
        res
        (reverse2 (cdr seq) (cons (car seq) res))))
  (reverse2 seq null))
(reverse-list-iter (list 1 2 3 4 5))
;; Cwiczenie 5
(define (insert xs x);; wstawianie elementu do posortowanego ciągu na odpowiednie miejsce
  (if (null? xs)
      (append xs (list x))
      (if (< x (car xs))
          (append (list x) xs)
          (cons (car xs) (insert (cdr xs) x)))))
(insert (list 1 2 4 45) 3)
(define (insertion-sort xs)
  (define (sort xs res)
    (if (null? xs)
        res
        (sort (cdr xs) (insert res (car xs)))))
  (sort xs null))
(insertion-sort (list 12 4 8 9 1))
;; Cwiczenie 6
(define (length-list xs)
  (if (null? xs)
      0
      (+ 1 (length-list (cdr xs)))))
(define (insert-n x xs n) ;; wstawia x na n-te miejsce w liście xs
  (if (= n 0)
      (cons x xs)
      (cons (car xs) (insert-n x (cdr xs) (- n 1)))))
(define (map x f xs) ;; zwraca liste z elementami xs wyliczonymi w f
  (if (null? xs)
      '()
      (append (f (car xs) x) (map x f (cdr xs)))))
(define (insert2 x xs n) ;; zwraca liste list z x wstawionym na kazde miejsce
  (if (= n (+ (length-list xs) 1))
      '()
      (cons (insert-n x xs n) (insert2 x xs (+ n 1)))))
(define (permi xs)
  (if (null? xs)
      '(())
      (map (car xs) (lambda (xs x) (insert2 x xs 0)) (permi (cdr xs))))) ;;jak zrobic mapa bez przekazywania x do wstawienia insertowi???

(permi (list 1 2 3 4))















