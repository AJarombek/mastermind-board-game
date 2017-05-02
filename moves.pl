% Author: Andrew Jarombek
% Date: 4/18/2017
% The move logic for the mastermind game

use_module(library(random)).
use_module(library(lists)).

% Make the first move of the game, which consists of picking random pegs
move(firstmove, PegList) :- 
	randomPeg(W),
	randomPeg(X),
	randomPeg(Y),
	randomPeg(Z),
	PegList = [W, X, Y, Z].

% Make a move using the knuth algorithm
move(knuth, NewPegList) :-
	randomPegList(NewPegList).

% Make a move of the game
move(nmove, PegList, Black, White, NewPegList) :-
	random_permutation([1,2,3,4], Pegs),
	write('Pegs: '), write(Pegs), nl,
	blackPegs(Pegs, Black, BlackPegs, RemainingPegs),
	write('RemainingPegs: '), write(RemainingPegs), nl,
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

% Pick a random peg list
randomPegList(PegList) :-
	solution(PegList).

% Pick a peg if it is a member of the black peg list
educatedPeg(N, Move, BP, _, Peg) :-
	member(N, BP),
	write(N), write(' is a member of '), write(BP), nl,
	nth1(N, Move, Elem),
	Peg = Elem.

% Pick a peg if it is a member of the white peg list
educatedPeg(N, Move, _, WP, Peg) :-
	member(N, WP),
	write(N), write(' is a member of '), write(WP), nl,
	random_permutation(Move, [H|_]),
	Peg = H.

% Pick a random peg if it is neither a member of the white or black peg list
educatedPeg(_, _, _, _, Peg) :-
	randomPeg(Peg),
	write('Random peg '), write(Peg), nl. 

% Compute a score for a move based on user feedback
feedback(Black, White, Score) :-
	BlackScore is Black * 10,
	WhiteScore is White * 2,
	Score is BlackScore + WhiteScore.

% Save the move as a fact
recordmove(PegList) :-
	assert(attempt(PegList)).

% Pick the attempt with the highest score
pickbestattempt(_, _, _, _, HS) :-
	attempt(L, S, B, W), 
	S > HS, 
	write('Score: '), write(S), nl,
	write('List: '), write(L), nl,
	pickbestattempt(L, S, B, W, S).

% Pick this move as the best move
bestMove(Score, PrevScore, PegList, _, Black, _, White, _, BestPegList, BestScore, BestBlack, BestWhite) :-
	Score >= PrevScore,
	BestPegList = PegList,
	BestScore = Score,
	BestBlack = Black,
	BestWhite = White.

% Pick the previous move as the best move
bestMove(Score, PrevScore, _, PrevPegList, _, PrevBlack, _, PrevWhite, BestPegList, BestScore, BestBlack, BestWhite) :-
	PrevScore > Score,
	BestPegList = PrevPegList,
	BestScore = PrevScore,
	BestBlack = PrevBlack,
	BestWhite = PrevWhite.

% Once all the black pegs have been chosen, return the unchosen pegs
blackPegs(Pegs, Count, BlackPegs, RemainingPegs) :-
	Count =< 0,
	write('Black Pegs 0'), nl,
	BlackPegs = [],
	RemainingPegs = Pegs.

% Get a list of the indexes that will follow the black peg feedback
blackPegs([H|T], Count, BlackPegs, RemainingPegs) :-
	write('Black Pegs N'), nl,
	Count > 0,
	blackPegs(T, Count - 1, BP, RP),
	append(BP, [H], BlackPegs),
	RemainingPegs = RP.

% Once all the white pegs have been chosen
whitePegs(_, Count, WhitePegs) :-
	Count =< 0,
	write('White Pegs 0'), nl,
	WhitePegs = [].

% Get a list of the indexes that will follow the white peg feedback
whitePegs([H|T], Count, WhitePegs) :-
	write('White Pegs N'), nl,
	Count > 0,
	whitePegs(T, Count - 1, WP),
	append(WP, [H], WhitePegs).

% Narrow down solutions based on Knuth's algorithm
narrowsolutions(PegList, Black, White) :-
	PegList = [PW, PX, PY, PZ],
	solution([W, X, Y, Z]),
	analyzePeg(PW, W, [W, X, Y, Z], Black1, White1),
	analyzePeg(PX, X, [W, X, Y, Z], Black2, White2),
	analyzePeg(PY, Y, [W, X, Y, Z], Black3, White3),
	analyzePeg(PZ, Z, [W, X, Y, Z], Black4, White4),
	BlackTotal is Black1 + Black2 + Black3 + Black4,
	WhiteTotal is White1 + White2 + White3 + White4,
	write('Black total: '), write(BlackTotal), write(' White total: '), write(WhiteTotal), nl,
	(BlackTotal =\= Black; WhiteTotal =\= White),
	retract(solution([W, X, Y, Z])),
	false.

% Also retract the previous guessed solution
narrowsolutions(PegList, _, _) :-
	retract(solution(PegList)).

% Catch-all narrowsolutions rule
narrowsolutions(_, _, _).

% Analyze a peg, matches if a black peg should be returned
analyzePeg(PX, X, _, Black, White) :-
	PX = X,
	Black is 1,
	White is 0.

% Analyze a peg, matches if a white peg should be returned
analyzePeg(PX, X, PegList, Black, White) :-
	PX \= X,
	member(PX, PegList),
	Black is 0,
	White is 1.

% Analyze a peg, matches if no peg should be returned
analyzePeg(PX, X, PegList, Black, White) :-
	PX \= X,
	\+ member(PX, PegList),
	Black is 0,
	White is 0.

% Stop execution on a solution
checkscore(Score) :-
	Score = 40,
	nl, write('Solution Found!'), nl,
	abort.

% Continue execution when a valid non-solution score is entered
checkscore(Score) :- 
	Score >= 0,
	Score < 40.

% Stop execution on an invalid score
checkscore(Score) :-
	(Score < 0; Score > 40),
	nl, write('ERROR: Invalid Feedback!'), nl, false,
	abort.
