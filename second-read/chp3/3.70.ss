#lang scheme

 (define (merge-weighted s1 s2 compare) 
   (cond ((stream-null? s1) s2) 
         ((stream-null? s2) s1) 
         (else 
          (let ((s1car (stream-car s1)) 
                (s2car (stream-car s2))) 
            (let ((w1 (compare s1car)) 
                  (w2 (compare s2car))) 
              (cond ((< w1 w2) 
                     (cons-stream s1car 
                                  (merge-weighted (stream-cdr s1) s2 compare))) 
                    ((> w1 w2) 
                     (cons-stream s2car 
                                  (merge-weighted s1 (stream-cdr s2) compare))) 
                    (else 
                     (cons-stream 
                      s1car 
                      (cons-stream 
                       s2car
                            (merge-weighted 
                            (stream-cdr s1) 
                            (stream-cdr s2) 
                            compare)))))))))) 