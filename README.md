# Conversational Career Interview and Guidance Expert System Using Prolog

## Overview

This project is a rule-based expert system written in SWI-Prolog. It is designed to behave like a short career interview rather than a questionnaire.

The system follows this pipeline:

1. **narrative intake**
2. **interpretation**
3. **reflection**
4. **clarification**
5. **inference**
6. **guidance**

Instead of asking a long sequence of fixed survey questions, it begins with a small number of broad prompts, extracts evidence from the user narrative, summarizes what it believes, asks only targeted follow-up questions where needed, then recommends a career family and likely specialization.

## Core Features

- narrative intake with broad free-text prompts
- interpretation layer that extracts structured evidence from natural answers
- reflection step: the system summarizes what it thinks it heard
- clarification step driven by ambiguity, contradiction, or missing evidence
- hierarchical inference from broad family to specialization
- uncertainty handling for answers like `none`, `both`, `mixed`, `not sure`, `it depends`
- negative evidence and exclusions such as avoiding hospital work or deep coding
- explanation of fit, concerns, and validation steps
- restart support from the terminal

## Supported Career Families

- Computing and IT
- Engineering and Applied Science
- Health and Life Sciences
- Education and Training
- Business and Finance
- Communication and Media
- Law and Public Service
- Social and Community Services
- Creative Arts and Design

## Supported Career Specializations

The system currently supports 47 career options, including:

### Computing and IT
- Software Engineering
- Web Development
- Mobile Development
- Data Science
- AI / Machine Learning
- Cybersecurity
- Networking
- Cloud / DevOps
- Database Administration
- UI/UX Design
- Systems Analysis
- Business Information Systems

### Engineering and Applied Science
- Civil / Structural Engineering
- Mechanical / Mechatronics Engineering
- Electrical / Electronics Engineering
- Environmental / Energy Engineering
- Architecture / Built Environment

### Health and Life Sciences
- Medicine
- Nursing
- Pharmacy
- Medical Laboratory Science
- Public Health

### Education and Training
- Mathematics Education
- Science Education
- Language / Humanities Education
- Educational Guidance / Counseling

### Business and Finance
- Accounting
- Finance / Banking
- Marketing / Digital Marketing
- Entrepreneurship / Business Development
- Operations / Supply Chain

### Communication and Media
- Journalism / Reporting
- Public Relations / Communications
- Broadcasting / Multimedia Production
- Technical Writing / Documentation

### Law and Public Service
- Law
- Public Administration / Policy
- International Relations / Diplomacy
- Criminology / Security Studies

### Social and Community Services
- Psychology / Counseling
- Social Work
- Human Resource Management
- Community Development / NGO Work

### Creative Arts and Design
- Graphic Communication Design
- Animation / Game Art
- Fashion Design
- Interior / Spatial Design

## File Structure

```text
Conversational Career Interview and Guidance Expert System Using Prolog/
|-- main.pl
|-- dialogue_manager.pl
|-- interpreter.pl
|-- profile.pl
|-- knowledge_base.pl
|-- family_inference.pl
|-- specialization_inference.pl
|-- explanation.pl
|-- utils.pl
`-- README.md
```

## Module Roles

- `main.pl`
  - entry point
  - welcome message
  - restart loop

- `dialogue_manager.pl`
  - interview flow control
  - command handling
  - targeted clarification selection

- `interpreter.pl`
  - free-text interpretation
  - ambiguity detection
  - rare menu fallback support

- `profile.pl`
  - dynamic working memory
  - answer history and rollback support

- `knowledge_base.pl`
  - families, careers, prompts, labels, and weighted rules

- `family_inference.pl`
  - broad family scoring and ranking

- `specialization_inference.pl`
  - specialization scoring within leading families

- `explanation.pl`
  - reflection summaries
  - profile summaries
  - final guidance report

- `utils.pl`
  - normalization and general helper predicates

## Knowledge Representation

The system converts narrative input into explicit symbolic evidence.

Examples of stored evidence:

```prolog
profile_fact(academic, performed_well(mathematics)).
profile_fact(academic, enjoyed(business_studies)).
profile_fact(academic, found_difficult(none)).
profile_fact(experience, completed_project(coding_project)).
profile_fact(behavior, shows(teaching_behavior)).
profile_fact(preference, prefers(technical_systems)).
profile_fact(exclusion, excludes(hospital_environment)).
profile_fact(goal, values(stability)).
profile_fact(uncertainty, mixed_about(work_style)).
```

These facts are matched against weighted rules of the form:

```prolog
family_rule(Family, Category, EvidencePattern, Weight, Reason).
career_rule(Career, Category, EvidencePattern, Weight, Reason).
```

## How the Interview Works

### 1. Narrative Intake

The interview begins with broad prompts such as:

- `Tell me about the subjects, activities, and experiences that best describe you.`
- `What kinds of things do you naturally enjoy doing?`
- `Are there any kinds of work or environments you already know you would dislike?`

### 2. Interpretation

The interpreter maps free text into structured evidence.

Examples:

- `I was strongest in maths and computer studies` -> academic strength evidence
- `I built a small website` -> project exposure
- `I do not want hospital work` -> exclusion evidence
- `both` / `mixed` / `it depends` -> uncertainty evidence

### 3. Reflection

After the first narrative intake, the system summarizes what it currently believes.

Example:

- `I think I heard Mathematics performance was high...`
- `I also heard has done coding projects...`
- `I also heard dislikes crowded environments...`

Then it asks:

- `What did I misunderstand or miss?`

### 4. Clarification

Clarification is asked only where needed.

Examples:

- if the user mentions games, the system asks what part of games is interesting
- if the user dislikes crowded environments, the system asks whether the problem is noise, interaction, movement, or focus
- if biology is positive but hospital work is excluded, the system asks about non-clinical biology directions
- if enough broad evidence points toward a family, the system asks one focused narrowing question for that family

### 5. Inference

The system first ranks **career families**, then ranks **specializations** inside the most plausible family or top competing families.

### 6. Guidance

The final report includes:

- current evidence summary
- leading family recommendation
- primary specialization
- secondary specialization if relevant
- confidence level
- explanation of fit
- possible concerns or mismatches
- validation steps

## Commands During the Interview

At any prompt, the user can type:

- `why`
- `help`
- `examples`
- `summary`
- `profile`
- `what do you know about me`
- `why this direction`
- `what is unclear`
- `skip`
- `back`
- `exit`

## How Uncertainty Handling Works

The system does not force false precision. It accepts expressions such as:

- `none`
- `not sure`
- `both`
- `mixed`
- `it depends`
- `I liked it but was not strong at it`
- `I was strong at it but did not enjoy it`

Instead of rejecting such answers, it stores separate evidence and uncertainty where appropriate.

This means the system can preserve distinctions such as:

- strong in biology
- but dislikes hospital work

or:

- likes computers
- but does not want deep coding work

## How to Run

### Terminal

```bash
swipl -q -s main.pl -g main:start -t halt
```

### SWI-Prolog prompt

```prolog
?- [main].
?- main:start.
```

## Sample Session Transcript

```text
$ swipl -q -s main.pl -g main:start -t halt

======================================================================
     Conversational Career Interview and Guidance Expert System       
                           Using Prolog                               
======================================================================
This expert system works like a narrative career interview.
It listens to your story, reflects what it understood, asks only
targeted clarifying questions, then infers career families and
specific guidance paths.

Tell me about the subjects, activities, and experiences that best describe you.
> I was strongest in maths and computer studies, built a small website, joined coding club, and often explained tech to classmates.

What kinds of things do you naturally enjoy doing, even when nobody is forcing you?
> I naturally enjoy analyzing patterns, organizing systems, and improving how things work.

Are there any kinds of work, environments, or career directions you already know you would dislike?
> I already know I would dislike deep coding all day, hospital work, and very noisy crowded places.

My current understanding:
- I think I heard Mathematics performance was high, performed well in Computer Studies / ICT, performed well in Mathematics.
- I also heard has done coding, app, or website projects and joined coding or technical clubs.
- I also heard prefers business and enterprise work and prefers data and analysis.
- I also heard dislikes crowded environments and does not want deep coding-heavy work.

I have summarized what I think I heard. What did I misunderstand or miss?
> You missed that I also liked business even though it was not my strongest subject.

My current understanding:
- I think I heard Mathematics performance was high, enjoyed Business Studies / Commerce, performed well in Computer Studies / ICT.
- I also heard has done coding, app, or website projects and joined coding or technical clubs.
- I also heard prefers business and enterprise work and prefers data and analysis.
- I also heard dislikes crowded environments and does not want deep coding-heavy work.

I want to clarify one thing before narrowing further: Different kinds of crowd discomfort matter for different career environments, so I need to know what exactly you want to avoid.

When you say crowded environments, do you mainly mean noise, too much interaction, too much movement, or difficulty focusing?
> Mostly noise and difficulty focusing.

I want to clarify one thing before narrowing further: Weak or uncomfortable subjects matter because they can reduce the realism of some otherwise attractive paths.

Were there subjects you struggled with, disliked, or simply found less natural? You can also say none.
> No clear weak subject.

I want to clarify one thing before narrowing further: Environment matters because a person can fit the subject area of a career but still dislike the setting where that career is practiced.

What kind of setting sounds comfortable to you, for example an office, lab, classroom, field site, hospital, studio, or workshop?
> Mostly a quiet office style place, maybe some lab work.

I want to clarify one thing before narrowing further: Long-term motivations help distinguish paths driven by security, impact, creativity, leadership, research, or technical depth.

What matters most in the future you want: stability, income, impact, creativity, entrepreneurship, technical mastery, public service, leadership, research, or some combination?
> Stability and social impact.

I now want to test whether Computing and IT is really your strongest direction.

You currently sound closest to Computing and IT. Within that family, what feels most natural: software, web, mobile, data, AI, cybersecurity, networking, cloud, databases, UX, systems analysis, or business technology?
> Business information systems or systems analysis.

Current direction:
1. Computing and IT (Strong fit, score 44, coverage 5, uncertainty 1): computer studies is a performance strength and you have done coding or software-style projects.
2. Business and Finance (Moderate fit, score 14, coverage 3, uncertainty 1): you prefer business and enterprise work and mathematics supports business and finance decisions.

Primary family recommendation:
- Family: Computing and IT
- Confidence: Strong fit
- Score: 44
- Coverage: 5 categories
- Uncertainty markers affecting confidence: 1
- Why this family is leading: you have done coding or software-style projects, you prefer technical systems, mathematics supports technical and analytical computing work.

Primary specialization:
- Career: Business Information Systems
- Family: Computing and IT
- Confidence: Strong fit
- Score: 22
- Coverage: 4 categories
- Why this specialization was chosen: you explicitly leaned toward business information systems, business processes fit you, technology systems also fit you, computer studies supports this path.

Secondary specialization:
- Career: Systems Analysis
- Family: Computing and IT
- Confidence: Strong fit
- Score: 20

Validation steps:
- Step 1: Explore business processes, databases, and technology-enabled process improvement.
- Step 2: Talk to someone studying or working in Computing and IT, then compare that reality with the picture you currently have in mind.
```

## Validation Notes

This project was live-tested with SWI-Prolog after adding SWI-Prolog to the command path in the local shell environment.

## Possible Future Improvements

- richer language parsing beyond phrase matching
- saving interview transcripts for later comparison
- region-specific course and admission guidance
- labor-market data integration
- stronger probabilistic uncertainty models

## Conclusion

This project demonstrates a more realistic academic expert system architecture in Prolog by replacing a questionnaire-style flow with a narrative interview model: intake, interpretation, reflection, clarification, inference, and guidance.
