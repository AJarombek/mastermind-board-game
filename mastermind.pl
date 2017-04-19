% Author: Andrew Jarombek
% Date: 4/18/2017
% Simulate the mastermind board game

use_module(mastermindMoves).
use_module(mastermindFacts).

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
	move(firstmove, []).

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