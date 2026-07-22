#define UNSELLABLE_REASON_ALCHEMICAL "bears obvious signs of transmutative origin"
/datum/component/unsellable
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/reason

/// desc will show up on examine, see /obj/item/examine
/datum/component/unsellable/Initialize(desc = UNSELLABLE_REASON_ALCHEMICAL)
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
	reason = desc
	var/obj/item/item = parent
	item.sellprice = 0
	item.static_price = TRUE
