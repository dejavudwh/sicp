#lang scheme

(require "2.2.ss")

(define (make-rectangle left-point right-point)
    (cons left-point right-point))

(define (left-point rect)
    (car rect))

(define (right-point rect)
    (cdr rect))

(define (rect-perimeter rect)
    (let ((p1 (left-point rect))
          (p2 (right-point rect)))
        (* 2 (+ (- (x-point p2) (x-point p1))
                (- (y-point p1) (y-point p2))))))

(define p1 (make-point 3 5))
(define p2 (make-point 5 4))
(define r (make-rectangle p1 p2))

(rect-perimeter r)
