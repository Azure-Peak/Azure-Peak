/proc/is_matching_bait(obj/item/bait, identifier)
	if(ispath(identifier)) //Just a path
		return istype(bait, identifier)
	if(!islist(identifier))
		return HAS_TRAIT(bait, identifier)
	var/list/special_identifier = identifier
	switch(special_identifier[FISH_BAIT_TYPE])
		if(FISH_BAIT_FOODTYPE)
			if(istype(bait, /obj/item/reagent_containers/food/snacks))
				var/obj/item/reagent_containers/food/snacks/food_bait = bait
				return food_bait.dish_type & special_identifier[FISH_BAIT_VALUE]
			else
				return bait.bait_flag & special_identifier[FISH_BAIT_VALUE]
		if(FISH_BAIT_REAGENT)
			return bait.reagents?.has_reagent(special_identifier[FISH_BAIT_VALUE], special_identifier[FISH_BAIT_AMOUNT], check_subtypes = TRUE)
		else
			CRASH("Unknown bait identifier in fish favourite/disliked list")

/proc/fishing_skill_prized_mult(skill_level)
	switch(skill_level)
		if(SKILL_LEVEL_EXPERT)
			return FISHING_SKILL_PRIZED_MULT_EXPERT
		if(SKILL_LEVEL_MASTER)
			return FISHING_SKILL_PRIZED_MULT_MASTER
		if(SKILL_LEVEL_LEGENDARY)
			return FISHING_SKILL_PRIZED_MULT_LEGENDARY
	return 1

/proc/fishing_skill_dud_mult(skill_level)
	switch(skill_level)
		if(SKILL_LEVEL_JOURNEYMAN)
			return FISHING_SKILL_DUD_MULT_JOURNEYMAN
		if(SKILL_LEVEL_EXPERT)
			return FISHING_SKILL_DUD_MULT_EXPERT
		if(SKILL_LEVEL_MASTER)
			return FISHING_SKILL_DUD_MULT_MASTER
		if(SKILL_LEVEL_LEGENDARY)
			return FISHING_SKILL_DUD_MULT_LEGENDARY
	return 1
