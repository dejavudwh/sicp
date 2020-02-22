; 这题的问题在于会漏掉一些参数不相同但是可以进行类型转换的情况

; 比如一个函数接受(type1 type2 type3)
; 类型塔为(type3>type2>type1)
; 但是对于(type1 type2 type2)永远都找不到这个函数