#lang scheme

(define (unless->if exp)
  (make-if (unless-predicative exp)
           (unless-alternative exp)        
           (unless-consequence exp)))