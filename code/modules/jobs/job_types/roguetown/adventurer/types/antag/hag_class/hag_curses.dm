/datum/hag_boon/curse
	name = "Generic Curse"
	var/status_type = /datum/status_effect/debuff/hag_curse

/datum/hag_boon/curse/apply_boon_effect(mob/living/L)
	// Passing (type, src.tracker) as the extra arguments for on_creation
	L.apply_status_effect(status_type, type, tracker, points)

/datum/hag_boon/curse/rotting_touch
	name = "Curse of rotting touch"
	status_type = /datum/status_effect/debuff/hag_curse/rotting_touch
