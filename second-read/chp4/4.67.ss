#lang scheme

(rule (append-to-form () ?y ?y))
(rule (append-to-form (?u . ?v) ?y (?u . ?z))
      (append-to-form ?v ?y ?z))

(rule (reverse (?x) (?x)))
(rule (reverse (?h . ?t) ?y)
  (and (reverse ?t ?reversed-t)
       (append-to-form ?reversed-t (?h) ?y)))
