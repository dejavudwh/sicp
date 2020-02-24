#lang scheme

(define (c- x y)
    (let ((sub (make-connector)))
        (adder y sub x)
        sub))

(define (c* x y)
    (let ((product (make-connector)))
        (multiplier x y product)
        product))

(define (c/ p q)
    (let ((r (make-connector)))
        (multiplier q r p)
        r))