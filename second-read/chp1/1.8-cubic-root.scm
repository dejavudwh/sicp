#lang scheme

(require "math.scm")

(define (cube-root x)
    (cube-root-iter 1 x x))

(define (cube-root-iter new-guess old-guess x)
    (if (good-enough? new-guess old-guess)
        new-guess
        (cube-root-iter (improve x new-guess) new-guess x)))

(define (good-enough? new-guess old-guess)
    (> 0.01 
        (abs (/ (- new-guess old-guess)
            old-guess))))

(define (improve x y)
    (/ (+ (/ x (square y))
        (* 2 y)) 
    3))

(cube-root 2)