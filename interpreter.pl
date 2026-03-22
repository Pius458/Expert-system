% Free-text interpretation with clarification-first behaviour.

:- module(interpreter, [
    interpret_response/3,
    menu_selection_facts/3,
    question_menu_options/2
]).

:- use_module(knowledge_base).
:- use_module(utils).

interpret_response(QuestionId, RawInput, Result) :-
    normalize_text(RawInput, Text),
    question_specific_facts(QuestionId, Text, SpecificFacts, ClarifyPrompt),
    generic_cross_facts(QuestionId, Text, CrossFacts),
    append(SpecificFacts, CrossFacts, AllFacts0),
    unique_items(AllFacts0, Facts),
    choose_result(QuestionId, Text, Facts, ClarifyPrompt, Result).

intake_question(QuestionId) :-
    base_question_ids(BaseQuestions),
    member(QuestionId, BaseQuestions).

choose_result(QuestionId, _Text, Facts, _, understood(Facts)) :-
    intake_question(QuestionId),
    Facts \= [],
    !.
choose_result(QuestionId, Text, Facts, _, understood(Facts)) :-
    Facts \= [],
    \+ needs_clarification(QuestionId, Text, Facts),
    !.
choose_result(reflection_correction, Text, [], _, understood([])) :-
    any_phrase(Text, ['nothing', 'nothing important', 'that sounds right', 'that is right', 'you got it', 'mostly right']),
    !.
choose_result(QuestionId, Text, Facts, Prompt, clarify(Facts, FinalPrompt)) :-
    clarification_prompt(QuestionId, Text, Facts, Prompt, FinalPrompt),
    !.
choose_result(QuestionId, Text, [], _, understood([fact(uncertainty, uncertain_about(QuestionId))])) :-
    uncertainty_phrase(Text),
    !.
choose_result(_, _, _, _, unresolved).

needs_clarification(QuestionId, Text, Facts) :-
    clarification_prompt(QuestionId, Text, Facts, none, _).

clarification_prompt(_, _, _, Prompt, Prompt) :-
    nonvar(Prompt),
    Prompt \= none,
    !.
clarification_prompt(opening_narrative, _, Facts, _, 'Could you tell me a little more about the subjects, activities, or experiences that stand out most for you?') :-
    Facts = [],
    !.
clarification_prompt(natural_enjoyment, _, Facts, _, 'Could you say a little more about the kinds of things you naturally drift toward? For example, building, analyzing, helping, teaching, organizing, or creating?') :-
    Facts = [],
    !.
clarification_prompt(known_dislikes, _, Facts, _, 'Could you tell me a little more about the kinds of work, settings, or tasks you already suspect you would dislike?') :-
    Facts = [],
    !.
clarification_prompt(reflection_correction, _, _, _, 'If something is wrong, just tell me what I misunderstood. If something is missing, tell me what I should add.') :-
    fail.
clarification_prompt(strongest_subjects, Text, Facts, _, Prompt) :-
    broad_subject_domain(Text, Domain),
    \+ has_subject_fact(Facts),
    domain_subject_prompt(Domain, Prompt).
clarification_prompt(difficult_subjects, Text, Facts, _, Prompt) :-
    broad_subject_domain(Text, Domain),
    \+ has_subject_fact(Facts),
    domain_subject_prompt(Domain, Prompt).
clarification_prompt(enjoyed_subjects, Text, Facts, _, Prompt) :-
    broad_subject_domain(Text, Domain),
    \+ has_subject_fact(Facts),
    domain_subject_prompt(Domain, Prompt).
clarification_prompt(activities_and_projects, Text, _, _, 'When you say science projects, were they more like lab experiments, health-related activities, engineering builds, or data investigations?') :-
    any_phrase(Text, ['science project', 'science projects']),
    \+ any_phrase(Text, ['lab', 'biology', 'chemistry', 'health', 'engineering', 'robotics', 'electronics', 'data']).
clarification_prompt(activities_and_projects, Text, _, _, 'Could you tell me a little more about those projects or activities? For example, were they technical, health-related, business, media, community, or design-based?') :-
    any_phrase(Text, ['projects', 'activities', 'club', 'competition']),
    \+ any_phrase(Text, ['coding', 'website', 'app', 'data', 'lab', 'health', 'debate', 'business', 'leadership', 'community', 'design', 'art']).
clarification_prompt(preferred_environments, Text, Facts, _, 'When you picture that setting, is it closer to an office, lab, classroom, hospital, studio, workshop, or field-based environment?') :-
    any_phrase(Text, ['something similar', 'it depends', 'not sure', 'somewhere', 'mixed']),
    \+ has_environment_fact(Facts).
clarification_prompt(work_style_preferences, Text, Facts, _, 'If you had to lean one way, would you rather build things, analyze things, explain things, care for people, organize systems, or create things?') :-
    any_phrase(Text, ['both', 'mixed', 'it depends', 'not sure']),
    \+ has_preference_fact(Facts).
clarification_prompt(disliked_environments_paths, Text, Facts, _, 'That is useful. Are you ruling out a setting like hospitals, public speaking, routine office work, heavy fieldwork, deep coding, or something else?') :-
    any_phrase(Text, ['that kind of work', 'something like that', 'not that', 'i do not want that']),
    \+ has_exclusion_fact(Facts).
clarification_prompt(known_dislikes, Text, Facts, _, 'When you say crowded environments, do you mean noise, too much interaction, too much movement, or difficulty focusing?') :-
    has_exclusion_fact(Facts),
    member(fact(exclusion, excludes(crowded_environments)), Facts),
    !,
    any_phrase(Text, ['crowd', 'crowded']).
clarification_prompt(_, _, _, _, _) :-
    fail.

domain_subject_prompt(science, 'Do you mean biology, chemistry, physics, or computer studies?').
domain_subject_prompt(humanities, 'Do you mean English, literature, history, or geography?').
domain_subject_prompt(business, 'Do you mean business studies, economics, or accounting?').
domain_subject_prompt(technology, 'Do you mean computer studies, mathematics, or something more technical?').
domain_subject_prompt(creative, 'Do you mean art and design, or another creative subject?').

has_subject_fact(Facts) :-
    member(fact(academic, performed_well(_)), Facts), !.
has_subject_fact(Facts) :-
    member(fact(academic, enjoyed(_)), Facts), !.
has_subject_fact(Facts) :-
    member(fact(academic, found_difficult(_)), Facts), !.

has_environment_fact(Facts) :-
    member(fact(preference, prefers_environment(_)), Facts).

has_preference_fact(Facts) :-
    member(fact(preference, prefers(_)), Facts), !.
has_preference_fact(Facts) :-
    member(fact(preference, work_style(_)), Facts).

has_exclusion_fact(Facts) :-
    member(fact(exclusion, excludes(_)), Facts).

question_specific_facts(opening_narrative, Text, Facts, none) :-
    interview_narrative_facts(Text, BaseFacts),
    BaseFacts \= [],
    maybe_add_uncertainty(Text, uncertain_about(general_direction), BaseFacts, Facts).
question_specific_facts(opening_narrative, Text, [fact(uncertainty, uncertain_about(general_direction))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(natural_enjoyment, Text, Facts, none) :-
    enjoyment_narrative_facts(Text, BaseFacts),
    BaseFacts \= [],
    maybe_add_uncertainty(Text, uncertain_about(enjoyment_patterns), BaseFacts, Facts).
question_specific_facts(natural_enjoyment, Text, [fact(uncertainty, uncertain_about(enjoyment_patterns))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(known_dislikes, Text, [fact(exclusion, excludes(none))], none) :-
    none_phrase(Text),
    !.
question_specific_facts(known_dislikes, Text, Facts, none) :-
    dislike_narrative_facts(Text, BaseFacts),
    BaseFacts \= [],
    maybe_add_uncertainty(Text, uncertain_about(exclusions), BaseFacts, Facts).
question_specific_facts(known_dislikes, Text, [fact(uncertainty, uncertain_about(exclusions))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(reflection_correction, Text, [], none) :-
    any_phrase(Text, ['nothing', 'nothing important', 'that sounds right', 'that is right', 'you got it', 'mostly right']),
    !.
question_specific_facts(reflection_correction, Text, Facts, none) :-
    interview_narrative_facts(Text, BaseFacts),
    BaseFacts \= [],
    maybe_add_uncertainty(Text, uncertain_about(reflection_correction), BaseFacts, Facts).

question_specific_facts(strongest_subjects, Text, Facts, none) :-
    subject_mentions(Text, Subjects),
    Subjects \= [],
    findall(fact(academic, performed_well(Subject)), member(Subject, Subjects), BaseFacts),
    maybe_add_uncertainty(Text, uncertain_about(subject_strength), BaseFacts, Facts).
question_specific_facts(strongest_subjects, Text, [fact(uncertainty, uncertain_about(subject_strength))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(difficult_subjects, Text, [fact(academic, found_difficult(none))], none) :-
    no_difficulty_phrase(Text),
    !.
question_specific_facts(difficult_subjects, Text, Facts, none) :-
    subject_mentions(Text, Subjects),
    Subjects \= [],
    findall(fact(academic, found_difficult(Subject)), member(Subject, Subjects), Facts).
question_specific_facts(difficult_subjects, Text, [fact(uncertainty, uncertain_about(subject_difficulty))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(enjoyed_subjects, Text, Facts, none) :-
    subject_mentions(Text, Subjects),
    Subjects \= [],
    findall(fact(academic, enjoyed(Subject)), member(Subject, Subjects), BaseFacts),
    maybe_add_uncertainty(Text, uncertain_about(subject_enjoyment), BaseFacts, Facts).
question_specific_facts(enjoyed_subjects, Text, [fact(uncertainty, uncertain_about(subject_enjoyment))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(performance_snapshot, Text, Facts, none) :-
    performance_snapshot_facts(Text, BaseFacts),
    BaseFacts \= [],
    maybe_add_uncertainty(Text, uncertain_about(performance_snapshot), BaseFacts, Facts).
question_specific_facts(performance_snapshot, Text, [fact(uncertainty, uncertain_about(performance_snapshot))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(activities_and_projects, Text, Facts, none) :-
    activity_and_project_facts(Text, BaseFacts),
    BaseFacts \= [],
    maybe_add_uncertainty(Text, uncertain_about(experience_background), BaseFacts, Facts).
question_specific_facts(activities_and_projects, Text, [fact(uncertainty, uncertain_about(experience_background))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(behaviours_and_roles, Text, Facts, none) :-
    behaviour_role_facts(Text, BaseFacts),
    BaseFacts \= [],
    maybe_add_uncertainty(Text, uncertain_about(behavior_patterns), BaseFacts, Facts).
question_specific_facts(behaviours_and_roles, Text, [fact(uncertainty, uncertain_about(behavior_patterns))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(work_style_preferences, Text, Facts, none) :-
    work_style_facts(Text, BaseFacts),
    BaseFacts \= [],
    maybe_add_work_style_uncertainty(Text, BaseFacts, Facts).
question_specific_facts(work_style_preferences, Text, [fact(uncertainty, uncertain_about(general_direction))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(preferred_environments, Text, Facts, none) :-
    environment_facts(Text, BaseFacts),
    BaseFacts \= [],
    maybe_add_uncertainty(Text, uncertain_about(work_environment), BaseFacts, Facts).
question_specific_facts(preferred_environments, Text, [fact(uncertainty, uncertain_about(work_environment))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(disliked_environments_paths, Text, [fact(exclusion, excludes(none))], none) :-
    none_phrase(Text),
    !.
question_specific_facts(disliked_environments_paths, Text, Facts, none) :-
    exclusion_facts(Text, Facts),
    Facts \= [].
question_specific_facts(disliked_environments_paths, Text, [fact(uncertainty, uncertain_about(exclusions))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(motivations, Text, Facts, none) :-
    goal_facts(Text, BaseFacts),
    BaseFacts \= [],
    maybe_add_uncertainty(Text, uncertain_about(goals), BaseFacts, Facts).
question_specific_facts(motivations, Text, [fact(uncertainty, uncertain_about(goals))], none) :-
    uncertainty_phrase(Text).

question_specific_facts(games_interest_clarification, Text, Facts, none) :-
    game_interest_facts(Text, Facts),
    Facts \= [].
question_specific_facts(crowded_environment_clarification, Text, Facts, none) :-
    crowded_environment_facts(Text, Facts),
    Facts \= [].
question_specific_facts(biology_nonhospital_clarification, Text, Facts, none) :-
    biology_nonhospital_facts(Text, Facts),
    Facts \= [].

question_specific_facts(computing_narrowing, Text, Facts, none) :-
    narrowing_direction_facts(computing_it, Text, Facts),
    Facts \= [].
question_specific_facts(engineering_narrowing, Text, Facts, none) :-
    narrowing_direction_facts(engineering_applied_science, Text, Facts),
    Facts \= [].
question_specific_facts(health_narrowing, Text, Facts, none) :-
    narrowing_direction_facts(health_life_sciences, Text, Facts),
    Facts \= [].
question_specific_facts(education_narrowing, Text, Facts, none) :-
    narrowing_direction_facts(education_training, Text, Facts),
    Facts \= [].
question_specific_facts(business_narrowing, Text, Facts, none) :-
    narrowing_direction_facts(business_finance, Text, Facts),
    Facts \= [].
question_specific_facts(media_narrowing, Text, Facts, none) :-
    narrowing_direction_facts(communication_media, Text, Facts),
    Facts \= [].
question_specific_facts(public_service_narrowing, Text, Facts, none) :-
    narrowing_direction_facts(law_public_service, Text, Facts),
    Facts \= [].
question_specific_facts(community_narrowing, Text, Facts, none) :-
    narrowing_direction_facts(social_community_services, Text, Facts),
    Facts \= [].
question_specific_facts(creative_narrowing, Text, Facts, none) :-
    narrowing_direction_facts(creative_arts_design, Text, Facts),
    Facts \= [].
question_specific_facts(_, _, [], none).

generic_cross_facts(known_dislikes, _, []).
generic_cross_facts(disliked_environments_paths, _, []).
generic_cross_facts(_, Text, Facts) :-
    subject_relationship_facts(Text, SubjectFacts),
    activity_and_project_facts(Text, ExperienceFacts),
    behaviour_role_facts(Text, BehaviourFacts),
    work_style_facts(Text, PreferenceFacts),
    environment_facts(Text, EnvironmentFacts),
    exclusion_facts(Text, ExclusionFacts),
    goal_facts(Text, GoalFacts),
    append([SubjectFacts, ExperienceFacts, BehaviourFacts, PreferenceFacts, EnvironmentFacts, ExclusionFacts, GoalFacts], Combined),
    unique_items(Combined, Facts).

interview_narrative_facts(Text, Facts) :-
    subject_relationship_facts(Text, SubjectFacts),
    activity_and_project_facts(Text, ExperienceFacts),
    behaviour_role_facts(Text, BehaviourFacts),
    work_style_facts(Text, PreferenceFacts),
    environment_facts(Text, EnvironmentFacts),
    exclusion_facts(Text, ExclusionFacts),
    goal_facts(Text, GoalFacts),
    extra_narrative_facts(Text, ExtraFacts),
    append([SubjectFacts, ExperienceFacts, BehaviourFacts, PreferenceFacts, EnvironmentFacts, ExclusionFacts, GoalFacts, ExtraFacts], Combined),
    unique_items(Combined, Facts).

enjoyment_narrative_facts(Text, Facts) :-
    subject_relationship_facts(Text, SubjectFacts),
    behaviour_role_facts(Text, BehaviourFacts),
    work_style_facts(Text, PreferenceFacts),
    activity_and_project_facts(Text, ExperienceFacts),
    extra_narrative_facts(Text, ExtraFacts),
    append([SubjectFacts, BehaviourFacts, PreferenceFacts, ExperienceFacts, ExtraFacts], Combined),
    unique_items(Combined, Facts).

dislike_narrative_facts(Text, Facts) :-
    subject_relationship_facts(Text, SubjectFacts),
    exclusion_facts(Text, ExclusionFacts),
    environment_facts(Text, EnvironmentFacts),
    extra_narrative_facts(Text, ExtraFacts),
    append([SubjectFacts, ExclusionFacts, EnvironmentFacts, ExtraFacts], Combined),
    unique_items(Combined, Facts).

extra_narrative_facts(Text, Facts) :-
    findall(Fact, extra_narrative_fact(Text, Fact), Facts).

extra_narrative_fact(Text, fact(uncertainty, mentioned(games_interest))) :-
    any_phrase(Text, ['games', 'gaming', 'video games']).
extra_narrative_fact(Text, fact(exclusion, excludes(crowded_environments))) :-
    negative_phrase(Text),
    any_phrase(Text, ['crowded environments', 'crowds', 'crowded places', 'too crowded']).
extra_narrative_fact(Text, fact(exclusion, excludes(crowded_environments))) :-
    any_phrase(Text, ['i dislike crowded environments', 'i dont like crowded places', 'i do not like crowded places']).

game_interest_facts(Text, Facts) :-
    findall(Fact, game_interest_fact(Text, Fact), Facts).

game_interest_fact(Text, fact(preference, prefers(technical_systems))) :-
    any_phrase(Text, ['programming', 'coding', 'systems']).
game_interest_fact(Text, fact(direction, leans_toward(software_engineering))) :-
    any_phrase(Text, ['programming', 'coding']).
game_interest_fact(Text, fact(preference, prefers(data_analysis))) :-
    any_phrase(Text, ['strategy', 'systems thinking']).
game_interest_fact(Text, fact(behavior, shows(analytical_behavior))) :-
    any_phrase(Text, ['strategy', 'systems thinking']).
game_interest_fact(Text, fact(preference, prefers(design_and_visual_work))) :-
    any_phrase(Text, ['art', 'design', 'visual']).
game_interest_fact(Text, fact(preference, prefers(media_storytelling))) :-
    any_phrase(Text, ['story', 'storytelling', 'world building', 'characters']).
game_interest_fact(Text, fact(direction, leans_toward(animation_game_art))) :-
    any_phrase(Text, ['art', 'design', 'visual', 'story', 'storytelling', 'world building']).
game_interest_fact(Text, fact(uncertainty, uncertain_about(games_interest))) :-
    any_phrase(Text, ['just playing', 'mostly playing', 'not sure']).

crowded_environment_facts(Text, Facts) :-
    findall(Fact, crowded_environment_fact(Text, Fact), Facts).

crowded_environment_fact(Text, fact(exclusion, excludes(noisy_environments))) :-
    any_phrase(Text, ['noise', 'noisy', 'too loud']).
crowded_environment_fact(Text, fact(exclusion, excludes(high_interaction_environments))) :-
    any_phrase(Text, ['too much interaction', 'too many people talking', 'too social']).
crowded_environment_fact(Text, fact(exclusion, excludes(high_movement_environments))) :-
    any_phrase(Text, ['too much movement', 'chaotic movement', 'too much activity']).
crowded_environment_fact(Text, fact(preference, prefers(quiet_focus_work))) :-
    any_phrase(Text, ['difficulty focusing', 'lack of focus', 'focus', 'quiet']).

biology_nonhospital_facts(Text, Facts) :-
    findall(Fact, biology_nonhospital_fact(Text, Fact), Facts).

biology_nonhospital_fact(Text, fact(direction, leans_toward(medical_laboratory_science))) :-
    any_phrase(Text, ['lab', 'laboratory', 'diagnostics']).
biology_nonhospital_fact(Text, fact(direction, leans_toward(public_health))) :-
    any_phrase(Text, ['public health', 'community health', 'community']).
biology_nonhospital_fact(Text, fact(direction, leans_toward(psychology_counseling))) :-
    any_phrase(Text, ['psychology', 'counseling', 'mental health']).
biology_nonhospital_fact(Text, fact(goal, values(research))) :-
    any_phrase(Text, ['research']).
biology_nonhospital_fact(Text, fact(preference, prefers(data_analysis))) :-
    any_phrase(Text, ['research', 'lab']).

maybe_add_uncertainty(Text, Token, Facts, FinalFacts) :-
    (   uncertainty_phrase(Text)
    ->  append(Facts, [fact(uncertainty, Token)], Combined)
    ;   Combined = Facts
    ),
    unique_items(Combined, FinalFacts).

maybe_add_work_style_uncertainty(Text, Facts, FinalFacts) :-
    (   mixed_phrase(Text)
    ->  append(Facts, [fact(uncertainty, mixed_about(work_style))], Combined)
    ;   uncertainty_phrase(Text)
    ->  append(Facts, [fact(uncertainty, uncertain_about(general_direction))], Combined)
    ;   Combined = Facts
    ),
    unique_items(Combined, FinalFacts).

subject_relationship_facts(Text, Facts) :-
    findall(Fact, subject_relationship_fact(Text, Fact), Facts).

subject_relationship_fact(Text, fact(academic, performed_well(Subject))) :-
    subject_positive_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, performance_level(Subject, high))) :-
    subject_positive_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, enjoyed(Subject))) :-
    subject_enjoyment_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, found_difficult(Subject))) :-
    subject_difficulty_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, performance_level(Subject, low))) :-
    subject_difficulty_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, performance_level(Subject, medium))) :-
    subject_medium_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, did_not_enjoy(Subject))) :-
    subject_dislike_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, performed_well(Subject))) :-
    single_subject_reference(Text, Subject),
    any_phrase(Text, ['good at', 'strong in', 'excellent', 'high in', 'performed well']),
    \+ subject_positive_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, enjoyed(Subject))) :-
    single_subject_reference(Text, Subject),
    any_phrase(Text, ['liked', 'enjoyed', 'loved', 'favorite', 'favourite']),
    \+ subject_enjoyment_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, found_difficult(Subject))) :-
    single_subject_reference(Text, Subject),
    any_phrase(Text, ['struggled', 'difficult', 'hard for me', 'poor at']),
    \+ subject_difficulty_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, performance_level(Subject, medium))) :-
    single_subject_reference(Text, Subject),
    any_phrase(Text, ['not strong', 'not very good', 'average']),
    \+ subject_medium_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, did_not_enjoy(Subject))) :-
    single_subject_reference(Text, Subject),
    any_phrase(Text, ['did not enjoy', 'did not like', 'didnt enjoy', 'didnt like', 'hated', 'disliked']),
    \+ subject_dislike_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, performed_well(Subject))) :-
    any_phrase(Text, ['strongest in', 'good at', 'strong in', 'excellent in', 'high in', 'performed well in']),
    \+ any_phrase(Text, ['not my strongest', 'not strongest', 'not strong at', 'not very good at']),
    subject_mentioned(Text, Subject),
    \+ subject_difficulty_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, enjoyed(Subject))) :-
    any_phrase(Text, ['liked', 'enjoyed', 'loved', 'favorite', 'favourite']),
    subject_mentioned(Text, Subject),
    \+ subject_dislike_signal(Text, Subject).
subject_relationship_fact(Text, fact(academic, found_difficult(Subject))) :-
    any_phrase(Text, ['struggled with', 'difficult', 'hard for me', 'weak in']),
    subject_mentioned(Text, Subject),
    \+ no_difficulty_phrase(Text).

subject_positive_signal(Text, Subject) :-
    subject_aliases(Subject, Aliases),
    member(Alias, Aliases),
    positive_subject_phrase(Phrase),
    text_matches_subject_phrase(Text, Alias, Phrase).

subject_enjoyment_signal(Text, Subject) :-
    subject_aliases(Subject, Aliases),
    member(Alias, Aliases),
    enjoyment_phrase(Phrase),
    text_matches_subject_phrase(Text, Alias, Phrase).

subject_difficulty_signal(Text, Subject) :-
    subject_aliases(Subject, Aliases),
    member(Alias, Aliases),
    difficulty_phrase(Phrase),
    text_matches_subject_phrase(Text, Alias, Phrase).

subject_dislike_signal(Text, Subject) :-
    subject_aliases(Subject, Aliases),
    member(Alias, Aliases),
    dislike_phrase(Phrase),
    text_matches_subject_phrase(Text, Alias, Phrase).

subject_medium_signal(Text, Subject) :-
    subject_aliases(Subject, Aliases),
    member(Alias, Aliases),
    medium_phrase(Phrase),
    text_matches_subject_phrase(Text, Alias, Phrase).

text_matches_subject_phrase(Text, Alias, Phrase) :-
    format(atom(Forward), '~w ~w', [Phrase, Alias]),
    contains_phrase(Text, Forward),
    !.
text_matches_subject_phrase(Text, Alias, Phrase) :-
    format(atom(Backward), '~w ~w', [Alias, Phrase]),
    contains_phrase(Text, Backward).

positive_subject_phrase('good at').
positive_subject_phrase('strong in').
positive_subject_phrase('strong at').
positive_subject_phrase('strongest in').
positive_subject_phrase('excellent in').
positive_subject_phrase('high in').
positive_subject_phrase('best subject').
positive_subject_phrase('performed well in').

enjoyment_phrase('liked').
enjoyment_phrase('enjoyed').
enjoyment_phrase('loved').
enjoyment_phrase('favorite').
enjoyment_phrase('favourite').
enjoyment_phrase('interested in').

difficulty_phrase('weak in').
difficulty_phrase('struggled with').
difficulty_phrase('difficult for me').
difficulty_phrase('hard for me').
difficulty_phrase('poor in').
difficulty_phrase('bad at').

dislike_phrase('did not enjoy').
dislike_phrase('did not like').
dislike_phrase('didnt enjoy').
dislike_phrase('didnt like').
dislike_phrase('hated').
dislike_phrase('disliked').

medium_phrase('average in').
medium_phrase('okay in').
medium_phrase('not strong in').
medium_phrase('not very good at').
medium_phrase('fair in').

performance_snapshot_facts(Text, Facts) :-
    findall(Fact, performance_snapshot_fact(Text, Fact), Facts).

performance_snapshot_fact(Text, fact(academic, performance_level(Subject, high))) :-
    subject_positive_signal(Text, Subject).
performance_snapshot_fact(Text, fact(academic, performed_well(Subject))) :-
    subject_positive_signal(Text, Subject).
performance_snapshot_fact(Text, fact(academic, performance_level(Subject, medium))) :-
    subject_medium_signal(Text, Subject).
performance_snapshot_fact(Text, fact(academic, performance_level(Subject, low))) :-
    subject_difficulty_signal(Text, Subject).
performance_snapshot_fact(Text, fact(academic, found_difficult(Subject))) :-
    subject_difficulty_signal(Text, Subject).

activity_and_project_facts(Text, Facts) :-
    findall(fact(experience, completed_project(Project)), project_mentioned(Text, Project), ProjectFacts),
    findall(fact(experience, joined(Activity)), activity_mentioned(Text, Activity), ActivityFacts),
    findall(fact(experience, taught_subject(Subject)), teaching_subject_mentioned(Text, Subject), TeachingFacts),
    append([ProjectFacts, ActivityFacts, TeachingFacts], Facts).

behaviour_role_facts(Text, Facts) :-
    findall(fact(behavior, shows(Trait)), trait_mentioned(Text, Trait), TraitFacts),
    findall(fact(experience, joined(Activity)), leadership_or_support_activity(Text, Activity), ActivityFacts),
    append(TraitFacts, ActivityFacts, Facts).

work_style_facts(Text, Facts) :-
    findall(fact(preference, prefers(Preference)), preference_mentioned(Text, Preference), PreferenceFacts),
    findall(fact(preference, work_style(Style)), work_style_mentioned(Text, Style), StyleFacts),
    append(PreferenceFacts, StyleFacts, Facts).

environment_facts(Text, Facts) :-
    findall(fact(preference, prefers_environment(Environment)), environment_positive_mentioned(Text, Environment), Facts).

exclusion_facts(Text, Facts) :-
    findall(fact(exclusion, excludes(Item)), exclusion_mentioned(Text, Item), Facts).

goal_facts(Text, Facts) :-
    findall(fact(goal, values(Goal)), goal_mentioned(Text, Goal), Facts).

narrowing_direction_facts(Family, Text, Facts) :-
    findall(fact(direction, leans_toward(Career)), career_direction_mentioned(Family, Text, Career), Facts).

subject_mentions(Text, Subjects) :-
    findall(Subject, subject_mentioned(Text, Subject), RawSubjects),
    sort(RawSubjects, Subjects).

single_subject_reference(Text, Subject) :-
    subject_mentions(Text, [Subject]).

subject_mentioned(Text, Subject) :-
    subject_aliases(Subject, Aliases),
    member(Alias, Aliases),
    contains_phrase(Text, Alias).

project_mentioned(Text, Project) :-
    project_aliases(Project, Aliases),
    member(Alias, Aliases),
    contains_phrase(Text, Alias).

activity_mentioned(Text, Activity) :-
    activity_aliases(Activity, Aliases),
    member(Alias, Aliases),
    contains_phrase(Text, Alias).

leadership_or_support_activity(Text, peer_tutoring) :-
    teaching_subject_mentioned(Text, _),
    !.
leadership_or_support_activity(Text, student_leadership) :-
    any_phrase(Text, ['led a team', 'led others', 'coordinated others', 'captain', 'class representative', 'prefect']).

teaching_subject_mentioned(Text, Subject) :-
    any_phrase(Text, ['teach', 'teaching', 'tutor', 'tutoring', 'explaining', 'explain to classmates', 'help classmates']),
    subject_mentioned(Text, Subject).

trait_mentioned(Text, teaching_behavior) :-
    any_phrase(Text, ['teach', 'teaching', 'tutor', 'tutoring', 'explain', 'explaining', 'explained']).
trait_mentioned(Text, leadership_behavior) :-
    any_phrase(Text, ['lead', 'leading', 'coordinating', 'captain', 'organized others']).
trait_mentioned(Text, problem_solving_behavior) :-
    any_phrase(Text, ['solve problems', 'solving problems', 'problem solving', 'troubleshooting', 'figure things out']).
trait_mentioned(Text, analytical_behavior) :-
    any_phrase(Text, ['analysis', 'analyzing', 'analytical', 'logic', 'logical', 'careful reasoning']).
trait_mentioned(Text, communication_behavior) :-
    any_phrase(Text, ['communication', 'speaking', 'writing', 'presenting', 'public speaking']).
trait_mentioned(Text, helping_behavior) :-
    any_phrase(Text, ['help people', 'support people', 'care for people', 'assist others']).
trait_mentioned(Text, practical_builder_behavior) :-
    any_phrase(Text, ['build things', 'hands on', 'practical work', 'repair', 'fixing']).
trait_mentioned(Text, organization_behavior) :-
    any_phrase(Text, ['organized', 'organizing things', 'planning', 'arranging', 'coordination']).
trait_mentioned(Text, creative_behavior) :-
    any_phrase(Text, ['creative', 'designing', 'artistic', 'imaginative']).
trait_mentioned(Text, research_behavior) :-
    any_phrase(Text, ['research', 'investigate', 'investigation', 'experiment']).
trait_mentioned(Text, empathy_behavior) :-
    any_phrase(Text, ['empathy', 'empathetic', 'listening', 'patient with people']).

preference_mentioned(Text, technical_systems) :-
    any_phrase(Text, ['systems', 'technology', 'computers', 'it work']).
preference_mentioned(Text, data_analysis) :-
    any_phrase(Text, ['data', 'analysis', 'analyze things', 'analytics', 'statistics', 'patterns']).
preference_mentioned(Text, people_helping) :-
    any_phrase(Text, ['help people', 'support people', 'care for people', 'clients', 'patients']).
preference_mentioned(Text, teaching_and_explaining) :-
    any_phrase(Text, ['teaching', 'explaining', 'explain things', 'training', 'guiding learners']).
preference_mentioned(Text, design_and_visual_work) :-
    any_phrase(Text, ['design', 'visual', 'graphics', 'art work', 'creative work', 'create things', 'creating']).
preference_mentioned(Text, business_processes) :-
    any_phrase(Text, ['business processes', 'organize systems', 'organizing systems', 'organizing', 'operations', 'management', 'enterprise']).
preference_mentioned(Text, numbers_and_records) :-
    any_phrase(Text, ['numbers', 'calculations', 'accounting', 'finance']).
preference_mentioned(Text, law_policy_debate) :-
    any_phrase(Text, ['law', 'policy', 'justice', 'debate', 'governance']).
preference_mentioned(Text, community_support) :-
    any_phrase(Text, ['community', 'social programs', 'development work', 'ngo']).
preference_mentioned(Text, machines_and_structures) :-
    any_phrase(Text, ['build things', 'machines', 'structures', 'construction', 'robotics', 'electronics']).
preference_mentioned(Text, media_storytelling) :-
    any_phrase(Text, ['media', 'storytelling', 'journalism', 'content']).
preference_mentioned(Text, caring_for_people) :-
    any_phrase(Text, ['patient care', 'health care', 'caring for people']).
preference_mentioned(Text, user_facing_technology) :-
    any_phrase(Text, ['web', 'mobile', 'products for users', 'user experience']).

work_style_mentioned(Text, practical) :-
    any_phrase(Text, ['practical', 'hands on', 'build things', 'real world']).
work_style_mentioned(Text, theoretical) :-
    any_phrase(Text, ['theory', 'theoretical', 'conceptual']).
work_style_mentioned(Text, mixed) :-
    mixed_phrase(Text).

environment_positive_mentioned(Text, office_environment) :-
    \+ negative_environment_reference(Text, ['office', 'desk', 'corporate']),
    any_phrase(Text, ['office', 'desk', 'corporate']).
environment_positive_mentioned(Text, lab_environment) :-
    \+ negative_environment_reference(Text, ['lab', 'laboratory']),
    any_phrase(Text, ['lab', 'laboratory']).
environment_positive_mentioned(Text, classroom_environment) :-
    \+ negative_environment_reference(Text, ['classroom', 'school setting']),
    any_phrase(Text, ['classroom', 'school setting']).
environment_positive_mentioned(Text, field_environment) :-
    \+ negative_environment_reference(Text, ['field work', 'outdoors', 'site work']),
    any_phrase(Text, ['field work', 'outdoors', 'site work']).
environment_positive_mentioned(Text, hospital_environment) :-
    \+ negative_environment_reference(Text, ['hospital', 'clinic', 'ward']),
    any_phrase(Text, ['hospital', 'clinic', 'ward']).
environment_positive_mentioned(Text, studio_environment) :-
    \+ negative_environment_reference(Text, ['studio', 'creative studio']),
    any_phrase(Text, ['studio', 'creative studio']).
environment_positive_mentioned(Text, workshop_environment) :-
    \+ negative_environment_reference(Text, ['workshop', 'technical room', 'practical lab']),
    any_phrase(Text, ['workshop', 'technical room', 'practical lab']).

negative_environment_reference(Text, Aliases) :-
    negative_phrase(Text),
    member(Alias, Aliases),
    contains_phrase(Text, Alias),
    !.

exclusion_mentioned(Text, hospital_environment) :-
    negative_phrase(Text),
    any_phrase(Text, ['hospital', 'clinic', 'ward']).
exclusion_mentioned(Text, public_speaking_work) :-
    negative_phrase(Text),
    any_phrase(Text, ['public speaking', 'debate', 'presenting']).
exclusion_mentioned(Text, routine_office_work) :-
    negative_phrase(Text),
    any_phrase(Text, ['routine office', 'desk job', 'paperwork', 'office all day']).
exclusion_mentioned(Text, deep_coding_work) :-
    negative_phrase(Text),
    any_phrase(Text, ['deep coding', 'coding all day', 'programming all day', 'hardcore coding']).
exclusion_mentioned(Text, engineering_work) :-
    negative_phrase(Text),
    any_phrase(Text, ['engineering', 'engineering work']).
exclusion_mentioned(Text, direct_patient_care) :-
    negative_phrase(Text),
    any_phrase(Text, ['patient care', 'ward work', 'nursing']).
exclusion_mentioned(Text, sales_heavy_work) :-
    negative_phrase(Text),
    any_phrase(Text, ['sales', 'selling', 'cold calling']).
exclusion_mentioned(Text, law_argument_work) :-
    negative_phrase(Text),
    any_phrase(Text, ['law', 'courtroom', 'legal argument']).
exclusion_mentioned(Text, child_classroom_work) :-
    negative_phrase(Text),
    any_phrase(Text, ['young children', 'early childhood', 'small kids']).
exclusion_mentioned(Text, fieldwork_heavy) :-
    negative_phrase(Text),
    any_phrase(Text, ['field work', 'outdoors all day', 'site work']).
exclusion_mentioned(Text, repetitive_lab_work) :-
    negative_phrase(Text),
    any_phrase(Text, ['lab work', 'laboratory work', 'repetitive lab']).
exclusion_mentioned(Text, design_studio_work) :-
    negative_phrase(Text),
    any_phrase(Text, ['design studio', 'studio design', 'graphic design']).

goal_mentioned(Text, stability) :-
    any_phrase(Text, ['stability', 'secure job', 'job security']).
goal_mentioned(Text, income) :-
    any_phrase(Text, ['income', 'money', 'salary', 'financial reward']).
goal_mentioned(Text, social_impact) :-
    any_phrase(Text, ['impact', 'help society', 'make a difference', 'change lives']).
goal_mentioned(Text, creativity) :-
    any_phrase(Text, ['creativity', 'creative freedom', 'express myself']).
goal_mentioned(Text, entrepreneurship) :-
    any_phrase(Text, ['entrepreneurship', 'my own business', 'startup', 'build a business']).
goal_mentioned(Text, technical_mastery) :-
    any_phrase(Text, ['technical mastery', 'deep technical', 'expert in something technical']).
goal_mentioned(Text, public_service) :-
    any_phrase(Text, ['public service', 'serve the public', 'government service']).
goal_mentioned(Text, leadership) :-
    any_phrase(Text, ['leadership', 'responsibility', 'leading people']).
goal_mentioned(Text, research) :-
    any_phrase(Text, ['research', 'discovery', 'innovation']).

career_direction_mentioned(Family, Text, Career) :-
    career(Career, Family),
    career_direction_aliases(Career, Aliases),
    member(Alias, Aliases),
    \+ negative_alias_reference(Text, Alias),
    contains_phrase(Text, Alias).

negative_alias_reference(Text, Alias) :-
    marker_before_alias(Text, 'rather than', Alias),
    !.
negative_alias_reference(Text, Alias) :-
    marker_before_alias(Text, 'instead of', Alias),
    !.
negative_alias_reference(Text, Alias) :-
    marker_before_alias(Text, 'do not want', Alias),
    !.
negative_alias_reference(Text, Alias) :-
    marker_before_alias(Text, 'dont want', Alias),
    !.
negative_alias_reference(Text, Alias) :-
    marker_before_alias(Text, 'not', Alias),
    contains_phrase(Text, Alias),
    !.

marker_before_alias(Text, Marker, Alias) :-
    normalize_text(Text, NormalizedText),
    normalize_text(Marker, NormalizedMarker),
    normalize_text(Alias, NormalizedAlias),
    sub_atom(NormalizedText, MarkerPos, _, _, NormalizedMarker),
    sub_atom(NormalizedText, AliasPos, _, _, NormalizedAlias),
    AliasPos > MarkerPos.

none_phrase(Text) :-
    any_phrase(Text, ['none', 'nothing', 'no particular one', 'not really any']).

no_difficulty_phrase(Text) :-
    any_phrase(Text, ['none', 'no weak subject', 'no weak subjects', 'no clear weak subject', 'i did not have a weak subject', 'i didnt have a weak subject', 'nothing really']).

uncertainty_phrase(Text) :-
    any_phrase(Text, ['not sure', 'i do not know', 'i dont know', 'do not know', 'dont know', 'maybe', 'it depends']).

mixed_phrase(Text) :-
    any_phrase(Text, ['both', 'mixed', 'it depends', 'a mix', 'combination']).

negative_phrase(Text) :-
    any_phrase(Text, ['do not want', 'dont want', 'do not like', 'dont like', 'would not want', 'avoid', 'dislike', 'hate', 'not interested in']).

broad_subject_domain(Text, science) :-
    contains_phrase(Text, 'science'),
    !.
broad_subject_domain(Text, humanities) :-
    any_phrase(Text, ['humanities', 'arts subjects', 'languages']),
    !.
broad_subject_domain(Text, business) :-
    any_phrase(Text, ['business', 'commerce']),
    !.
broad_subject_domain(Text, technology) :-
    any_phrase(Text, ['technology', 'computers', 'it']),
    !.
broad_subject_domain(Text, creative) :-
    any_phrase(Text, ['art', 'design', 'creative']),
    !.

question_menu_options(strongest_subjects, Options) :-
    subject_options(Options).
question_menu_options(difficult_subjects, Options) :-
    subject_options(Options).
question_menu_options(enjoyed_subjects, Options) :-
    subject_options(Options).
question_menu_options(activities_and_projects, [
    option(coding_project, 'Coding, app, or website projects'),
    option(data_project, 'Data or analytics projects'),
    option(security_project, 'Security or networking projects'),
    option(science_lab_project, 'Lab or science investigation'),
    option(health_project, 'Health or outreach activities'),
    option(business_project, 'Business or enterprise activities'),
    option(media_project, 'Writing, media, or debate activities'),
    option(design_project, 'Art or design projects'),
    option(community_project, 'Community service or volunteering'),
    option(leadership_activity, 'Leadership role or coordination')
]).
question_menu_options(work_style_preferences, [
    option(technical_systems, 'Working with technical systems'),
    option(data_analysis, 'Analyzing data and patterns'),
    option(people_helping, 'Helping people directly'),
    option(teaching_and_explaining, 'Teaching or explaining'),
    option(design_and_visual_work, 'Creating or designing things'),
    option(business_processes, 'Business and enterprise work'),
    option(law_policy_debate, 'Law, policy, or debate'),
    option(community_support, 'Community and social support')
]).
question_menu_options(preferred_environments, [
    option(office_environment, 'Office environment'),
    option(lab_environment, 'Laboratory environment'),
    option(classroom_environment, 'Classroom environment'),
    option(field_environment, 'Fieldwork or site environment'),
    option(hospital_environment, 'Hospital or clinic'),
    option(studio_environment, 'Studio or creative space'),
    option(workshop_environment, 'Workshop or technical room')
]).
question_menu_options(disliked_environments_paths, [
    option(hospital_environment, 'Hospital work'),
    option(public_speaking_work, 'Public speaking heavy work'),
    option(routine_office_work, 'Routine office work'),
    option(deep_coding_work, 'Deep coding work'),
    option(engineering_work, 'Engineering-heavy work'),
    option(direct_patient_care, 'Direct patient-care work'),
    option(sales_heavy_work, 'Sales-heavy work'),
    option(law_argument_work, 'Legal argument-heavy work')
]).
question_menu_options(motivations, [
    option(stability, 'Stability and security'),
    option(income, 'Income and financial reward'),
    option(social_impact, 'Social impact'),
    option(creativity, 'Creativity'),
    option(entrepreneurship, 'Entrepreneurship'),
    option(technical_mastery, 'Technical mastery'),
    option(public_service, 'Public service'),
    option(leadership, 'Leadership'),
    option(research, 'Research and discovery')
]).
question_menu_options(computing_narrowing, Options) :-
    career_direction_options(computing_it, Options).
question_menu_options(engineering_narrowing, Options) :-
    career_direction_options(engineering_applied_science, Options).
question_menu_options(health_narrowing, Options) :-
    career_direction_options(health_life_sciences, Options).
question_menu_options(education_narrowing, Options) :-
    career_direction_options(education_training, Options).
question_menu_options(business_narrowing, Options) :-
    career_direction_options(business_finance, Options).
question_menu_options(media_narrowing, Options) :-
    career_direction_options(communication_media, Options).
question_menu_options(public_service_narrowing, Options) :-
    career_direction_options(law_public_service, Options).
question_menu_options(community_narrowing, Options) :-
    career_direction_options(social_community_services, Options).
question_menu_options(creative_narrowing, Options) :-
    career_direction_options(creative_arts_design, Options).

menu_selection_facts(strongest_subjects, Keys, Facts) :-
    findall(fact(academic, performed_well(Key)), member(Key, Keys), Facts).
menu_selection_facts(difficult_subjects, Keys, Facts) :-
    findall(fact(academic, found_difficult(Key)), member(Key, Keys), Facts).
menu_selection_facts(enjoyed_subjects, Keys, Facts) :-
    findall(fact(academic, enjoyed(Key)), member(Key, Keys), Facts).
menu_selection_facts(activities_and_projects, Keys, Facts) :-
    findall(Fact, menu_experience_fact(Keys, Fact), Facts).
menu_selection_facts(work_style_preferences, Keys, Facts) :-
    findall(fact(preference, prefers(Key)), member(Key, Keys), Facts).
menu_selection_facts(preferred_environments, Keys, Facts) :-
    findall(fact(preference, prefers_environment(Key)), member(Key, Keys), Facts).
menu_selection_facts(disliked_environments_paths, Keys, Facts) :-
    findall(fact(exclusion, excludes(Key)), member(Key, Keys), Facts).
menu_selection_facts(motivations, Keys, Facts) :-
    findall(fact(goal, values(Key)), member(Key, Keys), Facts).
menu_selection_facts(QuestionId, Keys, Facts) :-
    narrowing_question_family(QuestionId, Family),
    findall(fact(direction, leans_toward(Key)), (member(Key, Keys), career(Key, Family)), Facts).

menu_experience_fact(Keys, fact(experience, completed_project(coding_project))) :- member(coding_project, Keys).
menu_experience_fact(Keys, fact(experience, completed_project(data_project))) :- member(data_project, Keys).
menu_experience_fact(Keys, fact(experience, completed_project(security_project))) :- member(security_project, Keys).
menu_experience_fact(Keys, fact(experience, completed_project(science_lab_project))) :- member(science_lab_project, Keys).
menu_experience_fact(Keys, fact(experience, completed_project(health_project))) :- member(health_project, Keys).
menu_experience_fact(Keys, fact(experience, completed_project(business_project))) :- member(business_project, Keys).
menu_experience_fact(Keys, fact(experience, completed_project(media_project))) :- member(media_project, Keys).
menu_experience_fact(Keys, fact(experience, completed_project(design_project))) :- member(design_project, Keys).
menu_experience_fact(Keys, fact(experience, joined(community_service))) :- member(community_project, Keys).
menu_experience_fact(Keys, fact(experience, joined(student_leadership))) :- member(leadership_activity, Keys).

subject_options([
    option(mathematics, 'Mathematics'),
    option(physics, 'Physics'),
    option(chemistry, 'Chemistry'),
    option(biology, 'Biology'),
    option(computer_studies, 'Computer Studies / ICT'),
    option(english, 'English / Writing'),
    option(literature, 'Literature / Languages'),
    option(history, 'History / Government'),
    option(geography, 'Geography'),
    option(economics, 'Economics'),
    option(business_studies, 'Business Studies / Commerce'),
    option(accounting, 'Accounting'),
    option(art_design, 'Art / Design')
]).

career_direction_options(Family, Options) :-
    findall(option(Career, Label), (career(Career, Family), career_label(Career, Label)), Options).

narrowing_question_family(computing_narrowing, computing_it).
narrowing_question_family(engineering_narrowing, engineering_applied_science).
narrowing_question_family(health_narrowing, health_life_sciences).
narrowing_question_family(education_narrowing, education_training).
narrowing_question_family(business_narrowing, business_finance).
narrowing_question_family(media_narrowing, communication_media).
narrowing_question_family(public_service_narrowing, law_public_service).
narrowing_question_family(community_narrowing, social_community_services).
narrowing_question_family(creative_narrowing, creative_arts_design).

subject_aliases(mathematics, ['math', 'maths', 'mathematics', 'algebra', 'calculus']).
subject_aliases(physics, ['physics']).
subject_aliases(chemistry, ['chemistry']).
subject_aliases(biology, ['biology']).
subject_aliases(computer_studies, ['computer studies', 'ict', 'computing', 'computer']).
subject_aliases(english, ['english', 'writing']).
subject_aliases(literature, ['literature', 'language', 'languages']).
subject_aliases(history, ['history', 'government']).
subject_aliases(geography, ['geography']).
subject_aliases(economics, ['economics']).
subject_aliases(business_studies, ['business studies', 'business', 'commerce']).
subject_aliases(accounting, ['accounting', 'accounts']).
subject_aliases(art_design, ['art', 'design', 'drawing']).

project_aliases(coding_project, ['coding', 'programming', 'website', 'websites', 'app', 'apps', 'software project']).
project_aliases(data_project, ['data analysis', 'analytics', 'machine learning', 'ai project', 'data project']).
project_aliases(security_project, ['cybersecurity project', 'security project', 'ethical hacking', 'network security']).
project_aliases(science_lab_project, ['science fair', 'lab project', 'experiment', 'laboratory']).
project_aliases(health_project, ['health outreach', 'health project', 'clinic volunteer']).
project_aliases(business_project, ['business idea', 'market day', 'enterprise project', 'selling project']).
project_aliases(media_project, ['article', 'school magazine', 'podcast', 'reporting', 'media project']).
project_aliases(design_project, ['poster design', 'portfolio', 'illustration', 'logo design', 'fashion sketch']).
project_aliases(community_project, ['community project', 'outreach', 'volunteering', 'charity work']).

activity_aliases(coding_club, ['coding club', 'ict club', 'programming club', 'hackathon']).
activity_aliases(science_fair, ['science fair', 'science club']).
activity_aliases(debate_public_speaking, ['debate club', 'debate', 'public speaking', 'speech']).
activity_aliases(peer_tutoring, ['peer tutoring', 'tutoring', 'helping classmates']).
activity_aliases(student_leadership, ['prefect', 'class representative', 'captain', 'club leader', 'student council']).
activity_aliases(business_club, ['business club', 'enterprise club']).
activity_aliases(media_club, ['journalism club', 'media club', 'school magazine']).
activity_aliases(community_service, ['community service', 'volunteering', 'charity']).
activity_aliases(art_club, ['art club', 'design club']).
activity_aliases(civic_club, ['model un', 'youth parliament', 'government club']).

career_direction_aliases(software_engineering, ['software engineering', 'software', 'backend', 'building software']).
career_direction_aliases(web_development, ['web development', 'web', 'websites']).
career_direction_aliases(mobile_development, ['mobile development', 'mobile apps', 'apps']).
career_direction_aliases(data_science, ['data science', 'analytics', 'data']).
career_direction_aliases(ai_machine_learning, ['ai', 'artificial intelligence', 'machine learning']).
career_direction_aliases(cybersecurity, ['cybersecurity', 'security', 'ethical hacking']).
career_direction_aliases(networking_administration, ['networking', 'networks', 'systems administration']).
career_direction_aliases(cloud_devops, ['cloud', 'devops', 'deployment', 'infrastructure automation']).
career_direction_aliases(database_administration, ['database', 'databases', 'database administration']).
career_direction_aliases(ui_ux_design, ['ui', 'ux', 'user experience', 'interface design']).
career_direction_aliases(systems_analysis, ['systems analysis', 'systems analyst', 'analyzing business systems']).
career_direction_aliases(business_information_systems, ['business information systems', 'business systems', 'technology for business']).
career_direction_aliases(civil_structural_engineering, ['civil engineering', 'structures', 'infrastructure', 'construction']).
career_direction_aliases(mechanical_mechatronics_engineering, ['mechanical engineering', 'robotics', 'mechatronics', 'machines']).
career_direction_aliases(electrical_electronics_engineering, ['electrical engineering', 'electronics', 'power systems']).
career_direction_aliases(environmental_energy_engineering, ['environmental engineering', 'energy engineering', 'renewable energy']).
career_direction_aliases(architecture_built_environment, ['architecture', 'built environment', 'spatial design']).
career_direction_aliases(medicine, ['medicine', 'doctor']).
career_direction_aliases(nursing, ['nursing', 'nurse', 'patient care']).
career_direction_aliases(pharmacy, ['pharmacy', 'pharmacist', 'medicines']).
career_direction_aliases(medical_laboratory_science, ['medical laboratory', 'lab diagnostics', 'laboratory science']).
career_direction_aliases(public_health, ['public health', 'community health']).
career_direction_aliases(mathematics_education, ['math education', 'teaching maths', 'teach mathematics']).
career_direction_aliases(science_education, ['science education', 'teaching science']).
career_direction_aliases(language_humanities_education, ['language education', 'teaching english', 'humanities education']).
career_direction_aliases(educational_guidance_counseling, ['guidance', 'school counseling', 'educational counseling']).
career_direction_aliases(accounting, ['accounting']).
career_direction_aliases(finance_banking, ['finance', 'banking', 'investment']).
career_direction_aliases(marketing_digital_marketing, ['marketing', 'digital marketing', 'branding']).
career_direction_aliases(entrepreneurship_business_development, ['entrepreneurship', 'startup', 'business development']).
career_direction_aliases(operations_supply_chain, ['operations', 'supply chain', 'logistics']).
career_direction_aliases(journalism_reporting, ['journalism', 'reporting']).
career_direction_aliases(public_relations_communications, ['public relations', 'communications']).
career_direction_aliases(broadcasting_multimedia_production, ['broadcasting', 'multimedia', 'media production']).
career_direction_aliases(technical_writing_documentation, ['technical writing', 'documentation']).
career_direction_aliases(law, ['law', 'lawyer']).
career_direction_aliases(public_administration_policy, ['public administration', 'policy']).
career_direction_aliases(international_relations_diplomacy, ['international relations', 'diplomacy']).
career_direction_aliases(criminology_security_studies, ['criminology', 'security studies', 'justice']).
career_direction_aliases(psychology_counseling, ['psychology', 'counseling', 'therapy']).
career_direction_aliases(social_work, ['social work']).
career_direction_aliases(human_resource_management, ['human resources', 'hr']).
career_direction_aliases(community_development_ngo, ['community development', 'ngo work', 'development work', 'community and ngo']).
career_direction_aliases(graphic_communication_design, ['graphic design', 'graphic communication']).
career_direction_aliases(animation_game_art, ['animation', 'game art']).
career_direction_aliases(fashion_design, ['fashion design', 'fashion']).
career_direction_aliases(interior_spatial_design, ['interior design', 'spatial design']).
