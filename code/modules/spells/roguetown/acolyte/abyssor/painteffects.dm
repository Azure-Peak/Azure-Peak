/obj/effect/ink_trail
	name = "paint trail"
	desc = "A strange, shimmering paint staining the ground."
	icon = 'icons/mob/actions/abyssormiracles.dmi'
	icon_state = "paint"
	alpha = 255
	anchored = TRUE
	duration = 8 SECONDS
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER

	var/datum/weakref/caster_ref
	var/duration = 8 SECONDS
	var/expiration_timer_id

/obj/effect/ink_trail/ex_act()
	return

/obj/effect/ink_trail/Initialize(mapload, mob/living/caster)
	. = ..()
	if(caster)
		caster_ref = WEAKREF(caster)

	src.pixel_x = rand(-4, 4)
	src.pixel_y = rand(-4, 4)
	src.transform = turn(src.transform, pick(0, 90, 180, 270))
	src.alpha = 255

	// We use a filter to make it cheaper for del() to clean these up!
	start_filter_fade()

/obj/effect/ink_trail/proc/start_filter_fade()
	if(src.filters && src.filters.len)
		src.remove_filter("ink_trail_fade")

	var/list/filter_params = list(
		"type" = "color",
		"color" = list(
			1, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 1, 0,
			0, 0, 0, 1
		)
	)

	src.add_filter("ink_trail_fade", 1, filter_params)
	if(!src.filters || !src.filters.len)
		return
	var/raw_filter = src.filters[src.filters.len]

	animate(raw_filter, color = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,1), time = duration - 3 SECONDS, flags = ANIMATION_RELATIVE)
	animate(color = list(1,0,0,0, 0,1,0,0, 0,0,1,0, 0,0,0,0.1), time = 3 SECONDS, easing = LINEAR_EASING)
	expiration_timer_id = addtimer(CALLBACK(src, .proc/timed_out), duration, TIMER_STOPPABLE)

/obj/effect/ink_trail/proc/timed_out()
	expiration_timer_id = null
	qdel(src)

/obj/effect/ink_trail/proc/refresh_lifetime()
	if(expiration_timer_id)
		deltimer(expiration_timer_id)
	start_filter_fade()

/obj/effect/ink_trail/Crossed(atom/movable/AM)
	. = ..()
	if(isliving(AM))
		trigger_ink_effect(AM)

/obj/effect/ink_trail/proc/trigger_ink_effect(mob/living/L)
	if(!L || L.stat != CONSCIOUS)
		return

	var/mob/living/caster = caster_ref?.resolve()

	if(HAS_TRAIT(L, TRAIT_INK_AFFINITY) || (caster && L == caster))
		L.apply_status_effect(/datum/status_effect/buff/ink_surge)
	else
		L.apply_status_effect(/datum/status_effect/debuff/ink_clog)

// ==========================================
// STATUS EFFECT DEFINITIONS
// ==========================================

/datum/status_effect/buff/ink_surge
	id = "ink_surge"
	duration = 1.5 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/buff/ink_surge

/datum/status_effect/buff/ink_surge/on_apply()
	effectedstats = list(STATKEY_SPD = 1)
	// Makes it ever so slightly easier to sprint around the map with this.
	owner.adjust_nutrition(1)
	return ..()

/datum/status_effect/buff/ink_surge/refresh()
	owner.adjust_nutrition(1)
	return ..()

/datum/status_effect/debuff/ink_clog
	id = "ink_clog"
	duration = 2.5 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/debuff/ink_clog

/datum/status_effect/debuff/ink_clog/on_apply()
	effectedstats = list(STATKEY_SPD = -1)
	owner.blur_eyes(2)
	if(iscarbon(owner))
		var/mob/living/carbon/C = owner
		// Slight loss of stamina to make chasing down a corridor harder
		C.stamina_add(2)
	return ..()

/atom/movable/screen/alert/status_effect/buff/ink_surge
	name = "Abyssal Sprint"
	desc = "The depths speed my step!"
	icon_state = "buff"

/atom/movable/screen/alert/status_effect/debuff/ink_clog
	name = "Paint Fatigue"
	desc = "Abyssal paints cling to my legs."
	icon_state = "debuff"
