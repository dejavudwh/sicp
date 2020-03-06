#lang planet neil/sicp 

;;; table

(define (make-table)
    (let ((local-table (list '*table*)))
        (define (lookup key-1 key-2)
            (let ((subtable (assoc key-1 (cdr local-table))))
                (if subtable
                    (let ((record (assoc key-2 (cdr subtable))))
                        (if record 
                            (cdr record)
                            false))
                    false)))
        (define (insert! key-1 key-2 value)
            (let ((subtable (assoc key-1 (cdr local-table))))
                (if subtable
                    (let ((record (assoc key-2 (cdr subtable))))
                        (if record 
                            (set-cdr! record value)
                            (set-cdr! subtable
                                      (cons (cons key-2 value)
                                            subtable))))
                    (set-cdr! local-table
                              (cons (list key-1
                                          (cons key-2 value))
                                    (cdr local-table)))))
            'ok)
        (define (dispatch m)
            (cond ((eq? m 'lookup-proc) lookup)
                  ((eq? m 'insert-proc) insert!)
                  (else 
                    (error "Unknown operation -- TABLE" m))))
    dispatch))

(define (equal? s1 s2)
    (cond ((and (null? s1) (null? s2)) true)
          ((and (not (pair? s1)) (not (pair? s2))) (eq? s1 s2))
          ((and (pair? s1) (pair? s2) (eq? (car s1)  (car s2))) (equal? (cdr s1) (cdr s2)))
          (else false)))

(define (assoc key records)
    (cond ((null? records) false)
          ((equal? key (caar records)) (car records))
          (else
           (assoc key (cdr records)))))

(define table (make-table))
(define get (table 'lookup-proc))
(define put (table 'insert-proc))

; test
; (put 'h 'd 1234)
; (get 'h 'd)


;;; stream

(define (cons-stream a b)
    (cons a (delay b)))

(define (stream-car stream) (car stream))
(define (stream-cdr stream) (force (cdr stream)))

(define the-empty-stream '())
(define (stream-null? stream) (null? stream))

(define (memo-proc proc)
    (let ((already-run? false) (result false))
       (lambda ()
         (if (not already-run?)
             (begin (set! result (proc))
                    (set! already-run? true)
                    result)
             result))))

(define (delay exp)
    (memo-proc (lambda () exp)))

(define (force delayed-object)
    (delayed-object))

(define (stream-ref s n)
    (if (= n 0)
        (stream-car s)
        (stream-ref (stream-cdr s) (- n 1))))
        
(define (stream-append s1 s2)
     (if (stream-null? s1)
         s2
         (cons-stream (stream-car s1)
                      (stream-append (stream-cdr s1) s2))))

(define (stream-map proc s)
   (if (stream-null? s)
        the-empty-stream
        (cons-stream (proc (stream-car s))
                     (stream-map proc (stream-cdr s)))))
                     
(define (stream-for-each proc s)
    (if (stream-null? s)
        'done
        (begin (proc (stream-car s))
               (stream-for-each proc (stream-cdr s)))))
               
(define (display-stream s)
     (stream-for-each display-line s))
     
(define (display-line x)
    (newline)
    (display x))


;;; driver loop

(define input-prompt ";;; Query input:")
(define output-prompt ";;; Query output:")

(define (query-driver-loop)
    (prompt-for-input input-prompt)
     (let ((q (query-syntax-process (read))))
        (display q)
        (newline)
        (cond ((assertion-to-be-added? q)
                (add-rule-or-assertion! (add-assertion-body q))
                (newline)
                (display "Assertion adde to data base.  ")
                (query-driver-loop))
              (else   
                (newline)
                (display output-prompt)
                (display-stream
                    (stream-map
                        (lambda (frame)
                            (instantiate q
                                         frame
                                         (lambda (v f)
                                            (contract-question-mark v))))
                         (qeval q (singleton-stream '()))))
                (query-driver-loop)))))

(define (instantiate exp frame unbound-var-handler)
    (display "<------ instatiate ------>")
    (newline)
    (display exp)
    (display frame)
    (define (copy exp)
        (cond ((var? exp)
               (display "Variables and its bindings:")
               (display exp)
               (let ((binding (binding-in-frame exp frame)))
                  (display binding)
                  (if binding
                      (copy (binding-value binding))
                      (unbound-var-handler exp frame))))
              ((pair? exp)
               (cons (copy (car exp)) (copy (cdr exp))))
              (else exp)))
    (copy exp))


;;; query eval

(define (qeval query frame-stream)
    (display "<----- query eval ----->")
    (newline)
    (let ((qproc (get (type query) 'qeval)))
        (if qproc
            (qproc (contents query) frame-stream)
            (simple-query query frame-stream))))

;; simple query

(define (simple-query query-pattern frame-stream)
    (display "simple query:")
    (display query-pattern)
    (stream-flatmap
        (lambda (frame)
            (stream-append-delayed
                 (find-assertions query-pattern frame)
                 (delay (apply-rules query-pattern frame))))
    frame-stream))        

;; and

(define (conjoin conjuncts frame-stream)
    (if (empty-conjunction? conjuncts)
        frame-stream
        (conjoin (rest-conjuncts conjuncts)
                 (qeval (first-conjunct conjuncts)
                        frame-stream))))
(put 'and 'qeval conjoin)

;; or

(define (disjoin disjuncts frame-stream)
    (if (empty-disjunction? disjuncts)
        the-empty-stream
        (interleave-delayed
            (qeval (first-disjunct disjuncts) frame-stream)
            (delay (disjoin (rest-disjuncts disjuncts)
                            frame-stream)))))
(put 'or 'qeval disjoin)    

;; filter

(define (negate operands frame-stream)
    (stream-flatmap
         (lambda (frame)
              (if (stream-null? (qeval (negated-query operands)
                                       (singleton-stream frame)))
                  (singleton-stream frame)
                  the-empty-stream))
          frame-stream))
 (put 'not 'qeval negate)       

(define (lisp-value call frame-stream)
   (stream-flatmap
        (lambda (frame)
             (if (execute
                     (instantiate
                      call
                      frame
                      (lambda (v f)
                           (error "Unknwn pat var -- LISP-VALUE" v))))
                 (singleton-stream frame)
                 the-empty-stream))
        frame-stream))
(put 'lisp-value 'qeval lisp-value)

(define (execute exp)
     (apply (eval (predicate exp) user-initial-environment)
            (args exp)))