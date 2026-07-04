/datum/hag_boon/curse
	name = "Generic Curse"
	// Sorry hag, you can't turn a curse into a curse. what are you trying to pull here?
	transmutable = FALSE
	hag_curse = TRUE
	var/status_type = /datum/status_effect/debuff/hag_curse

/datum/hag_boon/curse/apply_boon_effect(mob/living/L)
	// Passing (type, src.tracker) as the extra arguments for on_creation
	L.apply_status_effect(status_type, type, tracker, points)

/datum/hag_boon/curse/rotting_touch
	name = "Curse of rotting touch"
	desc = "Food will rot in the bearer's hands. Dispelled after a certain amount of items are affected."
	status_type = /datum/status_effect/debuff/hag_curse/rotting_touch

/datum/hag_boon/curse/storm_weakness
	name = "Curse of Storm Weakness"
	desc = "The bearer loses a large amount of constitution. Applied after storm rebirth."
	status_type = /datum/status_effect/debuff/hag_curse/storm_weakness
