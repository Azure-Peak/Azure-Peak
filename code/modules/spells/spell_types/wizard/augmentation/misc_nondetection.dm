// Nondetection - shrouds a target from divination magic for 1 hour.
/datum/action/cooldown/spell/nondetection
	button_icon = 'icons/mob/actions/mage_augmentation.dmi'
	name = "Nondetection"
	desc = "Shroud a target from divination magic for 1 hour."
	button_icon_state = "nondetection"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_BUFF
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_AUGMENTATION

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_UTILITY_BUFF

	charge_required = TRUE
	charge_time = 1 SECONDS
	charge_drain = 0
	charge_slowdown = CHARGING_SLOWDOWN_SMALL
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 10 SECONDS

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1

	point_cost = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/nondetection/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(HAS_TRAIT(spelltarget, TRAIT_ANTISCRYING))
		to_chat(H, span_warning("They are already shrouded!"))
		return FALSE

	ADD_TRAIT(spelltarget, TRAIT_ANTISCRYING, MAGIC_TRAIT)

	if(spelltarget != H)
		H.visible_message("[H] draws a glyph in the air, shrouding [spelltarget] from prying eyes.")
	else
		H.visible_message("[H] draws a glyph in the air, shrouding themselves from prying eyes.")

	to_chat(spelltarget, span_notice("I feel hidden from divination magic."))
	addtimer(CALLBACK(src, PROC_REF(remove_buff), spelltarget), 1 HOURS)
	return TRUE

/datum/action/cooldown/spell/nondetection/proc/remove_buff(mob/living/target)
	if(QDELETED(target))
		return
	REMOVE_TRAIT(target, TRAIT_ANTISCRYING, MAGIC_TRAIT)
	to_chat(target, span_warning("I feel my anti-scrying shroud failing."))
