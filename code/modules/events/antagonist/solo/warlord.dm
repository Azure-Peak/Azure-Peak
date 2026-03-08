/datum/round_event_control/antagonist/solo/warlord
	name = "Warlord"
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
		TAG_WAR
	)
	roundstart = TRUE
	antag_flag = ROLE_WARLORD
	shared_occurence_type = SHARED_HIGH_THREAT
	earliest_start = 0 SECONDS

	denominator = 80
	base_antags = 5
	maximum_antags = 9
	max_occurrences = 1
	weight = 2

	min_players = 40	
	required_enemies = 25
	enemy_roles = list("Man at Arms", 
	"Sergeant",
	"Knight",
	"Captain",
	"Squire",
	"Marshal",
	"Court Magician",
	"Warden",
	"Court Agent",
	"Veteran",
	"Templar",
	"Martyr",
	"Mercenary",
	"Adventurer")

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES
	typepath = /datum/round_event/antagonist/solo/warlord
	antag_datum = /datum/antagonist/warlord


/datum/round_event/antagonist/solo/warlord
	var/datum/mind/warlord_mind
	var/list/lieutenant_minds = list()
	var/list/grunt_minds = list()

/datum/round_event/antagonist/solo/warlord/start()
	if(!setup_minds.len)
		return

	setup_minds = shuffle(setup_minds)
	var/turf/spawn_loc
	for(var/obj/effect/landmark/start/warlord/the_box in GLOB.landmarks_list)
		spawn_loc = get_turf(the_box)
		break

	warlord_mind = setup_minds[1]
	if(setup_minds.len >= 2)
		lieutenant_minds += setup_minds[2]
	if(setup_minds.len >= 3)
		grunt_minds += setup_minds[3]
	if(setup_minds.len >= 4)
		for(var/i in 4 to min(setup_minds.len, 9))
			if(i % 2 == 0)
				lieutenant_minds += setup_minds[i]
			else
				grunt_minds += setup_minds[i]

	// Spawn everyone
	if(warlord_mind?.current)
		process_candidate(warlord_mind, "Warlord", /datum/antagonist/warlord, spawn_loc)
	var/lt_num = 1
	for(var/datum/mind/lt_mind in lieutenant_minds)
		if(lt_mind.current)
			process_candidate(lt_mind, "Lieutenant", /datum/antagonist/warlord_lieutenant, spawn_loc, lt_num++)
	var/grunt_num = 1
	for(var/datum/mind/grunt_mind in grunt_minds)
		if(grunt_mind.current)
			process_candidate(grunt_mind, "Grunt", /datum/antagonist/warlord_grunt, spawn_loc, grunt_num++)


/datum/round_event/antagonist/solo/warlord/proc/process_candidate(datum/mind/target_mind, role_name, datum_path, turf/loc, unique_number = 0)
	target_mind.current.loc = loc // send them to The Box
	var/datum/job/J = SSjob.GetJob(target_mind.current.job)
	J?.current_positions = max(J?.current_positions-1, 0)
	SSjob.AssignRole(target_mind.current, role_name)
	target_mind.add_antag_datum(datum_path)
	if(unique_number)
		var/datum/antagonist/warlord_unit = target_mind.has_antag_datum(datum_path)
		if(warlord_unit)
			warlord_unit.unique_number = unique_number
