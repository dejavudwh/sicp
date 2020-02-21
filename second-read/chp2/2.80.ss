#lang scheme

(define (=zero? x)
    (apply-generic '=zero? x))

; install-scheme-number-package

(put '=zero? '(scheme-number)
        (lambda (value)
            (= value 0)))

; install-rational-package

(put '=zero? '(rational)
        (lambda (r)
            (= 0 (numer r))))

; install-complex-package

(put '=zero? '(complex)
        (lambda (c)
            (and (= 0 (real-part c))
                 (= 0 (imag-part c)))))