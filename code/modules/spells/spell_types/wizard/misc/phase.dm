/datum/action/cooldown/spell/phase
	name = "Phase"
	desc = "Slip your body partly out of the world, becoming hazy and ethereal. For a short time you move faster and pass straight through other beings. The effect is stronger in lighter armor. Afterwards, neither Phase nor Dagger Dash can be used until 30 seconds later."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "rune6"
	sound = 'sound/magic/blink.ogg'
	spell_color = GLOW_COLOR_DISPLACEMENT
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = FALSE
	self_cast_possible = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = SPELLCOST_STAT_BUFF

	invocations = list("Translatio!")
	invocation_type = INVOCATION_SHOUT

	charge_required = TRUE
	weapon_cast_penalized = FALSE
	charge_time = CHARGETIME_POKE
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_NONE
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 45 SECONDS

	associated_skill = /datum/skill/magic/arcane
	point_cost = 3
	spell_tier = 2
	spell_impact_intensity = SPELL_IMPACT_NONE
	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN

/datum/action/cooldown/spell/phase/can_cast_spell(feedback = TRUE)
	. = ..()
	if(!.)
		return FALSE
	var/mob/living/living_owner = owner
	if(istype(living_owner) && living_owner.has_status_effect(/datum/status_effect/debuff/slip_recovery))
		if(feedback)
			owner.balloon_alert(owner, "Still winded!")
		return FALSE

/datum/action/cooldown/spell/phase/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return FALSE

	H.balloon_alert_to_viewers("<font color='[GLOW_COLOR_DISPLACEMENT]'>Phased!</font>")
	H.visible_message(span_warning("<b>[H]'s form turns hazy and indistinct!</b>"), span_notice("<b>I slip between the spaces, my body turning ethereal!</b>"))
	H.apply_status_effect(/datum/status_effect/buff/phase)
	H.apply_status_effect(/datum/status_effect/debuff/slip_recovery)
	return TRUE
