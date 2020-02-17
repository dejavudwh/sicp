#lang scheme

(require "./3.38.ss")

(define (reverse sequence)
    (fold-left (lambda (x y)
                   (cons y x))
               '()
               sequence))

(define (reverse sequence)
    (fold-right (lambda (x y)
                    (append y (list x)))
                '()
                sequence))

(reverse (list 1 2 3 4))