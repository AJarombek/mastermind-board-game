% Author: Andrew Jarombek
% Date: 4/18/2017
% The move logic for the mastermind game

%module(mastermindMoves, [move/1]).

%use_module(library(random)).
%use_module(mastermindFacts).

% Make the first move of the game, which consists of picking random pegs
move(firstmove, PegList) :- 
	randomPeg(W),
	randomPeg(X),
	randomPeg(Y),
	randomPeg(Z),
	PegList = [W, X, Y, Z].

% Pick a random Peg
randomPeg(Peg) :- 
	random_between(0, 5, Random),
	matchPeg(Random, Peg).