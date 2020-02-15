#lang scheme

(require "./math.ss")

(define (compose f g)
    (lambda (x)
        (f (g x))))

((compose square inc) 6)