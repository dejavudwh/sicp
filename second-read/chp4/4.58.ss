#lang scheme

(rule (boss person)
    (and (job ?person ?type)
         (not (supervisor ?person ?boss))))

(rule (bigshot ?person ?division) 
    (and (job ?person (?division . ?rest)) 
         (or (not (supervisor ?person ?boss)) 
             (and (supervisor ?person ?boss) 
                  (not (job ?boss (?division . ?r)))))))