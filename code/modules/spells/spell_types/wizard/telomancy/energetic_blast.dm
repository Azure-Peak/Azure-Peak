/datum/action/cooldown/spell/energetic_blast
	button_icon = 'icons/mob/actions/mage_telomancy.dmi'
	name = "Energetic Blast"
	desc = "Channel a wave of raw arcyne energy in a 4-tile line in front of you, striking foes for blunt damage and hurling them back 3 paces. \
	Can be blocked by a shield, stopping the blast from propagating further."
	button_icon_state = "energetic_blast"
	sound = 'sound/magic/vlightning.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_MEDIUM
	attunement_school = ASPECT_NAME_TELOMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_PROJECTILE

	invocations = list("Pulsus Arcani!")
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
	spell_impact_intensity = SPELL_IMPACT_MEDIUM

	var/line_length = 4
	var/blast_damage = 55
	var/push_dist = 3

/datum/action/cooldown/spell/energetic_blast/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

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
		new /obj/effect/temp_visual/spell_impact(T, spell_color, spell_impact_intensity)
		new /obj/effect/temp_visual/energetic_blast(T)

	playsound(start, 'sound/magic/vlightning.ogg', 100, TRUE, 4)

	var/list/already_hit = list()
	var/blocked = FALSE
	for(var/turf/T in line_turfs)
		if(blocked)
			break
		var/list/victims_here = list()
		for(var/mob/living/L in T)
			victims_here += L
		for(var/mob/living/victim as anything in victims_here)
			if(victim == H || (victim in already_hit))
				continue
			if(victim.anti_magic_check())
				victim.visible_message(span_warning("The arcyne wave dissipates against [victim]!"))
				continue
			if(spell_guard_check(victim, FALSE, H))
				blocked = TRUE
				continue
			var/damage_dealt = arcyne_strike(H, victim, null, blast_damage, BODY_ZONE_CHEST, \
				BCLASS_BLUNT, spell_name = "Energetic Blast", \
				allow_shield_check = TRUE, damage_type = BRUTE, \
				skip_animation = TRUE)
			if(!damage_dealt)
				blocked = TRUE
			new /obj/effect/temp_visual/spell_impact(get_turf(victim), spell_color, spell_impact_intensity)
			already_hit += victim
			var/push_dir = get_dir(H, victim)
			if(!push_dir)
				push_dir = facing
			victim.safe_throw_at(get_ranged_target_turf(victim, push_dir, push_dist), push_dist, 2, H, force = MOVE_FORCE_STRONG)
		for(var/obj/item/I in T)
			if(I.anchored)
				continue
			var/toss_dir = get_dir(H, I)
			if(!toss_dir)
				toss_dir = facing
			I.throw_at(get_ranged_target_turf(I, toss_dir, push_dist), push_dist, 2)

	if(length(already_hit))
		H.visible_message(span_danger("[H] unleashes a wave of raw arcyne force, hurling [english_list(already_hit)] back!"))
	else
		H.visible_message(span_danger("[H] unleashes a wave of raw arcyne force!"))

	return TRUE

/obj/effect/temp_visual/energetic_blast
	icon = 'icons/effects/effects.dmi'
	icon_state = "quantum_sparks"
	name = "arcyne discharge"
	desc = "Raw mana spilling across the ground."
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER
