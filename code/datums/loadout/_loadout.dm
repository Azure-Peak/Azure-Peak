GLOBAL_LIST_EMPTY(loadout_items)
GLOBAL_LIST_EMPTY(loadout_items_by_name)

/datum/loadout_item
	var/name = "Parent loadout datum"
	var/desc
	var/path
	var/cost = 1				//point cost in the loadout budget
	var/donoritem				//autoset on new if null
	var/list/ckeywhitelist
	var/triumph_cost
	var/sort_category = "Miscellaneous" 	//Used for sorting loadout items in the menu. Should be one of the following: One per each file

/datum/loadout_item/New()
	if(isnull(donoritem))
		if(ckeywhitelist)
			donoritem = TRUE
	if(!isnull(path)) // First item in the loadout list is the parent datum, so we want to skip it
		var/obj/targetitem = path
		desc = targetitem.desc

/datum/loadout_item/proc/donator_ckey_check(key)
	if(ckeywhitelist && ckeywhitelist.Find(key))
		return TRUE
	return
