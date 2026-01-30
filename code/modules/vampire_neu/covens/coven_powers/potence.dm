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
	owner.dna.species.punch_damage += 8
	owner.potence_weapon_buff = 1

/datum/coven_power/potence/one/deactivate()
	. = ..()
	owner.dna.species.punch_damage -= 8
	owner.potence_weapon_buff = 0
	owner.remove_overlay(POTENCE_LAYER)

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
	owner.dna.species.punch_damage += 16
	owner.potence_weapon_buff = 2

/datum/coven_power/potence/two/deactivate()
	. = ..()
	owner.dna.species.punch_damage -= 16
	owner.potence_weapon_buff = 0
	owner.remove_overlay(POTENCE_LAYER)

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
	owner.dna.species.punch_damage += 24
	owner.potence_weapon_buff = 3


/datum/coven_power/potence/three/deactivate()
	. = ..()
	owner.dna.species.punch_damage -= 24
	owner.potence_weapon_buff = 0
	owner.remove_overlay(POTENCE_LAYER)

//POTENCE 4
/datum/coven_power/potence/four
	name = "Potence 4"
	desc = "Become an unyielding machine for as long as your Vitae lasts."

	level = 4
	minimal_generation = GENERATION_ANCILLAE
	research_cost = 3
	vitae_cost = 65
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

/datum/coven_power/potence/four/activate()
	. = ..()
	owner.dna.species.punch_damage += 32
	owner.potence_weapon_buff = 4

/datum/coven_power/potence/four/deactivate()
	. = ..()
	owner.dna.species.punch_damage -= 32
	owner.potence_weapon_buff = 0
	owner.remove_overlay(POTENCE_LAYER)


//POTENCE 5
/datum/coven_power/potence/five
	name = "Potence 5"
	desc = "The people could worship you as a god if you showed them this."

	level = 5
	minimal_generation = GENERATION_ANCILLAE
	research_cost = 4
	vitae_cost = 70
	check_flags = COVEN_CHECK_CAPABLE
	toggled = TRUE
	duration_length = 2 TURNS

/datum/coven_power/potence/five/activate()
	. = ..()
	owner.dna.species.punch_damage += 40
	owner.potence_weapon_buff = 5

/datum/coven_power/potence/five/deactivate()
	. = ..()
	owner.dna.species.punch_damage -= 40
	owner.potence_weapon_buff = 0
	owner.remove_overlay(POTENCE_LAYER)
