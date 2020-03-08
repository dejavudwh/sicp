#lang scheme

(define (make-new-machine) 
  (let ((pc (make-register 'pc)) 
            (flag (make-register 'flag)) 
            (stack (make-stack)) 
            (the-instruction-sequence '()) 
            (instruction-number 0))                           ;; *** 
   (define (print-instruction-number)                   ;; *** 
    (display (list "current instruction number is: " instruction-number)) 
    (set! instruction-number 0) 
    (newline)) 
   (let ((the-ops 
                  (list (list 'initialize-stack 
                                   (lambda () (stack 'initialize))) 
                        (list 'print-stack-statistics  
                                       (lambda () (stack 'print-statistics))))) 
             (register-table       
           (list (list 'pc pc) (list 'flag flag)))) 
    (define (allocate-register name) 
         (if (assoc name register-table) 
             (error "Multiply defined register: " name) 
                 (set! register-table 
                       (cons (list name (make-register name)) 
                                 register-table))) 
         'register-allocated) 
    (define (lookup-register name) 
         (let ((val (assoc name register-table))) 
          (if val 
              (cadr val) 
                  (begin 
                   (allocate-register name) 
                   (lookup-register name))))) 
    (define (execute) 
         (let ((insts (get-contents pc))) 
           ((instruction-execution-proc (car insts))) 
           (set! instruction-number (+ instruction-number 1))     ;; *** 
           (execute))) 
         (define (dispatch message) 
          (cond ((eq? message 'start) 
                         (set-contents! pc the-instruction-sequence) 
                         (execute)) 
                ((eq? message 'install-instruction-sequence) 
                         (lambda (seq) (set! the-instruction-sequence seq))) 
                    ((eq? message 'allocate-register) allocate-register) 
                    ((eq? message 'get-register) lookup-register) 
                    ((eq? message 'install-operations) 
                         (lambda (ops) (set! the-ops (append the-ops ops)))) 
                    ((eq? message  'instruction-number) print-instruction-number)           ;;*** 
                    ((eq? message 'stack) stack) 
                    ((eq? message 'operations) the-ops) 
                    (else (error "Unkown request -- MACHINE" message)))) 
         dispatch))) 