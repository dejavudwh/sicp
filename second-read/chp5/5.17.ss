#lang scheme

 ;; add a field to instruction to include label. and change the code in extract-labels 
 (define (make-instruction text) 
  (list text '() '())) 
 (define (make-instruction-with-label text label) 
  (list text label '())) 
 (define (instruction-text inst) 
  (car inst)) 
 (define (instruction-label inst) 
  (cadr inst)) 
 (define (instruction-execution-proc inst) 
  (caddr inst)) 
 (define (set-instruction-execution-proc! inst proc) 
  (set-car! (cddr inst) proc)) 
  
 (define (extract-labels text) 
  (if (null? text) 
      (cons '() '()) 
          (let ((result (extract-labels (cdr text)))) 
           (let ((insts (car result)) (labels (cdr result))) 
            (let ((next-inst (car text))) 
                 (if (symbol? next-inst) 
                     (if (label-exist? labels next-inst) 
                             (error "the label has existed EXTRACT-LABELS" next-inst) 
                         (let ((insts                                                    
                                            (if (null? insts) 
                                                '() 
                                                    (cons (make-instruction-with-label  
                                                                   (instruction-text (car insts)) 
                                                       next-inst) 
                                                      (cdr insts))))) 
                                  (cons insts 
                                    (cons (make-label-entry next-inst insts) labels)))) 
                         (cons (cons (make-instruction next-inst) insts) 
                               labels))))))) 
  
 ;; change the code in execute in make-new-machine 
  (define (execute) 
         (let ((insts (get-contents pc))) 
          (if (null? insts) 
              'done 
                  (begin 
                   (if trace-on 
                       (begin 
                        (if (not (null? (instruction-label (car insts))))                      
                                (begin  
                                     (display (instruction-label (car insts))) 
                                     (newline))) 
                            (display (instruction-text (car insts))) 
                        (newline))) 
                    ((instruction-execution-proc (car insts))) 
                    (set! instruction-number (+ instruction-number 1)) 
                    (execute))))) 