#lang scheme

(define (cont-frac N D K)
    (define (cf k result)
        (if (= k 0)
            result
            (cf (- k 1) (/ (N k) (+ (D k) result)))))
    (cf (- K 1) (/ (N K) (D K))))

(define (e k)
    (define (N i)
        1)
    (define (D i)
        (if (= 0 (remainder (+ i 1) 3))
            (* 2 (/ (+ i 1) 3))
            1))
    (+ 2.0 
       (cont-frac N D k)))

(e 2)