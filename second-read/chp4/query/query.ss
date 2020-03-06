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

(define (prompt-for-input string)
   (newline) (newline) (display string) (newline))

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

;;; 

(define (always-true ignore frame-stream) frame-stream)
(put 'always-true 'qeval always-true)


;;; pattern matchs

(define (find-assertions pattern frame)
   (stream-flatmap (lambda (datum)
                        (check-an-assertion datum pattern frame))
                   (fetch-assertions pattern frame)))

(define (check-an-assertion assertion query-pat query-frame)
     (let ((match-result
               (pattern-match query-pat assertion query-frame)))
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


;;; rule

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
                   (else exp)))
            (tree-walk rule)))

(define (unify-match p1 p2 frame)
     (cond ((eq? frame 'failed) 'failed)
            ((equal? p1 p2) frame)
            ((var? p1) (extend-if-possible p1 p2 frame))
            ((var? p2) (extend-if-possible p2 p1 frame))
            ((and (pair? p1) (pair? p2))
                (unify-match (cdr p1)
                             (cdr p2)
                             (unify-match (car p1)
                             (car p2)
                             frame)))
            (else 'failed)))

(define (extend-if-possible var val frame)
    (let ((binding (binding-in-frame var frame)))
        (cond (binding
               (unify-match 
                    (binding-value binding) val frame))
             ((var? val)
               (let ((binding (binding-in-frame val frame)))
                  (if binding
                       (unify-match 
                          var (binding-value binding) frame)
                       (extend var val frame))))
             ((depands-on? val var frame)
               'failed)
             (else (extend var val frame))))) 

(define (depands-on? exp var frame)
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


;;; data-base

(define THE-ASSERTIONS the-empty-stream)   
 
(define (fetch-assertions pattern frame)
    (if (user-index? pattern)
        (get-indexed-assertions pattern)
        (get-all-assertions)))

 (define (get-all-assertions) THE-ASSERTIONS)

 (define (get-indexed-assertions pattern)
      (get-stream (index-key-of pattern) 'assertion-stream))
 
(define (get-stream key1 key2)
    (let ((s (get key1 key2)))
        (if s s the-empty-stream)))


;;; rules

(define THE-RULES the-empty-stream)
(define (fetch-rules pattern frame)
   (if (user-index? pattern)
       (get-indexed-rules pattern)
       (get-all-rules)))

(define (get-all-rules) THE-RULES)

(define (get-indexed-rules pattern)
     (stream-append
          (get-stream (index-key-of pattern) 'rule-stream)
          (get-stream '? 'rule-stream)))
    
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
   (let ((old-rule THE-RULES))
       (set! THE-RULES (cons-stream rule old-rule))
       
    'ok))  

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
      (if (var? key) '? key)))

(define (user-index? pat)
    (constant-symbol? (car pat)))
 

;;; stream 

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


;;; syntax

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

(define (rule? statement)
    (tagged-list? statement 'rule))

(define (conclusion rule) (cadr rule))

(define (rule-body rule)
  (if (null? (cddr rule))
      '(always-true)
      (caddr rule)))
 
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

(define (var? exp)
    (tagged-list? exp '?))

(define (constant-symbol? exp) (symbol? exp))

(define rule-counter 0)

(define (new-rule-application-id)
    (set! rule-counter (+ 1 rule-counter))
    rule-counter)

(define (make-new-variable var rule-application-id)
    (cons '? (cons rule-application-id (cdr var))))

(define (contract-question-mark variable)
    (string->symbol
       (string-append "?"
           (if (number? (cadr variable))
                (string-append (symbol->string (caddr variable))
                               "-"
                               (number->string (cadr variable)))
                (symbol->string (cadr variable))))))

;;; frame

(define (make-binding variable value)
     (cons variable value))

(define (binding-variable binding) (car binding))

(define (binding-value binding) (cdr binding))

(define (binding-in-frame variable frame)
    (assoc variable frame))

(define (extend variable value frame)
    (cons (make-binding variable value) frame))  


;;; eval

;; 区分求值器内部的apply-in-evaluators
;; 这个就是利用lisp原生的基本过程

(define apply-in-underlying-scheme apply)

;;; [eval]

;; 因为Lisp语法自带AST，所以语法分析部分非常少，只有后面那些选择构造函数
;; 这个eval相当于递归下降来遍历AST然后进行解释执行

(define (eval exp env)
  (cond ((self-evaluating? exp) exp)
        ((variable? exp) (lookup-variable-value exp env))
        ((quoted? exp) (text-of-quotation exp))
        ((assignment? exp) (eval-assignment exp env))
        ((definition? exp) (eval-definition exp env))
        ((if? exp) (eval-if exp env))
        ((lambda? exp)
         (make-procedure (lambda-parameters exp)
                         (lambda-body exp)
                         env))
        ((begin? exp) 
         (eval-sequence (begin-actions exp) env))
        ((cond? exp) (eval (cond->if exp) env))
        ((application? exp)
         (apply-in-evaluators (eval (operator exp) env)
                              (list-of-values (operands exp) env)))
        (else
         (error "Unknown expression type -- EVAL" exp))))

;; 这个是用来执行过程的，基本思路就是分为lisp原本就可以提供的基本过程和用户自定义的过程
;; 用户自定义的过程就是extends环境然后eval过程体里的每一条语句

(define (apply-in-evaluators procedure arguments)
  (cond ((primitive-procedure? procedure)
         (apply-primitive-procedure procedure arguments))
        ((compound-procedure? procedure)
         (eval-sequence
           (procedure-body procedure)
           (extend-environment
             (procedure-parameters procedure)
             arguments
             (procedure-environment procedure))))
        (else
         (error
          "Unknown procedure type -- APPLY" procedure))))

;; 求参数

(define (list-of-values exps env)
  (if (no-operands? exps)
      '()
      (cons (eval (first-operand exps) env)
            (list-of-values (rest-operands exps) env))))

;; if

(define (eval-if exp env)
  (if (true? (eval (if-predicate exp) env))
      (eval (if-consequent exp) env)
      (eval (if-alternative exp) env)))

;; sequence

(define (eval-sequence exps env)
  (cond ((last-exp? exps) (eval (first-exp exps) env))
        (else (eval (first-exp exps) env)
              (eval-sequence (rest-exps exps) env))))

;; assginment

(define (eval-assignment exp env)
  (set-variable-value! (assignment-variable exp)
                       (eval (assignment-value exp) env)
                       env)
  'ok)

;; define

(define (eval-definition exp env)
  (define-variable! (definition-variable exp)
                    (eval (definition-value exp) env)
                    env)
  'ok)


;;; [represent] 

;; self-eavluating

(define (self-evaluating? exp)
  (cond ((number? exp) true)
        ((string? exp) true)
        (else false)))

;; quoted

(define (quoted? exp)
  (tagged-list? exp 'quote))

(define (text-of-quotation exp) (cadr exp))

(define (tagged-list? exp tag)
  (if (pair? exp)
      (eq? (car exp) tag)
      false))

;; assignment

(define (variable? exp) (symbol? exp))

(define (assignment? exp)
  (tagged-list? exp 'set!))

(define (assignment-variable exp) (cadr exp))

(define (assignment-value exp) (caddr exp))

;; define

(define (definition? exp)
  (tagged-list? exp 'define))

(define (definition-variable exp)
  (if (symbol? (cadr exp))
      (cadr exp)
      (caadr exp)))

(define (definition-value exp)
  (if (symbol? (cadr exp))
      (caddr exp)
      (make-lambda (cdadr exp)
                   (cddr exp))))

;; lambda

(define (lambda? exp) (tagged-list? exp 'lambda))

(define (lambda-parameters exp) (cadr exp))
(define (lambda-body exp) (cddr exp))

(define (make-lambda parameters body)
  (cons 'lambda (cons parameters body)))

;; if

(define (if? exp) (tagged-list? exp 'if))

(define (if-predicate exp) (cadr exp))

(define (if-consequent exp) (caddr exp))

(define (if-alternative exp)
  (if (not (null? (cdddr exp)))
      (cadddr exp)
      'false))

(define (make-if predicate consequent alternative)
  (list 'if predicate consequent alternative))

;; begin

(define (begin? exp) (tagged-list? exp 'begin))

(define (begin-actions exp) (cdr exp))

(define (last-exp? seq) (null? (cdr seq)))
(define (first-exp seq) (car seq))
(define (rest-exps seq) (cdr seq))

(define (sequence->exp seq)
  (cond ((null? seq) seq)
        ((last-exp? seq) (first-exp seq))
        (else (make-begin seq))))

(define (make-begin seq) (cons 'begin seq))

;; application

(define (application? exp) (pair? exp))
(define (operator exp) (car exp))
(define (operands exp) (cdr exp))

(define (no-operands? ops) (null? ops))
(define (first-operand ops) (car ops))
(define (rest-operands ops) (cdr ops))

;; cond

(define (cond? exp) (tagged-list? exp 'cond))

(define (cond-clauses exp) (cdr exp))

(define (cond-else-clause? clause)
  (eq? (cond-predicate clause) 'else))

(define (cond-predicate clause) (car clause))

(define (cond-actions clause) (cdr clause))

(define (cond->if exp)
  (expand-clauses (cond-clauses exp)))

(define (expand-clauses clauses)
  (if (null? clauses)
      'false                          ; no else clause
      (let ((first (car clauses))
            (rest (cdr clauses)))
        (if (cond-else-clause? first)
            (if (null? rest)
                (sequence->exp (cond-actions first))
                (error "ELSE clause isn't last -- COND->IF"
                       clauses))
            (make-if (cond-predicate first)
                     (sequence->exp (cond-actions first))
                     (expand-clauses rest))))))

;; procedure

(define (make-procedure parameters body env)
  (list 'procedure parameters body env))

(define (compound-procedure? p)
  (tagged-list? p 'procedure))

(define (procedure-parameters p) (cadr p))
(define (procedure-body p) (caddr p))
(define (procedure-environment p) (cadddr p))


;;; The data structure maintained inside the evaluator

;; environment

(define (enclosing-environment env) (cdr env))

(define (first-frame env) (car env))

(define the-empty-environment '())

(define (make-frame variables values)
  (cons variables values))

(define (frame-variables frame) (car frame))
(define (frame-values frame) (cdr frame))

(define (add-binding-to-frame! var val frame)
  (set-car! frame (cons var (car frame)))
  (set-cdr! frame (cons val (cdr frame))))

(define (extend-environment vars vals base-env)
  (if (= (length vars) (length vals))
      (cons (make-frame vars vals) base-env)
      (if (< (length vars) (length vals))
          (error "Too many arguments supplied" vars vals)
          (error "Too few arguments supplied" vars vals))))

(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (car vals))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (set-variable-value! var val env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
             (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
        (error "Unbound variable -- SET!" var)
        (let ((frame (first-frame env)))
          (scan (frame-variables frame)
                (frame-values frame)))))
  (env-loop env))

(define (define-variable! var val env)
  (let ((frame (first-frame env)))
    (define (scan vars vals)
      (cond ((null? vars)
             (add-binding-to-frame! var val frame))
            ((eq? var (car vars))
             (set-car! vals val))
            (else (scan (cdr vars) (cdr vals)))))
    (scan (frame-variables frame)
          (frame-values frame))))

;; Initialize

(define (true? x)
  (not (eq? x false)))

(define (false? x)
  (eq? x false))

(define (primitive-procedure? proc)
  (tagged-list? proc 'primitive))

(define (primitive-implementation proc) (cadr proc))

(define primitive-procedures
  (list (list 'car car)
        (list 'cdr cdr)
        (list 'cons cons)
        (list 'null? null?)
        (list '+ +)
        (list '- -)
        (list '* *)
        (list '/ /)))

(define (primitive-procedure-names)
  (map car
       primitive-procedures))

(define (primitive-procedure-objects)
  (map (lambda (proc) (list 'primitive (cadr proc)))
       primitive-procedures))

(define (apply-primitive-procedure proc args)
  (apply-in-underlying-scheme
   (primitive-implementation proc) args))

(define (setup-environment)
  (let ((initial-env
         (extend-environment (primitive-procedure-names)
                             (primitive-procedure-objects)
                             the-empty-environment)))
    (define-variable! 'true true initial-env)
    (define-variable! 'false false initial-env)
    initial-env))

(define user-initial-environment (setup-environment))

(query-driver-loop)