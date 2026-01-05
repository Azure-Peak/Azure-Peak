/datum/status_effect/zombie_infection
	id = "zombie_infection"
	alert_type = /atom/movable/screen/alert/status_effect/zombie_infection
	/// Time until transformation completes
	var/transformation_time
	var/message_cooldown_time
	var/message_cooldown_amount = 20 SECONDS
	/// Whether this infection came from a living host (Aka, did we die and get infected that way?)
	var/infected_wake = FALSE
	// Doesn't hurt making this a static list.
	var/static/list/infection_messages = list(
		"I can feel rot creeping up in the back of my throat. An oily, coppery taste flooding my mouth.",
		"My skin feels cold and clammy. I can feel my veins hardening up like cold steel.",
		"A deep hunger gnaws at my stomach. Nothing sates it.",
		"The color drains from the world as I view it, momentarily.",
		"I keep hearing whispers. Is she calling for me?",
		"My joints ache with a strange stiffness. It hurts to move.",
		"My mind is fraying, who am I?",
		"I can feel my pulse slowing. I've never felt this calm.",
		"There's a strange numbness spreading through my limbs, I'm bleeding but I can't tell where.",
		"I can smell my own flesh, it smells foul."
	)

/datum/status_effect/zombie_infection/on_creation(mob/living/new_owner, time_to_transform = 5 MINUTES, from_infected_wake = "wound")
	. = ..()
	transformation_time = world.time + time_to_transform
	message_cooldown_time = world.time + message_cooldown_amount
	infected_wake = from_infected_wake

/datum/status_effect/zombie_infection/tick()
	if(world.time > message_cooldown_time)
		var/warning_message = pick(infection_messages)
		if(prob(10))
			to_chat(owner, span_userdanger("[warning_message]"))
		else
			to_chat(owner, span_danger("[warning_message]"))
		message_cooldown_time = world.time + message_cooldown_amount
	if(world.time > transformation_time)
		var/mob/living/carbon/human/H = owner
		if(!iscarbon(H))
			owner.remove_status_effect(/datum/status_effect/zombie_infection)

		if(H.stat == DEAD || infected_wake)
			H.zombie_check_can_convert()
			var/datum/antagonist/zombie/zombie_antag = H.mind?.has_antag_datum(/datum/antagonist/zombie)
			if(zombie_antag && !zombie_antag.has_turned)
				zombie_antag.wake_zombie(infected_wake)
				owner.remove_status_effect(/datum/status_effect/zombie_infection)

/datum/status_effect/zombie_infection/on_apply()
	. = ..()
	var/warning_message = pick(infection_messages)
	if(prob(10))
		to_chat(owner, span_userdanger("[warning_message]"))
	else
		to_chat(owner, span_danger("[warning_message]"))
	var/mob/living/carbon/human/H = owner
	if(!iscarbon(H))
		owner.remove_status_effect(/datum/status_effect/zombie_infection)
	H.vomit(1, blood = TRUE, stun = FALSE)
	return TRUE

/atom/movable/screen/alert/status_effect/zombie_infection
	name = "Zombie Infection"
	desc = "You feel a coldness spreading through your body. You're turning into one of -them-!"
	icon_state = "zombie"

// Updated proc to use status effect
/mob/living/carbon/human/proc/attempt_zombie_infection(mob/living/carbon/human/source, infection_type, wake_delay = 0)
	var/datum/antagonist/zombie/zombie_antag = source.mind?.has_antag_datum(/datum/antagonist/zombie)
	if(!zombie_antag || !zombie_antag.has_turned)
		return FALSE

	if(mind?.has_antag_datum(/datum/antagonist/zombie))
		return FALSE

	// Apply status effect with timer
	apply_status_effect(
		/datum/status_effect/zombie_infection, 
		wake_delay, 
		infection_type == "wound"
	)

	switch(infection_type)
		if("bite")
			to_chat(src, span_danger("A growing cold seeps into my body. I feel horrible... REALLY horrible..."))
		if("wound")
			if(show_redflash())
				flash_fullscreen("redflash3")
			to_chat(src, span_danger("Ow! It hurts. I feel horrible... REALLY horrible..."))

	return TRUE
