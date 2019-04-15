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

; arith and bools

(define (const? t)
  (number? t))

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * / = > >= < <= %))))

(define (op-op e)
  (car e))

(define (op-args e)
  (cdr e))

(define (op-cons op l r)
  (list op l r))

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
        [(eq? op '%) modulo]))

(define (var? t)
  (symbol? t))

(define (eval-arith e m)
  (cond [(var? e) (get-mem e m)]
        [(op? e)
         (apply
          (op->proc (op-op e))
          (map (lambda (x) (eval-arith x m))
               (op-args e)))]
        [(const? e) e]))

;; WHILE instructions

;; assign

(define (assign? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (second t) ':=)))

(define (assign-var e)
  (first e))

(define (assign-expr e)
  (third e))

(define (assign-cons x v)
  (list x ':= v))

;; if

(define (if? t)
  (tagged-tuple? 'if 4 t))

(define (if-cond e)
  (second e))

(define (if-then e)
  (third e))

(define (if-else e)
  (fourth e))

;; while

(define (while? t)
  (tagged-tuple? 'while 3 t))

(define (while-cons cond expr)
  (list 'while cond expr))

(define (while-cond t)
  (second t))

(define (while-expr t)
  (third t))

;; block

(define (block? t)
  (list? t))

;; WHILE evaluator

(define (eval e m)
  (cond [(assign? e)
         (set-mem
          (assign-var e)
          (eval-arith (assign-expr e) m)
          m)]
        [(if? e)
         (if (eval-arith (if-cond e) m)
             (eval (if-then e) m)
             (eval (if-else e) m))]
        [(while? e)
         (if (eval-arith (while-cond e) m)
             (eval e (eval (while-expr e) m))
             m)]
        [(for? e)
         (eval (while-cons (for-def-cond (for-def e))
                           (cons (for-def-change (for-def e))
                                       (for-expr e)))
               (eval (for-def-begin (for-def e)) m))]
        [(inc? e)
         (eval (assign-cons (inc-var e)
                            (op-cons '+ (inc-var e) 1)) m)]
        [(dec? e)
         (eval (assign-cons (inc-var e)
                            (op-cons '- (inc-var e) 1)) m)]
        [(block? e)
         (if (null? e)
             m
             (eval (cdr e) (eval (car e) m)))]))

(define (run e)
  (eval e empty-mem))


;; Cwiczenie 3

(define fact10
  '( (i := 10)
     (r := 1)
     (while (> i 0)
       ( (r := (* i r))
         (i := (- i 1)) ))))

(define (computeFact10)
  (run fact10))

(define fib-n
  '( (lf := 0)
     (rf := 1)
     (i := 1)
     (r := 0)
     (while (< i n)
       ( (res := (+ lf rf))
         (lf := rf)
         (rf := res)
         (i := (+ i 1))))))

(define (computeFib n)
  (eval fib-n (set-mem 'n n empty-mem)))

(define prime-sum
  '( (i := 0)
     (prime := 2)
     (res := 0)
     (while (< i n)
       ( (j := 2)
         (bool := 1)
         (while (< j prime)
           ( (if (= (% prime j) 0)
                 (bool := 0)
                 (bool := bool))
             (j := (+ j 1))))
         (if (= bool 1)
               ( (res := (+ res prime))
                 (i := (+ i 1)))
               (res := res))
         (prime := (+ prime 1))))))

(define (compute-prime-sum n)
  (eval prime-sum (set-mem 'n n empty-mem)))
           
;; Cwiczenie 4

(define (vars-list e)
  (map (lambda (i) (car i))
       (run e)))

;; Cwiczenie 5

(define (inc? e)
  (and (list? e)
       (= (length e) 2)
       (symbol? (first  e))
       (eq? '++ (second e))))

(define (dec? e)
  (and (list? e)
       (= (length e) 2)
       (symbol? (first  e))
       (eq? '-- (second e))))

(define (inc-var e)
  (car e))

(define (dec-var e)
  (car e))

;; Cwiczenie 6

(define (for? e)
  (and (tagged-tuple? 'for 3 e)
       (assign? (cadr e))))

(define (for-cons beg cond change expr)
  (list 'for (list beg cond change) expr))

(define (for-def e)
  (cadr e))

(define (for-def-begin e)
  (car e))

(define (for-def-cond e)
  (cadr e))

(define (for-def-change e)
  (caddr e))

(define (for-expr e)
  (caddr e))









