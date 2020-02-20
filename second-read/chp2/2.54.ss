#lang scheme

(define (equal? a b)
  (cond ((and (symbol? a) (symbol? b)) 
            (eq? a b))
        ((and (null? a) (null? b))
            #t)  
        ((or (null? a) (null? b)) 
            #f)    
        ((and (list? a) (list? b)) 
            (and (equal? (car a) (car b))
                 (equal? (cdr a) (cdr b))))
        (else
            #f)))

(equal? '(this (is a) list) '(this (is a) list))
