/datum/round_event_control/antagonist/solo/vampires
	name = "Vampire Lord"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_NBEAST
	shared_occurence_type = SHARED_HIGH_THREAT
	storyteller_antag_flags = STORYTELLER_ANTAG_VILLAIN | STORYTELLER_ANTAG_ROUNDSTART
	storyteller_pill_label = "Vampire Lord"
	storyteller_rumour_name = "lycker lords"

	weight = 9
	max_occurrences = 1

	denominator = 80

	base_antags = 1
	maximum_antags = 1

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/vampire
	antag_datum = /datum/antagonist/vampire

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event_control/antagonist/solo/vampires/preRunEvent()
	if(is_storyteller_villain_blocked())
		return EVENT_CANT_RUN
	return ..()

/datum/round_event/antagonist/solo/vampire
	var/leader = FALSE

/datum/round_event/antagonist/solo/vampire/add_datum_to_mind(datum/mind/antag_mind)
	if(!leader)
		var/datum/job/J = SSjob.GetJob(antag_mind.current?.job)
		J?.current_positions = max(J?.current_positions-1, 0)
		var/datum/antagonist/vampire/lord/lorde = new /datum/antagonist/vampire/lord()
		var/mob/living/carbon/human/H = antag_mind.current
		if(H.client)
			var/datum/class_select_handler/stale = SSrole_class_handler.class_select_handlers[H.client.ckey]
			if(stale)
				SSrole_class_handler.class_select_handlers.Remove(H.client.ckey)
				qdel(stale)
				SSjob.AssignRole(H, "Migrant")
				H.job = "Migrant"
		SSrole_class_handler.setup_class_handler(H, list(CTAG_NO_OUTFIT = 20))
		H.set_advsetup(FALSE)
		H.hud_used?.set_advclass()
		//okay, we're finished w/ clearing away your role, now we make you into VL
		antag_mind.add_antag_datum(lorde)
		leader = TRUE
		return
	else
		if(!antag_mind.has_antag_datum(antag_datum))
			var/datum/job/J = SSjob.GetJob(antag_mind.current?.job)
			J?.current_positions = max(J?.current_positions-1, 0)
			var/datum/antagonist/vampire/servante = new /datum/antagonist/vampire(forced_clan = null, generation = GENERATION_ANCILLAE)
			antag_mind.add_antag_datum(servante)
			return
