// Snap Freeze - Cryomancy AOE zone-targeted ground effect
// Ported from old proc_holder system

/datum/action/cooldown/spell/snap_freeze
	button_icon = 'icons/mob/actions/mage_cryomancy.dmi'
	name = "Snap Freeze"
	desc = "Freeze the air in a small area in an instant, slowing and damaging those affected."
	button_icon_state = "snap_freeze"
	sound = 'sound/spellbooks/crystal.ogg'
	spell_color = GLOW_COLOR_ICE
	glow_intensity = GLOW_INTENSITY_HIGH
	attunement_school = ASPECT_NAME_CRYOMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_MAJOR_AOE

	invocations = list("Congelatio Subita!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 20 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 3
	point_cost = 6
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/delay = TELEGRAPH_HIGH_IMPACT
	var/damage = 65
	var/area_of_effect = 2

/datum/action/cooldown/spell/snap_freeze/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	// Reduce fire stacks on caster
	if(H.fire_stacks > 0)
		H.adjust_fire_stacks(-1)
		to_chat(H, span_notice("The frost becalms the flame on me."))

	var/turf/T = get_turf(cast_on)

	var/turf/source_turf = get_turf(H)
	if(T.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)

	if(!(T in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		if(!(affected_turf in get_hear(cast_range, source_turf)))
			continue
		new /obj/effect/temp_visual/trapice(affected_turf)
	playsound(T, 'sound/spellbooks/icicle.ogg', 80, TRUE, soundping = TRUE)

	addtimer(CALLBACK(src, PROC_REF(snap_freeze_detonate), T, source_turf, H), delay)
	return TRUE

/datum/action/cooldown/spell/snap_freeze/proc/snap_freeze_detonate(turf/T, turf/source_turf, mob/living/carbon/human/caster)
	var/play_cleave = FALSE

	for(var/turf/affected_turf in get_hear(area_of_effect, T))
		new /obj/effect/temp_visual/snap_freeze(affected_turf)
		if(!(affected_turf in get_hear(cast_range, source_turf)))
			continue
		for(var/mob/living/L in affected_turf.contents)
			if(L.anti_magic_check())
				L.visible_message(span_warning("The ice fades away around [L]!"))
				playsound(get_turf(L), 'sound/magic/magic_nulled.ogg', 100)
				continue
			if(spell_guard_check(L, TRUE))
				L.visible_message(span_warning("[L] endures the freezing blast!"))
				continue
			play_cleave = TRUE
			if(ishuman(caster) && ishuman(L))
				arcyne_strike(caster, L, null, damage, caster.zone_selected || BODY_ZONE_CHEST, \
					BCLASS_BURN, spell_name = "Snap Freeze", \
					damage_type = BURN, npc_simple_damage_mult = 1.33, \
					skip_animation = TRUE)
			else
				L.adjustFireLoss(damage + 20)
			apply_frost_stack(L)
			playsound(affected_turf, pick('sound/combat/fracture/fracturedry (1).ogg', 'sound/combat/fracture/fracturedry (2).ogg', 'sound/combat/fracture/fracturedry (3).ogg'), 80, TRUE)
			to_chat(L, span_userdanger("The air chills your bones!"))
			new /obj/effect/temp_visual/spell_impact(get_turf(L), spell_color, spell_impact_intensity)

	if(play_cleave)
		playsound(T, 'sound/spellbooks/crystal.ogg', 100, TRUE, soundping = TRUE)

