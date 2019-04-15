#lang racket

;; expressions

(define (const? t)
  (number? t))

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * /))))

(define (op-op e)
  (car e))

(define (op-args e)
  (cdr e))

(define (op-left e)
  (cadr e))

(define (op-right e)
  (caddr e))

(define (op-cons op args)
  (cons op args))

(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]))

(define (let-def? t)
  (and (list? t)
       (= (length t) 2)
       (symbol? (car t))))

(define (let-def-var e)
  (car e))

(define (let-def-expr e)
  (cadr e))

(define (let-def-cons x e)
  (list x e))

(define (let? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (car t) 'let)
       (let-def? (cadr t))))

(define (let-def e)
  (cadr e))

(define (let-expr e)
  (caddr e))

(define (let-cons def e)
  (list 'let def e))

(define (var? t)
  (symbol? t))

(define (var-var e)
  e)

(define (var-cons x)
  x)

(define (arith/let-expr? t)
  (or (const? t)
      (and (op? t)
           (andmap arith/let-expr? (op-args t)))
      (and (let? t)
           (arith/let-expr? (let-expr t))
           (arith/let-expr? (let-def-expr (let-def t))))
      (var? t)))

;; let-lifted expressions

(define (arith-expr? t)
  (or (const? t)
      (and (op? t)
           (andmap arith-expr? (op-args t)))
      (var? t)))

(define (let-lifted-expr? t) ;; ocb przecież definicje letów mogą być nadal zagnieżdżone
  (or (and (let? t)
           (let-lifted-expr? (let-expr t))
           (arith-expr? (let-def-expr (let-def t))))
      (arith-expr? t)))

;; generating a symbol using a counter

(define (number->symbol i)
  (string->symbol (string-append "x" (number->string i))))

;; environments (could be useful for something)

(define empty-env
  null)

(define (add-to-env x v env)
  (cons (list x v) env))

(define (find-in-env x env)
  (cond [(null? env) (error "undefined variable" x)]
        [(eq? x (caar env)) (cadar env)]
        [else (find-in-env x (cdr env))]))

;; the let-lift 

;; let-lift-iter output type -> res '((defs) (expression) i)

(define (res? t)
  (and (list? t)
       (= (length t) 3)
       (list?  (res-defs t))
       (list?  (res-expr t))
       (const? (res-iter t))))

(define (res-cons defs expr i)
  (list defs expr i))

(define (res-defs d)
  (car d))

(define (res-expr d)
  (cadr d))

(define (res-iter d)
  (caddr d))

(define (defs-append xs xd)
  (append xs xd))

;; original procedure
(define (let-lift e)
  (output-format
   (let-lift-iter e 1)))

(define (output-format e)
  (if (null? (res-defs e))
      (res-expr e)
      (let-cons (car (res-defs e))
                (output-format (res-cons (cdr (res-defs e))
                                         (res-expr e)
                                         (res-iter e))))))

(define (args-iter prev args)
  (if (null? args)
      prev
      (let ((current (let-lift-iter (car args)
                                    (res-iter prev))))
        (args-iter   (res-cons (defs-append (res-defs prev)
                                            (res-defs current))
                               (list (res-expr prev)
                                     (res-expr current))
                               (res-iter current))
                     (cdr args)))))

(define (let-lift-iter e i)
  (cond 
        [(const? e) (res-cons null e i)]
        [(var?   e) (res-cons null e i)]
        [(op? e)
         (let* ((p (let-lift-iter (car (op-args e)) i))
                (res (args-iter p (cdr (op-args e)))))
           (res-cons (res-defs res)
                     (list (op-op e) (res-expr res))
                     (res-iter res)))]
        [(let? e)
         (let ((l (let-lift-iter (rename-sym (let-expr e)
                                        (number->symbol i)
                                        (let-def-var (let-def e))) (+ i 1))))
           (res-cons (defs-append
                       (res-defs (let-lift-iter (let-def-expr (let-def e))
                                           (+ i 1)))
                       (defs-append
                         (list (let-def-cons (number->symbol i)
                                             (res-expr (let-lift-iter
                                                        (let-def-expr (let-def e))
                                                        (+ i 1)))))
                         (res-defs l)))
                     (res-expr l)
                     (res-iter l)))]))
                            
;; rename procedure changes all sym in expr to sub
(define (rename-sym expr sub sym)
  (cond [(const? expr) expr]
        [(var? expr) (if (eq? sym expr)
                          sub
                         (var-var expr))]
        [(op? expr) (list (op-op expr)
                          (rename-sym (op-left  expr) sub sym)
                          (rename-sym (op-right expr) sub sym))]
        [(let? expr) (let-cons (let-def-cons
                                (rename-sym (let-def-var  (let-def expr)) sub sym)
                                (rename-sym (let-def-expr (let-def expr)) sub sym))
                               (rename-sym (let-expr expr) sub sym))]))

;; let-lift test

(let-lift '(let (x (- 2 (let (z 3) z))) (+ x 2)))
(let-lift '(+ 10 (* (let (x 7) (+ x 2)) 2)))
(let-lift '(+ (let (x 5) x) (let (x 1) x)))
(let-lift '(let (x 1) (let (y (+ x 1))
                             (let (z (+ x y))
                               (+ z (let (g (* y 2)) g))))))
(let-lift '(let (x (let (y (+ 1 (let (z (- 3 (let (g (+ 1 1)) g))) z))) y)) (* x 5)))
(let-lift '(let (x (let (y (+ 1 1 1)) y)) (+ x (let (g (/ 2 1)) g))))
(let-lift '(+ 2 3 4 5 67))
(let-lift 'x)
  