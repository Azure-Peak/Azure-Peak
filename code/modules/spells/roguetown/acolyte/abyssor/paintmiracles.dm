/datum/action/cooldown/spell/ink_presence
	name = "Depth Stride"
	desc = "Start leaving paint trails as you move. You and those with paint affinity are sped up and regain a smidge of nutrition for touching trails, everyone else touching the trail is slowed."
	button_icon = 'icons/mob/actions/abyssormiracles.dmi'
	button_icon_state = "paint"
	sound = 'sound/magic/abyssor_splash.ogg'
	spell_color = "#00051f"

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list(
		"Shogg sp'gai! Swift steps from beyond!",
		"N'gai, n'gha'ghaa, fhtagn!",
		"Y'gathil mor, rise!",
		"K'rnul, the painter bleeds!"
	)
	invocation_type = INVOCATION_SHOUT
	charge_required = TRUE
	charge_time = 0.1 SECONDS
	cooldown_time = 22 SECONDS
	devotion_cost = 25
	associated_skill = /datum/skill/magic/holy

	var/active_duration = 7 SECONDS

/datum/action/cooldown/spell/ink_presence/cast(atom/cast_on)
	. = ..()
	var/mob/living/user = owner
	if(!user)
		return FALSE

	RegisterSignal(user, COMSIG_MOVABLE_MOVED, .proc/generate_ink_trail)
	addtimer(CALLBACK(src, .proc/stop_ink_presence, user), active_duration)
	return TRUE

/datum/action/cooldown/spell/ink_presence/proc/generate_ink_trail(mob/living/user, turf/old_turf, dir)
	SIGNAL_HANDLER
	if(!user || user.stat != CONSCIOUS)
		return
	var/turf/current_turf = get_turf(user)
	if(!current_turf || !isopenturf(current_turf))
		return

	var/obj/effect/ink_trail/existing_trail = locate(/obj/effect/ink_trail) in current_turf

	if(existing_trail)
		existing_trail.refresh_lifetime()
	else
		new /obj/effect/ink_trail(current_turf, user)
		user.apply_status_effect(/datum/status_effect/buff/ink_surge)

/datum/action/cooldown/spell/ink_presence/proc/stop_ink_presence(mob/living/user)
	if(user)
		UnregisterSignal(user, COMSIG_MOVABLE_MOVED)
