#lang scheme

 (define (ramanujan s) 
          (define (stream-cadr s) (stream-car (stream-cdr s))) 
          (define (stream-cddr s) (stream-cdr (stream-cdr s))) 
          (let ((scar (stream-car s)) 
                (scadr (stream-cadr s))) 
            (if (= (sum-triple scar) (sum-triple scadr))  
                    (cons-stream (list (sum-triple scar) scar scadr) 
                                       (ramanujan (stream-cddr s))) 
                    (ramanujan (stream-cdr s))))) 
 (define (triple x) (* x x x)) 
 (define (sum-triple x) (+ (triple (car x)) (triple (cadr x)))) 
 (define Ramanujan-numbers 
         (ramanujan (weighted-pairs integers integers sum-triple))) 