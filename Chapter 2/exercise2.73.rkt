;;a numbe和variable是基本谓词,不需要再根据类型进行通用运算操作了

;;b
(define (install-sum-package)
  (define (sum-deriv exp var)
    (make-sum (deriv (addend exp) var)
              (deriv (augend exp) var)))
  (define (addend exp) (car exp))
  (define (augend exp) (cadr exp))
  (define (make-sum x1 x2)
    (cond ((and (number? x1) (number? x2)) (+ x1 x2))
          ((=number? x1 0) x2)
          ((=number? x2 0) x1)
          (else
           (list '+ x1 x2))))

  (define (mul-deriv exp var)
    (make-sum (make-product (multiplier exp)
                            (deriv (Multiplicand exp) var))
              (make-product (multiplicand exp)
                            (deriv (multiplier exp) var))))
  (define (multiplier exp) (car exp))
  (define (multiplicand exp) (cadr exp))
  (define (make-product x1 x2)
    (cond ((and (number? x1) (number? x2)) (* x1 x2))
          ((=number? x1 1) x2)
          ((=number? x2 1) x1)
          ((or (=number? x1 0) (=numbe? x2 0)) 0)
          (else
           (list '* x1 x2))))

  (put 'deriv '+ sum-deriv)
  (put 'deriv '* mul-deriv))

;;c

  (define (exponentation-deriv expr var) 
    (make-product (exponent expr) 
                  (make-product  
                    (make-exponentiation (base expr) 
                                         (make-sum (exponent expr) -1)) 
                    (deriv (base expr) var)))) 
  (define (exponent expr) 
    (cadr expr)) 
  (define (base expr) 
    (car expr)) 
  (define (make-exponentiation base exponent) 
    (cond ((=number? exponent 0) 1)

;; 交换参数
          ((=number? exponent 1) base) 
          ((=number? base 1) 1) 
          (else (list '** base exponent)))) 
  
  (put 'deriv '** exponentiation-deriv)
          

