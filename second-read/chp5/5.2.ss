(controller
    (assign t n)
    (assign a (const 1))
    (assgin b (const 1))
    label-iter
        ((test (op >) (reg b) (reg t)))
        (goto label-done)
        (assign a (op *) (reg a) (reg b))
        (assgin b (op +) (reg b) (const 1))
        (branch (label-iter))
    label-done)