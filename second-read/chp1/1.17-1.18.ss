#lang scheme

; double halve

(define (double n)
  (+ n n))

(define (halve n)
  (/ n 2))

(define (mul a b c)
    (cond ((= b 0)
            c)
          ((even? b)
            (mul a (halve b) (+ c (double a))))
          ((odd? b)
            (mul a (- b 1) (+ c a)))))

(mul 4 7 0)