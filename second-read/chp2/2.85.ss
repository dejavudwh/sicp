#lang scheme

 (define (install-scheme-number-package) 
  ;; ... 
  (put 'project 'scheme-number
    (lambda (x) (make-rational x 1)))
  
  'done)

(define (install-rational-package) 
  ;; ... 
  (put 'project 'rational
    (lambda (x) 
      (make-scheme (round (/ (numer x) (denom x))))))

  'done) 

(define (install-real-package)   
  ;; ... 
  (put 'project 'real
    (lambda (x) (round x)))

  'done)

(define (type-val t) 
  (cond
    ((eq? t 'scheme-number) 1)
    ((eq? t 'rational) 2)
    ((eq? t 'real) 3)
    ((eq? t 'complex) 4)
    (else (error "No such type" t))))

(define (raise-to-complex x)
    (if ((eq? (type-tag x) 'complex')
        x)
        (raise-to-complex (raise x))))

(define (equal? x y)
    (let ((cx (raise-to-complex x)
          (cy (raise-to-complex y))))
        (equ? cx cy)))  ; 这里的equ?就是之前2.79实现的equ?了

(define (drop x)
    (let ((lower-x (project x))
        (if (equal? (raise lower-x) x)
            (drop lower-x)
            x)))

