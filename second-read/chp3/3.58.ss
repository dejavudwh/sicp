#lang scheme

(define (expand num den radix)
    (cons-stream
        (quotient (* num radix) den)
        (expand (remainder (* num radix) den) den radix)))

(stream-head (expand 1 7 10) 20)

;Value 13: (1 4 2 8 5 7 1 4 2 8 5 7 1 4 2 8 5 7 1 4)

(stream-head (expand 3 8 10) 20)

;Value 14: (3 7 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0)