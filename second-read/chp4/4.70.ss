#lang scheme

; 使用let是为了强迫对THE-ASSERTIONS求一次值

; 如果使用本题的(set! THE-ASSERTIONS (cons-stream assertions THE-ASSERTIONS))

; 在求值(cdr THE-ASSERTIONS)的时候永远只会得到assertions