:- dynamic dirty/1.
:- dynamic vacuum_location/1.

adjacent(a, b).
adjacent(b, a).
adjacent(b, c).
adjacent(c, b).

vacuum_location(a).
dirty(a).
dirty(c).

action(clean) :-
    vacuum_location(Room),
    dirty(Room).

action(move(ToRoom)) :-
    vacuum_location(CurrentRoom),
    adjacent(CurrentRoom, ToRoom),
    dirty(ToRoom).

action(move(ToRoom)) :-
    vacuum_location(CurrentRoom),
    dirty(_),
    adjacent(CurrentRoom, ToRoom).

action(stop) :-
    \+ dirty(_).

perform(clean) :-
    vacuum_location(Room),
    retract(dirty(Room)),
    format('Vacuum cleaned room ~w.~n', [Room]).

perform(move(ToRoom)) :-
    retract(vacuum_location(_)),
    assert(vacuum_location(ToRoom)),
    format('Vacuum moved to room ~w.~n', [ToRoom]).

perform(stop) :-
    format('All rooms are clean. Stopping.~n').

start :-
    action(Action),
    perform(Action),
    Action \= stop,
    start.

start :-
    action(stop),
    perform(stop).
