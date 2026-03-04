/* Tremor - Macebearer self-centered repulse.
Slam the ground, damage and push everyone adjacent away.
Knockback only. The flail special as a spell.

Invoked (click to release) but self-centered — hits everyone in
1-tile radius around the caster and pushes them outward.

At 3+ momentum: consumes 3 stacks, doubles damage and push distance.
Builds 1 momentum if any target hit.
Respects spell_guard_check. */

/obj/effect/proc_holder/spell/invoked/tremor
	name = "Tremor"
	desc = "The earth answers. Slam the ground with arcyne force, damaging and pushing back everyone adjacent 1 tile. \
		Builds 1 momentum on hit. \
		At 3+ momentum: consumes 3 to double damage. \
		Can be deflected by Defend stance."
	clothes_req = FALSE
	range = 1
	ignore_los = TRUE
	action_icon = 'icons/mob/actions/spellblade.dmi' // Icon by Prominence / Nobleed
	overlay_state = "tremor"
	releasedrain = 20
	chargedrain = 0
	chargetime = 5
	recharge_time = 12 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 0
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("Tremor!")
	invocation_type = "shout"
	gesture_required = TRUE
	xp_gain = FALSE
	var/base_damage = 40
	var/empowered_mult = 2
	var/push_dist = 1
	var/momentum_cost = 3

/obj/effect/proc_holder/spell/invoked/tremor/cast(list/targets, mob/user = usr)
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		revert_cast()
		return

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		revert_cast()
		return

	var/turf/center = get_turf(H)

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released — empowered tremor!"))

	var/damage = empowered ? (base_damage * empowered_mult) : base_damage
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	playsound(center, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 100, TRUE)

	for(var/turf/T in get_hear(1, center))
		if(T != center)
			new /obj/effect/temp_visual/kinetic_blast(T)

	var/hit_count = 0
	for(var/turf/T in get_hear(1, center))
		for(var/mob/living/victim in T)
			if(victim == H || victim.stat == DEAD)
				continue
			if(spell_guard_check(victim, FALSE, hit_count == 0 ? H : null))
				continue
			if(empowered)
				arcyne_strike(H, victim, held_weapon, round(damage / 2), def_zone, BCLASS_BLUNT, spell_name = "Tremor", skip_message = TRUE)
				arcyne_strike(H, victim, held_weapon, round(damage / 2), def_zone, BCLASS_BLUNT, spell_name = "Tremor")
			else
				arcyne_strike(H, victim, held_weapon, damage, def_zone, BCLASS_BLUNT, spell_name = "Tremor")
			hit_count++
			var/push_dir = get_dir(H, victim)
			if(!push_dir)
				push_dir = pick(GLOB.cardinals)
			victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 1, H, force = MOVE_FORCE_STRONG)

	if(hit_count)
		if(M)
			M.add_stacks(1)
		H.visible_message(span_danger("[H] slams [H.p_their()] [held_weapon.name] into the ground, sending shockwaves outward!"))
	else
		H.visible_message(span_notice("[H] slams [H.p_their()] [held_weapon.name] into the ground!"))
	if(hit_count >= 2)
		if(M)
			M.add_stacks(1)
			to_chat(H, span_notice("DOUBLE STRIKE! ARCYNE SURGE!"))

	log_combat(H, null, "used Tremor")
	return TRUE
