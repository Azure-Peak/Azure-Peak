/datum/keybinding/dsay
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST
	hotkey_keys = list("U")
	name = "DSAY"
	full_name = "Dead Chat"
	description = "Chat for ghosts."

/datum/keybinding/dsay/down(client/user)
	user.get_dead_say()
	return TRUE


/client/proc/get_dead_say()
	if (!isobserver(mob) && !holder)
		to_chat(src, span_danger("I need to be a ghost to use dead-chat!"))
		return

	var/msg = input(src, null, "dsay \"text\"") as text|null

	if (isnull(msg))
		return

	do_dsay(msg)


/client/verb/dsay()
	set name = "DSAY"
	set desc = "Dead Chat. OOC chat visible only to ghosts."
	set category = "OOC"

	get_dead_say()


/client/proc/do_dsay(msg as text)
	if(!mob)
		return

	if(!holder)
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in DSAY: [msg]")
			return

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(src, span_danger("Speech is currently admin-disabled."))
		return

	if(prefs.muted & MUTE_DEADCHAT)
		to_chat(src, span_danger("I cannot use DSAY (temp muted)."))
		return

	if(is_banned_from(ckey, "Deadchat"))
		to_chat(src, span_danger("I cannot use DSAY (perma muted)."))
		return

	if(handle_spam_prevention(msg, MUTE_DEADCHAT))
		return

	if(!(prefs.chat_toggles & CHAT_DSAY))
		to_chat(src, span_danger("You have DSAY muted."))
		return

	msg = copytext(sanitize(msg), 1, MAX_MESSAGE_LEN)
	mob.log_talk(msg, LOG_DSAY)

	if(!msg)
		return

	var/rank_name
	var/player_name = mob.name
	var/deadbarks = pick("moans", "groans", "complains", "whines")
	var/adjectives = pick("Ghastly", "Spectral", "Phantom", "Spooky")

	if(src in GLOB.admins)
		rank_name = holder.rank
		if(holder.fakekey)
			rank_name = pick(strings("admin_nicknames.json", "ranks", "config"))
			player_name = pick(strings("admin_nicknames.json", "names", "config"))
	if(ckey in GLOB.anonymize)
		player_name = "[adjectives] Spectator"

	for(var/mob/M in GLOB.player_list)
		if(!(M.client.prefs.chat_toggles & CHAT_DSAY))
			continue

		var/prefix = "DSAY: "
		if(M.client in GLOB.admins)
			prefix += "([mob.ckey]) <A href='?_src_=holder;[HrefToken()];adminplayeropts=[REF(mob)]]'>\[PP\]</font></a>"

		var/rendered = span_gamedeadsay("<span class='prefix'>[prefix]</span> <span class='name'>[rank_name ? "([rank_name])" : ""][player_name]</span> [deadbarks], <span class='dsayspeech'>\"[emoji_parse(msg)]\"</span>")
		if(isobserver(M) || (M.client in GLOB.admins))
			to_chat(M, rendered)
