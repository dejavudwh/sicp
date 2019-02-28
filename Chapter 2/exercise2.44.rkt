(define (up-split painter n) 
   (cond ((= n 0) painter) 
         (else 
          (let ((smaller (up-split painter (- n 1)))) 
            (below painter (beside smaller smaller)))))) 