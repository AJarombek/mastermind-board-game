% Author: Andrew Jarombek
% Date: 4/18/2017
% Simulate the mastermind board game

newgame(X) :- program(X).

program(start) :-
	write('Enter the four peg colors in order for the solution.'), nl,
	write('Options: [Blue, Green, Orange, Purple, Red, Yellow].'), nl,
	read(W),
	read(X),
	read(Y),
	read(Z),
	writeboard(W, X, Y, Z).

solution(W, X, Y, Z) :- 
	assert(codePeg1(W)), 
	assert(codePeg2(X)), 
	assert(codePeg3(Y)), 
	assert(codePeg4(Z)).

writeboard(W, X, Y, Z) :-
	write('Board: ['),
	write(W), write(', '),
	write(X), write(', '),
	write(Y), write(', '),
	write(Z), write(']'), nl.

codePeg('Blue').
codePeg('Green').
codePeg('Orange').
codePeg('Purple').
codePeg('Red').
codePeg('Yellow').