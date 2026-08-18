/*
 * Lesser quirks: small, character-flavor traits too small to be a virtue.
 * None of these should be particularly impactful; it's not hard to get a slot for one.
*/

/datum/quirk/amphibious
	name = "Amphibious"
	desc = "Through some quirk of my heritage, I can breathe in water just as readily as in air."
	allowed_species = list(/datum/species/anthromorph, /datum/species/lizardfolk)
	restricted_virtues = list(/datum/virtue/combat/second_chance) // you're probably already unbreathing
	added_traits = list(TRAIT_WATERBREATHING) // notably NOT breathless

/datum/quirk/beautiful
	name = "Beautiful"
	desc = "Whether blessed or simply exceptional, I'm considered attractive by most."
	restricted_species = list(/datum/species/dullahan) // revs can only get uncanny beauty, not the regular one
	added_traits = list(TRAIT_BEAUTIFUL) // notably not goodlover, as that's been atomized

/datum/quirk/goodlover // if you want to triumph farm, you need to earn your erp instead of being ontologically beautiful. sorry!
	name = "Fabled Lover"
	desc = "It's a lucky thing to share my bed. One might even call it a true TRIUMPH."
	added_traits = list(TRAIT_GOODLOVER)

/datum/quirk/wyrdbeauty
	name = "Otherworldly"
	desc = "No-one can quite seem to decide whether I'm mesmerizing or horrifying."
	added_traits = list(TRAIT_BEAUTIFUL_UNCANNY)
	allowed_species = list(/datum/species/aasimar, /datum/species/dullahan)
	allowed_virtues = list(/datum/virtue/combat/second_chance) // hacky, but w/e

/datum/quirk/ugly
	name = "Disfigured"
	desc = "My face is distressing to look upon."
	mechdesc = "This will grant no mechanical stress."
	added_traits = list(TRAIT_DISFIGURED)

/datum/quirk/tainted
	name = "Tainted"
	desc = "My lux bears some manner of curse; it cannot be safely transplanted."
	mechdesc = "You will be unable to donate lux to revive others."
	added_traits = list(TRAIT_TAINTEDLUX)
