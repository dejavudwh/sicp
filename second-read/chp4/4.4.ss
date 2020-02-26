#lang scheme

; and

(define (and->if exp)
    (if (null? exp)
        'true
        (make-if (not (car exp))
                 'false
                 (and->if (cdr exp)))))

(define (eval-and exps env)
    (cond ((null? exps)
            true)
          ((last-exp? (first-exp exps))
            (eval (first-exp exps)))
          ((true? (eval (first-exp exps) env))
            (eval-and (rest-exp exps) env))
          (else
            false)))

; or

(define (or->if exp)
    (if (null? exp)
        'false
        (make-if (car exp)
                 'true
                 (or->if (cdr exp)))))
                
(define (eval-or exps env)
    (cond ((null? exps)
            true)
          ((true? (eval (first-exp exps) env))
            (eval-or (rest-exp exps) env))
          (else
            false)