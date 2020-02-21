#lang scheme

(define (make-leaf symbol weight)
    (list 'leaf symbol weight))

(define (leaf? obj)
    (eq? (car obj) 'leaf))

(define (symbol-leaf x)
    (cadr x))

(define (symbol-weight x)
    (caddr x))

(define (symbols tree)
    (if (leaf? tree)
        (list (symbol-leaf tree))
        (caddr tree)))

(define (weight tree)
    (if (leaf? tree)
        (symbol-weight tree)
        (cadddr tree)))

(define (make-code-tree left right)
    (list left 
          right
          (append (symbols left) (symbols right))
          (+ (weight left) (weight right))))

(define (left-branch tree)
    (car tree))

(define (right-branch tree)
    (cadr tree))

(define (choose-branch bit tree)
    (cond ((= bit 0)
           (left-branch tree))
          ((= bit 1)
           (right-branch tree))))

(define (decode bits tree)
    (define (decode-1 bits cur-branch)
        (if (null? bits)
            '()
            (let ((next-branch (choose-branch (car bits) cur-branch)))
                 (if (leaf? next-branch)
                     (cons (symbol-leaf next-branch)
                           (decode-1 (cdr bits) tree))
                     (decode-1 (cdr bits) next-branch)))))
    (decode-1 bits tree))

(define tree (make-code-tree (make-leaf 'A 4)
                             (make-code-tree (make-leaf 'B 2)
                                (make-code-tree (make-leaf 'D 1)
                                                (make-leaf 'C 1)))))

(define msg '(0 1 1 0 0 1 0 1 0 1 1 1 0))

(decode msg tree)

