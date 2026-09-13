//Sends resource files to client cache
/client/proc/getFiles(...)
	for(var/file in args)
		src << browse_rsc(file)

/proc/wrap_file(filepath)
	if(IsAdminAdvancedProcCall())
		// Admins shouldnt fuck with this
		to_chat(usr, "<span class='boldannounceooc'>File load blocked: Advanced ProcCall detected.</span>")
		message_admins("[key_name(usr)] attempted to load files via advanced proc-call")
		log_admin("[key_name(usr)] attempted to load files via advanced proc-call")
		return

	return file(filepath)

/proc/wrap_file2text(filepath)
	if(IsAdminAdvancedProcCall())
		// Admins shouldnt fuck with this
		to_chat(usr, "<span class='boldannounceooc'>File load blocked: Advanced ProcCall detected.</span>")
		message_admins("[key_name(usr)] attempted to load files via advanced proc-call")
		log_admin("[key_name(usr)] attempted to load files via advanced proc-call")
		return

	return file2text(filepath)


/client/proc/browse_files(root="data/logs/", max_iterations=10, list/valid_extensions=list("txt","log","htm", "html", "json"))
	var/path = root

	for(var/i=0, i<max_iterations, i++)
		var/list/choices = flist(path)
		if(path != root)
			choices.Insert(1,"/")

		var/choice = input(src,"Choose a file to access:","Download",null) as null|anything in sortList(choices)
		switch(choice)
			if(null)
				return
			if("/")
				path = root
				continue
		path += choice

		if(copytext(path,-1,0) != "/")		//didn't choose a directory, no need to iterate again
			break
	var/extensions
	for(var/i in valid_extensions)
		if(extensions)
			extensions += "|"
		extensions += "[i]"
	var/regex/valid_ext = new("\\.([extensions])$", "i")
	if( !fexists(path) || !(valid_ext.Find(path)) )
		to_chat(src, "<font color='red'>Error: browse_files(): File not found/Invalid file([path]).</font>")
		return

	return path

#define FTPDELAY 200	//200 tick delay to discourage spam
#define ADMIN_FTPDELAY_MODIFIER 0.5		//Admins get to spam files faster since we ~trust~ them!
/*	This proc is a failsafe to prevent spamming of file requests.
	It is just a timer that only permits a download every [FTPDELAY] ticks.
	This can be changed by modifying FTPDELAY's value above.

	PLEASE USE RESPONSIBLY, Some log files can reach sizes of 4MB!	*/
/client/proc/file_spam_check()
	var/time_to_wait = GLOB.fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: file_spam_check(): Spam. Please wait [DisplayTimeText(time_to_wait)].</font>")
		return 1
	var/delay = FTPDELAY
	if(holder)
		delay *= ADMIN_FTPDELAY_MODIFIER
	GLOB.fileaccess_timer = world.time + delay
	return 0
#undef FTPDELAY
#undef ADMIN_FTPDELAY_MODIFIER

/**
 * Takes a directory and returns every file within every sub directory.
 * If extensions_filter is provided then only files that end in that extension are given back.
 * If extensions_filter is a list, any file that matches at least one entry is given back.
 */
/proc/pathwalk(path, extensions_filter)
	var/list/jobs = list(path)
	var/list/filenames = list()

	while(jobs.len)
		var/current_dir = pop(jobs)
		var/list/new_filenames = flist(current_dir)
		for(var/new_filename in new_filenames)
			// if filename ends in / it is a directory, append to currdir
			if(findtext(new_filename, "/", -1))
				jobs += "[current_dir][new_filename]"
				continue
			// filename extension filtering
			if(extensions_filter)
				if(islist(extensions_filter))
					for(var/allowed_extension in extensions_filter)
						if(endswith(new_filename, allowed_extension))
							filenames += "[current_dir][new_filename]"
							break
				else if(endswith(new_filename, extensions_filter))
					filenames += "[current_dir][new_filename]"
			else
				filenames += current_dir + new_filename
				filenames += "[current_dir][new_filename]"
	return filenames

/proc/pathflatten(path)
	return replacetext(path, "/", "_")

#define MUSIC_MAX_SIZE (4 * 1024 * 1024)
#define MUSIC_MAX_LENGTH (15 MINUTES)

/proc/music_upload(mob/user, atom/source, max_size = MUSIC_MAX_SIZE)
	var/ckey = user?.ckey
	if(!ckey)
		return

	var/client/uploader = user.client
	if(uploader)
		uploader.upload_limit = max_size
		uploader.upload_exts = list(".ogg")

	var/infile = input(user, "CHOOSE A NEW SONG", "[source]") as null|file

	if(uploader)
		uploader.upload_limit = null
		uploader.upload_exts = null

	if(!infile || QDELETED(user) || QDELETED(source) || user.ckey != ckey)
		return

	var/filename = "[infile]"
	filename = copytext(filename, findlasttext(filename, "/") + 1)
	filename = copytext(filename, findlasttext(filename, "\\") + 1)
	filename = SANITIZE_FILENAME(filename)
	while(length(filename) && (copytext(filename, 1, 2) == "." || copytext(filename, 1, 2) == " "))
		filename = copytext(filename, 2)

	if(length(filename) < 5 || LOWER_TEXT(copytext(filename, -4)) != ".ogg")
		to_chat(user, span_warning("THAT IS NOT THE RIGHT STYLE."))
		return
	if(length(filename) > 96)
		to_chat(user, span_warning("THAT NAME IS TOO LONG."))
		return

	var/static/list/reserved = list(
		"con", "prn", "aux", "nul",
		"com1", "com2", "com3", "com4", "com5", "com6", "com7", "com8", "com9",
		"lpt1", "lpt2", "lpt3", "lpt4", "lpt5", "lpt6", "lpt7", "lpt8", "lpt9",
	)
	if(LOWER_TEXT(copytext(filename, 1, -4)) in reserved)
		to_chat(user, span_warning("THAT NAME IS NOT ALLOWED."))
		return

	var/size = length(infile)
	if(size < 64)
		to_chat(user, span_warning("THAT IS NOT A SONG."))
		return
	if(size > max_size)
		to_chat(user, span_warning("TOO BIG. [round(max_size / (1024 * 1024), 0.1)] MEGABYTES OR LESS."))
		return

	var/static/notch = 0
	notch = WRAP(notch + 1, 0, SHORT_REAL_LIMIT)
	var/scratch = "tmp/musicupload.[ckey].[notch].ogg"
	if(!fcopy(infile, scratch))
		to_chat(user, span_warning("THE SONG WOULD NOT TAKE."))
		return

	var/duration = rustg_sound_length(scratch)
	if(!isnum(duration) || duration <= 0)
		fdel(scratch)
		message_admins("[ADMIN_LOOKUPFLW(user)] tried to upload [filename] ([size] bytes), which is not playable audio.")
		log_game("[key_name(user)] tried to upload undecodable audio named [filename] ([size] bytes).")
		to_chat(user, span_warning("THAT IS NOT A SONG."))
		return
	if(duration > MUSIC_MAX_LENGTH)
		fdel(scratch)
		to_chat(user, span_warning("TOO LONG. [MUSIC_MAX_LENGTH / (1 MINUTES)] MINUTES OR LESS."))
		return

	var/header = file2text(scratch)
	if(length(header) && copytext(header, 1, 5) != "OggS")
		fdel(scratch)
		message_admins("[ADMIN_LOOKUPFLW(user)] tried to upload [filename] ([size] bytes), which is not an Ogg.")
		log_game("[key_name(user)] tried to upload a non-Ogg file named [filename] ([size] bytes).")
		to_chat(user, span_warning("THIS IS NOT THE RIGHT STYLE."))
		return

	if(QDELETED(source))
		fdel(scratch)
		return

	var/path = "data/jukeboxuploads/[ckey]/[filename]"
	if(!fcopy(scratch, path))
		fdel(scratch)
		to_chat(user, span_warning("THE SONG WOULD NOT TAKE."))
		return
	fdel(scratch)

	message_admins("[ADMIN_LOOKUPFLW(user)] uploaded a song [filename], [round(size / (1024 * 1024), 0.01)] MB and [round(duration / (1 SECONDS))] seconds long.")
	log_game("[key_name(user)] uploaded a music file to [path] ([size] bytes).")
	return file(path)

/proc/music_prune()
	var/root = "data/jukeboxuploads/"
	for(var/folder in flist(root))
		for(var/song in flist("[root][folder]"))
			fdel("[root][folder][song]")
		fdel("[root][folder]")
	fdel(root)

/// Save file as an external file then md5 it.
/// Used because md5ing files stored in the rsc sometimes gives incorrect md5 results.
/// https://www.byond.com/forum/post/2611357
/proc/md5asfile(file)
	var/static/notch = 0
	// its importaint this code can handle md5filepath sleeping instead of hard blocking, if it's converted to use rust_g.
	var/filename = "tmp/md5asfile.[world.realtime].[world.timeofday].[world.time].[world.tick_usage].[notch]"
	notch = WRAP(notch+1, 0, 2**15)
	fcopy(file, filename)
	. = rustg_hash_file(RUSTG_HASH_MD5, filename)
	fdel(filename)
