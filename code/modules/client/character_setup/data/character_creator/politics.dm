/datum/preferences/proc/ui_data_character_creator_politics(mob/user)
	return list(
		"political_faction" = political_faction,
		"estate_region" = estate_region,
		"psydonite" = istype(selected_patron, /datum/patron/old_god),
	)
