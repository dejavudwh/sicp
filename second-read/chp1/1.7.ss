#lang scheme

; 根据之前的good-enough来判断，过小的数字不能得出正确答案，过大的数字会耗费不可承担的时间
; 所以根据书上来修改good-enough，通过新老猜测值的变化比率还判断

(define (sqrt x)
    (sqrt-iter 1 x x))

(define (sqrt-iter new-guess old-guess x)
    (if (good-enough? new-guess old-guess)
        new-guess
        (sqrt-iter (improve new-guess x) new-guess x)))

(define (good-enough? new-guess old-guess)
    (> 0.01 
        (abs (/ (- new-guess old-guess)
            old-guess))))

(define (improve guess x)
    (average (/ x guess) guess))

(define (average x y)
    (/ (+ x y) 2))

(define (square x)
    (* x x))

(sqrt 0.00009)