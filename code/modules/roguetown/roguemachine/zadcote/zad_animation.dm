/obj/effect/temp_visual/zad_tracked
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	randomdir = FALSE
	var/datum/weakref/tracked_cage
	var/atom/movable/current_anchor

/obj/effect/temp_visual/zad_tracked/proc/start_tracking(obj/item/zadcage/cage)
	if(!cage)
		return
	tracked_cage = WEAKREF(cage)
	process()
	START_PROCESSING(SSfastprocess, src)

/obj/effect/temp_visual/zad_tracked/process()
	if(!tracked_cage)
		STOP_PROCESSING(SSfastprocess, src)
		return
	var/obj/item/zadcage/cage = tracked_cage.resolve()
	if(!cage)
		STOP_PROCESSING(SSfastprocess, src)
		return
	var/atom/expected = zad_world_anchor(cage)
	if(expected == current_anchor)
		return
	if(current_anchor && (src in current_anchor.vis_contents))
		current_anchor.vis_contents -= src
	current_anchor = null
	if(!expected)
		return
	if(isturf(expected))
		forceMove(expected)
		return
	if(ismovable(expected))
		var/atom/movable/AM = expected
		moveToNullspace()
		AM.vis_contents += src
		current_anchor = AM
	else
		forceMove(get_turf(expected))

/obj/effect/temp_visual/zad_tracked/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	if(current_anchor && (src in current_anchor.vis_contents))
		current_anchor.vis_contents -= src
	current_anchor = null
	return ..()

/obj/effect/temp_visual/zad_tracked/zad_flight
	icon = 'icons/roguetown/mob/monster/crow.dmi'
	icon_state = "crow_flying"
	name = "zads in flight"
	duration = ZAD_ASCEND_DURATION

/obj/effect/temp_visual/zad_tracked/zad_flight/ascend
	duration = ZAD_ASCEND_DURATION

/obj/effect/temp_visual/zad_tracked/zad_flight/ascend/Initialize()
	. = ..()
	pixel_y = 0
	alpha = 255
	animate(src, pixel_y = ZAD_FLIGHT_TRAVEL_HEIGHT, time = duration - 3, easing = SINE_EASING)
	animate(alpha = 0, time = 3)

/obj/effect/temp_visual/zad_tracked/zad_flight/descend
	duration = ZAD_DESCEND_DURATION
	alpha = 255

/obj/effect/temp_visual/zad_tracked/zad_flight/descend/Initialize()
	. = ..()
	pixel_y = ZAD_FLIGHT_TRAVEL_HEIGHT
	alpha = 255
	animate(src, pixel_y = 0, time = duration - 3, easing = SINE_EASING)
	animate(alpha = 0, time = 3)

/obj/effect/temp_visual/zad_tracked/zad_flight/descend_long
	duration = ZAD_BOMB_DESCEND_DURATION_VAR_MAX
	alpha = 0

/obj/effect/temp_visual/zad_tracked/zad_flight/descend_long/Initialize()
	. = ..()
	pixel_y = ZAD_FLIGHT_TRAVEL_HEIGHT
	alpha = 255

/obj/effect/temp_visual/zad_tracked/zad_flight/descend_long/proc/begin_descent()
	animate(src, pixel_y = 0, time = duration - 3, easing = SINE_EASING)
	animate(alpha = 0, time = 3)

/obj/effect/temp_visual/zad_tracked/zad_flight/plummet
	icon = 'icons/roguetown/mob/monster/crow.dmi'
	icon_state = "crow1"
	duration = 1.5 SECONDS

/obj/effect/temp_visual/zad_tracked/zad_flight/plummet/Initialize()
	. = ..()
	pixel_y = ZAD_FLIGHT_TRAVEL_HEIGHT
	alpha = 255
	animate(src, pixel_y = -8, time = duration - 3, easing = QUAD_EASING)
	animate(alpha = 0, time = 3)

/obj/effect/temp_visual/zad_tracked/zad_flight/arrival
	duration = 1.5 SECONDS
	icon = 'icons/roguetown/mob/monster/crow.dmi'
	icon_state = "crow"

/obj/effect/temp_visual/zad_tracked/zad_flight/arrival/Initialize()
	. = ..()
	pixel_y = 4
	animate(src, pixel_y = 0, time = 4, easing = SINE_EASING)
	animate(pixel_y = 4, time = 4, easing = SINE_EASING)
	animate(pixel_y = 0, time = 4, easing = SINE_EASING)
	animate(pixel_y = 4, time = 3, easing = SINE_EASING, flags = ANIMATION_END_NOW)

/proc/zad_world_anchor(atom/source)
	if(!source)
		return null
	if(isturf(source))
		return source
	if(isobj(source))
		var/obj/item/zadcage/cage = source
		if(istype(cage))
			var/mob/holder = cage.holder_mob()
			if(holder)
				return holder
	return source

/proc/attach_zad_effect(obj/effect/temp_visual/zad_tracked/E, atom/source)
	if(!E || !source)
		return
	if(istype(source, /obj/item/zadcage))
		E.start_tracking(source)
		return
	if(isturf(source))
		if(E.loc != source)
			E.forceMove(source)
		return
	if(!ismovable(source))
		E.forceMove(get_turf(source))
		return
	var/atom/movable/AM = source
	E.moveToNullspace()
	if(!(E in AM.vis_contents))
		AM.vis_contents += E
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(detach_zad_static_anchor), E, AM), E.duration)

/proc/detach_zad_static_anchor(obj/effect/temp_visual/zad_tracked/E, atom/movable/anchor)
	if(anchor && (E in anchor.vis_contents))
		anchor.vis_contents -= E

/proc/play_zad_ascend(atom/source, count = 1, list/payload_items = null, bomb_count = 0)
	if(!source)
		return
	for(var/i in 1 to count)
		var/obj/effect/temp_visual/zad_tracked/zad_flight/ascend/effect = new(get_turf(source))
		var/list/offsets = zad_overlay_offset(i, count)
		effect.pixel_x = offsets["x"]
		attach_zad_effect(effect, source)
	if(bomb_count > 0)
		apply_bomb_payload_overlay(source, bomb_count, ZAD_ASCEND_DURATION, "ascend")
	else
		apply_payload_overlay(source, payload_items, "ascend")

/proc/play_zad_descend(atom/source, count = 1, list/payload_items = null)
	if(!source)
		return
	for(var/i in 1 to count)
		var/obj/effect/temp_visual/zad_tracked/zad_flight/descend/effect = new(get_turf(source))
		var/list/offsets = zad_overlay_offset(i, count)
		effect.pixel_x = offsets["x"]
		attach_zad_effect(effect, source)
	apply_payload_overlay(source, payload_items, "descend")

/proc/play_zad_bomb_descend(atom/source, count = 1, bomb_count = 1, descend_time)
	if(!source)
		return
	var/effect_duration = descend_time || ZAD_BOMB_DESCEND_DURATION_VAR_MAX
	for(var/i in 1 to count)
		var/obj/effect/temp_visual/zad_tracked/zad_flight/descend_long/effect = new(get_turf(source))
		effect.duration = effect_duration
		var/list/offsets = zad_overlay_offset(i, count)
		effect.pixel_x = offsets["x"]
		attach_zad_effect(effect, source)
		effect.begin_descent()
	apply_bomb_payload_overlay(source, bomb_count, effect_duration, "descend_long")

/proc/play_zad_arrival(atom/source, count = 1)
	if(!source)
		return
	for(var/i in 1 to count)
		var/obj/effect/temp_visual/zad_tracked/zad_flight/arrival/effect = new(get_turf(source))
		var/list/offsets = zad_overlay_offset(i, count)
		effect.pixel_x = offsets["x"]
		attach_zad_effect(effect, source)

/proc/play_zad_plummet(atom/source, count = 1)
	if(!source || count <= 0)
		return
	for(var/i in 1 to count)
		var/obj/effect/temp_visual/zad_tracked/zad_flight/plummet/effect = new(get_turf(source))
		var/list/offsets = zad_overlay_offset(i, count)
		effect.pixel_x = offsets["x"] + rand(-6, 6)
		attach_zad_effect(effect, source)

/proc/apply_payload_overlay(atom/host, list/payload_items, direction)
	if(!host || !length(payload_items))
		return
	var/obj/item/I = payload_items[1]
	if(!istype(I))
		return
	var/obj/effect/temp_visual/zad_tracked/zad_payload/parcel = new(get_turf(host))
	parcel.appearance = I.appearance
	parcel.name = "[I.name] in flight"
	parcel.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	parcel.alpha = 200
	parcel.transform = matrix() * 0.6
	if(direction == "ascend")
		parcel.pixel_y = 0
		animate(parcel, pixel_y = ZAD_FLIGHT_TRAVEL_HEIGHT - 8, time = ZAD_ASCEND_DURATION - 3, easing = SINE_EASING)
		animate(alpha = 0, time = 3)
	else
		parcel.pixel_y = ZAD_FLIGHT_TRAVEL_HEIGHT - 8
		animate(parcel, pixel_y = 0, time = ZAD_DESCEND_DURATION - 3, easing = SINE_EASING)
		animate(alpha = 0, time = 3)
	attach_zad_effect(parcel, host)

/proc/apply_bomb_payload_overlay(atom/host, bomb_count, duration, mode = "descend_long")
	if(!host || bomb_count <= 0)
		return
	var/effect_duration = duration || ZAD_BOMB_DESCEND_DURATION_VAR_MAX
	var/turf/T = get_turf(host)
	var/static/list/bomb_offsets_1 = list(0)
	var/static/list/bomb_offsets_2 = list(-5, 5)
	var/static/list/bomb_offsets_3 = list(-7, 0, 7)
	var/list/bomb_xs
	switch(bomb_count)
		if(1)
			bomb_xs = bomb_offsets_1
		if(2)
			bomb_xs = bomb_offsets_2
		else
			bomb_xs = bomb_offsets_3
	for(var/x_offset in bomb_xs)
		var/obj/effect/temp_visual/zad_tracked/zad_bomb_overlay/bomb
		if(mode == "ascend")
			bomb = new /obj/effect/temp_visual/zad_tracked/zad_bomb_overlay/unlit(T)
		else
			bomb = new(T)
		bomb.pixel_x = x_offset
		bomb.duration = effect_duration
		if(mode == "ascend")
			bomb.pixel_y = -14
			bomb.alpha = 255
			animate(bomb, pixel_y = ZAD_FLIGHT_TRAVEL_HEIGHT - 14, alpha = 0, time = effect_duration, easing = SINE_EASING)
		else
			bomb.pixel_y = ZAD_FLIGHT_TRAVEL_HEIGHT - 14
			bomb.alpha = 255
			animate(bomb, pixel_y = -14, time = effect_duration - 3, easing = SINE_EASING)
			animate(alpha = 0, time = 3)
		attach_zad_effect(bomb, host)

/obj/effect/temp_visual/zad_tracked/zad_payload
	icon = 'icons/roguetown/mob/monster/crow.dmi'
	icon_state = ""
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	duration = ZAD_ASCEND_DURATION
	randomdir = FALSE

/obj/effect/temp_visual/zad_tracked/zad_bomb_overlay
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "bbomb-lit"
	name = "armed bottlebomb"
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_MOB_LAYER
	duration = ZAD_BOMB_DESCEND_DURATION_VAR_MAX
	randomdir = FALSE

/obj/effect/temp_visual/zad_tracked/zad_bomb_overlay/Initialize()
	. = ..()
	transform = matrix() * 0.65

/obj/effect/temp_visual/zad_tracked/zad_bomb_overlay/unlit
	icon_state = "bbomb"
	name = "bottlebomb"
	duration = ZAD_ASCEND_DURATION

/proc/zad_overlay_offset(index, total)
	var/list/two_offsets = list(-4, 4)
	var/list/three_offsets = list(-6, 0, 6)
	switch(total)
		if(2)
			return list("x" = two_offsets[index])
		if(3)
			return list("x" = three_offsets[index])
		else
			return list("x" = 0)
