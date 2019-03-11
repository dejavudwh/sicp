  
 (define fact-machine 
   (make-machine 
    '(c p n) 
    (list (list '* *) (list '+ +) (list '> >)) 
    '((assign c (const 1)) 
      (assign p (const 1)) 
      test-n 
      (test (op >) (reg c) (reg n)) 
      (branch (label fact-done)) 
      (assign p (op *) (reg c) (reg p)) 
      (assign c (op +) (reg c) (const 1)) 
      (goto (label test-n)) 
      fact-done))) 
  
 (set-register-contents! fact-machine 'n 5) 
 (start fact-machine) 
  
 (get-register-contents fact-machine 'p) 
 =>120 