;;Louis交换嵌套映射,导致每次进行第二次map时有要进行一次深度的queen-cols的递归
;;对于每个K都会产生(queen-cols (- k 1))个棋盘