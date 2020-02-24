#lang scheme

; 假设a1 a2初始是0 1

; a1变为1，(0, 1) -> (1, 1) 这时候先会调用这个action，new-value就变成了1，然后再把action放到agenda里
; a2变为0，(1, 1) -> (1, 0) new-value就变成了0

; 然后由于这个是后进先出的，所以会先执行action2，这时候new-value还是0
; 继续执行action1，new-value就变成了1，所以显然调换顺序是不行的