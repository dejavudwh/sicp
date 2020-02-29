#lang scheme

(define adverb '(adverb moreover properly usually))
(define adjectives '(adjectives radient obedient obliging ))

(define (parse-verb-phrase)
    (define (maybe-extend verb-phrase)
    (amb verb-phrase
            (maybe-extend (list 'verb-phrase
                                verb-phrase
                                (parse-prepositional-phrase)))))
    (maybe-extend (parse-simple-verb-phrase)))

(define (parse-simple-verb-phrase)
    (amb (list 'simple-verb-phrase
                (parse-word verbs))
         (list 'adverb-phrase
                (parse-word verbs)
                (parse-word adverbs))))

 (define (parse-simple-noun-phrase)       
       (amb (list 'simple-noun-phrase 
                  (parse-word articles) 
                  (parse-word nouns)) 
            (list 'simple-noun-phrase 
                  (parse-word articles) 
                  (parse-word adjectives) 
                  (parse-word nouns)))) 