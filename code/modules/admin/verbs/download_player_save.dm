/client/proc/download_player_save()
	set name = "Download Player Save"
	set desc = ""
	set category = "Server"

	if(!check_rights(R_SERVER))
		return

	var/input_key = input(src, "Enter a ckey (or partial) to search for.", "Download Player Save") as text|null
	if(!input_key)
		return

	var/needle = ckey(input_key)
	if(!needle)
		to_chat(src, span_warning("Invalid ckey."))
		return

	var/shard_letter = copytext(needle, 1, 2)
	var/shard = "data/player_saves/[shard_letter]/"
	var/list/shard_entries = flist(shard)
	if(!length(shard_entries))
		to_chat(src, span_warning("No player saves found under '[shard_letter]'."))
		return

	var/player_dir
	var/target = "[needle]/"
	if(target in shard_entries)
		player_dir = "[shard][target]"
	else
		var/list/matches = list()
		for(var/entry in shard_entries)
			if(findtext(entry, needle))
				matches += entry
		if(!length(matches))
			to_chat(src, span_warning("No ckey matching '[needle]' found."))
			return
		if(length(matches) > 50)
			to_chat(src, span_warning("[length(matches)] matches - please narrow your search."))
			return
		var/picked = input(src, "Select a player save.", "Download Player Save") as null|anything in sortList(matches)
		if(!picked)
			return
		player_dir = "[shard][picked]"

	if(file_spam_check())
		return

	var/path = browse_files(player_dir, valid_extensions = list("sav", "json", "txt", "log"))
	if(!path)
		return

	message_admins("[key_name_admin(src)] downloaded player save file: [path]")
	log_admin("[key_name(src)] downloaded player save file: [path]")
	src << ftp(file(path))
	to_chat(src, "Attempting to send [path], this may take a moment for larger files.")
