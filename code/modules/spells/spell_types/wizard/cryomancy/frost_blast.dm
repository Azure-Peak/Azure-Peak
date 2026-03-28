/datum/action/cooldown/spell/frost_blast
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "Frost Blast"
	desc = "Channel a blast of frost in a 4-tile line toward your target, repelling those struck back 2 paces and chilling them to the bone. \
	Can be blocked by a shield, stopping the blast from propagating further."
	button_icon_state = "frost_blast"
	sound = 'sound/spellbooks/icicle.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_CRYOMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Flumen Glaciei!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = 1 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 10 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	point_cost = 3
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	var/line_length = 4
	var/blast_damage = 40
	var/push_dist = 2

/datum/action/cooldown/spell/frost_blast/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	// Reduce fire stacks on caster
	if(H.fire_stacks > 0)
		H.adjust_fire_stacks(-1)
		to_chat(H, span_notice("The frost becalms the flame on me."))

	var/turf/start = get_turf(H)
	var/turf/target_turf = get_turf(cast_on)

	var/list/full_line = get_line(start, target_turf)
	var/list/line_turfs = list()
	for(var/i in 2 to min(length(full_line), line_length + 1))
		var/turf/T = full_line[i]
		if(!T || T.density)
			break
		line_turfs += T

	var/facing = length(line_turfs) ? get_dir(start, line_turfs[1]) : H.dir

	if(!length(line_turfs))
		return FALSE

	for(var/turf/T in line_turfs)
		new /obj/effect/temp_visual/snap_freeze(T)

	playsound(start, 'sound/spellbooks/crystal.ogg', 100, TRUE, 4)

	var/list/already_hit = list()
	var/blocked = FALSE
	for(var/turf/T in line_turfs)
		if(blocked)
			break
		for(var/mob/living/victim in T)
			if(victim == H || victim.stat == DEAD || (victim in already_hit))
				continue
			if(victim.anti_magic_check())
				victim.visible_message(span_warning("The frost fizzles on contact with [victim]!"))
				continue
			if(spell_guard_check(victim, FALSE, H))
				blocked = TRUE
				break
			// Shatter frost if target has fire
			if(victim.on_fire)
				victim.extinguish_mob()
				victim.visible_message(span_warning("The frost extinguishes [victim]!"))
			var/damage_dealt = arcyne_strike(H, victim, null, blast_damage, H.zone_selected || BODY_ZONE_CHEST, \
				BCLASS_BURN, spell_name = "Frost Blast", \
				allow_shield_check = TRUE, damage_type = BURN, \
				skip_animation = TRUE)
			if(!damage_dealt)
				blocked = TRUE
				break
			apply_frost_stack(victim, 2)
			already_hit += victim
			var/push_dir = get_dir(H, victim)
			if(!push_dir)
				push_dir = facing
			victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 2, H, force = MOVE_FORCE_STRONG)

	if(length(already_hit))
		H.visible_message(span_danger("[H] unleashes a blast of frost, sending [english_list(already_hit)] flying!"))
	else
		H.visible_message(span_danger("[H] unleashes a blast of frost!"))

	return TRUE
