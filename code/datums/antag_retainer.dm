///this is basically a datum that stores all antags in them it also lets us interact easily with antags through events
/datum/antag_retainer
	//Major antag types
	var/list/vampires = list()
	var/list/death_knights = list()
	var/list/werewolves = list()
	var/list/liches = list()
	var/list/bandits = list()
	var/list/dreamwalkers = list()

	//Minor antag types
	var/list/wretches = list()
	var/list/aspirants = list()
	var/list/assassins = list()

	var/head_rebel_decree = FALSE

	///vampire stuff
	var/mob/living/carbon/human/vampire_lord
	var/king_submitted = FALSE
	var/ascended = FALSE

	///delf stuff
	var/delf_contribute = 0
	var/delf_goal = 1

	///bandit stuff
	var/bandit_goal = 1
	var/bandit_contribute = 0

/proc/vampire_werewolf()
	var/vampyr = 0
	var/wwoelf = 0
	for(var/mob/living/carbon/human/player in GLOB.human_list)
		if(player.mind)
			if(player.stat != DEAD)
				if(isbrain(player)) //also technically dead
					continue
				if(is_in_roguetown(player))
					var/datum/antagonist/D = player.mind.has_antag_datum(/datum/antagonist/werewolf)
					if(D && D.increase_votepwr)
						wwoelf++
						continue
					D = player.mind.has_antag_datum(/datum/antagonist/vampire)
					if(D && D.increase_votepwr)
						vampyr++
						continue
	if(vampyr)
		if(!wwoelf)
			return "vampire"
	if(wwoelf)
		if(!vampyr)
			return "werewolf"

/proc/check_for_lord(forced = FALSE)
	if(!forced && (world.time < SSticker.next_lord_check))
		return
	SSticker.next_lord_check = world.time + 1 MINUTES
	var/mob/living/ruler = SSticker.rulermob
	if(!ruler || ruler.stat == DEAD)
		if(!SSticker.missing_lord_time)
			SSticker.missing_lord_time = world.time
		if(world.time > SSticker.missing_lord_time + 10 MINUTES)
			SSticker.missing_lord_time = world.time
			addomen(OMEN_NOLORD)
		return FALSE
	else
		return TRUE

/proc/age_check(client/C)
	if(get_remaining_days(C) == 0)
		return 1	//Available in 0 days = available right now = player is old enough to play.
	return 0

/proc/get_remaining_days(client/C)
	if(!C)
		return 0
	if(!CONFIG_GET(flag/use_age_restriction_for_jobs))
		return 0
	if(!isnum(C.player_age))
		return 0 //This is only a number if the db connection is established, otherwise it is text: "Requires database", meaning these restrictions cannot be enforced
	if(!isnum(0))
		return 0

	return max(0, 0 - C.player_age)


/proc/select_omen_event() // There's probably a better place I could've put this. Too bad!
	// Check for all existing omen events
	var/list/candidates = list()
	for(var/datum/round_event_control/E in SSevents.control)
		if(E.track == EVENT_TRACK_OMENS)
			candidates += E
	// None exist
	if(!length(candidates))
		return null

	// Use var/weight to roll for which event in the list should launch. Probably a little better than just rand(0, length(candidates))
	var/total_weight = 0
	for(var/datum/round_event_control/E in candidates)
		total_weight += max(1, E.weight)

	var/roll = rand(1, total_weight)
	var/acc = 0
	for(var/datum/round_event_control/E in candidates)
		acc += max(1, E.weight)
		if(roll <= acc)
			return E

/proc/launch_omen_event()
	// Pick an omen event
	var/datum/round_event_control/E = select_omen_event()
	if(!E)
		return

	// Force it to launch. We don't care about the storyteller requirements.
	E.req_omen = FALSE
	E.earliest_start = 0
	E.min_players = 0
	E.runEvent()
