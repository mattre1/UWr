#lang racket

;; arithmetic expressions

(define (const? t)
  (number? t))

(define (op? t)
  (and (list? t)
       (member (car t) '(+ - * /))))

(define (op-op e)
  (car e))

(define (op-args e)
  (cdr e))

(define (op-cons op args)
  (cons op args))

(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]))

;; null

(define (null-expr? e)
  (eq? e 'null))

(define (null-cons)
   'null)

;; lets

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

;; variables

(define (var? t)
  (symbol? t))

(define (var-var e)
  e)

(define (var-cons x)
  x)

;; pairs

(define (pair-expr? t)
  (cons-expr? t))

(define (cons-expr? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (car t) 'cons)))

(define (cons-cons e1 e2)
  (list 'cons e1 e2))

(define (car? t)
  (and (list? t)
       (= (length t) 2)
       (eq? (car t) 'car)))

(define (cdr? t)
  (and (list? t)
       (= (length t) 2)
       (eq? (car t) 'cdr)))

(define (cons-fst e)
  (second e))

(define (cons-snd e)
  (third e))

(define (car-expr e)
  (second e))

(define (cdr-expr e)
  (second e))

;; lists

(define (list-expr? l)
  (and (list? l)
       (> (length l) 1)
       (eq? (car l) 'list)))

(define (list-cons l)
  (cons 'list l))

(define (list-exprs l)
  (cdr l))

(define (list->evalform l)
  (if (null? l)
      null
      (cons (car l) (list->evalform (cdr l)))))

;; booleans

(define (true-expr? b)
  (eq? b 'true))

(define (false-expr? b)
  (eq? b 'false))

(define (true-cons)
  'true)

(define (false-cons)
  'false)

(define (boolean-expr? t)
  (or   (eq? false (eval t))
        (eq? true  (eval t))))

(define (binop? t)
  (and (list? t)
       (= (length t) 3)
       (member (car t) '(= > >= < <=))))

(define (binop-cons op l r)
  (list op l r))

(define (binop-left t)
  (cadr t))

(define (binop-right t)
  (caddr t))

(define (binop-op t)
  (car t))

(define (binop->proc op)
  (cond [(eq? op '=) =]
        [(eq? op '>) >]
        [(eq? op '<) <]
        [(eq? op '>=) >=]
        [(eq? op '<=) <=]))
        
;; if, cond

(define (if-expr? t)
  (and (list? t)
       (eq? (car t) 'if)
       (= (length t) 4)
       (boolean-expr? (cadr t))
       (expr?  (caddr  t))
       (expr?  (cadddr t))))

(define (cond-expr? t)
  (and (list? t)
       (> (length t) 1)
       (eq? (cond-tag t) 'cond)
       (andmap (lambda (x) (and (or (eq? 'else
                                         (cond-expr-cond x))
                                    (boolean-expr?
                                     (cond-expr-cond x)))
                                (expr? (cond-expr-expr x))))
               (cond-exprs t))))

(define (if-cond t)
  (cadr t))

(define (if-true t)
  (caddr t))

(define (if-false t)
  (cadddr t))

(define (cond-exprs t)
  (cdr t))

(define (cond-expr-cond t)
  (car t))

(define (cond-expr-expr t)
  (cdr t))

(define (cond-tag t)
  (car t))

(define (cond-tag? t)
  (eq? 'cond))

(define (string->cond c)
  cond)

;; lambdas

(define (lambda? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (car t) 'lambda)
       (list? (cadr t))
       (andmap symbol? (cadr t))))

(define (lambda-vars e)
  (cadr e))

(define (lambda-expr e)
  (caddr e))

;; applications

(define (app? t)
  (and (list? t)
       (> (length t) 0)))

(define (app-proc e)
  (car e))

(define (app-args e)
  (cdr e))

;; expressions

(define (expr? t)
  (or (const? t)
      (var? t)
      (true-expr? t)
      (false-expr? t)
      (null-expr? t)
      (if-expr? t)
      (cond-expr? t)
      (and (op? t)
           (andmap expr? (op-args t)))
      (and (binop? t)
           (expr? (binop-left  t))
           (expr? (binop-right t)))
      (and (let? t)
           (expr? (let-expr t))
           (expr? (let-def-expr (let-def t))))
      (and (cons-expr? t)
           (expr? (cons-fst t))
           (expr? (cons-snd t)))
      (and (car? t)
           (expr? (car-expr t)))
      (and (cdr? t)
           (expr? (cdr-expr t)))
      (and (list-expr? t)
           (andmap expr? (list-exprs t)))
      (and (lambda? t)
           (expr? (lambda-expr t)))
      (and (app? t)
           (expr? (app-proc t))
           (andmap expr? (app-args t)))))

;; environments

(define empty-env
  null)

(define (add-to-env x v env)
  (cons (list x v) env))

(define (find-in-env x env)
  (cond [(null? env) (error "undefined variable" x)]
        [(eq? x (caar env)) (cadar env)]
        [else (find-in-env x (cdr env))]))

;; closures

(define (closure-cons xs expr env)
  (list 'closure xs expr env))

(define (closure? c)
  (and (list? c)
       (= (length c) 4)
       (eq? (car c) 'closure)))

(define (closure-vars c)
  (cadr c))

(define (closure-expr c)
  (caddr c))

(define (closure-env c)
  (cadddr c))

;; evaluator

(define (eval-env e env)
  (cond [(const? e) e]
        [(var? e)    (find-in-env (var-var e) env)]
        [(null-expr?  e) null]
        [(true-expr?  e) true]
        [(false-expr? e) false]
        [(op? e)
         (apply (op->proc (op-op e))
                (map (lambda (a) (eval-env a env))
                     (op-args e)))]
        [(binop? e)
         ((binop->proc (binop-op e))
          (eval-env (binop-left  e) env)
          (eval-env (binop-right e) env))]
        [(let? e)
         (eval-env (let-expr e)
                   (env-for-let (let-def e) env))]
        [(cons-expr? e)
         (cons (eval-env (cons-fst e) env)
               (eval-env (cons-snd e) env))]
        [(car? e)
         (car  (eval-env (car-expr e) env))]
        [(cdr? e)
         (cdr (eval-env (cdr-expr e) env))]
        [(list-expr? e)
         (map (lambda (x) (eval-env x env))
              (list->evalform (list-exprs e)))]
        [(if-expr? e)
         (if (eval-env (if-cond  e) env)
             (eval-env (if-true  e) env)
             (eval-env (if-false e) env))]
        [(lambda? e)
         (closure-cons (lambda-vars e) (lambda-expr e) env)]
        [(app? e)
         (apply-closure
           (eval-env (app-proc e) env)
           (map (lambda (a) (eval-env a env))
                (app-args e)))]))

(define (

(define (apply-closure c args)
  (eval-env (closure-expr c)
            (env-for-closure
              (closure-vars c)
              args
              (closure-env c))))

(define (env-for-closure xs vs env)
  (cond [(and (null? xs) (null? vs)) env]
        [(and (not (null? xs)) (not (null? vs)))
         (add-to-env
           (car xs)
           (car vs)
           (env-for-closure (cdr xs) (cdr vs) env))]
        [else (error "arity mismatch")]))

(define (env-for-let def env)
  (add-to-env
    (let-def-var def)
    (eval-env (let-def-expr def) env)
    env))

(define (eval e)
  (eval-env e empty-env))