/datum/antagonist/lycker
	name = "Licker"
	roundend_category = "lyckers"
	antagpanel_category = "Lyckers"
	show_name_in_check_antagonists = FALSE
	has_tempo = TRUE

/datum/antagonist/lycker/get_antag_cap_weight()
	return 0

/datum/antagonist/lycker/on_gain()
	. = ..()
	if(owner)
		owner.special_role = "Licker"

/datum/antagonist/lycker/on_removal()
	. = ..()
	if(owner)
		owner.special_role = null
