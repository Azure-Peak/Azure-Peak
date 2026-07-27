/datum/action/cooldown/spell/grenzel_meteor
	button_icon = 'icons/mob/actions/mage_geomancy.dmi'
	name = "Meteor Strike"
	desc = "Call down a single massive meteor on a location after a short delay. It obliterates structures across a 5x5 area and caves in the skull of anyone caught beneath it."
	button_icon_state = "meteor_strike"
	sound = 'sound/magic/meteorstorm.ogg'
	spell_color = GLOW_COLOR_EARTHEN
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_GEOMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Cadat Meteoron!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MAJOR
	charge_swingdelay_type = SWINGDELAY_CANCEL
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging_fire.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/blast_radius = 2
	var/impact_delay = 2 SECONDS
	var/structural_damage = 1000
	var/head_damage = 150
	displayed_damage = 150

/datum/action/cooldown/spell/grenzel_meteor/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	var/turf/center = get_turf(cast_on)
	if(!center)
		return FALSE
	if(!(center in get_hear(cast_range, get_turf(H))))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	for(var/turf/T in range(blast_radius, center))
		new /obj/effect/temp_visual/trap/meteor(T)
	center.visible_message(span_boldwarning("The sky darkens - a meteor plummets down!"))
	addtimer(CALLBACK(src, PROC_REF(drop_meteor), center), impact_delay)
	return TRUE

/datum/action/cooldown/spell/grenzel_meteor/proc/drop_meteor(turf/center)
	if(QDELETED(src) || QDELETED(owner))
		return
	new /obj/effect/temp_visual/falling_boulder(center, CALLBACK(src, PROC_REF(meteor_impact), center))

/datum/action/cooldown/spell/grenzel_meteor/proc/meteor_impact(turf/center)
	if(QDELETED(src) || QDELETED(owner))
		return
	var/mob/living/carbon/human/caster = owner
	playsound(center, 'sound/combat/hits/onstone/stonedeath.ogg', 100, TRUE, 6)
	new /obj/effect/temp_visual/spell_impact(center, spell_color, spell_impact_intensity)

	for(var/turf/T in range(blast_radius, center))
		for(var/obj/structure/S in T.contents)
			S.take_damage(structural_damage, BRUTE, "blunt", object_damage_multiplier = 2)
		T.take_damage(structural_damage, BRUTE, "blunt", object_damage_multiplier = 2)
		for(var/mob/living/L in T.contents)
			if(L == owner)
				continue
			if(L.anti_magic_check())
				L.visible_message(span_warning("The meteor fades away around [L]!"))
				continue
			if(spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L] endures the meteor strike!"))
				continue
			if(istype(caster) && ishuman(L))
				arcyne_strike(caster, L, null, head_damage, BODY_ZONE_HEAD, BCLASS_BLUNT, spell_name = "Meteor Strike", damage_type = BRUTE, skip_animation = TRUE, exact_zone = TRUE)
			else
				L.adjustBruteLoss(head_damage)
			L.Knockdown(3)
			new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)
