#lang scheme

; a)
(define (lookup-variable-value var env)
  (define (env-loop env)
    (define (scan vars vals)
      (cond ((null? vars)
              (env-loop (enclosing-environment env)))
            ((eq? var (car vars))
              (if (eq? '*unassigned* (car vals))
                (error "Can't access '*unassigned* value " var)
                (car vals)))
            (else (scan (cdr vars) (cdr vals)))))
    (if (eq? env the-empty-environment)
      (error "Unbound variable " var)
      (let ((frame (first-frame env)))
        (scan (frame-variables frame)
              (frame-values frame)))))
  (env-loop env))

; b)
(define (scan-out-defines proc)
  (define (make-unassigned-binding variables)
    (map (lambda (var) (cons var '*unassigned*)) variables))
  (define (iter body non-define-clauses variables set-clauses)
    (if (null? body)
      (make-let (make-unassigned-binding variables)
                (append set-clauses non-define-clauses))
      (let ((first-clause (first-exp body)))
        (if (define? first-clause)
          (iter (rest-exps body)
                non-define-clauses
                (cons (definition-variable first-clause) variables)
                (list set! (definition-variable first-clause) (definition-value first-clause)))
          (iter body
                (cons first-clause non-define-clauses)
                variables
                set-clauses)))))
  (let (body (lambda-body proc))
    (iter body '() '() '())))

; c)

; 应该安装在make-procedure里，不然每次调用都会重复之小红scan-out-defines