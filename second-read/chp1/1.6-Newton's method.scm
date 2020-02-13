#lang scheme

(define (sqrt x)
    (sqrt-iter 1 x))

(define (sqrt-iter guess x)
    (if (good-enough? guess x)
        guess
        (sqrt-iter (improve guess x) x)))

(define (good-enough? guess x)
    (< (abs (- (square guess) x)) 0.001))

(define (improve guess x)
    (average (/ x guess) guess))

(define (average x y)
    (/ (+ x y) 2))

(define (square x)
    (* x x))

(sqrt 0.25)