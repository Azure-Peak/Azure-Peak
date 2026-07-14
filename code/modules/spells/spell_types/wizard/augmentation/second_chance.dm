/datum/action/cooldown/spell/second_chance
	name = "Second Chance"
	desc = "Invigorate a target with magickal resilience for 30 seconds - they shrug off critical wounds, and no longer stagger from pain."
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	button_icon_state = "stoneskin"
	sound = 'sound/magic/charging.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = 50

	invocations = list("Iterum!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_MINOR
	charge_swingdelay_type = SWINGDELAY_PENALTY
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_MEDIUM
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 2 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/second_chance/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE
	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE
	var/mob/living/target = cast_on
	target.apply_status_effect(/datum/status_effect/buff/second_chance)
	if(target != H)
		H.Beam(target, icon_state = "b_beam", time = 1.5 SECONDS)
	target.visible_message(span_warning("[target] is wreathed in magickal light!"), \
		span_notice("Magickal resilience floods my body - I will not fall so easily!"))
	new /obj/effect/temp_visual/spell_impact(get_turf(target), spell_color, spell_impact_intensity)
	return TRUE
