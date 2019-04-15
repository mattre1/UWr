#lang racket

;;definitions

(define (var? t)
  (symbol? t))

(define (neg? t)
  (and (list? t)
       (= 2 (length t))
       (eq? 'neg (car t))))

(define (conj? t)
  (and (list? t)
       (= 3 (length t))
       (eq? 'conj (car t))))

(define (disj? t)
  (and (list? t)
       (= 3 (length t))
       (eq? 'disj (car t))))

(define (prop? f)
  (or (var? f)
      (and (neg? f)
           (prop? (neg-subf f)))
      (and (disj? f)
           (prop? (disj-left f))
           (prop? (disj-right f)))
      (and (conj? f)
           (prop? (conj-left f))
           (prop? (conj-right f)))))

(define (literal? x)
  (or (var? x)
      (and (neg? x)
           (var? (neg-subf x)))))

(define (clause? x)
  (or (literal? x)
      (and (disj? x)
           (clause? (disj-left x))
           (clause? (disj-right x)))))

;;constructors, selectors


(define (make-neg f)
  (list 'neg f))

(define (neg-subf f)
  (cadr f))

(define (make-conj f g)
  (list 'conj f g))

(define (make-disj f g)
  (list 'disj f g))

(define (conj-left f)
  (cadr f))

(define (conj-right f)
  (caddr f))

(define (disj-left f)
  (cadr f))

(define (disj-right f)
  (caddr f))

;;Cwiczenie 2

;;free variables in formula
(define (free-vars f)
  (cond ((var? f) (list f))
        ((neg? f) (free-vars (neg-subf f)))
        ((conj? f) (append (free-vars (conj-left f)) (free-vars (conj-right f))))
        ((disj? f) (append (free-vars (disj-left f)) (free-vars (disj-right f))))))
    
;;Cwiczenie 3

;;evaluation of variable
(define (value-of x vs)
  (if (eq? (caar vs) x)
      (cadar vs)
      (if (null? vs)
          (error "Variable is not defined")
          (value-of x (cdr vs)))))

;;evaluation of formula
(define (eval-formula f vs)
  (cond ((var? f)  (value-of f vs))
        ((neg? f)  (not (eval-formula (neg-subf f) vs)))
        ((conj? f) (and (eval-formula (conj-left f) vs) (eval-formula (conj-right f) vs)))
        ((disj? f) (or  (eval-formula (disj-left f) vs) (eval-formula (disj-right f) vs)))))

;;all possible evaluations of variables set
(define (gen-vals xs)
  (if (null? xs)
      (list null)
      (let*
           ((vss (gen-vals (cdr xs)))
           (x (car xs))
           (vst (map (lambda (vs) (cons (list x true) vs)) vss))
           (vsf (map (lambda (vs) (cons (list x false) vs)) vss)))
        (append vst vsf))))

;;false evaluation of formula
(define (falsifiable-eval? f)
  (let*
      ((var-set (free-vars f))
       (all-evals (gen-vals var-set)))
    ;;finds first set of variables that returns false evaluation of whole formula
    (define (first-false f evals)
      (if (null? evals)
          #f          ;;tautology
          (if (not (eval-formula f (car evals)))
              (car evals)
              (first-false f (cdr evals)))))
    (first-false f all-evals)))

;;Cwiczenie 4

;;nnf -> negative normal form
(define (nnf? f)
  (cond ((disj? f) (and (nnf? (disj-left f)) (nnf? (disj-right f))))
        ((conj? f) (and (nnf? (conj-left f)) (nnf? (conj-right f))))
        ((literal? f) #t)
        ( else #f)))
         
;;Cwiczenie 5

(define (convert-to-nnf f)
  (cond ((literal? f) (list f))
        ((disj? f) (cons 'disj (append (convert-to-nnf (disj-left f))
                                       (convert-to-nnf (disj-right f)))))
        ((conj? f) (cons 'conj (append (convert-to-nnf (conj-left f))
                                       (convert-to-nnf (conj-right f)))))
        ((neg? f)  (convert-to-nnf (neg-reduction f)))
        ( else (error (car f) "This connector is not implemented yet"))))

;;removes multiple negations, changes alternative and conjunction using de Morgan's laws
(define (neg-reduction f)
  (if (literal? f)
      f
      (if (neg? f)
          (if (neg? (neg-subf f))
              (neg-reduction (neg-subf (neg-subf f)))
              (cond ((disj? (neg-subf f)) (list 'conj (list 'neg (disj-left (neg-subf f))) (list 'neg (disj-right (neg-subf f)))))
                    ((conj? (neg-subf f)) (list 'disj (list 'neg (conj-left (neg-subf f))) (list 'neg (conj-right (neg-subf f)))))
                    ( else (error (car f) "This connector is not implemented yet"))))
          f)))
                    
;;Cwiczenie 6

;;cnf->conjuctive normal form, clause->disjunction of literals
(define (cnf? f)
  (or (clause? f)
      (and (conj? f)
           (cnf? (conj-left f))
           (cnf? (conj-right f)))))

  




                 
        
  
      















       

