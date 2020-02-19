; a)

(define top-left (make-vect 0.0 1.0))

(define top-right (make-vect 1.0 1.0))

(define bottom-left (make-vect 0.0 0.0))

(define bottom-right (make-vect 1.0 0.0))

(define top (make-segment top-left top-right))

(define left (make-segment top-left bottom-left))

(define right (make-segment top-right bottom-right))

(define bottom (make-segment bottom-left bottom-right))

(segments->painter (list top bottom left right))

; b)

(define left-top (make-vect 0.0 1.0))

(define right-bottom (make-vect 1.0 0.0))

(define right-top (make-vect 1.0 1.0))

(define left-bottom (make-vect 0.0 0.0))

(define left-top-to-right-bottom (make-segment left-top
                                               right-bottom))

(define right-top-to-left-bottom (make-segment right-top
                                               left-bottom))

(segments->painter (list left-top-to-right-bottom
                         right-top-to-left-bottom))

; c

(define top-mid-point (make-vect 0.5 1.0))

(define bottom-mid-point (make-vect 0.5 0.0))

(define left-mid-point (make-vect 0.0 0.5))

(define right-mid-point (make-vect 1.0 0.5))

(define top-to-left (make-segment top-mid-point
                                  left-mid-point))

(define top-to-right (make-segment top-mid-point
                                   right-mid-point))

(define bottom-to-left (make-segment bottom-mid-point
                                     left-mid-point))

(define bottom-to-right (make-segment bottom-mid-point
                                      right-mid-point))

(segments->painter (list top-to-left
                         top-to-right
                         bottom-to-left
                         bottom-to-right))
