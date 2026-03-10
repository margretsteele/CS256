vampire(dracula).
vampire(edwardcullen).
vampire(X) :- hybrid(X).

werewolf(samuley).
werewolf(X) :- hybrid(X).
hybrid(michaelcorvin).

poltergeist(peeves).
ghost(caspar).
ghost(X) :- poltergeist(X).

looksLike(X, 'human') :- vampire(X).
looksLike(X, 'human') :- ghost(X).
looksLike(X, 'wolf') :- werewolf(X).

thrivesOn(X, 'blood') :- vampire(X).
thrivesOn(X, 'fear') :- ghost(X).
thrivesOn(X, 'flesh') :- werewolf(X).

monster(X) :- vampire(X).
monster(X) :- ghost(X).
monster(X) :- werewolf(X).
monster(X) :- hybrid(X).

undead(X) :- vampire(X).
dead(X) :- ghost(X).
alive(X) :- werewolf(X).

