/datum/action/cooldown/spell/convert_heretic
	name = "Convert to Ecclesiarchy"
	desc = "Initiate a lengthy ritual to convert a willing soul into your faith."
	fluff_desc = "In the end, this was always a matter of faith. Not all Ecclesiarchs are thieves, madmen, cannibals, or tyrants; they are simply those who learned too early that humanity must shape the future of this dying world. Divinity was never meant to remain outside mortal hands."
	button_icon = 'icons/mob/actions/roguespells.dmi'
	button_icon_state = "convert_heretic"
	invocations = list("Claude oculos, aperi mentem. Ex ruina spes surgi, mundus cadit, tu spes renova.")
	invocation_type = INVOCATION_WHISPER
	sound = 'sound/magic/bless.ogg'
	charge_sound = 'sound/magic/chargingold.ogg'
	primary_resource_type = SPELL_COST_ENERGY
	primary_resource_cost = 125
	cooldown_time = 5 MINUTES
	charge_required = TRUE
	charge_time = 10 SECONDS
	associated_skill = /datum/skill/magic/holy
	associated_stat = null
	self_cast_possible = FALSE

/datum/action/cooldown/spell/convert_heretic/is_valid_target(atom/cast_on)
	return ishuman(cast_on)

/datum/action/cooldown/spell/convert_heretic/cast(atom/cast_on)
	. = ..()
	var/mob/living/carbon/human/user = owner
	var/mob/living/carbon/human/target = cast_on
	return user.convert_other(target) // all the logic for this is in the orison code, this exists entirely so that lich and necromancer (who get no devotion) can convert without giving them orison, which would be silly


