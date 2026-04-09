/datum/familiar_prefs
	/// Reference to our prefs
	var/datum/preferences/prefs
	var/alist/familiar_names
	var/alist/familiar_species
	var/alist/familiar_flavortexts
	var/alist/familiar_pronouns

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
	for(var/plane in GLOB.planar_lists)
		var/list/planar_list = GLOB.planar_lists[plane]
		dat += "<br><div align='center'><font size=4 color='#bbbbbb'>[pretty_plane_names[plane]] Preferences</font></div>"
		dat += "<br><b>Familiar Name:</b> <a href='?_src_=familiar_prefs;preference=familiar_names;task=input;plane=[plane]'>[(src.familiar_names[plane] ? src.familiar_names[plane] : "")] (Set name)</a>"
		var/selected_pronoun = (src.familiar_pronouns[plane] ? (pronoun_display[src.familiar_pronouns[plane]] ? pronoun_display[src.familiar_pronouns[plane]] : "they/them") : "they/them")
		dat += "<br><b>Pronouns:</b> <a href='?_src_=familiar_prefs;preference=familiar_pronouns;task=select;plane=[plane]'>[selected_pronoun]</a>"

		var/display_name = "None selected"
		// void drakelings only have one type, so displaying this selection would be moot
		if(planar_list && planar_list.len > 1)
			for (var/name in planar_list)
				if (planar_list[name] == familiar_species[plane])
					display_name = name
					break
			dat += "<br><b>Selected Familiar Type:</b> <a href='?_src_=familiar_prefs;preference=familiar_species;task=select;plane=[plane]'>[display_name]</a>"

		// however, we *do* want to display their lore blurb
		if (familiar_species[plane])
			var/lore_blurb = GLOB.familiar_lore_blurbs[familiar_species[plane]]
			if (lore_blurb)
				dat += "<br><i><b>Lore inspiration:</b> [lore_blurb]</i>"

	var/datum/browser/popup = new(client?.mob, "Familiar Preferences", "<center>Familiar Preferences</center>", 900, 900)
	popup.set_window_options("can_close=1")
	popup.set_content(dat.Join())
	popup.open(FALSE)

/datum/familiar_prefs/proc/fam_process_link(mob/user, list/href_list)
	if(!user)
		return

	// var/task = href_list["task"]
	var/plane = href_list["plane"]

	switch(href_list["preference"])
		if("familiar_names")
			var/new_name = input(user, "Choose your Familiar character's name:", "Identity") as text|null
			if(new_name)
				new_name = reject_bad_name(new_name)
				if(new_name)
					familiar_names[plane] = new_name
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
				familiar_pronouns[plane] = pronoun_options[choice]
				to_chat(user, "<span class='notice'>Familiar pronouns set to [choice].</span>")

		if ("familiar_species")
			var/list/all_types = GLOB.planar_lists[plane]

			var/choice = input(user, "Select a Familiar type:", "Familiar Type") as null|anything in all_types
			if (choice)
				var/path = all_types[choice]
				if (path)
					familiar_species[plane] = path
					to_chat(user, "<span class='notice'>Familiar type set to [choice]</span>")
					log_game("[user] has set familiar type to [choice]")
				else
					to_chat(user, span_warning("Something went wrong selecting that familiar type."))

	if(user.client)
		fam_show_ui()
