#lang scheme

(provide square)
(provide inc)
(provide average)

(define (average x y)
    (/ (+ x y) 2))

(define (square x)
    (* x x))

(define (inc x)
    (+ x 1))