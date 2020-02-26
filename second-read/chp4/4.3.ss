#lang scheme

(define (eval exp env)
    (if (self-evaluating? exp)
        exp
        (let ((proc (get 'eval (type-tag exp))))
            (proc (content exp)
                       env))))

; put就懒得写了，和之前的一样