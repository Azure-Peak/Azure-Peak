GLOBAL_LIST_EMPTY(faithlist)

GLOBAL_LIST_EMPTY(preference_faiths)

/datum/faith
	/// Name of the faith
	var/name
	/// Description of the faith
	var/desc = "A faith that believes in the power of reporting this issue on GitHub - You shouldn't be seeing this, someone forgot to set the description for this faith."
	/// People most likely to practice this faith
	var/worshippers = "Coderbus"
	/// Our "primary" patron god
	var/datum/patron/godhead = /datum/patron
	/// Whether or not this faith can be accessed in preferences
	var/preference_accessible = TRUE

/datum/faith/proc/constant_ui_data()
	return list(
		"name" = name,
		"desc" = desc,
		"worshippers" = worshippers,
		"godhead" = godhead,
	)
