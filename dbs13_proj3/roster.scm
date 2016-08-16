;;Drew Smith
;;COP4020
;;April 2016
;;roster.scm 

(define sortID
	(lambda (i1 i2)
		(if (string<? (car i1) (car i2)) #t #f)
	)
)

(define sortName
	(lambda (i1 i2)
		(if (string<? (cadr i1) (cadr i2)) #t #f)
	)
)

(define sortGrade
	(lambda (i1 i2)
		(if (< (caddr i1) (caddr i2)) #t #f)
	)
)

(define showRoster
	(lambda (n l)
		(cond ((null? l))
			(else
				(display "No.")
				(display n)
				(display ": ID=")
				(display (car (car l)))
				(display ", Name=\"")
				(display (cadr (car l)))
				(display "\", Grade=")
				(display (caddr (car l)))
				(display "\n")
				(showRoster (+ n 1) (cdr l))
			)
		)
	)
)

(define showStudent
	(lambda (input l)
		(cond 
			((null? l)
				(display "\nStudent ")
				(display input)
				(display " is not in the roster.\n")
			) 
			((or (equal? (cadr (car l)) input) (equal? (car (car l)) input))
				(display "\nID=")
				(display (caar l))
				(display ", Name=")
				(display (cadr (car l)))
				(display ", Grade=")
				(display (caddr (car l)))
				(display "\n")
			)
			(else
				(showStudent input (cdr l))
			)
		)
	)
)		

(define removeStudent
	(lambda (input l)
		(cond 
			((null? l)
				(display "\nStudent ")
				(display input)
				(display " is not in the roster.\n")
			)

			((or (equal? (cadr (car l)) input) (equal? (car (car l)) input))
				(display "\nStudent with ID or name ")
				(display input)
				(display " deleted.\n")
				(cdr l)
			)
			
			(else
				(cons (car l) (removeStudent input (cdr l)))
			)
		)
	)
)	


(define addStudent
	(lambda (n l)
	  (cond 
	  	((= n 0) 
	  		(begin (display "Student ID: ")
	      	(addStudent 1 (list (read-line)))
	    	)
	    )
			
			((= n 1) 
				(begin
					(display "Student Name: ")
					(addStudent 2 (list (car l) (read-line)))
				)
			)			
		
			((= n 2) 
				(begin
	        (display "Grade: ")
	        (list (car l) (cadr l) (read))
	      )
	    )
    )
  )
) 

(define performtask
	(lambda (n roster) 
    (cond 
    	((= n 0) 
    	(begin
      	(display "\nRoster reset (now empty)\n")
       	(menu '())
      ))
    
  		((= n 1) 
  		  (begin
					(display "\nLoad roster from a file:")
					(display "\nEnter file name: ")
  		    
  		    (let ((readfile (open-input-file (read-line))))
						(let ((loadroster (read readfile)))
							(close-input-port readfile)
							(display "Roster read from file.\n")
							(menu loadroster)
						)
  		    )
				)
			)
			
			((= n 2) 
				(begin
					(display "\nStore roster to a file:")
					(display "\nEnter file name: ")
					
					(let ((writefile (open-output-file (read-line))))
						(write roster writefile)
						(close-output-port writefile)
					)
					(display "Roster stored.\n")
					(menu roster)
				)
			)
			
			((= n 3) 
				(begin
					(display "\nDisplay Roster, sort by ID:\n")
					(showRoster 1 (sort roster sortID))
					(menu roster)
				)
			)
			
			((= n 4) 
				(begin
					(display "\nDisplay Roster, sort by name:\n")
					(showRoster 1 (sort roster sortName))
					(menu roster)
				)
			)

			((= n 5) 
				(begin
					(display "\nDisplay Roster, sort by grade:\n")
					(showRoster 1 (sort roster sortGrade))
					(menu roster)
				)
			)
			
			((= n 6) 
				(begin
					(display "\nDisplay student information:\n")
					(display "Enter student name or ID: ")
					(showStudent (read-line) roster)
					(menu roster)
				)
			)

			((= n 7) 
				(begin
					(display "\nAdd student to the roster\n")
					(menu (cons (addStudent 0 '()) roster))
				)
			)
			
			((= n 8) 
				(begin
					(display "\nRemove a student from roster:\n")	
					(display "Enter student name or ID: ")
					(menu (removeStudent (read-line) roster))	
				)
			)
  		      	
  		((= n 9) 
  			(begin
  		    (display "\nGoodbye\n")
  		    #t
  		  )
  		)
  		
  		(
  		else 
  			(begin
  		    (display "\nTask No. ")
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
			(display "\nClass Roster Management System\n")
      (display "================================\n")
      (display "              MENU              \n")
      (display "================================\n")
      (display "0. Reset roster\n")
      (display "1. Load roster from file\n")
      (display "2. Store roster to file\n")
			(display "3. Display roster sorted by ID\n")
			(display "4. Diplay roster sorted by name\n")
			(display "5. Display roster sorted by grade\n")
			(display "6. Display student info\n")
			(display "7. Add student to roster\n")
			(display "8. Remove a student from roster\n")
			(display "9. Exit\n\n")
      (display "Enter your choice: ")
      (performtask (read) roster)
    )
  )
)