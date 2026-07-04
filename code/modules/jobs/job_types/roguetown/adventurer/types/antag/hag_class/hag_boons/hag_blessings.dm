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
	points = 65
	status_type = /datum/status_effect/buff/hag_boon/storm_rebirth

/datum/hag_boon/buff/natural_communion
	name = "Natural Communion"
	desc = "The bearer will regenerate their stamina whilst on grass, dirt, snow or swampwater."
	points = 40
	status_type = /datum/status_effect/buff/hag_boon/natural_communion

/datum/hag_boon/buff/creeping_moss
	name = "Creeping Moss"
	desc = "The bearer will regenerate their health whilst on grass, dirt, snow or swampwater. Don't let the moss grow too thick..."
	points = 40
	status_type = /datum/status_effect/buff/hag_boon/creeping_moss
