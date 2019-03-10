;;a
(meeting ?dept (Friday . ?t))

;;b
 (rule (meeting-time ?person ?day-and-time) 
          (and (job ?person (?dept . ?r)) 
                  (or (meeting ?dept ?day-and-time) 
                  (meeting the-whole-company ?day-and-time))))

;;c
(and (meeting-time (Hacker Alyssa P) (Wednesday . ?time)) 
          (meeting ?dept (Wednesday . ?time))) 