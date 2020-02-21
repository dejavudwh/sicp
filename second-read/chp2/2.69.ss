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

(define (adjoin-set symbol set)
    (let ((w (weight (cdr set))))
        (cond ((> w (weight symbol)
               (cons symbol set)))
              ((< w (weight symbol)
               (cons set (adjoin-set symbol (cdr set)))))
              (else
                (list symbol)))))

(define (make-leaf-set pairs)
    (if (null? pairs)
        '()
        (let ((pair (car pairs)))
            (adjoin-set (make-leaf (car pair)
                                   (cadr pair))
                        (make-leaf-set (cdr pair))))))

(define (successive-merge ordered-set)
    (cond ((= 0 (length ordered-set))
            '())
          ((= 1 (length ordered-set))
            (car ordered-set))
          (else
            (let ((new-sub-tree (make-code-tree (car ordered-set)
                                                (cadr ordered-set)))
                  (remained-ordered-set (cddr ordered-set)))
                (successive-merge (adjoin-set new-sub-tree remained-ordered-set))))))

(define (generate-huffman-tree pairs)
    (successive-merge (make-leaf-set pairs)))

(generate-huffman-tree '((A 4) (B 2) (C 1) (D 1)))