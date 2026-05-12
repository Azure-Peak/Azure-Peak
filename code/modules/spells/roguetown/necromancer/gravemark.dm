/datum/action/cooldown/spell/gravemark
	name = "Gravemark"
	desc = "Adjusts a chosen target's status, allowing you to denote them as an ally to the undead creechers under your command.\nMarked allies will not be targeted nor attacked by any undead creechers under your command.\nCasting the 'Gravemark' spell on them again will mark them as an enemy, causing all undead creechers under your command to become hostile against them."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "cult_mark"
	cast_range = 7
	charge_required = FALSE
	cooldown_time = 15 SECONDS
	spell_requirements = SPELL_REQUIRES_SAME_Z
	primary_resource_type = SPELL_COST_NONE
	self_cast_possible = FALSE
	zizo_spell = TRUE

/datum/action/cooldown/spell/gravemark/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/gravemark/cast(atom/cast_on)
	. = ..()
	var/mob/living/target = cast_on
	var/faction_tag = "[owner.mind.current.real_name]_faction"
	if(target.mind && target.mind.current)
		if(faction_tag in target.mind?.current.faction)
			target.mind?.current.faction -= faction_tag
			owner.say("Hostis declaratus es.", language = /datum/language/common)
		else
			target.mind?.current.faction += faction_tag
			owner.say("Amicus declaratus es.", language = /datum/language/common)
			target.notify_faction_change()
	else if(istype(target, /mob/living/simple_animal))
		if(faction_tag in target.faction)
			target.faction -= faction_tag
			owner.say("Hostis declaratus es.", language = /datum/language/common)
		else
			target.faction |= faction_tag
			owner.say("Amicus declaratus es.", language = /datum/language/common)
			target.notify_faction_change()
	return TRUE

/datum/action/cooldown/spell/gravemark/no_sprite
	button_icon_state = ""
