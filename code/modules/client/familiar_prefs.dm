/datum/familiar_prefs
	/// Reference to our prefs
	var/datum/preferences/prefs
	var/familiar_name
	var/familiar_specie
	var/familiar_headshot_link
	var/familiar_flavortext
	var/familiar_flavortext_display
	var/familiar_ooc
	var/familiar_ooc_notes
	var/familiar_ooc_notes_display
	var/familiar_ooc_extra
	var/familiar_ooc_extra_link
	var/familiar_pronouns = THEY_THEM // Default pronouns

/datum/familiar_prefs/New(datum/preferences/passed_prefs)
	. = ..()
	prefs = passed_prefs

/datum/familiar_prefs/proc/fam_show_ui()
	var/client/client = prefs?.parent
	if (!client)
		return

	var/list/dat = list()
		// --- Familiar species display using mapping ---
	if (familiar_specie && GLOB.familiar_display_names[familiar_specie])
		var/specie_type = GLOB.familiar_display_names[familiar_specie] ? GLOB.familiar_display_names[familiar_specie] : "Unknown Species"
		dat += "<div align='center'><font size=4 color='#bbbbbb'>[specie_type]</font></div>"

	dat += "<br><b>Familiar Name:</b> <a href='?_src_=familiar_prefs;preference=familiar_name;task=input'>[familiar_name] (Set name)</a>"

	// --- Pronoun selection ---
	var/list/pronoun_display = list(
		HE_HIM = "he/him",
		SHE_HER = "she/her",
		THEY_THEM = "they/them",
		IT_ITS = "it/its"
	)
	var/selected_pronoun = pronoun_display[familiar_pronouns] ? pronoun_display[familiar_pronouns] : "they/them"
	dat += "<br><b>Pronouns:</b> <a href='?_src_=familiar_prefs;preference=familiar_pronouns;task=select'>[selected_pronoun]</a>"

	dat += "<br><b>Familiar Headshot:</b> <a href='?_src_=familiar_prefs;preference=familiar_headshot;task=input'>Change</a>"
	if (familiar_headshot_link)
		dat += "<br><img src='[familiar_headshot_link]' width='100px' height='100px'>"

	dat += "<br><b>Flavortext:</b> <a href='?_src_=familiar_prefs;preference=formathelp;task=input'>(?)</a> <a href='?_src_=familiar_prefs;preference=familiar_flavortext;task=input'>Change</a>"

	dat += "<br><b>OOC Notes:</b> <a href='?_src_=familiar_prefs;preference=formathelp;task=input'>(?)</a> <a href='?_src_=familiar_prefs;preference=familiar_ooc_notes;task=input'>Change</a>"

	dat += "<br><b>Familiar OOC Extra:</b> <a href='?_src_=familiar_prefs;preference=formathelp;task=input'>(?)</a> <a href='?_src_=familiar_prefs;preference=familiar_ooc_extra;task=input'>Change</a>"

	var/display_name = "None selected"
	var/list/all_types = GLOB.familiar_types
	for (var/name in all_types)
		if (all_types[name] == familiar_specie)
			display_name = name
			break
	dat += "<br><b>Selected Familiar Type:</b> <a href='?_src_=familiar_prefs;preference=familiar_specie;task=select'>[display_name]</a>"

	if (familiar_specie)
		var/lore_blurb = GLOB.familiar_lore_blurbs[familiar_specie]
		if (lore_blurb)
			dat += "<br><i><b>Lore inspiration:</b> [lore_blurb]</i>"

	if (client in GLOB.familiar_queue)
		dat += "<br><a href='?_src_=familiar_prefs;preference=familiar_queue;task=leave'>Leave Queue</a>"
	else
		dat += "<br><a href='?_src_=familiar_prefs;preference=familiar_queue;task=join'>Queue Up</a>"

	var/datum/browser/popup = new(client?.mob, "Be a Familiar", "<center>Be a Familiar</center>", 330, 410)
	popup.set_window_options("can_close=1")
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/familiar_prefs/proc/fam_process_link(mob/user, list/href_list)
	if(!user)
		return

	var/task = href_list["task"]

	switch(href_list["preference"])
		if("familiar_name")
			var/new_name = input(user, "Choose your Familiar character's name:", "Identity") as text|null
			if(new_name)
				new_name = reject_bad_name(new_name)
				if(new_name)
					familiar_name = new_name
					to_chat(user, "<span class='notice'>Familiar name set to [new_name].</span>")
				else
					to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ', . and ,.</font>")
				
		if ("familiar_pronouns")
			var/list/pronoun_options = list(
				"he/him" = HE_HIM,
				"she/her" = SHE_HER,
				"they/them" = THEY_THEM,
				"it/its" = IT_ITS
			)
			var/choice = input(user, "Select your familiar's pronouns:", "Pronouns") as null|anything in pronoun_options
			if(choice)
				familiar_pronouns = pronoun_options[choice]
				to_chat(user, "<span class='notice'>Familiar pronouns set to [choice].</span>")
				
		if("familiar_headshot")
			to_chat(user, "<span class='notice'>Please use a relatively SFW image of the head and shoulder area to maintain immersion level. <b>Do not use a real life photo or unserious images.</b></span>")
			to_chat(user, "<span class='notice'>Ensure it's a direct image link. The photo will be resized to 325x325 pixels.</span>")
			var/new_headshot_link = input(user, "Input the headshot link (https, hosts: gyazo, discord, lensdump, imgbox, catbox):", "Headshot", familiar_headshot_link) as text|null
			if(new_headshot_link == null)
				return
			if(new_headshot_link == "")
				familiar_headshot_link = null
				fam_show_ui()
				return
			if(!valid_headshot_link(user, new_headshot_link))
				familiar_headshot_link = null
				fam_show_ui()
				return
			familiar_headshot_link = new_headshot_link
			to_chat(user, "<span class='notice'>Successfully updated Familiar headshot picture</span>")
			log_game("[user] has set their Familiar Headshot image to '[familiar_headshot_link]'.")

		if("familiar_flavortext")
			to_chat(user, "<span class='notice'><b>Flavortext should not include nonphysical nonsensory attributes such as backstory or internal thoughts.</b></span>")
			var/new_flavortext = input(user, "Input your Familiar character description:", "Flavortext", familiar_flavortext) as message|null
			if(new_flavortext == null)
				return
			if(new_flavortext == "")
				familiar_flavortext = null
				familiar_flavortext_display = null
				fam_show_ui()
				return
			familiar_flavortext = new_flavortext
			var/ft = html_encode(parsemarkdown_basic(familiar_flavortext))
			ft = replacetext(ft, "\n", "<BR>")
			familiar_flavortext_display = ft
			to_chat(user, "<span class='notice'>Successfully updated familiar flavortext</span>")
			log_game("[user] has set their familiar flavortext.")

		if("familiar_ooc_notes")
			var/new_ooc_notes = input(user, "Input your OOC preferences:", "OOC notes", familiar_ooc_notes) as message|null
			if(new_ooc_notes == null)
				return
			if(new_ooc_notes == "")
				familiar_ooc_notes = null
				familiar_ooc_notes_display = null
				fam_show_ui()
				return
			familiar_ooc_notes = new_ooc_notes
			var/ooc = html_encode(parsemarkdown_basic(familiar_ooc_notes))
			ooc = replacetext(ooc, "\n", "<BR>")
			familiar_ooc_notes_display = ooc
			to_chat(user, "<span class='notice'>Successfully updated Familiar OOC notes.</span>")
			log_game("[user] has set their Familiar OOC notes.")

		if("familiar_ooc_extra")
			to_chat(user, "<span class='notice'>Add a link to an mp3, mp4, or jpg/png (catbox, discord, etc).</span>")
			to_chat(user, "<span class='notice'>Videos are resized to ~300x300. Abuse = ban.</span>")
			to_chat(user, "<font color='#d6d6d6'>Leave a single space to delete it.</font>")
			var/link = input(user, "Input the accessory link (https)", "Familiar OOC Extra", familiar_ooc_extra_link) as text|null
			if(link == null)
				return
			if(link == "")
				link = null
				fam_show_ui()
				return
			if(link == " ")
				familiar_ooc_extra = null
				familiar_ooc_extra_link = null
				to_chat(user, "<span class='notice'>Successfully deleted Familiar OOC Extra.</span>")
				fam_show_ui()
				return
			var/static/list/valid_ext = list("jpg", "jpeg", "png", "gif", "mp4", "mp3")
			if(!valid_headshot_link(user, link, FALSE, valid_ext))
				link = null
				fam_show_ui()
				return
			familiar_ooc_extra_link = link
			var/ext = lowertext(splittext(link, ".")[length(splittext(link, "."))])
			var/info
			switch(ext)
				if("jpg", "jpeg", "png", "gif")
					familiar_ooc_extra = "<div align='center'><br><img src='[link]'/></div>"
					info = "an embedded image."
				if("mp4")
					familiar_ooc_extra = "<div align='center'><br><video width='288' height='288' controls><source src='[link]' type='video/mp4'></video></div>"
					info = "a video."
				if("mp3")
					familiar_ooc_extra = "<div align='center'><br><audio controls><source src='[link]' type='audio/mp3'>Your browser does not support the audio element.</audio></div>"
					info = "embedded audio."
			to_chat(user, "<span class='notice'>Successfully updated Familiar OOC Extra with [info]</span>")
			log_game("[user] has set their Familiar OOC Extra to '[link]'.")

		if ("familiar_queue")
			if (task == "join")
				var/datum/preferences/prefs = user?.client?.prefs
				var/datum/familiar_prefs/fam_pref = prefs?.familiar_prefs
				
				if (!fam_pref)
					to_chat(user, "<span class='warning'>Familiar preferences are not initialized.</span>")
					return

				if (!fam_pref.familiar_name || !fam_pref.familiar_flavortext_display || !fam_pref.familiar_specie)
					to_chat(user, "<span class='warning'>You must set your Familiar's name, description, and type before joining the queue.</span>")
					return

				if (!(user.client in GLOB.familiar_queue))
					GLOB.familiar_queue += user.client
					to_chat(user, "<span class='notice'>You have been added to the Familiar queue.</span>")

					for(var/client/advertisee in (GLOB.clients - src))
						var/mob/living/char = get_mob_by_key(advertisee.ckey)
						if(!char || !istype(char))
							continue
						if(HAS_TRAIT(char, TRAIT_ARCYNE))
							to_chat(advertisee, span_info("A new familiar is available to summon."))

			else if (task == "leave")
				if (user.client in GLOB.familiar_queue)
					GLOB.familiar_queue -= user.client
					to_chat(user, "<span class='notice'>You have been removed from the Familiar queue.</span>")

		if ("familiar_specie")
			var/list/all_types = GLOB.familiar_types

			var/choice = input(user, "Select a Familiar type:", "Familiar Type") as null|anything in all_types
			if (choice)
				var/path = all_types[choice]
				if (path)
					familiar_specie = path
					to_chat(user, "<span class='notice'>Familiar type set to [choice]</span>")
					log_game("[user] has set familiar type to [choice]")
				else
					to_chat(user, span_warning("Something went wrong selecting that familiar type."))

	if(user.client)
		fam_show_ui()
