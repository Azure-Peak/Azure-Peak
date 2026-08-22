/datum/antagonist/heretic
	name = "Heretic"
	roundend_category = "heretics"
	antagpanel_category = "Heretics"
	show_name_in_check_antagonists = FALSE
	has_tempo = TRUE

/datum/antagonist/heretic/get_antag_cap_weight()
	return 0

/datum/antagonist/heretic/on_gain()
	. = ..()
	if(owner)
		owner.special_role = "Heretic"

/datum/antagonist/heretic/on_removal()
	. = ..()
	if(owner)
		owner.special_role = null
