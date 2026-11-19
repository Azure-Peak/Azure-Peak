#define IRC_STATUS_THROTTLE 5
// discord notes
// Max length of a single chat message Discords limit is 1970 I think?
#define CHAT_NOTES_MESSAGE_LENGTH 1900
// Max length of a single note
#define CHAT_NOTES_NOTE_LENGTH 1600

/datum/tgs_chat_command/ircstatus
	name = "status"
	help_text = "Gets the admincount, playercount, gamemode, and true game mode of the server"
	admin_only = TRUE
	var/last_irc_status = 0

/datum/tgs_chat_command/ircstatus/Run(datum/tgs_chat_user/sender, params)
	var/rtod = REALTIMEOFDAY
	if(rtod - last_irc_status < IRC_STATUS_THROTTLE)
		return
	last_irc_status = rtod
	var/list/adm = get_admin_counts()
	var/list/allmins = adm["total"]
	var/status = "Admins: [allmins.len] (Active: [english_list(adm["present"])] AFK: [english_list(adm["afk"])] Stealth: [english_list(adm["stealth"])] Skipped: [english_list(adm["noflags"])]). "
	status += "Players: [GLOB.clients.len] (Active: [get_active_player_count(0,1,0)]). Mode: Storytellers."
	return status

/datum/tgs_chat_command/irccheck
	name = "check"
	help_text = "Gets the playercount, gamemode, and address of the server"
	var/last_irc_check = 0

/datum/tgs_chat_command/irccheck/Run(datum/tgs_chat_user/sender, params)
	var/rtod = REALTIMEOFDAY
	if(rtod - last_irc_check < IRC_STATUS_THROTTLE)
		return
	last_irc_check = rtod
	var/server = CONFIG_GET(string/server)
	return "[GLOB.round_id ? "Round #[GLOB.round_id]: " : ""][GLOB.clients.len] players on [SSmapping.config.map_name], Mode: [GLOB.master_mode]; Round [SSticker.HasRoundStarted() ? (SSticker.IsRoundInProgress() ? "Active" : "Finishing") : "Starting"] -- [server ? server : "[world.internet_address]:[world.port]"]"

/datum/tgs_chat_command/ahelp
	name = "ahelp"
	help_text = "<ckey|ticket #> <message|ticket <close|resolve|icissue|reject|reopen <ticket #>|list>>"
	admin_only = TRUE

/datum/tgs_chat_command/ahelp/Run(datum/tgs_chat_user/sender, params)
	var/list/all_params = splittext(params, " ")
	if(all_params.len < 2)
		return "Insufficient parameters"
	var/target = all_params[1]
	all_params.Cut(1, 2)
	var/id = text2num(target)
	if(id != null)
		var/datum/admin_help/AH = GLOB.ahelp_tickets.TicketByID(id)
		if(AH)
			target = AH.initiator_ckey
		else
			return "Ticket #[id] not found!"
	var/res = IrcPm(target, all_params.Join(" "), sender.friendly_name)
	if(res != "Message Successful")
		return res

/datum/tgs_chat_command/namecheck
	name = "namecheck"
	help_text = "Returns info on the specified target"
	admin_only = TRUE

/datum/tgs_chat_command/namecheck/Run(datum/tgs_chat_user/sender, params)
	params = trim(params)
	if(!params)
		return "Insufficient parameters"
	log_admin("Chat Name Check: [sender.friendly_name] on [params]")
	message_admins("Name checking [params] from [sender.friendly_name]")
	return keywords_lookup(params, 1)

/datum/tgs_chat_command/adminwho
	name = "adminwho"
	help_text = "Lists administrators currently on the server"
	admin_only = TRUE

/datum/tgs_chat_command/adminwho/Run(datum/tgs_chat_user/sender, params)
	return ircadminwho()

GLOBAL_LIST(round_end_notifiees)

/datum/tgs_chat_command/endnotify
	name = "endnotify"
	help_text = "Pings the invoker when the round ends"
	admin_only = TRUE

/datum/tgs_chat_command/endnotify/Run(datum/tgs_chat_user/sender, params)
	if(!SSticker.IsRoundInProgress() && SSticker.HasRoundStarted())
		return "[sender.mention], the round has already ended!"
	LAZYINITLIST(GLOB.round_end_notifiees)
	GLOB.round_end_notifiees[sender.mention] = TRUE
	return "I will notify [sender.mention] when the round ends."

/datum/tgs_chat_command/sdql
	name = "sdql"
	help_text = "Runs an SDQL query"
	admin_only = TRUE

/datum/tgs_chat_command/sdql/Run(datum/tgs_chat_user/sender, params)
	if(GLOB.AdminProcCaller)
		return "Unable to run query, another admin proc call is in progress. Try again later."
	GLOB.AdminProcCaller = "CHAT_[sender.friendly_name]"	//_ won't show up in ckeys so it'll never match with a real admin
	var/list/results = world.SDQL2_query(params, GLOB.AdminProcCaller, GLOB.AdminProcCaller)
	GLOB.AdminProcCaller = null
	if(!results)
		return "Query produced no output"
	var/list/text_res = results.Copy(1, 3)
	var/list/refs = results.len > 3 ? results.Copy(4) : null
	. = "[text_res.Join("\n")][refs ? "\nRefs: [refs.Join(" ")]" : ""]"

/datum/tgs_chat_command/reload_admins
	name = "reload_admins"
	help_text = "Forces the server to reload admins."
	admin_only = TRUE

/datum/tgs_chat_command/reload_admins/Run(datum/tgs_chat_user/sender, params)
	ReloadAsync()
	log_admin("[chat_sender_name(sender)] reloaded admins via chat command.")
	return "Admins reloaded."

/datum/tgs_chat_command/reload_admins/proc/ReloadAsync()
	set waitfor = FALSE
	load_admins()

// Whitelist Commands
/datum/tgs_chat_command/whitelist_add
	name = "whitelist_add"
	help_text = "adds a ckey to the whitelist"

/datum/tgs_chat_command/whitelist_add/Run(datum/tgs_chat_user/sender, params)
	params = trim(params)
	if(!params)
		return "Insufficient parameters"

	if(sender.channel.custom_tag != CONFIG_GET(string/chat_command_whitelist))
		return "This command is not allowed in this channel."

	BC_WhitelistKey(params)
	message_admins("[chat_sender_name(sender)] added [params] to the border whitelist.")
	log_admin("[chat_sender_name(sender)] added [params] to the border whitelist.")
	if(CONFIG_GET(string/chat_announce_whitelist))
		send2chat(new /datum/tgs_message_content("[chat_sender_name(sender)] added [params] to the border whitelist via Discord."), CONFIG_GET(string/chat_announce_whitelist))

	return "added [params] to the border whitelist."

/datum/tgs_chat_command/whitelist_remove
	name = "whitelist_remove"
	help_text = "removes a ckey from the whitelist"

/datum/tgs_chat_command/whitelist_remove/Run(datum/tgs_chat_user/sender, params)
	params = trim(params)
	if(!params)
		return "Insufficient parameters"

	if(sender.channel.custom_tag != CONFIG_GET(string/chat_command_whitelist))
		return "This command is not allowed in this channel."

	BC_RemoveKey(params)
	message_admins("[chat_sender_name(sender)] removed [params] from the border whitelist.")
	log_admin("[chat_sender_name(sender)] removed [params] from the border whitelist.")
	if(CONFIG_GET(string/chat_announce_whitelist))
		send2chat(new /datum/tgs_message_content("[chat_sender_name(sender)] removed [params] from the border whitelist via Discord."), CONFIG_GET(string/chat_announce_whitelist))

	return "removed [params] from the border whitelist."

/datum/tgs_chat_command/asay
	name = "asay"
	help_text = "<message> sends a message to in-game admin chat"

/datum/tgs_chat_command/asay/Run(datum/tgs_chat_user/sender, params)
	if(!CONFIG_GET(string/chat_asay) || sender.channel.custom_tag != CONFIG_GET(string/chat_asay))
		return "This command is not allowed in this channel."

	var/msg = emoji_parse(copytext(sanitize(trim(params)), 1, MAX_MESSAGE_LEN))
	if(!msg)
		return "Usage: asay <message>"

	log_adminsay("[chat_sender_name(sender)]: [msg]")
	log_game("[chat_sender_name(sender)] sent an asay message from Discord: [msg]")
	to_chat(GLOB.admins, "<span class='adminsay'><span class='prefix'>DISCORD:</span> <EM>[sender.friendly_name]</EM>: <font color='#FF4500'><span class='message linkify'>[msg]</span></font></span>")
	return "Sent to asay."

// Notes commands
/datum/tgs_chat_command/notes
	name = "notes"
	help_text = "<ckey> lists all of a players notes"

/datum/tgs_chat_command/notes/Run(datum/tgs_chat_user/sender, params)
	var/target_ckey = ckey(params)
	if(!target_ckey)
		return "Insufficient parameters"

	if(!CONFIG_GET(string/chat_command_notes) || sender.channel.custom_tag != CONFIG_GET(string/chat_command_notes))
		return "This command is not allowed in this channel."

	if(!SSdbcore.Connect())
		return "Failed to establish database connection."

	var/datum/DBQuery/query_get_notes = SSdbcore.NewQuery({"
		SELECT
			IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE ckey = adminckey), adminckey),
			text,
			timestamp,
			server,
			expire_timestamp,
			severity,
			id
		FROM [format_table_name("messages")]
		WHERE type = 'note' AND targetckey = :targetckey AND deleted = 0 AND (expire_timestamp > NOW() OR expire_timestamp IS NULL)
		ORDER BY timestamp DESC
	"}, list("targetckey" = target_ckey))
	if(!query_get_notes.warn_execute())
		qdel(query_get_notes)
		return "Failed to fetch notes for [target_ckey]."

	var/list/notes = list()
	while(query_get_notes.NextRow())
		var/admin_key = query_get_notes.item[1]
		var/text = note_text_for_chat(query_get_notes.item[2])
		var/timestamp = query_get_notes.item[3]
		var/server = query_get_notes.item[4]
		var/expire_timestamp = query_get_notes.item[5]
		var/severity = query_get_notes.item[6] ? LOWER_TEXT("[query_get_notes.item[6]]") : "n/a"
		var/id = query_get_notes.item[7]
		notes += "#[id] | [timestamp] | [server] | [admin_key] | [severity] severity[expire_timestamp ? " | expires [expire_timestamp]" : ""]\n[text]"
	qdel(query_get_notes)

	log_admin("Chat Notes Check: [chat_sender_name(sender)] viewed the notes of [target_ckey]")
	if(!length(notes))
		return "[target_ckey] has no notes."

	// Split the notes to fit notes
	var/list/messages = list()
	var/current = "Notes for [target_ckey] ([length(notes)]):"
	for(var/note in notes)
		if(length(current) + length(note) + 2 > CHAT_NOTES_MESSAGE_LENGTH)
			messages += current
			current = note
		else
			current += "\n\n[note]"
	messages += current

	// Send the message
	for(var/i in 1 to length(messages) - 1)
		world.TgsChatBroadcast(new /datum/tgs_message_content(messages[i]), list(sender.channel))
	return messages[length(messages)]

/datum/tgs_chat_command/note_add
	name = "note_add"
	help_text = "<ckey> <high|medium|minor|none> <text> adds a note to a player"

/datum/tgs_chat_command/note_add/Run(datum/tgs_chat_user/sender, params)
	var/list/all_params = splittext(trim(params), " ")
	if(length(all_params) < 3)
		return "Usage: note_add <ckey> <high|medium|minor|none> <text>"
	var/target_ckey = ckey(all_params[1])
	var/note_severity = LOWER_TEXT(all_params[2])
	var/text = trim(jointext(all_params, " ", 3))
	if(!target_ckey || !text)
		return "Insufficient parameters"
	if(!(note_severity in list("high", "medium", "minor", "none")))
		return "Severity must be one of: high, medium, minor, none."

	if(!CONFIG_GET(string/chat_command_notes) || sender.channel.custom_tag != CONFIG_GET(string/chat_command_notes))
		return "This command is not allowed in this channel."

	if(!SSdbcore.Connect())
		return "Failed to establish database connection."

	// Same insert as create_message(), notes are always made secret in game too
	var/datum/DBQuery/query_create_note = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("messages")] (type, targetckey, adminckey, text, timestamp, server, server_ip, server_port, round_id, secret, severity)
		VALUES ('note', :target_ckey, :admin_ckey, :text, :timestamp, :server, INET_ATON(:internet_address), :port, :round_id, 1, :note_severity)
	"}, list(
		"target_ckey" = target_ckey,
		"admin_ckey" = chat_sender_ckey(sender),
		"text" = text,
		"timestamp" = SQLtime(),
		"server" = CONFIG_GET(string/serversqlname),
		"internet_address" = world.internet_address || "0",
		"port" = "[world.port]",
		"round_id" = GLOB.round_id,
		"note_severity" = note_severity,
	))
	if(!query_create_note.warn_execute())
		qdel(query_create_note)
		return "Failed to add the note for [target_ckey]."
	qdel(query_create_note)

	var/header = "[chat_sender_name(sender)] has created a note for [target_ckey]"
	log_admin_private("[header]: [text]")
	message_admins("[header]:<br>[text]")
	admin_ticket_log(target_ckey, "<font color='blue'>[header]</font>")
	admin_ticket_log(target_ckey, text)
	announce_note_change("NOTES: [chat_sender_name(sender)] added a [note_severity] severity note for [target_ckey]: [note_text_for_chat(text)]")

	return "Added a [note_severity] severity note for [target_ckey]."

/datum/tgs_chat_command/note_remove
	name = "note_remove"
	help_text = "<note id> deletes a player note, the id is shown by the notes command"

/datum/tgs_chat_command/note_remove/Run(datum/tgs_chat_user/sender, params)
	var/message_id = text2num(trim(replacetext(params, "#", "")))
	if(!message_id)
		return "Usage: note_remove <note id>"

	if(!CONFIG_GET(string/chat_command_notes) || sender.channel.custom_tag != CONFIG_GET(string/chat_command_notes))
		return "This command is not allowed in this channel."

	if(!SSdbcore.Connect())
		return "Failed to establish database connection."

	// Same as delete_message() limited to notes
	var/datum/DBQuery/query_find_del_message = SSdbcore.NewQuery(
		"SELECT IFNULL((SELECT byond_key FROM [format_table_name("player")] WHERE ckey = targetckey), targetckey), text FROM [format_table_name("messages")] WHERE id = :id AND type = 'note' AND deleted = 0",
		list("id" = message_id)
	)
	if(!query_find_del_message.warn_execute())
		qdel(query_find_del_message)
		return "Failed to look up note #[message_id]."
	if(!query_find_del_message.NextRow())
		qdel(query_find_del_message)
		return "No note with id #[message_id] was found."
	var/target_key = query_find_del_message.item[1]
	var/text = query_find_del_message.item[2]
	qdel(query_find_del_message)

	var/datum/DBQuery/query_del_message = SSdbcore.NewQuery(
		"UPDATE [format_table_name("messages")] SET deleted = 1, deleted_ckey = :deleted_ckey WHERE id = :id",
		list("deleted_ckey" = chat_sender_ckey(sender), "id" = message_id)
	)
	if(!query_del_message.warn_execute())
		qdel(query_del_message)
		return "Failed to delete note #[message_id]."
	qdel(query_del_message)

	log_admin_private("[chat_sender_name(sender)] has deleted a note for [target_key]: [text]")
	message_admins("[chat_sender_name(sender)] has deleted a note for [target_key]:<br>[text]")
	announce_note_change("NOTES: [chat_sender_name(sender)] deleted a note for [target_key]: [note_text_for_chat(text)]")

	return "Deleted note #[message_id] for [target_key]."

//// Procs
// Sends a message to the tagged channel
/proc/announce_note_change(message)
	if(CONFIG_GET(string/chat_announce_notes))
		send2chat(new /datum/tgs_message_content(message), CONFIG_GET(string/chat_announce_notes))

// Makes notes short enough to send to chat
/proc/note_text_for_chat(text, max_length = CHAT_NOTES_NOTE_LENGTH)
	text = replacetext("[text]", "<br>", "\n")
	if(length(text) > max_length)
		text = "[copytext(text, 1, max_length)]..."
	return strip_html_simple(text, max_length + 4)

// Return Name and discord ID for use in adminckey
/proc/chat_sender_ckey(datum/tgs_chat_user/sender)
	var/id = copytext("[sender.id]", 1, 21)
	return "[copytext(ckey(sender.friendly_name), 1, 32 - length(id))]-[id]"

// Return name and discord ID
/proc/chat_sender_name(datum/tgs_chat_user/sender)
	return "[sender.friendly_name] (Discord ID: [sender.id])"

// Relays to the asay tagged channel strips html and stops @
/proc/relay_asay_to_chat(sender_name, msg)
	if(!CONFIG_GET(string/chat_asay))
		return
	msg = html_decode(strip_html_simple("[msg]", MAX_MESSAGE_LEN))
	msg = replacetext(msg, "@", "@[ascii2text(8203)]")
	send2chat(new /datum/tgs_message_content("**ASAY:** [sender_name]: [msg]"), CONFIG_GET(string/chat_asay))

#undef IRC_STATUS_THROTTLE
// discord notes
#undef CHAT_NOTES_MESSAGE_LENGTH
#undef CHAT_NOTES_NOTE_LENGTH
