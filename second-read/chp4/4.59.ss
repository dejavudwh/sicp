#lang scheme

;a)

(meeting ?range (Friday ?time))

; b)

(rule (meeting-time ?person ?day-and-time)
    (or (job ?person (?division . ?type))
        (meeting ?division (?day-and-time))
        (meeting whole-company (?day-and-time))))

; c)
(rule (meeting-time (Hacker Alyssa P) (Wednesday ?time)))