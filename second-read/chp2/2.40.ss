#lang scheme

(define (enumerate-interval start end)
    (if (> start end)
        '()
        (cons start (enumerate-interval (+ 1 start) end))))

(define (accumulate op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (accumulate op initial (cdr sequence)))))

(define (unique-pairs n)
    (accumulate append
            '()
            (map (lambda (i)
                     (map (lambda (j) (list i j))
                          (enumerate-interval 1 (- i 1))))
                 (enumerate-interval 1 n))))

(unique-pairs 9)