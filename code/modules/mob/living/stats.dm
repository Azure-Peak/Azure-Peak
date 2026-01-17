

/mob/living
	/// Strength.
	var/STASTR = 10
	/// Perception.
	var/STAPER = 10
	/// Intelligence.
	var/STAINT = 10
	/// Constitution.
	var/STACON = 10
	/// Willpower.
	var/STAWIL = 10
	/// Speed.
	var/STASPD = 10
	/// Luck.
	var/STALUC = 10
	//buffers, the 'true' amount of each stat
	var/BUFSTR = 0
	var/BUFPER = 0
	var/BUFINT = 0
	var/BUFCON = 0
	var/BUFEND = 0
	var/BUFSPE = 0
	var/BUFLUC = 0
	var/statbuf = FALSE
	var/list/statindex = list()
	var/datum/patron/patron = /datum/patron/godless

/mob/living/proc/init_faith()
	set_patron(/datum/patron/godless)

/mob/living/proc/set_patron(datum/patron/new_patron)
	if(!new_patron)
		return TRUE
	if(ispath(new_patron))
		new_patron = GLOB.patronlist[new_patron]
	if(!istype(new_patron))
		return TRUE
	if(istype(patron))
		patron.on_loss(src)
	patron = new_patron
	new_patron.on_gain(src)
	return TRUE

/datum/species
	// Associative list of stat (STAT_STRENGTH, etc) bonuses used to differentiate each race. They should ALWAYS be positive.
	var/list/race_bonus = list()
	var/construct = 0
	var/gibs_on_shapeshift = FALSE
/mob/living/proc/roll_stats()
	STASTR = 10
	STAPER = 10
	STAINT = 10
	STACON = 10
	STAWIL = 10
	STASPD = 10
	STALUC = 10
	if(ishuman(src))
		var/mob/living/carbon/human/H = src

		if (H.statpack)
			H.statpack.apply_to_human(H)
		if (H.dna?.species) // LETHALSTONE EDIT: apply our race bonus, if we have one
			var/datum/species/species = H.dna.species
			if (species.race_bonus)
				for (var/stat in species.race_bonus)
					var/amt = species.race_bonus[stat]
					H.change_stat(stat, amt)
		switch(H.age)
			if(AGE_MIDDLEAGED)
				change_stat(STATKEY_SPD, -1)
				change_stat(STATKEY_WIL, 1)
				change_stat(STATKEY_LCK, 1)
			if(AGE_OLD)
				change_stat(STATKEY_STR, -1)
				change_stat(STATKEY_SPD, -2)
				change_stat(STATKEY_PER, -1)
				change_stat(STATKEY_CON, -2)
				change_stat(STATKEY_INT, 2)
				change_stat(STATKEY_LCK, 1)
		if(key)
			if(check_blacklist(ckey(key)))
				change_stat(STATKEY_STR, -5)
				change_stat(STATKEY_SPD, -20)
				change_stat(STATKEY_WIL, -2)
				change_stat(STATKEY_CON, -2)
				change_stat(STATKEY_INT, -20)
				change_stat(STATKEY_LCK, -20)
			if(check_psychokiller(ckey(key)))

				H.eye_color = "ff0000"
				H.voice_color = "ff0000"

/mob/living/proc/get_stat(stat)
	if(!stat)
		return
	switch(stat)
		if(STAT_STRENGTH)
			return STASTR
		if(STAT_PERCEPTION)
			return STAPER
		if(STAT_INTELLIGENCE)
			return STAINT
		if(STAT_CONSTITUTION)
			return STACON
		if(STAT_WILLPOWER)
			return STAWIL
		if(STAT_SPEED)
			return STASPD
		if(STAT_FORTUNE)
			return STALUC
		else
			CRASH("get_stat called on [src] with an erroneous stat flag: [stat]")

/mob/living/proc/change_stat(stat, amt, index)
	if(!stat)
		return
	if(amt == 0 && index)
		if(statindex[index])
			change_stat(statindex[index]["stat"], -1*statindex[index]["amt"])
			statindex[index] = null
			return
	if(!amt)
		return
	if(index)
		if(statindex[index])
			return //we cannot make a new index
		else
			statindex[index] = list("stat" = stat, "amt" = amt)
//			statindex[index]["stat"] = stat
//			statindex[index]["amt"] = amt
	var/newamt = 0
	switch(stat)
		if(STATKEY_STR)
			newamt = STASTR + amt
			if(BUFSTR < 0)
				BUFSTR = BUFSTR + amt
				if(BUFSTR > 0)
					newamt = STASTR + BUFSTR
					BUFSTR = 0
			if(BUFSTR > 0)
				BUFSTR = BUFSTR + amt
				if(BUFSTR < 0)
					newamt = STASTR + BUFSTR
					BUFSTR = 0
			while(newamt < 1)
				newamt++
				BUFSTR--
			while(newamt > 20)
				newamt--
				BUFSTR++
			STASTR = newamt

		if(STATKEY_PER)
			newamt = STAPER + amt
			if(BUFPER < 0)
				BUFPER = BUFPER + amt
				if(BUFPER > 0)
					newamt = STAPER + BUFPER
					BUFPER = 0
			if(BUFPER > 0)
				BUFPER = BUFPER + amt
				if(BUFPER < 0)
					newamt = STAPER + BUFPER
					BUFPER = 0
			while(newamt < 1)
				newamt++
				BUFPER--
			while(newamt > 20)
				newamt--
				BUFPER++
			STAPER = newamt

			update_fov_angles()

		if(STATKEY_INT)
			newamt = STAINT + amt
			if(BUFINT < 0)
				BUFINT = BUFINT + amt
				if(BUFINT > 0)
					newamt = STAINT + BUFINT
					BUFINT = 0
			if(BUFINT > 0)
				BUFINT = BUFINT + amt
				if(BUFINT < 0)
					newamt = STAINT + BUFINT
					BUFINT = 0
			while(newamt < 1)
				newamt++
				BUFINT--
			while(newamt > 20)
				newamt--
				BUFINT++
			STAINT = newamt

		if(STATKEY_CON)
			newamt = STACON + amt
			if(BUFCON < 0)
				BUFCON = BUFCON + amt
				if(BUFCON > 0)
					newamt = STACON + BUFCON
					BUFCON = 0
			if(BUFCON > 0)
				BUFCON = BUFCON + amt
				if(BUFCON < 0)
					newamt = STACON + BUFCON
					BUFCON = 0
			while(newamt < 1)
				newamt++
				BUFCON--
			while(newamt > 20)
				newamt--
				BUFCON++
			STACON = newamt

		if(STATKEY_WIL)
			newamt = STAWIL + amt
			if(BUFEND < 0)
				BUFEND = BUFEND + amt
				if(BUFEND > 0)
					newamt = STAWIL + BUFEND
					BUFEND = 0
			if(BUFEND > 0)
				BUFEND = BUFEND + amt
				if(BUFEND < 0)
					newamt = STAWIL + BUFEND
					BUFEND = 0
			while(newamt < 1)
				newamt++
				BUFEND--
			while(newamt > 20)
				newamt--
				BUFEND++

			pain_threshold += amt * 10
			STAWIL = newamt

		if(STATKEY_SPD)
			newamt = STASPD + amt
			if(BUFSPE < 0)
				BUFSPE = BUFSPE + amt
				if(BUFSPE > 0)
					newamt = STASPD + BUFSPE
					BUFSPE = 0
			if(BUFSPE > 0)
				BUFSPE = BUFSPE + amt
				if(BUFSPE < 0)
					newamt = STASPD + BUFSPE
					BUFSPE = 0
			while(newamt < 1)
				newamt++
				BUFSPE--
			while(newamt > 20)
				newamt--
				BUFSPE++
			STASPD = newamt
			update_move_intent_slowdown()

		if(STATKEY_LCK)
			newamt = STALUC + amt
			if(BUFLUC < 0)
				BUFLUC = BUFLUC + amt
				if(BUFLUC > 0)
					newamt = STALUC + BUFLUC
					BUFLUC = 0
			if(BUFLUC > 0)
				BUFLUC = BUFLUC + amt
				if(BUFLUC < 0)
					newamt = STALUC + BUFLUC
					BUFLUC = 0
			while(newamt < 1)
				newamt++
				BUFLUC--
			while(newamt > 20)
				newamt--
				BUFLUC++
			STALUC = newamt

/// Calculates a luck value in the range [1, 400] (calculated as STALUC^2), then maps the result linearly to the given range
/// min must be >= 0, max must be <= 100, and min must be <= max
/// For giving
/mob/living/proc/get_scaled_sq_luck(min, max)
	if (min < 0)
		min = 0
	if (max > 100)
		max = 100
	if (min > max)
		var/temp = min
		min = max
		max = temp
	var/adjusted_luck = (src.STALUC * src.STALUC) / 400

	return LERP(min, max, adjusted_luck)

/proc/generic_stat_comparison(userstat as num, targetstat as num)
	var/difference = userstat - targetstat
	if(difference > 1 || difference < -1)
		return difference * 10
	else
		return 0

/mob/living/proc/badluck(multi = 3, ignore_effects = FALSE)
	if(ignore_effects)
		var/truefor = get_true_stat(STATKEY_LCK)
		if(truefor < 10)
			var/failed = prob((10 - truefor) * multi)
			// if we failed, but we're a xylixian devotee, we get another shot
			if(failed && HAS_TRAIT(src, TRAIT_XYLIX_DEVOTEE))
				failed = prob((10 - truefor) * multi)
				// if xylix twisted fate into our favour, get a little jingle from them
				if(!failed)
					play_overhead_indicator('icons/mob/overhead_effects.dmi', "sign_Xylix", 15, MUTATIONS_LAYER, private = TRAIT_XYLIX_DEVOTEE, soundin = 'sound/items/gem.ogg', y_offset = 32)
					add_stress(/datum/stressevent/xylixian_pity)
			return failed
	else if(STALUC < 10)
		var/failed = prob((10 - STALUC) * multi)
		// if we failed, but we're a xylixian devotee, we get another shot
		if(failed && HAS_TRAIT(src, TRAIT_XYLIX_DEVOTEE))
			failed = prob((10 - STALUC) * multi)
			// if xylix twisted fate into our favour, get a little jingle from them
			if(!failed)
				play_overhead_indicator('icons/mob/overhead_effects.dmi', "sign_Xylix", 15, MUTATIONS_LAYER, private = TRAIT_XYLIX_DEVOTEE, soundin = 'sound/items/gem.ogg', y_offset = 32)
				add_stress(/datum/stressevent/xylixian_pity)
		return failed

/mob/living/proc/goodluck(multi = 3)
	if(STALUC > 10)
		var/succeeded = prob((STALUC - 10) * multi)
		// if we didn't succeed, but we're a xylixian devotee, we get another shot
		if(!succeeded && HAS_TRAIT(src, TRAIT_XYLIX_DEVOTEE))
			succeeded = prob((STALUC - 10) * multi)
			// if xylix twisted fate into our favour, get a little jingle from them
			if(succeeded)
				play_overhead_indicator('icons/mob/overhead_effects.dmi', "sign_Xylix", 15, MUTATIONS_LAYER, private = TRAIT_XYLIX_DEVOTEE, soundin = 'sound/items/gem.ogg', y_offset = 32)
				add_stress(/datum/stressevent/xylixian_fate)
		return succeeded

/mob/living/proc/get_stat_level(stat_keys)
	switch(stat_keys)
		if(STATKEY_STR)
			return STASTR
		if(STATKEY_PER)
			return STAPER
		if(STATKEY_WIL)
			return STAWIL
		if(STATKEY_CON)
			return STACON
		if(STATKEY_INT)
			return STAINT
		if(STATKEY_SPD)
			return STASPD
		if(STATKEY_LCK)
			return STALUC

///Effectively rolls a d20, with each point in the stat being a chance_per_point% chance to succeed per point in the stat. If no stat is provided, just returns 0.
///dee_cee is a difficulty mod, a positive value makes the check harder, a negative value makes it easier.
///invert_dc changes it from stat - dc to dc - stat, for inverted checks.
///EG: A person with 10 luck and a dc of -10 effectively has a 100% chance of success. Or an inverted DC with 10 means 0% chance of success.
/mob/living/proc/stat_roll(stat_key,chance_per_point = 5, dee_cee = null, invert_dc = FALSE)
	if(!stat_key)
		return FALSE
	var/tocheck
	switch(stat_key)
		if(STATKEY_STR)
			tocheck = STASTR
		if(STATKEY_PER)
			tocheck = STAPER
		if(STATKEY_WIL)
			tocheck = STAWIL
		if(STATKEY_CON)
			tocheck = STACON
		if(STATKEY_INT)
			tocheck = STAINT
		if(STATKEY_SPD)
			tocheck = STASPD
		if(STATKEY_LCK)
			tocheck = STALUC
	if(invert_dc)
		return isnull(dee_cee) ? prob(tocheck * chance_per_point) : prob(clamp((dee_cee - tocheck) * chance_per_point,0,100))
	else
		return isnull(dee_cee) ? prob(tocheck * chance_per_point) : prob(clamp((tocheck - dee_cee) * chance_per_point,0,100))
