% Author: Andrew Jarombek
% Date: 4/18/2017
% The fact database for the mastermind game

% Facts of the peg color options
codePeg(blue).
codePeg(green).
codePeg(orange).
codePeg(purple).
codePeg(red).
codePeg(yellow).

% Match numbers to pegs
matchPeg(0, Peg) :- Peg = 'blue'.
matchPeg(1, Peg) :- Peg = 'green'.
matchPeg(2, Peg) :- Peg = 'orange'.
matchPeg(3, Peg) :- Peg = 'purple'.
matchPeg(4, Peg) :- Peg = 'red'.
matchPeg(5, Peg) :- Peg = 'yellow'.

% Dynamically create facts for all possible solutions
setupfacts(_) :-
	codePeg(W),
	codePeg(X),
	codePeg(Y),
	codePeg(Z),
	assertz(solution([W, X, Y, Z])),
	false.

% Catch all for the setupfacts
setupfacts(_).

% get the number of solutions remaining
countsolutions(X) :-
    findall(N, solution(N), Ns),
    length(Ns, X).