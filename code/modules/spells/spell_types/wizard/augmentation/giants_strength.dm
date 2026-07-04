// Giant's Strength — Augmentation buff spell (new action system)
// Status effect kept in buffs_debuffs/giants_strength.dm
/datum/action/cooldown/spell/giants_strength
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "Giant's Strength"
	desc = "Strengthen the target. (+3 Strength)\nCasting on another person extends the duration."
	button_icon_state = "giants_strength"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Vis Gigantis.")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	charge_then_click = TRUE
	cooldown_time = 2 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 2

	point_cost = 3
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/giants_strength/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H] mutters an incantation and [spelltarget]'s muscles strengthen and grow.")
		to_chat(H, span_notice("With another person as a conduit, my spell's duration is extended."))
		spelltarget.apply_status_effect(/datum/status_effect/buff/giants_strength, STAT_BUFF_ALLY_DURATION)
	else
		H.visible_message("[H] mutters an incantation and their muscles strengthen and grow.")
		spelltarget.apply_status_effect(/datum/status_effect/buff/giants_strength, STAT_BUFF_SELF_DURATION)

	return TRUE
