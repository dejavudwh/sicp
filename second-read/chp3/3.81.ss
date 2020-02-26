#lang scheme

 (define (rand-generator commands) 
    (define (rand-helper num remaining-commands) 
        (let ((next-command (stream-car remaining-commands))) 
            (cond ((eq? next-command 'generate) 
                    (cons-stream num 
                                (rand-helper (rand-update num) 
                                             (stream-cdr remaining-commands)))) 
                  ((pair? next-command) 
                    (if (eq? (car next-command) 'reset) 
                        (cons-stream (cdr next-command) 
                                     (rand-helper (rand-update next-command)) 
                                                  (stream-cdr remaining-commands))) 
                        (error "bad command -- " next-commmand))) 
             (else (error "bad command -- " next-commmand))))) 
   (rand-helper rand-init commands)) 
  