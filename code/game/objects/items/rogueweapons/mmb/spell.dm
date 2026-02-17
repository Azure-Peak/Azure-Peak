/datum/intent/spell
	name = "spell"
	tranged = 1
	chargedrain = 0
	chargetime = 0
	warnie = "aimwarn"
	warnoffset = 0

/datum/intent/spell/can_charge(atom/clicked_object)
	var/obj/effect/proc_holder/spell/spell_ability = mastermob.ranged_ability
	if(istype(spell_ability) && !spell_ability.charge_check(mastermob, TRUE))
		to_chat(mastermob, span_warning("This spell needs time to recharge!"))
		return FALSE
	return TRUE

/datum/intent/spell/on_mmb(atom/target, mob/living/user, params)
	if(user.ranged_ability?.InterceptClickOn(user, params, target))
		user.changeNext_move(clickcd)
		if(releasedrain)
			user.stamina_add(releasedrain)
