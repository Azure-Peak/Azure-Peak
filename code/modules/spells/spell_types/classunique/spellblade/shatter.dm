/datum/action/cooldown/spell/shatter
	name = "Shatter"
	desc = "What the blade cannot cut, the mace breaks. Smash a 3-tile line with arcyne force, knocking targets back 1 tile. \
		Does not build momentum. At 3+ momentum: consumes 3 to double damage. \
		Strikes your aimed bodypart. Can be deflected by Defend stance."
	button_icon = 'icons/mob/actions/classuniquespells/spellblade.dmi'
	button_icon_state = "shatter"
	sound = 'sound/combat/ground_smash1.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM

	cast_range = 7

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_SB_POKE

	invocations = list("Frange!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = 3
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/line_length = 3
	var/base_damage = 30
	var/empowered_mult = 2
	var/push_dist = 1
	var/momentum_cost = 3
	var/telegraph_delay = 4

/datum/action/cooldown/spell/shatter/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		to_chat(H, span_warning("I need my bound weapon in hand!"))
		return FALSE

	var/turf/target_turf = get_turf(cast_on)
	var/turf/start = get_turf(H)
	var/facing = get_dir(start, target_turf) || H.dir

	var/empowered = FALSE
	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(M && M.stacks >= momentum_cost)
		M.consume_stacks(momentum_cost)
		empowered = TRUE
		to_chat(H, span_notice("[momentum_cost] momentum released - empowered shatter!"))

	var/damage = empowered ? (base_damage * empowered_mult) : base_damage

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
		return FALSE

	// Telegraph - show warning on affected tiles
	for(var/turf/T in line_turfs)
		new /obj/effect/temp_visual/air_strike_telegraph(T)

	// Grunt as they wind up the swing
	H.emote("attackgrunt", forced = TRUE)

	addtimer(CALLBACK(src, PROC_REF(resolve_shatter), H, line_turfs, facing, damage, empowered), telegraph_delay)
	return TRUE

/datum/action/cooldown/spell/shatter/proc/resolve_shatter(mob/living/carbon/human/H, list/line_turfs, facing, damage, empowered)
	if(QDELETED(H) || H.stat == DEAD)
		return

	var/obj/item/held_weapon = arcyne_get_weapon(H)
	if(!held_weapon)
		return

	var/def_zone = H.zone_selected || BODY_ZONE_CHEST

	// Visual and sound effects
	for(var/turf/T in line_turfs)
		new /obj/effect/temp_visual/kinetic_blast(T)
	playsound(get_turf(H), pick('sound/combat/ground_smash1.ogg', 'sound/combat/ground_smash2.ogg', 'sound/combat/ground_smash3.ogg'), 80, TRUE)

	H.emote("attack", forced = TRUE)

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

	var/datum/status_effect/buff/arcyne_momentum/M = H.has_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(hit_count >= 2)
		if(M)
			M.add_stacks(1)
			to_chat(H, span_notice("DOUBLE STRIKE! ARCYNE SURGE!"))

	log_combat(H, null, "used Shatter")
