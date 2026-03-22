% Dynamic working memory for the consultation.

:- module(profile, [
    current_snapshot/1,
    pop_last_answer/1,
    profile_fact/2,
    question_answered/1,
    record_answer/4,
    reset_profile/0,
    restore_snapshot/1
]).

:- dynamic answer_history/5.
:- dynamic profile_fact/2.

reset_profile :-
    retractall(profile_fact(_, _)),
    retractall(answer_history(_, _, _, _, _)).

current_snapshot(Snapshot) :-
    findall(profile_fact(Category, Token), profile_fact(Category, Token), Snapshot).

restore_snapshot(Snapshot) :-
    retractall(profile_fact(_, _)),
    restore_snapshot_items(Snapshot).

restore_snapshot_items([]).
restore_snapshot_items([profile_fact(Category, Token)|Rest]) :-
    assertz(profile_fact(Category, Token)),
    restore_snapshot_items(Rest).

record_answer(QuestionId, RawInput, Facts, Snapshot) :-
    next_history_index(Index),
    assertz(answer_history(Index, QuestionId, RawInput, Facts, Snapshot)),
    add_facts(Facts).

next_history_index(Index) :-
    findall(N, answer_history(N, _, _, _, _), Indices),
    (   Indices = []
    ->  Index = 1
    ;   max_list(Indices, MaxIndex),
        Index is MaxIndex + 1
    ).

add_facts([]).
add_facts([fact(Category, Token)|Rest]) :-
    ensure_fact(Category, Token),
    add_facts(Rest).

ensure_fact(Category, Token) :-
    profile_fact(Category, Token),
    !.
ensure_fact(Category, Token) :-
    assertz(profile_fact(Category, Token)).

question_answered(QuestionId) :-
    answer_history(_, QuestionId, _, _, _).

pop_last_answer(QuestionId) :-
    last_answer_entry(Index, QuestionId, Snapshot),
    retract(answer_history(Index, QuestionId, _, _, Snapshot)),
    restore_snapshot(Snapshot).

last_answer_entry(Index, QuestionId, Snapshot) :-
    findall(Index-QuestionId-Snapshot, answer_history(Index, QuestionId, _, _, Snapshot), Entries),
    Entries \= [],
    last(Entries, Index-QuestionId-Snapshot).
