/datum/round_event_control/antagonist/solo/renegade
	name = "Renegades"
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_RENEGADE
	shared_occurence_type = SHARED_HIGH_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_rumour_name = "renegades"

	maximum_antags = 0
	max_occurrences = 1

	earliest_start = 0 SECONDS

	antag_datum = /datum/antagonist/renegade

	restricted_roles = RENEGADE_BLACKLISTED_ROLES

/datum/round_event_control/antagonist/solo/renegade/preRunEvent()
	if(is_storyteller_villain_blocked())
		return EVENT_CANT_RUN
	return ..()

/datum/round_event_control/antagonist/solo/renegade/get_antag_amount()
	var/admin_slot = SSgamemode.get_admin_slot(antag_datum, storyteller_slot_key)
	if(!isnull(admin_slot))
		return max(0, admin_slot)
	return SSgamemode.story_antag_slot_cap(antag_datum, roundstart = roundstart)

/proc/renegade_midround()
	var/datum/storyteller/preset = active_preset()
	if(!preset?.allow_renegade || SSgamemode.halted_storyteller)
		log_storyteller("Renegade midround check skipped under preset [preset?.name || "none"].")
		return
	var/list/candidates = SSgamemode.get_candidates(ROLE_RENEGADE, ROLE_RENEGADE, FALSE, FALSE, TRUE, midround_antag_pref = TRUE, restricted_roles = RENEGADE_BLACKLISTED_ROLES)
	for(var/mob/living/carbon/human/H in candidates)
		if(H.stat == DEAD || H.advsetup || H.client?.is_afk() || is_banned_from(H.ckey, list(ROLE_SYNDICATE, ROLE_RENEGADE)))
			candidates -= H
	if(!length(candidates))
		log_storyteller("Renegade midround check found no valid candidates.")
		return
	for(var/i in 1 to min(RENEGADE_MIDROUND_COUNT, length(candidates)))
		var/mob/living/carbon/human/H = pick_n_take(candidates)
		H.mind.add_antag_datum(/datum/antagonist/renegade)
		message_admins("STORYTELLER: [ADMIN_LOOKUPFLW(H)] was made a midround Renegade.")
		log_storyteller("Renegade midround check made [key_name(H)] a Renegade.")
