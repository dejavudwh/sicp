#lang scheme

(require "./math.ss")

(define (repeated f n)
    (if (< n 1)
        f
        (repeated (lambda (x)
                    (f (f x))) 
            (- n 2))))

((repeated square 2) 5)