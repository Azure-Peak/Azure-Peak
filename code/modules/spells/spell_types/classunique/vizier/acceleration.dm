/datum/action/cooldown/spell/vizier/acceleration
	name = "Acceleration"
	desc = "Displace a target slightly ahead of local time, dramatically increasing their speed and reactions. When reality catches up, the resulting temporal strain leaves them sluggish and exhausted."
	fluff_desc = "One of the earliest applications of Origin Magick, Acceleration was first devised to hasten crop growth and shorten agricultural cycles. The experiment revealed a fundamental limitation of the art: while a subject's personal timeline can be advanced, the debt incurred cannot be avoided. Reality inevitably reconciles the discrepancy, repaying every stolen moment in equal measure. Though unsuitable for cultivation, the technique found lasting use among Naledi Viziers as a potent, if taxing, combat tool."	
	button_icon_state = "accel"
	sound = list('sound/magic/haste.ogg')
	cast_range = 4
	charge_required = FALSE
	cooldown_time = 5 MINUTES
	invocations = list("Aggil!")
	invocation_type = INVOCATION_SHOUT

/datum/action/cooldown/spell/vizier/acceleration/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/target = cast_on

	if(!istype(target))
		return FALSE
	var/obj/effect/temp_visual/origin_restoration/V = new
	target.vis_contents += V

	var/turf/user_turf = get_turf(owner)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, NORTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, NORTHWEST)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, SOUTHEAST)
	new /obj/effect/temp_visual/origin_restoration_burst(user_turf, SOUTHWEST)

	target.visible_message(span_blue("Origin magicks skip [target]'s body ahead in time!"), span_blue("My form is thrown ahead of the present!"))
	target.apply_status_effect(/datum/status_effect/buff/accel)

	return TRUE

/atom/movable/screen/alert/status_effect/buff/accel
	name = "Acceleration"
	desc = "My personal timeline has accelerated. My body moves before I can think!"
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/debuff/decel
	name = "Deceleration"
	desc = "Time is catching up with me. Everything is in slow motion...!"
	icon_state = "debuff"

/datum/status_effect/buff/accel
	id = "acceleration"
	alert_type = /atom/movable/screen/alert/status_effect/buff/accel
	effectedstats = list(STATKEY_SPD = 20)
	duration = 15 SECONDS
	tick_interval = 1 SECONDS
	var/afterimage_active = FALSE

/datum/status_effect/buff/accel/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/buff/accel/on_apply()
	. = ..()

	ADD_TRAIT(owner, TRAIT_GUIDANCE, "naledi_cat_nonsense")
	ADD_TRAIT(owner, TRAIT_NOPAINSTUN, "naledi_cat_nonsense")
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, "naledi_cat_nonsense")

	if(!afterimage_active)
		owner.AddComponent(/datum/component/after_image)
		afterimage_active = TRUE

	to_chat(owner, span_green("My timeline races ahead of the present. I am unbound by time!"))

/datum/status_effect/buff/accel/tick()
	owner.stamina_add(-69)

/datum/status_effect/buff/accel/on_remove()
	. = ..()

	REMOVE_TRAIT(owner, TRAIT_GUIDANCE, "naledi_cat_nonsense")
	REMOVE_TRAIT(owner, TRAIT_NOPAINSTUN, "naledi_cat_nonsense")
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, "naledi_cat_nonsense")

	if(afterimage_active)
		var/datum/component/after_image/after_image_component = owner.GetComponent(/datum/component/after_image)
		if(after_image_component)
			qdel(after_image_component)
		afterimage_active = FALSE

	owner.apply_status_effect(/datum/status_effect/debuff/decel, 14 SECONDS)

	to_chat(owner, span_red("Time catches up with me, with its toll."))

/datum/status_effect/buff/accel/nextmove_modifier()
	return 0.5

/datum/status_effect/debuff/decel
	id = "deceleration"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/decel
	effectedstats = list(STATKEY_SPD = -20)
	duration = 15 SECONDS

/datum/status_effect/debuff/decel/on_creation(mob/living/new_owner, new_duration = null)
	if(new_duration)
		duration = new_duration
	. = ..()

/datum/status_effect/debuff/decel/on_apply()
	. = ..()

	ADD_TRAIT(owner, TRAIT_NODEF, "naledi_cat_nonsense")
	owner.stamina_add(125)
	to_chat(owner, span_red("Everything feels unbearably slow. I am defenseless!"))

/datum/status_effect/debuff/decel/on_remove()
	. = ..()

	REMOVE_TRAIT(owner, TRAIT_NODEF, "naledi_cat_nonsense")

	to_chat(owner, span_blue("My timeline stabilizes, finally."))

/datum/status_effect/debuff/decel/nextmove_modifier()
	return 2


/obj/effect/temp_visual/origin_haste
	icon = 'icons/effects/effects.dmi'
	icon_state = "chronofield"
	duration = 10
	layer = ABOVE_MOB_LAYER
	alpha = 200
	color = "#66ffcc"

/obj/effect/temp_visual/origin_haste/Initialize(mapload)
	. = ..()
	transform = matrix()*3
	animate(src, transform = matrix()*0.1, alpha = 0, time = duration, easing = EASE_IN)
	return INITIALIZE_HINT_NORMAL

/obj/effect/temp_visual/origin_haste/Destroy()
	if(ismob(loc))
		var/mob/M = loc
		M.vis_contents -= src
	return ..()
