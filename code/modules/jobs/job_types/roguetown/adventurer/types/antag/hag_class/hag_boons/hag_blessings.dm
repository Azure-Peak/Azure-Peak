/datum/hag_boon/storm_rebirth
	name = "Deathless"
	desc = "The first time the bearer dies, they shall be revived completely. Their body animated like a puppet, leaving them with a curse most terrible."
	points = 85
	var/status_type = /datum/status_effect/buff/hag_boon/storm_rebirth

/datum/hag_boon/storm_rebirth/apply_boon_effect(mob/living/L)
	L.apply_status_effect(status_type, type, tracker)
	return

/datum/hag_boon/storm_rebirth/remove_boon_effect(mob/living/L)
	L.remove_status_effect(status_type)
	return
