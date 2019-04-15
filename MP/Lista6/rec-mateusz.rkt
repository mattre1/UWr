#lang racket

;; definitions, selectors, constructors

(define (const? t)
  (number? t))

(define (binop? t)
  (and (list? t)
       (= (length t) 3)
       (member (car t) '(+ - * /))))

(define (binop-op e)
  (car e))

(define (binop-left e)
  (cadr e))

(define (binop-right e)
  (caddr e))

(define (binop-cons op l r)
  (list op l r))

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

(define (hole? t)
  (eq? t 'hole))

(define (arith/let/holes? t)
  (or (hole? t)
      (const? t)
      (and (binop? t)
           (arith/let/holes? (binop-left  t))
           (arith/let/holes? (binop-right t)))
      (and (let? t)
           (arith/let/holes? (let-expr t))
           (arith/let/holes? (let-def-expr (let-def t))))
      (var? t)))

(define (num-of-holes t)
  (cond [(hole? t) 1]
        [(const? t) 0]
        [(binop? t)
         (+ (num-of-holes (binop-left  t))
            (num-of-holes (binop-right t)))]
        [(let? t)
         (+ (num-of-holes (let-expr t))
            (num-of-holes (let-def-expr (let-def t))))]
        [(var? t) 0]))

(define (arith/let/hole-expr? t)
  (and (arith/let/holes? t)
       (= (num-of-holes t) 1)))

;; lista zwiazanych zmiennych we wskazanym przez hole miejscu w wyrazeniu
(define (hole-context e)
  (define (hole-context-iter e res)
    (cond [(hole?  e) res]
          [(const? e) res]
          [(var?   e) res]
          [(binop? e)
           (if (arith/let/hole-expr? (binop-left e))
               (hole-context-iter (binop-left e)  res)
               (hole-context-iter (binop-right e) res))]
          [(let? e)
           (if (arith/let/hole-expr? (let-def-expr (let-def e)))
               (hole-context-iter (let-def-expr (let-def e)) res)
               (hole-context-iter (let-expr e)
                                  (if (member (let-def-var (let-def e))
                                               res)
                                       res
                                      (cons (let-def-var (let-def e)) res))))]))
  (if (arith/let/hole-expr? e)
      (hole-context-iter e null)
      (error "hole-context: contract violation")))
                

;; sprawdzarka z wbudowanymi testami dla hole-context
(define (test)
  (let*  ((test-list
           (list '(+ 3 hole)
               '(let (x 3) (let (y 7) (+ x hole)))
               '(let (x 3) (let (y hole) (+ x 3)))
               '(let (x hole) (let (y 7) (+ x 3)))
               '(let (piesek 1)
                   (let (kotek 7)
                      (let (piesek 9)
                         (let (chomik 5)
                            hole))))
               '(+ (let (x 4) 5) hole)
               '(let (x (let (y 12) hole)) 12)
               '(let (x (let (y hole) 12)) 12)))
          (test-res (map
                    (lambda (x) (hole-context x))
                     test-list)))
    (and (eq? (first test-res) null)
         (and (= (length (second test-res)) 2)
              (member 'x (second test-res))
              (member 'y (second test-res)))
         (and (= (length (third test-res))  1)
              (member 'x (third test-res)))
         (eq? (fourth test-res) null)
         (and (= (length (fifth test-res)) 3)
              (member 'chomik (fifth test-res))
              (member 'piesek (fifth test-res))
              (member 'kotek  (fifth test-res)))
         (eq? (sixth test-res)   null)
         (and (= (length (seventh test-res)) 1)
              (member 'y (seventh test-res)))
         (eq? (eighth test-res) null))))
         
    
         
    
       
      
         
     
         
         ;; (list '(+ (let(x (let (y hole) 5)) 5) 3) '() "'hole w definicji let'a zagniezdzonego w definicji innego let'a")
        
         

               



               
               
               
