% Main entry point for the conversational career interview expert system.

:- module(main, [start/0]).

:- use_module(dialogue_manager).
:- use_module(profile).
:- use_module(utils).

start :-
    show_welcome,
    catch(consultation_loop, exit_requested, handle_exit).

show_welcome :-
    nl,
    writeln('======================================================================'),
    writeln('     Conversational Career Interview and Guidance Expert System       '),
    writeln('                           Using Prolog                               '),
    writeln('======================================================================'),
    writeln('This expert system works like a narrative career interview.'),
    writeln('It listens to your story, reflects what it understood, asks only'),
    writeln('targeted clarifying questions, then infers career families and'),
    writeln('specific guidance paths.'),
    nl.

consultation_loop :-
    reset_profile,
    run_consultation,
    nl,
    ask_restart(Restart),
    nl,
    (   Restart = yes
    ->  consultation_loop
    ;   writeln('Thank you for using the expert system. Goodbye.')
    ).

handle_exit :-
    nl,
    writeln('Exiting the consultation now. Goodbye.').

ask_restart(Response) :-
    repeat,
    write('Would you like to restart the consultation? (yes/no): '),
    read_line_to_string(user_input, RawInput),
    normalize_text(RawInput, CleanInput),
    (   CleanInput = ''
    ->  Response = no,
        !
    ;   CleanInput = exit
    ->  throw(exit_requested)
    ;   member(CleanInput, [yes, y])
    ->  Response = yes,
        !
    ;   member(CleanInput, [no, n])
    ->  Response = no,
        !
    ;   writeln('Please answer yes or no.'),
        fail
    ).
