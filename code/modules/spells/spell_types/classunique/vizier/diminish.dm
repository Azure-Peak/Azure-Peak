/obj/effect/proc_holder/spell/invoked/diminish
	name = "Diminish"
	desc = "Diminishes all targets in an area through origin magick, reducing their ability to parry and dodge by 20% and sapping their physical faculties. Applies -2 to STR and CON."
	releasedrain = 60
	chargedrain = 1
	chargetime = 1 SECONDS
	range = 5
	warnie = "sydwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 2
	chargedloop = /datum/looping_sound/invokegen
	sound = list('sound/magic/diminish1.ogg','sound/magic/diminish2.ogg','sound/magic/diminish3.ogg','sound/magic/diminish4.ogg')
	action_icon = 'icons/mob/actions/classuniquespells/vizier.dmi'
	overlay_state = "diminish"
	invocations = list("Id'iuf!")
	invocation_type = "shout"
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	recharge_time = 60 SECONDS
	miracle = FALSE
	ignore_los = FALSE
	cost = 2
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW
	var/delay = 8
	var/area_of_effect = 1

/obj/effect/temp_visual/diminish
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 1
	duration = 8
	layer = MASSIVE_OBJ_LAYER

/obj/effect/proc_holder/spell/invoked/diminish/cast(list/targets, mob/living/user)
	. = ..()
	var/turf/T = get_turf(targets[1])

	var/turf/source_turf = get_turf(user)
	if(T.z > user.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < user.z)
		source_turf = get_step_multiz(source_turf, DOWN)

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(!(affected_turf in get_hear(range, source_turf)))
			continue
		new /obj/effect/temp_visual/diminish(affected_turf)
	playsound(T, pick('sound/magic/diminish1.ogg','sound/magic/diminish2.ogg','sound/magic/diminish3.ogg','sound/magic/diminish4.ogg'), 80, TRUE)

	sleep(delay)

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(!(affected_turf in get_hear(range, source_turf)))
			continue
		for(var/mob/living/L in affected_turf.contents)
			if(L.anti_magic_check())
				L.visible_message(span_warning("The origin magick dissipates around [L]!"))
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L] resists the diminishing magick!"))
				continue
			L.visible_message(span_warning("Origin magick diminishes [L]'s instincts!"), span_warning("My instincts feel sluggish and predictable!"))
			L.apply_status_effect(/datum/status_effect/debuff/diminish)

	return TRUE
