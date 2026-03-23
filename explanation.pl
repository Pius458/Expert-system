% Explanation, reflection, and reporting predicates.

:- module(explanation, [
    print_command_reference/0,
    print_current_direction/0,
    print_final_report/3,
    print_interpreter_summary/0,
    print_interview_reflection/0,
    print_profile_summary/0,
    print_question_examples/1,
    print_question_help/1,
    print_question_reason/1,
    print_reflection/1,
    print_specialization_inference/3,
    print_unclear_areas/0
]).

:- use_module(family_inference).
:- use_module(knowledge_base).
:- use_module(profile).
:- use_module(specialization_inference).
:- use_module(utils).

print_question_reason(QuestionId) :-
    question_why(QuestionId, Reason),
    format('- Why this matters: ~w~n', [Reason]).

print_question_help(QuestionId) :-
    question_help(QuestionId, HelpText),
    format('- Help: ~w~n', [HelpText]),
    print_command_reference.

print_command_reference :-
    writeln('- Commands: why, help, examples, summary, profile, why this direction, what is unclear, skip, back, exit.').

print_question_examples(QuestionId) :-
    question_examples(QuestionId, ExampleText),
    format('- Examples: ~w~n', [ExampleText]).

print_reflection([]) :-
    writeln('- I did not extract anything reliable from that answer yet.').
print_reflection(Facts) :-
    reflection_message(Facts, Message),
    format('- ~w~n', [Message]).

print_interview_reflection :-
    findall(Token, profile_fact(academic, Token), AcademicTokens),
    findall(Token, profile_fact(experience, Token), ExperienceTokens),
    findall(Token, profile_fact(preference, Token), PreferenceTokens),
    findall(Token, profile_fact(exclusion, Token), ExclusionTokens),
    findall(Token, profile_fact(uncertainty, Token), UncertaintyTokens),
    narrative_summary(AcademicTokens, ExperienceTokens, PreferenceTokens, ExclusionTokens, UncertaintyTokens, SummaryLines),
    nl,
    writeln('My current understanding:'),
    print_lines(SummaryLines),
    nl.

print_interpreter_summary :-
    nl,
    writeln('Interpreter summary (structured evidence):'),
    print_structured_evidence_line('Academic evidence', academic),
    print_structured_evidence_line('Experience evidence', experience),
    print_structured_evidence_line('Behavior evidence', behavior),
    print_structured_evidence_line('Preference evidence', preference),
    print_structured_evidence_line('Exclusion evidence', exclusion),
    print_structured_evidence_line('Goal evidence', goal),
    print_structured_evidence_line('Ambiguity markers', uncertainty),
    nl.

print_structured_evidence_line(Title, Category) :-
    findall(Token, profile_fact(Category, Token), Tokens),
    (   Tokens = []
    ->  format('- ~w: none extracted yet.~n', [Title])
    ;   findall(Label, (member(Token, Tokens), token_label(Category, Token, Label)), RawLabels),
        sort(RawLabels, Labels),
        list_to_sentence(Labels, Sentence),
        format('- ~w: ~w.~n', [Title, Sentence])
    ).

narrative_summary(Academic, Experience, Preference, Exclusion, Uncertainty, Lines) :-
    first_labels(academic, Academic, 3, AcademicSummary),
    first_labels(experience, Experience, 2, ExperienceSummary),
    first_labels(preference, Preference, 2, PreferenceSummary),
    first_labels(exclusion, Exclusion, 2, ExclusionSummary),
    first_uncertainty_labels(Uncertainty, UncertaintySummary),
    build_narrative_lines(AcademicSummary, ExperienceSummary, PreferenceSummary, ExclusionSummary, UncertaintySummary, Lines).

first_labels(_, [], _, []).
first_labels(Category, Tokens, Count, Labels) :-
    findall(Label, (member(Token, Tokens), token_label(Category, Token, Label)), RawLabels),
    sort(RawLabels, UniqueLabels),
    first_n(UniqueLabels, Count, Labels).

first_uncertainty_labels([], []).
first_uncertainty_labels(Tokens, Labels) :-
    findall(Label, (member(Token, Tokens), once(uncertainty_label(Token, Label))), RawLabels),
    sort(RawLabels, UniqueLabels),
    first_n(UniqueLabels, 2, Labels).

build_narrative_lines(Academic, Experience, Preference, Exclusion, Uncertainty, Lines) :-
    phrase_lines(Academic, 'I think I heard', AcademicLine),
    phrase_lines(Experience, 'I also heard', ExperienceLine),
    phrase_lines(Preference, 'I also heard', PreferenceLine),
    phrase_lines(Exclusion, 'I also heard', ExclusionLine),
    phrase_lines(Uncertainty, 'What still seems uncertain is', UncertaintyLine),
    exclude(=(none), [AcademicLine, ExperienceLine, PreferenceLine, ExclusionLine, UncertaintyLine], Lines).

phrase_lines([], _, none).
phrase_lines(Labels, Prefix, Line) :-
    list_to_sentence(Labels, Sentence),
    format(atom(Line), '- ~w ~w.', [Prefix, Sentence]).

print_lines([]).
print_lines([Line|Rest]) :-
    writeln(Line),
    print_lines(Rest).

reflection_message(Facts, 'That suggests technical interest and structured problem solving.') :-
    has_fact(Facts, preference, prefers(technical_systems)),
    has_fact(Facts, behavior, shows(problem_solving_behavior)),
    !.
reflection_message(Facts, 'That keeps people-centered and service-oriented families open.') :-
    has_fact(Facts, preference, prefers(people_helping)),
    !.
reflection_message(Facts, 'That points toward communication-heavy and explanation-heavy work.') :-
    has_fact(Facts, behavior, shows(communication_behavior)),
    !.
reflection_message(Facts, 'I now see no strong academic weakness, which keeps several families open.') :-
    has_fact(Facts, academic, found_difficult(none)),
    !.
reflection_message(Facts, 'That exclusion matters because it narrows paths even when you have the ability for them.') :-
    has_category(Facts, exclusion),
    !.
reflection_message(Facts, 'I am treating that as uncertain evidence rather than a firm conclusion.') :-
    has_category(Facts, uncertainty),
    !.
reflection_message(_, 'Thank you. That gives me another useful piece of evidence.').

has_fact(Facts, Category, Token) :-
    member(fact(Category, Token), Facts).

has_category(Facts, Category) :-
    member(fact(Category, _), Facts).

print_current_direction :-
    ranked_families(RankedFamilies),
    first_n(RankedFamilies, 3, TopFamilies),
    nl,
    writeln('Family-level inference:'),
    print_family_lines(TopFamilies, 1),
    nl.

print_family_lines([], _).
print_family_lines([Family|Rest], Index) :-
    print_family_line(Family, Index),
    NextIndex is Index + 1,
    print_family_lines(Rest, NextIndex).

print_family_line(family_assessment(Family, Score, Coverage, UncertaintyCount, Confidence, Positive, _), Index) :-
    family_label(Family, Label),
    confidence_label(Confidence, ConfidenceLabel),
    top_reason_summary(Positive, 2, Summary),
    format('~d. ~w (~w, score ~d, coverage ~d, uncertainty ~d): ~w.~n',
        [Index, Label, ConfidenceLabel, Score, Coverage, UncertaintyCount, Summary]).

print_unclear_areas :-
    findall(Token, profile_fact(uncertainty, Token), UncertaintyTokens),
    unanswered_question_ids(Unanswered),
    nl,
    writeln('What is still unclear:'),
    print_uncertainty_lines(UncertaintyTokens),
    print_unanswered_lines(Unanswered),
    nl.

print_uncertainty_lines([]) :-
    writeln('- I do not currently have strong explicit uncertainty markers from you.').
print_uncertainty_lines(Tokens) :-
    findall(Label, (member(Token, Tokens), once(uncertainty_label(Token, Label))), Labels),
    sort(Labels, UniqueLabels),
    UniqueLabels \= [],
    list_to_sentence(UniqueLabels, Sentence),
    format('- Uncertain areas: ~w.~n', [Sentence]).

print_unanswered_lines([]) :-
    writeln('- All planned questions for this stage have already been answered or skipped.').
print_unanswered_lines(Questions) :-
    findall(Prompt, (member(Q, Questions), question_prompt(Q, Prompt)), Prompts),
    first_n(Prompts, 3, ShortPrompts),
    list_to_sentence(ShortPrompts, Sentence),
    format('- Questions still open: ~w.~n', [Sentence]).

unanswered_question_ids(Unanswered) :-
    findall(Q, pending_gap_question(Q), RawQuestions),
    sort(RawQuestions, Unanswered).

pending_gap_question(strongest_subjects) :-
    \+ profile_fact(academic, performed_well(_)).
pending_gap_question(enjoyed_subjects) :-
    \+ profile_fact(academic, enjoyed(_)).
pending_gap_question(difficult_subjects) :-
    \+ profile_fact(academic, found_difficult(_)).
pending_gap_question(activities_and_projects) :-
    \+ profile_fact(experience, completed_project(_)),
    \+ profile_fact(experience, joined(_)).
pending_gap_question(behaviours_and_roles) :-
    \+ profile_fact(behavior, shows(_)).
pending_gap_question(work_style_preferences) :-
    \+ profile_fact(preference, prefers(_)).
pending_gap_question(preferred_environments) :-
    \+ profile_fact(preference, prefers_environment(_)).
pending_gap_question(motivations) :-
    \+ profile_fact(goal, values(_)).

uncertainty_label(uncertain_about(subject_strength), 'subject strengths').
uncertainty_label(uncertain_about(subject_difficulty), 'subject difficulties').
uncertainty_label(uncertain_about(subject_enjoyment), 'subject enjoyment').
uncertainty_label(uncertain_about(enjoyment_patterns), 'enjoyment patterns').
uncertainty_label(uncertain_about(experience_background), 'practical exposure and activities').
uncertainty_label(uncertain_about(behavior_patterns), 'behavior patterns').
uncertainty_label(uncertain_about(work_environment), 'preferred work environment').
uncertainty_label(uncertain_about(goals), 'long-term goals').
uncertainty_label(uncertain_about(general_direction), 'general direction').
uncertainty_label(uncertain_about(reflection_correction), 'whether the reflection was complete').
uncertainty_label(mixed_about(work_style), 'work style').
uncertainty_label(mentioned(games_interest), 'what your interest in games actually means').
uncertainty_label(no_major_correction, 'no major correction to the reflection').
uncertainty_label(uncertain_about(family(Family)), Label) :-
    family_label(Family, FamilyLabel),
    format(atom(Label), '~w as a family direction', [FamilyLabel]).
uncertainty_label(uncertain_about(career(Career)), Label) :-
    career_label(Career, CareerLabel),
    format(atom(Label), '~w as a specialization', [CareerLabel]).
uncertainty_label(Token, Label) :-
    format(atom(Label), '~w', [Token]).

print_profile_summary :-
    nl,
    writeln('What I know about you so far:'),
    print_category_summary('Academic', academic),
    print_category_summary('Experience', experience),
    print_category_summary('Behavior', behavior),
    print_category_summary('Preferences', preference),
    print_category_summary('Exclusions', exclusion),
    print_category_summary('Goals', goal),
    print_category_summary('Uncertainty', uncertainty),
    nl.

print_specialization_inference(CandidateFamilies, PrimaryCareer, SecondaryCareer) :-
    ranked_careers(CandidateFamilies, RankedCareers),
    first_n(RankedCareers, 3, TopCareers),
    nl,
    writeln('Specialization-level inference:'),
    print_career_lines(TopCareers, 1, PrimaryCareer, SecondaryCareer),
    nl.

print_career_lines([], _, _, _).
print_career_lines([Career|Rest], Index, PrimaryCareer, SecondaryCareer) :-
    print_ranked_career_line(Career, Index, PrimaryCareer, SecondaryCareer),
    NextIndex is Index + 1,
    print_career_lines(Rest, NextIndex, PrimaryCareer, SecondaryCareer).

print_ranked_career_line(career_assessment(Career, Family, Score, Coverage, UncertaintyCount, Confidence, Positive, _), Index, PrimaryCareer, SecondaryCareer) :-
    career_label(Career, CareerLabel),
    family_label(Family, FamilyLabel),
    confidence_label(Confidence, ConfidenceLabel),
    top_reason_summary(Positive, 2, Summary),
    career_rank_tag(career_assessment(Career, Family, Score, Coverage, UncertaintyCount, Confidence, Positive, _), PrimaryCareer, SecondaryCareer, Tag),
    format('~d. ~w~w (~w, family ~w, score ~d, coverage ~d, uncertainty ~d): ~w.~n',
        [Index, CareerLabel, Tag, ConfidenceLabel, FamilyLabel, Score, Coverage, UncertaintyCount, Summary]).

career_rank_tag(Assessment, PrimaryCareer, _, ' [primary recommendation]') :-
    Assessment =@= PrimaryCareer,
    !.
career_rank_tag(Assessment, _, SecondaryCareer, ' [secondary recommendation]') :-
    SecondaryCareer \= none,
    Assessment =@= SecondaryCareer,
    !.
career_rank_tag(_, _, _, '').

print_category_summary(Title, Category) :-
    findall(Token, profile_fact(Category, Token), Tokens),
    (   Tokens = []
    ->  format('- ~w: none recorded yet.~n', [Title])
    ;   findall(Label, (member(Token, Tokens), token_label(Category, Token, Label)), Labels),
        sort(Labels, UniqueLabels),
        list_to_sentence(UniqueLabels, Sentence),
        format('- ~w: ~w.~n', [Title, Sentence])
    ).

print_final_report(PrimaryFamily, PrimaryCareer, SecondaryCareer) :-
    nl,
    writeln('Final recommendation report:'),
    print_overall_fit_explanation(PrimaryFamily, PrimaryCareer, SecondaryCareer),
    nl,
    print_primary_family(PrimaryFamily),
    nl,
    print_primary_career(PrimaryCareer),
    print_secondary_career(SecondaryCareer),
    nl,
    print_profile_summary,
    print_validation_steps(PrimaryCareer).

print_overall_fit_explanation(
    family_assessment(Family, _, _, _, FamilyConfidence, FamilyPositive, FamilyNegative),
    career_assessment(Career, _, _, _, _, CareerConfidence, CareerPositive, CareerNegative),
    SecondaryCareer
) :-
    family_label(Family, FamilyLabel),
    career_label(Career, CareerLabel),
    overall_confidence_label(FamilyConfidence, CareerConfidence, ConfidenceLabel),
    top_reason_summary(FamilyPositive, 2, FamilySupport),
    top_reason_summary(CareerPositive, 2, CareerSupport),
    format('- Overall recommendation: ~w -> ~w.~n', [FamilyLabel, CareerLabel]),
    format('- Overall confidence: ~w.~n', [ConfidenceLabel]),
    format('- Fit explanation: The strongest family-level pattern is ~w, while the clearest specialization-level pattern is ~w.~n', [FamilySupport, CareerSupport]),
    print_overall_concern_line(FamilyNegative, CareerNegative),
    print_secondary_option_line(SecondaryCareer).

overall_confidence_label(strong_fit, strong_fit, 'Strong fit').
overall_confidence_label(possible_fit, _, 'Possible fit').
overall_confidence_label(_, possible_fit, 'Possible fit').
overall_confidence_label(_, _, 'Moderate fit').

print_overall_concern_line([], []).
print_overall_concern_line(FamilyNegative, CareerNegative) :-
    append(FamilyNegative, CareerNegative, CombinedNegative),
    CombinedNegative \= [],
    top_reason_summary(CombinedNegative, 2, Summary),
    format('- Main caution: ~w.~n', [Summary]).

print_secondary_option_line(none) :-
    !.
print_secondary_option_line(career_assessment(Career, _, _, _, _, _, Positive, _)) :-
    career_label(Career, CareerLabel),
    top_reason_summary(Positive, 2, Summary),
    format('- Secondary option worth checking: ~w, because ~w.~n', [CareerLabel, Summary]).

print_primary_family(family_assessment(Family, Score, Coverage, UncertaintyCount, Confidence, Positive, Negative)) :-
    family_label(Family, Label),
    family_overview(Family, Overview),
    confidence_label(Confidence, ConfidenceLabel),
    writeln('Primary family recommendation:'),
    format('- Family: ~w~n', [Label]),
    format('- Confidence: ~w~n', [ConfidenceLabel]),
    format('- Score: ~d~n', [Score]),
    format('- Coverage: ~d categories~n', [Coverage]),
    format('- Uncertainty markers affecting confidence: ~d~n', [UncertaintyCount]),
    top_reason_summary(Positive, 3, SupportSummary),
    format('- Why this family is leading: ~w.~n', [SupportSummary]),
    print_negative_summary('Possible concerns or mismatches at family level', Negative),
    format('- Interpretation: ~w~n', [Overview]).

print_primary_career(career_assessment(Career, Family, Score, Coverage, UncertaintyCount, Confidence, Positive, Negative)) :-
    career_label(Career, CareerLabel),
    family_label(Family, FamilyLabel),
    career_overview(Career, Overview),
    confidence_label(Confidence, ConfidenceLabel),
    writeln('Primary specialization:'),
    format('- Career: ~w~n', [CareerLabel]),
    format('- Family: ~w~n', [FamilyLabel]),
    format('- Confidence: ~w~n', [ConfidenceLabel]),
    format('- Score: ~d~n', [Score]),
    format('- Coverage: ~d categories~n', [Coverage]),
    format('- Uncertainty markers affecting confidence: ~d~n', [UncertaintyCount]),
    top_reason_summary(Positive, 4, SupportSummary),
    format('- Why this specialization was chosen: ~w.~n', [SupportSummary]),
    print_negative_summary('Possible concerns or mismatches', Negative),
    format('- Interpretation: ~w~n', [Overview]).

print_secondary_career(none) :-
    !.
print_secondary_career(career_assessment(Career, Family, Score, _, UncertaintyCount, Confidence, Positive, _)) :-
    career_label(Career, CareerLabel),
    family_label(Family, FamilyLabel),
    confidence_label(Confidence, ConfidenceLabel),
    top_reason_summary(Positive, 3, Summary),
    nl,
    writeln('Secondary specialization:'),
    format('- Career: ~w~n', [CareerLabel]),
    format('- Family: ~w~n', [FamilyLabel]),
    format('- Confidence: ~w~n', [ConfidenceLabel]),
    format('- Score: ~d~n', [Score]),
    format('- Uncertainty markers affecting confidence: ~d~n', [UncertaintyCount]),
    format('- Why it is also plausible: ~w.~n', [Summary]).

print_negative_summary(_, []).
print_negative_summary(Title, Negative) :-
    top_reason_summary(Negative, 2, Summary),
    format('- ~w: ~w.~n', [Title, Summary]).

print_validation_steps(career_assessment(Career, Family, _, _, _, _, _, _)) :-
    career_next_step(Career, Advice),
    family_label(Family, FamilyLabel),
    nl,
    writeln('Validation steps:'),
    format('- Step 1: ~w~n', [Advice]),
    format('- Step 2: Talk to someone studying or working in ~w, then compare that reality with the picture you currently have in mind.~n', [FamilyLabel]).

top_reason_summary(Matches, Count, Summary) :-
    first_n(Matches, Count, TopMatches),
    findall(Reason, member(match(_, _, _, Reason), TopMatches), Reasons),
    list_to_sentence(Reasons, Summary).

confidence_label(strong_fit, 'Strong fit').
confidence_label(moderate_fit, 'Moderate fit').
confidence_label(possible_fit, 'Possible fit').

token_label(academic, performed_well(Subject), Label) :-
    subject_label(Subject, SubjectLabel),
    format(atom(Label), 'performed well in ~w', [SubjectLabel]).
token_label(academic, enjoyed(Subject), Label) :-
    subject_label(Subject, SubjectLabel),
    format(atom(Label), 'enjoyed ~w', [SubjectLabel]).
token_label(academic, found_difficult(Subject), Label) :-
    subject_label(Subject, SubjectLabel),
    format(atom(Label), 'found ~w difficult', [SubjectLabel]).
token_label(academic, found_difficult(none), 'reported no clear weak subject').
token_label(academic, did_not_enjoy(Subject), Label) :-
    subject_label(Subject, SubjectLabel),
    format(atom(Label), 'did not enjoy ~w', [SubjectLabel]).
token_label(academic, performance_level(Subject, Level), Label) :-
    subject_label(Subject, SubjectLabel),
    format(atom(Label), '~w performance was ~w', [SubjectLabel, Level]).
token_label(experience, completed_project(Project), Label) :-
    project_label(Project, Label).
token_label(experience, joined(Activity), Label) :-
    activity_label(Activity, Label).
token_label(experience, taught_subject(Subject), Label) :-
    subject_label(Subject, SubjectLabel),
    format(atom(Label), 'has taught or explained ~w', [SubjectLabel]).
token_label(behavior, shows(Trait), Label) :-
    trait_label(Trait, Label).
token_label(preference, prefers(Item), Label) :-
    preference_label(Item, Label).
token_label(preference, work_style(Style), Label) :-
    format(atom(Label), 'prefers ~w work', [Style]).
token_label(preference, prefers_environment(Environment), Label) :-
    environment_label(Environment, Label).
token_label(exclusion, excludes(Item), Label) :-
    once(exclusion_label(Item, Label)).
token_label(goal, values(Goal), Label) :-
    goal_label(Goal, Label).
token_label(direction, leans_toward(Career), Label) :-
    career_label(Career, CareerLabel),
    format(atom(Label), 'leans toward ~w', [CareerLabel]).
token_label(uncertainty, Token, Label) :-
    once(uncertainty_label(Token, Label)).

exclusion_label(none, 'reported no clear exclusion').
exclusion_label(hospital_environment, 'does not want hospital-based work').
exclusion_label(public_speaking_work, 'does not want public-speaking-heavy work').
exclusion_label(routine_office_work, 'does not want routine office work').
exclusion_label(deep_coding_work, 'does not want deep coding-heavy work').
exclusion_label(engineering_work, 'does not want engineering-heavy work').
exclusion_label(direct_patient_care, 'does not want direct patient-care roles').
exclusion_label(sales_heavy_work, 'does not want sales-heavy work').
exclusion_label(law_argument_work, 'does not want legal-argument-heavy work').
exclusion_label(child_classroom_work, 'does not want child-classroom work').
exclusion_label(fieldwork_heavy, 'does not want heavy fieldwork').
exclusion_label(repetitive_lab_work, 'does not want repetitive lab work').
exclusion_label(design_studio_work, 'does not want design-studio work').
exclusion_label(crowded_environments, 'dislikes crowded environments').
exclusion_label(noisy_environments, 'dislikes noisy environments').
exclusion_label(high_interaction_environments, 'dislikes heavy interaction environments').
exclusion_label(high_movement_environments, 'dislikes chaotic or constantly moving environments').
exclusion_label(Item, Label) :-
    format(atom(Label), 'excludes ~w', [Item]).
