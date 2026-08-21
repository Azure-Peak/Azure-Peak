// Reversion - Origin Magic (Vizier)
// Close range channeled healing spell that requires proximity.
// Rewinds them through time and does a big heal.

/datum/action/cooldown/spell/vizier/reversion
	button_icon = 'icons/mob/actions/classuniquespells/vizier.dmi'
	name = "Reversion"
	desc = "A demanding and difficult to execute spell that reverts a target to a prior state in their timestream before they were injured, instantaneously healing a large amount of damage and stopping bleeding. It does not restore blood, due to the nature of how it flows."
	fluff_desc = "Among the most demanding applications of Origin Magick, this art reaches into the timestream of a person, allowing the Vizier to pluck through it and find a point in time where their injuries were not as severe. Then, as if plucking an apple from a tree, it is flung to the present and collapsed into their current timestream."
	button_icon_state = "reversion"
	sound = 'sound/magic/timeforward.ogg'
	spell_color = GLOW_COLOR_ARCANE
	glow_intensity = GLOW_INTENSITY_LOW

	click_to_activate = TRUE
	cast_range = 2
	self_cast_possible = TRUE
	aim_assist = TRUE

	primary_resource_type = SPELL_COST_STAMINA
	primary_resource_cost = 60

	invocations = list("Irji'!")
	invocation_type = INVOCATION_WHISPER

	charge_required = TRUE
	charge_time = 15 SECONDS
	charge_swingdelay_type = SWINGDELAY_CANCEL
	hold_drain = 1
	charge_slowdown = CHARGING_SLOWDOWN_HEAVY
	charge_sound = 'sound/magic/charging.ogg'
	cooldown_time = 4 MINUTES

	associated_skill = /datum/skill/magic/arcane
	spell_tier = 1
	spell_impact_intensity = SPELL_IMPACT_NONE

	spell_requirements = SPELL_REQUIRES_NO_ANTIMAGIC | SPELL_REQUIRES_HUMAN | SPELL_REQUIRES_SAME_Z

	cost = 3

/datum/action/cooldown/spell/vizier/reversion/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/target = cast_on
	if(!istype(target))
		return FALSE

	target.visible_message(span_purple("[target]'s body begins to flicker, slipping out of the present moment, before violently shuddering back into normal time!"))
	target.adjust_fire_stacks(-100)
	target.adjust_fire_stacks(-100, /datum/status_effect/fire_handler/fire_stacks/sunder)
	target.adjust_fire_stacks(-100, /datum/status_effect/fire_handler/fire_stacks/divine)
	target.adjustBruteLoss(-300)
	target.adjustFireLoss(-300)
	target.adjustOxyLoss(-300)
	target.adjustToxLoss(-300)
	target.stamina_add(-200)
	target.energy_add(-600)

	var/list/wCount = target.get_wounds()

	if(wCount.len > 0)
		target.heal_wounds(100)
		target.update_damage_overlays()

	if(wCount && length(wCount))
		for(var/datum/wound/W as anything in wCount)
			if(!W)
				continue
			if(W.bleed_rate > 0)
				W.set_bleed_rate(0)
