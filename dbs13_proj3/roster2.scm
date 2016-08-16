;;Drew Smith
;;COP4020
;;April 2016
;;roster.scm 

(define sort-by-id
	(lambda (s1 s2)
		(if (string<? (car s1) (car s2)) #t #f)
	)
)

(define sort-by-name
	(lambda (s1 s2)
		(if (string<? (cadr s1) (cadr s2)) #t #f)
	)
)

(define sort-by-grade
	(lambda (s1 s2)
		(if (< (caddr s1) (caddr s2)) #t #f)
	)
)

(define show-roster
	(lambda (n l)
		(cond
			((null? l))
			(else
				(display "\tNo.")
				(display n)
				(display ": ID=")
				(display (car (car l)))
				(display ", Name=\"")
				(display (cadr (car l)))
				(display "\", Grade=")
				(display (caddr (car l)))
				(display "\n")
				(show-roster (+ n 1) (cdr l))
			)
		)
	)
)

(define show-student
	(lambda (input l)
		(cond 
			((null? l)
				(display "\n\tStudent ")
				(display input)
				(display " is not in the roster.\n")
			) 
			((or (equal? (cadr (car l)) input) (equal? (car (car l)) input))
				(display "\n\tID=")
				(display (caar l))
				(display ", Name=")
				(display (cadr (car l)))
				(display ", Grade=")
				(display (caddr (car l)))
				(display "\n")
			)
			(else
				(show-student input (cdr l))
			)
		)
	)
)		

(define remove-student
	(lambda (input l)
		(cond 
			((null? l)
				(display "\n\tStudent ")
				(display input)
				(display " is not in the roster.\n")
			) 
			((or (equal? (cadr (car l)) input) (equal? (car (car l)) input))
				(display "\n\tStudent ")
				(display input)
				(display " removed.\n")
				(cdr l)
			)
			(else
				(cons (car l) (remove-student input (cdr l)))
			)
		)
	)
)	


(define add-student
	(lambda (n l)
	     	(cond ((= n 0) (begin
	        	(display "\tStudent ID: ")
			;;call function again, but with 1 as n to keep data but move to next read
	                (add-student 1 (list (read-line)))
	                ))
		((= n 1) (begin
			(display "\tStudent name: ")
			;;make new list with car l (ID) and the user input and move to next read
			(add-student 2 (list (car l) (read-line)))
			))			
		((= n 2) (begin
	                (display "\tGrade: ")
			;;make new list with car l (ID) cadr l (Name) and user input
	                (list (car l) (cadr l) (read))
	                ))
      		)
  	)
) 

;;perform task chosen in menu
(define performtask
	(lambda (n roster) 
    		(cond ((= n 0) (begin
                	(display "\n\tReset roster\n")
                    	(menu '())
                    	))
          	((= n 1) (begin
			(display "\n\tLoad roster from a file:")
			(display "\n\tEnter file name: ")
                	(let ((readfile (open-input-file (read-line))))
				(let ((loadroster (read readfile)))
					(close-input-port readfile)
					(display "\tRoster read from file.\n")
					(menu loadroster)
				)
                    	)
			))
		((= n 2) (begin
			(display "\n\tStore roster to a file:")
			(display "\n\tEnter file name: ")
			(let ((writefile (open-output-file (read-line))))
				(write roster writefile)
				(close-output-port writefile)
			)
			(display "\tRoster stored.\n")
			(menu roster)
			))
		((= n 3) (begin
			(display "\n\tDisplay Roster, sort by ID:\n")
			(show-roster 1 (sort roster sort-by-id))
			(menu roster)
			))
		((= n 4) (begin
			(display "\n\tDisplay Roster, sort by name:\n")
			(show-roster 1 (sort roster sort-by-name))
			(menu roster)
			))
		((= n 5) (begin
			(display "\n\tDisplay Roster, sort by grade:\n")
			(show-roster 1 (sort roster sort-by-grade))
			(menu roster)
			))
		((= n 6) (begin
			(display "\n\tDisplay student information:\n")
			(display "\tEnter student name or ID: ")
			(show-student (read-line) roster)
			(menu roster)
			))
		((= n 7) (begin
			(display "\n\tAdd student to the roster\n")
			;;call menu again with contents of add-student appended to roster
			(menu (cons (add-student 0 '()) roster))
			))
		((= n 8) (begin
			(display "\n\tRemove a student from roster:\n")	
			(display "\tEnter student name or ID: ")
			(menu (remove-student (read-line) roster))	
			))
          	((= n 9) (begin
                    	(display "\nGoodbye\n")
                    	#t
                    	))
           	(else (begin
                    	(display "\n\ttask no. ")
                    	(display n)
                    	(display " does not exist.\n\n")
                    	(menu roster)
                  	)
            	)
     		)
   	)
)

(define menu
  (lambda (roster)
     (begin
	(display "\n\tClass roster management system\n")
        (display "\t============================\n")
        (display "\t   			MENU\n")
        (display "\t============================\n")
        (display "\t0. Reset roster\n")
        (display "\t1. Load roster from file\n")
        (display "\t2. Store roster to file\n")
	(display "\t3. Display roster sorted by ID\n")
	(display "\t4. Diplay roster sorted by name\n")
	(display "\t5. Display roster sorted by grade\n")
	(display "\t6. Display student info\n")
	(display "\t7. Add student to roster\n")
	(display "\t8. Remove a student from roster\n")
	(display "\t9. Exit\n\n")
        (display "\tEnter your choice: ")
        (performtask (read) roster)
      )
   )
)89