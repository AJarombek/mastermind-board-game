% Author: Andrew Jarombek
% Date: 4/18/2017
% Simulate the mastermind board game
% Execute using ?- [mastermind, moves, facts].
%				?- newgame(standard).
%				?- newgame(knuth).

newgame(X) :- program(X).

%
% First attempt without optimization algorithm
%

% Start the game
program(standard) :-
	write('Enter the four peg colors in order for the solution.'), nl,
	write('Options: [blue, green, orange, purple, red, yellow].'), nl,
	read(W),
	read(X),
	read(Y),
	read(Z),
	verifyinput(W, X, Y, Z), 
	move(firstmove, PegList),
	recordmove(PegList),
	nl, writeboard(PegList),
	write('Winning '), writeboard(W, X, Y, Z), nl,
	program(play, PegList, [W, X, Y, Z]).

%
% Mastermind utilizing Knuth's algorithm
%

% Start the game
program(knuth) :-
	setupfacts(X),
	write('Enter the four peg colors in order for the solution.'), nl,
	write('Options: [blue, green, orange, purple, red, yellow].'), nl,
	read(W),
	read(X),
	read(Y),
	read(Z),
	verifyinput(W, X, Y, Z), 
	move(firstmove, PegList),
	nl, writeboard(PegList),
	write('Winning '), writeboard(W, X, Y, Z), nl.

% Make a move based on the first move and get feedback for the first time
program(play, PegList, WinningBoard) :-
	write('Give Feedback:'), nl,
	write('Black Pegs represent correct colors and correct positions.'), nl,
	write('White Pegs represent correct color but incorrect position.'), nl,
	nl, write('# of Black Pegs:'), nl,
	read(Black),
	nl, write('# of White Pegs:'), nl,
	read(White),
	feedback(Black, White, Score),
	write('The Score: '), write(Score), nl,
	checkscore(Score),
	move(nmove, PegList, Black, White, NewPegList),
	recordmove(NewPegList),
	write('Move Made.'), nl,
	nl, writeboard(NewPegList),
	write('Winning '), writeboard(WinningBoard), nl,
	program(play, NewPegList, PegList, Score, Black, White, WinningBoard).

% Make a move based on the BEST move and get feedback
program(play, PegList, PrevPegList, PrevScore, PrevBlack, PrevWhite, WinningBoard) :-
	write('Give Feedback:'), nl,
	write('Black Pegs represent correct colors and correct positions.'), nl,
	write('White Pegs represent correct color but incorrect position.'), nl,
	nl, write('# of Black Pegs:'), nl,
	read(Black),
	nl, write('# of White Pegs:'), nl,
	read(White),
	feedback(Black, White, Score),
	write('The Score: '), write(Score), nl,
	checkscore(Score),
	bestMove(Score, PrevScore, PegList, PrevPegList, Black, PrevBlack, White, PrevWhite, BestPegList, BestScore, BestBlack, BestWhite),
	move(nmove, BestPegList, BestBlack, BestWhite, NewPegList),
	recordmove(NewPegList),
	write('Move Made.'), nl,
	nl, writeboard(NewPegList),
	write('Winning '), writeboard(WinningBoard), nl,
	program(play, NewPegList, BestPegList, BestScore, BestBlack, BestWhite, WinningBoard).

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
	write('Board:         ['),
	writepeg(PegList).

% Print out a single peg at the end of the list
writepeg([H|T]) :-
	T = [],
	write(H), write(']'), nl.

% Print out a single peg in the middle of the list
writepeg([H|T]) :-
	write(H), write(', '),
	writepeg(T).



