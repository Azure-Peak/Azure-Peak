GLOBAL_LIST_EMPTY(quirks)
GLOBAL_LIST_EMPTY(quirks_lesser)
GLOBAL_LIST_EMPTY(quirks_greater)

/datum/quirk
	var/name					// name of the quirk
	var/desc					// ic description; shows on hover in the selection menu, and printed to chat when it's picked
	var/mechdesc				// mechanical description; if present, printed after the IC desc in chat
	var/list/restricted_species	// if present, these species will not be able to pick the quirk
	var/list/allowed_species	// if present, ONLY these species will be able to pick the quirk
	var/list/allowed_virtues	// if present, and the character has this virtue selected, they can roll the quirk even if they aren't in allowed_species. this is entirely to let second chancers take uncanny beauty
	var/list/restricted_virtues	// if present, these virtues will block the quirk from being picked/applied - useful when they overlap
	var/list/restricted_traits	// if present, these traits will block the quirk from being applied. prefer other options, as this won't prevent it being picked in character creation!
	var/greater	= FALSE			// if this is a 'greater' quirk only accessible if you take virtuous/fated AND two vices
	var/list/added_traits		// traits always applied by the quirk

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

/datum/quirk/none
	name = "None"
	desc = "Without quirk."
