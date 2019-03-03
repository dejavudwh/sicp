(define (make-monitored f)
  (let ((count 0))
    (lambda (x)
      (cond ((eq? x 'how-many-call?) count)
            ((eq? x 'reset-count) (set! count 0))
            (else
             (set! count (+ count 1))
             (f x))))))

(define s (make-monitored sqrt))

(s 100)

(s 'how-many-call?)

(s 'reset-count)

(s 'how-many-call?)

