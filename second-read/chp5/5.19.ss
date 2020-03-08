#lang scheme

organ

  ;; using a list to contain break points, every element in the list   
  ;; is a pair containing the label and line.  the code changed   
  ;; had been marked.  
  (define (make-new-machine)  
   (let ((pc (make-register 'pc))  
             (flag (make-register 'flag))  
             (stack (make-stack))  
             (the-instruction-sequence '())  
             (instruction-number 0)  
             (trace-on false)  
             (labels '())                                            ;; ***  
             (current-label '*unassigned*)             ;; ***  
             (current-line 0)                                    ;; ***  
             (breakpoint-line 0)                              ;; ***  
             (break-on true))                                   ;; ****  
    (let ((the-ops  
                   (list (list 'initialize-stack  
                                    (lambda () (stack 'initialize)))  
                         (list 'print-stack-statistics   
                                        (lambda () (stack 'print-statistics)))))  
              (register-table        
            (list (list 'pc pc) (list 'flag flag))))  
    (define (print-instruction-number)  
     (display (list "current instruction number is: " instruction-number))  
     (set! instruction-number 0)  
     (newline))  
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
           (if (null? insts)  
               'done  
                   (begin                                                 ;; ***  
                    (if (and (not (null? (instruction-label (car insts))))  
                                 (assoc (instruction-label (car insts)) labels))  
                        (begin  
                             (set! current-label (instruction-label (car insts)))  
                             (set! breakpoint-line (cdr (assoc current-label labels)))  
                             (set! current-line 0)))  
                    (set! current-line (+ current-line 1))  
                    (if (and (= current-line breakpoint-line) break-on)  
                        (begin   
                             (set! break-on false)  
                         (display (list "breakpoint here" current-label current-line)))  
                        (begin  
                             (if trace-on  
                                  (begin  
                                   (display (instruction-text (car insts)))  
                           (newline)))  
                             (set! break-on true)                                    ;; ***  
                         ((instruction-execution-proc (car insts)))  
                         (set! instruction-number (+ instruction-number 1))  
                         (execute)))))))  
          (define (cancel-breakpoint label)                                 ;; ***  
           (define (delete-label acc-labels orig-labels)  
            (cond ((null? orig-labels)  
                           (error "the label is not in the machine -- CANCEL-REAKPOINT" label))  
                  ((eq? (caar orig-labels) label) (append acc-labels (cdr orig-labels)))  
                      (else (delete-label (cons (car orig-labels) acc-labels) (cdr orig-labels)))))  
           (set! labels (delete-label '() labels)))  
          (define (dispatch message)  
           (cond ((eq? message 'start)  
                          (set-contents! pc the-instruction-sequence)  
                          (execute))  
                 ((eq? message 'install-instruction-sequence)  
                          (lambda (seq) (set! the-instruction-sequence seq)))  
                     ((eq? message 'allocate-register) allocate-register)  
                     ((eq? message 'trace-on) (set! trace-on true))  
                     ((eq? message 'trace-off) (set! trace-on false))  
                     ((eq? message 'get-register) lookup-register)  
                     ((eq? message 'install-operations)  
                          (lambda (ops) (set! the-ops (append the-ops ops))))  
                     ((eq? message 'instruction-number) print-instruction-number)  
                     ((eq? message 'stack) stack)  
                     ((eq? message 'operations) the-ops)  
                     ((eq? message 'set-breakpoint)                           ;; ***  
                          (lambda (label n) (set! labels (cons (cons label n) labels))))  
                     ((eq? message 'cancel-breakpoint)                     ;; ***  
                          (lambda (label) (cancel-breakpoint label)))  
                     ((eq? message 'cancel-all-breakpoint) (set! labels '()))  
                     ((eq? message 'process-machine) (execute))     ;; ***  
                     (else (error "Unkown request -- MACHINE" message))))  
          dispatch)))  
    
  (define (set-breakpoint machine label n)  
   ((machine 'set-breakpoint) label n))  
  (define (cancel-breakpoint machine label)  
   ((machine 'cancel-breakpoint) label))  
  (define (cancel-all-breakpoint machine)  
   (machine 'cancel-all-breakpoint))  
  (define (process-machine machine)  
   (machine 'process-machine))  