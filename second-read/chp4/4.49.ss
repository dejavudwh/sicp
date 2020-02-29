#lang scheme

 (define (list-amb li) 
    (if (null? li) 
        (amb) 
        (amb (car li) (list-amb (cdr li))))) 
  
 (define (parse-word word-list) 
    (if (null? word-list)
        (amb)
        (amb (car word-list) (parse-word (cdr word-list)))))