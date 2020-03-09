 ; cond
 
(test (op cond?) (reg expr)) 
(branch (label ev-cond)) 
  
ev-cond 
    (assign expr (op cond->if) (reg expr)) 
    (goto (label ev-if)) 

; let

(test (op let?) (reg exp)) 
(branch (label ev-let)) 
  
ev-let 
    (assign exp (op let->combination) (reg exp)) 
    (goto (label ev-lambda)) 