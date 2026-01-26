/mob/living/carbon/human/proc/calculate_sentinel_bonus()
	if(STAINT > 10)
		var/fakeint = STAINT
		if(length(status_effects))
			for(var/datum/status_effect/status as anything in status_effects)
				if(length(status.effectedstats) && status.effectedstats["intelligence"] > 0)
					fakeint -= status.effectedstats["intelligence"]
		if(fakeint > 10)
			var/bonus = round(((fakeint - 10) / 2)) * 10
			if(bonus > 0)
				if(HAS_TRAIT(src, TRAIT_HEAVYARMOR) || HAS_TRAIT(src, TRAIT_MEDIUMARMOR) || HAS_TRAIT(src, TRAIT_DODGEEXPERT) || HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
					bonus = clamp(bonus, 0, 25)
				else
					bonus = clamp(bonus, 0, 50)//20-21 INT
			return bonus
		else
			return 0
	else
		return 0

/// Gets the "true" value of a stat on a human mob by eliminating all status effect modifiers that affect that stat.
/mob/living/proc/get_true_stat(stat)
	var/fakestat = get_stat(stat)
	if(status_effects.len)
		for(var/S in status_effects)
			var/datum/status_effect/status = S
			if(status.effectedstats.len)
				if(status.effectedstats[stat])
					if(status.effectedstats[stat] > 0)
						fakestat -= status.effectedstats[stat]
	return fakestat
