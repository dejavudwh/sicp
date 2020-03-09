#lang scheme

;  a)

 ev-application 
   (save continue) 
   (assign unev (op operands) (reg exp)) 
   (assign exp (op operator) (reg exp)) 
   (test (op symbol?) (reg exp))                    
   (branch (label ev-appl-operator-symbol)) 
   (save env) 
   (save unev) 
   (assign continue (label ev-appl-did-operator)) 
   (goto (label eval-dispatch)) 
 ev-appl-operator-symbol 
   (assign continue (label ev-appl-did-operator-no-restore)) 
   (goto (label eval-dispatch)) 
 ev-appl-did-operator 
   (restore unev)             
   (restore env) 
 ev-appl-did-operator-no-restore 
   (assign argl (op empty-arglist)) 
   (assign proc (reg val))     ; the operator 
   (test (op no-operands?) (reg unev)) 
   (branch (label apply-dispatch)) 
   (save proc) 