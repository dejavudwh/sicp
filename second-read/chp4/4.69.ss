#lang scheme

(rule (end-with-grandson (grandson)))

(rule (end-with-grandson (?f . ?tail))
  (end-with-grandson ?tail))

(rule ((grandson) ?x ?y)
      (grandson ?x ?y))

(rule ((great . ?rel) ?x ?y) 
      (and (end-with-grandson ?rel) 
           (son ?x ?z) 
           (?rel ?z ?y))) 