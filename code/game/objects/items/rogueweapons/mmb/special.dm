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
	if(!user.cmode)
		if(ishuman(user) && ishuman(target))
			var/mob/living/carbon/human/H = user
			H.attempt_steal(user, target)
			return
	if(user.has_status_effect(/datum/status_effect/debuff/specialcd))
		return

	user.face_atom(target)

	var/obj/item/rogueweapon/W = user.get_active_held_item()
	if(istype(W, /obj/item/rogueweapon) && W.special)
		var/skillreq = W.associated_skill
		if(W.special.custom_skill)
			skillreq = W.special.custom_skill
		if(!HAS_TRAIT(user, TRAIT_BATTLEMASTER))
			if(user.get_skill_level(skillreq) < SKILL_LEVEL_JOURNEYMAN)
				to_chat(user, span_info("I'm not knowledgeable enough in the arts of this weapon to use this."))
				return
		if(W.special.check_range(user, target))
			if(W.special.apply_cost(user))
				W.special.deploy(user, W, target)

	. = ..()
