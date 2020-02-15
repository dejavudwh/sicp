#lang scheme

(require "../chp1/math.ss")

(provide make-point)
(provide x-point)
(provide y-point)

(define (make-point x y)
    (cons x y))

(define (x-point p)
    (car p))

(define (y-point p)
    (cdr p))

(define (make-segment p1 p2)
    (cons p1 p2))

(define (start-segment s)
    (car s))

(define (end-segment s)
    (cdr s))

(define (midpoint-segment seg)
    (let ((start (start-segment seg))
          (end (end-segment seg)))
        (make-point (average (x-point start)
                             (x-point end))
                    (average (y-point start)
                             (y-point end)))))

(define (print-point p)
    (newline)
    (display "(")
    (display (x-point p))
    (display ",")
    (display (y-point p))
    (display ")"))