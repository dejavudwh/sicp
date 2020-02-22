#lang scheme

(define (make-accumulator initial)
    (let ((num initial))
        (lambda (augend)
            (begin (set! num (+ num augend)) 
                   num))))

(define A (make-accumulator 5))

(A 10)

(A 10)