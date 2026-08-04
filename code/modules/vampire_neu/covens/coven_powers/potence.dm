/datum/coven/potence
	name = "Potence"
	desc = "Boosts melee and unarmed damage."
	icon_state = "potence"
	power_type = /datum/coven_power/potence

/datum/coven_power/potence
	name = "Potence power name"
	desc = "Potence power description"

	grouped_powers = list(
		/datum/coven_power/potence/one,
		/datum/coven_power/potence/two,
		/datum/coven_power/potence/three,
		/datum/coven_power/potence/four,
		/datum/coven_power/potence/five
	)

/datum/coven_power/potence/activate(atom/target)
	. = ..()
	owner.apply_status_effect(/datum/status_effect/buff/potence, level)
	if(level > 2)
		owner.visible_message(span_warning("[owner] tenses their muscles, looking exceptionally stronger!"))
		if(level > 3)
			ADD_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_VAMPIRE)
			ADD_TRAIT(owner, TRAIT_ZJUMP, TRAIT_VAMPIRE)
			ADD_TRAIT(owner, TRAIT_NOFALLDAMAGE1, TRAIT_VAMPIRE)

/datum/coven_power/potence/deactivate(atom/target, direct)
	. = ..()
	owner.remove_status_effect(/datum/status_effect/buff/potence)
	if(level > 2)
		owner.visible_message(span_warning("[owner] relaxes their body."))
		if(level > 3)
			REMOVE_TRAIT(owner, TRAIT_STRENGTH_UNCAPPED, TRAIT_VAMPIRE)
			REMOVE_TRAIT(owner, TRAIT_ZJUMP, TRAIT_VAMPIRE)
			REMOVE_TRAIT(owner, TRAIT_NOFALLDAMAGE1, TRAIT_VAMPIRE)

/datum/coven_power/potence/do_caster_notification(target)
	to_chat(owner, span_warning("You feel your blood surge through your muscles, empowering your body."))

/// Shared deactivation message for all Potence levels.
/datum/coven_power/potence/proc/do_deactivation_notification()
	to_chat(owner, span_warning("The supernatural strength fades from your limbs."))

//POTENCE 1
/datum/coven_power/potence/one
	name = "Potence 1"
	desc = "Enhance your muscles. Never hit softly."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

/datum/coven_power/potence/one/activate()
	. = ..()
	owner.dna.species.punch_damage += 2

/datum/coven_power/potence/one/deactivate()
	. = ..()
	owner.dna.species.punch_damage -= 2
	do_deactivation_notification()

//POTENCE 2
/datum/coven_power/potence/two
	name = "Potence 2"
	desc = "Become powerful beyond your muscles. Wreck people and things."

	level = 2
	research_cost = 1
	vitae_cost = 55
	check_flags = COVEN_CHECK_CAPABLE

	toggled = TRUE
	duration_length = 2 TURNS

/datum/coven_power/potence/two/activate()
	. = ..()
	owner.dna.species.punch_damage += 4

/datum/coven_power/potence/two/deactivate()
	. = ..()
	owner.dna.species.punch_damage -= 4
	do_deactivation_notification()

//POTENCE 3
/datum/coven_power/potence/three
	name = "Potence 3"
	desc = "Become a force of destruction. Lift and break the unliftable and the unbreakable."

	level = 3
	research_cost = 2
	vitae_cost = 60
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

/datum/coven_power/potence/three/activate()
	. = ..()
	owner.dna.species.punch_damage += 6

/datum/coven_power/potence/three/deactivate()
	. = ..()
	owner.dna.species.punch_damage -= 6
	do_deactivation_notification()

//POTENCE 4
/datum/coven_power/potence/four
	name = "Potence 4"
	desc = "Become an unyielding machine for as long as your Vitae lasts."

	level = 4
	research_cost = 3
	vitae_cost = 65
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

/datum/coven_power/potence/four/activate()
	. = ..()
	owner.dna.species.punch_damage += 8

/datum/coven_power/potence/four/deactivate()
	. = ..()
	owner.dna.species.punch_damage -= 8
	do_deactivation_notification()


//POTENCE 5
/datum/coven_power/potence/five
	name = "Potence 5"
	desc = "The people could worship you as a god if you showed them this."

	level = 5
	research_cost = 4
	vitae_cost = 70
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

/datum/coven_power/potence/five/activate()
	. = ..()
	owner.dna.species.punch_damage += 10

/datum/coven_power/potence/five/deactivate()
	. = ..()
	owner.dna.species.punch_damage -= 10
	do_deactivation_notification()
