test(X) :-  X == 5,
			write('evaluated this').
			
			
test2(N) :- N is 5,
			write(N), nl,
			changeN(_),
			write(N), nl.
			
changeN(N) :- N is 6.

test3(M) :- [ M | [] ].

test4(P) :- P is '1',
			P is 1. 		
			