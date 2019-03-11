 (assert! (rule (father ?s ?f) 
                (or (son ?f ?s) 
                    (and (son ?w ?s) 
                         (wife ?f ?w))))) 
  
 (assert! (rule (grandson ?g ?s) 
                (and (father ?s ?f) 
                     (father ?f ?g)))) 