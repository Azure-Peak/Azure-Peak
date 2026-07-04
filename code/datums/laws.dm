/**
 * UI holder for managing the laws in 'Set laws'.
 *
 * Supersedes the old 'make/remove law' system; however the old one is still in place for backwards compatibility (i.e. Marshal abilities).
 */

/datum/laws_menu
	/// Announcement header when laws are changed
	var/change_announcement_text = "LAWS AMENDED"
	/// Announcement header when all laws are purged
	var/purge_announcement_text = "LAWS PURGED"
	/// Maximum number of laws permitted
	var/max_laws = 20

/datum/laws_menu/New(change_text = null, purge_text = null)
	. = ..()
	if(change_text)
		src.change_announcement_text = change_text
	if(purge_text)
		src.purge_announcement_text = purge_text

/datum/laws_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "LawsMenu", "Laws of the Land")
		ui.open()

/datum/laws_menu/ui_static_data(mob/user)
	var/list/data = list()
	data["max_laws"] = max_laws
	return data

/datum/laws_menu/ui_data(mob/user)
	var/list/data = list()
	var/list/current_laws = list()
	for(var/i in 1 to length(GLOB.laws_of_the_land))
		current_laws += list(list(
			"index" = i,
			"text" = GLOB.laws_of_the_land[i],
		))
	data["current_laws"] = current_laws
	return data

/datum/laws_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		// Batch replace: wipe existing laws and set new ones
		if("set_laws")
			var/list/new_laws = params["laws"]
			if(!islist(new_laws))
				return FALSE

			var/list/clean_laws = list()
			for(var/entry in new_laws)
				var/law_text = entry["text"]
				if(!law_text || !length(trim(law_text)))
					continue
				if(length(clean_laws) >= max_laws)
					break
				law_text = copytext(trim(law_text), 1, 501)
				clean_laws += law_text

			// Check if anything actually changed
			if(lists_equal(clean_laws, GLOB.laws_of_the_land))
				to_chat(usr, span_notice("The laws remain unchanged."))
				return FALSE

			GLOB.laws_of_the_land = clean_laws

			var/mob/living/carbon/human/ruler = ui.user
			var/ruler_title = ruler.get_role_title()
			var/ruler_name = ruler.real_name

			if(length(GLOB.laws_of_the_land))
				var/list/law_lines = list()
				for(var/i in 1 to length(GLOB.laws_of_the_land))
					law_lines += "[i]. [GLOB.laws_of_the_land[i]]"
				var/law_text = jointext(law_lines, "\n")
				priority_announce("[ruler_title] [ruler_name] has modified the laws of the land.\n\n[law_text]", change_announcement_text, pick('sound/misc/new_law.ogg', 'sound/misc/new_law2.ogg'), "Captain")
			else
				priority_announce("All laws of the land have been purged!", purge_announcement_text, 'sound/misc/lawspurged.ogg', "Captain")

			return TRUE

		// Purge all laws outright
		if("purge_laws")
			if(!length(GLOB.laws_of_the_land))
				return FALSE
			GLOB.laws_of_the_land = list()
			priority_announce("All laws of the land have been purged!", purge_announcement_text, 'sound/misc/lawspurged.ogg', "Captain")
			return TRUE

/datum/laws_menu/ui_state(mob/user)
	return GLOB.conscious_state

/// Helper: compare two flat string lists for equality
/proc/lists_equal(list/a, list/b)
	if(length(a) != length(b))
		return FALSE
	for(var/i in 1 to length(a))
		if(a[i] != b[i])
			return FALSE
	return TRUE
