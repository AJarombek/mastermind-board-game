% Author: Andrew Jarombek
% Date: 4/18/2017
% Simulate the mastermind board game
% Execute using ?- [mastermind, moves, facts].

%use_module(mastermindMoves).
%use_module(mastermindFacts).

newgame(X) :- program(X).

% Start the game
program(start) :-
	write('Enter the four peg colors in order for the solution.'), nl,
	write('Options: [blue, green, orange, purple, red, yellow].'), nl,
	read(W),
	read(X),
	read(Y),
	read(Z),
	verifyinput(W, X, Y, Z),
	write('Winning '), writeboard(W, X, Y, Z),
	move(firstmove, PegList),
	writeboard(PegList).

% Verify that the user selects valid peg colors
verifyinput(W, X, Y, Z) :-
	codePeg(W),
	codePeg(X),
	codePeg(Y),
	codePeg(Z),
	addsolution(W, X, Y, Z).

% If the user selection is verified, add facts about the solution
addsolution(W, X, Y, Z) :- 
	assert(codePeg1(W)), 
	assert(codePeg2(X)), 
	assert(codePeg3(Y)), 
	assert(codePeg4(Z)).

% Print out the current board state to the screen
writeboard(W, X, Y, Z) :-
	write('Board: ['),
	write(W), write(', '),
	write(X), write(', '),
	write(Y), write(', '),
	write(Z), write(']'), nl.

% Print out the current board when given a list of the board
writeboard(PegList) :-
	write('Board: ['),
	writepeg(PegList).

% Print out a single peg at the end of the list
writepeg([H|T]) :-
	T = [],
	write(H), write(']'), nl.

% Print out a single peg in the middle of the list
writepeg([H|T]) :-
	write(H), write(', '),
	writepeg(T).
