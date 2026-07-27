#define ARMORID "armor-[blunt]-[slash]-[stab]-[piercing]-[fire]-[magic]"

/proc/getArmor(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, magic = 0)
	. = locate(ARMORID)
	if (!.)
		. = new /datum/armor(blunt, slash, stab, piercing, fire, magic)

/datum/armor
	datum_flags = DF_USE_TAG
	/// better defined as area pressure melee
	var/blunt
	/// better defined as line pressure melee
	var/slash
	/// better defined as point pressure melee
	var/stab
	/// basically projectiles
	var/piercing
	/// protection against burning
	var/fire
	/// protection against magical attacks (make this adjustable via rune enchantments or something)
	var/magic

/datum/armor/New(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, magic = 0)
	src.blunt = blunt
	src.slash = slash
	src.stab = stab
	src.piercing = piercing
	src.fire = fire
	src.magic = magic
	tag = ARMORID

/datum/armor/proc/modifyRating(blunt = 0, slash = 0, stab = 0, piercing = 0, fire = 0, magic = 0)
	return getArmor(src.blunt+blunt, src.slash+slash, src.stab+stab, src.piercing+piercing,src.fire+fire, src.magic+magic)

/datum/armor/proc/modifyAllRatings(modifier = 0)
	return getArmor(blunt+modifier, slash+modifier, stab+modifier, piercing+modifier,fire+modifier, magic+modifier)

//TODO! PORT BLACKSTONE BLUNT/SLASH/STAB ARMOR DEFINES!!!!!!
/datum/armor/proc/multiplymodifyAllRatings(modifier = 0)
	return getArmor(blunt*modifier, slash*modifier, stab*modifier, piercing*modifier, fire*modifier, magic*modifier)

/datum/armor/proc/setRating(blunt, slash, stab, piercing, fire, magic)
	return getArmor((isnull(blunt) ? src.blunt : blunt),\
					(isnull(slash) ? src.slash : slash),\
					(isnull(stab) ? src.stab : stab),\
					(isnull(piercing) ? src.piercing : piercing),\
					(isnull(fire) ? src.fire : fire),\
					(isnull(magic) ? src.magic : magic))

/datum/armor/proc/getRating(rating)
	switch(rating)
		if("blunt", "slash", "stab", "piercing", "fire", "magic")
			return vars[rating]
	stack_trace("getRating called with unknown rating key [rating] — fix the caller")
	return 0

/datum/armor/proc/getList()
	return list("blunt" = blunt, "slash" = slash, "stab" = stab, "piercing" = piercing, "fire" = fire, "magic" = magic)

/datum/armor/proc/attachArmor(datum/armor/AA)
	return getArmor(blunt+AA.blunt, slash+AA.slash, stab+AA.stab, piercing+AA.piercing, fire+AA.fire, magic+AA.magic)

/datum/armor/proc/detachArmor(datum/armor/AA)
	return getArmor(blunt-AA.blunt, slash-AA.slash, stab-AA.stab, piercing-AA.piercing, fire-AA.fire, magic-AA.magic)

/datum/armor/vv_edit_var(var_name, var_value)
	if (var_name == NAMEOF(src, tag))
		return FALSE
	. = ..()
	tag = ARMORID // update tag in case armor values were edited

#undef ARMORID
