/datum/action/cooldown/spell/charge
	name = "Charge!"
	desc = "Infuse mana into your legs, dashing forward four paces - \
		ramming everyone in your path to the sides for no damage."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "advance"
	sound = 'sound/combat/wooshes/bladed/wooshsmall (1).ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_MOBILITY

	invocations = list()
	invocation_type = INVOCATION_NONE

	charge_required = FALSE
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/charge_steps = 4
	var/step_delay = 2

/datum/action/cooldown/spell/charge/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/facing = H.dir
	var/turf/start = get_turf(H)
	var/turf/first_step = get_step(start, facing)
	if(!first_step || first_step.density)
		to_chat(H, span_warning("There's no room to charge!"))
		return FALSE

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
		return FALSE

	log_combat(H, null, "used Charge!")
	return TRUE

/datum/action/cooldown/spell/charge/proc/get_perpendicular_dirs(dir)
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
