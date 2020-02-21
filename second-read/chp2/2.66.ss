#lang scheme

(define (lookup given-key tree-of-records)
    (cond ((null? tree-of-records)
            false)
          ((= given-key entry-key)                                  ; 对比当前节点的键和给定的查找键
            (entry tree-of-records))      
          ((> given-key (key (entry tree-of-records)))
            (lookup given-key (right-branch tree-of-records)))
          (else
            (lookup given-key (left-branch tree-of-records)))))