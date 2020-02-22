#lang scheme

 (define (install-rational-package) 
     ;; internal procuedures 
     (define (numer x) (car x)) 
     (define (denom x) (cdr x)) 
     (define (make-rat n d) (cons n d)) 
     (define (add-rat x y) 
         (make-rat (add (mul (numer x) (denom y)) 
                        (mul (numer y) (demom x))) 
                   (mul (denom x) (demom y)))) 
     (define (sub-rat x y) 
         (make-rat (sub (mul (numer x) (denom y)) 
                        (mul (numer y) (demom x))) 
                   (mul (denom x) (demom y)))) 
     (define (mul-rat x y) 
         (make-rat (mul (numer x) (numer y)) 
                   (mul (denom x) (denom y)))) 
     (define (div-rat x y) 
         (make-rat (mul (numer x) (denom y)) 
                   (mul (denom x) (numer y)))) 
      
     ;; interface to rest of the system 
     ; same as before 
 ) 
  
 (define p1 (make-polynomial 'x '((2 1) (0 1)))) 
 (define p1 (make-polynomial 'x '((3 1) (0 1)))) 
 (define rf (make-rational p2 p1)) 
  
 (add rf rf) 