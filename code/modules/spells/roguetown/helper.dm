// Check if a mob has arcyne training
/proc/is_user_magic(mob/target)
	return HAS_TRAIT(target, TRAIT_ARCYNE)

// Get mob's patron and check if eligable for evil spells
/proc/get_user_evilness(mob/target)
	if(HAS_TRAIT(target, TRAIT_CABAL))
		return 1
	if(HAS_TRAIT(target, TRAIT_HORDE))
		return 1
	if(HAS_TRAIT(target, TRAIT_FREEMAN))
		return 1
	if(HAS_TRAIT(target, TRAIT_DEPRAVED))
		return 1
	if(HAS_TRAIT(target, TRAIT_WITCH))		//Not evil but you know, witch.
		return 1
	return 0
