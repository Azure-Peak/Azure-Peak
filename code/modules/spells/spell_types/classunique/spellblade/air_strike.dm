/* The bread & butter poke and ranged attack of the blade subclass.
Since you need normal attack to build momentum, at higher momentum it
is empowered for double damage.

The ability to turn it from a perpendicular slash (Cut) to parallel AP
Stab (Stab) or single-target integrity nuke (Blunt) add some skill
expression and complexity to the spell, to Blade's otherwise 3
unique spells only toolkit. It is about adapting to the situation at
hand and I intend for Spellblade, feeling wise.
*/
/obj/effect/proc_holder/spell/invoked/air_strike
	name = "Air Strike"
	desc = "Your blade passes into the immaterial and the leyline carries it forth, striking up to 4 tiles away. \
	Brief telegraph before the strike lands — aim where they will be. \
	At 3+ momentum: consumes 3 to double damage. \
	Strikes your aimed bodypart. Adaptable to intent: \
		- Cut: 3x1 perpendicular line, multiple targets. (30/60 damage) \
		- Stab: 3x1 forward line, pierces through enemies. (20/40 damage, 25 AP) \
		- Blunt: All force focused on a single target. (45/90 damage)"
	clothes_req = FALSE
	range = 4
	action_icon = 'icons/mob/actions/spellblade.dmi'
	overlay_state = "air_strike" // Icon by Prominence.
	releasedrain = 20
	chargedrain = 0
	chargetime = 3
	recharge_time = 12 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 0
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("Ictus Venti!")
	invocation_type = "shout"
	gesture_required = TRUE
	xp_gain = FALSE
	var/cut_damage = 30
	var/stab_damage = 20
	var/stab_ap = 25 // AP pierce low grade leather armor (40) unempowered, pierce hardened leather (50), but not light brig
	var/blunt_damage = 45
	var/empowered_mult = 2
	var/momentum_cost = 3

/obj/effect/proc_holder/spell/invoked/air_strike/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		revert_cast()
		return

	var/atom/target = targets[1]
	var/turf/target_turf = get_turf(target)
	if(!target_turf)
		revert_cast()
		return

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released — empowered strike!"))

	var/facing = get_dir(get_turf(H), target_turf) || H.dir
	var/datum/intent/current_intent = H.a_intent
	var/blade_class = current_intent?.blade_class || BCLASS_CUT

	switch(blade_class)
		if(BCLASS_STAB, BCLASS_PICK)
			do_stab_strike(H, held_weapon, empowered, target_turf, facing)
		if(BCLASS_BLUNT, BCLASS_SMASH)
			do_blunt_strike(H, held_weapon, empowered, target_turf)
		else
			do_cut_strike(H, held_weapon, empowered, target_turf, facing)

	return TRUE

/obj/effect/proc_holder/spell/invoked/air_strike/proc/do_cut_strike(mob/living/carbon/human/H, obj/item/weapon, empowered, turf/origin, facing)
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST
	var/damage = empowered ? (cut_damage * empowered_mult) : cut_damage

	var/list/affected_turfs = get_perpendicular_line(origin, facing)

	// Telegraph — spellwarning on affected tiles
	for(var/turf/T in affected_turfs)
		new /obj/effect/temp_visual/air_strike_telegraph(T)

	addtimer(CALLBACK(src, PROC_REF(resolve_cut_strike), H, weapon, empowered, affected_turfs, damage, def_zone, facing), 2)

/obj/effect/proc_holder/spell/invoked/air_strike/proc/resolve_cut_strike(mob/living/carbon/human/H, obj/item/weapon, empowered, list/affected_turfs, damage, def_zone, facing)
	if(QDELETED(H) || H.stat == DEAD)
		return

	for(var/turf/T in affected_turfs)
		var/obj/effect/temp_visual/blade_cut/V = new(T)
		V.dir = facing
	playsound(affected_turfs[1], pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 80, TRUE)

	var/hit_count = 0
	var/deflected = FALSE
	for(var/turf/T in affected_turfs)
		for(var/mob/living/victim in T)
			if(victim == H || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, deflected ? null : H))
				deflected = TRUE
				continue
			if(empowered)
				arcyne_strike(H, victim, weapon, round(damage / 2), def_zone, BCLASS_CUT, spell_name = "Air Strike (Cut)", skip_message = TRUE)
				arcyne_strike(H, victim, weapon, round(damage / 2), def_zone, BCLASS_CUT, spell_name = "Air Strike (Cut)")
			else
				arcyne_strike(H, victim, weapon, damage, def_zone, BCLASS_CUT, spell_name = "Air Strike (Cut)")
			hit_count++

	if(hit_count)
		H.visible_message(span_danger("[H] sweeps [weapon.name] in a wide arcyne arc!"))
	else
		H.visible_message(span_notice("[H] sweeps [weapon.name] through the air!"))
	if(hit_count >= 2)
		var/datum/status_effect/buff/arcyne_momentum/surge = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
		if(surge)
			surge.add_stacks(1)
			to_chat(H, span_notice("DOUBLE STRIKE! ARCYNE SURGE!"))

/obj/effect/proc_holder/spell/invoked/air_strike/proc/do_stab_strike(mob/living/carbon/human/H, obj/item/weapon, empowered, turf/origin, facing)
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST
	var/damage = empowered ? (stab_damage * empowered_mult) : stab_damage

	var/list/affected_turfs = get_forward_line(origin, facing, 3)

	// Telegraph — spellwarning on affected tiles
	for(var/turf/T in affected_turfs)
		new /obj/effect/temp_visual/air_strike_telegraph(T)

	addtimer(CALLBACK(src, PROC_REF(resolve_stab_strike), H, weapon, empowered, affected_turfs, damage, def_zone, facing), 2)

/obj/effect/proc_holder/spell/invoked/air_strike/proc/resolve_stab_strike(mob/living/carbon/human/H, obj/item/weapon, empowered, list/affected_turfs, damage, def_zone, facing)
	if(QDELETED(H) || H.stat == DEAD)
		return

	for(var/turf/T in affected_turfs)
		var/obj/effect/temp_visual/blade_burst/V = new(T)
		V.dir = facing
	playsound(affected_turfs[1], pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 80, TRUE)

	var/hit_count = 0
	var/deflected = FALSE
	for(var/turf/T in affected_turfs)
		for(var/mob/living/victim in T)
			if(victim == H || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, deflected ? null : H))
				deflected = TRUE
				continue
			if(empowered)
				arcyne_strike(H, victim, weapon, round(damage / 2), def_zone, BCLASS_STAB, armor_penetration = stab_ap, spell_name = "Air Strike (Stab)", skip_message = TRUE)
				arcyne_strike(H, victim, weapon, round(damage / 2), def_zone, BCLASS_STAB, armor_penetration = stab_ap, spell_name = "Air Strike (Stab)")
			else
				arcyne_strike(H, victim, weapon, damage, def_zone, BCLASS_STAB, armor_penetration = stab_ap, spell_name = "Air Strike (Stab)")
			hit_count++

	if(hit_count)
		H.visible_message(span_danger("[H] thrusts [weapon.name] forward, sending an arcyne lance through the air!"))
	else
		H.visible_message(span_notice("[H] thrusts [weapon.name] forward, sending an arcyne lance through empty air!"))
	if(hit_count >= 2)
		var/datum/status_effect/buff/arcyne_momentum/surge = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
		if(surge)
			surge.add_stacks(1)
			to_chat(H, span_notice("DOUBLE STRIKE! ARCYNE SURGE!"))

/obj/effect/proc_holder/spell/invoked/air_strike/proc/do_blunt_strike(mob/living/carbon/human/H, obj/item/weapon, empowered, turf/origin)
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST
	var/damage = empowered ? (blunt_damage * empowered_mult) : blunt_damage

	// Telegraph — spellwarning on target tile
	new /obj/effect/temp_visual/air_strike_telegraph(origin)

	addtimer(CALLBACK(src, PROC_REF(resolve_blunt_strike), H, weapon, empowered, origin, damage, def_zone), 2)

/obj/effect/proc_holder/spell/invoked/air_strike/proc/resolve_blunt_strike(mob/living/carbon/human/H, obj/item/weapon, empowered, turf/origin, damage, def_zone)
	if(QDELETED(H) || H.stat == DEAD)
		return

	new /obj/effect/temp_visual/kinetic_blast(origin)
	playsound(origin, pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg', 'sound/combat/wooshes/bladed/wooshsmall (2).ogg'), 80, TRUE)

	var/mob/living/victim = null
	for(var/mob/living/L in origin)
		if(L == H || L.stat == DEAD)
			continue
		victim = L
		break

	if(!victim)
		H.visible_message(span_notice("[H] slams [weapon.name] down, sending a shockwave into the ground!"))
		return

	if(spell_guard_check(victim, FALSE, H))
		return

	if(empowered)
		arcyne_strike(H, victim, weapon, round(damage / 2), def_zone, BCLASS_BLUNT, spell_name = "Air Strike (Blunt)", skip_message = TRUE)
		arcyne_strike(H, victim, weapon, round(damage / 2), def_zone, BCLASS_BLUNT, spell_name = "Air Strike (Blunt)")
	else
		arcyne_strike(H, victim, weapon, damage, def_zone, BCLASS_BLUNT, spell_name = "Air Strike (Blunt)")
	H.visible_message(span_danger("[H] slams [weapon.name] down, focusing all arcyne force into [victim]!"))

/obj/effect/proc_holder/spell/invoked/air_strike/proc/get_perpendicular_line(turf/center, facing)
	var/list/turfs = list()
	turfs += center
	var/perp_dir1
	var/perp_dir2
	if(facing == NORTH || facing == SOUTH)
		perp_dir1 = WEST
		perp_dir2 = EAST
	else
		perp_dir1 = NORTH
		perp_dir2 = SOUTH
	var/turf/left = get_step(center, perp_dir1)
	var/turf/right = get_step(center, perp_dir2)
	if(left) turfs += left
	if(right) turfs += right
	return turfs

/obj/effect/proc_holder/spell/invoked/air_strike/proc/get_forward_line(turf/center, facing, length = 3)
	var/list/turfs = list()
	turfs += center
	var/turf/current = center
	for(var/i in 1 to (length - 1))
		current = get_step(current, facing)
		if(!current)
			break
		turfs += current
	return turfs

/obj/effect/temp_visual/air_strike_telegraph
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 1
	duration = 3
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/arcyne_strike_fx
	icon = 'icons/effects/effects.dmi'
	icon_state = "strike"
	duration = 5
	layer = MASSIVE_OBJ_LAYER
