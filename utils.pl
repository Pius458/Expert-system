% Shared utility predicates for text handling and formatting.

:- module(utils, [
    any_phrase/2,
    contains_phrase/2,
    first_n/3,
    join_inputs/3,
    list_to_sentence/2,
    normalize_text/2,
    parse_number_selection/2,
    unique_items/2
]).

:- use_module(library(lists)).

normalize_text(end_of_file, '') :-
    !.
normalize_text(RawInput, Normalized) :-
    (   string(RawInput)
    ->  InputString = RawInput
    ;   atom_string(RawInput, InputString)
    ),
    string_lower(InputString, LowerString),
    string_chars(LowerString, Chars),
    maplist(normalize_char, Chars, CleanChars),
    string_chars(CleanString, CleanChars),
    normalize_space(string(Trimmed), CleanString),
    atom_string(Normalized, Trimmed).

normalize_char(Char, Char) :-
    char_type(Char, alnum),
    !.
normalize_char(Char, Char) :-
    member(Char, ['+', '#', '/']),
    !.
normalize_char(_, ' ').

contains_phrase(Text, Phrase) :-
    normalize_text(Text, NormalizedText),
    normalize_text(Phrase, NormalizedPhrase),
    format(atom(WrappedText), ' ~w ', [NormalizedText]),
    format(atom(WrappedPhrase), ' ~w ', [NormalizedPhrase]),
    sub_atom(WrappedText, _, _, _, WrappedPhrase).

any_phrase(Text, Phrases) :-
    member(Phrase, Phrases),
    contains_phrase(Text, Phrase),
    !.

first_n(_, 0, []) :-
    !.
first_n([], _, []).
first_n([Item|Rest], Count, [Item|Selected]) :-
    NextCount is Count - 1,
    first_n(Rest, NextCount, Selected).

join_inputs(First, Second, Joined) :-
    normalize_text(First, CleanFirst),
    normalize_text(Second, CleanSecond),
    atomic_list_concat([CleanFirst, CleanSecond], ' ', Combined),
    normalize_text(Combined, Joined).

list_to_sentence([], 'none recorded').
list_to_sentence([Item], Item).
list_to_sentence([First, Second], Sentence) :-
    format(atom(Sentence), '~w and ~w', [First, Second]).
list_to_sentence([First, Second|Rest], Sentence) :-
    append([First, Second], Rest, Items),
    atomic_list_concat(Items, ', ', Sentence).

parse_number_selection(RawInput, Numbers) :-
    normalize_text(RawInput, CleanInput),
    atomic_list_concat(Parts, ' ', CleanInput),
    exclude(=(''), Parts, FilledParts),
    catch(maplist(atom_number, FilledParts, Numbers), _, fail),
    Numbers \= [].

unique_items(Items, UniqueItems) :-
    sort(Items, UniqueItems).
