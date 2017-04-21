% Author: Andrew Jarombek
% Date: 4/18/2017
% The move logic for the mastermind game

%module(mastermindMoves, [move/1]).

use_module(library(random)).
use_module(library(lists)).
%use_module(mastermindFacts).

% Make the first move of the game, which consists of picking random pegs
move(firstmove, PegList) :- 
	randomPeg(W),
	randomPeg(X),
	randomPeg(Y),
	randomPeg(Z),
	PegList = [W, X, Y, Z].

% Make a move of the game
move(nmove, PegList) :-
	pickbestattempt(Move, Score, Black, White, 0),
	random_permutation([1,2,3,4], Pegs),
	BlackPegs = [], WhitePegs = [],
	blackPegs(Pegs, Black, BlackPegs, RemainingPegs),
	whitePegs(RemainingPegs, White, WhitePegs),
	educatedPeg(Move, BlackPegs, WhitePegs).

% Pick a random Peg
randomPeg(Peg) :- 
	random_between(0, 5, Random),
	matchPeg(Random, Peg).

% Compute a score for a move based on user feedback
feedback(Black, White, Score) :-
	BlackScore is Black * 10,
	WhiteScore is White * 2,
	Score is BlackScore + WhiteScore, write(Score).

% Save the move and its score as a fact
recordmove(PegList, Score, Black, White) :-
	assert(attempt(PegList, Score, Black, White)).

% Pick the attempt with the highest score
pickbestattempt(Move, Score, Black, White, HS) :-
	attempt(L, S, B, W), 
	S >= HS, 
	pickbestattempt(L, S, B, W, S).

blackPegs(Pegs, 0, _, RemainingPegs) :-
	RemainingPegs = Pegs.

% Get a list of the indexes that will follow the black peg feedback
blackPegs([H|T], Count, BlackPegs, _) :-
	Count > 0,
	append(BlackPegs, H, BP),
	blackPegs(T, Count - 1, BP).

% Get a list of the indexes that will follow the white peg feedback
whitePegs([H|T], Count, WhitePegs) :-
	count > 0,
	append(WhitePegs, H, WP),
	whitePegs(T, Count - 1, WP).
