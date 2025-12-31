/mob
	var/datum/skill_holder/skills

/mob/proc/ensure_skills()
	RETURN_TYPE(/datum/skill_holder)
	if(!skills)
		skills = new /datum/skill_holder()
		skills.set_current(src)
	return skills

/mob/proc/get_skill_level(skill)
	return ensure_skills().get_skill_level(skill)

/mob/proc/adjust_experience(skill, amt, silent=FALSE, check_apprentice=TRUE)
	return ensure_skills().adjust_experience(skill, amt, silent, check_apprentice)

/mob/proc/get_skill_speed_modifier(skill)
	return ensure_skills().get_skill_speed_modifier(skill)

/mob/proc/adjust_skillrank(skill, amt, silent = FALSE)
	return ensure_skills().adjust_skillrank(skill, amt, silent)

/mob/proc/adjust_skillrank_up_to(skill, amt, silent = FALSE)
	return ensure_skills().adjust_skillrank_up_to(skill, amt, silent)

/mob/proc/adjust_skillrank_down_to(skill, amt, silent = FALSE)
	return ensure_skills().adjust_skillrank_down_to(skill, amt, silent)
	
/mob/proc/print_levels()
	return ensure_skills().print_levels(src)

/mob/proc/get_mentor()
	return ensure_skills().mentor

/mob/proc/set_mentor(mob/living/carbon/human/M)
	ensure_skills().mentor = M

/mob/proc/get_apprentice()
	return ensure_skills().my_apprentice

/mob/proc/set_apprentice(mob/living/carbon/human/A)
	ensure_skills().my_apprentice = A

/datum/skill_holder
	///our current host
	var/mob/living/current
	///Assoc list of skills - level
	var/list/known_skills = list()
	///Assoc list of skills - exp
	var/list/skill_experience = list()
	///Cooldown for level up effects. Duplicate from sleep_adv
	COOLDOWN_DECLARE(level_up)
	// Mentor & Apprentice system. Each person may only have one mentor and apprentice per round.
	// This is used by the Take Apprentice spell.
	var/mob/living/carbon/human/mentor = null
	var/mob/living/carbon/human/my_apprentice = null

/datum/skill_holder/New()
	. = ..()
	for(var/datum/skill/skill as anything in SSskills.all_skills)
		if(!(skill in skill_experience))
			skill_experience |= skill
			skill_experience[skill] = 0

/datum/skill_holder/Destroy()
	current = null
	. = ..()

/datum/skill_holder/proc/set_current(mob/incoming)
	current = incoming
	RegisterSignal(incoming, COMSIG_MIND_TRANSFER, PROC_REF(transfer_skills))
	incoming.skills = src

/datum/skill_holder/proc/transfer_skills(mob/source, mob/destination)
	UnregisterSignal(source, COMSIG_MIND_TRANSFER)
	set_current(destination)

/datum/skill_holder/proc/adjust_experience(skill, amt, silent = FALSE)
	var/datum/skill/S = GetSkillRef(skill)
	skill_experience[S] = max(0, skill_experience[S] + amt) //Prevent going below 0
	var/old_level = known_skills[S]
	switch(skill_experience[S])
		if(SKILL_EXP_LEGENDARY to INFINITY)
			known_skills[S] = SKILL_LEVEL_LEGENDARY

		if(SKILL_EXP_MASTER to SKILL_EXP_LEGENDARY)
			known_skills[S] = SKILL_LEVEL_MASTER

		if(SKILL_EXP_EXPERT to SKILL_EXP_MASTER)
			known_skills[S] = SKILL_LEVEL_EXPERT

		if(SKILL_EXP_JOURNEYMAN to SKILL_EXP_EXPERT)
			known_skills[S] = SKILL_LEVEL_JOURNEYMAN

		if(SKILL_EXP_APPRENTICE to SKILL_EXP_JOURNEYMAN)
			known_skills[S] = SKILL_LEVEL_APPRENTICE

		if(SKILL_EXP_NOVICE to SKILL_EXP_APPRENTICE)
			known_skills[S] = SKILL_LEVEL_NOVICE

		if(0 to SKILL_EXP_NOVICE)
			known_skills[S] = SKILL_LEVEL_NONE

	if(isnull(old_level) || known_skills[S] == old_level)
		return //same level or we just started earning xp towards the first level.
	if(silent)
		return
	// ratio = round(skill_experience[S]/limit,1) * 100
	// to_chat(current, "<span class='nicegreen'> My [S.name] is around [ratio]% of the way there.")
	//TODO add some bar hud or something, i think i seen a request like that somewhere
	if(known_skills[S] >= old_level)
		if(known_skills[S] > old_level)
			to_chat(current, span_nicegreen("My [S.name] grows to [SSskills.level_names[known_skills[S]]]!"))
			if(!COOLDOWN_FINISHED(src, level_up))
				if(current.client?.prefs.floating_text_toggles & XP_TEXT)
					current.balloon_alert(current, "<font color = '#9BCCD0'>Level up...</font>")
				current.playsound_local(current, pick(LEVEL_UP_SOUNDS), 100, TRUE)
				COOLDOWN_START(src, level_up, XP_SHOW_COOLDOWN)
			SEND_SIGNAL(current, COMSIG_SKILL_RANK_INCREASED, S, known_skills[S], old_level)
			record_round_statistic(STATS_SKILLS_LEARNED)
			S.skill_level_effect(known_skills[S], src)
			if(istype(known_skills, /datum/skill/combat))
				record_round_statistic(STATS_COMBAT_SKILLS)
			if(istype(known_skills, /datum/skill/craft))
				record_round_statistic(STATS_CRAFT_SKILLS)
	else
		to_chat(current, span_warning("My [S.name] has weakened to [SSskills.level_names[known_skills[S]]]!"))

/datum/skill_holder/proc/adjust_skillrank_up_to(skill, amt, silent = FALSE)
	var/proper_amt = amt - get_skill_level(skill)
	if(proper_amt <= 0)
		return
	adjust_skillrank(skill, proper_amt, silent)

/datum/skill_holder/proc/adjust_skillrank_down_to(skill, amt, silent = FALSE)
	var/proper_amt = get_skill_level(skill) - amt
	if(proper_amt <= 0)
		return
	adjust_skillrank(skill, -proper_amt, silent)

/datum/skill_holder/proc/adjust_skillrank(skill, amt, silent = FALSE)
	if(!amt)
		return
	if(!skill)
		CRASH("adjust_skillrank was called without a specified skill!")
	/// The skill we are changing
	var/datum/skill/skill_ref = GetSkillRef(skill)
	/// How much experience the mob gets at the end
	var/amt2gain = 0
	if(amt > 0)
		for(var/i in 1 to amt)
			switch(skill_experience[skill_ref])
				if(SKILL_EXP_MASTER to SKILL_EXP_LEGENDARY)
					amt2gain = SKILL_EXP_LEGENDARY-skill_experience[skill_ref]
				if(SKILL_EXP_EXPERT to SKILL_EXP_MASTER)
					amt2gain = SKILL_EXP_MASTER-skill_experience[skill_ref]
				if(SKILL_EXP_JOURNEYMAN to SKILL_EXP_EXPERT)
					amt2gain = SKILL_EXP_EXPERT-skill_experience[skill_ref]
				if(SKILL_EXP_APPRENTICE to SKILL_EXP_JOURNEYMAN)
					amt2gain = SKILL_EXP_JOURNEYMAN-skill_experience[skill_ref]
				if(SKILL_EXP_NOVICE to SKILL_EXP_APPRENTICE)
					amt2gain = SKILL_EXP_APPRENTICE-skill_experience[skill_ref]
				if(0 to SKILL_EXP_NOVICE)
					amt2gain = SKILL_EXP_NOVICE-skill_experience[skill_ref] + 1
			if(!skill_experience[skill_ref])
				amt2gain = SKILL_EXP_NOVICE+1
			skill_experience[skill_ref] = max(0, skill_experience[skill_ref] + amt2gain) //Prevent going below 0
	if(amt < 0)
		var/flipped_amt = -amt
		for(var/i in 1 to flipped_amt)
			switch(skill_experience[skill_ref])
				if(SKILL_EXP_LEGENDARY)
					amt2gain = SKILL_EXP_MASTER
				if(SKILL_EXP_MASTER to SKILL_EXP_LEGENDARY-1)
					amt2gain = SKILL_EXP_EXPERT
				if(SKILL_EXP_EXPERT to SKILL_EXP_MASTER-1)
					amt2gain = SKILL_EXP_JOURNEYMAN
				if(SKILL_EXP_JOURNEYMAN to SKILL_EXP_EXPERT -1)
					amt2gain = SKILL_EXP_APPRENTICE
				if(SKILL_EXP_APPRENTICE to SKILL_EXP_JOURNEYMAN-1)
					amt2gain = SKILL_EXP_NOVICE
				if(SKILL_EXP_NOVICE to SKILL_EXP_APPRENTICE-1)
					amt2gain = 1
				if(0 to SKILL_EXP_NOVICE)
					amt2gain = 1
			if(!skill_experience[skill_ref])
				amt2gain = 1
			skill_experience[skill_ref] = amt2gain //Prevent going below 0

	var/old_level = known_skills[skill_ref]
	switch(skill_experience[skill_ref])
		if(SKILL_EXP_LEGENDARY to INFINITY)
			known_skills[skill_ref] = SKILL_LEVEL_LEGENDARY
		if(SKILL_EXP_MASTER to SKILL_EXP_LEGENDARY)
			known_skills[skill_ref] = SKILL_LEVEL_MASTER
		if(SKILL_EXP_EXPERT to SKILL_EXP_MASTER)
			known_skills[skill_ref] = SKILL_LEVEL_EXPERT
		if(SKILL_EXP_JOURNEYMAN to SKILL_EXP_EXPERT)
			known_skills[skill_ref] = SKILL_LEVEL_JOURNEYMAN
		if(SKILL_EXP_APPRENTICE to SKILL_EXP_JOURNEYMAN)
			known_skills[skill_ref] = SKILL_LEVEL_APPRENTICE
		if(SKILL_EXP_NOVICE to SKILL_EXP_APPRENTICE)
			known_skills[skill_ref] = SKILL_LEVEL_NOVICE
		if(0 to SKILL_EXP_NOVICE)
			known_skills[skill_ref] = SKILL_LEVEL_NONE
	var/is_new_skill = !(skill_ref in known_skills)
	if(isnull(old_level) && !is_new_skill)
		old_level = SKILL_LEVEL_NONE
	if((isnull(old_level) && is_new_skill) || known_skills[skill_ref] == old_level)
		return
	if(silent)
		return
	if(known_skills[skill_ref] >= old_level)
		SEND_SIGNAL(current, COMSIG_SKILL_RANK_INCREASED, skill_ref, known_skills[skill_ref], old_level)
		to_chat(current, span_nicegreen("I feel like I've become more proficient at [skill_ref.name]!"))
		record_round_statistic(STATS_SKILLS_LEARNED)
		if(istype(skill_ref, /datum/skill/combat))
			record_round_statistic(STATS_COMBAT_SKILLS)
		if(istype(skill_ref, /datum/skill/craft))
			record_round_statistic(STATS_CRAFT_SKILLS)
		if(skill == /datum/skill/misc/reading && old_level == SKILL_LEVEL_NONE && current.is_literate())
			record_round_statistic(STATS_LITERACY_TAUGHT)
	else
		to_chat(current, span_warning("I feel like I've become worse at [skill_ref.name]!"))

	if(ishuman(current))
		var/mob/living/carbon/human/H = current
		if(H.adaptive_name)
			var/str
			var/list/jobnames = list()
			for(var/skillt in SSskills.all_skills)
				var/datum/skill/sk = GetSkillRef(skillt)
				if(current.get_skill_level(sk.type) >= SKILL_LEVEL_EXPERT)
					jobnames.Add(initial(sk.expert_name))
			if(length(jobnames))
				if(length(jobnames) == 1)
					current.advjob = jobnames[1]
				else
					for(var/i in 1 to length(jobnames))
						if(i == 1)
							str += "[jobnames[i]]"
						else
							str += "-[jobnames[i]]"
					current.advjob = str

/datum/skill_holder/proc/get_skill_speed_modifier(skill)
	var/datum/skill/S = GetSkillRef(skill)
	return S.get_skill_speed_modifier(known_skills[S] || SKILL_LEVEL_NONE)

/datum/skill_holder/proc/get_skill_level(skill)
	var/datum/skill/S = GetSkillRef(skill)
	var/modifier = 0
	if(S?.abstract_type in list(/datum/skill/labor, /datum/skill/craft))
		modifier = current?.get_inspirational_bonus()
	if(!(S in known_skills))
		return SKILL_LEVEL_NONE
	return known_skills[S] + modifier || SKILL_LEVEL_NONE

/datum/skill_holder/proc/print_levels(user)
	var/list/shown_skills = list()
	for(var/i in known_skills)
		if(known_skills[i]) //Do we actually have a level in this?
			shown_skills += i
	if(!length(shown_skills))
		to_chat(user, span_warning("I don't have any skills."))
		return
	var/msg = ""
	msg += span_info("*---------*\n")
	var/list/sorted_skills = sortList(shown_skills, GLOBAL_PROC_REF(cmp_skills_for_display))
	for(var/datum/skill/i in sorted_skills)
		var/can_advance_post = current?.mind?.sleep_adv.enough_sleep_xp_to_advance(i.type, 1)
		var/capped_post = current?.mind?.sleep_adv.enough_sleep_xp_to_advance(i.type, 2)
		var/rankup_postfix = capped_post ? span_nicegreen(" ★ ") : can_advance_post ? span_nicegreen(" ☆ ") : ""
		var/skill_name = "<span style='color: [i.color]'>[i]</span>"
		msg += "[skill_name] - [SSskills.level_names[known_skills[i]]][rankup_postfix] <a href='?src=[REF(i)];skill_detail=1' style='font-size: 0.5em;'>{?}</a>\n"
	msg += "</span>"

	to_chat(user, msg)

/mob/proc/get_inspirational_bonus()
	return 0

/mob/living/carbon/get_inspirational_bonus()
	var/bonus = 0
	for(var/event_type in stressors)
		var/datum/stressevent/event = stressors[event_type]
		bonus += event.quality_modifier
	return bonus
