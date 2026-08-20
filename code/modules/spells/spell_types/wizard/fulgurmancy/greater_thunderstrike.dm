#define GTSTRIKE_DAMAGE 80
#define GTSTRIKE_TELEGRAPH 16

/datum/action/cooldown/spell/greater_thunderstrike
	button_icon = 'icons/mob/actions/mage_fulgurmancy.dmi'
	name = "Greater Thunderstrike"
	desc = "PLACEHOLDER MASTERY SPELL - may be replaced later.\n\n\
	Call a massive lightning strike that engulfs the entire area at once. \
	Damage falls off with distance from the center."
	button_icon_state = "greater_thunderstrike"
	sound = 'sound/magic/lightning.ogg'
	spell_color = GLOW_COLOR_LIGHTNING
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_FULGURMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE

	invocations = list("Caelum Fulmine Immane!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_swingdelay_type = SWINGDELAY_CANCEL
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 60 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/aoe_range = 3
	displayed_damage = GTSTRIKE_DAMAGE

/datum/action/cooldown/spell/greater_thunderstrike/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	var/turf/centerpoint = get_turf(cast_on)
	if(!centerpoint)
		return FALSE

	var/turf/source_turf = get_turf(H)
	if(centerpoint.z > H.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(centerpoint.z < H.z)
		source_turf = get_step_multiz(source_turf, DOWN)
	if(!(centerpoint in get_hear(cast_range, source_turf)))
		to_chat(H, span_warning("I can't cast where I can't see!"))
		return FALSE

	for(var/turf/T in range(aoe_range, centerpoint))
		if(!(T in get_hear(aoe_range, centerpoint)))
			continue
		new /obj/effect/temp_visual/pillar_warning/fadein(T, GTSTRIKE_TELEGRAPH)

	H.visible_message(span_boldwarning("[H] calls down a massive storm of lightning!"))
	playsound(centerpoint, 'sound/magic/charging.ogg', 80, TRUE, 6)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(thunderstrike_erupt), centerpoint, H, aoe_range, GTSTRIKE_DAMAGE, src, "Greater Thunderstrike"), GTSTRIKE_TELEGRAPH)
	return TRUE

#undef GTSTRIKE_DAMAGE
#undef GTSTRIKE_TELEGRAPH
