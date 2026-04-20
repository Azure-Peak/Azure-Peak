// Iron Skin — Ferramancy buff spell
// Status effect kept in augmentation/augmentation_status_effects.dm
/datum/action/cooldown/spell/iron_skin
	button_icon = 'icons/mob/actions/mage_ferramancy.dmi'
	name = "Iron Skin"
	desc = "Conjure bits of arcyne iron and steel to surround the target's armor, blunting incoming blows and protecting their equipment. Reduces incoming integrity damage to armor by 25%.\nCasting on another person extends the duration."
	button_icon_state = "iron_skin"
	sound = 'sound/magic/haste.ogg'
	spell_color = GLOW_COLOR_METAL
	glow_intensity = GLOW_INTENSITY_LOW
	attunement_school = ASPECT_NAME_FERRAMANCY

	click_to_activate = TRUE
	cast_range = SPELL_RANGE_GROUND
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Ferrum Tutamen.")
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

	point_cost = 2
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

/datum/action/cooldown/spell/iron_skin/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	if(!isliving(cast_on))
		to_chat(H, span_warning("That is not a valid target!"))
		return FALSE

	var/mob/living/spelltarget = cast_on

	if(spelltarget != H)
		H.visible_message("[H] mutters an incantation and bits of iron materialize around [spelltarget]'s armor.")
		to_chat(H, span_notice("With another person as a conduit, my spell's duration is extended."))
		spelltarget.apply_status_effect(/datum/status_effect/buff/iron_skin, STAT_BUFF_ALLY_DURATION)
	else
		H.visible_message("[H] mutters an incantation and bits of iron materialize around their armor.")
		spelltarget.apply_status_effect(/datum/status_effect/buff/iron_skin, STAT_BUFF_SELF_DURATION)

	return TRUE
