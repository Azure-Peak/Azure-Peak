/datum/antagonist/renegade
	name = "Renegade"
	roundend_category = "renegades"
	antagpanel_category = "Renegade"
	job_rank = ROLE_RENEGADE
	confess_lines = list(
		"I ANSWER TO NO CROWN!",
		"LET IT ALL BURN!",
		"VHESLIE PAYS BETTER THAN YOUR LORD!",
	)
	rogue_enabled = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_maxcaps = list(/datum/storyteller/gamemode/guaranteed_antag = 3)
	/// Skill levels still owed, handed out in order.
	var/list/picks = list(SKILL_LEVEL_MASTER, SKILL_LEVEL_EXPERT, SKILL_LEVEL_EXPERT, SKILL_LEVEL_JOURNEYMAN, SKILL_LEVEL_JOURNEYMAN, SKILL_LEVEL_JOURNEYMAN)
	/// Skill types already picked, so none is picked twice.
	var/list/chosen = list()
	/// TRUE while the skill prompt is open, so it is not stacked.
	var/picking = FALSE
	/// The Boon Menu backing this Renegade.
	var/datum/renegade_boons/boons
	/// Total psila spent on boons.
	var/spent = 0
	/// Names of every boon bought.
	var/list/bought = list()

/datum/antagonist/renegade/Destroy()
	QDEL_NULL(boons)
	return ..()

/datum/antagonist/renegade/examine_friendorfoe(datum/antagonist/examined_datum, mob/examiner, mob/examined)
	if(istype(examined_datum, /datum/antagonist/renegade))
		return span_boldnotice("Another Renegade. Vheslie feeds us both.")

/datum/antagonist/renegade/on_gain()
	owner.special_role = name
	boons = new(src)
	objectives += new /datum/objective/renegade(null, owner)
	. = ..()
	greet()
	add_verb(owner.current, list(/mob/living/carbon/human/proc/renegade_skills, /mob/living/carbon/human/proc/renegade_goals))
	INVOKE_ASYNC(src, PROC_REF(write_goals))
	wait_class()

/datum/antagonist/renegade/on_removal()
	if(owner?.current)
		remove_verb(owner.current, list(/mob/living/carbon/human/proc/renegade_skills, /mob/living/carbon/human/proc/renegade_goals))
	return ..()

/datum/antagonist/renegade/greet()
	var/mob/M = owner.current
	to_chat(M, span_alertsyndie("I am a RENEGADE!"))
	to_chat(M, span_boldwarning("I've had enough. Xylix has deemed me befitting of lyfe for another dae', and I'm about to make it everyone's problem."))
	to_chat(M, span_boldwarning("I shouldn't care for allegiences, or friendships. Everyone's an equal opportunity for misery."))
	to_chat(M, span_info("Placing a stack of psila in my mouth opens the Boon Menu, linking me to the Vile Vheslie's hoard and to boons meant for Renegades alone."))
	to_chat(M, span_info("A single psilen flipped in my hand crumbles and answers to me. It may hurl me somewhere far off, or bite into my flesh."))
	to_chat(M, span_info("Vheslie can only grant me boons whilst I'm in Azure Peak itself, as well as its sewers and harbour."))
	M.playsound_local(get_turf(M), 'sound/music/renegade_strawberye.ogg', 60, FALSE, pressure_affected = FALSE)
	owner.announce_objectives()

/datum/antagonist/renegade/proc/write_goals()
	var/mob/M = owner?.current
	var/datum/objective/renegade/O = locate() in objectives
	if(!M || !O)
		return
	var/text = tgui_input_text(M, "What do I mean to do this round?", "Renegade Objectives", O.explanation_text, MAX_MESSAGE_LEN, TRUE)
	if(QDELETED(src) || QDELETED(M))
		return
	if(text)
		O.explanation_text = text
	owner.announce_objectives()
	to_chat(M, span_notice("I can rewrite my objectives with the Rewrite Objectives verb under RoleUnique."))

/datum/antagonist/renegade/proc/wait_class()
	var/mob/living/carbon/human/H = owner?.current
	if(!istype(H))
		return
	if(H.advsetup)
		addtimer(CALLBACK(src, PROC_REF(wait_class)), 5 SECONDS)
		return
	H.put_in_hands(new /obj/item/roguecoin/aalloy(get_turf(H), RENEGADE_STARTING_PSILA))
	to_chat(H, span_notice("A purse of [RENEGADE_STARTING_PSILA] psila weighs in my hand. Vheslie will take them gladly."))
	INVOKE_ASYNC(src, PROC_REF(pick_skills))

/datum/antagonist/renegade/proc/pick_skills()
	var/mob/living/carbon/human/H = owner?.current
	if(!istype(H) || picking || !length(picks))
		return
	picking = TRUE
	while(length(picks))
		var/level = picks[1]
		var/label = SSskills.level_names_plain[level]
		var/list/options = list()
		for(var/skill_type in SSskills.all_skills)
			if(skill_type in chosen)
				continue
			var/datum/skill/S = SSskills.all_skills[skill_type]
			options["[S.name] (now [skill_to_string(H.get_skill_level(skill_type))])"] = S
		var/choice = tgui_input_list(H, "Choose a skill to raise to [label]. ([length(picks)] picks left)", "Renegade Skills", sortList(options))
		if(!choice || QDELETED(src) || QDELETED(H))
			break
		var/datum/skill/picked = options[choice]
		chosen += picked.type
		picks.Cut(1, 2)
		H.adjust_skillrank_up_to(picked.type, level, TRUE)
		to_chat(H, span_notice("My [LOWER_TEXT(picked.name)] sharpens to [label]."))
	picking = FALSE
	if(QDELETED(src) || QDELETED(H))
		return
	if(length(picks))
		to_chat(H, span_warning("[length(picks)] skill picks remain. I can return to them with the Renegade Skills verb."))
	else
		remove_verb(H, /mob/living/carbon/human/proc/renegade_skills)

/datum/antagonist/renegade/roundend_report()
	return "[..()][spent ? "Spent [spent] psila on boons: [english_list(bought)]." : "Never bargained with Vheslie."]"

/mob/living/carbon/human/proc/renegade_skills()
	set name = "Renegade Skills"
	set category = "RoleUnique.Renegade"
	var/datum/antagonist/renegade/R = mind?.has_antag_datum(/datum/antagonist/renegade)
	if(!R)
		remove_verb(src, /mob/living/carbon/human/proc/renegade_skills)
		return
	if(advsetup)
		to_chat(src, span_warning("I must settle on my calling first."))
		return
	INVOKE_ASYNC(R, TYPE_PROC_REF(/datum/antagonist/renegade, pick_skills))

/mob/living/carbon/human/proc/renegade_goals()
	set name = "Rewrite Objectives"
	set category = "RoleUnique.Renegade"
	var/datum/antagonist/renegade/R = mind?.has_antag_datum(/datum/antagonist/renegade)
	if(!R)
		remove_verb(src, /mob/living/carbon/human/proc/renegade_goals)
		return
	INVOKE_ASYNC(R, TYPE_PROC_REF(/datum/antagonist/renegade, write_goals))

/datum/objective/renegade
	name = "sow chaos"
	explanation_text = "Sow chaos. Break the peace of this town by whatever means I see fit."
	triumph_count = 0

/datum/objective/renegade/check_completion()
	return TRUE
