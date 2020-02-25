#lang scheme

(define (sqrt-stream x)
    (define guesses
        (cons-stream 1.0
                     (stream-map (lambda (guess)
                                     (sqrt-improve guess x))
                                 guesses)))
    guesses)

(define (sqrt-stream x)
    (cons-stream 1.0
                 (stream-map (lambda (guess)
                                 (sqrt-improve guess x))
                             (sqrt-stream x))))

; 第一个版本的sqrt-stream用一个变量guesses持有流，所以每次流进行运算的时候都可以用到之前保存的值

; 但是第二个版本用的是函数调用，所以每一次运行都需要从头开始运算

; 所以如果不用memo-proc其实两个的复杂度都是O(n2)