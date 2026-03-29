/datum/antagonist/assassin/power
	var/ower_name = "Debug"
	var/description = "You shouldn't be seeing this!"
	var/cost = 0
	var/purchasable = FALSE
	var/freebie = FALSE // in case we need to give these for free... for some reason.

/datum/antagonist/assassin/power/spell
	var/spell // datum typepath of the spell we're going to add

/datum/antagonist/assassin/power/skill
	var/skill // skill datum we're adjusting
	var/limit // the up_to we adjust a skill to

/datum/antagonist/assassin/power/trait
	var/trait // trait typepath we're going to add

/datum/antagonist/assassin/power/proc/purchase(mob/user)
	if(!can_buy())
		return
	if(!freebie)
		graggar_boy_points -= cost
	purchasable = FALSE
	

/datum/antagonist/assassin/power/spell/purchase(mob/user)
	..()
	if(spell)
		owner.AddSpell(spell)

/datum/antagonist/assassin/power/trait/purchase(mob/user)
	..()
	if(trait)
		ADD_TRAIT(owner.current, trait, "Graggars Gifts")

/datum/antagonist/assassin/power/skill/purchase(mob/user)
	..()
	if((skill) && (limit))
		owner.current.adjust_skillrank_up_to(skill, limit)

/datum/antagonist/assassin/power/proc/can_buy(mob/user)
	if(!ishuman(user))
		return
	if(!HAS_TRAIT(user, TRAIT_ASSASSIN))
		return
	if(!purchasable)
		to_chat(user, span_danger("This is not purchasable! How did you GET here?"))
		return
	if(cost > graggar_boy_points && !freebie)
		to_chat(user, span_danger("The SINISTAR demands more souls for this!"))
		return FALSE
	else
		return TRUE
