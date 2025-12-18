
/obj/effect/proc_holder/spell/invoked/blade_burst
	name = "Blade Burst"
	desc = "Summon a storm of arcyne force in an area, wounding anything in that location after a delay."
	cost = 3
	range = 7
	xp_gain = TRUE
	releasedrain = 30
	chargedrain = 1
	chargetime = 20
	recharge_time = 15 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "blade_burst"
	spell_tier = 2 // AOE, but this is essential for PVE
	invocations = list("Erumpere Gladios!")
	invocation_type = "shout"
	glow_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_HIGH
	gesture_required = TRUE
	ignore_los = FALSE
	var/delay = 12
	var/damage = 125 //if you get hit by this it's your fault
	var/area_of_effect = 1

/obj/effect/temp_visual/trap
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	duration = 12
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/blade_burst
	icon = 'icons/effects/effects.dmi'
	icon_state = "stab"
	dir = NORTH
	name = "rippling arcyne energy"
	desc = "Get out of the way!"
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER


/obj/effect/proc_holder/spell/invoked/blade_burst/cast(list/targets, mob/user)
	var/turf/T = get_turf(targets[1])

	var/turf/source_turf = get_turf(user)
	if(T.z > user.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < user.z)
		source_turf = get_step_multiz(source_turf, DOWN)

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(!(affected_turf in get_hear(range, source_turf)))
			continue
		new /obj/effect/temp_visual/trap(affected_turf)
	playsound(T, 'sound/magic/blade_burst.ogg', 80, TRUE, soundping = TRUE)

	sleep(delay)
	var/play_cleave = FALSE

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(!(affected_turf in get_hear(range, source_turf)))
			continue
		new /obj/effect/temp_visual/blade_burst(affected_turf)
		for(var/mob/living/L in affected_turf.contents)
			if(L.anti_magic_check())
				visible_message(span_warning("The blades dispel when they near [L]!"))
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				continue
			play_cleave = TRUE
			L.adjustBruteLoss(damage)
			var/mark_stacks = consume_arcane_mark_stacks(L)
			if(mark_stacks)
				L.adjustBruteLoss(20 * (mark_stacks))
			if(mark_stacks == 3)
				to_chat(L, "<span class='userdanger'>THOUSAND-NEEDLE MADRIPOLE; TRYPTICH-MARKE DETONATION!</span>")
			playsound(affected_turf, "genslash", 80, TRUE)
			to_chat(L, "<span class='userdanger'>You're cut by arcyne force!</span>")

	if(play_cleave)
		playsound(T, 'sound/combat/newstuck.ogg', 80, TRUE, soundping = TRUE)

	return TRUE
