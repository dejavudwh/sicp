#lang planet neil/sicp 

; 只是因为队列的表示是一个指向首位的cons而已

(define (print-queue queue)
    (car queue))