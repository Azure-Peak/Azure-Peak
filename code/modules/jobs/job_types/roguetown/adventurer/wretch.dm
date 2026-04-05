// Wretch, soft antagonists. Giving them 9 points as stat (matching mercs) on average since they're a driving antagonist on AP or assistant antagonist. 
/datum/job/roguetown/wretch
	title = "Wretch"
	flag = WRETCH
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	allowed_races = RACES_ALL_KINDS
	tutorial = "Somewhere in your lyfe, you fell to the wrong side of civilization. Hounded by the consequences of your actions, you spend your daes prowling the roads for easy marks and loose purses, scraping to get by."
	outfit = null
	outfit_female = null
	display_order = JDO_WRETCH
	show_in_credits = FALSE
	min_pq = 10
	max_pq = null

	obsfuscated_job = TRUE
	class_categories = TRUE

	advclass_cat_rolls = list(CTAG_WRETCH = 20)
	PQ_boost_divider = 10
	round_contrib_points = 2

	announce_latejoin = FALSE
	wanderer_examine = TRUE
	advjob_examine = TRUE
	always_show_on_latechoices = TRUE
	job_reopens_slots_on_death = FALSE
	same_job_respawn_delay = 1 MINUTES
	virtue_restrictions = list(/datum/virtue/heretic/zchurch_keyholder) //all wretch classes automatically get this
	job_traits = list(TRAIT_STEELHEARTED, TRAIT_OUTLAW, TRAIT_HERESIARCH, TRAIT_SELF_SUSTENANCE, TRAIT_ZURCH)
	job_subclasses = list(
		/datum/advclass/wretch/licker,
		/datum/advclass/wretch/deserter,
		/datum/advclass/wretch/deserter/generic,
		/datum/advclass/wretch/berserker,
		/datum/advclass/wretch/roguemage,
		/datum/advclass/wretch/necromancer,
		/datum/advclass/wretch/heretic,
		/datum/advclass/wretch/heretic/spy,
		/datum/advclass/wretch/outlaw,
		/datum/advclass/wretch/poacher,
		/datum/advclass/wretch/plaguebearer,
		/datum/advclass/wretch/mistwalker,
		/datum/advclass/wretch/pyromaniac,
		/datum/advclass/wretch/vigilante,
		/datum/advclass/wretch/munitioneer,
		/datum/advclass/wretch/pariah,
		/datum/advclass/wretch/heretic_spellblade,
		/datum/advclass/wretch/ancient_spellblade,
		/datum/advclass/wretch/ancient_deathknight,
		/datum/advclass/wretch/slasher
	)

/datum/job/roguetown/wretch/special_job_check(mob/dead/new_player/player)
	if(is_storyteller_soft_antag_blocked())
		return FALSE
	return ..()

/datum/job/roguetown/wretch/special_check_latejoin(client/C)
	if(is_storyteller_soft_antag_blocked())
		return FALSE
	return ..()

/datum/job/roguetown/wretch/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		// Assign wretch antagonist datum so wretches appear in antag list
		if(H.mind && !H.mind.has_antag_datum(/datum/antagonist/wretch))
			var/datum/antagonist/new_antag = new /datum/antagonist/wretch()
			H.mind.add_antag_datum(new_antag)

/datum/job/roguetown/wretch/on_round_removal(mob/M)
	// Respawn delay applies immediately
	if(same_job_respawn_delay && M.ckey)
		GLOB.job_respawn_delays[M.ckey] = world.time + same_job_respawn_delay
	// Delayed slot reopen after 1 hour — subclass always reopens, global slot only if garrison criteria met
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(wretch_delayed_slot_reopen), M.advjob), 1 HOURS)

// Proc for wretch to select a bounty
/proc/wretch_select_bounty(mob/living/carbon/human/H)
	var/datum/preferences/P = H?.client?.prefs
	var/bounty_poster_key
	var/bounty_severity_key
	var/my_crime

	if(P?.preset_bounty_enabled)
		bounty_poster_key = P.preset_bounty_poster_key
		bounty_severity_key = P.preset_bounty_severity_key
		my_crime = P.preset_bounty_crime

	if(bounty_poster_key && !GLOB.bounty_posters[bounty_poster_key])
		bounty_poster_key = null

	if(bounty_severity_key && !GLOB.wretch_bounty_severities[bounty_severity_key])
		bounty_severity_key = null

	if(!bounty_poster_key)
		var/list/poster_choices = list()
		for(var/key in GLOB.bounty_posters)
			poster_choices[GLOB.bounty_posters[key]] = key
		var/choice = input(H, "Who placed a bounty on you?", "Bounty Poster") as anything in poster_choices
		bounty_poster_key = poster_choices[choice]

	if(!bounty_severity_key)
		var/list/sev_choices = list()
		for(var/key in GLOB.wretch_bounty_severities)
			sev_choices[GLOB.wretch_bounty_severities[key]["name"]] = key
		var/choice = input(H, "How severe are your crimes?", "Bounty Amount") as anything in sev_choices
		bounty_severity_key = sev_choices[choice]

	var/bounty_poster = GLOB.bounty_posters[bounty_poster_key]

	var/list/sev_data = GLOB.wretch_bounty_severities[bounty_severity_key]
	var/bounty_total = rand(sev_data["min"], sev_data["max"])
	if(bounty_severity_key == "ATROCITY")
		if(bounty_poster_key == "AZURIA")
			GLOB.outlawed_players += H.real_name
		else
			GLOB.excommunicated_players += H.real_name
	if(!my_crime)
		my_crime = input(H, "What is your crime?", "Crime") as text|null
	if(!my_crime)
		my_crime = "crimes against the Crown"

	var/race = H.dna.species
	var/gender = H.gender
	var/list/d_list = H.get_mob_descriptors()

	var/descriptor_height = build_coalesce_description_nofluff(
		d_list, H, list(MOB_DESCRIPTOR_SLOT_HEIGHT), "%DESC1%"
	)
	var/descriptor_body = build_coalesce_description_nofluff(
		d_list, H, list(MOB_DESCRIPTOR_SLOT_BODY), "%DESC1%"
	)
	var/descriptor_voice = build_coalesce_description_nofluff(
		d_list, H, list(MOB_DESCRIPTOR_SLOT_VOICE), "%DESC1%"
	)
	add_bounty(H.real_name, race, gender, descriptor_height, descriptor_body, descriptor_voice, bounty_total, FALSE, my_crime, bounty_poster)
	to_chat(H, span_danger("You are playing an Antagonist role. By choosing to spawn as a Wretch, you are expected to actively create conflict with other players. Failing to play this role with the appropriate gravitas may result in punishment for Low Roleplay standards."))

/// Returns an assoc list with all intermediate wretch scaling values for admin display.
/// If override_player_count is provided (e.g. from readied player count at roundstart), use that instead of the live joined list.
/proc/calculate_wretch_scaling(override_player_count)
	var/list/result = list()
	var/player_count = override_player_count || length(GLOB.joined_player_list)
	result["player_count"] = player_count
	if(is_storyteller_soft_antag_blocked())
		result["tier1_slots"] = 0
		result["major_antag_active"] = FALSE
		result["garrison"] = SSgamemode.garrison
		result["holy_warrior"] = SSgamemode.holy_warrior
		result["acolyte"] = SSgamemode.half_combatant
		result["combat_total"] = SSgamemode.garrison + SSgamemode.holy_warrior + FLOOR(SSgamemode.half_combatant * 0.5, 1)
		result["tier2_extra"] = 0
		result["final_slots"] = 0
		return result

	// Tier 1: Population scaling, +1 per 10 players above 40, max 10
	var/slots = 5
	if(player_count > 40)
		slots += floor((player_count - 40) / 10)
	slots = min(slots, 10)
	result["tier1_slots"] = slots

	// Check for major round antagonists (lich, vampire lord) — hard cap at tier 1
	var/major_antag_active = FALSE
	for(var/datum/antagonist/antag as anything in GLOB.antagonists)
		if(QDELETED(antag) || QDELETED(antag.owner))
			continue
		if(istype(antag, /datum/antagonist/lich) || istype(antag, /datum/antagonist/vampire/lord))
			major_antag_active = TRUE
			break
	result["major_antag_active"] = major_antag_active

	// Tier 2: Garrison-gated expansion from 10 to 15
	var/garrison_count = SSgamemode.garrison
	var/holy_count = SSgamemode.holy_warrior
	var/acolyte_count = SSgamemode.half_combatant
	var/combat_count = garrison_count + holy_count + FLOOR(acolyte_count * 0.5, 1)
	result["garrison"] = garrison_count
	result["holy_warrior"] = holy_count
	result["acolyte"] = acolyte_count
	result["combat_total"] = combat_count

	var/tier2_max = 0
	if(slots >= 10 && !major_antag_active)
		tier2_max = min(max(0, combat_count - 10), 5)
		slots += tier2_max
	result["tier2_extra"] = tier2_max
	result["final_slots"] = max(0, slots)

	return result

/proc/update_wretch_slots(override_player_count)
	var/datum/job/wretch_job = SSjob.GetJob("Wretch")
	if(!wretch_job)
		return
	var/list/scaling = calculate_wretch_scaling(override_player_count)
	var/slots = max(0, scaling["final_slots"])
	// Never reduce below current occupancy
	wretch_job.total_positions = max(wretch_job.current_positions, slots)
	wretch_job.spawn_positions = max(wretch_job.current_positions, slots)

/// Called after 1 hour delay when a wretch leaves the round.
/// Always reopens the subclass slot. Only reopens the global slot if garrison criteria make sense.
/proc/wretch_delayed_slot_reopen(advclass_name)
	// Always reopen the subclass slot
	if(advclass_name)
		var/datum/advclass/target_class = SSrole_class_handler.get_advclass_by_name(advclass_name)
		if(target_class)
			SSrole_class_handler.adjust_class_amount(target_class, -1)

	var/datum/job/wretch_job = SSjob.GetJob("Wretch")
	if(!wretch_job)
		return
	wretch_job.current_positions = max(0, wretch_job.current_positions - 1)
	update_scaling_slots()

/// Returns an assoc list with intermediate adventurer scaling values for admin display.
/// If override_player_count is provided (e.g. from readied player count at roundstart), use that instead of the live joined list.
/proc/calculate_adventurer_scaling(override_player_count)
	var/list/result = list()
	var/player_count = override_player_count || length(GLOB.joined_player_list)
	result["player_count"] = player_count

	var/slots = 20
	if(player_count > 70)
		slots += floor((player_count - 70) / 10) * 2
	slots = min(slots, 40)
	result["final_slots"] = slots

	return result

/proc/update_adventurer_slots(override_player_count)
	var/datum/job/adventurer_job = SSjob.GetJob("Adventurer")
	if(!adventurer_job)
		return
	var/list/scaling = calculate_adventurer_scaling(override_player_count)
	var/slots = scaling["final_slots"]
	// Never reduce below current value, so admin-opened slots aren't overwritten.
	adventurer_job.total_positions = max(adventurer_job.total_positions, slots)
	adventurer_job.spawn_positions = max(adventurer_job.spawn_positions, slots)

/// Convenience proc to update both wretch and adventurer scaling in one call.
/proc/update_scaling_slots(override_player_count)
	update_wretch_slots(override_player_count)
	update_adventurer_slots(override_player_count)
