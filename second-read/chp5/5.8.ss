; 3
; 这里的关键在extract-labels里的这两行

(cons (make-label-entry next-inst insts)
      labels)

; 这里先出现的label就会在前面，所以assoc的时候就会先找到第一个here