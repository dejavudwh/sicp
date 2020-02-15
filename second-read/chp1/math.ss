#lang scheme

(provide square)
(provide inc)

(define (average x y)
    (/ (+ x y) 2))

(define (square x)
    (* x x))

(define (inc x)
    (+ x 1))