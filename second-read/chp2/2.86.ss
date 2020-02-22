#lang scheme

; 只要把原本的基本运算+ - * /改成通用操作 add sub mul div即可
; 这就是抽象的力量

(define (add-complex z1 z2)
  (make-from-real-imag (add (real-part z1) (real-part z2))
                       (add (imag-part z1) (imag-part z2)))

(define (sub-complex z1 z2)
  (make-from-real-imag (sub (real-part z1) (real-part z2))
                       (sub (imag-part z1) (imag-part z2)))

(define (mul-complex z1 z2)
  (make-from-mag-ang (mul (magnitude z1) (magnitude z2))
                     (add (angle z1) (angle z2)))

(define (div-complex z1 z2)
  (make-from-mag-ang (div (magnitude z1) (magnitude z2))
                     (sub (angle z1) (angle z2)))


(put 'sine 'scheme-number 
  (lambda (x) (tag (sin x)))) 
(put 'cosine 'scheme-number 
  (lambda (x) (tag (cos x)))) 

(put 'sine 'rational 
  (lambda (x) (sine (/ (numer x) (denom x)))))  
(put 'cosine 'rational 
  (lambda (x) (cosine (/ (numer x) (denom x)))))      