#lang racket

;; lazy env

(define (add-to-lazy-env var val env)
  (cons (list 'lazy var val) env))

(define (lazy-def? e)
  (tagged-tuple? 'lazy 3 e))

(define (lazy-def-var e)
  (cadr e))

(define (lazy-def-val e)
  (caddr e))

;; pomocnicza funkcja dla list tagowanych o określonej długości

(define (tagged-tuple? tag len p)
  (and (list? p)
       (= (length p) len)
       (eq? (car p) tag)))

(define (tagged-list? tag p)
  (and (pair? p)
       (eq? (car p) tag)
       (list? (cdr p))))