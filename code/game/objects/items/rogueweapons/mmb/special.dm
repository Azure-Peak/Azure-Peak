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
	var/datum/special_intent/active_special
	var/skillreq

	if(istype(W, /obj/item/rogueweapon) && W.special)
		active_special = W.special
		skillreq = W.associated_skill
	else if(!W && ishuman(user))
		var/mob/living/carbon/human/HU = user
		if(HU.unarmed_special)
			active_special = HU.unarmed_special
			skillreq = /datum/skill/combat/unarmed

	if(active_special)
		if(active_special.custom_skill)
			skillreq = active_special.custom_skill
		if(!HAS_TRAIT(user, TRAIT_BATTLEMASTER))
			if(user.get_skill_level(skillreq) < SKILL_LEVEL_JOURNEYMAN)
				to_chat(user, span_info("I'm not knowledgeable enough in the arts of this weapon to use this."))
				return
		var/atom/parent = W ? W : user
		if(active_special.check_range(user, target) && active_special.check_reqs(user, parent))
			if(active_special.apply_cost(user))
				active_special.deploy(user, parent, target)

	. = ..()
