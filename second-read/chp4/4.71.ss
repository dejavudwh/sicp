#lang scheme

; 这个答案来自wiki

; This will postpone some infinite loop. for example: 
;  (assert! (married Minnie Mickey)) 
;  (assert! (rule (married ?x ?y) 
;                 (married ?y ?x))) 
;  (married Mickey ?who) 
;  if we don't use delay, there is no answer to display. but if we use it, we can get: 
;  ;;; Query output: 
;  (married Mickey Minnie) 
;  (married Mickey Minnie) 
;  (married Mickey Minnie) 
;  .... 
;  this is better than nothing. the reason of this difference is that in this example (apply-rules query-pattern frame) will lead to infinite loop, if we delay it, we still can get some meaningful answers. 