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

/datum/status_effect/infusion/on_creation(mob/living/new_owner, obj/structure/dream_pylon/source_pylon)
	if(source_pylon)
		pylon_ref = WEAKREF(source_pylon)
	last_tick_time = world.time
	original_duration = initial(duration)
	return ..()

/datum/status_effect/infusion/tick(wait)
	var/obj/structure/dream_pylon/P = pylon_ref?.resolve()

	if(!P || QDELETED(P))
		to_chat(owner, "<span class='userdanger'>You feel your link sever as the source pylon is completely destroyed!</span>")
		qdel(src)
		return

	var/distance = get_dist(owner, P)
	var/was_out_of_range = out_of_range
	out_of_range = (distance > max_range)
	var/time_passed = world.time - last_tick_time
	last_tick_time = world.time

	var/effective_time_consumed = time_passed
	if(out_of_range)
		if(!was_out_of_range)
			to_chat(owner, "<span class='warning'>You have wandered too far from the pylon! Your infusion begins decaying rapidly.</span>")
		effective_time_consumed = time_passed * decay_multiplier
		duration -= time_passed * (decay_multiplier - 1)
	else if(was_out_of_range)
		to_chat(owner, "<span class='notice'>You have stepped back into range of the pylon. Your aura stabilizes.</span>")
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

	to_chat(owner, "<span class='notice'>You clear your alignment. [charge_to_restore] energy points flow back to the pylon.</span>")
	P.update_pylon_appearance()
	qdel(src)
