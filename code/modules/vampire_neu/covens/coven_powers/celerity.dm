/datum/coven/celerity
	name = "Celerity"
	desc = "Boosts your speed. Violates Masquerade."
	icon_state = "celerity"
	power_type = /datum/coven_power/celerity

/datum/coven_power/celerity
	name = "Celerity power name"
	desc = "Celerity power description"
	grouped_powers = list(
		/datum/coven_power/celerity/one,
		/datum/coven_power/celerity/two,
		/datum/coven_power/celerity/three,
		/datum/coven_power/celerity/four,
		/datum/coven_power/celerity/five,
	)
	var/multiplicative_slowdown = -0.1

/datum/coven_power/celerity/activate(atom/target)
	. = ..()
	owner.add_movespeed_modifier(MOVESPEED_ID_CELERITY, multiplicative_slowdown = src.multiplicative_slowdown)
	owner.apply_status_effect(/datum/status_effect/buff/celerity, level)
	owner.AddComponent(/datum/component/after_image)
	playsound(owner,'sound/magic/timeforward.ogg', 40, TRUE)
	owner.visible_message(
		span_warning("[owner] starts moving at inhumen speeds, their every action a blur!"))

/datum/coven_power/celerity/deactivate(atom/target, direct)
	. = ..()
	qdel(owner.GetComponent(/datum/component/after_image))
	owner.remove_status_effect(/datum/status_effect/buff/celerity)
	owner.remove_movespeed_modifier(MOVESPEED_ID_CELERITY)
	playsound(owner,'sound/magic/timestop.ogg', 40, TRUE)

//CELERITY 1
/datum/coven_power/celerity/one
	name = "Celerity 1"
	desc = "Enhances your speed to make everything a little bit easier."

	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	multiplicative_slowdown = -0.15

//CELERITY 2

/datum/coven_power/celerity/two
	name = "Celerity 2"
	desc = "Significantly improves your speed and reaction time."

	level = 2
	research_cost = 1
	vitae_cost = 55
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	multiplicative_slowdown = -0.2

//CELERITY 3
/datum/coven_power/celerity/three
	name = "Celerity 3"
	desc = "Move faster. React in less time. Your body is under perfect control."

	level = 3
	research_cost = 2
	vitae_cost = 60
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	multiplicative_slowdown = -0.25

//CELERITY 4
/datum/coven_power/celerity/four
	name = "Celerity 4"
	desc = "Breach the limits of what is humanly possible. Move like a lightning bolt."

	level = 4
	research_cost = 3
	vitae_cost = 65
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	multiplicative_slowdown = -0.3

//CELERITY 5
/datum/coven_power/celerity/five
	name = "Celerity 5"
	desc = "You are like light. Blaze your way through the world."

	level = 5
	research_cost = 4
	vitae_cost = 70
	check_flags = COVEN_CHECK_LYING | COVEN_CHECK_IMMOBILE
	toggled = TRUE
	duration_length = 2 TURNS

	multiplicative_slowdown = -0.35
