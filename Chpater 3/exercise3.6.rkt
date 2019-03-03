(define random-init 0) 
(define rand
  (let ((x random-init))
    (define (dispatch message)
      (cond ((eq? message 'generate)
             (begin (set! x (rand-update x))
                    x))
            ((eq? message 'reset)
             (lambda (value) (set! x value)))))
  dispatch))

 
 (define (rand-update x) (+ x 1)) ; A not-very-evolved PNRG 
 (rand 'generate) 
 ; 1 
 (rand 'generate) 
 ; 2 
 ((rand 'reset) 0) 
 ; 0 
 (rand 'generate) 
 ; 1 
        