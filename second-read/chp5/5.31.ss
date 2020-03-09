 ; 完全不需要进行save和restore
 (f 'x 'y) 
 ((f) 'x 'y) 

 ; proc和argl需要save和restore
 (f (g 'x) y)  
 (f (g 'x) 'y) 