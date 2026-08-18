/*
 * Lesser quirks: small, character-flavor traits too small to be a virtue.
 * None of these should be particularly impactful; it's not hard to get a slot for one.
*/

/datum/quirk/amphibious
	name = "Amphibious"
	desc = "Through some quirk of my heritage, I can breathe in water just as readily as in air."
	allowed_species = list(/datum/species/anthromorph, /datum/species/anthromorphsmall, /datum/species/lizardfolk)
	restricted_virtues = list(/datum/virtue/combat/second_chance) // you're probably already unbreathing
	added_traits = list(TRAIT_WATERBREATHING) // notably NOT breathless

/datum/quirk/goodlover // no beautiful trait for you. if you want to triumph farm, you need to earn your erp instead of being ontologically beautiful. sorry!
	name = "Fabled Lover"
	desc = "It's a lucky thing to share my bed. One might even call it a true TRIUMPH."
	added_traits = list(TRAIT_GOODLOVER)

/datum/quirk/wyrdbeauty
	name = "Otherworldly"
	desc = "No-one can quite seem to decide whether I'm mesmerizing or horrifying."
	added_traits = list(TRAIT_BEAUTIFUL_UNCANNY)
	allowed_species = list(/datum/species/aasimar, /datum/species/dullahan)
	allowed_virtues = list(/datum/virtue/combat/second_chance) // hacky, but w/e

/datum/quirk/large // this is - literally just cucking yourself by making your sprite bigger, idt we need to curb this?
	name = "Large"
	desc = "I'm just bigger than most others, plain and simple. Alas, it hasn't affected my strength."
	restricted_virtues = list(/datum/virtue/size/giant) // ...except, if you stack it with the giant virtue and big guy, you literally take up two entire tiles. which is probably bad

/datum/quirk/large/apply_to_human(mob/living/carbon/human/recipient) // same as giant virtue - just without the mechanical effects
	. = ..()
	recipient.transform = recipient.transform.Scale(1.25, 1.25)
	recipient.transform = recipient.transform.Translate(0, (0.25 * 16))
	recipient.update_transform()

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

/datum/quirk/outdoorsman
	name = "Outdoorsy"
	desc = "I feel at home in the wyld. Sleeping in tree branches is almost as comfortable as a bed to me."
	added_traits = list(TRAIT_OUTDOORSMAN)
