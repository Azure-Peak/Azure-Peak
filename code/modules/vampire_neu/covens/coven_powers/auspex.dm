/datum/coven/auspex
	name = "Auspex"
	desc = "Allows to see entities, auras and their health through walls."
	icon_state = "auspex"
	power_type = /datum/coven_power/auspex
	max_level = 4

/datum/coven_power/auspex
	name = "Auspex power name"
	desc = "Auspex power description"

	grouped_powers = list(
		/datum/coven_power/auspex/heightened_senses,
		/datum/coven_power/auspex/ear_for_lies,
		/datum/coven_power/auspex/spirit_touch,
		/datum/coven_power/auspex/psychic_projection,
	)

//HEIGHTENED SENSES
/datum/coven_power/auspex/heightened_senses
	name = "Heightened Senses"
	desc = "Enhances your senses far past human limitations."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CONSCIOUS
	vitae_cost = 10
	cooldown_length = 15 SECONDS
	duration_length = 10 SECONDS

	toggled = TRUE

/datum/coven_power/auspex/heightened_senses/activate()
	. = ..()

	ADD_TRAIT(owner, TRAIT_THERMAL_VISION, TRAIT_VAMPIRE)
	owner.apply_status_effect(/datum/status_effect/buff/auspex, level)

	owner.update_sight()

/datum/coven_power/auspex/heightened_senses/deactivate()
	. = ..()

	REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, TRAIT_VAMPIRE)
	owner.remove_status_effect(/datum/status_effect/buff/auspex)

	owner.update_sight()

//AN EAR FOR LIES
/datum/coven_power/auspex/ear_for_lies
	name = "An Ear For Lies"
	desc = "Hear more than you should."

	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS
	vitae_cost = 13
	cooldown_length = 15 SECONDS
	duration_length = 10 SECONDS

	toggled = TRUE

/datum/coven_power/auspex/ear_for_lies/activate()
	. = ..()

	ADD_TRAIT(owner, TRAIT_THERMAL_VISION, TRAIT_VAMPIRE)
	ADD_TRAIT(owner, TRAIT_KEENEARS, TRAIT_VAMPIRE)
	owner.apply_status_effect(/datum/status_effect/buff/auspex, level)

	owner.update_sight()

/datum/coven_power/auspex/ear_for_lies/deactivate()
	. = ..()

	REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, TRAIT_VAMPIRE)
	REMOVE_TRAIT(owner, TRAIT_KEENEARS, TRAIT_VAMPIRE)
	owner.remove_status_effect(/datum/status_effect/buff/auspex)

	owner.update_sight()

//"THE SPIRITS TOUCH" 
/datum/coven_power/auspex/spirit_touch
	name = "The Spirit's Touch"
	desc = "Be able to track down your pray by the smallest hints possible."

	level = 3
	research_cost = 1
	check_flags = COVEN_CHECK_CONSCIOUS
	vitae_cost = 15
	cooldown_length = 15 SECONDS
	duration_length = 10 SECONDS

	toggled = TRUE

/datum/coven_power/auspex/spirit_touch/activate()
	. = ..()

	ADD_TRAIT(owner, TRAIT_THERMAL_VISION, TRAIT_VAMPIRE)
	ADD_TRAIT(owner, TRAIT_KEENEARS, TRAIT_VAMPIRE)
	ADD_TRAIT(owner, TRAIT_PERFECT_TRACKER, TRAIT_VAMPIRE)
	owner.apply_status_effect(/datum/status_effect/buff/auspex, level)

	owner.update_sight()

/datum/coven_power/auspex/spirit_touch/deactivate()
	. = ..()

	REMOVE_TRAIT(owner, TRAIT_THERMAL_VISION, TRAIT_VAMPIRE)
	REMOVE_TRAIT(owner, TRAIT_KEENEARS, TRAIT_VAMPIRE)
	REMOVE_TRAIT(owner, TRAIT_PERFECT_TRACKER, TRAIT_VAMPIRE)
	owner.remove_status_effect(/datum/status_effect/buff/auspex)

	owner.update_sight()

//PSYCHIC PROJECTION
/datum/coven_power/auspex/psychic_projection
	name = "Psychic Projection"
	desc = "Leave your body behind and fly across the land."

	level = 4
	research_cost = 2
	check_flags = COVEN_CHECK_CONSCIOUS
	vitae_cost = 250

/datum/coven_power/auspex/psychic_projection/activate()
	. = ..()
	owner.visible_message("<font color='red'>[owner]'s eyes turn blank, like they are not even here.</font>", "<font color='red'>I begin to channel my consciousness into a psychic projection.</font>")
	if(do_after(owner, 6 SECONDS, src))
		owner.scry(can_reenter_corpse = 1, force_respawn = FALSE)
