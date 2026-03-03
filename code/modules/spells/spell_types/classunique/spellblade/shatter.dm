/* Shatter - Macebearer lineal smash.
Pure integrity damage tool. Zero AP. Smashes everything in a 3-tile line in front of
the caster, dealing high damage and knocking them back. Doubled when empowered.
No momentum gain — use normal swings for that.*/

/obj/effect/proc_holder/spell/invoked/shatter
	name = "Shatter"
	desc = "What the blade cannot cut, the mace breaks. Smash a 3-tile line with arcyne force, knocking targets back 1 tile. Cannot penetrate armor, but inflicts high damage. \
		Does not build momentum. At 3+ momentum: consumes 3 to double damage. \
		Strikes your aimed bodypart. Can be deflected by Defend stance."
	clothes_req = FALSE
	range = 3
	action_icon = 'icons/mob/actions/spellblade.dmi' // Icon by Prominence / Nobleed
	overlay_state = "shatter"
	releasedrain = 20
	chargedrain = 0
	chargetime = 3
	recharge_time = 12 SECONDS
	warnie = "spellwarning"
	no_early_release = TRUE
	movement_interrupt = FALSE
	charging_slowdown = 0
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("Frange!")
	invocation_type = "shout"
	gesture_required = TRUE
	xp_gain = FALSE
	var/line_length = 3
	var/base_damage = 50
	var/empowered_mult = 2
	var/push_dist = 1
	var/momentum_cost = 3

/obj/effect/proc_holder/spell/invoked/shatter/cast(list/targets, mob/user = usr)
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
	var/turf/start = get_turf(H)
	var/facing = get_dir(start, target_turf) || H.dir
	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released — empowered shatter!"))

	var/damage = empowered ? (base_damage * empowered_mult) : base_damage
	var/push_dist = 1

	var/list/line_turfs = list()
	var/turf/current = start
	for(var/i in 1 to line_length)
		current = get_step(current, facing)
		if(!current || current.density)
			break
		var/struct_blocked = FALSE
		for(var/obj/structure/S in current.contents)
			if(S.density && !S.climbable)
				struct_blocked = TRUE
				break
		if(struct_blocked)
			break
		line_turfs += current

	if(!length(line_turfs))
		to_chat(H, span_warning("There's no room to swing!"))
		revert_cast()
		return

	for(var/turf/T in line_turfs)
		new /obj/effect/temp_visual/kinetic_blast(T)
	playsound(start, pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 80, TRUE)

	var/hit_count = 0
	var/deflected = FALSE
	var/list/already_hit = list()
	for(var/turf/T in line_turfs)
		for(var/mob/living/victim in T)
			if(victim == H || victim.stat == DEAD || (victim in already_hit))
				continue
			if(spell_guard_check(victim, FALSE, deflected ? null : H))
				deflected = TRUE
				continue
			if(empowered)
				arcyne_strike(H, victim, held_weapon, round(damage / 2), def_zone, BCLASS_BLUNT, spell_name = "Shatter", skip_message = TRUE)
				arcyne_strike(H, victim, held_weapon, round(damage / 2), def_zone, BCLASS_BLUNT, spell_name = "Shatter")
			else
				arcyne_strike(H, victim, held_weapon, damage, def_zone, BCLASS_BLUNT, spell_name = "Shatter")
			hit_count++
			already_hit += victim
			var/push_dir = get_dir(H, victim)
			if(!push_dir)
				push_dir = facing
			victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 1, H, force = MOVE_FORCE_STRONG)

	if(hit_count)
		H.visible_message(span_danger("[H] smashes [H.p_their()] [held_weapon.name] forward in a devastating line!"))
	else
		H.visible_message(span_notice("[H] smashes [H.p_their()] [held_weapon.name] forward!"))
	if(hit_count >= 2)
		if(M)
			M.add_stacks(1)
			to_chat(H, span_notice("DOUBLE STRIKE! ARCYNE SURGE!"))

	log_combat(H, null, "used Shatter")
	return TRUE
