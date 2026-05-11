
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
	recharge_time = 15 SECONDS
	hide_charge_effect = TRUE

/obj/effect/proc_holder/spell/invoked/gravemark/cast(list/targets, mob/living/user)
	. = ..()
	if(isliving(targets[1]))
		var/mob/living/target = targets[1]
		var/faction_tag = "[user.mind.current.real_name]_faction"
		if (target == user)
			to_chat(user, span_warning("It would be unwise to make an enemy of your own skeletons."))
			return FALSE
		if(target.mind && target.mind.current)
			if (faction_tag in target.mind?.current.faction)
				target.mind?.current.faction -= faction_tag
				user.say("Hostis declaratus es.", language = /datum/language/common)
			else
				target.mind?.current.faction += faction_tag
				user.say("Amicus declaratus es.", language = /datum/language/common)
				target.notify_faction_change()
		else if(istype(target, /mob/living/simple_animal))
			if (faction_tag in target.faction)
				target.faction -= faction_tag
				user.say("Hostis declaratus es.", language = /datum/language/common)
			else
				target.faction |= faction_tag
				user.say("Amicus declaratus es.", language = /datum/language/common)
				target.notify_faction_change()
		return TRUE
	return FALSE

/obj/effect/proc_holder/spell/invoked/gravemark/no_sprite
	overlay_state = ""
