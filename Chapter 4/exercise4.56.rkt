;;a
(and (supervisor ?person (Bitdiddle Ben)) 
              (address ?person ?where)) 
;;b
(and (salary (Bitdiddle Ben) ?number) 
              (salary ?person ?amount) 
              (lisp-value < ?amount ?number))
;;c
(and (supervisor ?person ?boss) 
               (not (job ?boss (computer . ?type))) 
               (job ?boss ?job)) 