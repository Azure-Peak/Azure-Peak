/datum/preferences/proc/ui_act_popup_character_select(action, list/params, datum/tgui/ui, datum/ui_state/state)
	var/mob/user = ui.user

	switch(action)
		if("favorite_slot")
			var/index = sanitize_integer(text2num(params["index"]), 0, max_save_slots, -1)
			if(index == -1)
				return CHARACTER_ACT_DATA_UPDATE

			favorited_slots += index
			save_preferences()
			verbose_pref_log_notification(user, "notice", "Slot [index] added to favorite slots")
			return CHARACTER_ACT_DATA_UPDATE
		if("unfavorite_slot")
			var/index = sanitize_integer(text2num(params["index"]), 0, max_save_slots, -1)
			if(index == -1)
				return CHARACTER_ACT_DATA_UPDATE

			favorited_slots -= index
			save_preferences()
			verbose_pref_log_notification(user, "notice", "Slot [index] removed from favorite slots")
			return CHARACTER_ACT_DATA_UPDATE
		if("reorder_favorited_slots")
			var/list/new_list = params["slots"]
			if(!islist(new_list) || length(new_list) > max_save_slots)
				return CHARACTER_ACT_DATA_UPDATE
			// try to filter out href exploits
			if(length(new_list))
				if(!isnum(new_list[1]))
					return CHARACTER_ACT_DATA_UPDATE
			favorited_slots = new_list
			return CHARACTER_ACT_DATA_UPDATE
		if("changeslot_index")
			var/index = sanitize_integer(text2num(params["index"]), 0, max_save_slots, -1)
			if(index == -1)
				return CHARACTER_ACT_DATA_UPDATE

			close_subwindows(user)

			if(!load_character(index))
				random_character(null, RANDOMIZE_NEW_CHARACTER)
				save_character()
				verbose_pref_log_notification(user, "notice", "Created new character")
			else
				verbose_pref_log_notification(user, "notice", "Loaded character from savefile")
			return CHARACTER_ACT_PREVIEW_UPDATE
		if("copy_slot")
			if(!path || savefile_write_locked)
				to_chat(user, span_danger("You cannot copy a character at this time."))
				return CHARACTER_ACT_DATA_UPDATE

			var/from_index = sanitize_integer(text2num(params["from"]), 0, max_save_slots, -1)
			if(from_index == -1)
				return CHARACTER_ACT_DATA_UPDATE
			var/to_index = sanitize_integer(text2num(params["to"]), 0, max_save_slots, -1)
			if(to_index == -1)
				return CHARACTER_ACT_DATA_UPDATE

			var/savefile/S = new /savefile(path)
			if(!S)
				return CHARACTER_ACT_DATA_UPDATE

			if(!S.dir.Find("character[from_index]"))
				return CHARACTER_ACT_DATA_UPDATE

			var/from_name
			S["character[from_index]/real_name"] >> from_name

			var/to_name
			if(S.dir.Find("character[to_index]"))
				S["character[to_index]/real_name"] >> to_name

				if(tgui_alert(user, "You are about to overwrite slot #[to_index], containing character [to_name || "ERROR"], with slot #[from_index] containing character [from_name]. This is irreversible, continue?", "IRREVERSIBLE OVERWRITE", list("Get Me Outta Here", "Confirm Overwrite")) != "Confirm Overwrite")
					return CHARACTER_ACT_DATA_UPDATE

			to_chat(user, span_danger("Copying slot #[from_index] ([from_name]) over #[to_index] ([to_name || "None"])"))

			do_copy_slot(S, from_index, to_index)

			to_chat(user, span_danger("Successfully wrote slot #[from_index] ([from_name]) over #[to_index] ([to_name || "None"])."))
			verbose_pref_log_notification(user, "danger", "Copied slot #[from_index] ([from_name]) over #[to_index] ([to_name || "None"])")

			return CHARACTER_ACT_DATA_UPDATE
		if("delete_slot")
			if(!path || savefile_write_locked)
				to_chat(user, span_danger("You cannot delete a character at this time."))
				return CHARACTER_ACT_DATA_UPDATE

			var/index = sanitize_integer(text2num(params["index"]), 0, max_save_slots, -1)
			if(index == -1)
				return CHARACTER_ACT_DATA_UPDATE

			var/savefile/S = new /savefile(path)
			if(!S)
				return CHARACTER_ACT_DATA_UPDATE

			if(index == default_slot)
				to_chat(user, span_danger("You cannot delete the currently selected character."))
				return CHARACTER_ACT_DATA_UPDATE

			S.cd = "/character[index]"
			var/their_name
			S["real_name"] >> their_name

			if(tgui_alert(user, "ARE YOU SURE YOU WANT TO DELETE SLOT [index], CONTAINING CHARACTER [their_name]?", "IRREVERSIBLE DELETION", list("Get Me Outta Here", "Confirm DELETION")) != "Confirm DELETION")
				return CHARACTER_ACT_DATA_UPDATE

			// Bye Becky!
			to_chat(user, span_danger("Beginning deletion of slot [index]..."))

			delete_slot(S, index)

			to_chat(user, span_danger("Slot [index] (Previously Containing [their_name]) has been permanently erased."))
			verbose_pref_log_notification(user, "danger", "Deleted slot [index] (Previously Containing [their_name])")
			return CHARACTER_ACT_DATA_UPDATE

// Protected proc, locks savefile while operating
/datum/preferences/proc/copy_slot(savefile/S, from_index, to_index)
	if(savefile_write_locked)
		return FALSE

	savefile_write_locked = TRUE
	do_copy_slot(S, from_index, to_index)
	// flush changes in case downstream overrode do_copy_slot
	S.Flush()
	savefile_write_locked = FALSE

	return TRUE

// UNSAFE proc, locking is done externally
/datum/preferences/proc/do_copy_slot(savefile/S, from_index, to_index)
	var/exported_text = S.ExportText("character[from_index]")
	S.ImportText("character[to_index]", exported_text)

/* INSTRUCTIONS FOR DOWNSTREAM:
Add a new override in your modular folder that looks like this:
/datum/preferences/do_copy_slot(savefile/S, from_index, to_index)
	. = ..()
	copy_whatever_other_prefs(S, from_index, to_index)
*/

// Protected proc, locks savefile while operating
/datum/preferences/proc/delete_slot(savefile/S, murder_index)
	if(savefile_write_locked)
		return FALSE

	savefile_write_locked = TRUE
	do_delete_slot(S, murder_index)
	// flush changes in case downstream overrode do_delete_slot
	S.Flush()
	savefile_write_locked = FALSE

	return TRUE

// UNSAFE proc, locking is done externally
/datum/preferences/proc/do_delete_slot(savefile/S, murder_index)
	S.cd = "/"
	S.dir.Remove("character[murder_index]")

/* INSTRUCTIONS FOR DOWNSTREAM:
Add a new override in your modular folder that looks like this:
/datum/preferences/do_delete_slot(savefile/S, murder_index)
	. = ..()
	delete_whatever_other_prefs(S, murder_index)
*/
