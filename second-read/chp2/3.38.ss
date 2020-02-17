#lang scheme
; fold-left和fold-right的本质区别就是结合顺序不一样
; 所以只要符合结合律的操作符都可以让它们的结果相同
; * - + or and 都可以

(provide fold-left)
(provide fold-right)

(define (fold-left op initial sequence)
    (define (iter result rest)
        (if (null? rest)
            result
            (iter (op result (car rest))
                  (cdr rest))))
    (iter initial sequence))

(define (fold-right op initial sequence)
    (if (null? sequence)
        initial
        (op (car sequence)
            (fold-right op initial (cdr sequence)))))