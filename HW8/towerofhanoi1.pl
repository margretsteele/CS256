% Tower of Hanoi Program 1
% basically declares 'to' for our purposes herein
:- op(100, xfx, to).
% hanoi(N, A, B, C, Moves)
% Moves is the sequence of moves required to move N discs
% from peg A to peg B using peg C as an intermediary
% according to the rules of the Towers of Hanoi puzzle
%
hanoi(1, A, B, _, [A to B]).
hanoi(N, A, B, C, Moves) :-
N > 1,
N1 is N-1,
hanoi(N1, A, C, B, Moves1),
hanoi(N1, C, B, A, Moves2),
append(Moves1, [A to B | Moves2], Moves).
go(N, Moves) :- hanoi(N, a, b, c, Moves).