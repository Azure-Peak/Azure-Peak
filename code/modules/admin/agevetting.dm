// This is almost entirely a copy paste of the Ratwood bunker system repurposed for adding in Age vetted people.
// Agevets matter more than simple whitelist access, so the approach is a bit different.
// We currently store age vets in an assoc list locally.
// The keys: player ckeys, values: the admin who added them.

GLOBAL_LIST_INIT(agevetted_list, load_agevets_from_file())
GLOBAL_PROTECT(agevetted_list)

/client/proc/check_agevet()
	if(LAZYACCESS(GLOB.agevetted_list, ckey) || holder)
		return TRUE
	return FALSE

/mob/proc/check_agevet()
	if(client)
		return client.check_agevet()
	if(LAZYACCESS(GLOB.agevetted_list, ckey) || copytext(key,1,2)=="@") //aghosted people stay verified
		return TRUE
	return FALSE

/client/proc/agevet_player()
	set category = "-Server-"
	set name = "BC - Add Age Vetted"

	if(!check_rights())
		return

	var/selection = input("Who would you like to verify?", "CKEY", "") as text|null
	if(selection)
		if(alert(src, "Confirm: [selection] as being ID verified?", "Age Vetting", "Yes!", "No") == "Yes!")
			add_agevet(selection, ckey, src) // keep the client ref to save us a duplicate list call

/proc/add_agevet(target_ckey, admin_ckey = "SYSTEM", clientref)
	if(!target_ckey || (target_ckey in GLOB.agevetted_list))
		return

	if(IsAdminAdvancedProcCall())
		return

	if(LAZYACCESS(GLOB.agevetted_list, target_ckey))
		to_chat(clientref, span_warning("The ckey \"[target_ckey]\" has already been ID vetted."))
		return

	target_ckey = ckey(target_ckey)
	GLOB.agevetted_list[target_ckey] = admin_ckey
	message_admins("ID VETTING: Added [target_ckey] to the agevetted list[admin_ckey? " by [admin_ckey]":""]")
	log_admin("ID VETTING: Added [target_ckey] to the agevetted list[admin_ckey? " by [admin_ckey]":""]")
	save_agevets_to_file()
	log_agevet_to_csv(target_ckey, admin_ckey)
	if(CONFIG_GET(string/chat_announce_verify))
		send2chat(new /datum/tgs_message_content("ID VETTING: Added [target_ckey] to the agevetted list[admin_ckey? " by [admin_ckey]":""]"), CONFIG_GET(string/chat_announce_verify))

	// if they're online, notify
	var/recipient = LAZYACCESS(GLOB.directory, target_ckey)
	if(recipient)
		to_chat(recipient, span_notice("Good news! You are now ID verified."))

// Read/write the assoc list. Player ckey maps to vetting admin ckey.
/proc/load_agevets_from_file()
	var/json_file = file("data/agevets.json")
	if(fexists(json_file))
		var/list/json = json_decode(file2text(json_file))
		return json
	else
		return list()

/proc/save_agevets_to_file()
	var/json_file = file("data/agevets.json")
	var/list/file_data = list()
	file_data = GLOB.agevetted_list
	fdel(json_file)
	WRITE_FILE(json_file,json_encode(file_data))

// for more convenient host oversight and perhaps an eventual database import. 
/proc/log_agevet_to_csv(target_ckey, admin_ckey = "SYSTEM")
	if(IsAdminAdvancedProcCall()) // sorry for using this twice
		return
	var/csv_file = file("data/agevets_log.csv")
	var/current_date = time2text(world.timeofday, "YYYY-MM-DD")
	if(!fexists(csv_file))
		var/csv_columns = "player_ckey,admin_ckey,datestamp,rogue_round_id"
		WRITE_FILE(csv_file,csv_columns)
	csv_file << "[target_ckey],[admin_ckey],[current_date],[GLOB.rogue_round_id]"
