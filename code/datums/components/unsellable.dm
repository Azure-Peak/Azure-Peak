/datum/component/unsellable
	dupe_mode = COMPONENT_DUPE_UNIQUE

/datum/component/unsellable/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	var/obj/item/item = parent
	item.sellprice = 0
	item.static_price = TRUE
