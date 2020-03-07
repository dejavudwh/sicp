; a)

(controller
    (assgin contiune (label expt-done))
    expt-loop
        (test (op =) (reg n) (const 0))
        (assgin t (const 1))
        (goto (restore contiune))
        (save contiune)
        (save b)
        (assgin contiune (label after-expt-loop))
        (assgin n (op -) (reg n) (const 1))
        (goto (label expt-loop))
    after-expt-loop
        (restore b)
        (assgin t (op *) (reg t) (reg b))
        (goto (restore contiune))
    expt-done  
        (reg t))
; b)

(controller
    test
        (test (op =) (reg n) (const 0))
        (branch (label expn-done))
        (assign p (op mul) (reg p) (reg b))
        (assign n (op sub) (reg n) (const 1))
        (goto (label test))
    expn-done)