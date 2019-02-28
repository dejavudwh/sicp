(define (split op1 op2)
  (lambda (paiter n)
    (cond ((= n 0) painter)
          (else
           (let ((smaller ((split op1 op2) painter (- n 1))))
             (op1 painter (op2 smaller smaller)))))))
               