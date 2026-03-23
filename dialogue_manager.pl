% Conversational dialogue manager with clarification-first flow.

:- module(dialogue_manager, [run_consultation/0]).

:- use_module(explanation).
:- use_module(family_inference).
:- use_module(interpreter).
:- use_module(knowledge_base).
:- use_module(profile).
:- use_module(specialization_inference).
:- use_module(utils).

run_consultation :-
    print_intro,
    print_narrative_intake_header,
    base_question_ids(BaseQuestions),
    run_question_sequence(BaseQuestions),
    print_interview_reflection,
    print_interpreter_summary,
    ask_question(reflection_correction),
    print_interview_reflection,
    print_interpreter_summary,
    run_targeted_clarifications(5),
    print_current_direction,
    leading_family(PrimaryFamily),
    candidate_families(CandidateFamilies),
    specialization_recommendations(CandidateFamilies, PrimaryCareer, SecondaryCareer),
    print_specialization_inference(CandidateFamilies, PrimaryCareer, SecondaryCareer),
    print_final_report(PrimaryFamily, PrimaryCareer, SecondaryCareer).

print_intro :-
    writeln('I will treat this as a career interview rather than a questionnaire.'),
    writeln('I will begin with a small narrative intake, reflect what I think I heard,'),
    writeln('then ask only the clarification questions that seem necessary.'),
    writeln('Useful commands at any prompt: why, help, examples, summary, profile,'),
    writeln('why this direction, what is unclear, skip, back, exit.'),
    nl.

print_narrative_intake_header :-
    writeln('Narrative intake:'),
    writeln('- Start with your story in your own words.'),
    writeln('- You can give short or long answers.'),
    writeln('- If you get stuck, type help or examples.'),
    nl.

run_question_sequence(QuestionIds) :-
    next_unanswered_question(QuestionIds, QuestionId),
    !,
    ask_question(QuestionId),
    run_question_sequence(QuestionIds).
run_question_sequence(_).

next_unanswered_question([QuestionId|_], QuestionId) :-
    \+ question_answered(QuestionId),
    !.
next_unanswered_question([_|Rest], QuestionId) :-
    next_unanswered_question(Rest, QuestionId).

run_targeted_clarifications(0) :-
    !.
run_targeted_clarifications(Remaining) :-
    next_clarification_question(QuestionId),
    !,
    announce_clarification(QuestionId),
    ask_question(QuestionId),
    RemainingNext is Remaining - 1,
    run_targeted_clarifications(RemainingNext).
run_targeted_clarifications(_).

announce_clarification(QuestionId) :-
    family_narrowing_question(Family, QuestionId),
    !,
    family_label(Family, Label),
    format('I now want to test whether ~w is really your strongest direction.~n', [Label]),
    nl.
announce_clarification(QuestionId) :-
    question_why(QuestionId, Reason),
    format('I want to clarify one thing before narrowing further: ~w~n', [Reason]),
    nl.

family_labels([], []).
family_labels([Family|Rest], [Label|Labels]) :-
    family_label(Family, Label),
    family_labels(Rest, Labels).

next_clarification_question(games_interest_clarification) :-
    \+ question_answered(games_interest_clarification),
    profile_fact(uncertainty, mentioned(games_interest)),
    !.
next_clarification_question(crowded_environment_clarification) :-
    \+ question_answered(crowded_environment_clarification),
    profile_fact(exclusion, excludes(crowded_environments)),
    !.
next_clarification_question(biology_nonhospital_clarification) :-
    \+ question_answered(biology_nonhospital_clarification),
    biology_positive_nonhospital_profile,
    !.
next_clarification_question(strongest_subjects) :-
    \+ question_answered(strongest_subjects),
    \+ profile_fact(academic, performed_well(_)),
    !.
next_clarification_question(enjoyed_subjects) :-
    \+ question_answered(enjoyed_subjects),
    \+ profile_fact(academic, enjoyed(_)),
    !.
next_clarification_question(difficult_subjects) :-
    \+ question_answered(difficult_subjects),
    \+ profile_fact(academic, found_difficult(_)),
    !.
next_clarification_question(activities_and_projects) :-
    \+ question_answered(activities_and_projects),
    \+ profile_fact(experience, completed_project(_)),
    \+ profile_fact(experience, joined(_)),
    !.
next_clarification_question(behaviours_and_roles) :-
    \+ question_answered(behaviours_and_roles),
    \+ profile_fact(behavior, shows(_)),
    !.
next_clarification_question(work_style_preferences) :-
    \+ question_answered(work_style_preferences),
    (   \+ profile_fact(preference, prefers(_))
    ;   profile_fact(uncertainty, mixed_about(work_style))
    ;   profile_fact(uncertainty, uncertain_about(general_direction))
    ),
    !.
next_clarification_question(preferred_environments) :-
    \+ question_answered(preferred_environments),
    (   \+ profile_fact(preference, prefers_environment(_))
    ;   profile_fact(uncertainty, uncertain_about(work_environment))
    ),
    !.
next_clarification_question(motivations) :-
    \+ question_answered(motivations),
    \+ profile_fact(goal, values(_)),
    !.
next_clarification_question(QuestionId) :-
    candidate_families(Families),
    member(Family, Families),
    family_narrowing_question(Family, QuestionId),
    \+ question_answered(QuestionId),
    \+ direction_recorded_for_family(Family),
    !.

direction_recorded_for_family(Family) :-
    career(Career, Family),
    profile_fact(direction, leans_toward(Career)),
    !.

biology_positive_nonhospital_profile :-
    (   profile_fact(academic, performed_well(biology))
    ;   profile_fact(academic, enjoyed(biology))
    ),
    profile_fact(exclusion, excludes(hospital_environment)).

ask_question(QuestionId) :-
    question_prompt(QuestionId, Prompt),
    nl,
    format('~w~n', [Prompt]),
    question_prompt_prefix(QuestionId, PromptPrefix),
    write(PromptPrefix),
    read_line_to_string(user_input, RawInput),
    normalize_text(RawInput, CleanInput),
    (   CleanInput = ''
    ->  writeln('- I did not receive any text. You can answer in your own words, type help for guidance, examples for sample answers, or skip to move on.'),
        ask_question(QuestionId)
    ;   handle_input(QuestionId, RawInput, CleanInput)
    ).

question_prompt_prefix(QuestionId, 'narrative> ') :-
    base_question_ids(BaseQuestions),
    member(QuestionId, BaseQuestions),
    !.
question_prompt_prefix(reflection_correction, 'review> ') :-
    !.
question_prompt_prefix(_, 'focus> ').

handle_input(QuestionId, _, CleanInput) :-
    recognized_command(CleanInput, Command),
    !,
    execute_command(QuestionId, Command).
handle_input(QuestionId, RawInput, _) :-
    interpret_response(QuestionId, RawInput, Result),
    handle_interpretation(QuestionId, RawInput, Result).

handle_interpretation(reflection_correction, RawInput, understood([])) :-
    current_snapshot(Snapshot),
    record_answer(reflection_correction, RawInput, [], Snapshot),
    writeln('- Good. I will keep the current understanding and continue.').
handle_interpretation(QuestionId, RawInput, understood(Facts)) :-
    current_snapshot(Snapshot),
    record_answer(QuestionId, RawInput, Facts, Snapshot),
    print_reflection(Facts).
handle_interpretation(QuestionId, RawInput, clarify(PreFacts, ClarifyPrompt)) :-
    print_reflection(PreFacts),
    ask_clarification(QuestionId, RawInput, ClarifyPrompt, PreFacts).
handle_interpretation(QuestionId, _, unresolved) :-
    writeln('- I only understood that partly.'),
    print_question_help(QuestionId),
    attempt_last_resort(QuestionId).

ask_clarification(QuestionId, OriginalInput, ClarifyPrompt, PreFacts) :-
    format('~w~n', [ClarifyPrompt]),
    write('clarify> '),
    read_line_to_string(user_input, ClarifyInput),
    normalize_text(ClarifyInput, CleanClarify),
    (   CleanClarify = ''
    ->  writeln('- I did not receive a clarification yet. You can answer naturally, type help, or type skip if you want me to keep this area uncertain.'),
        ask_clarification(QuestionId, OriginalInput, ClarifyPrompt, PreFacts)
    ;   recognized_command(CleanClarify, Command)
    ->  execute_clarification_command(QuestionId, Command, OriginalInput, ClarifyPrompt, PreFacts)
    ;   join_inputs(OriginalInput, ClarifyInput, CombinedInput),
        interpret_response(QuestionId, CombinedInput, Result),
        handle_clarified_interpretation(QuestionId, CombinedInput, PreFacts, Result)
    ).

execute_clarification_command(QuestionId, why, OriginalInput, ClarifyPrompt, PreFacts) :-
    print_question_reason(QuestionId),
    ask_clarification(QuestionId, OriginalInput, ClarifyPrompt, PreFacts).
execute_clarification_command(QuestionId, help, OriginalInput, ClarifyPrompt, PreFacts) :-
    print_question_help(QuestionId),
    ask_clarification(QuestionId, OriginalInput, ClarifyPrompt, PreFacts).
execute_clarification_command(QuestionId, examples, OriginalInput, ClarifyPrompt, PreFacts) :-
    print_question_examples(QuestionId),
    ask_clarification(QuestionId, OriginalInput, ClarifyPrompt, PreFacts).
execute_clarification_command(QuestionId, summary, OriginalInput, ClarifyPrompt, PreFacts) :-
    print_interview_reflection,
    print_interpreter_summary,
    ask_clarification(QuestionId, OriginalInput, ClarifyPrompt, PreFacts).
execute_clarification_command(QuestionId, profile, OriginalInput, ClarifyPrompt, PreFacts) :-
    print_profile_summary,
    ask_clarification(QuestionId, OriginalInput, ClarifyPrompt, PreFacts).
execute_clarification_command(QuestionId, why_this_direction, OriginalInput, ClarifyPrompt, PreFacts) :-
    print_current_direction,
    ask_clarification(QuestionId, OriginalInput, ClarifyPrompt, PreFacts).
execute_clarification_command(QuestionId, what_is_unclear, OriginalInput, ClarifyPrompt, PreFacts) :-
    print_unclear_areas,
    ask_clarification(QuestionId, OriginalInput, ClarifyPrompt, PreFacts).
execute_clarification_command(QuestionId, skip, _, _, PreFacts) :-
    current_snapshot(Snapshot),
    append(PreFacts, [fact(uncertainty, uncertain_about(QuestionId))], FinalFacts),
    record_answer(QuestionId, 'skip_after_clarification', FinalFacts, Snapshot),
    writeln('- That is okay. I will keep the partial evidence and move on.').
execute_clarification_command(_, exit, _, _, _) :-
    throw(exit_requested).
execute_clarification_command(_, back, _, _, _) :-
    (   pop_last_answer(PreviousQuestion)
    ->  format('- I removed your previous answer (~w). We can revisit it now.~n', [PreviousQuestion])
    ;   writeln('- There is no earlier answer to remove yet.')
    ).
execute_clarification_command(QuestionId, _, OriginalInput, ClarifyPrompt, PreFacts) :-
    ask_clarification(QuestionId, OriginalInput, ClarifyPrompt, PreFacts).

handle_clarified_interpretation(QuestionId, CombinedInput, PreFacts, understood(Facts)) :-
    append(PreFacts, Facts, CombinedFacts0),
    unique_items(CombinedFacts0, CombinedFacts),
    current_snapshot(Snapshot),
    record_answer(QuestionId, CombinedInput, CombinedFacts, Snapshot),
    print_reflection(CombinedFacts).
handle_clarified_interpretation(QuestionId, _, PreFacts, clarify(_, _)) :-
    writeln('- I still only partly understand, so I will offer a small fallback list.'),
    attempt_last_resort_with_seed(QuestionId, PreFacts).
handle_clarified_interpretation(QuestionId, _, PreFacts, unresolved) :-
    writeln('- I still only partly understand, so I will offer a small fallback list.'),
    attempt_last_resort_with_seed(QuestionId, PreFacts).

attempt_last_resort(QuestionId) :-
    attempt_last_resort_with_seed(QuestionId, []).

attempt_last_resort_with_seed(QuestionId, SeedFacts) :-
    (   question_menu_options(QuestionId, Options)
    ->  ask_menu_fallback(QuestionId, SeedFacts, Options)
    ;   current_snapshot(Snapshot),
        append(SeedFacts, [fact(uncertainty, uncertain_about(QuestionId))], FinalFacts),
        record_answer(QuestionId, 'unresolved_skip', FinalFacts, Snapshot),
        writeln('- I will keep that as uncertain and continue.')
    ).

ask_menu_fallback(QuestionId, SeedFacts, Options) :-
    writeln('- As a last resort, choose one or more close options below. Separate numbers with spaces.'),
    display_options(Options, 1),
    write('menu> '),
    read_line_to_string(user_input, RawInput),
    normalize_text(RawInput, CleanInput),
    (   CleanInput = ''
    ->  writeln('- I did not receive a menu selection. Enter one or more numbers, or type help, skip, or exit.'),
        ask_menu_fallback(QuestionId, SeedFacts, Options)
    ;   recognized_command(CleanInput, Command)
    ->  execute_menu_command(QuestionId, Command, SeedFacts, Options)
    ;   parse_number_selection(RawInput, Numbers),
        resolve_menu_keys(Numbers, Options, Keys),
        menu_selection_facts(QuestionId, Keys, MenuFacts),
        append(SeedFacts, MenuFacts, CombinedFacts0),
        unique_items(CombinedFacts0, CombinedFacts),
        CombinedFacts \= []
    ->  current_snapshot(Snapshot),
        record_answer(QuestionId, RawInput, CombinedFacts, Snapshot),
        print_reflection(CombinedFacts)
    ;   writeln('- Those menu choices were not valid. Please enter the option numbers shown, or type help, skip, or exit.'),
        ask_menu_fallback(QuestionId, SeedFacts, Options)
    ).

execute_menu_command(QuestionId, why, SeedFacts, Options) :-
    print_question_reason(QuestionId),
    ask_menu_fallback(QuestionId, SeedFacts, Options).
execute_menu_command(QuestionId, help, SeedFacts, Options) :-
    print_question_help(QuestionId),
    ask_menu_fallback(QuestionId, SeedFacts, Options).
execute_menu_command(QuestionId, examples, SeedFacts, Options) :-
    print_question_examples(QuestionId),
    ask_menu_fallback(QuestionId, SeedFacts, Options).
execute_menu_command(QuestionId, summary, SeedFacts, Options) :-
    print_interview_reflection,
    print_interpreter_summary,
    ask_menu_fallback(QuestionId, SeedFacts, Options).
execute_menu_command(QuestionId, profile, SeedFacts, Options) :-
    print_profile_summary,
    ask_menu_fallback(QuestionId, SeedFacts, Options).
execute_menu_command(QuestionId, why_this_direction, SeedFacts, Options) :-
    print_current_direction,
    ask_menu_fallback(QuestionId, SeedFacts, Options).
execute_menu_command(QuestionId, what_is_unclear, SeedFacts, Options) :-
    print_unclear_areas,
    ask_menu_fallback(QuestionId, SeedFacts, Options).
execute_menu_command(QuestionId, skip, SeedFacts, _) :-
    current_snapshot(Snapshot),
    append(SeedFacts, [fact(uncertainty, uncertain_about(QuestionId))], FinalFacts),
    record_answer(QuestionId, 'menu_skip', FinalFacts, Snapshot),
    writeln('- I will keep this area open and continue.').
execute_menu_command(_, exit, _, _) :-
    throw(exit_requested).
execute_menu_command(_, back, _, _) :-
    (   pop_last_answer(PreviousQuestion)
    ->  format('- I removed your previous answer (~w). We can revisit it now.~n', [PreviousQuestion])
    ;   writeln('- There is no earlier answer to remove yet.')
    ).
execute_menu_command(QuestionId, _, SeedFacts, Options) :-
    ask_menu_fallback(QuestionId, SeedFacts, Options).

resolve_menu_keys([], _, []).
resolve_menu_keys([Number|Rest], Options, [Key|Keys]) :-
    nth1(Number, Options, option(Key, _)),
    resolve_menu_keys(Rest, Options, Keys).

display_options([], _).
display_options([option(_, Label)|Rest], Index) :-
    format('  ~d. ~w~n', [Index, Label]),
    NextIndex is Index + 1,
    display_options(Rest, NextIndex).

recognized_command(Text, why) :-
    Text = why,
    !.
recognized_command(Text, help) :-
    Text = help,
    !.
recognized_command(Text, help) :-
    Text = commands,
    !.
recognized_command(Text, help) :-
    contains_phrase(Text, 'what can i type'),
    !.
recognized_command(Text, examples) :-
    Text = examples,
    !.
recognized_command(Text, skip) :-
    Text = skip,
    !.
recognized_command(Text, exit) :-
    Text = exit,
    !.
recognized_command(Text, back) :-
    Text = back,
    !.
recognized_command(Text, summary) :-
    Text = summary,
    !.
recognized_command(Text, profile) :-
    Text = profile,
    !.
recognized_command(Text, profile) :-
    contains_phrase(Text, 'what do you know about me'),
    !.
recognized_command(Text, why_this_direction) :-
    contains_phrase(Text, 'why this direction'),
    !.
recognized_command(Text, why_this_direction) :-
    contains_phrase(Text, 'why this path'),
    !.
recognized_command(Text, what_is_unclear) :-
    contains_phrase(Text, 'what is unclear'),
    !.
recognized_command(Text, what_is_unclear) :-
    contains_phrase(Text, 'what remains unclear'),
    !.

execute_command(QuestionId, why) :-
    print_question_reason(QuestionId),
    ask_question(QuestionId).
execute_command(QuestionId, help) :-
    print_question_help(QuestionId),
    ask_question(QuestionId).
execute_command(QuestionId, examples) :-
    print_question_examples(QuestionId),
    ask_question(QuestionId).
execute_command(QuestionId, summary) :-
    print_interview_reflection,
    print_interpreter_summary,
    ask_question(QuestionId).
execute_command(QuestionId, profile) :-
    print_profile_summary,
    ask_question(QuestionId).
execute_command(QuestionId, why_this_direction) :-
    print_current_direction,
    ask_question(QuestionId).
execute_command(QuestionId, what_is_unclear) :-
    print_unclear_areas,
    ask_question(QuestionId).
execute_command(QuestionId, skip) :-
    current_snapshot(Snapshot),
    record_answer(QuestionId, 'skip', [fact(uncertainty, uncertain_about(QuestionId))], Snapshot),
    writeln('- That is okay. I will keep this area open and move on.').
execute_command(_, exit) :-
    throw(exit_requested).
execute_command(_, back) :-
    (   pop_last_answer(PreviousQuestion)
    ->  format('- I removed your previous answer (~w). We can revisit it now.~n', [PreviousQuestion])
    ;   writeln('- There is no earlier answer to remove yet.')
    ).
