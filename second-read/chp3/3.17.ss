#lang scheme

; 函数式

(define (count-pairs x)
    (length (inner x '())))

(define (inner x memo-list)
    (if (and (pair? x)
             (false? (memq x memo-list)))
        (inner (car x)
               (inner (cdr x)
                      (cons x memo-list)))
        memo-list))

; 命令式

(define (count-pairs l)
    (define memo-list '())
    (define (iter x)
        (if (and (pair? x)
                 (false? (memq x memo-list)))
            (begin (set! memo-list (cons x memo-list))
                   (iter (car x))
                   (iter (cdr x)))
            (length memo-list)))
    (iter l))
    

(count-pairs (cons (cons 1 2) (cons 3 4)))
(define x (cons 1 2))
(count-pairs (cons x x))