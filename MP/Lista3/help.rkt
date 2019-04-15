#lang racket
(define (make-queen x y)
  (cons x y))

(define (concatMap f xs)
  (if (null? xs)
      null
      (append (f (car xs)) (concatMap f (cdr xs)))))

(define (adjoin-position row col rest)
    (cons (make-queen row col) rest))

(define (safe? k positions)
  '())

(concatMap (lambda (rest-of-queens)
             (map (lambda (new-row)
                    (adjoin-position new-row 4 rest-of-queens))
                  '(1 2 3 4)))
           '(((1 . 3) (4 . 2) (2 . 1))
             ((4 . 3) (1 . 2) (3 . 1))))
(define (safe? positions)
    ;;Checking if queen which is now considered is legit whith else queens 
    (define (check x xs)
      (if (null? xs)
          #t
          (cond ((= (car x) (car (car xs))) #f)
                ((= (cdr x) (cdr (car xs))) #f)
                ((= (abs (- (car x) (car (car xs))))
                    (abs (- (cdr x) (cdr (car xs))))) #f)
                (else (check x (cdr xs))))))
    (if (null? positions)
        #t
        (if (check (car positions) (cdr positions))
            (safe? (cdr positions))
            #f)))