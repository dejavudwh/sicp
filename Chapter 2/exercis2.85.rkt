 (put 'project 'rational
      (lambda (x) (make-scheme-number (round (/ (number x) (denom x))))))

 (put 'project 'real 
      (lambda (x)  
        (let ((rat (rationalize  
                     (inexact->exact x) 1/100))) 
          (make-rational 
            (numerator rat) 
            (denominator rat)))))

 (put 'project 'complex 
      (lambda (x) (make-real (real-part x))))

 (define (drop x)
   (let ((project-proc (get 'project (type-tag x))))
     (if projext-proc
         (let ((project-number (project-proc (contents x))))
           (if (equ? project-number (raise project-number))
               (drop project-number)
               x))
         x)))