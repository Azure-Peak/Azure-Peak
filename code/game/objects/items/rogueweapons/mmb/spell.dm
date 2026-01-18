/datum/intent/spell
	name = "spell"
	tranged = 1
	chargedrain = 0
	chargetime = 0
	warnie = "aimwarn"
	warnoffset = 0

/datum/intent/spell/can_charge()
	if(mastermob?.next_move > world.time)
		if(mastermob.client.last_cooldown_warn + 10 < world.time)
			to_chat(mastermob, span_warning("I'm not ready to do that yet!"))
			mastermob.client.last_cooldown_warn = world.time
		return FALSE
	return TRUE

/datum/intent/spell/on_mmb(atom/target, mob/living/user, params)
	if(user.ranged_ability?.InterceptClickOn(user, params, target))
		user.changeNext_move(clickcd)
		if(releasedrain)
			user.stamina_add(releasedrain)
