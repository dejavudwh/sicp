#lang scheme

; 因为这两个都符合规则，之所以会出现重复就是因为same符合交换律，所以可以换一个判断过程

(rule (lives-near ?p1 ?p2)
  (and (address ?p1 (?town . ?rest-1))
       (address ?p2 (?town . ?rest-2))
       (not (person>? ?p1 ?p2))))

 (define (person->string person) 
   (if (null? person) 
       "" 
       (string-append (symbol->string (car person)) (person->string (cdr person))))) 
 (define (person>? p1 p2) 
   (string>? (person->sring p1) (person->string p2))) 