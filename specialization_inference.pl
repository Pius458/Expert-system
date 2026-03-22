% Specialization inference within the strongest family or families.

:- module(specialization_inference, [
    ranked_careers/2,
    specialization_recommendations/3,
    specialization_recommendations/4
]).

:- use_module(knowledge_base).
:- use_module(profile).

ranked_careers(Families, SortedAssessments) :-
    findall(Assessment, assess_career(Families, Assessment), Assessments),
    predsort(compare_career_assessments, Assessments, SortedAssessments).

specialization_recommendations(Families, Primary, Secondary) :-
    ranked_careers(Families, [Primary|Rest]),
    choose_secondary(Primary, Rest, Secondary).

specialization_recommendations(Families, Primary, Secondary, RankedAssessments) :-
    ranked_careers(Families, RankedAssessments),
    RankedAssessments = [Primary|Rest],
    choose_secondary(Primary, Rest, Secondary).

assess_career(Families, career_assessment(Career, Family, Score, Coverage, UncertaintyCount, Confidence, SortedPositive, SortedNegative)) :-
    career(Career, Family),
    member(Family, Families),
    findall(
        match(Category, Token, Weight, Reason),
        matched_career_rule(Career, Category, Token, Weight, Reason),
        Matches
    ),
    split_matches(Matches, Positive, Negative),
    sum_weights(Positive, PositiveScore),
    sum_weights(Negative, NegativeScore),
    Score is PositiveScore + NegativeScore,
    category_coverage(Positive, Coverage),
    career_uncertainty_count(Career, Family, UncertaintyCount),
    confidence_level(Score, Coverage, UncertaintyCount, Confidence),
    predsort(compare_positive_matches, Positive, SortedPositive),
    predsort(compare_negative_matches, Negative, SortedNegative).

matched_career_rule(Career, Category, Token, Weight, Reason) :-
    profile_fact(Category, Token),
    career_rule(Career, Category, Pattern, Weight, Reason),
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

career_uncertainty_count(Career, Family, Count) :-
    findall(Token, career_related_uncertainty(Career, Family, Token), Tokens),
    sort(Tokens, UniqueTokens),
    length(UniqueTokens, Count).

career_related_uncertainty(Career, _, uncertain_about(career(Career))) :-
    profile_fact(uncertainty, uncertain_about(career(Career))).
career_related_uncertainty(_, Family, uncertain_about(family(Family))) :-
    profile_fact(uncertainty, uncertain_about(family(Family))).
career_related_uncertainty(_, _, mixed_about(work_style)) :-
    profile_fact(uncertainty, mixed_about(work_style)).
career_related_uncertainty(_, _, uncertain_about(work_environment)) :-
    profile_fact(uncertainty, uncertain_about(work_environment)).

confidence_level(Score, Coverage, UncertaintyCount, strong_fit) :-
    Score >= 16,
    Coverage >= 4,
    UncertaintyCount =< 1,
    !.
confidence_level(Score, Coverage, UncertaintyCount, moderate_fit) :-
    Score >= 10,
    Coverage >= 3,
    UncertaintyCount =< 3,
    !.
confidence_level(_, _, _, possible_fit).

choose_secondary(career_assessment(_, _, PrimaryScore, _, _, _, _, _), [Candidate|_], Candidate) :-
    Candidate = career_assessment(_, _, CandidateScore, CandidateCoverage, _, _, _, _),
    CandidateScore > 0,
    CandidateCoverage >= 2,
    (   CandidateScore * 100 >= PrimaryScore * 80
    ;   PrimaryScore - CandidateScore =< 3
    ),
    !.
choose_secondary(Primary, [_|Rest], Secondary) :-
    choose_secondary(Primary, Rest, Secondary).
choose_secondary(_, [], none).

compare_career_assessments(Order, career_assessment(CareerA, _, ScoreA, CoverageA, UncertaintyA, _, _, _), career_assessment(CareerB, _, ScoreB, CoverageB, UncertaintyB, _, _, _)) :-
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
    ;   compare(Order, CareerA, CareerB)
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
