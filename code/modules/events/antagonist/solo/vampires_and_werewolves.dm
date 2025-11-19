/datum/round_event_control/antagonist/solo/vampires_and_werewolves
	name = "Vampires and Verevolves"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_NBEAST
	shared_occurence_type = SHARED_HIGH_THREAT
	denominator = 80

	base_antags = 2
	maximum_antags = 4

	earliest_start = 0 SECONDS

	weight = 1		//Disabled cus vampires too strong.
	max_occurrences = 1

	typepath = /datum/round_event/antagonist/solo/vampires_and_werewolves

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event/antagonist/solo/vampires_and_werewolves
	var/leader = FALSE

/datum/round_event/antagonist/solo/vampires_and_werewolves/start()
	var/vampire = FALSE
	for(var/datum/mind/antag_mind as anything in setup_minds)
		if(vampire)
			add_vampire(antag_mind)
		else
			add_werewolf(antag_mind, antag_mind.current)
		vampire = !vampire

/datum/round_event/antagonist/solo/vampires_and_werewolves/proc/add_werewolf(datum/mind/antag_mind)
	antag_mind.add_antag_datum(/datum/antagonist/werewolf)

/datum/round_event/antagonist/solo/vampires_and_werewolves/proc/add_vampire(datum/mind/antag_mind)
	if(!leader)
		var/datum/job/J = SSjob.GetJob(antag_mind.current?.job)
		J?.current_positions = max(J?.current_positions-1, 0)
		antag_mind.current.unequip_everything()
		antag_mind.add_antag_datum(antag_datum)
		leader = TRUE
		return
	else
		if(!antag_mind.has_antag_datum(/datum/antagonist/vampire))
			var/datum/job/J = SSjob.GetJob(antag_mind.current?.job)
			J?.current_positions = max(J?.current_positions-1, 0)
			antag_mind.current.unequip_everything()
			antag_mind.add_antag_datum(/datum/antagonist/vampire)
		return
