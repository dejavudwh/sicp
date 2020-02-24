#lang scheme

; 因为把延时处理加入到待处理表的过程在after-delay里调用，而after-delay又在action里调用
; 所以就必须先调用action