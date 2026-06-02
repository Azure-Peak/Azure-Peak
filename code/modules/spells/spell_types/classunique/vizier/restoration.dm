/obj/effect/proc_holder/spell/invoked/vizier_restoration
	name = "Restoration"
	desc = "Uses origin magick to restore the target's body to a prior state, granting health regeneration."
	overlay_state = "restoration"
	releasedrain = 50
	chargedrain = 0
	chargetime = 0
	range = 4
	warnie = "sydwarning"
	movement_interrupt = FALSE
	sound = list('sound/magic/regression1.ogg','sound/magic/regression2.ogg','sound/magic/regression3.ogg','sound/magic/regression4.ogg')
	action_icon = 'icons/mob/actions/classuniquespells/vizier.dmi'
	invocations = list("Ishfi!") // https://en.wiktionary.org/wiki/%D8%B4%D9%81%D9%89
	invocation_type = "whisper"
	associated_skill = /datum/skill/magic/arcane
	antimagic_allowed = TRUE
	recharge_time = 12 SECONDS
	miracle = FALSE
	ignore_los = FALSE
	cost = 2
	devotion_cost = 0
	glow_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

/obj/effect/proc_holder/spell/invoked/vizier_restoration/cast(list/targets, mob/living/user)
	. = ..()
	if(!isliving(targets[1]))
		revert_cast()
		return FALSE
	var/mob/living/target = targets[1]
	new /obj/effect/temp_visual/origin_restoration(get_turf(target))
	new /obj/effect/temp_visual/origin_restoration_burst(get_turf(user), NORTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(get_turf(user), NORTHWEST)
	new /obj/effect/temp_visual/origin_restoration_burst(get_turf(user), SOUTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(get_turf(user), SOUTHWEST)
	target.visible_message(span_info("Origin magick rewinds [target]'s body!"), span_notice("My body recalls its prior form!"))
	var/amt_per_tick = 3
	target.apply_status_effect(/datum/status_effect/buff/originhealing, amt_per_tick)
	return TRUE

/obj/effect/temp_visual/origin_restoration
	icon = 'icons/effects/effects.dmi'
	icon_state = "bhole3"
	duration = 10
	layer = ABOVE_MOB_LAYER
	alpha = 220
	color = "#FFD966"

/obj/effect/temp_visual/origin_restoration/Initialize(mapload)
	. = ..()
	transform = matrix()*3
	animate(src, transform = matrix()*0.1, alpha = 0, time = duration, easing = EASE_IN)
	return INITIALIZE_HINT_NORMAL

/obj/effect/temp_visual/origin_restoration_burst
	icon = 'icons/effects/effects.dmi'
	icon_state = "medi_holo"
	duration = 8
	layer = ABOVE_MOB_LAYER
	alpha = 220
	color = "#FFD966"

/obj/effect/temp_visual/origin_restoration_burst/Initialize(mapload, dir_to_go)
	. = ..()
	var/turf/T = get_step(src, dir_to_go)
	if(T)
		animate(src, pixel_x = (T.x - x) * 32, pixel_y = (T.y - y) * 32, alpha = 0, time = duration)
	return INITIALIZE_HINT_NORMAL
