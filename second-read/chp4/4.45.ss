#lang scheme

(sentence
  (simple-noun-phrase (article the) (noun professor))
  (verb-phrase
    (verb lectures)
    (prep-phrase (prep to)
                 (simple-noun-phrase (article the) (noun student)))
    (prep-phrase (prep in)
                 (simple-noun-phrase (article the) (noun class)))
    (prep-phrase (prep with)
                 (simple-noun-phrase (article the) (noun cat)))))

(sentence
  (simple-noun-phrase (article the) (noun professor))
  (verb-phrase
    (verb lectures)
    (prep-phrase (prep to)
                 (simple-noun-phrase
                   (article the)
                   (noun-phrase (noun student)
                                (prep-phrase (prep in)
                                             (simple-noun-phrase (article the) (noun class))))))
    (prep-phrase (prep with)
                 (simple-noun-phrase (article the) (noun cat)))))

(sentence
  (simple-noun-phrase (article the) (noun professor))
  (verb-phrase
    (verb lectures)
    (prep-phrase (prep to)
                 (simple-noun-phrase
                   (article the)
                   (noun-phrase (noun student)
                                (prep-phrase (prep in)
                                             (simple-noun-phrase (article the) (noun class)))
                                (prep-phrase (prep with)
                                             (simple-noun-phrase (article the) (noun cat))))))))


(sentence
  (simple-noun-phrase (article the) (noun professor))
  (verb-phrase
    (verb lectures)
    (prep-phrase (prep to)
                 (simple-noun-phrase
                   (article the)
                   (noun-phrase (noun student)
                                (prep-phrase (prep in)
                                             (simple-noun-phrase
                                               (article the)
                                               (noun-phrase)
                                                 (noun class)
                                                 (prep-phrase (prep with)
                                                              (simple-noun-phrase (article the) (noun cat))))))))))

(sentence
  (simple-noun-phrase (article the) (noun professor))
  (verb-phrase
    (verb lectures)
    (prep-phrase (prep to)
                 (simple-noun-phrase (article the) (noun student)))
    (prep-phrase (prep in)
                 (simple-noun-phrase
                   (article the)
                   (noun-phrase
                     (noun class)
                     (prep-phrase (prep with)
                                  (simple-noun-phrase (article the) (noun cat))))))))