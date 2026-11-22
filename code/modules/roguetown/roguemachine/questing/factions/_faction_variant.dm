/datum/quest_faction_variant
	var/name_singular
	var/name_plural
	var/group_word
	var/list/mob_types
	var/list/boss_mob_types
	var/pickable = TRUE

/datum/quest_faction_variant/proc/make_faction(datum/quest_faction/base)
	var/datum/quest_faction/variant = new base.type()
	variant.variant_chances = null
	if(name_singular)
		variant.name_singular = name_singular
	if(name_plural)
		variant.name_plural = name_plural
	if(group_word)
		variant.group_word = group_word
	if(length(mob_types))
		variant.mob_types = mob_types.Copy()
	if(length(boss_mob_types))
		variant.boss_mob_types = boss_mob_types.Copy()
	return variant
