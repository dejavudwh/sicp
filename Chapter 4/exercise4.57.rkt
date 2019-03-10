;;a
(rule (replace ?person1 ?person2) 
                (and (job ?person1 ?job1) 
                     (job ?person2 ?job2) 
                     (or (same ?job1 ?job2) 
                         (can-do-job ?job1 ?job2)) 
                     (not (same ?person1 ?person2))))
;;b
(replace ?p (Fect Cy D))

;;c
(and (salary ?p1 ?a1) 
     (salary ?p2 ?a2) 
     (replace ?p1 ?p2)  
     (lisp-value > ?a2 ?a1)) 