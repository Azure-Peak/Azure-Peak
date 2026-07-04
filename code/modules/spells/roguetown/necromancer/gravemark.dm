/datum/action/cooldown/spell/gravemark
	name = "Gravemark"
	desc = "Adjusts a chosen target's status, allowing you to denote them as an ally to the undead creechers under your command. </br>Marked allies \
	will not be targeted nor attacked by any undead creechers under your command. </br>Casting the 'Gravemark' spell on them again will mark them as \
	an enemy, causing all undead creechers under your command to become hostile against them."
	button_icon = 'icons/mob/actions/actions_clockcult.dmi'
	button_icon_state = "Judicial Marker"
	cast_range = 8
	charge_required = FALSE
	cooldown_time = 3 SECONDS
	spell_requirements = SPELL_REQUIRES_SAME_Z
	primary_resource_type = SPELL_COST_NONE
	self_cast_possible = TRUE
	has_visual_effects = FALSE
	has_visual_effects = FALSE
	sound = null
	zizo_spell = TRUE

/datum/action/cooldown/spell/gravemark/cast(atom/cast_on)
	if(!owner)
		return FALSE

	var/mob/living/target = cast_on
	if(!isliving(target))
		return FALSE

	var/faction_tag = "[owner.real_name]_faction"

	// Self-cast = list current allies
	if(target == owner)
		var/list/allies = list()

		for(var/mob/living/M as anything in GLOB.mob_list)
			if(M == owner)
				continue

			if(M.mind?.current)
				if(faction_tag in M.mind.current.faction)
					allies += M.real_name
			else if(istype(M, /mob/living/simple_animal))
				if(faction_tag in M.faction)
					allies += M.name

		if(!length(allies))
			to_chat(owner, span_notice("You have declared no allies among the living or dead."))
		else
			to_chat(owner, span_notice("Those bearing your Gravemark: [english_list(allies)]."))

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
		owner.say("Hostis declaratus es!", language = /datum/language/common)
	else
		faction_list += faction_tag
		owner.say("Amicus declaratus es.", language = /datum/language/common)

	target.notify_faction_change()
	return TRUE

/datum/action/cooldown/spell/gravemark/no_sprite
	button_icon_state = ""
