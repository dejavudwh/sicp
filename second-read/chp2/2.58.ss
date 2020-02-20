#lang scheme

; a)

(define (make-sum a1 a2)
    (cond ((=number? a1 0)
            a2)
          ((=number? a2 0)
            a1)
          ((and (number? a1) (number? a2))
            (+ a1 a2))
          (else
            (list a1 '+ a2))))              

(define (sum? x)
    (and (pair? x)
         (eq? (cadr x) '+)))                

(define (addend s)
    (car s))                                

(define (augend s)
    (caddr s))

(define (make-product m1 m2)
    (cond ((or (=number? m1 0) (=number? m2 0))
            0)
          ((=number? m1 1)
            m2)
          ((=number? m2 1)
            m1)
          ((and (number? m1) (number? m2))
            (* m1 m2))
          (else
            (list m1 '* m2))))               

(define (product? x)
    (and (pair? x)
         (eq? (cadr x) '*)))                

(define (multiplier p)
    (car p))                             

(define (multiplicand p)
    (caddr p))

; b)

; 如果不写括号的话，就会产生优先级问题，显然只靠谓词、选择函数和构造函数是不能处理优先级问题的
; 优先级问题需要在deriv中处理