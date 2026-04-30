/datum/familiar_prefs
	/// Reference to our prefs
	var/datum/preferences/prefs
	var/alist/familiar_names
	var/alist/familiar_species
	var/alist/familiar_flavortexts
	var/alist/familiar_pronouns
	var/list/familiar_flavortext
	var/list/familiar_flavortext_display
	var/list/familiar_headshot_link
	var/list/familiar_ooc_notes
	var/list/familiar_ooc_notes_display
	var/list/familiar_ooc_extra
	var/list/familiar_ooc_extra_link

/datum/familiar_prefs/New(datum/preferences/passed_prefs)
	. = ..()
	prefs = passed_prefs
	familiar_names = alist()
	familiar_species = alist(
		"fae" = /mob/living/simple_animal/pet/familiar/fae,
		"infernal" = /mob/living/simple_animal/pet/familiar/infernal,
		"elemental" = /mob/living/simple_animal/pet/familiar/elemental,
		"void" = /mob/living/simple_animal/pet/familiar/void
	)
	familiar_flavortexts = alist()
	familiar_pronouns = alist(
		"fae" = THEY_THEM,
		"infernal" = THEY_THEM,
		"elemental" = THEY_THEM,
		"void" = THEY_THEM
	)
	familiar_flavortext = list()
	familiar_flavortext_display = list()
	familiar_headshot_link = list()
	familiar_ooc_notes = list()
	familiar_ooc_notes_display = list()
	familiar_ooc_extra = list()
	familiar_ooc_extra_link = list()

/datum/familiar_prefs/proc/fam_show_ui()
	var/client/client = prefs?.parent
	if (!client)
		return
	if(!familiar_names) // this is an old prefs object; re-instantiate it so the new fields aren't null
		src.New(prefs)
	var/list/dat = list()
	var/list/pronoun_display = list(
		HE_HIM = "he/him",
		SHE_HER = "she/her",
		THEY_THEM = "they/them",
		IT_ITS = "it/its"
	)

	dat += "<i>You can set preferences for all four familar types here: which set is used depends on which type of summons you respond to. Setting prefs for some types and not others will prevent you from being summoned as the types you did not set prefs for.<br>Subtypes of each of the four familiar categories are aesthetic only; there is no functional difference.</i>"
	var/list/pretty_plane_names = list(
		"fae" = "Fae",
		"infernal" = "Infernal",
		"elemental" = "Elemental",
		"void" = "Void"
	)
	for(var/planar_origin in list("fae","infernal","elemental","void"))
		var/list/planar_list = GLOB.planar_lists[planar_origin]
		dat += "<br><div align='center'><font size=4 color='#bbbbbb'>[pretty_plane_names[planar_origin]] Preferences</font></div>"
		dat += "<br><b>Familiar Name:</b> <a href='?_src_=familiar_prefs;preference=familiar_names;task=input;planar_origin=[planar_origin]'>[(src.familiar_names[planar_origin] ? src.familiar_names[planar_origin] : "")] (Set name)</a>"
		var/selected_pronoun = (src.familiar_pronouns[planar_origin] ? (pronoun_display[src.familiar_pronouns[planar_origin]] ? pronoun_display[src.familiar_pronouns[planar_origin]] : "they/them") : "they/them")
		dat += "<br><b>Pronouns:</b> <a href='?_src_=familiar_prefs;preference=familiar_pronouns;task=select;planar_origin=[planar_origin]'>[selected_pronoun]</a>"

		var/display_name = "None selected"
		// void drakelings only have one type, so displaying this selection would be moot
		if(planar_list && planar_list.len > 1)
			for (var/name in planar_list)
				if (planar_list[name] == familiar_species[planar_origin])
					display_name = name
					break
			dat += "<br><b>Selected Familiar Type:</b> <a href='?_src_=familiar_prefs;preference=familiar_species;task=select;planar_origin=[planar_origin]'>[display_name]</a>"

		// however, we *do* want to display their lore blurb
		if (familiar_species[planar_origin])
			var/lore_blurb = GLOB.familiar_lore_blurbs[familiar_species[planar_origin]]
			if (lore_blurb)
				dat += "<br><i><b>Lore inspiration:</b> [lore_blurb]</i>"
		dat += "<br><b>Examine settings:</b> <a href='?_src_=familiar_prefs;preference=familiar_examine;task=select;planar_origin=[planar_origin]'>Open</a>"

	var/datum/browser/popup = new(client?.mob, "Familiar Preferences", "<center>Familiar Preferences</center>", 900, 900)
	popup.set_window_options("can_close=1")
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/familiar_prefs/proc/fam_process_link(mob/user, list/href_list)
	if(!user)
		return

	// var/task = href_list["task"]
	var/planar_origin = href_list["planar_origin"]

	switch(href_list["preference"])
		if("familiar_names")
			var/new_name = input(user, "Choose your Familiar character's name:", "Identity") as text|null
			if(new_name)
				new_name = reject_bad_name(new_name)
				if(new_name)
					familiar_names[planar_origin] = new_name
					to_chat(user, "<span class='notice'>Familiar name set to [new_name].</span>")
				else
					to_chat(user, "<font color='red'>Invalid name. Your name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ', . and ,.</font>")
			else
				familiar_names[planar_origin] = null
				to_chat(user, "<span class='notice'>Familiar name reset.</span>")
		if ("familiar_pronouns")
			var/list/pronoun_options = list(
				"he/him" = HE_HIM,
				"she/her" = SHE_HER,
				"they/them" = THEY_THEM,
				"it/its" = IT_ITS
			)
			var/choice = input(user, "Select your familiar's pronouns:", "Pronouns") as null|anything in pronoun_options
			if(choice)
				familiar_pronouns[planar_origin] = pronoun_options[choice]
				to_chat(user, "<span class='notice'>Familiar pronouns set to [choice].</span>")

		if ("familiar_species")
			var/list/all_types = GLOB.planar_lists[planar_origin]

			var/choice = input(user, "Select a Familiar type:", "Familiar Type") as null|anything in all_types
			if (choice)
				var/path = all_types[choice]
				if (path)
					familiar_species[planar_origin] = path
					to_chat(user, "<span class='notice'>Familiar type set to [choice]</span>")
					log_game("[user] has set familiar type to [choice]")
				else
					to_chat(user, span_warning("Something went wrong selecting that familiar type."))

		if("familiar_examine")
			setup_examine_window(user,planar_origin)
			return
		
		if("familiar_headshot")
			to_chat(user, "<span class='notice'>Please use a relatively SFW image of the head and shoulder area to maintain immersion level. <b>Do not use a real life photo or unserious images.</b></span>")
			to_chat(user, "<span class='notice'>Ensure it's a direct image link. The photo will be resized to 325x325 pixels.</span>")
			var/new_headshot_link = input(user, "Input the headshot link (https, hosts: gyazo, discord, lensdump, imgbox, catbox):", "Headshot", familiar_headshot_link[planar_origin]) as text|null
			if(new_headshot_link == null)
				return
			if(new_headshot_link == "")
				familiar_headshot_link[planar_origin] = null
				setup_examine_window(user,planar_origin)
				return
			if(!valid_headshot_link(user, new_headshot_link))
				familiar_headshot_link[planar_origin] = null
				setup_examine_window(user,planar_origin)
				return
			familiar_headshot_link[planar_origin] = new_headshot_link
			to_chat(user, "<span class='notice'>Successfully updated Familiar headshot picture</span>")
			log_game("[user] has set their Familiar Headshot image to '[familiar_headshot_link[planar_origin]]'.")
			setup_examine_window(user,planar_origin)
			return

		if("familiar_flavortext")
			to_chat(user, "<span class='notice'><b>Flavortext should not include nonphysical nonsensory attributes such as backstory or internal thoughts.</b></span>")
			var/new_flavortext = input(user, "Input your Familiar character description:", "Flavortext", familiar_flavortext[planar_origin]) as message|null
			if(new_flavortext == null)
				return
			if(new_flavortext == "")
				to_chat(user, "<span class='notice'>Successfully reset familiar flavortext</span>")
				familiar_flavortext[planar_origin] = null
				familiar_flavortext_display[planar_origin] = null
				setup_examine_window(user,planar_origin)
				return
			familiar_flavortext[planar_origin] = new_flavortext
			var/ft = html_encode(parsemarkdown_basic(familiar_flavortext[planar_origin]))
			ft = replacetext(ft, "\n", "<BR>")
			familiar_flavortext_display[planar_origin] = ft
			to_chat(user, "<span class='notice'>Successfully updated familiar flavortext</span>")
			log_game("[user] has set their familiar flavortext.")
			setup_examine_window(user, planar_origin)
			return

		if("familiar_ooc_notes")
			var/new_ooc_notes = input(user, "Input your OOC preferences:", "OOC notes", familiar_ooc_notes[planar_origin]) as message|null
			if(new_ooc_notes == null)
				return
			if(new_ooc_notes == "")
				familiar_ooc_notes[planar_origin] = null
				familiar_ooc_notes_display[planar_origin] = null
				setup_examine_window(user,planar_origin)
				return
			familiar_ooc_notes[planar_origin] = new_ooc_notes
			var/ooc = html_encode(parsemarkdown_basic(familiar_ooc_notes[planar_origin]))
			ooc = replacetext(ooc, "\n", "<BR>")
			familiar_ooc_notes_display[planar_origin] = ooc
			to_chat(user, "<span class='notice'>Successfully updated Familiar OOC notes.</span>")
			log_game("[user] has set their Familiar OOC notes.")
			setup_examine_window(user,planar_origin)
			return

		if("familiar_ooc_extra")
			to_chat(user, "<span class='notice'>Add a link to an mp3, mp4, or jpg/png (catbox, discord, etc).</span>")
			to_chat(user, "<span class='notice'>Videos are resized to ~300x300. Abuse = ban.</span>")
			to_chat(user, "<font color='#d6d6d6'>Leave a single space to delete it.</font>")
			var/link = input(user, "Input the accessory link (https)", "Familiar OOC Extra", familiar_ooc_extra_link[planar_origin]) as text|null
			if(link == null)
				return
			if(link == "")
				link = null
				setup_examine_window(user,planar_origin)
				return
			if(link == " ")
				familiar_ooc_extra[planar_origin] = null
				familiar_ooc_extra_link[planar_origin] = null
				to_chat(user, "<span class='notice'>Successfully deleted Familiar OOC Extra.</span>")
				setup_examine_window(user,planar_origin)
				return
			var/static/list/valid_ext = list("jpg", "jpeg", "png", "gif", "mp4", "mp3")
			if(!valid_headshot_link(user, link, FALSE, valid_ext))
				link = null
				setup_examine_window(user,planar_origin)
				return
			familiar_ooc_extra_link[planar_origin] = link
			var/ext = lowertext(splittext(link, ".")[length(splittext(link, "."))])
			var/info
			switch(ext)
				if("jpg", "jpeg", "png", "gif")
					familiar_ooc_extra[planar_origin] = "<div align='center'><br><img src='[link]'/></div>"
					info = "an embedded image."
				if("mp4")
					familiar_ooc_extra[planar_origin] = "<div align='center'><br><video width='288' height='288' controls><source src='[link]' type='video/mp4'></video></div>"
					info = "a video."
				if("mp3")
					familiar_ooc_extra[planar_origin] = "<div align='center'><br><audio controls><source src='[link]' type='audio/mp3'>Your browser does not support the audio element.</audio></div>"
					info = "embedded audio."
			to_chat(user, "<span class='notice'>Successfully updated Familiar OOC Extra with [info]</span>")
			log_game("[user] has set their Familiar OOC Extra to '[link]'.")
			setup_examine_window(user,planar_origin)
			return

	if(user.client)
		fam_show_ui()

// used for updating old objects without wiping the rest of the prefs
/datum/familiar_prefs/proc/instantiate_examine_prefs()
	familiar_flavortext = list()
	familiar_flavortext_display = list()
	familiar_headshot_link = list()
	familiar_ooc_notes = list()
	familiar_ooc_notes_display = list()
	familiar_ooc_extra = list()
	familiar_ooc_extra_link = list()

/datum/familiar_prefs/proc/setup_examine_window(mob/user, planar_origin)
	var/list/pretty_plane_names = list(
		"fae" = "Fae",
		"infernal" = "Infernal",
		"elemental" = "Elemental",
		"void" = "Void"
	)
	var/client/client = prefs?.parent
	if (!client)
		return
	if(!src.familiar_flavortext || !istype(src.familiar_flavortext)) // this is a prefs object from before the examine update; re-instantiate it
		src.instantiate_examine_prefs()
	var/list/dat = list()
	dat += "<br><b>Familiar Headshot:</b> <a href='?_src_=familiar_prefs;preference=familiar_headshot;task=input;planar_origin=[planar_origin]'>Change</a>"
	if (familiar_headshot_link[planar_origin])
		dat += "<br><img src='[familiar_headshot_link[planar_origin]]' width='100px' height='100px'>"
	dat += "<br><b>Flavortext:</b> <a href='?_src_=familiar_prefs;preference=formathelp;task=input'>(?)</a> <a href='?_src_=familiar_prefs;preference=familiar_flavortext;task=input;planar_origin=[planar_origin]'>Change</a>"
	dat += "<br><b>OOC Notes:</b> <a href='?_src_=familiar_prefs;preference=formathelp;task=input'>(?)</a> <a href='?_src_=familiar_prefs;preference=familiar_ooc_notes;task=input;planar_origin=[planar_origin]'>Change</a>"
	dat += "<br><b>Familiar OOC Extra:</b> <a href='?_src_=familiar_prefs;preference=formathelp;task=input'>(?)</a> <a href='?_src_=familiar_prefs;preference=familiar_ooc_extra;task=input;planar_origin=[planar_origin]'>Change</a>"
	var/datum/browser/popup = new(user, "Examine Preferences", "<center>[pretty_plane_names[planar_origin]] Examine Preferences</center>", 400, 500)
	popup.set_window_options("can_close=1")
	popup.set_content(dat.Join())
	popup.open(FALSE)
