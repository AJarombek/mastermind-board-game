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
move(nmove, PegList, Black, White, NewPegList) :-
	random_permutation([1,2,3,4], Pegs),
	write('Pegs: '), write(Pegs), nl,
	BlackPegs = [], WhitePegs = [],
	blackPegs(Pegs, Black, BlackPegs, RemainingPegs),
	whitePegs(RemainingPegs, White, WhitePegs),
	write('Black Pegs: '), write(BlackPegs), nl,
	write('White Pegs: '), write(WhitePegs), nl,
	educatedPeg(1, PegList, BlackPegs, WhitePegs, W),
	educatedPeg(2, PegList, BlackPegs, WhitePegs, X),
	educatedPeg(3, PegList, BlackPegs, WhitePegs, Y),
	educatedPeg(4, PegList, BlackPegs, WhitePegs, Z),
	NewPegList = [W, X, Y, Z].

% Pick a random Peg
randomPeg(Peg) :- 
	random_between(0, 5, Random),
	matchPeg(Random, Peg).

% Pick a peg if it is a member of the black peg list
educatedPeg(N, Move, BP, _, Peg) :-
	member(N, BP),
	nth1(N, Move, Elem),
	Peg = Elem.

% Pick a peg if it is a member of the white peg list
educatedPeg(N, Move, _, WP, Peg) :-
	member(N, WP),
	random_permutation(Move, [H|_]),
	Peg = H.

% Pick a random peg if it is neither a member of the white or black peg list
educatedPeg(_, _, _, _, Peg) :-
	randomPeg(Peg). 

% Compute a score for a move based on user feedback
feedback(Black, White, Score) :-
	BlackScore is Black * 10,
	WhiteScore is White * 2,
	Score is BlackScore + WhiteScore.

% Save the move and its score as a fact
recordmove(PegList, Score, Black, White) :-
	assert(attempt(PegList, Score, Black, White)).

% Pick the attempt with the highest score
pickbestattempt(_, _, _, _, HS) :-
	attempt(L, S, B, W), 
	S > HS, 
	write('Score: '), write(S), nl,
	write('List: '), write(L), nl,
	pickbestattempt(L, S, B, W, S).

bestMove(Score, PrevScore, PegList, _, Black, _, White, _, BestPegList, BestScore, BestBlack, BestWhite) :-
	Score > PrevScore,
	BestPegList = PegList,
	BestScore = Score,
	BestBlack = Black,
	BestWhite = White.

bestMove(Score, PrevScore, _, PrevPegList, _, PrevBlack, _, PrevWhite, BestPegList, BestScore, BestBlack, BestWhite) :-
	PrevScore > Score,
	BestPegList = PrevPegList,
	BestScore = PrevScore,
	BestBlack = PrevBlack,
	BestWhite = PrevWhite.

% Once all the black pegs have been chosen, return the unchosen pegs
blackPegs(Pegs, Count, _, RemainingPegs) :-
	Count =< 0,
	write('Black Pegs 0'), nl,
	RemainingPegs = Pegs.

% Get a list of the indexes that will follow the black peg feedback
blackPegs([H|T], Count, BlackPegs, _) :-
	write('Black Pegs N'), nl,
	Count > 0,
	append(BlackPegs, H, BP),
	blackPegs(T, Count - 1, BP, _).

% Get a list of the indexes that will follow the white peg feedback
whitePegs([H|T], Count, WhitePegs) :-
	Count > 0,
	append(WhitePegs, H, WP),
	whitePegs(T, Count - 1, WP).

whitePegs([_|_], Count, _) :-
	Count = 0.

