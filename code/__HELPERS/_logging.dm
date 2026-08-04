//wrapper macros for easier grepping
#define DIRECT_OUTPUT(A, B) A << B
#define SEND_IMAGE(target, image) DIRECT_OUTPUT(target, image)
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)
#define SEND_TEXT(target, text) DIRECT_OUTPUT(target, text)
#define WRITE_FILE(file, text) DIRECT_OUTPUT(file, text)
#define logtime time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")

//This is an external call, "true" and "false" are how rust parses out booleans
#define WRITE_LOG(log, text) rustg_log_write(log, text, "true")
#define WRITE_LOG_NO_FORMAT(log, text) rustg_log_write(log, text, "false")
#define SET_SERIALIZATION_SEMVER(semver_list, semver) semver_list[type] = semver

//print a warning message to world.log
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [UNLINT(src)] usr: [usr].")
/proc/warning(msg)
	msg = "## WARNING: [msg]"
	log_world(msg)

//not an error or a warning, but worth to mention on the world log, just in case.
#define NOTICE(MSG) notice(MSG)
/proc/notice(msg)
	msg = "## NOTICE: [msg]"
	log_world(msg)

//print a testing-mode debug message to world.log and world
#ifdef TESTING
#define testing(msg) log_world("## TESTING: [msg]"); to_chat(world, "## TESTING: [msg]")
#else
#define testing(msg)
#endif

#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)
/proc/log_test(text)
	WRITE_LOG(GLOB.test_log, text)
	SEND_TEXT(world.log, text)
#endif

/proc/log_admin(text)
	GLOB.admin_log.Add(text)
	logger.Log(LOG_CATEGORY_ADMIN, text)

/proc/log_admin_private(text)
	GLOB.admin_log.Add(text)
	logger.Log(LOG_CATEGORY_ADMIN_PRIVATE, text)

/proc/log_adminsay(text)
	GLOB.admin_log.Add(text)
	logger.Log(LOG_CATEGORY_ADMIN_PRIVATE_ASAY, text)

/proc/log_dsay(text)
	logger.Log(LOG_CATEGORY_ADMIN_DSAY, text)

/// Logging for generic/unsorted game messages
/proc/log_game(text)
	logger.Log(LOG_CATEGORY_GAME, text)

/proc/log_mecha(text)
	CRASH("Deprecated log_mecha")

/proc/log_virus(text)
	CRASH("Deprecated log_virus")

/proc/log_cloning(text, mob/initiator)
	CRASH("Deprecated log_cloning")

/proc/log_paper(text)
	logger.Log(LOG_CATEGORY_GAME_PAPER, text)

/proc/log_asset(text)
	logger.Log(LOG_CATEGORY_DEBUG_ASSET, text)

/proc/log_access(text)
	logger.Log(LOG_CATEGORY_GAME_ACCESS, text)

/proc/log_law(text)
	CRASH("Deprecated log_law")

/proc/log_seen_internal(text)
	// Do nothing! 

/proc/log_attack(text)
	logger.Log(LOG_CATEGORY_ATTACK, text)

/proc/log_manifest(ckey, datum/mind/mind, mob/body, latejoin = FALSE)
	logger.Log(LOG_CATEGORY_MANIFEST, "[ckey] \\ [body.real_name] \\ [mind.assigned_role] \\ [mind.special_role ? mind.special_role : "NONE"] \\ [latejoin ? "LATEJOIN":"ROUNDSTART"]")

/proc/log_quest(ckey, datum/mind/mind, mob/body, text)
	logger.Log(LOG_CATEGORY_QUEST, "[ckey] \\ [body.real_name] \\ [text]")

/proc/log_bomber(atom/user, details, atom/bomb, additional_details, message_admins = TRUE)
	var/bomb_message = "[details][bomb ? " [bomb.name] at [AREACOORD(bomb)]": ""][additional_details ? " [additional_details]" : ""]."

	if(user)
		user.log_message(bomb_message, LOG_GAME) //let it go to individual logs as well as the game log
		bomb_message = "[key_name(user)] at [AREACOORD(user)] [bomb_message]"
	else
		log_game(bomb_message)

	GLOB.bombers += bomb_message

	if(message_admins)
		message_admins("[user ? "[ADMIN_LOOKUPFLW(user)] at [ADMIN_VERBOSEJMP(user)] " : ""][details][bomb ? " [bomb.name] at [ADMIN_VERBOSEJMP(bomb)]": ""][additional_details ? " [additional_details]" : ""].")

/proc/log_say(text)
	logger.Log(LOG_CATEGORY_GAME_SAY, text)

/proc/log_npc_say(text)
    logger.Log(LOG_CATEGORY_GAME_SAY, text)

/proc/log_ooc(text)
	logger.Log(LOG_CATEGORY_GAME_OOC, text)

/proc/log_looc(text)
	logger.Log(LOG_CATEGORY_GAME_LOOC, text)

/proc/log_whisper(text)
	logger.Log(LOG_CATEGORY_GAME_WHISPER, text)

/proc/log_emote(text)
	logger.Log(LOG_CATEGORY_GAME_EMOTE, text)

/proc/log_prayer(text)
	logger.Log(LOG_CATEGORY_GAME_PRAYER, text)

/proc/log_pda(text)
	CRASH("Deprecated log_pda")

/proc/log_comment(text)
	CRASH("Deprecated log_comment")

/proc/log_telecomms(text)
	CRASH("Deprecated log_telecomms")

/proc/log_chat(text)
	CRASH("Deprecated log_chat")

/proc/log_craft(text)
	logger.Log(LOG_CATEGORY_GAME_CRAFT, text)

/proc/log_vote(text)
	logger.Log(LOG_CATEGORY_GAME_VOTE, text)

/proc/log_topic(text)
	logger.Log(LOG_CATEGORY_GAME_TOPIC, text)

/proc/log_href(text)
	logger.Log(LOG_CATEGORY_HREF, text)

/proc/log_sql(text)
	logger.Log(LOG_CATEGORY_DEBUG_SQL, text)

/proc/log_qdel(text, list/data)
	logger.Log(LOG_CATEGORY_QDEL, text, data)

/proc/log_query_debug(text)
	log_sql(text)

/proc/log_job_debug(text)
	logger.Log(LOG_CATEGORY_DEBUG_JOB, text)

/* Log to both DD and the logfile. */
/proc/log_world(text)
#ifdef USE_CUSTOM_ERROR_HANDLER
	logger.Log(LOG_CATEGORY_RUNTIME, text)
#endif
	SEND_TEXT(world.log, text)

/* Log to the logfile only. */
/proc/log_runtime(text)
	logger.Log(LOG_CATEGORY_RUNTIME, text)

/* Rarely gets called; just here in case the config breaks. */
/proc/log_config(text)
	logger.Log(LOG_CATEGORY_CONFIG, text)
	SEND_TEXT(world.log, text)

/proc/log_mapping(text)
	logger.Log(LOG_CATEGORY_DEBUG_MAPPING, text)

/proc/log_character(text)
	logger.Log(LOG_CATEGORY_CHARACTER, text)

/proc/log_hunted(text)
	logger.Log(LOG_CATEGORY_HUNTED, text)

/**
 * Appends a tgui-related log entry. All arguments are optional.
 */
/proc/log_tgui(
	user,
	message,
	context,
	datum/tgui_window/window,
	datum/src_object,
)

	var/entry = ""
	// Insert user info
	if(!user)
		entry += "<nobody>"
	else if(istype(user, /mob))
		var/mob/mob = user
		entry += "[mob.ckey] (as [mob] at [mob.x],[mob.y],[mob.z])"
	else if(istype(user, /client))
		var/client/client = user
		entry += "[client.ckey]"
	// Insert context
	if(context)
		entry += " in [context]"
	else if(window)
		entry += " in [window.id]"
	// Resolve src_object
	if(!src_object && window?.locked_by)
		src_object = window.locked_by.src_object
	// Insert src_object info
	if(src_object)
		entry += "\nUsing: [src_object.type] [REF(src_object)]"
	// Insert message
	if(message)
		entry += "\n[message]"
	logger.Log(LOG_CATEGORY_HREF_TGUI, entry)

/proc/log_storyteller(text, list/data)
	log_game("STORYTELLERS: [text]")

/* For logging round startup. */
/proc/start_log(log)
	WRITE_LOG(log, "Starting up round ID [GLOB.rogue_round_id].\n-------------------------")

/* Close open log handles. This should be called as late as possible, and no logging should hapen after. */
/proc/shutdown_logging()
	rustg_log_close_all()
	logger.shutdown_logging()

/* Helper procs for building detailed log lines */
/proc/key_name(whom, include_link = null, include_name = TRUE)
	var/mob/M
	var/client/C
	var/key
	var/ckey
	var/fallback_name

	if(!whom)
		return "*null*"
	if(istype(whom, /client))
		C = whom
		M = C.mob
		key = C.key
		ckey = C.ckey
	else if(ismob(whom))
		M = whom
		C = M.client
		key = M.key
		ckey = M.ckey
	else if(istext(whom))
		key = whom
		ckey = ckey(whom)
		C = GLOB.directory[ckey]
		if(C)
			M = C.mob
	else if(istype(whom,/datum/mind))
		var/datum/mind/mind = whom
		key = mind.key
		ckey = ckey(key)
		if(mind.current)
			M = mind.current
			if(M.client)
				C = M.client
		else
			fallback_name = mind.name
	else // Catch-all cases if none of the types above match
		var/swhom = null

		if(istype(whom, /atom))
			var/atom/A = whom
			swhom = "[A.name]"
		else if(istype(whom, /datum))
			swhom = "[whom]"

		if(!swhom)
			swhom = "*invalid*"

		return "\[[swhom]\]"

	. = ""

	if(!ckey)
		include_link = FALSE

	if(key)
		if(C && C.holder && C.holder.fakekey && !include_name)
			if(include_link)
				. += "<a href='?priv_msg=[C.findStealthKey()]'>"
			. += "Administrator"
		else
			if(include_link)
				. += "<a href='?priv_msg=[ckey]'>"
			. += key
		if(!C)
			. += "\[DC\]"

		if(include_link)
			. += "</a>"
	else
		. += "*no key*"

	if(include_name)
		if(M)
			if(M.real_name)
				. += "/([M.real_name])"
			else if(M.name)
				. += "/([M.name])"
		else if(fallback_name)
			. += "/([fallback_name])"

	return .

/proc/key_name_admin(whom, include_name = TRUE)
	return key_name(whom, TRUE, include_name)

/proc/loc_name(atom/A)
	if(!istype(A))
		return "(INVALID LOCATION)"

	var/turf/T = A
	if (!istype(T))
		T = get_turf(A)

	if(istype(T))
		return "([AREACOORD(T)])"
	else if(A.loc)
		return "(UNKNOWN (?, ?, ?))"
