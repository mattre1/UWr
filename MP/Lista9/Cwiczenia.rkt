#lang racket

;; pomocnicza funkcja dla list tagowanych o określonej długości

(define (tagged-tuple? tag len p)
  (and (list? p)
       (= (length p) len)
       (eq? (car p) tag)))

(define (tagged-list? tag p)
  (and (pair? p)
       (eq? (car p) tag)
       (list? (cdr p))))

;;

(define (node l r)
  (list 'node l r))

(define (node? n)
  (tagged-tuple? 'node 3 n))

(define (node-left n)
  (second n))

(define (node-right n)
  (third n))

(define (leaf? n)
  (or (symbol? n)
      (number? n)
      (null? n)))

;;

(define (res-cons v s)
  (cons v s))

(define (res-val r)
  (car r))

(define (res-state r)
  (cdr r))

;;

(define (rename t)
  (define (rename-st t i)
    (cond [(leaf? t) (res-cons i (+ i 1))]
          [(node? t)
           (let* ([rl (rename-st (node-left t) i)]
                  [rr (rename-st (node-right t) (res-state rl))])
             (res-cons (node (res-val rl) (res-val rr))
                  (res-state rr)))]))
  (res-val (rename-st t 0)))

;;

(define (st-app f x y)
  (lambda (i)
    (let* ([rx (x i)]
           [ry (y (res-state rx))])
      (res-cons (f (res-val rx) (res-val ry))
           (res-state ry)))))

(define get-st
  (lambda (i)
    (res-cons i i)))

(define (modify-st f)
  (lambda (i)
    (res-cons null (f i))))

(define (rand-st max)
  (lambda (i)
    (res-cons null (res-val ((rand max) i)))))

;;

(define (inc n)
  (+ n 1))

(define (rename2 t)
  (define (rename-st t)
    (cond [(leaf? t)
           (st-app (lambda (x y) x)
                   get-st
                   (modify-st inc))]
          [(node? t)
           (st-app node
                   (rename-st (node-left  t))
                   (rename-st (node-right t)))]))
  (res-val ((rename-st t) 0)))

;; Cwiczenie 1

(define (args-calc args i)
  (if (null? args)
      (cons i null)
      (let ([x ((car args) i)])
        (cons (res-val x)
              (args-calc (cdr args) (res-state x))))))

(define (get-args-state e)
  (car (reverse e)))

(define (delete-args-state e)
  (if (null? (cdr e))
      null
      (cons (car e) (delete-args-state (cdr e)))))
      

(define (st-app-args f args)
  (lambda (i)
    (res-cons (apply f (delete-args-state (args-calc args i)))
                        (get-args-state (args-calc args i)))))

(define (rename3 t)
  (define (rename-st t)
    (cond [(leaf? t)
           (st-app-args (lambda (x y) x)
                   (list get-st (modify-st inc)))]
          [(node? t)
           (st-app-args node
                   (list (rename-st (node-left  t)) (rename-st (node-right t))))]))
  (res-val ((rename-st t) 0)))
              
(rename3 '(node (node (node g g) g) (node g g)))

;; rand-generator

(define (rand max)
  (lambda (i)
    (let ([v (modulo (+ (* 1103515245 i) 12345) (expt 2 32))])
      (res-cons (modulo v max) v))))

;; Cwiczenie 2

(define (rename-rand t)
  (define (rename-st t)
    (cond [(leaf? t)
           (st-app (lambda (x y) x)
                   get-st
                   (rand-st 100))]
          [(node? t)
           (st-app node
                   (rename-st (node-left  t))
                   (rename-st (node-right t)))]))
  (res-val ((rename-st t) 0)))

(rename-rand '(node (node 2 3) (node 4 5)))
(rename-rand '(node (node (node g g) g) (node g g)))


;; Cwiczenie 3








