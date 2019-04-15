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

;; reprezentacja danych wejściowych (z ćwiczeń)
(define (var? x)
  (symbol? x))

(define (var x)
  x)

(define (var-name x)
  x)

;; przydatne predykaty na zmiennych
(define (var<? x y)
  (symbol<? x y))

(define (var=? x y)
  (eq? x y))

(define (literal? x)
  (and (tagged-tuple? 'literal 3 x)
       (boolean? (cadr x))
       (var? (caddr x))))

(define (literal pol x)
  (list 'literal pol x))

(define (literal-pol x)
  (cadr x))

(define (literal-var x)
  (caddr x))

(define (clause? x)
  (and (tagged-list? 'clause x)
       (andmap literal? (cdr x))))

(define (clause . lits)
  (cons 'clause lits))

(define (clause-lits c)
  (cdr c))

(define (cnf? x)
  (and (tagged-list? 'cnf x)
       (andmap clause? (cdr x))))

(define (cnf . cs)
    (cons 'cnf cs))

(define (cnf-clauses x)
  (cdr x))

;; oblicza wartość formuły w CNF z częściowym wartościowaniem. jeśli zmienna nie jest
;; zwartościowana, literał jest uznawany za fałszywy.
(define (valuate-partial val form)
  (define (val-lit l)
    (let ((r (assoc (literal-var l) val)))
      (cond
       [(not r)  false]
       [(cadr r) (literal-pol l)]
       [else     (not (literal-pol l))])))
  (define (val-clause c)
    (ormap val-lit (clause-lits c)))
  (andmap val-clause (cnf-clauses form)))

;; reprezentacja dowodów sprzeczności

(define (axiom? p)
  (tagged-tuple? 'axiom 2 p))

(define (proof-axiom c)
  (list 'axiom c))

(define (axiom-clause p)
  (cadr p))

(define (res? p)
  (tagged-tuple? 'resolve 4 p))

(define (proof-res x pp pn)
  (list 'resolve x pp pn))

(define (res-var p)
  (cadr p))

(define (res-proof-pos p)
  (caddr p))

(define (res-proof-neg p)
  (cadddr p))

;; sprawdza strukturę, ale nie poprawność dowodu
(define (proof? p)
  (or (and (axiom? p)
           (clause? (axiom-clause p)))
      (and (res? p)
           (var? (res-var p))
           (proof? (res-proof-pos p))
           (proof? (res-proof-neg p)))))

;; procedura sprawdzająca poprawność dowodu
(define (check-proof pf form)
  (define (run-axiom c)
    (displayln (list 'checking 'axiom c))
    (and (member c (cnf-clauses form))
         (clause-lits c)))
  (define (run-res x cpos cneg)
    (displayln (list 'checking 'resolution 'of x 'for cpos 'and cneg))
    (and (findf (lambda (l) (and (literal-pol l)
                                 (eq? x (literal-var l))))
                cpos)
         (findf (lambda (l) (and (not (literal-pol l))
                                 (eq? x (literal-var l))))
                cneg)
         (append (remove* (list (literal true x))  cpos)
                 (remove* (list (literal false x)) cneg))))
  (define (run-proof pf)
    (cond
     [(axiom? pf) (run-axiom (axiom-clause pf))]
     [(res? pf)   (run-res (res-var pf)
                           (run-proof (res-proof-pos pf))
                           (run-proof (res-proof-neg pf)))]
     [else        false]))
  (null? (run-proof pf)))


;; reprezentacja wewnętrzna

;; sprawdza posortowanie w porządku ściśle rosnącym, bez duplikatów
(define (sorted? vs)
  (or (null? vs)
      (null? (cdr vs))
      (and (var<? (car vs) (cadr vs))
           (sorted? (cdr vs)))))

(define (sorted-varlist? x)
  (and (list? x)
       (andmap (var? x))
       (sorted? x)))

;; klauzulę reprezentujemy jako parę list — osobno wystąpienia pozytywne i negatywne. Dodatkowo
;; pamiętamy wyprowadzenie tej klauzuli (dowód) i jej rozmiar.
(define (res-clause? x)
  (and (tagged-tuple? 'res-int 5 x)
       (sorted-varlist? (second x))
       (sorted-varlist? (third x))
       (= (fourth x) (+ (length (second x)) (length (third x))))
       (proof? (fifth x))))

(define (res-clause pos neg proof)
  (list 'res-int pos neg (+ (length pos) (length neg)) proof))

(define (res-clause-pos c)
  (second c))

(define (res-clause-neg c)
  (third c))

(define (res-clause-size c)
  (fourth c))

(define (res-clause-proof c)
  (fifth c))

;; przedstawia klauzulę jako parę list zmiennych występujących odpowiednio pozytywnie i negatywnie
(define (print-res-clause c)
  (list (res-clause-pos c) (res-clause-neg c)))

;; sprawdzanie klauzuli sprzecznej
(define (clause-false? c)
  (and (null? (res-clause-pos c))
       (null? (res-clause-neg c))))

;; pomocnicze procedury: scalanie i usuwanie duplikatów z list posortowanych
(define (merge-vars xs ys)
  (cond [(null? xs) ys]
        [(null? ys) xs]
        [(var<? (car xs) (car ys))
         (cons (car xs) (merge-vars (cdr xs) ys))]
        [(var<? (car ys) (car xs))
         (cons (car ys) (merge-vars xs (cdr ys)))]
        [else (cons (car xs) (merge-vars (cdr xs) (cdr ys)))]))

(define (remove-duplicates-vars xs)
  (cond [(null? xs) xs]
        [(null? (cdr xs)) xs]
        [(var=? (car xs) (cadr xs)) (remove-duplicates-vars (cdr xs))]
        [else (cons (car xs) (remove-duplicates-vars (cdr xs)))]))

(define (rev-append xs ys)
  (if (null? xs) ys
      (rev-append (cdr xs) (cons (car xs) ys))))

;; miejsce na uzupełnienie własnych funkcji pomocniczych

;; przecięcie dwóch zbiorów literałów
(define (intersection xs ys)
  (cond [(null? xs) null]
        [(null? ys) null]
        [(var<? (car xs) (car ys)) (intersection (cdr xs) ys)]
        [(var<? (car ys) (car xs)) (intersection xs (cdr ys))]
        [(var=? (car xs) (car ys)) (cons (car xs)
                                         (intersection (cdr xs) (cdr ys)))]))

;; usuwa element x ze zbioru xs
(define (delete x xs)
  (if (eq? x (car xs))
      (cdr xs)
      (cons (car xs) (delete x (cdr xs)))))

;; zwraca fałsz jeśli klauzula nie zawiera takiej samej zmiennej i jej negacji
(define (clause-trivial? c)
  (if (null? (intersection (res-clause-pos c)
                           (res-clause-neg c)))
      false
      true))

(define (resolve c1 c2)
  (let* ((pos (merge-vars (res-clause-pos c1)
                          (res-clause-pos c2)))
         (neg (merge-vars (res-clause-neg c1)
                          (res-clause-neg c2)))
         (c               (intersection pos neg)))
    (if (null? c)
        false
        (if (null?      (intersection (list (car c)) (res-clause-pos c1)))
            (res-clause (delete (car c) pos)  (delete (car c) neg)
                        (proof-res (car c)    (res-clause-proof c2) (res-clause-proof c1)))
            (res-clause (delete (car c) pos)  (delete (car c) neg)
                        (proof-res (car c)    (res-clause-proof c1) (res-clause-proof c2)))))))
          
    
#|(define (resolve-single-prove s-clause checked pending)
  (let* ((resolvents-checked   (filter-map (lambda (c) (resolve c s-clause))
                                     checked))
         (resolvents-pending   (filter-map (lambda (c) (resolve c s-clause))
                                     pending))
         (filtered-checked     (filter-list s-clause checked))
         (filtered-pending     (filter-list s-clause pending)))
         (cond [(eq? (car (filtered-checked)) 'unsat) (filtered-checked)]
               [(eq? (car (filtered-pending)) 'unsat) (filtered-pending)]
               [else (subsume-add-prove filtered-checked filtered-pending null)])))


(define (filter-list s-clause list)
  (if (null? list)
      null
      (if (resolve s-clause (car list))
          (if (= (res-clause-size (car list)) 1)
              (list 'unsat (res-clause-proof (car list)))
              (cons (resolve s-clause (car list))
                    (filter-list s-clause (cdr list))))
          (cons (car list)
                (filter-list s-clause (cdr list))))))|#

(define (resolve-single-prove s-clause checked pending)
  ;; TODO: zaimplementuj!
  ;; Poniższa implementacja działa w ten sam sposób co dla większych klauzul — łatwo ją poprawić!
  (let* ((resolvents   (filter-map (lambda (c) (resolve c s-clause))
                                     checked))
         (sorted-rs    (sort resolvents < #:key res-clause-size)))
    (subsume-add-prove (cons s-clause checked) pending sorted-rs)))

;; wstawianie klauzuli w posortowaną względem rozmiaru listę klauzul
(define (insert nc ncs)
  (cond
   [(null? ncs)                     (list nc)]
   [(< (res-clause-size nc)
       (res-clause-size (car ncs))) (cons nc ncs)]
   [else                            (cons (car ncs) (insert nc (cdr ncs)))]))

;; sortowanie klauzul względem rozmiaru (funkcja biblioteczna sort)
(define (sort-clauses cs)
  (sort cs < #:key res-clause-size))

;; główna procedura szukająca dowodu sprzeczności
;; zakładamy że w checked i pending nigdy nie ma klauzuli sprzecznej
(define (resolve-prove checked pending)
  (cond
   ;; jeśli lista pending jest pusta, to checked jest zamknięta na rezolucję czyli spełnialna
   [(null? pending) (generate-valuation (sort-clauses checked))]
   ;; jeśli klauzula ma jeden literał, to możemy traktować łatwo i efektywnie ją przetworzyć
   [(= 1 (res-clause-size (car pending)))
    (resolve-single-prove (car pending) checked (cdr pending))]
   ;; w przeciwnym wypadku wykonujemy rezolucję z wszystkimi klauzulami już sprawdzonymi, a
   ;; następnie dodajemy otrzymane klauzule do zbioru i kontynuujemy obliczenia
   [else
    (let* ((next-clause  (car pending))
           (rest-pending (cdr pending))
           (resolvents   (filter-map (lambda (c) (resolve c next-clause))
                                     checked))
           (sorted-rs    (sort-clauses resolvents)))
      (subsume-add-prove (cons next-clause checked) rest-pending sorted-rs))]))

;; procedura upraszczająca stan obliczeń biorąc pod uwagę świeżo wygenerowane klauzule i
;; kontynuująca obliczenia. Do uzupełnienia.
(define (subsume-add-prove checked pending new)
  (cond
   [(null? new)                 (resolve-prove checked pending)]
   ;; jeśli klauzula do przetworzenia jest sprzeczna to jej wyprowadzenie jest dowodem sprzeczności
   ;; początkowej formuły
   [(clause-false? (car new))   (list 'unsat (res-clause-proof (car new)))]
   ;; jeśli klauzula jest trywialna to nie ma potrzeby jej przetwarzać
   [(clause-trivial? (car new)) (subsume-add-prove checked pending (cdr new))]
   ;; jeśli klauzula jest łatwiejsza od którejś -> wyrzucamy ją
   ;; w p.p. wyrzucamy  z list wszystkie łatwiejsze od niej
   [else
    (if (ormap (lambda (x) (easier? (car new) x)) (append checked pending))
        (subsume-add-prove checked pending (cdr new))
        (subsume-add-prove (filter-not (lambda (x) (easier? x (car new))) checked)
                           (cons (car new) (filter-not (lambda (x) (easier? x (car new))) pending))
                           (cdr new)))]))

;; pomocnicza procedura, sprawdza czy y subsumuje x
(define (easier? x y)
  (if (= (length (append (intersection (res-clause-pos x)
                                       (res-clause-pos y))
                         (intersection (res-clause-neg x)
                                       (res-clause-neg y))))
         (res-clause-size y))
      true
      false))

;; procedura generujaca częściowe wartościowanie spełniające zbiór rezolwent
;; generuje zbiór vals w postaci '( (zmienne pozytywne) (zmienne negatywne)) a następnie przekształca w pary (zmienna wartościowanie)
;; nie używam kilku zdefiniowanych selektorów, bo z niewiadomych powodów wpisując je w niektóre miejsca zamiast dłuższego kodu procedura przestaje działac
(define (generate-valuation resolved)
  (define (g-val resolved vals)
    (if (null? resolved)
          vals
          (let ((resolvent (car resolved))
                (rest      (cdr resolved))
                (vals-pos  (car vals))
                (vals-neg  (cadr vals)))
            (if (null? (res-clause-neg resolvent))
                (let*  ((val-pos  (car  (res-clause-pos resolvent)))
                        (new-vals (list (cons val-pos (car vals))
                                  (cadr vals))))
                  (g-val (check rest val-pos #t) new-vals))
                (let*  ((val-neg  (car  (res-clause-neg resolvent)))
                        (new-vals (list (car vals)
                                  (cons val-neg (cadr vals)))))
                  (g-val (check rest val-neg #f) new-vals))))))
  (list 'sat
         (append
            (map (lambda (x) (make-pair x #t)) (car (g-val resolved (list null null))))
            (map (lambda (x) (make-pair x #f)) (cadr (g-val resolved (list null null)))))))

(define (make-pair a b)
  (list a b))

;; pomocnicze check, zmienia odpowiednio klauzule res
;; jeśli wystepuje w nich zmienna val
(define (check res val bool)
  (if   (null? res)
         null
        (let ((resolvent (car res)))
          (if bool
             (cond [(contains? val (res-clause-pos resolvent))
                    (check (cdr res) val bool)]
                   [(contains? val (res-clause-neg resolvent))
                    (cons (res-clause (res-clause-pos resolvent)
                                      (delete val (res-clause-neg resolvent))
                                      (res-clause-proof resolvent))
                          (check (cdr res) val bool))]
                   [else (cons resolvent (check (cdr res) val bool))])
             (cond [(contains? val (res-clause-neg resolvent))
                    (check (cdr res) val bool)]
                   [(contains? val (res-clause-pos resolvent))
                    (cons (res-clause (delete val (res-clause-pos resolvent))
                                      (res-clause-neg resolvent)
                                      (res-clause-proof resolvent))
                          (check (cdr res) val bool))]
                   [else (cons resolvent (check (cdr res) val bool))])))))

;; pomocnicze contains?, sprawdza czy zmienna wystepuje w klauzuli
(define (contains? x xs)
  (if (null? xs)
      #f
      (if (eq? x (car xs))
          #t
          (contains? x (cdr xs)))))
    

;; procedura przetwarzające wejściowy CNF na wewnętrzną reprezentację klauzul
(define (form->clauses f)
  (define (conv-clause c)
    (define (aux ls pos neg)
      (cond
       [(null? ls)
        (res-clause (remove-duplicates-vars (sort pos var<?))
                    (remove-duplicates-vars (sort neg var<?))
                    (proof-axiom c))]
       [(literal-pol (car ls))
        (aux (cdr ls)
             (cons (literal-var (car ls)) pos)
             neg)]
       [else
        (aux (cdr ls)
             pos
             (cons (literal-var (car ls)) neg))]))
    (aux (clause-lits c) null null))
  (map conv-clause (cnf-clauses f)))

(define (prove form)
  (let* ((clauses (form->clauses form)))
    (subsume-add-prove '() '() clauses)))

;; procedura testująca: próbuje dowieść sprzeczność formuły i sprawdza czy wygenerowany
;; dowód/waluacja są poprawne. Uwaga: żeby działała dla formuł spełnialnych trzeba umieć wygenerować
;; poprawną waluację.
(define (prove-and-check form)
  (let* ((res (prove form))
         (sat (car res))
         (pf-val (cadr res)))
    (if (eq? sat 'sat)
        (valuate-partial pf-val form)
        (check-proof pf-val form))))

;;; poniżej wpisz swoje testy
;; 1 i 2 powinny zwracać poprawne wyniki natomiast mogą być problemy z testami, które wymagają 3 cwiczenia

(prove '(cnf (clause (literal #f p) (literal #f q)) (clause (literal #t w) (literal #f z)) (clause (literal #t a) (literal #t b) (literal #t w))))
(prove-and-check '(cnf (clause (literal #f p) (literal #f q)) (clause (literal #t w) (literal #f z)) (clause (literal #t a) (literal #t b) (literal #t w))))
(prove '(cnf (clause (literal #t p) (literal #f q)) (clause (literal #t q) (literal #f p)) (clause (literal #t w) (literal #f z)) (clause (literal #t z) (literal #f w))))
(prove-and-check '(cnf (clause (literal #t p) (literal #f q)) (clause (literal #t q) (literal #f p)) (clause (literal #t w) (literal #f z)) (clause (literal #t z) (literal #f w))))
(prove '(cnf (clause (literal #t p) (literal #f q)) (clause (literal #t q) (literal #f p)) (clause (literal #f p) (literal #f r) (literal #t s))
                       (clause (literal #t p) (literal #f s))))
(prove-and-check '(cnf (clause (literal #t p) (literal #f q)) (clause (literal #t q) (literal #f p)) (clause (literal #f p) (literal #f r) (literal #t s))
                       (clause (literal #t p) (literal #f s))))

