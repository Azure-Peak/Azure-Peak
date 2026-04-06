/client
	var/preferred_ui_language = "en"

/client/verb/change_prefered_language()
	set name = "Change Preferred TGUI Language"
	set category = "OOC"
	set desc = "Change your preferred TGUI language for multilingual interfaces."

	var/list/language_choices = list(
		"English" = "en",
		"Russian" = "ru",
	)
	var/current_language = preferred_ui_language
	if(!(current_language in list("en", "ru")))
		current_language = "en"

	var/selection = input(src, "Choose your preferred UI language.", "Preferred Language", current_language == "ru" ? "Russian" : "English") as null|anything in language_choices
	if(!selection)
		return

	preferred_ui_language = language_choices[selection]
	to_chat(src, span_notice("Preferred UI language set to [selection]. Reopen interfaces to apply it."))