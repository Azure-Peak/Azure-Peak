
SUBSYSTEM_DEF(crediticons)
	name = "crediticons"
	wait = 20
	flags = SS_NO_INIT
	priority = 1
	var/list/processing = list()
	var/list/currentrun = list()
	can_fire = FALSE

/datum/controller/subsystem/crediticons/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while (currentrun.len)
		var/mob/living/carbon/human/thing = currentrun[currentrun.len]
		currentrun.len--
		if (!thing || QDELETED(thing))
			processing -= thing
			if (MC_TICK_CHECK)
				return
			continue
		thing.add_credit()
		STOP_PROCESSING(SScrediticons, thing)
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/crediticons/proc/get_credit_icon(mob/living/carbon/human/target, crop_to_upper_half = FALSE)
	if(!target || !istype(target) || !target.mind || !target.client)
		return null

	var/credit_name = "[target.real_name]"
	if(target.mind.assigned_role)
		// We don't have their job refactor yet
		var/datum/job/job = target.mind.assigned_role
		if(job)
			credit_name = "[credit_name]\nthe [job]"

	if(!GLOB.credits_icons[credit_name]?["icon"])
		return null

	var/icon/credit_icon = GLOB.credits_icons[credit_name]["icon"]

	if(crop_to_upper_half)
		var/icon/cropped_icon = icon(credit_icon)
		cropped_icon.Crop(1, 49, 96, 96)
		return cropped_icon

	return credit_icon
