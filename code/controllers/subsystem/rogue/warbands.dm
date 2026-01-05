SUBSYSTEM_DEF(warbands)
	name = "warbands"
	wait = 20
	flags = SS_NO_FIRE
	priority = 10
	var/list/warband_managers = list()
	var/list/warband_machines = list()
	var/warband_managers_busy = FALSE	// prevents multiple warbands from being loaded in at once | necessary, as warband_ID assignments for objects will expect this to be the case
	var/atom/movable/screen/warband/manager/roundstart_manager
	var/roundstart_manager_claimed = FALSE

	var/list/treaties = list()
	var/list/submitted_treaties = list()
	var/territory = list()
	var/territory_factions = list()

	// list of associated faction names & jobs
	var/list/name_to_faction_cache = list() 	 
	var/list/job_to_faction_cache = list()

/datum/controller/subsystem/warbands/New()
	..()
	for(var/territory_path in DEFAULT_TERRITORY)
		territory += new territory_path
	for(var/territory_faction_path in DEFAULT_TERRITORY_FACTIONS)
		territory_factions += new territory_faction_path
	create_name_cache()

	roundstart_manager = new /atom/movable/screen/warband/manager(FALSE)
	roundstart_manager.warband_ID = 1
	warband_managers += roundstart_manager

/datum/controller/subsystem/warbands/proc/create_name_cache()
	for(var/datum/territory_faction/faction in territory_factions)
		if(faction.owner)
			name_to_faction_cache[faction.owner] = faction
		if(faction.job_owner)
			job_to_faction_cache[faction.job_owner] = faction


