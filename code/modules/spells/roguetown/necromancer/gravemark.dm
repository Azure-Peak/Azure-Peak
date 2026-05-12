/datum/action/cooldown/spell/gravemark
	name = "Gravemark"
	desc = "Adjusts a chosen target's status, allowing you to denote them as an ally to the undead creechers under your command. </br>Marked allies \
	will not be targeted nor attacked by any undead creechers under your command. </br>Casting the 'Gravemark' spell on them again will mark them as \
	an enemy, causing all undead creechers under your command to become hostile against them."
	button_icon = 'icons/mob/actions/actions_cult.dmi'
	button_icon_state = "cult_mark"
	cast_range = 8
	charge_required = FALSE
	cooldown_time = 5 SECONDS
	spell_requirements = SPELL_REQUIRES_SAME_Z
	primary_resource_type = SPELL_COST_NONE
	self_cast_possible = TRUE
	zizo_spell = TRUE

/datum/action/cooldown/spell/gravemark/cast(list/targets, mob/living/user)
	if(!length(targets))
		return FALSE

	var/mob/living/target = targets[1]
	if(!isliving(target))
		return FALSE

	var/faction_tag = "[user.real_name]_faction"

	if(target == user) // making it so self-click helps debug or know who you've declared an ally for now, alongside fixing the cooldown oversight that made it quite fuckin annoying to use
		var/list/allies = list()

		for(var/mob/living/M in world)
			if(M == user)
				continue

			if(M.mind?.current)
				if(faction_tag in M.mind.current.faction)
					allies += M.real_name
			else if(istype(M, /mob/living/simple_animal))
				if(faction_tag in M.faction)
					allies += M.name

		if(!length(allies))
			to_chat(user, span_notice("You have declared no allies among the living or dead."))
		else
			to_chat(user, span_notice("Those bearing your Gravemark: [english_list(allies)]."))

		return TRUE

	var/list/faction_list

	if(target.mind?.current)
		faction_list = target.mind.current.faction
	else if(istype(target, /mob/living/simple_animal))
		faction_list = target.faction
	else
		return FALSE

	. = ..()

	if(faction_tag in faction_list)
		faction_list -= faction_tag
		user.say("Hostis declaratus es.", language = /datum/language/common)
	else
		faction_list += faction_tag
		user.say("Amicus declaratus es.", language = /datum/language/common)

	target.notify_faction_change()
	return TRUE

/datum/action/cooldown/spell/gravemark/no_sprite
	button_icon_state = ""
