#lang scheme

(define (ln2-stream n)
    (cons-stream (/ 1.0 n)
                 (stream-map - (ln2-stream (+ n 1)))))

(define ln2
    (partial-sums (ln2-stream 1)))