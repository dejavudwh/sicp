(controller
  (assign x (op read))
  (assign guess (const 1.0))

  test-good
    (test (op good-enough?) (reg guess) (reg x))
    (branch (label done))
    (assign t (op improve) (reg guess) (reg x))
    (assign guess (reg t))
    (goto test-good)
  done

  (perform (op print) (reg guess)))