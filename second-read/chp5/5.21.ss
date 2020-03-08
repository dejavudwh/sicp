#lang scheme

  
 ;; a. 
 (define (not-pair? lst) 
   (not (pair? lst))) 
  
 (define count-leaves 
   (make-machine 
    `((car ,car) (cdr ,cdr) (null? ,null?) 
                 (not-pair? ,not-pair?) (+ ,+)) 
    '( 
      start 
        (assign continue (label done)) 
        (assign n (const 0)) 
      count-loop 
        (test (op null?) (reg lst)) 
        (branch (label null)) 
        (test (op not-pair?) (reg lst)) 
        (branch (label not-pair)) 
        (save continue) 
        (assign continue (label after-car)) 
        (save lst) 
        (assign lst (op car) (reg lst)) 
        (goto (label count-loop)) 
      after-car 
        (restore lst) 
        (assign lst (op cdr) (reg lst)) 
        (assign continue (label after-cdr)) 
        (save val) 
        (goto (label count-loop)) 
      after-cdr 
        (restore n) 
        (restore continue) 
        (assign val 
                (op +) (reg val) (reg n)) 
        (goto (reg continue)) 
      null 
        (assign val (const 0)) 
        (goto (reg continue)) 
      not-pair 
        (assign val (const 1)) 
        (goto (reg continue)) 
      done))) 
  
 ;; b. 
  
 (define count-leaves 
   (make-machine 
    `((car ,car) (cdr ,cdr) (pair? ,pair?) 
                 (null? ,null?) (+ ,+)) 
    '( 
      start 
        (assign val (const 0)) 
        (assign continue (label done)) 
        (save continue) 
        (assign continue (label cdr-loop)) 
      count-loop 
        (test (op pair?) (reg lst)) 
        (branch (label pair)) 
        (test (op null?) (reg lst)) 
        (branch (label null)) 
        (assign val (op +) (reg val) (const 1)) 
        (restore continue) 
        (goto (reg continue)) 
      cdr-loop 
        (restore lst) 
        (assign lst (op cdr) (reg lst)) 
        (goto (label count-loop)) 
      pair 
        (save lst) 
        (save continue) 
        (assign lst (op car) (reg lst)) 
        (goto (label count-loop)) 
      null 
        (restore continue) 
        (goto (reg continue)) 
      done))) 