#lang scheme

; (magnitude z)

; (apply-generic 'magnitude z)

; (map type-tag (list z))         

; (get 'magnitude '(complex))   很显然到这的时候找不到complex类型的magnitude操作了

; apply-generic 调用了两次，第一次调用它剥去数据上的 complex 标示
; 并调用 (install-rectangular-package) 包中的 magnitude 函数
; 第二次调用它剥去数据上的 rectangular 标示，
; 并调用 (install-rectangular-package) 包中的 magnitude 函数。

