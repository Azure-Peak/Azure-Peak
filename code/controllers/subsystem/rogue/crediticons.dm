SUBSYSTEM_DEF(crediticons)
	name = "crediticons"
	wait = 6 SECONDS
	flags = SS_NO_INIT | SS_BACKGROUND
	priority = 1
	var/list/processing = list()
	var/list/currentrun = list()

/datum/controller/subsystem/crediticons/fire(resumed = 0)
	if (!resumed)
		src.currentrun = processing.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/currentrun = src.currentrun

	while (currentrun.len)
		var/queued_ckey = currentrun[currentrun.len]
		currentrun.len--
		var/client/queued_client = GLOB.directory[queued_ckey]
		var/mob/living/carbon/human/actor = queued_client?.mob
		if(!istype(actor) || QDELETED(actor))
			if (MC_TICK_CHECK)
				return
			continue
		actor.add_credit(processing[queued_ckey])
		processing -= queued_ckey
		return

/datum/controller/subsystem/crediticons/proc/get_credit_icon(mob/living/carbon/human/target, crop_to_upper_half = FALSE)
	if(!target || !istype(target) || !target.mind || !target.client)
		return null


	var/credit_name = "[target.real_name]"

	if(!GLOB.credits_icons[credit_name]?["icon"])
		return null

	var/icon/credit_icon = GLOB.credits_icons[credit_name]["icon"]

	if(crop_to_upper_half)
		var/icon/cropped_icon = icon(credit_icon)
		cropped_icon.Crop(1, 49, 96, 96)
		return cropped_icon

	return credit_icon
