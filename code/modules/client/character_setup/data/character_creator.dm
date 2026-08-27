// In this folder, all of our different pages are split up into separate sub-procs

/datum/preferences/proc/ui_data_character_creator(mob/user)
	var/list/data = list()

	data += ui_data_character_creator_all_pages(user)
	data += ui_data_character_creator_appearance(user)
	data += ui_data_character_creator_classes(user)
	data += ui_data_character_creator_descriptors(user)
	data += ui_data_character_creator_identity(user)
	data += ui_data_character_creator_villain(user)

	return data

/* INSTRUCTIONS FOR DOWNSTREAM:
Add a new override in your modular folder that looks like this:
/datum/preferences/ui_data_character_creator(mob/user)
	var/list/data = ..()
	data += ui_data_downstream(user)
	return data
*/

/datum/preferences/proc/ui_data_character_creator_all_pages(mob/user)
	return list(
		"character_preview_view" = character_preview_view?.assigned_map,
		"preview_background" = character_preview_view?.preview_background.icon_state,

		"loaded_slot" = loaded_slot,
		"real_name" = real_name,
		"headshot_link" = headshot_link,

		"pq" = get_playerquality(parent.ckey, text = TRUE),
		"hide_pq" = should_hide_pq_for(user),
		"triumphs" = user.get_triumphs(),

		"agevet" = user.check_agevet(),
	)

// INSTRUCTIONS FOR DOWNSTREAM: Override in your modular folder!
/datum/preferences/proc/should_hide_pq_for(mob/user)
	return FALSE
