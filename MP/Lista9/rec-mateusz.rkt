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
;; WHILE
;;

; memory

(define empty-mem
  null)

(define (set-mem x v m)
  (cond [(null? m)
         (list (cons x v))]
        [(eq? x (caar m))
         (cons (cons x v) (cdr m))]
        [else
         (cons (car m) (set-mem x v (cdr m)))]))

(define (get-mem x m)
  (cond [(null? m) 0]
        [(eq? x (caar m)) (cdar m)]
        [else (get-mem x (cdr m))]))

; arith and bool expressions: syntax and semantics

(define (const? t)
  (number? t))

(define (true? t)
  (eq? t 'true))

(define (false? t)
  (eq? t 'false))

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * / = > >= < <= not and or mod rand expt))))

(define (op-op e)
  (car e))

(define (op-args e)
  (cdr e))

(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]
        [(eq? op '=) =]
        [(eq? op '>) >]
        [(eq? op '>=) >=]
        [(eq? op '<)  <]
        [(eq? op '<=) <=]
        [(eq? op 'not) not]
        [(eq? op 'and) (lambda x (andmap identity x))]
        [(eq? op 'or) (lambda x (ormap identity x))]
        [(eq? op 'mod) modulo]
        [(eq? op 'rand) (lambda (max) (rand max))]
        [(eq? op 'expt) expt]))

(define (var? t)
  (symbol? t))

(define (eval-arith e m)
  (cond [(true? e) true]
        [(false? e) false]
        [(var? e) (get-mem e m)]
        [(op? e)
         (apply
           (op->proc (op-op e))
           (map (lambda (x) (eval-arith x m))
                (op-args e)))]
        [(const? e) e]))

;; syntax of commands

(define (assign? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (second t) ':=)))

(define (assign-var e)
  (first e))

(define (assign-expr e)
  (third e))

(define (assign-cons var expr)
  (list var ':= expr))

(define (if? t)
  (tagged-tuple? 'if 4 t))

(define (if-cond e)
  (second e))

(define (if-then e)
  (third e))

(define (if-else e)
  (fourth e))

(define (while? t)
  (tagged-tuple? 'while 3 t))

(define (while-cond t)
  (second t))

(define (while-expr t)
  (third t))

(define (block? t)
  (list? t))

(define (inc? e)
  (and (list? e)
       (= (length e) 2)
       (symbol? (first e))
       (eq? '++ (second e))))

(define (dec? e)
  (and (list? e)
       (= (length e) 2)
       (symbol? (first e))
       (eq? '-- (second e))))

(define (inc-var e)
  (car e))

(define (dec-var e)
  (car e))

;; state

(define (res v s)
  (cons v s))

(define (res-val r)
  (car r))

(define (res-state r)
  (cdr r))

;; psedo-random generator

(define (initial-seed)
  (exact-round (current-inexact-milliseconds)))

(define (rand max)
  (lambda (i)
    (let ([v (modulo (+ (* 1103515245 i) 12345) (expt 2 32))])
      (res (modulo v max) v))))

;; WHILE interpreter

(define (eval e m)
  (cond [(assign? e)
         (let [(r (eval-arith (assign-expr e) m))]
              (cond [(or (number?  r)
                         (boolean? r))
                     (set-mem (assign-var e) r m)]
                    [else (let [(res (r (get-mem 'seed m)))]
                               (eval (assign-cons 'seed
                                                  (res-state res))
                                     (set-mem (assign-var e)
                                              (res-val res)
                                               m)))]))]
        [(if? e)
         (if (eval-arith (if-cond e) m)
             (eval (if-then e) m)
             (eval (if-else e) m))]
        [(while? e)
         (if (eval-arith (while-cond e) m)
             (eval e (eval (while-expr e) m))
             m)]
        [(inc? e)
         (let [(val (get-mem (inc-var e) m))]
           (set-mem (inc-var e)
                    (+ val 1)
                    m))]
        [(dec? e)
         (let [(val (get-mem (inc-var e) m))]
           (set-mem (inc-var e)
                    (- val 1)
                    m))]  
        [(block? e)
         (if (null? e)
             m
             (eval (cdr e) (eval (car e) m)))]))

(define (run e)
  (eval e (set-mem 'seed (initial-seed) empty-mem)))

;; primary test

(define fermat-test
  '( (composite := false)
     (while (> k 0)
       ( (r := (rand (- n 1)))
         (a := (+ r 1))
         (if (= (mod (expt a (- n 1)) n)
                (mod 1 n))
             (k --)
             ( (k := 0)
               (composite := true)))))))

; check if a number n is prime using
; k iterations of Fermat's primality test
(define (probably-prime? n k) 
  (let ([memory (set-mem 'k k
                (set-mem 'n n
                (set-mem 'seed (initial-seed) empty-mem)))])
    (get-mem
       'composite
       (eval fermat-test memory))))

;; tests

;; A

;; primes

(define new-line "\n")

(display "PRIMES: ")
(display new-line)

(probably-prime? 2 10)
(probably-prime? 3 10)
(probably-prime? 23 10)
(probably-prime? 577 100)
(probably-prime? 17 10)
(probably-prime? 97 50)
(probably-prime? 1699 500)
(probably-prime? 17389 500)
(probably-prime? 16369 500)
(probably-prime? 13499 500)
(probably-prime? 15233 500)
(probably-prime? 9533 500)
(probably-prime? 8693 500)

(display new-line)
(display "NOT PRIMES: ")
(display new-line)

(probably-prime? 4 10)
(probably-prime? 15 10)
(probably-prime? 98 10)
(probably-prime? 16577 500)
(probably-prime? 18222 500)
(probably-prime? 8777 500)
(probably-prime? 1314 500)
(probably-prime? 3838 500)
(probably-prime? 9999 500)
(probably-prime? 222222 500)

(display new-line)

;; B

(display "1: ")
(run '(x := (rand 200)))

(display "2: ")
(run '(x := (rand 200)))

(display "3: ")
(run '(x := (rand 200)))

(display "4: ")
(run '(x := (rand 200)))

(display "5: ")
(run '(x := (rand 200)))

(display "6: ")
(run '( (x := (rand 1000))
        (if (< x 500)
            (res := true)
            (res := false))))

;; if eval wouldn't generate and transfer new seed correctly
;; sometimes (exactly when (rand 1000) returns value bigger than 500)
;; program could fall infinite loop
(display "7: ")
(run '( (x := (rand 1000))
        (while (<= x 500)
          ( (x := (rand 1000))))))



