% Knowledge base for the realistic conversational career expert system.

:- module(knowledge_base, [
    activity_label/2,
    base_question_ids/1,
    career/2,
    career_label/2,
    career_next_step/2,
    career_overview/2,
    career_rule/5,
    environment_label/2,
    family/1,
    family_label/2,
    family_narrowing_question/2,
    family_overview/2,
    family_rule/5,
    goal_label/2,
    preference_label/2,
    project_label/2,
    question_examples/2,
    question_help/2,
    question_prompt/2,
    question_why/2,
    subject_label/2,
    trait_label/2
]).

base_question_ids([
    opening_narrative,
    natural_enjoyment,
    known_dislikes
]).

family(computing_it).
family(engineering_applied_science).
family(health_life_sciences).
family(education_training).
family(business_finance).
family(communication_media).
family(law_public_service).
family(social_community_services).
family(creative_arts_design).

family_label(computing_it, 'Computing and IT').
family_label(engineering_applied_science, 'Engineering and Applied Science').
family_label(health_life_sciences, 'Health and Life Sciences').
family_label(education_training, 'Education and Training').
family_label(business_finance, 'Business and Finance').
family_label(communication_media, 'Communication and Media').
family_label(law_public_service, 'Law and Public Service').
family_label(social_community_services, 'Social and Community Services').
family_label(creative_arts_design, 'Creative Arts and Design').

family_overview(computing_it, 'This family suits people who prefer technical systems, digital tools, logic, structured analysis, and technology-enabled problem solving.').
family_overview(engineering_applied_science, 'This family suits people who apply mathematics and science to machines, structures, design, energy, and practical technical systems.').
family_overview(health_life_sciences, 'This family suits people who combine science with care, diagnostics, research, prevention, and human wellbeing.').
family_overview(education_training, 'This family suits people who enjoy helping others learn, explaining ideas, and supporting development through teaching or guidance.').
family_overview(business_finance, 'This family suits people who are drawn to enterprise, money, planning, operations, organization, and commercial decision making.').
family_overview(communication_media, 'This family suits people who enjoy writing, speaking, storytelling, media work, and clear communication to audiences.').
family_overview(law_public_service, 'This family suits people who care about justice, governance, advocacy, policy, security, and public leadership.').
family_overview(social_community_services, 'This family suits people who prefer helping individuals or communities through counseling, support, coordination, and development work.').
family_overview(creative_arts_design, 'This family suits people who enjoy visual communication, creativity, artistic expression, and design-centered work.').

career(software_engineering, computing_it).
career(web_development, computing_it).
career(mobile_development, computing_it).
career(data_science, computing_it).
career(ai_machine_learning, computing_it).
career(cybersecurity, computing_it).
career(networking_administration, computing_it).
career(cloud_devops, computing_it).
career(database_administration, computing_it).
career(ui_ux_design, computing_it).
career(systems_analysis, computing_it).
career(business_information_systems, computing_it).

career(civil_structural_engineering, engineering_applied_science).
career(mechanical_mechatronics_engineering, engineering_applied_science).
career(electrical_electronics_engineering, engineering_applied_science).
career(environmental_energy_engineering, engineering_applied_science).
career(architecture_built_environment, engineering_applied_science).

career(medicine, health_life_sciences).
career(nursing, health_life_sciences).
career(pharmacy, health_life_sciences).
career(medical_laboratory_science, health_life_sciences).
career(public_health, health_life_sciences).

career(mathematics_education, education_training).
career(science_education, education_training).
career(language_humanities_education, education_training).
career(educational_guidance_counseling, education_training).

career(accounting, business_finance).
career(finance_banking, business_finance).
career(marketing_digital_marketing, business_finance).
career(entrepreneurship_business_development, business_finance).
career(operations_supply_chain, business_finance).

career(journalism_reporting, communication_media).
career(public_relations_communications, communication_media).
career(broadcasting_multimedia_production, communication_media).
career(technical_writing_documentation, communication_media).

career(law, law_public_service).
career(public_administration_policy, law_public_service).
career(international_relations_diplomacy, law_public_service).
career(criminology_security_studies, law_public_service).

career(psychology_counseling, social_community_services).
career(social_work, social_community_services).
career(human_resource_management, social_community_services).
career(community_development_ngo, social_community_services).

career(graphic_communication_design, creative_arts_design).
career(animation_game_art, creative_arts_design).
career(fashion_design, creative_arts_design).
career(interior_spatial_design, creative_arts_design).

career_label(software_engineering, 'Software Engineering').
career_label(web_development, 'Web Development').
career_label(mobile_development, 'Mobile Development').
career_label(data_science, 'Data Science').
career_label(ai_machine_learning, 'AI / Machine Learning').
career_label(cybersecurity, 'Cybersecurity').
career_label(networking_administration, 'Networking').
career_label(cloud_devops, 'Cloud / DevOps').
career_label(database_administration, 'Database Administration').
career_label(ui_ux_design, 'UI/UX Design').
career_label(systems_analysis, 'Systems Analysis').
career_label(business_information_systems, 'Business Information Systems').
career_label(civil_structural_engineering, 'Civil / Structural Engineering').
career_label(mechanical_mechatronics_engineering, 'Mechanical / Mechatronics Engineering').
career_label(electrical_electronics_engineering, 'Electrical / Electronics Engineering').
career_label(environmental_energy_engineering, 'Environmental / Energy Engineering').
career_label(architecture_built_environment, 'Architecture / Built Environment').
career_label(medicine, 'Medicine').
career_label(nursing, 'Nursing').
career_label(pharmacy, 'Pharmacy').
career_label(medical_laboratory_science, 'Medical Laboratory Science').
career_label(public_health, 'Public Health').
career_label(mathematics_education, 'Mathematics Education').
career_label(science_education, 'Science Education').
career_label(language_humanities_education, 'Language / Humanities Education').
career_label(educational_guidance_counseling, 'Educational Guidance / Counseling').
career_label(accounting, 'Accounting').
career_label(finance_banking, 'Finance / Banking').
career_label(marketing_digital_marketing, 'Marketing / Digital Marketing').
career_label(entrepreneurship_business_development, 'Entrepreneurship / Business Development').
career_label(operations_supply_chain, 'Operations / Supply Chain').
career_label(journalism_reporting, 'Journalism / Reporting').
career_label(public_relations_communications, 'Public Relations / Communications').
career_label(broadcasting_multimedia_production, 'Broadcasting / Multimedia Production').
career_label(technical_writing_documentation, 'Technical Writing / Documentation').
career_label(law, 'Law').
career_label(public_administration_policy, 'Public Administration / Policy').
career_label(international_relations_diplomacy, 'International Relations / Diplomacy').
career_label(criminology_security_studies, 'Criminology / Security Studies').
career_label(psychology_counseling, 'Psychology / Counseling').
career_label(social_work, 'Social Work').
career_label(human_resource_management, 'Human Resource Management').
career_label(community_development_ngo, 'Community Development / NGO Work').
career_label(graphic_communication_design, 'Graphic Communication Design').
career_label(animation_game_art, 'Animation / Game Art').
career_label(fashion_design, 'Fashion Design').
career_label(interior_spatial_design, 'Interior / Spatial Design').

career_overview(software_engineering, 'A good fit for someone who wants to design and build software systems through sustained coding and technical problem solving.').
career_overview(web_development, 'A good fit for someone who wants to build user-facing websites and digital products.').
career_overview(mobile_development, 'A good fit for someone who wants to create mobile apps and interactive digital tools.').
career_overview(data_science, 'A good fit for someone who enjoys mathematics, data patterns, analysis, and evidence-based reasoning.').
career_overview(ai_machine_learning, 'A good fit for someone who enjoys mathematics, data, and intelligent systems with deeper algorithmic work.').
career_overview(cybersecurity, 'A good fit for someone interested in digital protection, secure systems, and technical risk analysis.').
career_overview(networking_administration, 'A good fit for someone who likes infrastructure, troubleshooting, and keeping systems connected and reliable.').
career_overview(cloud_devops, 'A good fit for someone who enjoys technical systems, deployment, automation, and operational reliability.').
career_overview(database_administration, 'A good fit for someone who prefers structured information, data reliability, and careful system organization.').
career_overview(ui_ux_design, 'A good fit for someone who prefers user experience, interface design, and human-centered digital products.').
career_overview(systems_analysis, 'A good fit for someone who likes understanding how systems, processes, and technology fit together in real organizations.').
career_overview(business_information_systems, 'A good fit for someone who wants to bridge business needs and technology systems.').
career_overview(civil_structural_engineering, 'A good fit for someone drawn to structures, infrastructure, construction, and applied mathematics.').
career_overview(mechanical_mechatronics_engineering, 'A good fit for someone drawn to machines, robotics, movement, and technical prototyping.').
career_overview(electrical_electronics_engineering, 'A good fit for someone drawn to electronics, circuits, power, and technical devices.').
career_overview(environmental_energy_engineering, 'A good fit for someone who wants engineering to solve energy or environmental problems.').
career_overview(architecture_built_environment, 'A good fit for someone who combines design thinking with spatial planning and technical structure.').
career_overview(medicine, 'A good fit for someone who wants scientific depth and direct clinical responsibility.').
career_overview(nursing, 'A good fit for someone who combines science with sustained patient care and empathy.').
career_overview(pharmacy, 'A good fit for someone interested in medicines, chemistry, accuracy, and patient guidance.').
career_overview(medical_laboratory_science, 'A good fit for someone who prefers diagnostics, laboratory testing, and evidence-based investigation.').
career_overview(public_health, 'A good fit for someone who wants impact through community health, prevention, and population-level wellbeing.').
career_overview(mathematics_education, 'A good fit for someone strong in mathematics who also enjoys teaching and explanation.').
career_overview(science_education, 'A good fit for someone who enjoys science and helping others understand it.').
career_overview(language_humanities_education, 'A good fit for someone who enjoys languages, communication, reading, or humanities and wants to teach.').
career_overview(educational_guidance_counseling, 'A good fit for someone who wants to support learners through advising, mentoring, and guidance.').
career_overview(accounting, 'A good fit for someone who likes precision, records, structure, and disciplined financial work.').
career_overview(finance_banking, 'A good fit for someone who likes financial analysis, money systems, and decision making around numbers.').
career_overview(marketing_digital_marketing, 'A good fit for someone who enjoys communication, audiences, persuasion, and branding.').
career_overview(entrepreneurship_business_development, 'A good fit for someone motivated by initiative, opportunity, and building ventures.').
career_overview(operations_supply_chain, 'A good fit for someone who enjoys planning, organization, logistics, and keeping systems efficient.').
career_overview(journalism_reporting, 'A good fit for someone who enjoys writing, interviewing, investigating, and explaining events clearly.').
career_overview(public_relations_communications, 'A good fit for someone interested in messaging, reputation, and strategic communication.').
career_overview(broadcasting_multimedia_production, 'A good fit for someone who enjoys media production, presentation, and multimedia storytelling.').
career_overview(technical_writing_documentation, 'A good fit for someone who can explain structured or technical ideas clearly in writing.').
career_overview(law, 'A good fit for someone interested in advocacy, legal reasoning, and formal argument.').
career_overview(public_administration_policy, 'A good fit for someone who wants to work around governance, institutions, and public systems.').
career_overview(international_relations_diplomacy, 'A good fit for someone drawn to diplomacy, global issues, and public representation.').
career_overview(criminology_security_studies, 'A good fit for someone interested in justice, security, investigation, and safety systems.').
career_overview(psychology_counseling, 'A good fit for someone who wants to listen carefully, understand behaviour, and support people directly.').
career_overview(social_work, 'A good fit for someone motivated by practical support for people and communities.').
career_overview(human_resource_management, 'A good fit for someone interested in people support, workplace systems, and organizational communication.').
career_overview(community_development_ngo, 'A good fit for someone interested in community programs, development work, and social impact.').
career_overview(graphic_communication_design, 'A good fit for someone who enjoys visual communication, layout, branding, and graphics.').
career_overview(animation_game_art, 'A good fit for someone who enjoys digital art, animation, and interactive creative storytelling.').
career_overview(fashion_design, 'A good fit for someone drawn to style, product aesthetics, and creative design.').
career_overview(interior_spatial_design, 'A good fit for someone who likes spatial planning, environments, and applied visual design.').

career_next_step(software_engineering, 'Build software projects and strengthen structured coding, debugging, and version-control habits.').
career_next_step(web_development, 'Build small websites and study frontend and backend web foundations.').
career_next_step(mobile_development, 'Experiment with simple mobile apps and learn mobile interface and product basics.').
career_next_step(data_science, 'Strengthen mathematics, statistics, and practical data-analysis projects.').
career_next_step(ai_machine_learning, 'Strengthen mathematics and programming, then explore beginner machine-learning projects.').
career_next_step(cybersecurity, 'Study security basics, networks, and safe defensive security practice.').
career_next_step(networking_administration, 'Learn networking fundamentals, troubleshooting, and system setup.').
career_next_step(cloud_devops, 'Learn operating systems, cloud concepts, deployment pipelines, and automation basics.').
career_next_step(database_administration, 'Practice data organization, SQL, and database reliability concepts.').
career_next_step(ui_ux_design, 'Build a small portfolio with interfaces, wireframes, and user-centered design thinking.').
career_next_step(systems_analysis, 'Study how organizations use technology and practice process-mapping and requirements thinking.').
career_next_step(business_information_systems, 'Explore business processes, databases, and technology-enabled process improvement.').
career_next_step(civil_structural_engineering, 'Keep strengthening mathematics and physics and explore infrastructure or construction examples.').
career_next_step(mechanical_mechatronics_engineering, 'Explore robotics, motion, devices, and prototype-style technical projects.').
career_next_step(electrical_electronics_engineering, 'Build stronger mathematics and physics foundations and explore circuits or electronics projects.').
career_next_step(environmental_energy_engineering, 'Explore science, energy, and sustainability topics with practical engineering case studies.').
career_next_step(architecture_built_environment, 'Develop visual-spatial work and study basic design and built-environment concepts.').
career_next_step(medicine, 'Strengthen biology and chemistry while confirming sustained interest in clinical and science-heavy work.').
career_next_step(nursing, 'Seek realistic exposure to patient-support environments and strengthen science foundations.').
career_next_step(pharmacy, 'Strengthen chemistry and careful scientific reasoning while learning about medicines and patient guidance.').
career_next_step(medical_laboratory_science, 'Explore laboratory science, diagnostics, and evidence-based investigation.').
career_next_step(public_health, 'Look for health outreach, community service, or population-health topics that interest you.').
career_next_step(mathematics_education, 'Keep strengthening mathematics and keep practicing clear explanation to peers.').
career_next_step(science_education, 'Keep building science confidence and practice explaining scientific ideas clearly.').
career_next_step(language_humanities_education, 'Read widely, strengthen communication, and seek tutoring or peer-support opportunities.').
career_next_step(educational_guidance_counseling, 'Develop listening, mentoring, and learner-support experience.').
career_next_step(accounting, 'Practice structured records, spreadsheets, and disciplined numerical work.').
career_next_step(finance_banking, 'Strengthen quantitative reasoning and study the basics of financial analysis and markets.').
career_next_step(marketing_digital_marketing, 'Practice messaging, audience thinking, branding, and digital campaign ideas.').
career_next_step(entrepreneurship_business_development, 'Test small ideas, learn customer thinking, and build presentation confidence.').
career_next_step(operations_supply_chain, 'Practice planning, spreadsheets, logistics thinking, and process improvement.').
career_next_step(journalism_reporting, 'Write short reports, interview people, and practice explaining real topics clearly.').
career_next_step(public_relations_communications, 'Practice messaging, audience awareness, and strategic public communication.').
career_next_step(broadcasting_multimedia_production, 'Try audio, video, or multimedia projects and build a small portfolio.').
career_next_step(technical_writing_documentation, 'Practice explaining technical ideas clearly in structured writing.').
career_next_step(law, 'Strengthen reading, writing, and structured argument around public issues.').
career_next_step(public_administration_policy, 'Follow public issues and practice policy, governance, and systems thinking.').
career_next_step(international_relations_diplomacy, 'Read widely on global affairs, negotiation, and international public issues.').
career_next_step(criminology_security_studies, 'Explore justice, security, public safety, and investigative reasoning topics.').
career_next_step(psychology_counseling, 'Build listening, empathy, and knowledge of behaviour and mental wellbeing topics.').
career_next_step(social_work, 'Seek service opportunities and learn more about direct community and case-support work.').
career_next_step(human_resource_management, 'Build communication, organization, and people-coordination skills.').
career_next_step(community_development_ngo, 'Get involved in community or development activities and learn program-support basics.').
career_next_step(graphic_communication_design, 'Build a small visual portfolio and practice layout, branding, and graphic communication.').
career_next_step(animation_game_art, 'Build digital art skills and start an animation or game-art portfolio.').
career_next_step(fashion_design, 'Start sketching, studying garments, and building a simple design portfolio.').
career_next_step(interior_spatial_design, 'Study spaces, layout, color, and human-centered environment design.').

question_prompt(strongest_subjects, 'Tell me the subjects you were strongest in.').
question_prompt(difficult_subjects, 'Were there subjects you struggled with, disliked, or simply found less natural? You can also say none.').
question_prompt(opening_narrative, 'Tell me about the subjects, activities, and experiences that best describe you.').
question_prompt(natural_enjoyment, 'What kinds of things do you naturally enjoy doing, even when nobody is forcing you?').
question_prompt(known_dislikes, 'Are there any kinds of work, environments, or career directions you already suspect you would dislike?').
question_prompt(reflection_correction, 'I have summarized what I think I heard. What did I misunderstand or miss?').

question_prompt(strongest_subjects, 'I still do not have a clear sense of your strongest subjects. Which subjects come most naturally to you?').
question_prompt(enjoyed_subjects, 'Which subjects did you enjoy, even if they were not necessarily your strongest?').
question_prompt(performance_snapshot, 'If you can, describe any performance patterns that stand out, such as high in maths, average in English, or low in chemistry.').
question_prompt(activities_and_projects, 'Tell me about things you enjoyed doing, even outside class, such as projects, clubs, competitions, volunteering, or small initiatives.').
question_prompt(behaviours_and_roles, 'Have you found yourself teaching others, leading teams, solving difficult problems, organizing people, building things, or supporting others?').
question_prompt(work_style_preferences, 'Would you rather build things, analyze things, explain things, care for people, organize systems, create things, or some mix of these?').
question_prompt(preferred_environments, 'What kind of setting sounds comfortable to you, for example an office, lab, classroom, field site, hospital, studio, or workshop?').
question_prompt(disliked_environments_paths, 'Are there any work settings or career paths you already know you would dislike? You can say none, not sure, or explain the kind of work you want to avoid.').
question_prompt(motivations, 'What matters most in the future you want: stability, income, impact, creativity, entrepreneurship, technical mastery, public service, leadership, research, or some combination?').

question_prompt(games_interest_clarification, 'When you mention games, is the interesting part playing, strategy, storytelling, art and design, or programming and systems?').
question_prompt(crowded_environment_clarification, 'When you say crowded environments, do you mainly mean noise, too much interaction, too much movement, or difficulty focusing?').
question_prompt(biology_nonhospital_clarification, 'You seem positive about biology but negative about hospital work. Does the more realistic biology direction feel like laboratory work, public health, environmental science, psychology, or research?').

question_prompt(computing_narrowing, 'You currently sound closest to Computing and IT. Within that family, what feels most natural: software, web, mobile, data, AI, cybersecurity, networking, cloud, databases, UX, systems analysis, or business technology?').
question_prompt(engineering_narrowing, 'You currently sound close to Engineering and Applied Science. Are you more drawn to structures, machines and robotics, electronics, energy and environment, or architecture?').
question_prompt(health_narrowing, 'You currently sound close to Health and Life Sciences. Are you more drawn to medicine, nursing, pharmacy, laboratory science, or public health?').
question_prompt(education_narrowing, 'You currently sound close to Education and Training. Do you imagine yourself more in mathematics education, science education, language or humanities teaching, or educational guidance?').
question_prompt(business_narrowing, 'You currently sound close to Business and Finance. Are you leaning more toward accounting, finance, marketing, entrepreneurship, or operations and supply chain?').
question_prompt(media_narrowing, 'You currently sound close to Communication and Media. Are you leaning toward journalism, public relations, multimedia production, or technical writing?').
question_prompt(public_service_narrowing, 'You currently sound close to Law and Public Service. Are you leaning toward law, policy and administration, diplomacy, or criminology and security studies?').
question_prompt(community_narrowing, 'You currently sound close to Social and Community Services. Are you leaning toward counseling, social work, human resources, or community and NGO development?').
question_prompt(creative_narrowing, 'You currently sound close to Creative Arts and Design. Are you leaning toward graphic design, animation and game art, fashion, or interior and spatial design?').

question_why(opening_narrative, 'This gives the system a broad narrative intake so it can extract evidence naturally before narrowing too early.').
question_why(natural_enjoyment, 'Enjoyment often reveals motivation and recurring patterns that may not appear in grades alone.').
question_why(known_dislikes, 'Career fit depends not only on what you can do, but also on what kinds of work you would realistically avoid.').
question_why(reflection_correction, 'Reflection lets the system check its interpretation before it asks more targeted clarification questions.').

question_why(strongest_subjects, 'I am only asking this because your earlier narrative did not give me enough clear academic evidence.').
question_why(difficult_subjects, 'Weak or uncomfortable subjects matter because they can reduce the realism of some otherwise attractive paths.').
question_why(enjoyed_subjects, 'Enjoyment helps separate what motivates you from what you merely perform well in.').
question_why(performance_snapshot, 'Performance levels help distinguish strong ability, moderate ability, and real difficulty more precisely.').
question_why(activities_and_projects, 'Practical exposure often gives stronger evidence than abstract liking because it shows what you were willing to do in real settings.').
question_why(behaviours_and_roles, 'Behavior patterns such as teaching, leading, helping, or solving problems often point toward family fit more realistically than interests alone.').
question_why(work_style_preferences, 'Career families differ a lot in whether they focus on building, analysis, care, explanation, organization, or creative production.').
question_why(preferred_environments, 'Environment matters because a person can fit the subject area of a career but still dislike the setting where that career is practiced.').
question_why(disliked_environments_paths, 'Negative evidence is important because being able to do something is not the same as wanting that kind of work.').
question_why(motivations, 'Long-term motivations help distinguish paths driven by security, impact, creativity, leadership, research, or technical depth.').
question_why(games_interest_clarification, 'Game-related interest can point to very different directions such as design, strategy, storytelling, or programming.').
question_why(crowded_environment_clarification, 'Different kinds of crowd discomfort matter for different career environments, so I need to know what exactly you want to avoid.').
question_why(biology_nonhospital_clarification, 'This helps preserve the distinction between liking biology and disliking hospital-based work.').
question_why(computing_narrowing, 'Computing includes very different paths, from deep coding to systems work to design, so I need to narrow the type of digital work that fits you best.').
question_why(engineering_narrowing, 'Engineering is broad, so I need to identify the kind of applied technical work that feels most natural.').
question_why(health_narrowing, 'Health paths differ widely between direct care, medicines, labs, and population-level work.').
question_why(education_narrowing, 'Education paths differ by subject strength and by whether you prefer classroom teaching or learner support.').
question_why(business_narrowing, 'Business can mean finance, marketing, entrepreneurship, or operations, which require different evidence.').
question_why(media_narrowing, 'Media careers differ between reporting, strategic communication, production, and structured writing.').
question_why(public_service_narrowing, 'Public-service paths differ between law, policy, diplomacy, and security studies.').
question_why(community_narrowing, 'People-centered support careers vary between counseling, social work, HR, and community development.').
question_why(creative_narrowing, 'Creative careers differ between graphics, motion art, fashion, and spatial design.').

question_help(opening_narrative, 'Answer freely in your own words. You can mention subjects, activities, strengths, projects, clubs, roles, or anything else that describes you well.').
question_help(natural_enjoyment, 'You can talk about what you naturally drift toward, such as building things, analyzing, helping people, creating, teaching, or organizing.').
question_help(known_dislikes, 'You can mention environments, tasks, or career styles you already suspect you would dislike, such as hospital work, routine desk work, heavy public speaking, or deep coding.').
question_help(reflection_correction, 'You can say nothing important was missed, or correct me naturally, for example: I am good at biology but I do not want hospital work.').

question_help(strongest_subjects, 'You can answer naturally, for example: maths and physics, biology and chemistry, or computer studies and maths.').
question_help(difficult_subjects, 'You can name subjects, say none, or describe them naturally, such as English felt difficult or I did not really have a weak subject.').
question_help(enjoyed_subjects, 'You can mention subjects you liked even if you were only average in them.').
question_help(performance_snapshot, 'A short natural answer is enough, for example: high in maths, average in English, low in chemistry.').
question_help(activities_and_projects, 'Mention anything practical you enjoyed, such as coding, science projects, business club, debate, volunteering, tutoring, design, or media work.').
question_help(behaviours_and_roles, 'Describe what sounds like you, for example teaching friends, solving problems, leading teams, helping people, or building things.').
question_help(work_style_preferences, 'You can mention one or several styles, such as analyzing things, helping people, creating visual work, or building technical systems.').
question_help(preferred_environments, 'You can mention one or more settings, or say mixed if more than one environment feels realistic.').
question_help(disliked_environments_paths, 'You can rule things out naturally, for example I do not want hospital work, I dislike public speaking, or none.').
question_help(motivations, 'You can mention one or several goals, for example stability and impact, or income and entrepreneurship.').
question_help(games_interest_clarification, 'A short answer is enough, for example programming, storytelling, strategy, or art and design.').
question_help(crowded_environment_clarification, 'A short answer is enough, for example noise, too many people, too much talking, or lack of focus.').
question_help(biology_nonhospital_clarification, 'A short answer is enough, for example lab work, public health, research, psychology, or environmental science.').
question_help(computing_narrowing, 'You can answer freely, for example data science, cybersecurity, web apps, cloud work, or UX.').
question_help(engineering_narrowing, 'You can answer freely, for example structures, robotics, electronics, energy, or architecture.').
question_help(health_narrowing, 'You can answer freely, for example public health, medicine, nursing, lab science, or pharmacy.').
question_help(education_narrowing, 'You can answer freely, for example teaching maths, science education, humanities teaching, or guidance.').
question_help(business_narrowing, 'You can answer freely, for example accounting, finance, marketing, entrepreneurship, or operations.').
question_help(media_narrowing, 'You can answer freely, for example journalism, PR, multimedia, or technical writing.').
question_help(public_service_narrowing, 'You can answer freely, for example law, policy, diplomacy, or criminology.').
question_help(community_narrowing, 'You can answer freely, for example counseling, social work, HR, or NGO work.').
question_help(creative_narrowing, 'You can answer freely, for example graphic design, animation, fashion, or interior design.').

question_examples(opening_narrative, 'Examples: I was strongest in maths and computer studies, joined coding club, and liked solving technical problems; or I enjoyed biology, volunteering, and helping classmates.').
question_examples(natural_enjoyment, 'Examples: I naturally enjoy analyzing patterns, teaching people, building things, or creating visual work.').
question_examples(known_dislikes, 'Examples: I already know I would dislike hospital work, routine office work, or crowded noisy spaces.').
question_examples(reflection_correction, 'Examples: That is mostly right, but I liked biology without wanting hospital work; or you missed that I enjoy leadership and community work.').

question_examples(strongest_subjects, 'Examples: maths and physics; biology, chemistry, and ICT; accounting and business.').
question_examples(difficult_subjects, 'Examples: English felt difficult; I did not really have a weak subject; chemistry was hard for me.').
question_examples(enjoyed_subjects, 'Examples: I enjoyed biology even though I was only average; I liked maths and computer studies.').
question_examples(performance_snapshot, 'Examples: high in maths, medium in English; good at biology but average in chemistry; strong in accounts.').
question_examples(activities_and_projects, 'Examples: I built websites, joined debate club, liked science projects, volunteered in outreach, or ran a small business idea.').
question_examples(behaviours_and_roles, 'Examples: I taught maths to classmates; I led a team; I like solving hard problems; I often help people directly.').
question_examples(work_style_preferences, 'Examples: I like analyzing things and building systems; I prefer helping people and explaining ideas; I like creating visual things.').
question_examples(preferred_environments, 'Examples: office and lab; classroom; fieldwork; hospital but not ward work; studio.').
question_examples(disliked_environments_paths, 'Examples: I do not want hospital work; I dislike routine office work; no strong exclusions; not sure yet.').
question_examples(motivations, 'Examples: stability and impact; technical mastery; income and entrepreneurship; research and service.').
question_examples(games_interest_clarification, 'Examples: I mean the programming side; I like strategy and systems; I am more into storytelling and world-building; I only like playing casually.').
question_examples(crowded_environment_clarification, 'Examples: mostly noise; too much interaction; too many distractions; too much movement and chaos.').
question_examples(biology_nonhospital_clarification, 'Examples: lab science sounds better; I would rather do public health; I like research more than clinical work.').
question_examples(computing_narrowing, 'Examples: data science; cybersecurity; web development; cloud work; business technology.').
question_examples(engineering_narrowing, 'Examples: civil engineering; robotics; electronics; energy; architecture.').
question_examples(health_narrowing, 'Examples: medicine; public health; lab science; pharmacy; nursing.').
question_examples(education_narrowing, 'Examples: mathematics education; science teaching; humanities teaching; educational guidance.').
question_examples(business_narrowing, 'Examples: accounting; finance; marketing; entrepreneurship; operations.').
question_examples(media_narrowing, 'Examples: journalism; public relations; multimedia; technical writing.').
question_examples(public_service_narrowing, 'Examples: law; public policy; diplomacy; criminology.').
question_examples(community_narrowing, 'Examples: counseling; social work; HR; community and NGO development.').
question_examples(creative_narrowing, 'Examples: graphic design; animation; fashion; interior design.').

family_narrowing_question(computing_it, computing_narrowing).
family_narrowing_question(engineering_applied_science, engineering_narrowing).
family_narrowing_question(health_life_sciences, health_narrowing).
family_narrowing_question(education_training, education_narrowing).
family_narrowing_question(business_finance, business_narrowing).
family_narrowing_question(communication_media, media_narrowing).
family_narrowing_question(law_public_service, public_service_narrowing).
family_narrowing_question(social_community_services, community_narrowing).
family_narrowing_question(creative_arts_design, creative_narrowing).

subject_label(mathematics, 'Mathematics').
subject_label(physics, 'Physics').
subject_label(chemistry, 'Chemistry').
subject_label(biology, 'Biology').
subject_label(computer_studies, 'Computer Studies / ICT').
subject_label(english, 'English / Writing').
subject_label(literature, 'Literature / Languages').
subject_label(history, 'History / Government').
subject_label(geography, 'Geography').
subject_label(economics, 'Economics').
subject_label(business_studies, 'Business Studies / Commerce').
subject_label(accounting, 'Accounting').
subject_label(art_design, 'Art / Design').

project_label(coding_project, 'has done coding, app, or website projects').
project_label(data_project, 'has done data or analytics projects').
project_label(security_project, 'has done security or networking projects').
project_label(science_lab_project, 'has done lab or science investigation projects').
project_label(health_project, 'has done health-related or outreach projects').
project_label(business_project, 'has done business or enterprise projects').
project_label(media_project, 'has done writing, reporting, or media projects').
project_label(design_project, 'has done art, design, or portfolio projects').
project_label(community_project, 'has done community or service projects').

activity_label(coding_club, 'joined coding or technical clubs').
activity_label(science_fair, 'joined science-fair or science-club activities').
activity_label(debate_public_speaking, 'joined debate or public-speaking activities').
activity_label(peer_tutoring, 'has helped classmates through tutoring').
activity_label(student_leadership, 'has held leadership roles').
activity_label(business_club, 'joined business or enterprise activities').
activity_label(media_club, 'joined media or journalism activities').
activity_label(community_service, 'joined community service or volunteering').
activity_label(art_club, 'joined art or design activities').
activity_label(civic_club, 'joined civic or governance-related activities').

trait_label(teaching_behavior, 'shows teaching or explanation behaviour').
trait_label(leadership_behavior, 'shows leadership behaviour').
trait_label(problem_solving_behavior, 'shows strong problem-solving behaviour').
trait_label(analytical_behavior, 'shows analytical reasoning').
trait_label(communication_behavior, 'shows strong communication behaviour').
trait_label(helping_behavior, 'shows helping or support behaviour').
trait_label(practical_builder_behavior, 'shows practical builder behaviour').
trait_label(organization_behavior, 'shows organization and coordination behaviour').
trait_label(creative_behavior, 'shows creative behaviour').
trait_label(research_behavior, 'shows research-oriented behaviour').
trait_label(empathy_behavior, 'shows empathy and listening').

preference_label(technical_systems, 'prefers technical systems work').
preference_label(data_analysis, 'prefers data and analysis').
preference_label(people_helping, 'prefers helping people directly').
preference_label(teaching_and_explaining, 'prefers teaching and explaining').
preference_label(design_and_visual_work, 'prefers design and visual work').
preference_label(business_processes, 'prefers business and enterprise work').
preference_label(numbers_and_records, 'prefers numbers and records').
preference_label(law_policy_debate, 'prefers law, policy, or debate-oriented work').
preference_label(community_support, 'prefers community and social support work').
preference_label(machines_and_structures, 'prefers machines, structures, or technical objects').
preference_label(media_storytelling, 'prefers media and storytelling work').
preference_label(caring_for_people, 'prefers care-oriented work').
preference_label(user_facing_technology, 'prefers user-facing technology work').
preference_label(quiet_focus_work, 'prefers quiet and focus-heavy work').

environment_label(office_environment, 'office-style environments').
environment_label(lab_environment, 'laboratory environments').
environment_label(classroom_environment, 'classroom environments').
environment_label(field_environment, 'fieldwork or site-based environments').
environment_label(hospital_environment, 'hospital or clinical environments').
environment_label(studio_environment, 'studio or creative environments').
environment_label(workshop_environment, 'workshop or technical practical environments').

goal_label(stability, 'values stability and security').
goal_label(income, 'values income and financial reward').
goal_label(social_impact, 'values social impact').
goal_label(creativity, 'values creativity').
goal_label(entrepreneurship, 'values entrepreneurship').
goal_label(technical_mastery, 'values technical mastery').
goal_label(public_service, 'values public service').
goal_label(leadership, 'values leadership').
goal_label(research, 'values research and discovery').

% Family-level rules

family_rule(computing_it, academic, performed_well(computer_studies), 6, 'computer studies is a performance strength').
family_rule(computing_it, academic, enjoyed(computer_studies), 4, 'you enjoy computer-related study').
family_rule(computing_it, academic, performed_well(mathematics), 4, 'mathematics supports technical and analytical computing work').
family_rule(computing_it, experience, completed_project(coding_project), 6, 'you have done coding or software-style projects').
family_rule(computing_it, experience, completed_project(data_project), 5, 'you have done data-related projects').
family_rule(computing_it, experience, completed_project(security_project), 5, 'you have done security or networking projects').
family_rule(computing_it, experience, joined(coding_club), 4, 'you joined technical or coding activities').
family_rule(computing_it, behavior, shows(problem_solving_behavior), 4, 'you show strong problem-solving behaviour').
family_rule(computing_it, behavior, shows(analytical_behavior), 4, 'you show analytical reasoning').
family_rule(computing_it, preference, prefers(technical_systems), 5, 'you prefer technical systems').
family_rule(computing_it, preference, prefers(data_analysis), 4, 'you prefer data and analysis').
family_rule(computing_it, preference, prefers(quiet_focus_work), 3, 'quiet and focus-heavy work fits many computing paths').
family_rule(computing_it, preference, prefers(user_facing_technology), 3, 'you are open to user-facing technology products').
family_rule(computing_it, goal, values(technical_mastery), 4, 'technical mastery matters to you').
family_rule(computing_it, exclusion, excludes(engineering_work), -1, 'you explicitly ruled out engineering-heavy work, which keeps the system away from some technical branches').
family_rule(computing_it, direction, leans_toward(software_engineering), 4, 'you explicitly leaned toward a computing specialization').
family_rule(computing_it, direction, leans_toward(web_development), 4, 'you explicitly leaned toward a computing specialization').
family_rule(computing_it, direction, leans_toward(mobile_development), 4, 'you explicitly leaned toward a computing specialization').
family_rule(computing_it, direction, leans_toward(data_science), 4, 'you explicitly leaned toward a computing specialization').
family_rule(computing_it, direction, leans_toward(ai_machine_learning), 4, 'you explicitly leaned toward a computing specialization').
family_rule(computing_it, direction, leans_toward(cybersecurity), 4, 'you explicitly leaned toward a computing specialization').
family_rule(computing_it, direction, leans_toward(networking_administration), 4, 'you explicitly leaned toward a computing specialization').
family_rule(computing_it, direction, leans_toward(cloud_devops), 4, 'you explicitly leaned toward a computing specialization').
family_rule(computing_it, direction, leans_toward(database_administration), 4, 'you explicitly leaned toward a computing specialization').
family_rule(computing_it, direction, leans_toward(ui_ux_design), 4, 'you explicitly leaned toward a computing specialization').
family_rule(computing_it, direction, leans_toward(systems_analysis), 4, 'you explicitly leaned toward a computing specialization').
family_rule(computing_it, direction, leans_toward(business_information_systems), 4, 'you explicitly leaned toward a computing specialization').
family_rule(computing_it, academic, found_difficult(computer_studies), -5, 'computer studies appears difficult for you').

family_rule(engineering_applied_science, academic, performed_well(mathematics), 5, 'mathematics is a major strength').
family_rule(engineering_applied_science, academic, performed_well(physics), 5, 'physics is a major strength').
family_rule(engineering_applied_science, experience, completed_project(science_lab_project), 2, 'science experimentation supports engineering thinking').
family_rule(engineering_applied_science, behavior, shows(problem_solving_behavior), 4, 'you enjoy solving practical problems').
family_rule(engineering_applied_science, behavior, shows(practical_builder_behavior), 5, 'you like building or hands-on work').
family_rule(engineering_applied_science, preference, prefers(machines_and_structures), 6, 'you prefer machines, structures, or technical objects').
family_rule(engineering_applied_science, preference, work_style(practical), 3, 'you prefer practical work').
family_rule(engineering_applied_science, preference, prefers_environment(field_environment), 3, 'you are open to site or field environments').
family_rule(engineering_applied_science, preference, prefers_environment(workshop_environment), 3, 'you are comfortable in practical technical environments').
family_rule(engineering_applied_science, goal, values(technical_mastery), 3, 'technical mastery matters to you').
family_rule(engineering_applied_science, exclusion, excludes(engineering_work), -8, 'you already know you do not want engineering-style work').
family_rule(engineering_applied_science, exclusion, excludes(fieldwork_heavy), -3, 'heavy fieldwork is a turnoff for some engineering branches').
family_rule(engineering_applied_science, direction, leans_toward(civil_structural_engineering), 4, 'you explicitly leaned toward engineering').
family_rule(engineering_applied_science, direction, leans_toward(mechanical_mechatronics_engineering), 4, 'you explicitly leaned toward engineering').
family_rule(engineering_applied_science, direction, leans_toward(electrical_electronics_engineering), 4, 'you explicitly leaned toward engineering').
family_rule(engineering_applied_science, direction, leans_toward(environmental_energy_engineering), 4, 'you explicitly leaned toward engineering').
family_rule(engineering_applied_science, direction, leans_toward(architecture_built_environment), 4, 'you explicitly leaned toward architecture or engineering').
family_rule(engineering_applied_science, academic, found_difficult(mathematics), -6, 'mathematics appears difficult for you').
family_rule(engineering_applied_science, academic, found_difficult(physics), -5, 'physics appears difficult for you').

family_rule(health_life_sciences, academic, performed_well(biology), 5, 'biology is a major strength').
family_rule(health_life_sciences, academic, performed_well(chemistry), 4, 'chemistry supports health and life science pathways').
family_rule(health_life_sciences, academic, enjoyed(biology), 3, 'you enjoy biology').
family_rule(health_life_sciences, experience, completed_project(science_lab_project), 4, 'laboratory or science projects support this family').
family_rule(health_life_sciences, experience, completed_project(health_project), 5, 'health-related projects support this family').
family_rule(health_life_sciences, behavior, shows(helping_behavior), 4, 'helping people matters to you').
family_rule(health_life_sciences, behavior, shows(empathy_behavior), 4, 'you show empathy and listening').
family_rule(health_life_sciences, behavior, shows(research_behavior), 2, 'research interest supports several health pathways').
family_rule(health_life_sciences, preference, prefers(caring_for_people), 5, 'you are open to care-oriented work').
family_rule(health_life_sciences, preference, prefers_environment(hospital_environment), 3, 'clinical environments do not seem to put you off').
family_rule(health_life_sciences, preference, prefers_environment(lab_environment), 3, 'laboratory work also fits this family').
family_rule(health_life_sciences, goal, values(social_impact), 4, 'social impact matters to you').
family_rule(health_life_sciences, goal, values(research), 2, 'research interest supports health and life science work').
family_rule(health_life_sciences, exclusion, excludes(hospital_environment), -4, 'you ruled out hospital environments, which weakens some health paths').
family_rule(health_life_sciences, exclusion, excludes(direct_patient_care), -3, 'you ruled out direct patient-care work').
family_rule(health_life_sciences, direction, leans_toward(medicine), 4, 'you explicitly leaned toward a health specialization').
family_rule(health_life_sciences, direction, leans_toward(nursing), 4, 'you explicitly leaned toward a health specialization').
family_rule(health_life_sciences, direction, leans_toward(pharmacy), 4, 'you explicitly leaned toward a health specialization').
family_rule(health_life_sciences, direction, leans_toward(medical_laboratory_science), 4, 'you explicitly leaned toward a health specialization').
family_rule(health_life_sciences, direction, leans_toward(public_health), 4, 'you explicitly leaned toward a health specialization').
family_rule(health_life_sciences, academic, found_difficult(biology), -6, 'biology appears difficult for you').

family_rule(education_training, academic, enjoyed(mathematics), 2, 'subject enjoyment can support teaching').
family_rule(education_training, academic, enjoyed(english), 2, 'subject enjoyment can support teaching').
family_rule(education_training, experience, joined(peer_tutoring), 6, 'peer tutoring is strong evidence for education').
family_rule(education_training, experience, taught_subject(_), 5, 'you have already explained a subject to others').
family_rule(education_training, behavior, shows(teaching_behavior), 6, 'teaching or explanation is central in your profile').
family_rule(education_training, behavior, shows(helping_behavior), 4, 'helping people matters to you').
family_rule(education_training, behavior, shows(communication_behavior), 3, 'communication supports teaching and guidance').
family_rule(education_training, preference, prefers(teaching_and_explaining), 6, 'you prefer teaching and explanation').
family_rule(education_training, preference, prefers_environment(classroom_environment), 5, 'classroom environments suit you').
family_rule(education_training, exclusion, excludes(high_interaction_environments), -3, 'heavy interaction environments may make classroom-heavy roles less attractive').
family_rule(education_training, goal, values(social_impact), 4, 'social impact matters to you').
family_rule(education_training, exclusion, excludes(child_classroom_work), -3, 'you explicitly ruled out child-classroom work, which weakens some education paths').
family_rule(education_training, direction, leans_toward(mathematics_education), 4, 'you explicitly leaned toward an education specialization').
family_rule(education_training, direction, leans_toward(science_education), 4, 'you explicitly leaned toward an education specialization').
family_rule(education_training, direction, leans_toward(language_humanities_education), 4, 'you explicitly leaned toward an education specialization').
family_rule(education_training, direction, leans_toward(educational_guidance_counseling), 4, 'you explicitly leaned toward an education specialization').

family_rule(business_finance, academic, performed_well(accounting), 6, 'accounting is a strong academic area').
family_rule(business_finance, academic, performed_well(economics), 4, 'economics supports business reasoning').
family_rule(business_finance, academic, performed_well(business_studies), 5, 'business studies is a strong academic area').
family_rule(business_finance, academic, performed_well(mathematics), 3, 'mathematics supports business and finance decisions').
family_rule(business_finance, experience, completed_project(business_project), 6, 'business or enterprise projects strongly support this family').
family_rule(business_finance, experience, joined(business_club), 5, 'business-related activities support this family').
family_rule(business_finance, behavior, shows(leadership_behavior), 3, 'leadership supports business roles').
family_rule(business_finance, behavior, shows(organization_behavior), 4, 'organization strongly supports business and operations work').
family_rule(business_finance, preference, prefers(business_processes), 5, 'you prefer business and enterprise work').
family_rule(business_finance, preference, prefers(numbers_and_records), 4, 'you are comfortable with numbers and records').
family_rule(business_finance, preference, prefers_environment(office_environment), 3, 'office environments fit many business paths').
family_rule(business_finance, goal, values(entrepreneurship), 5, 'entrepreneurship matters to you').
family_rule(business_finance, goal, values(stability), 3, 'stability matters to you').
family_rule(business_finance, goal, values(income), 3, 'income matters to you').
family_rule(business_finance, exclusion, excludes(routine_office_work), -4, 'routine office work is a clear turnoff for you').
family_rule(business_finance, exclusion, excludes(sales_heavy_work), -2, 'sales-heavy work is a turnoff for you').
family_rule(business_finance, direction, leans_toward(accounting), 4, 'you explicitly leaned toward a business specialization').
family_rule(business_finance, direction, leans_toward(finance_banking), 4, 'you explicitly leaned toward a business specialization').
family_rule(business_finance, direction, leans_toward(marketing_digital_marketing), 4, 'you explicitly leaned toward a business specialization').
family_rule(business_finance, direction, leans_toward(entrepreneurship_business_development), 4, 'you explicitly leaned toward a business specialization').
family_rule(business_finance, direction, leans_toward(operations_supply_chain), 4, 'you explicitly leaned toward a business specialization').

family_rule(communication_media, academic, performed_well(english), 5, 'English is a strong academic area').
family_rule(communication_media, academic, enjoyed(english), 4, 'you enjoy English or writing').
family_rule(communication_media, academic, enjoyed(literature), 4, 'you enjoy language or literature').
family_rule(communication_media, experience, completed_project(media_project), 6, 'writing or media projects strongly support this family').
family_rule(communication_media, experience, joined(media_club), 5, 'media activities support this family').
family_rule(communication_media, experience, joined(debate_public_speaking), 4, 'debate and speaking activities support this family').
family_rule(communication_media, behavior, shows(communication_behavior), 5, 'communication is central in your profile').
family_rule(communication_media, behavior, shows(creative_behavior), 3, 'creative expression also matters here').
family_rule(communication_media, preference, prefers(media_storytelling), 6, 'you prefer media and storytelling work').
family_rule(communication_media, preference, prefers_environment(studio_environment), 3, 'studio-style or media environments fit this family').
family_rule(communication_media, goal, values(creativity), 3, 'creativity matters to you').
family_rule(communication_media, exclusion, excludes(crowded_environments), -2, 'crowded environments are a concern for you').
family_rule(communication_media, exclusion, excludes(noisy_environments), -3, 'noise-heavy settings are a concern for you').
family_rule(communication_media, exclusion, excludes(high_interaction_environments), -4, 'heavy interaction environments are a concern for you').
family_rule(communication_media, exclusion, excludes(public_speaking_work), -4, 'you ruled out public-speaking-heavy work').
family_rule(communication_media, direction, leans_toward(journalism_reporting), 4, 'you explicitly leaned toward a communication specialization').
family_rule(communication_media, direction, leans_toward(public_relations_communications), 4, 'you explicitly leaned toward a communication specialization').
family_rule(communication_media, direction, leans_toward(broadcasting_multimedia_production), 4, 'you explicitly leaned toward a communication specialization').
family_rule(communication_media, direction, leans_toward(technical_writing_documentation), 4, 'you explicitly leaned toward a communication specialization').
family_rule(communication_media, academic, found_difficult(english), -6, 'English appears difficult for you').

family_rule(law_public_service, academic, performed_well(english), 4, 'English supports legal and policy communication').
family_rule(law_public_service, academic, performed_well(history), 4, 'history or government supports public-service reasoning').
family_rule(law_public_service, experience, joined(debate_public_speaking), 5, 'debate strongly supports this family').
family_rule(law_public_service, experience, joined(civic_club), 5, 'civic or governance activities support this family').
family_rule(law_public_service, experience, joined(student_leadership), 3, 'leadership experience supports this family').
family_rule(law_public_service, behavior, shows(communication_behavior), 4, 'communication is important here').
family_rule(law_public_service, behavior, shows(leadership_behavior), 3, 'leadership matters here').
family_rule(law_public_service, preference, prefers(law_policy_debate), 6, 'you prefer law, policy, justice, or debate-oriented work').
family_rule(law_public_service, goal, values(public_service), 5, 'public service matters strongly to you').
family_rule(law_public_service, goal, values(leadership), 3, 'leadership matters to you').
family_rule(law_public_service, exclusion, excludes(high_interaction_environments), -3, 'heavy interaction environments are a concern for you').
family_rule(law_public_service, exclusion, excludes(law_argument_work), -5, 'you ruled out legal-argument-heavy work').
family_rule(law_public_service, exclusion, excludes(public_speaking_work), -3, 'public-speaking-heavy work is a turnoff for you').
family_rule(law_public_service, direction, leans_toward(law), 4, 'you explicitly leaned toward a public-service specialization').
family_rule(law_public_service, direction, leans_toward(public_administration_policy), 4, 'you explicitly leaned toward a public-service specialization').
family_rule(law_public_service, direction, leans_toward(international_relations_diplomacy), 4, 'you explicitly leaned toward a public-service specialization').
family_rule(law_public_service, direction, leans_toward(criminology_security_studies), 4, 'you explicitly leaned toward a public-service specialization').

family_rule(social_community_services, experience, completed_project(community_project), 5, 'community projects strongly support this family').
family_rule(social_community_services, experience, joined(community_service), 6, 'community service strongly supports this family').
family_rule(social_community_services, experience, joined(peer_tutoring), 2, 'peer support experience can support this family').
family_rule(social_community_services, behavior, shows(helping_behavior), 6, 'helping people is central in your profile').
family_rule(social_community_services, behavior, shows(empathy_behavior), 5, 'empathy and listening strongly support this family').
family_rule(social_community_services, behavior, shows(communication_behavior), 2, 'communication helps in service-oriented roles').
family_rule(social_community_services, preference, prefers(people_helping), 5, 'you prefer people-centered support work').
family_rule(social_community_services, preference, prefers(community_support), 6, 'you prefer community and social support work').
family_rule(social_community_services, exclusion, excludes(high_interaction_environments), -3, 'heavy interaction environments are a concern for you').
family_rule(social_community_services, goal, values(social_impact), 6, 'social impact matters strongly to you').
family_rule(social_community_services, goal, values(public_service), 2, 'public service also supports this family').
family_rule(social_community_services, direction, leans_toward(psychology_counseling), 4, 'you explicitly leaned toward a social-service specialization').
family_rule(social_community_services, direction, leans_toward(social_work), 4, 'you explicitly leaned toward a social-service specialization').
family_rule(social_community_services, direction, leans_toward(human_resource_management), 4, 'you explicitly leaned toward a social-service specialization').
family_rule(social_community_services, direction, leans_toward(community_development_ngo), 4, 'you explicitly leaned toward a social-service specialization').

family_rule(creative_arts_design, academic, performed_well(art_design), 6, 'art or design is a major strength').
family_rule(creative_arts_design, academic, enjoyed(art_design), 5, 'you genuinely enjoy art or design').
family_rule(creative_arts_design, experience, completed_project(design_project), 6, 'creative or portfolio work strongly supports this family').
family_rule(creative_arts_design, experience, joined(art_club), 5, 'creative activities support this family').
family_rule(creative_arts_design, behavior, shows(creative_behavior), 6, 'creativity is central in your profile').
family_rule(creative_arts_design, preference, prefers(design_and_visual_work), 6, 'you prefer design and visual work').
family_rule(creative_arts_design, preference, prefers_environment(studio_environment), 4, 'studio environments fit you').
family_rule(creative_arts_design, goal, values(creativity), 5, 'creative expression matters strongly to you').
family_rule(creative_arts_design, exclusion, excludes(design_studio_work), -6, 'you explicitly ruled out design-studio style work').
family_rule(creative_arts_design, direction, leans_toward(graphic_communication_design), 4, 'you explicitly leaned toward a creative specialization').
family_rule(creative_arts_design, direction, leans_toward(animation_game_art), 4, 'you explicitly leaned toward a creative specialization').
family_rule(creative_arts_design, direction, leans_toward(fashion_design), 4, 'you explicitly leaned toward a creative specialization').
family_rule(creative_arts_design, direction, leans_toward(interior_spatial_design), 4, 'you explicitly leaned toward a creative specialization').
family_rule(creative_arts_design, academic, found_difficult(art_design), -6, 'art or design appears difficult for you').

% Career-level rules

career_rule(software_engineering, direction, leans_toward(software_engineering), 7, 'you explicitly leaned toward software engineering').
career_rule(software_engineering, experience, completed_project(coding_project), 6, 'you have done coding or software-style projects').
career_rule(software_engineering, academic, performed_well(computer_studies), 4, 'computer studies supports this path').
career_rule(software_engineering, behavior, shows(problem_solving_behavior), 4, 'problem solving is central here').
career_rule(software_engineering, preference, prefers(technical_systems), 4, 'you prefer technical systems').
career_rule(software_engineering, exclusion, excludes(deep_coding_work), -7, 'you ruled out deep coding-heavy work').

career_rule(web_development, direction, leans_toward(web_development), 7, 'you explicitly leaned toward web development').
career_rule(web_development, experience, completed_project(coding_project), 5, 'coding or website projects support this path').
career_rule(web_development, preference, prefers(user_facing_technology), 5, 'you prefer user-facing technology products').
career_rule(web_development, preference, prefers(design_and_visual_work), 2, 'some visual or design interest supports web work').
career_rule(web_development, exclusion, excludes(deep_coding_work), -3, 'you are cautious about coding-heavy work').

career_rule(mobile_development, direction, leans_toward(mobile_development), 7, 'you explicitly leaned toward mobile development').
career_rule(mobile_development, experience, completed_project(coding_project), 5, 'coding projects support this path').
career_rule(mobile_development, preference, prefers(user_facing_technology), 5, 'you like user-facing technology').
career_rule(mobile_development, behavior, shows(problem_solving_behavior), 3, 'problem solving supports app development').
career_rule(mobile_development, exclusion, excludes(deep_coding_work), -4, 'coding-heavy work is a concern for you').

career_rule(data_science, direction, leans_toward(data_science), 7, 'you explicitly leaned toward data science').
career_rule(data_science, experience, completed_project(data_project), 6, 'data projects strongly support this path').
career_rule(data_science, academic, performed_well(mathematics), 5, 'mathematics is central here').
career_rule(data_science, behavior, shows(analytical_behavior), 4, 'analytical reasoning is central here').
career_rule(data_science, preference, prefers(data_analysis), 6, 'you prefer data and analysis').
career_rule(data_science, exclusion, excludes(deep_coding_work), -2, 'coding concerns slightly weaken this path').
career_rule(data_science, academic, found_difficult(mathematics), -7, 'mathematics difficulty strongly weakens this path').

career_rule(ai_machine_learning, direction, leans_toward(ai_machine_learning), 7, 'you explicitly leaned toward AI or machine learning').
career_rule(ai_machine_learning, experience, completed_project(data_project), 5, 'data or AI-style projects support this path').
career_rule(ai_machine_learning, academic, performed_well(mathematics), 6, 'mathematics is especially important here').
career_rule(ai_machine_learning, behavior, shows(analytical_behavior), 4, 'analysis is central here').
career_rule(ai_machine_learning, goal, values(research), 2, 'research orientation supports this path').
career_rule(ai_machine_learning, exclusion, excludes(deep_coding_work), -5, 'deep coding concerns weaken this path significantly').
career_rule(ai_machine_learning, academic, found_difficult(mathematics), -8, 'mathematics difficulty strongly weakens this path').

career_rule(cybersecurity, direction, leans_toward(cybersecurity), 7, 'you explicitly leaned toward cybersecurity').
career_rule(cybersecurity, experience, completed_project(security_project), 7, 'security projects strongly support this path').
career_rule(cybersecurity, academic, performed_well(computer_studies), 4, 'computer studies supports this path').
career_rule(cybersecurity, behavior, shows(problem_solving_behavior), 4, 'problem solving supports security work').
career_rule(cybersecurity, preference, prefers(technical_systems), 4, 'you prefer technical systems').

career_rule(networking_administration, direction, leans_toward(networking_administration), 7, 'you explicitly leaned toward networking').
career_rule(networking_administration, experience, completed_project(security_project), 4, 'network or security projects support this path').
career_rule(networking_administration, behavior, shows(practical_builder_behavior), 3, 'practical troubleshooting supports networking work').
career_rule(networking_administration, preference, prefers(technical_systems), 5, 'technical systems fit you').
career_rule(networking_administration, preference, prefers_environment(workshop_environment), 2, 'hands-on technical environments fit this path').

career_rule(cloud_devops, direction, leans_toward(cloud_devops), 7, 'you explicitly leaned toward cloud or DevOps work').
career_rule(cloud_devops, experience, completed_project(coding_project), 3, 'coding helps support this path').
career_rule(cloud_devops, experience, completed_project(security_project), 3, 'system or infrastructure projects support this path').
career_rule(cloud_devops, behavior, shows(organization_behavior), 3, 'operational discipline supports this path').
career_rule(cloud_devops, preference, prefers(technical_systems), 5, 'technical systems fit you well').
career_rule(cloud_devops, exclusion, excludes(deep_coding_work), -2, 'coding concerns slightly weaken this path').

career_rule(database_administration, direction, leans_toward(database_administration), 7, 'you explicitly leaned toward databases').
career_rule(database_administration, experience, completed_project(data_project), 3, 'data projects support this path').
career_rule(database_administration, behavior, shows(organization_behavior), 5, 'organization and structure are central here').
career_rule(database_administration, preference, prefers(numbers_and_records), 3, 'structured information work fits you').
career_rule(database_administration, preference, prefers(technical_systems), 3, 'technical systems also fit you').

career_rule(ui_ux_design, direction, leans_toward(ui_ux_design), 7, 'you explicitly leaned toward UI or UX').
career_rule(ui_ux_design, experience, completed_project(design_project), 5, 'design portfolio work supports this path').
career_rule(ui_ux_design, behavior, shows(creative_behavior), 4, 'creative behaviour matters here').
career_rule(ui_ux_design, preference, prefers(design_and_visual_work), 6, 'design and visual work fit you strongly').
career_rule(ui_ux_design, preference, prefers(user_facing_technology), 4, 'user-facing digital products fit you').
career_rule(ui_ux_design, exclusion, excludes(design_studio_work), -2, 'design-studio work concerns slightly weaken this path').

career_rule(systems_analysis, direction, leans_toward(systems_analysis), 7, 'you explicitly leaned toward systems analysis').
career_rule(systems_analysis, behavior, shows(analytical_behavior), 4, 'analysis is central here').
career_rule(systems_analysis, behavior, shows(organization_behavior), 3, 'organization supports systems analysis').
career_rule(systems_analysis, preference, prefers(technical_systems), 4, 'technical systems fit you').
career_rule(systems_analysis, preference, prefers(business_processes), 4, 'business processes also fit you').
career_rule(systems_analysis, exclusion, excludes(deep_coding_work), 1, 'not wanting deep coding does not rule this path out strongly').

career_rule(business_information_systems, direction, leans_toward(business_information_systems), 7, 'you explicitly leaned toward business information systems').
career_rule(business_information_systems, academic, performed_well(business_studies), 3, 'business understanding supports this path').
career_rule(business_information_systems, academic, performed_well(computer_studies), 4, 'computer studies supports this path').
career_rule(business_information_systems, preference, prefers(business_processes), 5, 'business processes fit you').
career_rule(business_information_systems, preference, prefers(technical_systems), 5, 'technology systems also fit you').
career_rule(business_information_systems, exclusion, excludes(deep_coding_work), 1, 'not wanting deep coding does not strongly rule this path out').

career_rule(civil_structural_engineering, direction, leans_toward(civil_structural_engineering), 7, 'you explicitly leaned toward civil or structural engineering').
career_rule(civil_structural_engineering, academic, performed_well(mathematics), 4, 'mathematics supports structural work').
career_rule(civil_structural_engineering, academic, performed_well(physics), 4, 'physics supports structural work').
career_rule(civil_structural_engineering, preference, prefers(machines_and_structures), 5, 'structures and physical systems fit you').
career_rule(civil_structural_engineering, exclusion, excludes(engineering_work), -8, 'you explicitly ruled out engineering work').

career_rule(mechanical_mechatronics_engineering, direction, leans_toward(mechanical_mechatronics_engineering), 7, 'you explicitly leaned toward mechanical or mechatronics work').
career_rule(mechanical_mechatronics_engineering, academic, performed_well(mathematics), 4, 'mathematics supports this path').
career_rule(mechanical_mechatronics_engineering, academic, performed_well(physics), 4, 'physics supports this path').
career_rule(mechanical_mechatronics_engineering, behavior, shows(practical_builder_behavior), 4, 'hands-on building supports this path').
career_rule(mechanical_mechatronics_engineering, exclusion, excludes(engineering_work), -8, 'you explicitly ruled out engineering work').

career_rule(electrical_electronics_engineering, direction, leans_toward(electrical_electronics_engineering), 7, 'you explicitly leaned toward electronics').
career_rule(electrical_electronics_engineering, academic, performed_well(mathematics), 4, 'mathematics supports this path').
career_rule(electrical_electronics_engineering, academic, performed_well(physics), 5, 'physics strongly supports this path').
career_rule(electrical_electronics_engineering, preference, prefers(machines_and_structures), 4, 'technical devices fit you').
career_rule(electrical_electronics_engineering, exclusion, excludes(engineering_work), -8, 'you explicitly ruled out engineering work').

career_rule(environmental_energy_engineering, direction, leans_toward(environmental_energy_engineering), 7, 'you explicitly leaned toward energy or environmental engineering').
career_rule(environmental_energy_engineering, academic, performed_well(physics), 3, 'physics supports this path').
career_rule(environmental_energy_engineering, academic, performed_well(chemistry), 3, 'chemistry can support this path').
career_rule(environmental_energy_engineering, goal, values(social_impact), 3, 'impact often matters in this path').
career_rule(environmental_energy_engineering, exclusion, excludes(engineering_work), -8, 'you explicitly ruled out engineering work').

career_rule(architecture_built_environment, direction, leans_toward(architecture_built_environment), 7, 'you explicitly leaned toward architecture or built environment').
career_rule(architecture_built_environment, academic, performed_well(art_design), 4, 'design strength supports this path').
career_rule(architecture_built_environment, academic, performed_well(mathematics), 2, 'mathematics still supports this path').
career_rule(architecture_built_environment, preference, prefers(design_and_visual_work), 4, 'design preference supports this path').
career_rule(architecture_built_environment, exclusion, excludes(engineering_work), -4, 'engineering concerns weaken this path').

career_rule(medicine, direction, leans_toward(medicine), 7, 'you explicitly leaned toward medicine').
career_rule(medicine, academic, performed_well(biology), 5, 'biology strongly supports medicine').
career_rule(medicine, academic, performed_well(chemistry), 4, 'chemistry strongly supports medicine').
career_rule(medicine, preference, prefers_environment(hospital_environment), 4, 'clinical environments fit this path').
career_rule(medicine, exclusion, excludes(hospital_environment), -8, 'you ruled out hospital environments').
career_rule(medicine, exclusion, excludes(direct_patient_care), -8, 'you ruled out direct patient-care work').

career_rule(nursing, direction, leans_toward(nursing), 7, 'you explicitly leaned toward nursing').
career_rule(nursing, academic, performed_well(biology), 4, 'biology supports nursing').
career_rule(nursing, behavior, shows(helping_behavior), 5, 'helping behaviour strongly supports nursing').
career_rule(nursing, behavior, shows(empathy_behavior), 5, 'empathy strongly supports nursing').
career_rule(nursing, exclusion, excludes(hospital_environment), -8, 'you ruled out hospital environments').
career_rule(nursing, exclusion, excludes(direct_patient_care), -9, 'you ruled out direct patient care').

career_rule(pharmacy, direction, leans_toward(pharmacy), 7, 'you explicitly leaned toward pharmacy').
career_rule(pharmacy, academic, performed_well(chemistry), 5, 'chemistry strongly supports pharmacy').
career_rule(pharmacy, academic, performed_well(biology), 2, 'biology also supports pharmacy').
career_rule(pharmacy, behavior, shows(organization_behavior), 3, 'accuracy and organization support pharmacy').
career_rule(pharmacy, exclusion, excludes(direct_patient_care), -1, 'avoiding direct patient care does not fully rule pharmacy out').

career_rule(medical_laboratory_science, direction, leans_toward(medical_laboratory_science), 7, 'you explicitly leaned toward laboratory science').
career_rule(medical_laboratory_science, experience, completed_project(science_lab_project), 6, 'lab projects strongly support this path').
career_rule(medical_laboratory_science, academic, performed_well(biology), 4, 'biology supports laboratory science').
career_rule(medical_laboratory_science, academic, performed_well(chemistry), 4, 'chemistry supports laboratory science').
career_rule(medical_laboratory_science, exclusion, excludes(repetitive_lab_work), -7, 'you ruled out repetitive lab work').

career_rule(public_health, direction, leans_toward(public_health), 7, 'you explicitly leaned toward public health').
career_rule(public_health, experience, completed_project(health_project), 4, 'health-related projects support this path').
career_rule(public_health, experience, completed_project(community_project), 4, 'community projects strongly support public health').
career_rule(public_health, behavior, shows(helping_behavior), 3, 'helping behaviour supports this path').
career_rule(public_health, goal, values(social_impact), 5, 'social impact strongly supports this path').
career_rule(public_health, exclusion, excludes(hospital_environment), 1, 'not wanting hospital work does not strongly rule public health out').

career_rule(mathematics_education, direction, leans_toward(mathematics_education), 7, 'you explicitly leaned toward mathematics education').
career_rule(mathematics_education, academic, performed_well(mathematics), 6, 'mathematics is central here').
career_rule(mathematics_education, experience, taught_subject(mathematics), 6, 'you have already taught or explained mathematics').
career_rule(mathematics_education, behavior, shows(teaching_behavior), 5, 'teaching behaviour strongly supports this path').
career_rule(mathematics_education, preference, prefers_environment(classroom_environment), 4, 'classroom environments fit this path').

career_rule(science_education, direction, leans_toward(science_education), 7, 'you explicitly leaned toward science education').
career_rule(science_education, academic, performed_well(biology), 2, 'science strength supports this path').
career_rule(science_education, academic, performed_well(physics), 2, 'science strength supports this path').
career_rule(science_education, behavior, shows(teaching_behavior), 5, 'teaching behaviour strongly supports this path').
career_rule(science_education, preference, prefers_environment(classroom_environment), 4, 'classroom environments fit this path').

career_rule(language_humanities_education, direction, leans_toward(language_humanities_education), 7, 'you explicitly leaned toward language or humanities education').
career_rule(language_humanities_education, academic, performed_well(english), 4, 'English supports this path').
career_rule(language_humanities_education, academic, enjoyed(literature), 3, 'language or literature enjoyment supports this path').
career_rule(language_humanities_education, behavior, shows(teaching_behavior), 5, 'teaching behaviour strongly supports this path').
career_rule(language_humanities_education, preference, prefers_environment(classroom_environment), 4, 'classroom environments fit this path').

career_rule(educational_guidance_counseling, direction, leans_toward(educational_guidance_counseling), 7, 'you explicitly leaned toward educational guidance').
career_rule(educational_guidance_counseling, behavior, shows(helping_behavior), 5, 'helping behaviour strongly supports this path').
career_rule(educational_guidance_counseling, behavior, shows(empathy_behavior), 5, 'empathy strongly supports this path').
career_rule(educational_guidance_counseling, preference, prefers(people_helping), 5, 'people-centered support fits this path').
career_rule(educational_guidance_counseling, goal, values(social_impact), 4, 'social impact supports this path').

career_rule(accounting, direction, leans_toward(accounting), 7, 'you explicitly leaned toward accounting').
career_rule(accounting, academic, performed_well(accounting), 6, 'accounting is central here').
career_rule(accounting, preference, prefers(numbers_and_records), 6, 'numbers and records fit this path strongly').
career_rule(accounting, behavior, shows(organization_behavior), 5, 'organization strongly supports accounting').
career_rule(accounting, exclusion, excludes(routine_office_work), -5, 'routine office work is a clear turnoff for you').

career_rule(finance_banking, direction, leans_toward(finance_banking), 7, 'you explicitly leaned toward finance or banking').
career_rule(finance_banking, academic, performed_well(mathematics), 4, 'mathematics supports finance').
career_rule(finance_banking, academic, performed_well(economics), 4, 'economics supports finance').
career_rule(finance_banking, preference, prefers(numbers_and_records), 5, 'numerical work supports this path').
career_rule(finance_banking, goal, values(income), 3, 'income motivation supports this path').

career_rule(marketing_digital_marketing, direction, leans_toward(marketing_digital_marketing), 7, 'you explicitly leaned toward marketing').
career_rule(marketing_digital_marketing, experience, completed_project(media_project), 3, 'media projects support marketing').
career_rule(marketing_digital_marketing, behavior, shows(communication_behavior), 4, 'communication strongly supports marketing').
career_rule(marketing_digital_marketing, behavior, shows(creative_behavior), 3, 'creativity supports marketing').
career_rule(marketing_digital_marketing, exclusion, excludes(sales_heavy_work), -3, 'sales-heavy work is a turnoff for you').

career_rule(entrepreneurship_business_development, direction, leans_toward(entrepreneurship_business_development), 7, 'you explicitly leaned toward entrepreneurship').
career_rule(entrepreneurship_business_development, experience, completed_project(business_project), 6, 'business projects strongly support this path').
career_rule(entrepreneurship_business_development, behavior, shows(leadership_behavior), 4, 'leadership supports this path').
career_rule(entrepreneurship_business_development, goal, values(entrepreneurship), 7, 'entrepreneurship is central to this path').
career_rule(entrepreneurship_business_development, exclusion, excludes(routine_office_work), 1, 'disliking routine office work does not strongly rule this path out').

career_rule(operations_supply_chain, direction, leans_toward(operations_supply_chain), 7, 'you explicitly leaned toward operations or supply chain').
career_rule(operations_supply_chain, behavior, shows(organization_behavior), 5, 'organization strongly supports this path').
career_rule(operations_supply_chain, preference, prefers(business_processes), 5, 'business process work supports this path').
career_rule(operations_supply_chain, preference, prefers_environment(office_environment), 3, 'office planning environments fit this path').
career_rule(operations_supply_chain, exclusion, excludes(routine_office_work), -3, 'routine office work is a concern for you').

career_rule(journalism_reporting, direction, leans_toward(journalism_reporting), 7, 'you explicitly leaned toward journalism').
career_rule(journalism_reporting, experience, completed_project(media_project), 6, 'media or reporting projects strongly support this path').
career_rule(journalism_reporting, behavior, shows(communication_behavior), 5, 'communication strongly supports journalism').
career_rule(journalism_reporting, behavior, shows(research_behavior), 3, 'investigation supports journalism').
career_rule(journalism_reporting, exclusion, excludes(public_speaking_work), -1, 'public speaking concerns do not strongly rule journalism out').

career_rule(public_relations_communications, direction, leans_toward(public_relations_communications), 7, 'you explicitly leaned toward public relations').
career_rule(public_relations_communications, behavior, shows(communication_behavior), 5, 'communication strongly supports this path').
career_rule(public_relations_communications, behavior, shows(leadership_behavior), 2, 'leadership can support this path').
career_rule(public_relations_communications, preference, prefers(media_storytelling), 4, 'media and messaging fit this path').
career_rule(public_relations_communications, exclusion, excludes(public_speaking_work), -4, 'public-speaking-heavy work is a turnoff for you').

career_rule(broadcasting_multimedia_production, direction, leans_toward(broadcasting_multimedia_production), 7, 'you explicitly leaned toward multimedia production').
career_rule(broadcasting_multimedia_production, experience, completed_project(media_project), 5, 'media projects support this path').
career_rule(broadcasting_multimedia_production, behavior, shows(creative_behavior), 4, 'creative behaviour supports this path').
career_rule(broadcasting_multimedia_production, preference, prefers_environment(studio_environment), 4, 'studio environments fit this path').
career_rule(broadcasting_multimedia_production, exclusion, excludes(public_speaking_work), -2, 'public speaking concerns slightly weaken this path').

career_rule(technical_writing_documentation, direction, leans_toward(technical_writing_documentation), 7, 'you explicitly leaned toward technical writing').
career_rule(technical_writing_documentation, academic, performed_well(english), 5, 'English supports this path').
career_rule(technical_writing_documentation, behavior, shows(communication_behavior), 5, 'clear communication strongly supports this path').
career_rule(technical_writing_documentation, behavior, shows(analytical_behavior), 3, 'analysis helps with structured documentation').
career_rule(technical_writing_documentation, preference, prefers(media_storytelling), 2, 'writing-focused work fits this path').

career_rule(law, direction, leans_toward(law), 7, 'you explicitly leaned toward law').
career_rule(law, academic, performed_well(english), 4, 'English supports legal work').
career_rule(law, experience, joined(debate_public_speaking), 5, 'debate strongly supports this path').
career_rule(law, preference, prefers(law_policy_debate), 6, 'law and argument fit this path').
career_rule(law, exclusion, excludes(law_argument_work), -9, 'you explicitly ruled out legal argument-heavy work').

career_rule(public_administration_policy, direction, leans_toward(public_administration_policy), 7, 'you explicitly leaned toward policy or administration').
career_rule(public_administration_policy, experience, joined(civic_club), 4, 'civic activity supports this path').
career_rule(public_administration_policy, behavior, shows(organization_behavior), 3, 'organization supports this path').
career_rule(public_administration_policy, goal, values(public_service), 5, 'public service strongly supports this path').
career_rule(public_administration_policy, exclusion, excludes(routine_office_work), -2, 'routine office work concerns slightly weaken this path').

career_rule(international_relations_diplomacy, direction, leans_toward(international_relations_diplomacy), 7, 'you explicitly leaned toward diplomacy').
career_rule(international_relations_diplomacy, experience, joined(civic_club), 5, 'civic or model-un activity strongly supports this path').
career_rule(international_relations_diplomacy, behavior, shows(communication_behavior), 4, 'communication strongly supports this path').
career_rule(international_relations_diplomacy, goal, values(public_service), 4, 'public service supports this path').
career_rule(international_relations_diplomacy, exclusion, excludes(public_speaking_work), -3, 'public-speaking concerns weaken this path').

career_rule(criminology_security_studies, direction, leans_toward(criminology_security_studies), 7, 'you explicitly leaned toward criminology or security studies').
career_rule(criminology_security_studies, behavior, shows(analytical_behavior), 3, 'analysis supports this path').
career_rule(criminology_security_studies, preference, prefers(law_policy_debate), 4, 'justice and security interests fit this path').
career_rule(criminology_security_studies, goal, values(public_service), 4, 'public service supports this path').
career_rule(criminology_security_studies, exclusion, excludes(law_argument_work), -1, 'legal-argument concerns do not fully rule this path out').

career_rule(psychology_counseling, direction, leans_toward(psychology_counseling), 7, 'you explicitly leaned toward counseling or psychology').
career_rule(psychology_counseling, behavior, shows(helping_behavior), 4, 'helping behaviour strongly supports this path').
career_rule(psychology_counseling, behavior, shows(empathy_behavior), 6, 'empathy strongly supports this path').
career_rule(psychology_counseling, preference, prefers(people_helping), 5, 'people-centered support fits this path').
career_rule(psychology_counseling, exclusion, excludes(public_speaking_work), 1, 'public speaking concerns do not strongly rule this path out').

career_rule(social_work, direction, leans_toward(social_work), 7, 'you explicitly leaned toward social work').
career_rule(social_work, experience, joined(community_service), 5, 'community service strongly supports this path').
career_rule(social_work, behavior, shows(helping_behavior), 5, 'helping behaviour strongly supports this path').
career_rule(social_work, preference, prefers(community_support), 5, 'community support work fits this path').
career_rule(social_work, goal, values(social_impact), 5, 'social impact strongly supports this path').

career_rule(human_resource_management, direction, leans_toward(human_resource_management), 7, 'you explicitly leaned toward human resources').
career_rule(human_resource_management, behavior, shows(communication_behavior), 4, 'communication strongly supports this path').
career_rule(human_resource_management, behavior, shows(organization_behavior), 4, 'organization strongly supports this path').
career_rule(human_resource_management, preference, prefers(people_helping), 3, 'people-facing work supports this path').
career_rule(human_resource_management, preference, prefers_environment(office_environment), 3, 'office environments fit this path').

career_rule(community_development_ngo, direction, leans_toward(community_development_ngo), 7, 'you explicitly leaned toward community or NGO development').
career_rule(community_development_ngo, experience, completed_project(community_project), 5, 'community projects strongly support this path').
career_rule(community_development_ngo, experience, joined(community_service), 5, 'community service strongly supports this path').
career_rule(community_development_ngo, preference, prefers(community_support), 6, 'community support work strongly fits this path').
career_rule(community_development_ngo, goal, values(social_impact), 6, 'social impact is central here').

career_rule(graphic_communication_design, direction, leans_toward(graphic_communication_design), 7, 'you explicitly leaned toward graphic design').
career_rule(graphic_communication_design, experience, completed_project(design_project), 6, 'design portfolio work strongly supports this path').
career_rule(graphic_communication_design, academic, performed_well(art_design), 5, 'art and design strongly support this path').
career_rule(graphic_communication_design, preference, prefers(design_and_visual_work), 6, 'visual design work strongly fits this path').
career_rule(graphic_communication_design, exclusion, excludes(design_studio_work), -7, 'you ruled out design-studio work').

career_rule(animation_game_art, direction, leans_toward(animation_game_art), 7, 'you explicitly leaned toward animation or game art').
career_rule(animation_game_art, experience, completed_project(design_project), 5, 'creative project work supports this path').
career_rule(animation_game_art, behavior, shows(creative_behavior), 5, 'creative behaviour strongly supports this path').
career_rule(animation_game_art, preference, prefers(design_and_visual_work), 5, 'visual creative work fits this path').
career_rule(animation_game_art, exclusion, excludes(design_studio_work), -3, 'design-studio concerns slightly weaken this path').

career_rule(fashion_design, direction, leans_toward(fashion_design), 7, 'you explicitly leaned toward fashion design').
career_rule(fashion_design, experience, completed_project(design_project), 4, 'design portfolio work supports this path').
career_rule(fashion_design, academic, enjoyed(art_design), 4, 'art and design enjoyment supports this path').
career_rule(fashion_design, behavior, shows(creative_behavior), 5, 'creative behaviour strongly supports this path').
career_rule(fashion_design, exclusion, excludes(design_studio_work), -2, 'design-studio concerns slightly weaken this path').

career_rule(interior_spatial_design, direction, leans_toward(interior_spatial_design), 7, 'you explicitly leaned toward interior or spatial design').
career_rule(interior_spatial_design, experience, completed_project(design_project), 4, 'design portfolio work supports this path').
career_rule(interior_spatial_design, academic, performed_well(art_design), 4, 'design strength supports this path').
career_rule(interior_spatial_design, preference, prefers(design_and_visual_work), 5, 'design and visual work fit this path').
career_rule(interior_spatial_design, exclusion, excludes(design_studio_work), -3, 'design-studio concerns slightly weaken this path').
