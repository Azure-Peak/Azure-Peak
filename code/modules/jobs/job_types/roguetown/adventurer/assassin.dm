/datum/job/roguetown/assassin
	title = "Assassin"
	flag = ASSASSIN
	department_flag = ANTAGONIST
	selection_color = JCOLOR_ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = 10		// was going to put this higher but realized bandit's only 3 pq and wretch is fucking 10 so whatever
	max_pq = null
	antag_job = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_SOFT
	storyteller_favor_flags = STORYTELLER_FAVOR_ASSASSIN
	allowed_races = RACES_ALL_KINDS
	tutorial = "Long ago you did a crime worthy of your bounty being hung on the wall outside of the local inn. You now live with your fellow freemen in the bog, and generally get up to no good."

	outfit = null
	outfit_female = null

	obsfuscated_job = TRUE
	give_bank_account = FALSE

	display_order = JDO_ASSASSIN
	announce_latejoin = FALSE
	round_contrib_points = 5

	advclass_cat_rolls = list(CTAG_ASSASSIN = 20)
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	advjob_examine = FALSE	//We don't want anyone knowing what type of assassin you are.
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE

	// Base job traits, we give one-specialty trait per role.
	job_traits = list(
		TRAIT_ASSASSIN,
		TRAIT_DODGEEXPERT,
		TRAIT_STEELHEARTED,
		TRAIT_HERESIARCH,	//Just so they can use the Zurch.
		TRAIT_ANTISCRYING,
	)
	cmode_music = 'sound/music/cmode/antag/combat_assassin.ogg'
	// Choices between: Ranged build, pioson knife-fighter w/ poison knife, garrote user/kidnapper build 
	job_subclasses = list(
		/datum/advclass/assassin_ranger,
		/datum/advclass/assassin_poisoner,
		/datum/advclass/assassin_hitman,
	)

/proc/calculate_assassin_scaling(override_player_count)
	var/list/result = list()
	var/player_count = override_player_count || length(GLOB.joined_player_list)
	result["player_count"] = player_count
	var/datum/job/assassin_job = SSjob.GetJob("Assassin")
	var/roundstart = !(SSticker?.HasRoundStarted())
	if(SSgamemode.storyteller_blocks_antag(assassin_job?.storyteller_antag_flags, roundstart, storyteller_midround_antag_flags = assassin_job?.storyteller_midround_antag_flags) || SSgamemode.storyteller_blocks_type(assassin_job?.storyteller_favor_flags, roundstart = roundstart))
		result["max_slots"] = 0
		result["final_slots"] = 0
		return result
	if(!SSgamemode.storyteller_unlocks_scaled_antag_slots(/datum/antagonist/assassin))
		result["max_slots"] = 0
		result["final_slots"] = 0
		return result

	var/max_slots = SSgamemode.story_antag_slot_cap(/datum/antagonist/assassin, roundstart)
	result["max_slots"] = max_slots
	result["garrison"] = SSgamemode.garrison
	result["holy_warrior"] = SSgamemode.holy_warrior
	result["acolyte"] = SSgamemode.half_combatant
	result["combat_total"] = SSgamemode.story_combat_pop()
	result["final_slots"] = SSgamemode.story_antag_slots(SSgamemode.storyteller_scale_slots(max_slots, player_count, TRUE, SSgamemode.story_antag_scaling_step(/datum/antagonist/assassin), SSgamemode.story_antag_min_players(/datum/antagonist/assassin)), /datum/antagonist/assassin, player_count)
	return result

/proc/assassinslot_update(player_count = null)
	var/datum/job/assassin_job = SSjob.GetJob("Assassin")
	if(!assassin_job)
		return
	var/list/scaling = calculate_assassin_scaling(player_count)
	var/scaled_player_count = scaling["player_count"]
	var/slots = max(0, scaling["final_slots"])
	var/old_total = assassin_job.total_positions
	assassin_job.total_positions = max(assassin_job.current_positions, slots)
	assassin_job.spawn_positions = max(assassin_job.current_positions, slots)
	SSgamemode.log_antag_slot_scaling("Assassins", old_total, assassin_job.total_positions, scaled_player_count, SSticker?.HasRoundStarted() ? "live slot update" : "roundstart slot update")

/datum/job/roguetown/assassin/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return
		H.ambushable = FALSE

/datum/outfit/job/roguetown/assassin/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/assassin()
		H.mind.add_antag_datum(new_antag)
		H.grant_language(/datum/language/thievescant)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "ASSASSIN"), 5 SECONDS)
		var/wanted = list("I am a notorious criminal", "I am a nobody")
		var/wanted_choice = input("Are you a known criminal?") as anything in wanted
		switch(wanted_choice)
			if("I am a notorious criminal") //Extra challenge for those who want it
				bandit_select_bounty(H)
				ADD_TRAIT(H, TRAIT_KNOWNCRIMINAL, TRAIT_GENERIC)
			if("I am a nobody") //Nothing ever happens
				return
