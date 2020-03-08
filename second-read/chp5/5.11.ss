#lang scheme

; a)

(assign n (reg val)) 
(restore val) 

->  (restore n) 


; b)

(define (make-save inst machine stack pc) 
   (let ((reg (get-register machine 
                            (stack-inst-reg-name inst)))) 
     (lambda () 
       (push stack (cons (stack-inst-reg-name inst) (get-contents reg))) 
       (advance-pc pc)))) 
  
(define (make-restore inst machine stack pc) 
   (let* ((reg-name (stack-inst-reg-name inst)) 
          (reg (get-register machine reg-name))) 
     (lambda () 
          (let ((pop-reg (pop stack)))  
           (if (eq? (car pop-reg) reg-name) 
                (begin 
                    (set-contents! reg (cdr pop-reg))     
                    (advance-pc pc)) 
                (error "the value is not from register:" reg-name)))))) 