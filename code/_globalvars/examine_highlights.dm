// NOTE: We deliberately exclude Gronn carving amulets from the ascendant amulet lists due to the unique nature of their relationship with the Four.

GLOBAL_LIST_INIT(zizo_amulet_types, get_amulet_type_list_zizo())
GLOBAL_LIST_INIT(gronn_amulet_types, get_amulet_type_list_gronn())

/proc/get_amulet_type_list_zizo()
	. = list()
	// Zizo amulet types are not organized underneath a central type unlike most other amulets.
	// Therefore we search for zcrosses in a very dumb way.
	var/inhumen_cross_types = typesof(/obj/item/clothing/neck/roguetown/psicross/inhumen)
	for(var/type in inhumen_cross_types)
		var/obj/item/clothing/neck/roguetown/psicross/inhumen/cross = type
		// This is the very dumb way.
		// The alternative is manually making a list of all zcrosses, which will be annoying to maintain.
		// In a perfect world, we'd have all Zizo amulets neatly organized underneath a type that denominates it as Zizite.
		// But this is not a perfect world...
		var/cross_name = initial(cross.name)
		var/list/zcross_names = list("zcross", "inverted psycross")
		for(var/zname in zcross_names)
			var/regex/name_search = regex("([zname])", "im")
			if(name_search.Find(cross_name))
				. += type
	return .

/proc/get_amulet_type_list_gronn()
	. = list()
	// Gronn amulet types are not organized underneath a central type unlike most other amulets.
	// Therefore we search for talismans in a very dumb way.
	var/inhumen_cross_types = typesof(/obj/item/clothing/neck/roguetown/psicross)
	for(var/type in inhumen_cross_types)
		var/obj/item/clothing/neck/roguetown/psicross/inhumen/cross = type
		// This is the very dumb way.
		// The alternative is manually making a list of all talismans, which will be annoying to maintain.
		// In a perfect world, we'd have all Gronn amulets neatly organized underneath a type that denominates it as Gronnite.
		// But this is not a perfect world...
		var/cross_name = initial(cross.name)
		var/regex/name_search = regex("(carved talisman)", "im")
		if(name_search.Find(cross_name))
			. += type
	return .
