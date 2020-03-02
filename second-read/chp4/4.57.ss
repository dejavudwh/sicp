#lang scheme

(rule (can-replace p1 p2)
  (and (job p1 ?job1)
       (job p2 ?job2)
       (or (same? job1 job2)
           (can-do-job job1 job2))
       (not (same p1 p2))))

(can-replace ?x (Fect Cy D))

(and (can-replace ?p1 ?p2)
     (salary ?p1 ?amount1)
     (salary ?p2 ?amount2)
     (lisp-value? < amount1 amount2))