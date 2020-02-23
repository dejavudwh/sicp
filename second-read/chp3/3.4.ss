#lang scheme

(define (make-account balance password) 
   (define bad-password-count 0) 
   (define (correct-password? p) 
     (if (eq? p password) 
         (set! bad-password-count 0) 
         (begin 
           (if (= bad-password-count 7) 
               (call-the-cops) 
               (set! bad-password-count (+ bad-password-count 1))) 
           (display "Incorrect password") 
           #f))) 
   (define (withdraw amount) 
     (if (>= balance amount) 
         (begin (set! balance (- balance amount)) 
                balance) 
         "Insufficient funds")) 
   (define (deposit amount) 
     (set! balance (+ balance amount)) 
     balance) 
   (define (dispatch p m) 
     (if (correct-password? p) 
         (cond 
           ((eq? m 'withdraw) withdraw) 
           ((eq? m 'deposit) deposit) 
           (else (error "Unknown request -- MAKE-ACCOUNT" m))) 
         (lambda (x) (display "")))) 
   dispatch) 