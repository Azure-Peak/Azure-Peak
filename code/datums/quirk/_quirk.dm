GLOBAL_LIST_EMPTY(quirks)

/datum/quirk
	///name of the quirk
	var/name
	///ic description; shows on hover in the selection menu, and printed to chat when it's picked
	var/desc
	///mechanical description; if present, printed after the IC desc in chat
	var/mechdesc
	///if present, these species will not be able to pick the quirk
	var/list/restricted_species
	///if present, ONLY these species will be able to pick the quirk
	var/list/allowed_species
	///if present, and the character has this virtue selected, they can roll the quirk even if they aren't in allowed_species. this is entirely to let second chancers take uncanny beauty
	var/list/allowed_virtues
	///if present, and the character has this quirk selected, they can roll the quirk even if they aren't in allowed_species. this is entirely to let feytouched take uncanny beauty
	var/list/allowed_quirks
	///if present, these virtues will block the quirk from being picked/applied - useful when they overlap
	var/list/restricted_virtues
	///if this is a 'greater' quirk only accessible if you take virtuous/fated AND two vices
	var/greater	= FALSE
	///traits always applied by the quirk
	var/list/added_traits
	///FontAwesome icon name to display in the PreferencesMenu UI
	var/ui_fa_icon = null

/datum/quirk/proc/apply_to_human(mob/living/carbon/human/recipient)
	return

/datum/quirk/proc/handle_traits(mob/living/carbon/human/recipient)
	if (!LAZYLEN(added_traits))
		return
	for(var/trait in added_traits)
		ADD_TRAIT(recipient, trait, TRAIT_QUIRK)

/proc/apply_quirk(mob/living/carbon/human/recipient, datum/quirk/quirk_type)
	quirk_type.apply_to_human(recipient)
	quirk_type.handle_traits(recipient)
	record_featured_object_stat(FEATURED_STATS_QUIRKS, quirk_type.name, 1)

/datum/quirk/none
	name = "None"
	desc = "Without quirk."
	ui_fa_icon = "ban"

/// Dynamic UI data for TGUI to display these in the prefs menu
/datum/quirk/ui_data(mob/user)
	var/list/data = ..()

	data["name"] = name

	return data // IS THIS EVEN NEEDED???

/// Constant UI data for TGUI to display these in the prefs menu
/datum/quirk/proc/constant_ui_data()
	var/list/data = list(
		"name" = name,
		"desc" = desc,
		"mechdesc" = mechdesc,
		"icon" = ui_fa_icon,
		"added_traits" = null,
	)

	var/list/added_traits_data = list()
	for(var/TR in added_traits)
		UNTYPED_LIST_ADD(added_traits_data, list(
			"name" = TR,
			"desc" = GLOB.roguetraits[TR],
		))
	data["added_traits"] = added_traits_data

	return data
