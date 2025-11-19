GLOBAL_LIST_INIT(available_kinks, generate_kink_list())

/datum/kink
	abstract_type = /datum/kink
	var/name = "Unknown Kink"
	var/description = "No description available."
	var/category = "General" // General, Domination, Submission, Roleplay, Fetish, etc.
	var/intensity = 1 // 1-5 scale
	var/enabled = TRUE
	var/notes = ""
	var/kink_flags = NONE
	var/list/tracked_mobs

/datum/kink/New(kink_name, kink_desc, kink_category, kink_intensity)
	if(kink_name)
		name = kink_name
	if(kink_desc)
		description = kink_desc
	if(kink_category)
		category = kink_category
	if(kink_intensity)
		intensity = clamp(kink_intensity, 1, 5)
	if(kink_flags & KINK_PROCESS)
		START_PROCESSING(SSobj, src)

/datum/kink/process()
	if(!length(tracked_mobs))
		return
	var/list/sexing_mobs = list()
	for(var/datum/sex_session/session in GLOB.sex_sessions)
		if(session.user in tracked_mobs)
			sexing_mobs |= session.user
		if(session.target in tracked_mobs)
			sexing_mobs |= session.target
	for(var/mob/living/mob in sexing_mobs)
		on_process(mob)

/datum/kink/proc/apply_kink(mob/target)
	return

/datum/kink/proc/on_process(mob/living/target)
	return

/proc/generate_kink_list()
	var/list/kinks = list()
	for(var/datum/kink/kink as anything in subtypesof(/datum/kink))
		if(is_abstract(kink))
			continue
		kinks[initial(kink.name)] = new kink
	return kinks
