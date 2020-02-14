#lang scheme

(define (cont-frac N D K)
    (define (cf k i)
        (if (= k i)
            (/ (N k) (D k))
            (/ (N i) (+ (D i) (cf k (+ i 1))))))
    (cf K 1))

(define (cont-frac N D K)
    (define (cf k result)
        (if (= k 0)
            reulst
            (cf (- k 1) (/ (N k) (+ (D k) result)))))
    (cf (- K 1) (/ (N K) (D K))))