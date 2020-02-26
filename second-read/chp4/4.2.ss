#lang scheme

; a)

; 这样(define x 3)就会被当做成一个过程调用

; b)

; 修改一下cond的application子句

(define (application? exp) (tagged-list? exp 'call)) 
(define (operator exp) (cadr exp)) 
(define (operands exp) (cddr exp)) 