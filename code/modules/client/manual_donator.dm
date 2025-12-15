// Copypasta of bordercontrol system

GLOBAL_LIST_EMPTY(donatorCkeys)
GLOBAL_VAR_INIT(donatorCkeysSaveFile, new /savefile("data/donators.db"))
GLOBAL_VAR_INIT(donatorLoaded, 0)

/proc/is_donator(key)
	key = ckey(key)

	if(!GLOB.donatorLoaded)
		load_donators()
	if(LAZYISIN(GLOB.donatorCkeys, key))
		return TRUE
	else
		return FALSE

/proc/donator_addkey(key)
	var/keyAsCkey = ckey(key)
	if(!GLOB.donatorLoaded)
		load_donators()
	
	if(!keyAsCkey)
		return FALSE
	else
		if(LAZYISIN(GLOB.donatorCkeys, keyAsCkey))
			return FALSE
		else
			LAZYINITLIST(GLOB.donatorCkeys)
			ADD_SORTED(GLOB.donatorCkeys, keyAsCkey, /proc/cmp_text_asc)
			save_donators()
			return TRUE

/proc/donator_removekey(key)
	key = ckey(key)

	if(!LAZYISIN(GLOB.donatorCkeys, key))
		return TRUE
	else if(GLOB.donatorCkeys)
		LAZYREMOVE(GLOB.donatorCkeys, key)
		save_donators()
		return TRUE

/proc/load_donators()
	LAZYCLEARLIST(GLOB.donatorCkeys)

	LAZYINITLIST(GLOB.donatorCkeys)

	if(!GLOB.donatorCkeysSaveFile)
		return FALSE

	GLOB.donatorCkeysSaveFile["donatorCkeys"] >> GLOB.donatorCkeys

	GLOB.donatorLoaded = TRUE

/proc/save_donators()
	if(!GLOB.donatorCkeys)
		return FALSE
	if(!GLOB.donatorCkeysSaveFile)
		return FALSE

	GLOB.donatorCkeysSaveFile["donatorCkeys"] << GLOB.donatorCkeys

// Procs goes here
/datum/admins/proc/admin_add_donator_verb()
	set name = "BC - Add Donator Ckey"
	set category = "-Server-"

	var/key = input("CKey to Add", "Add Donator CKey") as null|text

	if(key)
		var/confirm = alert("Add [key] to the donator list? (They need to reconnect to update status)", , "Yes", "No")
		if(confirm == "Yes")
			message_admins("[key_name(usr)] added [key] to the donator list.")
			log_admin("[key_name(usr)] added [key] to the donator list.")
			donator_addkey(key)
			if(CONFIG_GET(string/chat_announce_donator))
				send2chat(new /datum/tgs_message_content("[key_name(usr)] added [key] to the donator list."), CONFIG_GET(string/chat_announce_donator))

/datum/admins/proc/admin_remove_donator_verb()
	set name = "BC - Remove Donator Ckey"
	set category = "-Server-"

	var/key = input("CKey to Remove", "Remove Donator CKey") as null|anything in GLOB.donatorCkeys

	if(key)
		var/confirm = alert("Remove [key] from the donator list?", , "Yes", "No")
		if(confirm == "Yes")
			message_admins("[key_name(usr)] removed [key] from the donator list.")
			log_admin("[key_name(usr)] removed [key] from the donator list.")
			donator_removekey(key)
			if(CONFIG_GET(string/chat_announce_donator))
				send2chat(new /datum/tgs_message_content("[key_name(usr)] removed [key] from the donator list."), CONFIG_GET(string/chat_announce_donator))
