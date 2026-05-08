
/obj/effect/proc_holder/spell/invoked/gravemark
	name = "Gravemark"
	desc = "Adjusts a chosen target's status, allowing you to denote them as an ally to the undead creechers under your command. </br>Marked allies \
	will not be targeted nor attacked by any undead creechers under your command. </br>Casting the 'Gravemark' spell on them again will mark them as \
	an enemy, causing all undead creechers under your command to become hostile against them."
	overlay_state = "raiseskele"
	range = 7
	warnie = "sydwarning"
	movement_interrupt = FALSE
	chargedloop = null
	antimagic_allowed = TRUE
	recharge_time = 10 SECONDS
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/gravemark/cast(list/targets, mob/living/user)
	if(!length(targets))
		return FALSE

	var/mob/living/target = targets[1]
	if(!isliving(target))
		return FALSE

	var/faction_tag = "[REF(user)]_faction"

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

/obj/effect/proc_holder/spell/invoked/gravemark/no_sprite
	overlay_state = ""
