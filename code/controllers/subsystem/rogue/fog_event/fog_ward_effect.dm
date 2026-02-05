#define FOG_WARD_OUTLINE "fog_ward_outline"

/datum/status_effect/buff/fog_ward
	id = "fog_ward"
	duration = -1 // Controlled by the presence of the caster
	alert_type = /atom/movable/screen/alert/status_effect/buff/fog_ward
	var/mob/living/caster
	var/range = 5
	var/grace_period = 0

/datum/status_effect/buff/fog_ward/on_creation(mob/living/new_owner, mob/living/C, R)
	caster = C
	range = R
	. = ..()

/datum/status_effect/buff/fog_ward/on_apply()
	ADD_TRAIT(owner, TRAIT_FOG_WARDED, TRAIT_MIRACLE)
	SEND_SIGNAL(owner, COMSIG_WARDED_TRAIT_CHANGE)
	owner.add_filter(FOG_WARD_OUTLINE, 1, list("type" = "outline", "color" = "#ffffffb3", "size" = 1))
	return TRUE

/datum/status_effect/buff/fog_ward/process()
	. = ..()
	if(QDELETED(caster) || caster.stat == DEAD || !caster.has_status_effect(/datum/status_effect/buff/fog_ward_caster))
		to_chat(owner, span_warning("Woe! The ward fades!"))
		owner.remove_status_effect(/datum/status_effect/buff/fog_ward)
		return

	// should this cause lag, remind me to make this component based instead.
	if(get_dist(owner, caster) > range)
		if(!grace_period)
			to_chat(owner, span_warning("You have stepped out of the holy ward! Return to the light!"))
			grace_period = world.time + 5 SECONDS

		if(world.time > grace_period)
			to_chat(owner, span_danger("The holy protection fades as you wander too far from the caster for too long."))
			owner.remove_status_effect(/datum/status_effect/buff/fog_ward)
	else
		if(grace_period)
			to_chat(owner, span_notice("You are back within the safety of the ward."))
			grace_period = 0

/datum/status_effect/buff/fog_ward/on_remove()
	REMOVE_TRAIT(owner, TRAIT_FOG_WARDED, TRAIT_MIRACLE)
	SEND_SIGNAL(owner, COMSIG_WARDED_TRAIT_CHANGE)
	owner.remove_filter(FOG_WARD_OUTLINE)
	return ..()

// --- THE CASTER VARIANT ---
/datum/status_effect/buff/fog_ward_caster
	id = "fog_ward_caster"
	alert_type = /atom/movable/screen/alert/status_effect/buff/fog_ward/caster
	status_type = STATUS_EFFECT_REFRESH
	var/refresh_duration = 0
	var/range = 5
	var/dispel_revenants = TRUE

/datum/status_effect/buff/fog_ward_caster/refresh()
	duration = refresh_duration

/datum/status_effect/buff/fog_ward_caster/on_creation(mob/living/new_owner, R, D, dispel)
	range = R
	duration = D
	refresh_duration = D
	dispel_revenants = dispel
	. = ..()

/datum/status_effect/buff/fog_ward_caster/on_apply()
	ADD_TRAIT(owner, TRAIT_FOG_WARDED, TRAIT_MIRACLE)
	SEND_SIGNAL(owner, COMSIG_WARDED_TRAIT_CHANGE)
	owner.add_filter(FOG_WARD_OUTLINE, 1, list("type" = "outline", "color" = "#ffffff", "size" = 2))
	return TRUE

/datum/status_effect/buff/fog_ward_caster/on_remove()
	REMOVE_TRAIT(owner, TRAIT_FOG_WARDED, TRAIT_MIRACLE)
	SEND_SIGNAL(owner, COMSIG_WARDED_TRAIT_CHANGE)
	owner.remove_filter(FOG_WARD_OUTLINE)
	return ..()

/datum/status_effect/buff/fog_ward_caster/process()
	. = ..()
	for(var/mob/living/L in view(range, owner))
		if(L.has_status_effect(/datum/status_effect/buff/fog_ward_caster))
			continue

		if(dispel_revenants)
			if(istype(L, /mob/living/simple_animal/hostile/retaliate/rogue/revenant))
				var/mob/living/simple_animal/hostile/retaliate/rogue/revenant/F = L
				F.disappear_animated()
				continue // Don't try to ward the thing we're dispelling

		if(ishuman(L))
			L.apply_status_effect(/datum/status_effect/buff/fog_ward, owner, range)

/atom/movable/screen/alert/status_effect/buff/fog_ward
	name = "Holy Ward"
	desc = "You are protected from fog ambushes by a holy miracle. Stay close to the caster!"
	// I'll make icons for these later
	//icon_state = "holy_ward"

/atom/movable/screen/alert/status_effect/buff/fog_ward/caster
	name = "Sanctuary Aura"
	desc = "You are projecting a holy ward. Fog creatures that enter your light will be dispelled."
	//icon_state = "holy_aura"

#undef FOG_WARD_OUTLINE

/obj/effect/proc_holder/spell/invoked/fog_ward
	name = "Ward of the Undermaiden"
	desc = "Call upon Necra to manifest a holy mist that dispels fog phantoms and prevents ambushes. Allies must stay close to you to maintain protection."
	invocations = list("Necra, clear the path!", "Be gone, shades of the mist!")
	devotion_cost = 150
	recharge_time = 3 MINUTES
	chargetime = 2 SECONDS
	action_icon_state = "fog_ward"
	action_icon = 'icons/mob/actions/necramiracles.dmi'
	associated_skill = /datum/skill/magic/holy
	sound = 'sound/magic/magnet.ogg'

/obj/effect/proc_holder/spell/invoked/fog_ward/cast(list/targets, mob/living/user)
	var/holy_skill = user.get_skill_level(associated_skill)

	// Range scales with skill: 3 to 7 tiles
	var/ward_range = 3
	if(holy_skill >= SKILL_LEVEL_MASTER)
		ward_range = 7
	else if(holy_skill >= SKILL_LEVEL_APPRENTICE)
		ward_range = 5

	// Duration scales with skill: 30s to 6 minutes
	var/duration = 30 SECONDS
	if(holy_skill >= SKILL_LEVEL_MASTER)
		duration = 6 MINUTES
	else if(holy_skill >= SKILL_LEVEL_APPRENTICE)
		duration = 3 MINUTES

	user.apply_status_effect(/datum/status_effect/buff/fog_ward_caster, ward_range, duration)

	return TRUE

/obj/effect/proc_holder/spell/invoked/fog_ward/on_gain(mob/living/user)
	// Check the subsystem variable to see if fog is even a possibility this round
	if(!SSevent_scheduler.fog_scheduled)
		qdel(src)
		return FALSE
	return ..()
