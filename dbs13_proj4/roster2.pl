menu(Roster) :- 
   write('\tClass roster management system'), nl,
   write('\t=============================='), nl,
   write('\t   MENU'), nl,
   write('\t=============================='), nl,
   write('\t0. Reset Roster'), nl,
   write('\t1. Load roster from a file'), nl,
   write('\t2. Store roster to a file'), nl,
   write('\t3. Display roster sorted by ID'), nl,
   write('\t4. Display roster sorted by name'), nl,
   write('\t5. Display roster sorted by grade'), nl,
   write('\t6. Add a student to roster'), nl,
   write('\t7. Remove a student from roster'), nl,
   write('\t8. Exit'), nl, 
   write('\tEnter your choice (followed by a \'.\'): '),
   read(Sel),
   process(Sel, Roster).

process(0, _) :-
    write('\tRoster reset (now empty).'),
    nl, nl, menu([]).

process(1, _) :-
    nl,
    write('\tRead roster from a file:'),nl,
    write('\tEnter file name: '),
    read(File),
    browse(File),
    write('\tRoster read from file'),
    nl, nl, menu(Z).

process(2, Roster) :-
    nl,
    write('\tStore roster to a file:'),nl,
    write('\tEnter file name: '),
    read(A),
    open(A, write, F),
    write(F, Roster),
    write(F, '.'),
    close(F),
    write('\tRoster stored'),
    nl, nl, menu(Roster).

process(3, Roster) :-
    nl,
    write('\tDisplay Roster, sort by ID:'),nl,nl,
    naive_sort(Roster, Sorted),
    show_records(Sorted),
    nl, nl, menu(Roster).


process(4, Roster) :- 
    nl,
    write('\tAdd a student to the class roster'),nl,
    read_student_info([A, B, C]),
    (in_list([A, B, C], Roster) ->
      string_to_atom(A, D),
      format('\tStudent (ID:~a) is already on the roster', D),
      nl, nl, menu(X)
    ; string_to_atom(A, D),
      format('\tStudent (ID:~a) inserted.', D),
      nl, nl, menu([[A, B, C] | Roster])
    ).

process(5, X) :- 
    nl,
    write('\tRemove a student from roster:'),nl,
    write('\tEnter student name or ID : '),
    read(A),
    
    remove(_, [], []).
    remove(X, [X|T], T1):- remove(X, T, T1).
    remove(X, [Y|T], [Y|T1]) :- remove(X, T, T1).
      format('\tStudent ~a removed', T1), 
      nl, nl, menu(T1),
      format('\tStudent ~a is not in the roster', D), nl, nl, menu(X)
    ).

process(6, _) :- write('Good-bye'), nl, !.
process(_, X) :- menu(X).

/* ======================================================================================= */
read_student_info([A, B, C]) :-
  write('\tStudent ID: '),
  read(A),
  write('\tStudent Name: '),
  read(B),
  write('\tStudent Grade: '),
  read(C).


show_records(Roster) :-
  Roster = [ID | Name],
  write('\tID = '),
  ID = [Grade | D],
  write(Grade),
  write('\tName = '),
  D = [E | F],
  format("~s", [E]),
  write('\tGrade = '),
  F = [G | _],
  write(G),
  nl,
  show_records(Name).

naive_sort(Roster,Sorted):-perm(Roster,Sorted),is_sorted(Sorted).
  is_sorted([]).
  is_sorted([_]).
  is_sorted([ [X | XT], [Y | YT] | T]) :- X < Y, is_sorted([ [Y | YT] | T]).
  takeout(Item, [Item | L], L).
  takeout(Item, [X | L], [X | L1]) :- takeout(Item, L, L1).
  perm([], []).
  perm([X | Y], Z) :- perm(Y, W), takeout(X, Z, W).

browse(File) :-
  seeing(Old),
  see(File),
  repeat,
  read(Data),
  process(Data),
  seen,
  see(Old).
  process(end_of_file) :- !.
  process(Data) :-  write(Data), nl, fail.  
