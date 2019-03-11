;; SICP 4.4 Query Interpreter
;; http://mitpress.mit.edu/sicp/full-text/book/book-Z-H-29.html#%_sec_4.4
;; scheme -load logic.scm

;; ==================================================
;; 0 table data structure, see 3.3.3
;; ==================================================

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
                              (cdr subtable)))))
          (set-cdr! local-table
                    (cons (list key-1
                                (cons key-2 value))
                          (cdr local-table)))))
      'ok)
    (define (dispatch m)
      (cond ((eq? m 'lookup-in-database) lookup)
            ((eq? m 'insert-in-database!) insert!)
            (else 
              (error "Unknown operation -- TABLE" m))))
    dispatch))

(define (memo-proc proc)
  (let ((already-run? #f)
        (result #f))
    (lambda ()
      (if (not already-run?)
          (begin (set! result (proc))
                 (set! already-run? #t)
                 result)
          result))))

;;(define-macro (delay exp) `(memo-proc (lambda () ,exp)))

(define (force exp) (exp))

(define the-empty-stream '())

(define stream-null? null?)

;;(define-macro (cons-stream a b)
;;  `(cons ,a (delay ,b)))

(define (stream-car stream)
  (car stream))

(define (stream-cdr stream)
  (force (cdr stream)))

(define (stream-ref s n)
  (if (= n 0)
      (stream-car s)
      (stream-ref (stream-cdr s) (- n 1))))

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      the-empty-stream
      (cons-stream
       (apply proc (map stream-car argstreams))
       (apply stream-map
              (cons proc (map stream-cdr argstreams))))))

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

(define (stream-enumerate-interval low high)
  (if (> low high)
      the-empty-stream
      (cons-stream
       low
       (stream-enumerate-interval (+ low 1) high))))

(define (stream-filter pred stream)
  (cond ((stream-null? stream) the-empty-stream)
        ((pred (stream-car stream))
         (cons-stream (stream-car stream)
                      (stream-filter pred
                                     (stream-cdr stream))))
        (else (stream-filter pred (stream-cdr stream)))))

(define (show-stream s n)
  (if (= n 0)
      (newline)
      (begin
        (display " ")
        (display (stream-car s))
        (show-stream (stream-cdr s) (- n 1)))))
(define database (make-table))
(define get (database 'lookup-in-database))
(define put (database 'insert-in-database!))

;; ==================================================
;; 4.4.4.1 driver loop
;; ==================================================

(define (query-driver-loop)
  (prompt-for-input input-prompt)
  (let ((q (query-syntax-process (read))))
    (cond ((assertion-to-be-added? q)
           (add-rule-or-assertion! (add-assertion-body q))
           (newline)
           (display "Assertion added.")
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

(define input-prompt ";;; Query-input: ")
(define output-prompt ";;; Query-output: ")

(define (prompt-for-input string)
  (newline)
  (newline)
  (display string)
  (newline))

;; copy, replacing vars in expression by vals in the frame
;; recursive because unification could chain eg. ?x: ?y and ?y: 5

(define (instantiate exp frame unbound-var-handler)
  (define (copy exp)
    (cond ((var? exp)
           (let ((binding (binding-in-frame exp frame)))
             (if binding
               (copy (binding-value binding))
               (unbound-var-handler exp frame))))
          ((pair? exp)
           (cons (copy (car exp)) (copy (cdr exp))))
          (else exp)))
  (copy exp))

;; ==================================================
;; 4.4.4.2 evaluator
;; ==================================================

(define (qeval query frame-stream)
  (let ((qproc (get (type query) 'qeval)))
    (if qproc
      (qproc (contents query) frame-stream)
      (simple-query query frame-stream))))

(define (simple-query query-pattern frame-stream)
  (stream-flatmap
    (lambda (frame)
      (stream-append-delayed
        (find-assertions query-pattern frame)
        (delay (apply-rules query-pattern frame))))
    frame-stream))

; handling AND
(define (conjoin conjuncts frame-stream)
  (if (empty-conjunction? conjuncts)
    frame-stream
    (conjoin (rest-conjuncts conjuncts)
             (qeval (first-conjunct conjuncts)
                    frame-stream))))
(put 'and 'qeval conjoin) ;; add to generics table

; handling OR
(define (disjoin disjuncts frame-stream)
  (if (empty-disjunction? disjuncts)
    the-empty-stream
    (interleave-delayed
      (qeval (first-disjunct disjuncts) frame-stream)
      (delay (disjoin (rest-disjuncts disjuncts)
                      (frame-stream))))))
(put 'or 'qeval disjoin) ;; add to generics table

; handling NOT
(define (negate operands frame-stream)
  (stream-flatmap
    (lambda (frame)
      (if (stream-null? (qeval (negated-query operands)
                               (singleton-stream frame)))
        (singleton-stream frame)
        the-empty-stream))
    frame-stream))
(put 'not 'qeval negate) ;; add to generics table

; handling LISP-VALUE
(define (lisp-value call frame-stream)
  (stream-flatmap
    (lambda (frame)
      (if (execute (instantiate call frame
                                (lambda (v f)
                                  (error "Unknown pat var -- LISP-VALUE" v))))
        (singleton-stream frame)
        the-empty-stream))
    frame-stream))
(put 'lisp-value 'qeval lisp-value) ;; add to generics table

(define (execute exp)
  (apply (eval (predicate exp) user-initial-environment)
         (args exp)))

(define (always-true ignore frame-stream) frame-stream)
(put 'always-true 'qeval always-true)

;; ==================================================
;; 4.4.4.3 finding assertions by pattern matching
;; ==================================================

(define (find-assertions pattern frame)
  (stream-flatmap (lambda (datum)
                    (check-an-assertion datum pattern frame))
                  (fetch-assertions pattern frame)))

(define (check-an-assertion assertion query-pattern query-frame)
  (let ((match-result
          (pattern-match query-pattern assertion query-frame)))
    (if (eq? match-result 'failed)
      the-empty-stream
      (singleton-stream match-result))))

(define (pattern-match pat dat frame)
  (cond ((eq? frame 'failed) 'failed)
        ((equal? pat dat) frame)
        ((var? pat) (extend-if-consistent pat dat frame))
        ((and (pair? pat) (pair? dat))
         (pattern-match (cdr pat)
                        (cdr dat)
                        (pattern-match (car pat)
                                       (car dat)
                                       frame)))
        (else 'failed)))

(define (extend-if-consistent var dat frame)
  (let ((binding (binding-in-frame var frame)))
    (if binding
      (pattern-match (binding-value binding) dat frame)
      (extend var dat frame))))

;; ==================================================
;; 4.4.4.4 Rules and unification
;; ==================================================

(define (apply-rules pattern frame)
  (stream-flatmap (lambda (rule)
                    (apply-a-rule rule pattern frame))
                  (fetch-rules pattern frame)))

(define (apply-a-rule rule query-pattern query-frame)
  (let ((clean-rule (rename-variables-in rule)))
    (let ((unify-result
            (unify-match query-pattern
                         (conclusion clean-rule)
                         query-frame)))
      (if (eq? unify-result 'failed)
        the-empty-stream
        (qeval (rule-body clean-rule)
               (singleton-stream unify-result))))))

(define (rename-variables-in rule)
  (let ((rule-application-id (new-rule-application-id)))
    (define (tree-walk exp)
      (cond ((var? exp)
             (make-new-variable exp rule-application-id))
            ((pair? exp)
             (cons (tree-walk (car exp))
                   (tree-walk (cdr exp))))
            (else
              exp)))
    (tree-walk rule)))

(define (unify-match p1 p2 frame)
  (cond ((eq? frame 'failed) 'failed)
        ((equal? p1 p2) frame)
        ((var? p1) (extend-if-possible p1 p2 frame))
        ((var? p2) (extend-if-possible p2 p1 frame)) ;; ***
        ((and (pair? p1) (pair? p2))
         (unify-match (cdr p1)
                      (cdr p2)
                      (unify-match (car p1)
                                   (car p2)
                                   frame)))
        (else
          'failed)))

(define (extend-if-possible var val frame)
  (let ((binding (binding-in-frame var frame))) 
    (cond (binding
            (unify-match (binding-value binding) val frame))
          ((var? val)
           (let ((binding (binding-in-frame val frame)))
             (if binding
               (unify-match var (binding-value binding) frame)
               (extend var val frame))))
          ((depends-on? var val frame) 'failed)
          (else
            (extend var val frame)))))

;; let through only the case where ?y == ?y
;; dodges the infinite loop around ?y == (something ?y)
(define (depends-on? exp var frame)
  (define (tree-walk e)
    (cond ((var? e)
           (if (equal? var e)
             true
             (let ((b (binding-in-frame e frame)))
               (if b
                 (tree-walk (binding-value b))
                 false))))
          ((pair? e)
           (or (tree-walk (car e))
               (tree-walk (cdr e))))
          (else false)))
  (tree-walk exp))
          
;; ==================================================
;; 4.4.4.5 Maintaining the database
;; ==================================================

;; assertions

(define THE-ASSERTIONS the-empty-stream)

;; keep a table of streams to speed lookup
;; each assertion with a constant char the same ends up in the same stream

(define (fetch-assertions pattern frame)
  (if (use-index? pattern)
    (get-indexed-assertions pattern)
    (get-all-assertions)))

(define (get-all-assertions) THE-ASSERTIONS)

(define (get-indexed-assertions pattern)
  (get-stream (index-key-of pattern) 'assertion-stream))

(define (get-stream key1 key2)
  (let ((s (get key1 key2)))
    (if s
      s
      the-empty-stream)))

;; rules

(define THE-RULES the-empty-stream)

;; same indexing idea with rules, but adding a stream for variable cars

(define (fetch-rules pattern frame)
  (if (use-index? pattern)
    (get-indexed-rules pattern)
    (get-all-rules)))

(define (get-all-rules) THE-RULES)

(define (get-indexed-rules pattern)
  (stream-append
    (get-stream (index-key-of pattern) 'rule-stream)
    (get-stream '? 'rule-stream)))

;; populating

(define (add-rule-or-assertion! assertion)
  (if (rule? assertion)
    (add-rule! assertion)
    (add-assertion! assertion)))

(define (add-assertion! assertion)
  (store-assertion-in-index assertion)
  (let ((old-assertions THE-ASSERTIONS))
    (set! THE-ASSERTIONS
      (cons-stream assertion old-assertions))
    'ok))

(define (add-rule! rule)
  (store-rule-in-index rule)
  (let ((old-rules THE-RULES))
    (set! THE-RULES
      (cons-stream rule old-rules))
    'ok))

;; adding assertions

(define (add-rule-or-assertion! assertion)
  (if (rule? assertion)
    (add-rule! assertion)
    (add-assertion! assertion)))

(define (store-assertion-in-index assertion)
  (if (indexable? assertion)
    (let ((key (index-key-of assertion)))
      (let ((current-assertion-stream
              (get-stream key 'assertion-stream)))
        (put key
             'assertion-stream
             (cons-stream assertion
                          current-assertion-stream))))))

(define (store-rule-in-index rule)
  (let ((pattern (conclusion rule)))
    (if (indexable? pattern)
      (let ((key (index-key-of pattern)))
        (let ((current-rule-stream
                (get-stream key 'rule-stream)))
          (put key
               'rule-stream
               (cons-stream rule
                            current-rule-stream)))))))

(define (indexable? pat)
  (or (constant-symbol? (car pat))
      (var? (car pat))))

(define (index-key-of pat)
  (let ((key (car pat)))
    (if (var? key)
      '?
      key)))

(define (use-index? pat)
  (constant-symbol? (car pat)))

;; ==================================================
;; 4.4.4.6 stream operations
;; ==================================================

(define (stream-append-delayed s1 delayed-s2)
  (if (stream-null? s1)
    (force delayed-s2)
    (cons-stream
      (stream-car s1)
      (stream-append-delayed (stream-cdr s1) delayed-s2))))

(define (interleave-delayed s1 delayed-s2)
  (if (stream-null? s1)
    (force delayed-s2)
    (cons-stream
      (stream-car s1)
      (interleave-delayed (force delayed-s2)
                          (delay (stream-cdr s1))))))

(define (stream-flatmap proc s)
  (flatten-stream (stream-map proc s)))

(define (flatten-stream stream)
  (if (stream-null? stream)
    the-empty-stream
    (interleave-delayed
      (stream-car stream)
      (delay (flatten-stream (stream-cdr stream))))))

(define (singleton-stream x)
  (cons-stream x the-empty-stream))

(define (display-stream s)
  (stream-for-each display-line s))

(define (display-line x)
  (newline)
  (display x))

;; ==================================================
;; 4.4.4.7 query syntax bindings
;; ==================================================

(define (type exp)
  (if (pair? exp)
    (car exp)
    (error "Unknown expression TYPE" exp)))

(define (contents exp)
  (if (pair? exp)
    (cdr exp)
    (error "Unknown expression CONTENTS" exp)))

(define (assertion-to-be-added? exp)
  (eq? (type exp) 'assert!))

(define (add-assertion-body exp)
  (car (contents exp)))

(define (empty-conjunction? exps) (null? exps))
(define (first-conjunct exps) (car exps))
(define (rest-conjuncts exps) (cdr exps))
(define (empty-disjunction? exps) (null? exps))
(define (first-disjunct exps) (car exps))
(define (rest-disjuncts exps) (cdr exps))
(define (negated-query exps) (car exps))
(define (predicate exps) (car exps))
(define (args exps) (cdr exps))

(define (rule? statement) (tagged-list? statement 'rule))
(define (conclusion rule) (cadr rule))
(define (rule-body rule)
  (if (null? (cddr rule))
    'always-true
    (caddr rule)))

;; convert query var representation on the way in
;; ?x => pair of symbols (? x)
;; makes it easier to tag later as eg. (? 12 x) to disambiguate within the
;; unification step, see apply-a-rule
(define (query-syntax-process exp)
  (map-over-symbols expand-question-mark exp))

(define (map-over-symbols proc exp)
  (cond ((pair? exp)
         (cons (map-over-symbols proc (car exp))
               (map-over-symbols proc (cdr exp))))
        ((symbol? exp) (proc exp))
        (else exp)))

(define (expand-question-mark symbol)
  (let ((chars (symbol->string symbol)))
    (if (string=? (substring chars 0 1) "?")
      (list '?
            (string->symbol
              (substring chars 1 (string-length chars))))
      symbol)))

(define (tagged-list? exp tag)
  (if (pair? exp)
    (eq? (car exp) tag)
    false))

(define (var? exp) (tagged-list? exp '?))
(define (constant-symbol? exp) (symbol? exp))

(define rule-counter 0)
(define (new-rule-application-id)
  (set! rule-counter (+ 1 rule-counter))
  rule-counter)
(define (make-new-variable var rule-application-id)
  (cons '? (cons rule-application-id (cdr var))))

;; convert query var representation on the way out
;; turns eg. (? 12 x) back into '?x
(define (contract-question-mark variable)
  (string->symbol
    (string-append "?"
                   (if (number? (cadr variable))
                     (string-append (symbol->string (caddr variable))
                                    "-"
                                    (number->string (cadr variable)))
                     (symbol->string (cadr variable))))))

;; ==================================================
;; 4.4.4.8 frames and bindings
;; ==================================================

(define (make-binding variable value) (cons variable value))
(define (binding-variable binding) (car binding))
(define (binding-value binding) (cdr binding))
(define (binding-in-frame variable frame) (assoc variable frame))
(define (extend variable value frame) (cons (make-binding variable value) frame))

;; kickoff the REPL

(query-driver-loop)