GLOBAL_LIST_EMPTY(loadout_items)

/datum/loadout_item
	var/name = "Parent loadout datum"
	var/desc
	var/path
	var/donoritem			//autoset on new if null
	var/list/ckeywhitelist
	var/triumph_cost
	var/sort_category = "Miscellaneous" 	//Used for sorting loadout items in the menu. Should be one of the following: One per each file

/datum/loadout_item/New()
	if(isnull(donoritem))
		if(ckeywhitelist)
			donoritem = TRUE
	var/obj/targetitem = path
	desc = targetitem.desc
	if (triumph_cost)
		desc += "<br><b>Costs [triumph_cost] TRIUMPHS.</b>"

/datum/loadout_item/proc/donator_ckey_check(key)
	if(ckeywhitelist && ckeywhitelist.Find(key))
		return TRUE
	return
