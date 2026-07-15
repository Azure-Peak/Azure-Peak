/mob/living/carbon/examine(mob/user)
	var/datum/pronouns/pronoun = get_pronoun() // mutated many, many times
	var/self_examine = (user == src) // used to swap to first person pronouns

	. = list("<span class='info'>✠ ------------ ✠\nThis is \a <EM>[src]</EM>!")
	var/list/obscured = check_obscured_slots()

	if (handcuffed)
		pronoun = get_pronoun()
		. += span_warning("[pronoun.m1(self_examine)] tied up with \a [handcuffed]!")
	pronoun = get_pronoun()
	if (head)
		. += "[pronoun.m3(self_examine)] [head.get_examine_string(user)] on [pronoun.m2(self_examine)] head. "
	if(wear_mask && !(SLOT_WEAR_MASK in obscured))
		. += "[pronoun.m3(self_examine)] [wear_mask.get_examine_string(user)] on [pronoun.m2(self_examine)] face."
	if(wear_neck && !(SLOT_NECK in obscured))
		. += "[pronoun.m3(self_examine)] [wear_neck.get_examine_string(user)] around [pronoun.m2(self_examine)] neck."

	for(var/obj/item/I in held_items)
		if(!(I.item_flags & ABSTRACT))
			. += "[pronoun.m1(self_examine)] holding [I.get_examine_string(user)] in [pronoun.m2(self_examine)] [get_held_index_name(get_held_index_of_item(I))]."

	if (back)
		. += "[pronoun.m3(self_examine)] [back.get_examine_string(user)] on [pronoun.m2(self_examine)] back."
	var/appears_dead = 0
/*	if (stat == DEAD)
		appears_dead = 1
		if(getorgan(/obj/item/organ/brain))
			. += span_dead("[p_they(TRUE)] [p_are()] limp and unresponsive, with no signs of life.")
		else if(get_bodypart(BODY_ZONE_HEAD))
			. += span_dead("It appears that [p_their()] brain is missing...")*/


	pronoun = get_pronoun()
	var/list/missing = get_missing_limbs()
	for(var/t in missing)
		if(t==BODY_ZONE_HEAD)
			. += span_dead("<B>[capitalize(pronoun.m2(self_examine))] [parse_zone(t)] is gone.</B>")
			continue
		. += span_warning("<B>[capitalize(pronoun.m2(self_examine))] [parse_zone(t)] is gone.</B>")

	var/list/msg = list("<span class='warning'>")
	var/temp = getBruteLoss()
	pronoun = get_pronoun()
	if(!(user == src && src.hal_screwyhud == SCREWYHUD_HEALTHY)) //fake healthy
		if(temp)
			if (temp < 25)
				msg += "[pronoun.m3(self_examine)] some bruises.\n"
			else if (temp < 50)
				msg += "[pronoun.m3(self_examine)] a lot of bruises!\n"
			else
				msg += "<B>[pronoun.m1(self_examine)] black and blue!!</B>\n"

		temp = getFireLoss()
		if(temp)
			if (temp < 25)
				msg += "[pronoun.m3(self_examine)] some burns.\n"
			else if (temp < 50)
				msg += "[pronoun.m3(self_examine)] many burns!\n"
			else
				msg += "<B>[pronoun.m1(self_examine)] dragon food!!</B>\n"

		temp = getCloneLoss()
		if(temp)
			if(temp < 25)
				msg += "[pronoun.p_they(TRUE)] [pronoun.p_are()] slightly deformed.\n"
			else if (temp < 50)
				msg += "[pronoun.p_they(TRUE)] [pronoun.p_are()] <b>moderately</b> deformed!\n"
			else
				msg += "<b>[pronoun.p_they(TRUE)] [pronoun.p_are()] severely deformed!</b>\n"

	pronoun = get_pronoun()
	if(HAS_TRAIT(src, TRAIT_DUMB))
		msg += "[pronoun.p_they(TRUE)] seem[pronoun.p_s()] to be clumsy and unable to think.\n"

	if(has_status_effect(/datum/status_effect/fire_handler/fire_stacks))
		msg += "[pronoun.p_they(TRUE)] [pronoun.p_are()] covered in something flammable.\n"
	if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks))
		msg += "[pronoun.p_they(TRUE)] look[pronoun.p_s()] a little soaked.\n"

	if(pulledby && pulledby.grab_state)
		msg += "[pronoun.m1(self_examine)] restrained by [pulledby]'s grip.\n"

	msg += "</span>"

	. += msg.Join("")

	if(!appears_dead)
		if(stat == UNCONSCIOUS)
			pronoun = get_pronoun()
			. += span_warning("[pronoun.m1(self_examine)] unconscious.")
		else if(InCritical())
			pronoun = get_pronoun()
			. += span_warning("[pronoun.m1(self_examine)] barely conscious.")
	if (stat == DEAD)
		pronoun = get_pronoun()
		appears_dead = 1
		. += span_warning("[pronoun.m1(self_examine)] unconscious.")
	var/trait_exam = common_trait_examine()
	if (!isnull(trait_exam))
		. += trait_exam

	if(isliving(user))
		var/mob/living/L = user
		if(STASTR > L.STASTR)
			pronoun = get_pronoun()
			if(STASTR > 15)
				. += span_warning("[pronoun.p_they(TRUE)] look[pronoun.p_s()] stronger than I.")
			else
				. += span_warning("<B>[pronoun.p_they(TRUE)] look[pronoun.p_s()] stronger than I.</B>")

	. += "✠ ------------ ✠</span>"

	SEND_SIGNAL(src, COMSIG_PARENT_EXAMINE, user, .)
