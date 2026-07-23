/datum/component/unsellable
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/reason

/// desc will show up on examine, see /obj/item/examine
/datum/component/unsellable/Initialize(desc)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	reason = desc
	var/obj/item/item = parent
	item.sellprice = 0
	item.static_price = TRUE
