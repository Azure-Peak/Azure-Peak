/datum/intent/special
	name = "special"
	candodge = FALSE
	canparry = FALSE
	chargedrain = 0
	chargetime = 0
	noaa = TRUE

/datum/intent/special/on_mmb(atom/target, mob/living/user, params)
	if(!user)
		return
	if(user.incapacitated())
		return
	if(!user.mind)
		return
	user.try_special(target)
	. = ..()
