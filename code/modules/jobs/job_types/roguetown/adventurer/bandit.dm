/datum/job/roguetown/bandit //pysdon above there's like THREE bandit.dms now I'm so sorry. This one is latejoin bandits, the one in villain is the antag datum, and the one in the 'antag' folder is an old adventurer class we don't use. Good luck!
	title = "Bandit"
	flag = BANDIT
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	antag_job = TRUE
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN
	storyteller_favor_flags = STORYTELLER_FAVOR_BANDIT
	storyteller_guarantee_flags = STORYTELLER_FAVOR_BANDIT
	allowed_races = RACES_ALL_KINDS
	tutorial = "Long ago you did a crime worthy of your bounty being hung on the wall outside of the local inn. You now live with your fellow freemen in the bog, and generally get up to no good."

	outfit = null
	outfit_female = null

	obsfuscated_job = TRUE

	display_order = JDO_BANDIT
	announce_latejoin = FALSE
	min_pq = 3
	max_pq = null
	round_contrib_points = 5

	advclass_cat_rolls = list(CTAG_BANDIT = 20)
	PQ_boost_divider = 10

	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE //no endless stream of bandits, unless the migration waves deem it so
	job_traits = list(TRAIT_SELF_SUSTENANCE, TRAIT_STEELHEARTED)//Bandits and knaves truly though
	vice_restrictions = list(/datum/charflaw/noeyer, /datum/charflaw/noeyel, /datum/charflaw/mute, /datum/charflaw/limbloss/arm_r, /datum/charflaw/limbloss/arm_l)
	same_job_respawn_delay = 1 MINUTES
	cmode_music = 'sound/music/cmode/antag/combat_deadlyshadows.ogg'
	job_subclasses = list(
		/datum/advclass/brigand,
		/datum/advclass/hedgealchemist,
		/datum/advclass/hedgeknight,
		/datum/advclass/hedgemage,
		/datum/advclass/iconoclast,
		/datum/advclass/knave,
		/datum/advclass/sellsword
	)

/datum/job/roguetown/bandit/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		if(!H.mind)
			return
		H.ambushable = FALSE

/datum/outfit/job/roguetown/bandit/pre_equip(mob/living/carbon/human/H)
	. = ..()
	H.verbs |= /mob/proc/haltyell_exhausting

/datum/outfit/job/roguetown/bandit/post_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		var/datum/antagonist/new_antag = new /datum/antagonist/bandit()
		H.mind.add_antag_datum(new_antag)
		H.grant_language(/datum/language/thievescant)
		addtimer(CALLBACK(H, TYPE_PROC_REF(/mob/living/carbon/human, choose_name_popup), "BANDIT"), 5 SECONDS)
		var/wanted = list("I am a notorious criminal", "I am a nobody")
		var/wanted_choice = input("Are you a known criminal?") as anything in wanted
		switch(wanted_choice)
			if("I am a notorious criminal") //Extra challenge for those who want it
				bandit_select_bounty(H)
				ADD_TRAIT(H, TRAIT_KNOWNCRIMINAL, TRAIT_GENERIC)
			if("I am a nobody") //Nothing ever happens
				return

// Changed up proc from Wretch to suit bandits bit more
/proc/bandit_select_bounty(mob/living/carbon/human/H)
	var/datum/preferences/P = H?.client?.prefs

	var/bounty_poster_key
	var/bounty_severity_key
	var/my_crime

	if(P?.preset_bounty_enabled)
		bounty_poster_key = P.preset_bounty_poster_key
		bounty_severity_key = P.preset_bounty_severity_b_key
		my_crime = P.preset_bounty_crime

	if(bounty_poster_key && !GLOB.bounty_posters[bounty_poster_key])
		bounty_poster_key = null

	if(bounty_severity_key && !GLOB.bandit_bounty_severities[bounty_severity_key])
		bounty_severity_key = null
	if(!bounty_poster_key)
		var/list/poster_choices = list()
		for(var/key in GLOB.bounty_posters)
			poster_choices[GLOB.bounty_posters[key]] = key
		var/choice = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in poster_choices
		bounty_poster_key = poster_choices[choice]

	if(!bounty_severity_key)
		var/list/sev_choices = list()
		for(var/key in GLOB.bandit_bounty_severities)
			sev_choices[GLOB.bandit_bounty_severities[key]["name"]] = key
		var/choice = input(H, "How notorious are you?", "Bounty Amount") as anything in sev_choices
		bounty_severity_key = sev_choices[choice]
	var/bounty_poster = GLOB.bounty_posters[bounty_poster_key]

	var/list/sev_data = GLOB.bandit_bounty_severities[bounty_severity_key]
	var/bounty_total = rand(sev_data["min"], sev_data["max"])

	if(!my_crime)
		my_crime = input(H, "What is your crime?", "Crime") as text|null
	if(!my_crime)
		my_crime = "Brigandry"

	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()

	var/descriptor_height = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%")
	var/descriptor_body = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%")
	var/descriptor_voice = build_coalesce_description_nofluff(d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%")

	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)

/proc/calculate_bandit_scaling(override_player_count)
	var/list/result = list()
	var/player_count = isnull(override_player_count) ? SSgamemode.get_correct_popcount() : override_player_count
	result["player_count"] = player_count
	var/datum/job/bandit_job = SSjob.GetJob("Bandit")
	var/roundstart = !(SSticker?.HasRoundStarted())
	if(SSgamemode.storyteller_blocks_antag(bandit_job?.storyteller_antag_flags, roundstart, storyteller_midround_antag_flags = bandit_job?.storyteller_midround_antag_flags) || SSgamemode.storyteller_blocks_type(bandit_job?.storyteller_favor_flags, roundstart = roundstart))
		result["max_slots"] = 0
		result["final_slots"] = 0
		return result
	if(!SSgamemode.storyteller_unlocks_scaled_antag_slots(/datum/antagonist/bandit))
		result["max_slots"] = 0
		result["final_slots"] = 0
		return result
	if(!SSgamemode.picked_open_slots(/datum/antagonist/bandit))
		result["max_slots"] = 0
		result["final_slots"] = 0
		return result

	var/max_slots = SSgamemode.story_antag_slot_cap(/datum/antagonist/bandit, roundstart)
	result["max_slots"] = max_slots
	if(max_slots <= 0)
		result["final_slots"] = 0
		return result

	result["garrison"] = SSgamemode.garrison
	result["holy_warrior"] = SSgamemode.holy_warrior
	result["acolyte"] = SSgamemode.half_combatant
	result["combat_total"] = SSgamemode.story_combat_pop()
	result["final_slots"] = SSgamemode.story_antag_slots(SSgamemode.storyteller_scale_slots(max_slots, player_count, TRUE, SSgamemode.story_antag_scaling_step(/datum/antagonist/bandit), SSgamemode.story_antag_min_players(/datum/antagonist/bandit)), /datum/antagonist/bandit, player_count)
	return result

/proc/update_bandit_slots(override_player_count)
	var/datum/job/bandit_job = SSjob.GetJob("Bandit")
	if(!bandit_job)
		return
	var/list/scaling = calculate_bandit_scaling(override_player_count)
	var/player_count = scaling["player_count"]
	var/slots = max(0, scaling["final_slots"])
	var/old_total = bandit_job.total_positions
	var/final_slots = max(bandit_job.current_positions, slots)
	bandit_job.total_positions = final_slots
	bandit_job.spawn_positions = final_slots
	SSgamemode.log_antag_slot_scaling("Bandits", old_total, final_slots, player_count, SSticker?.HasRoundStarted() ? "live slot update" : "roundstart slot update")
	if(final_slots > 0)
		SSrole_class_handler.bandits_in_round = TRUE
	if(!SSticker?.HasRoundStarted() || final_slots <= old_total)
		return
	var/slot_gain = final_slots - old_total
	SSmapping.retainer.bandit_goal += slot_gain * rand(200, 400)
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		if(player.client)
			to_chat(player, span_danger("Bandits flock to Azuria. [slot_gain] bandit slots have opened."))

