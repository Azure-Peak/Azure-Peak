/datum/hag_boon/buff
	var/status_type = null

/datum/hag_boon/buff/apply_boon_effect(mob/living/L)
	L.apply_status_effect(status_type, type, tracker)
	return

/datum/hag_boon/buff/remove_boon_effect(mob/living/L)
	L.remove_status_effect(status_type)
	return

/datum/hag_boon/buff/storm_rebirth
	name = "Deathless"
	desc = "The first time the bearer dies, they shall be revived completely. Their body animated like a puppet, leaving them with a curse most terrible."
	points = 85
	status_type = /datum/status_effect/buff/hag_boon/storm_rebirth
