#lang scheme

(define (new-conjoin conjuncts frame-stream) 
   (if (empty-conjunction? conjuncts) 
       frame-stream 
       (merge (qeval (first-conjunct conjuncts) 
                     frame-stream) 
              (new-conjoin (rest-conjuncts conjuncts) 
                           frame-stream)))) 
 (define (merge s1 s2) 
   (cond ((stream-null? s1) s2) 
         ((stream-null? s2) s1) 
         (else 
          (stream-flatmap (lambda (frame1) 
                            (stream-flatmap (lambda (frame2) 
                                              (merge-frame frame1 frame2)) 
                                            s2)) 
                          s1)))) 
 (define (merge-frame f1 f2) 
   (if (null? f1) 
       (singleton-stream f2) 
       (let ((b1 (car f1))) 
         (let ((b2 (assoc (car b1) f2))) 
           (if b2 
               (if (equal? (cdr b1) (cdr b2)) 
                   (merge-frame (cdr f1) f2) 
                   the-empty-stream) 
               (merge-frame (cdr f1) (cons b1 f2))))))) 