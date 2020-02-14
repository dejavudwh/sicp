#lang scheme

(define (sum term a next b)
    (define (iter a result)
        (if (> a b)
            result
            (iter (next a) 
                  (+ result (term b)))))
    (iter a 0))