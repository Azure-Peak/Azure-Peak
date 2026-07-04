/datum/emote/living/subtle
	key = "subtle"
	key_third_person = "subtleemote"
#ifdef MATURESERVER
	message_param = "%t"
#endif

/datum/emote/living/subtle/can_run_emote(mob/user, status_check, intentional)
	. = ..() && intentional

/datum/emote/living/subtle/run_emote(mob/user, params, type_override = null, intentional = FALSE)
	if(!can_run_emote(user, TRUE, intentional))
		return FALSE
	if(is_banned_from(user.ckey, "Emote"))
		to_chat(user, "<span class='boldwarning'>I cannot send custom emotes (banned).</span>")
		return FALSE
	else if(QDELETED(user))
		return FALSE
	else if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, "<span class='boldwarning'>I cannot send IC messages (muted).</span>")
		return FALSE
	else if(!params)
		var/custom_emote = copytext(sanitize(input("What does your character subtly do?") as text|null), 1, MAX_MESSAGE_LEN)
		if(custom_emote)
			message = custom_emote
			emote_type = EMOTE_VISIBLE
	else
		message = params
		if(type_override)
			emote_type = type_override

	user.log_message("SUBTLE - " + message, LOG_EMOTE)
	if(findtext(message, "$n"))
		message = trim(replacetext(message, "$n", "<b>[user]</b>"))
	else
		message = "<b>[user]</b> " + message
/*
	for(var/mob/M in GLOB.dead_mob_list)
		if(!M.client || isnewplayer(M))
			continue
		var/T = get_turf(user)
		if(M.stat == DEAD && M.client && (M.client.prefs?.chat_toggles & CHAT_GHOSTSIGHT) && !(M in viewers(T, null)))
			M.show_message(message)*/
	user.do_subtle_emote(message)

/mob/proc/do_subtle_emote(var/message)
	var/distance = 4
	var/list/ghostless = get_hearers_in_view(distance, src)
	var/list/mobsinview = list()
	var/list/mobspickable = list("1-Tile Range", "Same Tile")
	for(var/mob/living/L in ghostless)
		if(L.stat != DEAD && L != src) // to those living only - slightly more expensive but subtle is not spammed
			mobsinview += L
			if(!L.rogue_sneaking && L.name != "Unknown") // do not let hidden/unknown targets be added to list
				mobspickable += L
	var/choice = input(src, "Pick a target?", "Subtle Emote") in mobspickable
	to_chat(src, "<i>[message]</i>")

	var/user_loc
	if(choice == "1-Tile Range")
		distance = 1
	else if(choice == "Same Tile")
		distance = 0
	else // we picked a target
		var/mob/living/target = choice
		if(!isliving(target) || QDELETED(target)) // mob has since been deleted/destroyed, skip
			to_chat(src, span_boldwarning("The subtle emote target no longer exists, try again."))
			return
		user_loc = get_turf(src)
		if(get_dist(get_turf(target), user_loc) <= distance)
			to_chat(target, "<i>[message]</i>")
			target.playsound_local(target, 'sound/misc/subtle_emote.ogg', 100)
		else
			to_chat(src, span_boldwarning("The subtle emote target moved out of view, try again."))
		return

	if(!mobsinview.len) // nobody to target, don't test distance
		return
	user_loc = get_turf(src)
	for(var/mob/living/L in mobsinview)
		if(!isliving(L) || QDELETED(L)) // mob has since been deleted/destroyed, skip
			continue
		if(get_dist(get_turf(L), user_loc) <= distance)
			to_chat(L, "<i>[message]</i>")
			L.playsound_local(L, 'sound/misc/subtle_emote.ogg', 100)

