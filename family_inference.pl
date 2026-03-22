% Family-level inference with explicit uncertainty handling.

:- module(family_inference, [
    candidate_families/1,
    leading_family/1,
    ranked_families/1
]).

:- use_module(knowledge_base).
:- use_module(profile).

ranked_families(SortedAssessments) :-
    findall(Assessment, assess_family(Assessment), Assessments),
    predsort(compare_family_assessments, Assessments, SortedAssessments).

leading_family(Assessment) :-
    ranked_families([Assessment|_]).

candidate_families(Candidates) :-
    ranked_families([Top|Rest]),
    Top = family_assessment(TopFamily, TopScore, _, _, _, _, _),
    candidate_tail(TopScore, Rest, [TopFamily], Candidates).

candidate_tail(_, [], Acc, Candidates) :-
    reverse(Acc, Candidates).
candidate_tail(TopScore, [family_assessment(Family, Score, _, _, _, _, _)|Rest], Acc, Candidates) :-
    Score > 0,
    (   Score * 100 >= TopScore * 78
    ;   TopScore - Score =< 4
    ),
    !,
    candidate_tail(TopScore, Rest, [Family|Acc], Candidates).
candidate_tail(_, _, Acc, Candidates) :-
    reverse(Acc, Candidates).

assess_family(family_assessment(Family, Score, Coverage, UncertaintyCount, Confidence, SortedPositive, SortedNegative)) :-
    family(Family),
    findall(
        match(Category, Token, Weight, Reason),
        matched_family_rule(Family, Category, Token, Weight, Reason),
        Matches
    ),
    split_matches(Matches, Positive, Negative),
    sum_weights(Positive, PositiveScore),
    sum_weights(Negative, NegativeScore),
    Score is PositiveScore + NegativeScore,
    category_coverage(Positive, Coverage),
    family_uncertainty_count(Family, UncertaintyCount),
    confidence_level(Score, Coverage, UncertaintyCount, Confidence),
    predsort(compare_positive_matches, Positive, SortedPositive),
    predsort(compare_negative_matches, Negative, SortedNegative).

matched_family_rule(Family, Category, Token, Weight, Reason) :-
    profile_fact(Category, Token),
    family_rule(Family, Category, Pattern, Weight, Reason),
    Token = Pattern.

split_matches([], [], []).
split_matches([Match|Rest], [Match|Positive], Negative) :-
    Match = match(_, _, Weight, _),
    Weight > 0,
    !,
    split_matches(Rest, Positive, Negative).
split_matches([Match|Rest], Positive, [Match|Negative]) :-
    split_matches(Rest, Positive, Negative).

sum_weights([], 0).
sum_weights([match(_, _, Weight, _)|Rest], Total) :-
    sum_weights(Rest, Partial),
    Total is Weight + Partial.

category_coverage(Matches, Coverage) :-
    findall(Category, member(match(Category, _, _, _), Matches), Categories),
    sort(Categories, UniqueCategories),
    length(UniqueCategories, Coverage).

family_uncertainty_count(Family, Count) :-
    findall(Token, family_related_uncertainty(Family, Token), Tokens),
    sort(Tokens, UniqueTokens),
    length(UniqueTokens, Count).

family_related_uncertainty(Family, uncertain_about(family(Family))) :-
    profile_fact(uncertainty, uncertain_about(family(Family))).
family_related_uncertainty(_, uncertain_about(general_direction)) :-
    profile_fact(uncertainty, uncertain_about(general_direction)).
family_related_uncertainty(_, mixed_about(work_style)) :-
    profile_fact(uncertainty, mixed_about(work_style)).
family_related_uncertainty(_, uncertain_about(work_environment)) :-
    profile_fact(uncertainty, uncertain_about(work_environment)).

confidence_level(Score, Coverage, UncertaintyCount, strong_fit) :-
    Score >= 20,
    Coverage >= 4,
    UncertaintyCount =< 1,
    !.
confidence_level(Score, Coverage, UncertaintyCount, moderate_fit) :-
    Score >= 12,
    Coverage >= 3,
    UncertaintyCount =< 3,
    !.
confidence_level(_, _, _, possible_fit).

compare_family_assessments(Order, family_assessment(FamilyA, ScoreA, CoverageA, UncertaintyA, _, _, _), family_assessment(FamilyB, ScoreB, CoverageB, UncertaintyB, _, _, _)) :-
    (   ScoreA > ScoreB
    ->  Order = '<'
    ;   ScoreA < ScoreB
    ->  Order = '>'
    ;   CoverageA > CoverageB
    ->  Order = '<'
    ;   CoverageA < CoverageB
    ->  Order = '>'
    ;   UncertaintyA < UncertaintyB
    ->  Order = '<'
    ;   UncertaintyA > UncertaintyB
    ->  Order = '>'
    ;   compare(Order, FamilyA, FamilyB)
    ).

compare_positive_matches(Order, match(_, _, WeightA, ReasonA), match(_, _, WeightB, ReasonB)) :-
    (   WeightA > WeightB
    ->  Order = '<'
    ;   WeightA < WeightB
    ->  Order = '>'
    ;   compare(Order, ReasonA, ReasonB)
    ).

compare_negative_matches(Order, match(_, _, WeightA, ReasonA), match(_, _, WeightB, ReasonB)) :-
    (   WeightA < WeightB
    ->  Order = '<'
    ;   WeightA > WeightB
    ->  Order = '>'
    ;   compare(Order, ReasonA, ReasonB)
    ).
