#lang racket

(define (leaf? x)
  (eq? x 'leaf))

(define node list)

(define leaf 'leaf)

(define (make-node v l r)
  (list 'node v l r))

(define (node-val x)
  (cadr x))

(define (node-left x)
  (caddr x))

(define (node-right x)
  (cadddr x))

(define (node? x)
  (and (eq? (car x) 'node)
       (= 4 (length x))
       (list? x)))

(define (tree? t)
  (or (leaf? t)
      (and (node? t)
           (tree? (node-left t))
           (tree? (node-right t)))))

;;General procedures 
(define (concatMap f xs)
  (if (null? xs)
      null
      (append (f (car xs)) (concatMap f (cdr xs)))))

(define (from-to s e)
  (if (= s e)
      (list s)
      (cons s (from-to (+ s 1) e))))
;;Cwiczenie 1
(define (make-queen x y)
  (cons y x))
(define (queens board-size)
  ;; Return the representation of a board with 0 queens inserted
  (define (empty-board)
    '())
  ;; Return the representation of a board with a new queen at
  ;; (row, col) added to the partial representation `rest'
  (define (adjoin-position row col rest)
    (cons (make-queen row col) rest))
  ;; Return true if the set of queens is ok
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
    
  ;; Return a list of all possible solutions for k first columns
  (define (queen-cols k)
    (if (= k 0)
        (list (empty-board))
        (filter
         (lambda (positions) (safe? positions))
         (concatMap
          (lambda (rest-of-queens)
            (map (lambda (new-row)
                   (adjoin-position new-row k rest-of-queens))
                 (from-to 1 board-size)))
          (queen-cols (- k 1))))))
  (queen-cols board-size))
(define (length-list xs)
  (if (null? xs)
      0
      (+ 1 (length-list (cdr xs)))))
(length-list (queens 8))

;; Cwiczenie 3

(define (mirror t)
  (if (leaf? t)
      'leaf
      (make-node (node-val t) (mirror (node-right t)) (mirror (node-left t)))))

;; Cwiczenie 4

(define (flatten tree)
  (if (leaf? tree)
      '()
      (append (flatten (node-left tree))
              (list (node-val tree))
              (flatten (node-right tree)))))
(define x '( node 2 (node 1 leaf leaf) (node 5 leaf leaf)))
(flatten x)

;; Cwiczenie 5

(define (bst-insert x t)
  (cond [(leaf? t)
         (make-node x leaf leaf)]
        [(< x (node-val t))
         (make-node (node-val t)
                    (bst-insert x (node-left t))
                    (node-right t))]
        [else
         (make-node (node-val t)
                    (node-left t)
                    (bst-insert x (node-right t)))]))

(define (treesort xs)
  (let ((tree (make-node (car xs) leaf leaf)))
    (define (sort list tree)
      (if (null? list)
          (flatten tree)
          (sort (cdr list) (bst-insert (car list) tree))))
    (sort (cdr xs) tree)))

(treesort '(6 5 7 3 4 3))

;; Cwiczenie 6




              
                




