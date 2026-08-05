/datum/action/cooldown/spell/augment_buff
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	charge_swingdelay_type = SWINGDELAY_PENALTY
	charge_time = CHARGETIME_MINOR
	hold_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 90 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	supports_fellowship_snap = TRUE

	var/self_cast_cooldown_multiplier = 1
	var/other_cast_cooldown_reduction = 0.25
	/// TRUE only while resolving a self-targeted cast, so the cooldown hook knows to apply the penalty.
	var/tmp/empowering_self = FALSE

/datum/action/cooldown/spell/augment_buff/before_cast(atom/cast_on)
	empowering_self = (cast_on == owner)
	return ..()

/datum/action/cooldown/spell/augment_buff/after_cast(atom/cast_on)
	. = ..()
	empowering_self = FALSE

/datum/action/cooldown/spell/augment_buff/get_adjusted_cooldown()
	var/original_cooldown = cooldown_time
	if(!empowering_self && other_cast_cooldown_reduction)
		cooldown_time = original_cooldown * (1 - other_cast_cooldown_reduction)
	. = ..()
	cooldown_time = original_cooldown
	if(empowering_self && self_cast_cooldown_multiplier != 1)
		. *= self_cast_cooldown_multiplier

/datum/action/cooldown/spell/augment_buff/get_cooldown_stat_lines(mob/living/user)
	var/list/lines = list()
	var/base_cd = cooldown_time
	if(!base_cd)
		return lines
	if(!user)
		lines += span_info("Cooldown: [DisplayTimeText(base_cd)]")
		return lines

	empowering_self = TRUE
	var/self_cd = get_adjusted_cooldown()
	empowering_self = FALSE
	var/ally_cd = get_adjusted_cooldown()
	empowering_self = FALSE

	lines += span_info("Cooldown: [DisplayTimeText(base_cd)]")
	if(!self_cast_possible)
		// Ally-only augmentation - self_cd is never reachable, so show one figure.
		if(abs(ally_cd - base_cd) > 0.5)
			lines += span_info("&nbsp;&nbsp;Current: [DisplayTimeText(ally_cd)]")
	else if(abs(ally_cd - self_cd) > 0.5)
		lines += span_info("&nbsp;&nbsp;Self-cast: [DisplayTimeText(self_cd)]")
		lines += span_info("&nbsp;&nbsp;Ally-cast: [DisplayTimeText(ally_cd)]")
	else if(abs(self_cd - base_cd) > 0.5)
		lines += span_info("&nbsp;&nbsp;Current: [DisplayTimeText(self_cd)]")
	var/list/cd_breakdown = get_cooldown_breakdown(user)
	if(length(cd_breakdown))
		lines += cd_breakdown
	var/time_left = max(next_use_time - world.time, 0)
	if(time_left > 0)
		lines += span_warning("Remaining: [DisplayTimeText(time_left)]")
	return lines

/datum/action/cooldown/spell/augment_buff/get_spell_statistics(mob/living/user)
	var/list/stats = ..()
	stats += span_info("Fellowship Mode (toggle with Shift+G): an off-target cast snaps the buff to your nearest fellowship member in range.")
	if(other_cast_cooldown_reduction)
		stats += span_info("Casting this on someone other than yourself cuts [round(other_cast_cooldown_reduction * 100)]% off the cooldown (before stat scaling).")
	if(self_cast_cooldown_multiplier != 1)
		stats += span_info("Casting this on yourself instead of a fellow costs [self_cast_cooldown_multiplier]x the cooldown.")
	return stats
