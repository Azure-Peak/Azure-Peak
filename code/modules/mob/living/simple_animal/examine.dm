/mob/living/simple_animal/examine(mob/user)
	var/t_He = p_they(TRUE)
	var/t_his = p_their()
	var/t_is = p_are()

	. = list("<span class='info'>✠ ------------ ✠\nThis is \a <EM>[src]</EM>.")
	if(desc)
		. += desc

	var/m1 = "[t_He] [t_is]"
	var/m2 = "[t_his]"
	if(user == src)
		m1 = "I am"
		m2 = "my"

	for(var/obj/item/held_item in held_items)
		if(held_item.item_flags & ABSTRACT)
			continue
		. += "[m1] holding [held_item.get_examine_string(user)] in [m2] [get_held_index_name(get_held_index_of_item(held_item))]."

	//Gets encapsulated with a warning span
	var/list/msg = list()

	var/temp = getBruteLoss() + getFireLoss()
	// Damage
	switch(temp)
		if(5 to 25)
			msg += "[m1] a little wounded."
		if(25 to 50)
			msg += "[m1] wounded."
		if(50 to 100)
			msg += "<B>[m1] severely wounded.</B>"
		if(100 to INFINITY)
			msg += span_danger("[m1] gravely wounded.")

	var/has_simple_wounds = HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS)
	if(has_simple_wounds)
		// Blood volume
		switch(blood_volume)
			if(-INFINITY to BLOOD_VOLUME_SURVIVE)
				msg += span_artery("<B>[m1] extremely pale and sickly.</B>")
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
				msg += span_artery("<B>[m1] very pale.</B>")
			if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
				msg += span_artery("[m1] pale.")
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				msg += span_artery("[m1] a little pale.")

		// Bleeding
		if(bleed_rate)
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
				msg += span_bloody("<B>[m1] [bleed_wording]</B>!")
			else
				msg += span_bloody("[m1] [bleed_wording]!")

	//Fire/water stacks
	if(has_status_effect(/datum/status_effect/fire_handler))
		msg += "[m1] covered in something flammable."
	else if(has_status_effect(/datum/status_effect/fire_handler/wet_stacks))
		msg += "[m1] soaked."

	//Grabbing
	if(pulledby && pulledby.grab_state)
		msg += "[m1] being grabbed by [pulledby]."

	if(stat >= UNCONSCIOUS)
		msg += "[m1] unconscious."

	if(length(msg))
		. += span_warning("[msg.Join("\n")]")

	if((user != src) && isliving(user))
		var/mob/living/L = user
		var/final_str = STASTR
		if(HAS_TRAIT(src, TRAIT_DECEIVING_MEEKNESS))
			final_str = 10
		var/strength_diff = final_str - L.STASTR
		switch(strength_diff)
			if(5 to INFINITY)
				. += span_warning("<B>[t_He] look[p_s()] much stronger than I.</B>")
			if(1 to 5)
				. += span_warning("[t_He] look[p_s()] stronger than I.")
			if(0)
				. += "[t_He] look[p_s()] about as strong as I."
			if(-5 to -1)
				. += span_warning("[t_He] look[p_s()] weaker than I.")
			if(-INFINITY to -5)
				. += span_warning("<B>[t_He] look[p_s()] much weaker than I.</B>")

	var/datum/anatomy/anat = get_anatomy()
	if(anat && length(anat.zones) && has_simple_wounds)
		var/list/broken_hints = list()
		for(var/datum/wound/cripple/crip in simple_wounds)
			if(!crip.crippled_zone)
				continue
			var/datum/anatomy_zone/broken_zone = anat.get_zone(crip.crippled_zone)
			if(broken_zone?.hint)
				broken_hints |= broken_zone.hint
		if(length(broken_hints))
			. += span_danger("<B>[t_He] [p_are()] crippled about the [english_list(broken_hints)].</B>")
		var/list/exposed_hints = list()
		for(var/zone_key in anat.zones)
			var/datum/anatomy_zone/candidate = anat.zones[zone_key]
			if(!length(candidate.requires_broken) || (candidate.zone in broken_parts))
				continue
			if(candidate.is_exposed(broken_parts))
				exposed_hints |= candidate.hint
		if(length(exposed_hints))
			. += span_danger("<B>[p_their(TRUE)] [english_list(exposed_hints)] [length(exposed_hints) > 1 ? "are" : "is"] laid bare.</B>")

	if(Adjacent(user))
		if(has_simple_wounds)
			. += "<a href='?src=[REF(src)];inspect_animal=1'>Inspect Wounds</a>"
		if(user != src)
			. += "<a href='?src=[REF(src)];check_hb=1'>Check Heartbeat</a>"

	if(tame)
		. += span_notice("This animal appears to be tamed.")
	if(ssaddle)
		. += span_notice("This animal is saddled: ([ssaddle.name]).")
	if(ccaparison)
		. += span_notice("This animal is wearing a caparison: ([ccaparison.name]).")
	if(bbarding)
		. += span_notice("This animal is wearing a bard: ([bbarding.name]).")

	. += "✠ ------------ ✠</span>"
