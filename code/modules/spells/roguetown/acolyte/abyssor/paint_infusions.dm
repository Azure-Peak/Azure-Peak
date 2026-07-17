/datum/status_effect/infusion/intelligence
	id = "Intelligence Infusion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/intelligence_infusion
	effectedstats = list(STATKEY_INT = 2)
	examine_text = "SUBJECTPRONOUN looks surrounded by a shimmering, thoughtful aura of dark paint."

/atom/movable/screen/alert/status_effect/buff/intelligence_infusion
	name = "Intelligence Infusion"
	desc = "Abyssor's dream is vivid in my mind, improving my ability to imagine all sorts of new posibilities."

/datum/status_effect/infusion/perception
	id = "Perception Infusion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/perception_infusion
	effectedstats = list(STATKEY_PER = 2)
	examine_text = "SUBJECTPRONOUN looks surrounded by a shimmering, perception-sharpening aura of dark paint."

/atom/movable/screen/alert/status_effect/buff/perception_infusion
	name = "Perception Infusion"
	desc = "Abyssor's dream is vivid in my mind, shapes of paint outline objects and people in the distance, making them clearer."

/datum/status_effect/infusion/fortune
	id = "Fortuitous Infusion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fortune_infusion
	effectedstats = list(STATKEY_LCK = 3)
	examine_text = "SUBJECTPRONOUN looks surrounded by a shimmering, luck-inducing aura of dark paint."

/atom/movable/screen/alert/status_effect/buff/fortune_infusion
	name = "Fortuitous Infusion"
	desc = "Abyssor's dream is vivid in my mind, paint sinking out in nearby waters to draw forth the rarest fish."

/datum/status_effect/infusion/strength
	id = "Strength Infusion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/strength_infusion
	effectedstats = list(STATKEY_STR = 1)
	// 30 seconds out of range
	decay_multiplier = 40
	examine_text = "SUBJECTPRONOUN looks surrounded by a shimmering, muscle-fostering aura of dark paint."

/atom/movable/screen/alert/status_effect/buff/strength_infusion
	name = "Strength Infusion"
	desc = "Abyssor's dream is vivid in my mind, my mind flooded with imagery of myself lifting heavy objects and people."

/datum/status_effect/infusion/speed
	id = "Speed Infusion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/speed_infusion
	effectedstats = list(STATKEY_SPD = 1)
	decay_multiplier = 40
	examine_text = "SUBJECTPRONOUN looks surrounded by a shimmering, speeding aura of dark paint."

/atom/movable/screen/alert/status_effect/buff/speed_infusion
	name = "Speed Infusion"
	desc = "Abyssor's dream is vivid in my mind, my mind flooded with imagery of hares outspeeding turtles."

/datum/status_effect/infusion/ambush_trait
	id = "Sneaky Infusion"
	alert_type = /atom/movable/screen/alert/status_effect/buff/sneak_infusion
	effectedstats = list()
	examine_text = "SUBJECTPRONOUN looks surrounded by a shimmering, obscuring aura of dark paint."

/datum/status_effect/infusion/ambush_trait/on_apply()
	. = ..()
	ADD_TRAIT(owner, TRAIT_AZURENATIVE, TRAIT_INFUSION)

/datum/status_effect/infusion/ambush_trait/on_remove()
	. = ..()
	REMOVE_TRAIT(owner, TRAIT_AZURENATIVE, TRAIT_INFUSION)

/atom/movable/screen/alert/status_effect/buff/sneak_infusion
	name = "Sneaky Infusion"
	desc = "Abyssor's dream is vivid in my mind, showing hints of rustling bushes and maneaters."
