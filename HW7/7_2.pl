% Its a crime for an American to sell weapons to hostile nations.
criminal(X) :- american(X), weapon(Y), sells(X, Y, Z), hostile(Z).

% The country Nono has some missiles.
owns(nono, M) :- missile(M). NONO OWNS MISSLE 2

% All of Nonos missiles were sold to it by Dr. Evil.
sells(evil, X, nono) :- missile(X), owns(nono, X). FACT 3

% Missiles are weapons.
weapon(X) :- missile(X). MISSLE IS WEAPON 1 

% An enemy of America counts as hostile.
hostile(X) :- enemy(X, america).

% Dr. Evil is an American.
american(evil). FACT

% The country Nono is an enemy of America.
enemy(nono, america). FACT 

% m1 is a missile.
missile(m1). FACT