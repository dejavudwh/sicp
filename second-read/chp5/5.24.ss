ev-cond 
    (assign expr (op cond-clauses) (reg expr)) 
    (test (op null?) (reg expr))   
    (branch (label ev-cond-end)) 
    (assign unev (op car) (reg expr)) 
    (assign expr (op cdr) (reg expr)) 
    (test (op cond-else-clauses?) (reg unev)) 
    (branch (label cond-else)) 
    (save env) 
    (save continue) 
    (save unev) 
    (save expr) 
    (assign continue (label ev-cond-loop)) 
    (assign expr (op cond-predicate) (reg unev)) 
    (goto (label ev-dispatch)) 
  
ev-cond-loop 
    (restore expr) 
    (test (op true?) (reg val)) 
    (branch (label cond-result)) 
    (restore unev) 
    (restore continue) 
    (restore env) 
    (goto (label ev-cond)) 

cond-result 
    (restore unev) 
    (assign expr (op cond-actions) (reg unev)) 
    (assign expr (op sequence->exp) (reg expr)) 
    (goto (label ev-dispatch)) 
  
cond-else 
    (assign unev (op cond-actions) (reg unev)) 
    (assign expr (op sequence->exp) (reg unev)) 
    (goto (label ev-dispatch)) 
  
ev-cond-end    
    (goto (reg continue)) 
  