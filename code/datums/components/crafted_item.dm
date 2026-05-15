/datum/component/crafted_item
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/crafter_name

/datum/component/crafted_item/Initialize(realname)
	. = ..()
	crafter_name = realname
