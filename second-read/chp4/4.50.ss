#lang scheme

 (define (analyze-ramb exp) 
   (define (list-ref-and-delete ref lst)        ; get random item from list. 
     (define (loop count prev-items rest-items) ; and return a list with the 
       (if (= count 0)                          ; random item as its car 
           (cons (car rest-items)               ; and the rest of the list as the cdr 
                 (append prev-items (cdr rest-items))) 
           (loop (- count 1)                    ; this will mangle the list every time 
                 (cons (car rest-items)         ; creating a "random" amb.  
                       prev-items) 
                 (cdr rest-items)))) 
     (if (null? lst) 
         '() 
         (loop ref '() lst))) 
   (let ((cprocs (map analyze (amb-choices exp)))) 
     (lambda (env succeed fail) 
       (define (try-next choices) 
         (if (null? choices) 
               (fail) 
               (let ((randomized (list-ref-and-delete 
                                  (random (length choices)) 
                                  choices))) 
                 ((car randomized) env 
                                   succeed 
                                   (lambda () 
                                     (try-next (cdr randomized))))))) 
       (try-next cprocs)))) 
  