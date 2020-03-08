#lang scheme

 (define (trace-on-register machine register-name) 
   ((get-register machine register-name) 'trace-on) 
   'trace-on) 
 (define (trace-off-register machine register-name) 
   ((get-register machine register-name) 'trace-off) 
   'trace-off) 
  
 (define (make-register name) 
  (let ((contents '*unassigned*) 
            (trace? false)) 
   (define (dispatch message) 
    (cond ((eq? message 'get) contents) 
           ((eq? message 'set) 
                (lambda (value)  
                (if trace? 
                    (begin 
                        (display name) 
                        (display " ") 
                        (display contents) 
                        (display " ") 
                        (display value) 
                        (newline) 
                        (set! contents value)) 
                        (set! contents value)))) 
            ((eq? message 'trace-on) 
                (set! trace? true)) 
                ((eq? message 'trace-off) 
                (set! trace? false)) 
            (else 
                (error "Unkown request -- REGISTER" message)))) 
   dispatch)) 