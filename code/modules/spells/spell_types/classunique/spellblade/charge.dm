/* Charge! - Spellblade combat dash.
4 rapid steps forward in the user's facing direction, shoving
anyone in the path to the sides for zero damage.
Instant self-cast, no empowerment, pure mobility/utility. */

/obj/effect/proc_holder/spell/self/charge
	name = "Charge!"
	desc = "Infuse mana into your legs, dashing forward four paces — \
		ramming everyone in your path to the sides for no damage."
	clothes_req = FALSE
	range = 7
	action_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	overlay_state = "advance" // Icon by Prominence. Shared with Advance since the spells are very similar.
	releasedrain = SPELLCOST_SB_MOBILITY
	chargedrain = 0
	chargetime = 0
	recharge_time = 12 SECONDS
	invocations = list()
	invocation_type = "none"
	gesture_required = FALSE
	xp_gain = FALSE
	var/charge_steps = 4
	var/step_delay = 2

/obj/effect/proc_holder/spell/self/charge/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/facing = H.dir
	var/turf/start = get_turf(H)
	var/turf/first_step = get_step(start, facing)
	if(!first_step || first_step.density)
		to_chat(H, span_warning("There's no room to charge!"))
		revert_cast()
		return

	if(H.buckled)
		H.buckled.unbuckle_mob(H, TRUE)

	H.say("Impete!", forced = "spell")
	H.visible_message(
		span_warning("[H] barrels forward!"),
		span_notice("I charge!"))
	playsound(start, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 60, TRUE)

	// Compute perpendicular directions for side-shoving
	var/list/perp_dirs = get_perpendicular_dirs(facing)
	var/shove_toggle = 0

	var/steps_taken = 0
	for(var/i in 1 to charge_steps)
		if(H.stat != CONSCIOUS || H.IsParalyzed() || H.IsStun() || QDELETED(H))
			break
		var/turf/next = get_step(get_turf(H), facing)
		if(!next || next.density)
			break

		var/blocked = FALSE
		for(var/obj/structure/S in next.contents)
			if(S.density)
				blocked = TRUE
				break
		if(blocked)
			break

		// Shove mobs on the next tile to the sides before stepping in
		for(var/mob/living/victim in next)
			if(victim == H || victim.stat == DEAD)
				continue
			var/shove_dir = perp_dirs[(shove_toggle % 2) + 1]
			shove_toggle++
			var/turf/shove_dest = get_step(get_turf(victim), shove_dir)
			if(shove_dest && !shove_dest.density)
				victim.safe_throw_at(shove_dest, 1, 1, H, force = MOVE_FORCE_STRONG)
				victim.visible_message(span_warning("[victim] is shoved aside by [H]'s charge!"))

		step(H, facing)
		steps_taken++
		new /obj/effect/temp_visual/kinetic_blast(get_turf(H))

		if(i < charge_steps)
			sleep(step_delay)

	if(steps_taken == 0)
		to_chat(H, span_warning("My charge is blocked!"))
		return

	log_combat(H, null, "used Charge!")
	return TRUE

/obj/effect/proc_holder/spell/self/charge/proc/get_perpendicular_dirs(dir)
	switch(dir)
		if(NORTH, SOUTH)
			return list(WEST, EAST)
		if(EAST, WEST)
			return list(NORTH, SOUTH)
		if(NORTHEAST)
			return list(NORTHWEST, SOUTHEAST)
		if(NORTHWEST)
			return list(NORTHEAST, SOUTHWEST)
		if(SOUTHEAST)
			return list(NORTHEAST, SOUTHWEST)
		if(SOUTHWEST)
			return list(NORTHWEST, SOUTHEAST)
	return list(WEST, EAST)
