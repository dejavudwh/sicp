(define (attach-tag type-tag content) (cons type-tag content)) 
 (define (get-record employee-id file) 
  (attach-tag (division file)  
   ((get 'get-record (division file)) employee-id file)))

 ;b. get-salary 
     (define (get-salary record) 
         (let ((record-type (car record)) 
               (record-content (cdr record))) 
                 ((get 'get-salary record-type) record-content)))

  ;c. find-employee-record 
     (define (find-employee-record employee-id file-list) 
         (if (null? file-list) 
             #f 
             (let ((current-file (car file-list))) 
              (if (get-record employee-id current-file) 
                 (get-record employee-id current-file) 
                 (find-employee-record employee-id (cdr file-list))))))
 ;;提供新分支的访问雇员的方法和获得薪水的方法,并安装到表中