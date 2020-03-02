#lang scheme

(and (address ?name ?addr)
     (supervisor ?name (Ben Bitdiddle)))

(and (salary ?person ?amount)
     (salary (Ben Bitdiddle) ?ben-amount)
     (lisp-value > ?amount ?ben-amount))

(and (supervisor ?person ?boss) 
     (not (job ?boss (computer . ?type))) 
     (job ?boss ?job)) 