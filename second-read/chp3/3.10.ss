#lang scheme

; 本质上就是每次的参数传递都创建了一个环境
; lambda (balance) 会立即执行，返回了一个函数，这个函数指向的环境就包含着balance

(define make-withdraw
    (lambda (initial-amount)
        ((lambda (balance)
            (lambda (amount)
                (if (>= balance amount)
                    (begin (set! balance (- balance amount))
                           balance)
                    "Insufficient funds")))
         initial-amount)))