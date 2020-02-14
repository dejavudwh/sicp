#lang scheme

(define (simpson f a b n)
    (define h (/ (- b a) n))
    (define (factor a)
        (cond ((or (= a 0) (= a n))
              1)
              ((even? a)
              2)
              ((odd? a)
              4)))
    (define (yk k)
        (f (+ a (* k h))))
    (define (iter-y k)
        (if (= k n)
            (yk k)
            (+ (* (factor k) (yk k)) (iter-y (+ k 1)))))
    (* (/ h 3) (iter-y 0)))

(define (cube x)
    (* x x x))

(simpson cube 0 1 1000)