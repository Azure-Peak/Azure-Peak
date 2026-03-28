/datum/action/cooldown/spell/ascension
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "Ascension"
	desc = "Channel all of your arcyne potential into another, granting them every augmentation at once - \
	Haste, Stoneskin, Giant's Strength, Fortitude, Hawk's Eyes, and Guidance. \
	This spell drains an enormous amount of energy from the caster and cannot be used on oneself."
	button_icon_state = "stoneskin"
	sound = 'sound/magic/charging.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_VERY_HIGH
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_ULTIMATE
	secondary_resource_type = SPELL_COST_ENERGY
	secondary_resource_cost = 600

	invocations = list("Ascende, Ultra Omnia!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = TRUE
	charge_time = CHARGETIME_HEAVY
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 120 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_impact_intensity = SPELL_IMPACT_HIGH

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	var/buff_duration = STAT_BUFF_ALLY_DURATION

/datum/action/cooldown/spell/ascension/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/target = cast_on

	if(target == H)
		to_chat(H, span_warning("This power is too great to channel into myself!"))
		return FALSE

	target.apply_status_effect(/datum/status_effect/buff/haste, buff_duration)
	target.apply_status_effect(/datum/status_effect/buff/stoneskin, buff_duration)
	target.apply_status_effect(/datum/status_effect/buff/giants_strength, buff_duration)
	target.apply_status_effect(/datum/status_effect/buff/fortitude, buff_duration)
	target.apply_status_effect(/datum/status_effect/buff/hawks_eyes, buff_duration)
	target.apply_status_effect(/datum/status_effect/buff/guidance, buff_duration)

	to_chat(target, span_notice("Arcyne power surges through every fiber of my being!"))
	to_chat(H, span_notice("I channel everything into [target] - ascending them beyond mortal limits!"))
	target.visible_message(span_warning("[target] radiates with overwhelming arcyne energy!"))
	new /obj/effect/temp_visual/spell_impact(get_turf(target), spell_color, spell_impact_intensity)
	return TRUE
