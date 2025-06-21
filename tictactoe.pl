:- dynamic(board/1).

init_board :- retractall(board(_)), assert(board([' ',' ',' ',' ',' ',' ',' ',' ',' '])).

display_board :-
    board(B),
    nth0(0, B, A), nth0(1, B, B1), nth0(2, B, C),
    nth0(3, B, D), nth0(4, B, E), nth0(5, B, F),
    nth0(6, B, G), nth0(7, B, H), nth0(8, B, I),
    format('~n ~w | ~w | ~w~n', [A, B1, C]),
    writeln('---+---+---'),
    format(' ~w | ~w | ~w~n', [D, E, F]),
    writeln('---+---+---'),
    format(' ~w | ~w | ~w~n', [G, H, I]).

make_move(Pos, Player) :-
    board(B),
    nth0(Pos, B, ' '),
    replace(B, Pos, Player, NewB),
    retractall(board(_)),
    assert(board(NewB)).

replace([_|T], 0, X, [X|T]).
replace([H|T], I, X, [H|R]) :-
    I > 0,
    I1 is I - 1,
    replace(T, I1, X, R).

win(B, P) :-
    (Row = [0,1,2]; Row = [3,4,5]; Row = [6,7,8];
     Row = [0,3,6]; Row = [1,4,7]; Row = [2,5,8];
     Row = [0,4,8]; Row = [2,4,6]),
    maplist(nth0_list(B), Row, [P,P,P]).

nth0_list(L, I, V) :- nth0(I, L, V).

draw :- board(B), \+ member(' ', B).

computer_move :-
    board(B),
    nth0(Pos, B, ' '),
    make_move(Pos, 'O'),
    format('Computer moves to position ~w~n', [Pos]).

human_move :-
    repeat,
    write('Enter your move (0-8): '),
    read(Pos),
    integer(Pos), between(0, 8, Pos),
    board(B), nth0(Pos, B, ' '), !,
    make_move(Pos, 'X').

play :-
    init_board,
    game_loop.

game_loop :-
    display_board,
    (   win_state('O') -> writeln('Computer wins!'), display_board
    ;   win_state('X') -> writeln('You win!'), display_board
    ;   draw          -> writeln('Draw!'), display_board
    ;   human_move, game_loop_2
    ).

game_loop_2 :-
    display_board,
    (   win_state('X') -> writeln('You win!'), display_board
    ;   draw          -> writeln('Draw!'), display_board
    ;   computer_move, game_loop
    ).

win_state(P) :- board(B), win(B, P).
