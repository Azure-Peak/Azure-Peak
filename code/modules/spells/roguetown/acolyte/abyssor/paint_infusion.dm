/datum/status_effect/infusion
	id = "Pylon Infusion"
	duration = 20 MINUTES
	tick_interval = 2 SECONDS
	status_type = STATUS_EFFECT_UNIQUE

	/// Weak reference back to the original source pylon
	var/datum/weakref/pylon_ref
	/// The tether bounding parameters
	var/max_range = 5
	/// Tracking variable to ensure warning alerts only dispatch once when breaking boundary lines
	var/out_of_range = FALSE
	/// The decay multiplier when out of range (10x = 20 minutes compresses to 2 minutes)
	var/decay_multiplier = 10
	/// The last tick time we processed (to handle variable tick intervals)
	var/last_tick_time = 0
	/// The total "effective" time consumed (accounting for acceleration)
	var/total_effective_consumed = 0
	/// The original duration (stored for ratio calculations)
	var/original_duration = 20 MINUTES
	var/image/pylon_outline

/datum/status_effect/infusion/on_creation(mob/living/new_owner, obj/structure/dream_pylon/source_pylon)
	if(source_pylon)
		pylon_ref = WEAKREF(source_pylon)
	last_tick_time = world.time
	original_duration = initial(duration)
	. = ..()
	if(owner && source_pylon)
		var/outline_color = source_pylon.pylon_color ? source_pylon.pylon_color : "#7A288A"
		update_pylon_outline(source_pylon, outline_color)

/datum/status_effect/infusion/Destroy()
	if(pylon_outline)
		if(owner?.client)
			owner.client.images -= pylon_outline
		qdel(pylon_outline)
		pylon_outline = null
	return ..()

/datum/status_effect/infusion/tick(wait)
	var/obj/structure/dream_pylon/P = pylon_ref?.resolve()

	if(!P || QDELETED(P))
		to_chat(owner, span_userdanger("You feel your link sever as the source pylon is completely destroyed!"))
		qdel(src)
		return

	var/distance = get_dist(owner, P)
	var/is_mismatched = (P.infusion_payload != type)
	var/is_far = (distance > max_range)

	var/time_passed = world.time - last_tick_time
	last_tick_time = world.time

	var/effective_time_consumed = time_passed

	if(is_mismatched || is_far)
		if(!out_of_range)
			out_of_range = TRUE
			if(is_mismatched)
				to_chat(owner, span_warning("The source pylon's essence no longer matches your infusion! Your link begins decaying rapidly."))
			else
				to_chat(owner, span_warning("You have wandered too far from the pylon! Your infusion begins decaying rapidly."))
			update_pylon_outline(P, COLOR_RED)

		effective_time_consumed = time_passed * decay_multiplier
		duration -= time_passed * (decay_multiplier - 1)

	else if(out_of_range && !is_mismatched)
		out_of_range = FALSE
		to_chat(owner, span_notice("You have stepped back into range of the pylon. Your infusion stabilizes."))
		var/outline_color = P.pylon_color ? P.pylon_color : "#7A288A"
		update_pylon_outline(P, outline_color)

	total_effective_consumed += effective_time_consumed

/datum/status_effect/infusion/proc/refund_charge()
	var/obj/structure/dream_pylon/P = pylon_ref?.resolve()
	if(!P || QDELETED(P))
		qdel(src)
		return

	// Calculate ratio of what's remaining based on original duration
	var/ratio_consumed = total_effective_consumed / original_duration
	var/ratio_remaining = max(0, 1 - ratio_consumed)

	var/charge_to_restore = round(P.charge_cost_per_use * ratio_remaining)
	P.charge = min(P.max_charge, P.charge + charge_to_restore)

	to_chat(owner, "<span class='notice'>You touch the edge of the pylon, letting the paint ooze back into the ball. [charge_to_restore] energy points flow back to the pylon.</span>")
	P.update_pylon_appearance()
	qdel(src)

/datum/status_effect/infusion/proc/update_pylon_outline(obj/structure/dream_pylon/P, new_color)
	if(!owner?.client || !P)
		return
	var/alpha_hex = "80"
	var/final_color = new_color
	if(length(new_color) == 7 && copytext(new_color, 1, 2) == "#")
		final_color = "[new_color][alpha_hex]"

	if(pylon_outline)
		pylon_outline.filters = null
		pylon_outline.filters += filter(type = "outline", size = 1, color = final_color)
	else
		var/image/I = image(icon = P.icon, loc = P, icon_state = P.icon_state, layer = P.layer + 0.05)

		if(P.active_overlay)
			I.overlays += image(icon = P.active_overlay.icon, icon_state = P.active_overlay.icon_state)

		I.filters += filter(type = "outline", size = 1, color = final_color)

		pylon_outline = I
		owner.client.images += pylon_outline
