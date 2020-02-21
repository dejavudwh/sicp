#lang scheme

; a)

; 首先应该不是无法加入数据导向分配，而是没有必要
; (get op type) 这里有点像多态，但是本质就是构建更通用的操作
; 所以通过数据类型来进行不同函数的选择，但是number？这个操作和其它的操作没有什么共通性，所以也没有必要加入数据导向分派

; b)

(define (install-sum-package)

    (define (addend s)
        (car s))

    (define (augend s)
        (cadr s))

    (define (make-sum x y)
        (cond ((=number? x 0)
                y)
              ((=number? y 0)
                x)
              ((and (number? x) (number? y))
                (+ x y))
              (else
                (attach-tag '+ x y))))

    (put 'addend '+ addend)
    (put 'augend '+ augend)
    (put 'make-sum '+ make-sum)

    (put 'deriv '+
        (lambda (exp var)
            (make-sum (deriv (addend exp) var)
                      (deriv (augend exp) var))))

'done)

(define (make-sum x y)
    ((get 'make-sum '+) x y))

(define (addend sum)
    ((get 'addend '+) (contents sum)))

(define (augend sum)
    ((get 'augend '+) (contents sum)))

(define (install-product-package)

    (define (multiplier p)
        (car p))

    (define (multiplicand p)
        (cadr p))

    (define (make-product x y)
        (cond ((or (=number? x 0) (=number? y 0))
                0)
              ((=number? x 1)
                y)
              ((=number? y 1)
                x)
              ((and (number? x) (number? y))
                (* x y))
              (else
                (attach-tag '* x y))))

    (put 'multiplier '* multiplier)
    (put 'multiplicand '* multiplicand)
    (put 'make-product '* make-product)

    (put 'deriv '*
        (lambda (exp var)
            (make-sum
                (make-product (multiplier exp)
                              (deriv (multiplicand exp) var))
                (make-product (deriv (multiplier exp) var)
                              (multiplicand exp)))))

'done)

(define (make-product x y)
    ((get 'make-product '*) x y))

(define (multiplier product)
    ((get 'multiplier '*) (contents product)))

(define (multiplicand product)
    ((get 'multiplicand '*) (contents product)))

; c)

(define (install-exponentiation-package)

    (define (base exp)
        (car exp))

    (define (exponent exp)
        (cadr exp))

    (define (make-exponentiation base n)
        (cond ((= n 0)
                0)
              ((= n 1)
                base)
              (else
                (attach-tag '** base n))))

    (put 'base '** base)
    (put 'exponent '** exponent)
    (put 'make-exponentiation '** make-exponentiation)

    (put 'deriv '**
         (lambda (exp var)
            (let ((n (exponent exp))
                  (u (base exp)))
                (make-product
                    n
                    (make-product
                        (make-exponentiation
                            u
                            (- n 1))
                        (deriv u var))))))

'done)

(define (make-exponentiation base n)
    ((get 'make-exponentiation '**) base n))

(define (base exp)
    ((get 'base '**) (contents exp)))

(define (exponent exp)
    ((get 'exponent '**) (contents exp)))

; d)

; 只要修改put的参数即可