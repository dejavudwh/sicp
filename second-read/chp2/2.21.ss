#lang scheme

(require "../chp1/math.ss")

(define (square-list item)
    (if (null? item)
        (list)
        (cons (square (car item)) 
            (square-list (cdr item)))))

(define (square-list2 items)
  (map square items))

(square-list2 (list 1 2 3 4))