lcm(X, 21) :- write(X), nl.

lcm(X, Y) :- 0 is X mod Y, NEW_Y is Y + 1, lcm(X, NEW_Y);
	     NEW_X is X + 1, lcm(NEW_X, 2).
