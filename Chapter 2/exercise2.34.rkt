 (define (horner-eval x coefficient-sequence) 
   (accumulate (lambda (this-coeff accum-sum) 
                 (+ this-coeff 
                    (* x accum-sum))) 
               0 
               coefficient-sequence))