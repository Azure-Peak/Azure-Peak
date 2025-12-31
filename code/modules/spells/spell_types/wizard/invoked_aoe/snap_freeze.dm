/obj/effect/proc_holder/spell/invoked/snap_freeze // to do: get scroll icon
	name = "Snap Freeze"
	desc = "Freeze the air in a small area in an instant, slowing and mildly damaging those affected."
	cost = 6
	xp_gain = TRUE
	releasedrain = 30
	overlay_state = "snap_freeze"
	chargedrain = 1
	chargetime = 20
	recharge_time = 15 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	range = 7
	gesture_required = TRUE // Offensive spell
	spell_tier = 3
	invocations = list("Congelare Subitus!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_HIGH
	ignore_los = FALSE
	var/delay = 14
	var/damage = 60
	var/area_of_effect = 2

/obj/effect/temp_visual/trapice
	icon = 'icons/effects/effects.dmi'
	icon_state = "frost"
	light_outer_range = 2
	light_color = "#4cadee"
	duration = 11
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/snap_freeze
	icon = 'icons/effects/effects.dmi'
	icon_state = "shieldsparkles"
	name = "rippeling arcyne ice"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER


/obj/effect/proc_holder/spell/invoked/snap_freeze/cast(list/targets, mob/user)
	var/turf/T = get_turf(targets[1])

	var/turf/source_turf = get_turf(user)
	if(T.z > user.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < user.z)
		source_turf = get_step_multiz(source_turf, DOWN)

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(!(affected_turf in get_hear(range, source_turf)))
			continue
		new /obj/effect/temp_visual/trapice(affected_turf)
	playsound(T, 'sound/combat/wooshes/blunt/wooshhuge (2).ogg', 80, TRUE, soundping = TRUE) // it kinda sounds like cold wind idk

	sleep(delay)
	var/play_cleave = FALSE

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		new /obj/effect/temp_visual/snap_freeze(affected_turf)
		if(!(affected_turf in get_hear(range, source_turf)))
			continue
		for(var/mob/living/L in affected_turf.contents)
			if(L.anti_magic_check())
				visible_message(span_warning("The ice fades away around you. [L] "))  //antimagic needs some testing
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				return
			play_cleave = TRUE
			if(ishuman(L))
				L.adjustFireLoss(damage)
			else
				L.adjustFireLoss(damage + 20)
			if(L.has_status_effect(/datum/status_effect/buff/frostbite))
				return
			else
				if(L.has_status_effect(/datum/status_effect/buff/frost))
					playsound(T, 'sound/combat/fracture/fracturedry (1).ogg', 80, TRUE, soundping = TRUE)
					L.remove_status_effect(/datum/status_effect/buff/frost)
					L.apply_status_effect(/datum/status_effect/buff/frostbite)
				else
					L.apply_status_effect(/datum/status_effect/buff/frost)
			playsound(affected_turf, "genslash", 80, TRUE)
			to_chat(L, "<span class='userdanger'>The air chills your bones!</span>")

	if(play_cleave)
		playsound(T, 'sound/combat/newstuck.ogg', 80, TRUE, soundping = TRUE) // this also kinda sounds like ice ngl

	return TRUE
