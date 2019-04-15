#lang racket

;; arithmetic expressions

(define (const? t)
  (number? t))

(define (binop? t)
  (and (list? t)
       (member (car t) '(+ - * /))))

(define (binop-op e)
  (car e))

(define (binop-left e)
  (cadr e))

(define (binop-right e)
  (caddr e))

(define (binop-args e)
  (cdr e))

(define (binop-cons op l r)
  (list op l r))

(define (arith-expr? t)
  (or (const? t)
      (and (binop? t)
           (arith-expr? (binop-left  t))
           (arith-expr? (binop-right t)))))


(define (if-zero? t)
  (if (list? t)
      (= (length t) 4)
      (eq? (car t) 'if-zero)))

(define (if-zero-pred t)
  (cadr t))

(define (if-zero-true t)
  (caddr t))

(define (if-zero-false t)
  (cadddr t))

;; let expressions

(define (let? t)
  (and (list? t)
       (= (length t) 3)
       (eq? (car t) 'let)
       (let-defs? (cadr t))))

(define (let-defs? t)
  (and (list? t)
       (= (length t) 2)
       (andmap (lambda (x) (symbol? (car x)))
               t)))

(define (make-let defs expr)
  (list 'let defs expr))

(define (let-defs t)
  (cadr t))

(define (let-expr t)
  (caddr t))

(define (let-def-var d)
  (car d))

(define (let-def-val d)
  (cadr d))

(define (var? e)
  (symbol? e))

(define (env-for-let defs env)
  (map (lambda (x) (add-to-env (env-def-var x)
                               (env-def-val x)
                                env))
        defs))
                     
;; environment expressions

(define empty-env
  null)

(define (env-def-var e)
  (car e))

(define (env-def-val e)
  (cadr e))

(define (add-to-env var val env)
  (cons (list var val) env))

(define (find-in-env e env)
  (if (null? env)
      (error e "undefined;")
      (if (eq? (env-def-var (car env)) e)
          (env-def-val (car env))
          (find-in-env e (cdr env)))))

;; calculator

(define (op->proc op)
  (cond [(eq? op '+) +]
        [(eq? op '*) *]
        [(eq? op '-) -]
        [(eq? op '/) /]))

;; Cwiczenie 1

(define (arith->rpn e)
  (define (arpn e stack)
    (if (const? e)
        (push e stack)
        (arpn (binop-left e)
              (arpn (binop-right e)
                    (push (binop-op e) stack)))))
  (arpn e empty-stack))

;; Cwiczenie 2
;; stack expressions

(define empty-stack
  null)

(define (stack? st)
  (list? st))

(define (push e st)
  (cons e st))

(define (pop st)
  (cdr st))

(define (top st)
  (car st))

;; Cwiczenie 3, 5

(define (eval-rpn e env)
  (cond [(const? e) e]
        [(var? e) (find-in-env e env)]
        [(binop? e)  (apply (op->proc (binop-op e))
                            (binop-args e))]
        [(let? e)     (eval-rpn (let-expr e)
                                (env-for-let (let-defs e) env))]
        [(if-zero? e) (if (= (eval-rpn (if-zero-pred e) env) 0)
                          (eval-rpn (if-zero-true e) env)
                          (eval-rpn (if-zero-false e) env))])) ;;LENIWA? GORLIWA?
        
        






              
             