/mob/living/simple_animal/examine(mob/user)
	var/datum/pronouns/pronoun = get_pronoun()
	var/self_examine = (user == src)

	. = list("<span class='info'>✠ ------------ ✠\nThis is \a <EM>[src]</EM>.")
	if(desc)
		. += desc

	for(var/obj/item/held_item in held_items)
		if(held_item.item_flags & ABSTRACT)
			continue
		. += "[pronoun.m1(self_examine)] holding [held_item.get_examine_string(user)] in [pronoun.m2(self_examine)] [get_held_index_name(get_held_index_of_item(held_item))]."

	//Gets encapsulated with a warning span
	var/list/msg = list()

	var/temp = getBruteLoss() + getFireLoss()
	pronoun = get_pronoun()
	// Damage
	switch(temp)
		if(5 to 25)
			msg += "[pronoun.m1(self_examine)] a little wounded."
		if(25 to 50)
			msg += "[pronoun.m1(self_examine)] wounded."
		if(50 to 100)
			msg += "<B>[pronoun.m1(self_examine)] severely wounded.</B>"
		if(100 to INFINITY)
			msg += span_danger("[pronoun.m1(self_examine)] gravely wounded.")

	var/has_simple_wounds = HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS)
	if(has_simple_wounds)
		pronoun = get_pronoun()
		// Blood volume
		switch(blood_volume)
			if(-INFINITY to BLOOD_VOLUME_SURVIVE)
				msg += span_artery("<B>[pronoun.m1(self_examine)] extremely pale and sickly.</B>")
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
				msg += span_artery("<B>[pronoun.m1(self_examine)] very pale.</B>")
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				msg += span_artery("[pronoun.m1(self_examine)] pale.")
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				msg += span_artery("[pronoun.m1(self_examine)] a little pale.")
	
		// Bleeding
		if(bleed_rate)
			pronoun = get_pronoun()
			var/bleed_wording = "bleeding"
			switch(bleed_rate)
				if(0 to 1)
					bleed_wording = "bleeding slightly"
				if(1 to 5)
					bleed_wording = "bleeding"
				if(5 to 10)
					bleed_wording = "bleeding a lot"
				if(10 to INFINITY)
					bleed_wording = "bleeding profusely"
			if(bleed_rate >= 5)
				msg += span_bloody("<B>[pronoun.m1(self_examine)] [bleed_wording]</B>!")
			else
				msg += span_bloody("[pronoun.m1(self_examine)] [bleed_wording]!")

	//Fire/water stacks
	if(has_status_effect(/datum/status_effect/fire_handler))
		pronoun = get_pronoun()
		msg += "[pronoun.m1(self_examine)] covered in something flammable."
	else if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks))
		pronoun = get_pronoun()
		msg += "[pronoun.m1(self_examine)] soaked."

	//Grabbing
	if(pulledby && pulledby.grab_state)
		pronoun = get_pronoun()
		msg += "[pronoun.m1(self_examine)] being grabbed by [pulledby]."
	
	if(stat >= UNCONSCIOUS)
		pronoun = get_pronoun()
		msg += "[pronoun.m1(self_examine)] unconscious."

	if(length(msg))
		. += span_warning("[msg.Join("\n")]")

	if((user != src) && isliving(user))
		var/mob/living/L = user
		var/final_str = STASTR
		if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			final_str = 10
		var/strength_diff = final_str - L.STASTR
		pronoun = get_pronoun()
		switch(strength_diff)
			if(5 to INFINITY)
				. += span_warning("<B>[pronoun.p_they(TRUE)] look[p_s()] much stronger than I.</B>")
			if(1 to 5)
				. += span_warning("[pronoun.p_they(TRUE)] look[p_s()] stronger than I.")
			if(0)
				. += "[pronoun.p_they(TRUE)] look[p_s()] about as strong as I."
			if(-5 to -1)
				. += span_warning("[pronoun.p_they(TRUE)] look[p_s()] weaker than I.")
			if(-INFINITY to -5)
				. += span_warning("<B>[pronoun.p_they(TRUE)] look[p_s()] much weaker than I.</B>")

	if(Adjacent(user))
		if(has_simple_wounds)
			. += "<a href='?src=[REF(src)];inspect_animal=1'>Inspect Wounds</a>"
		if(user != src)
			. += "<a href='?src=[REF(src)];check_hb=1'>Check Heartbeat</a>"

	. += "✠ ------------ ✠</span>"
