/datum/preferences/proc/ui_data_popup_marking_select(mob/user)
	var/list/data = ui_data_character_creator_appearance_markings(user)

	data["markings_species"] = pref_species.body_markings

	return data

