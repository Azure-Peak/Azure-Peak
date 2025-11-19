// Get what tier of spells is the user allowed to access
/proc/get_user_spell_tier(mob/target)
	if(HAS_TRAIT(target, TRAIT_ARCYNE_T4))
		return 4
	if(HAS_TRAIT(target, TRAIT_ARCYNE_T3))
		return 3
	if(HAS_TRAIT(target, TRAIT_ARCYNE_T2))
		return 2
	if(HAS_TRAIT(target, TRAIT_ARCYNE_T1))
		return 1
	return 0

// Get mob's patron and check if eligable for evil spells
/proc/get_user_evilness(mob/target)
	if(HAS_TRAIT(target, TRAIT_CABAL))
		return 1
	if(HAS_TRAIT(target, TRAIT_HORDE))
		return 1
	if(HAS_TRAIT(target, TRAIT_COMMIE))
		return 1
	if(HAS_TRAIT(target, TRAIT_DEPRAVED))
		return 1
	if(HAS_TRAIT(target, TRAIT_WITCH))		//Not evil but you know, witch.
		return 1
	return 0
