//PORT OF https://github.com/BeeStation/BeeStation-Hornet/pull/11210
/*
 *	[What does this do?]
 * 		It supports to make adjustment for each map
 *
 * 	[Why don't you just make this with map json file?]
 * 		Some stuff is easy to mistake.
 * 		Being a part of DM files can make a failsafe.
 *
*/
/datum/map_adjustment
	/// key of map_adjustment. It is used to check if '/datum/map_config/var/map_file' is matched
	var/map_file_name
	/// Name of the realm/location for announcements (e.g., "Azure Peak", "Azure Bleak", etc.)
	var/realm_name = "Azure Peak"
	/// Jobs that this map won't use
	var/list/blacklist
	/// Jobs that have slots changed /datum/job = num
	var/list/slot_adjust
	/// Jobs that have title adjustments. Don't adjust the title title, only display_title /datum/job = list(display_title = "Lord Commander", f_title = "Lady Commander"))
	var/list/title_adjust
	/// Job that have tutorial adjustments /datum/job = list("Good")
	var/list/tutorial_adjust
	/// Jobs that have species adjustments /datum/job = list("humen")
	var/list/species_adjust
	/// Jobs that have gender adjustments /datum/job = list(MALE, FEMALE)
	var/list/sexes_adjust
	/// Jobs that have age adjustments /datum/job = list(AGE_CHILD, AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD, AGE_IMMORTAL)
	var/list/ages_adjust

/// called on map config is loaded.
/// You need to change things manually here.
/datum/map_adjustment/proc/on_mapping_init()
	return

/// called upon job datum creation. Override this proc to change.
/datum/map_adjustment/proc/job_change()
	for(var/job as anything in slot_adjust)
		change_job_position(job, slot_adjust[job])
	for(var/job as anything in blacklist)
		change_job_position(job, 0)
	for(var/job as anything in title_adjust)
		var/datum/job/J = SSjob.GetJobType(job)
		J.display_title = title_adjust[job]["display_title"]
		J.f_title = title_adjust[job]["f_title"]
	for(var/job as anything in tutorial_adjust)
		var/datum/job/J = SSjob.GetJobType(job)
		J?.tutorial = tutorial_adjust[job]
	for(var/job as anything in species_adjust)
		var/datum/job/J = SSjob.GetJobType(job)
		J?.forbidden_races = species_adjust[job]
	for(var/job as anything in sexes_adjust)
		var/datum/job/J = SSjob.GetJobType(job)
		J?.allowed_sexes = sexes_adjust[job]
	for(var/job as anything in ages_adjust)
		var/datum/job/J = SSjob.GetJobType(job)
		J?.allowed_ages = ages_adjust[job]

/**
 * job_type`</datum/job/J>`: Type of the job that's being adjusted \
 * spawn_positions`<number, null>`: Roundstart positions, if null will not be adjusted \
 * total_positions`<number, null>`: Latejoin positions, if null will use spawn_positions
 **/
/datum/map_adjustment/proc/change_job_position(job_type, spawn_positions = null, total_positions = null)
	SHOULD_NOT_OVERRIDE(TRUE) // no reason to override for a new behaviour
	PROTECTED_PROC(TRUE) // no reason to call this outside of /map_adjustment datum. (I didn't add _underbar_ to the proc name because you use this frequently)
	var/datum/job/adjusting_job = SSjob.GetJobType(job_type)
	if(!adjusting_job)
		CRASH("Failed to adjust a job position: [job_type]")
	if(isnull(spawn_positions) && isnull(total_positions))
		CRASH("called without any positions to set")

	if(isnum(spawn_positions))
		adjusting_job.spawn_positions = spawn_positions

	if(isnull(total_positions)) //we can have spawn slots but no total slots, see lord
		total_positions = spawn_positions
	if(isnum(total_positions))
		adjusting_job.total_positions = total_positions
