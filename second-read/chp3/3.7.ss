#lang scheme 
 
 (define (make-account balance password) 
  
     (define (withdraw amount) 
         (if (>= balance amount) 
             (begin (set! balance (- balance amount)) balance) 
             "Insufficient funds")) 
      
     (define (deposit amount) 
         (set! balance (+ balance amount)) 
         balance) 
      
     (define (dispatch pwd m) 
         (if (eq? m 'auth) 
             (lambda () (eq? pwd password)) 
             (if (eq? pwd password) 
                 (cond ((eq? m 'withdraw) withdraw) 
                       ((eq? m 'deposit) deposit) 
                       (else (error "Unknown request -- MAKE-ACCOUNT" m))) 
                 (error "Incorrect password")))) 
      
     dispatch) 
  
 (define (make-joint account orig-pwd joint-pwd) 
  
     (define (withdraw amount) ((account orig-pwd 'withdraw) amount)) 
     (define (deposit amount) ((account orig-pwd 'deposit) amount)) 
  
     (define (dispatch pwd m) 
         (if (eq? m 'auth) 
             (lambda () (eq? pwd joint-pwd)) 
             (if (eq? pwd joint-pwd) 
                 (cond ((eq? m 'withdraw) withdraw) 
                       ((eq? m 'deposit) deposit) 
                       (else (error "Unknown request -- MAKE-ACCOUNT" m))) 
                 (error "Incorrect password")))) 
  
     (if ((account orig-pwd 'auth)) 
         dispatch 
         (error "Incorrect original password of target account"))) 
  
 ; test 
 (define peter-acc (make-account 100 'open-sesame)) 
 (define paul-acc (make-joint peter-acc 'open-sesame 'rosebud)) ;joint account 
 (define woofy-acc (make-joint paul-acc 'rosebud 'longleg)) ; joint joint account 
  
 ((peter-acc 'open-sesame 'withdraw) 50) ;50 
 ((paul-acc 'rosebud 'withdraw) 10) ;40 
 ((peter-acc 'open-sesame 'deposit) 0) ;40 
 ((woofy-acc 'longleg 'withdraw) 33) ;7 
 ((peter-acc 'open-sesame 'deposit) 0) ;7 
  
 ((woofy-acc 'rosebud 'withdraw) 100) ;wrong pwd 
 ((woofy-acc 'open-sesame 'withdraw) 100) ;wrong pwd 
  