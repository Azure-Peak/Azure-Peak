/datum/hag_boon
	var/name = "Generic Boon"
	var/time_granted = 0

/datum/hag_boon/New(boon_name, mob/living/L, datum/component/hag_curio_tracker/HC)
	src.time_granted = world.time
