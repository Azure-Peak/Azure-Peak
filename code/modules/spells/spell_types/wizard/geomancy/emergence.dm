/datum/action/cooldown/spell/emergence
	button_icon = 'icons/mob/actions/mage_geomancy.dmi'
	name = "Emergence"
	desc = "Command stone to erupt from the earth, dealing heavy damage to anyone standing on the target and repelling everyone nearby back 1 pace. Leaves a temporary stone pillar behind. \
	Deals 2x damage to structures. Can be self-cast - the caster is unharmed by their own eruption. \
	The pillar blocks movement and line of sight until it crumbles or is destroyed, shattering into gravel shrapnel."
	button_icon_state = "emergence"
	sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	spell_color = GLOW_COLOR_EARTHEN
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_GEOMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Surge, Terra!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_POKE
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 12 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_MEDIUM
	is_implement_scaled_spell = TRUE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	displayed_damage = 40

	var/telegraph_delay = TELEGRAPH_SKILLSHOT
	var/direct_damage = 40
	var/aoe_damage = 15
	var/npc_simple_damage_mult = 2
	var/push_dist = 1
	var/pillar_integrity = 150

/datum/action/cooldown/spell/emergence/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/T = get_turf(cast_on)
	if(!T)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(T.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(T in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	if(T.density)
		to_chat(H, span_warning("There's no room to raise stone there!"))
		return FALSE

	for(var/obj/structure/S in T.contents)
		if(S.density)
			to_chat(H, span_warning("Something is already there!"))
			return FALSE

	new /obj/effect/temp_visual/trap/emergence(T)
	playsound(T, 'sound/combat/hits/onstone/wallhit.ogg', 60, TRUE)

	addtimer(CALLBACK(src, PROC_REF(do_emergence), T, H), telegraph_delay)
	return TRUE

/datum/action/cooldown/spell/emergence/proc/do_emergence(turf/T, mob/living/carbon/human/caster)
	if(QDELETED(caster) || caster.stat == DEAD)
		return

	playsound(T, 'sound/combat/hits/onstone/stonedeath.ogg', 100, TRUE, 4)

	// Direct hit - full damage to anyone standing on the target tile
	for(var/mob/living/victim in T.contents)
		if(victim == caster || victim.stat == DEAD)
			continue
		if(victim.anti_magic_check())
			victim.visible_message(span_warning("The erupting stone crumbles around [victim]!"))
			playsound(get_turf(victim), 'sound/magic/magic_nulled.ogg', 100)
			continue
		if(spell_guard_check(victim, TRUE))
			victim.visible_message(span_warning("[victim] braces against the eruption!"))
			continue
		var/target_zone = caster.zone_selected || BODY_ZONE_CHEST
		arcyne_strike(caster, victim, null, direct_damage, target_zone, BCLASS_BLUNT, \
			spell_name = "Emergence", damage_type = BRUTE, \
			npc_simple_damage_mult = npc_simple_damage_mult, skip_animation = TRUE)
		to_chat(victim, span_userdanger("Stone erupts beneath me!"))
		new /obj/effect/temp_visual/spell_impact(get_turf(victim), spell_color, spell_impact_intensity)
		var/push_dir = get_dir(T, victim) || get_dir(caster, victim) || pick(GLOB.cardinals)
		victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 1, caster, force = MOVE_FORCE_STRONG)

	// AOE repulse - low damage to everyone adjacent
	for(var/turf/affected in get_hear(1, T))
		if(affected == T)
			continue
		new /obj/effect/temp_visual/kinetic_blast(affected)
		for(var/mob/living/victim in affected)
			if(victim == caster || victim.stat == DEAD)
				continue
			if(victim.anti_magic_check())
				continue
			if(spell_guard_check(victim, TRUE))
				continue
			var/target_zone = caster.zone_selected || BODY_ZONE_CHEST
			arcyne_strike(caster, victim, null, aoe_damage, target_zone, BCLASS_BLUNT, \
				spell_name = "Emergence", damage_type = BRUTE, \
				npc_simple_damage_mult = npc_simple_damage_mult, skip_animation = TRUE)
			var/push_dir = get_dir(T, victim)
			if(!push_dir)
				push_dir = get_dir(caster, victim) || pick(GLOB.cardinals)
			victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 1, caster, force = MOVE_FORCE_STRONG)

	// Structural damage - 2x to structures in the entire AOE
	for(var/turf/struct_turf in get_hear(1, T))
		for(var/obj/structure/S in struct_turf)
			S.take_damage(direct_damage, BRUTE, "blunt", object_damage_multiplier = 2)

	// Spawn the pillar - lasts until the spell is off cooldown
	new /obj/effect/temp_visual/kinetic_blast(T)
	var/obj/structure/earthen_pillar/pillar = new(T)
	pillar.max_integrity = pillar_integrity
	pillar.obj_integrity = pillar_integrity
	pillar.caster_ref = WEAKREF(caster)
	QDEL_IN(pillar, cooldown_time)

/obj/structure/earthen_pillar
	name = "stone pillar"
	desc = "A pillar of conjured stone. Sturdy, but not indestructible. Shatters into gravel when destroyed."
	icon = 'icons/obj/flora/rocks.dmi'
	icon_state = "basalt1"
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	density = TRUE
	opacity = TRUE
	max_integrity = 150
	anchored = TRUE
	var/datum/weakref/caster_ref
	var/fragment_count = 3
	var/fragment_damage = 15

/obj/structure/earthen_pillar/Destroy()
	caster_ref = null
	return ..()

/obj/structure/earthen_pillar/obj_break()
	shatter_fragments()
	return ..()

/obj/structure/earthen_pillar/proc/shatter_fragments()
	var/turf/T = get_turf(src)
	if(!T)
		return
	var/mob/caster = caster_ref?.resolve()
	var/list/dirs = list(NORTH, SOUTH, EAST, WEST, NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	for(var/i in 1 to fragment_count)
		var/dir = pick_n_take(dirs)
		var/turf/target = get_ranged_target_turf(T, dir, 3)
		var/obj/projectile/magic/gravel_blast/frag = new(T)
		frag.damage = fragment_damage
		if(caster)
			frag.firer = caster
		frag.preparePixelProjectile(target, T)
		frag.fire()

/obj/effect/temp_visual/trap/emergence
	color = GLOW_COLOR_EARTHEN
	light_color = GLOW_COLOR_EARTHEN
	duration = TELEGRAPH_SKILLSHOT
