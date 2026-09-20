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
	ui_fa_icon = "lungs"

/datum/quirk/goodlover // no beautiful trait for you. if you want to triumph farm, you need to earn your erp instead of being ontologically beautiful. sorry!
	name = "Fabled Lover"
	desc = "It's a lucky thing to share my bed. One might even call it a true TRIUMPH."
	added_traits = list(TRAIT_GOODLOVER)
	ui_fa_icon = "bed"

/datum/quirk/wyrdbeauty
	name = "Otherworldly"
	desc = "No-one can quite seem to decide whether I'm mesmerizing or horrifying."
	added_traits = list(TRAIT_BEAUTIFUL_UNCANNY)
	allowed_species = list(/datum/species/aasimar, /datum/species/dullahan, /datum/species/construct/metal, /datum/species/ooze)
	allowed_virtues = list(/datum/virtue/combat/second_chance) // hacky, but w/e
	ui_fa_icon = "person-rays"

/datum/quirk/ugly
	name = "Disfigured"
	desc = "My face is distressing to look upon."
	mechdesc = "This will grant no mechanical stress."
	added_traits = list(TRAIT_DISFIGURED)
	ui_fa_icon = "eye-slash"

/datum/quirk/tainted
	name = "Tainted"
	desc = "My lux bears some manner of curse; it cannot be safely transplanted."
	mechdesc = "You will be unable to donate lux to revive others."
	added_traits = list(TRAIT_TAINTEDLUX)
	restricted_species = list(/datum/species/tieberian, /datum/species/construct/metal)
	ui_fa_icon = "circle-half-stroke"

/datum/quirk/outdoorsman
	name = "Outdoorsy"
	desc = "I feel at home in the wyld. Sleeping in tree branches is almost as comfortable as a bed to me."
	added_traits = list(TRAIT_OUTDOORSMAN)
	allowed_species = list(/datum/species/tabaxi, /datum/species/anthromorph, /datum/species/anthromorphsmall, /datum/species/dullahan, /datum/species/elf/wood)
	ui_fa_icon = "tree"

/datum/quirk/caustic
	name = "Prickly"
	desc = "Through quills, spines, or a caustic makeup, touching me isn't exactly pleasant."
	mechdesc = "Doesn't affect grabs."
	added_traits = list(TRAIT_CAUSTIC)
	allowed_species = list(/datum/species/ooze, /datum/species/anthromorph, /datum/species/anthromorphsmall, /datum/species/aasimar, /datum/species/dullahan)
	ui_fa_icon = "road-spikes"

/datum/quirk/nightowl
	name = "Night Owl"
	desc = "For one reason or another, I've a nocturnal sleep cycle."
	added_traits = list(TRAIT_NIGHT_OWL)
	ui_fa_icon = "moon"

/datum/quirk/nostink
	name = "Deadened Nose"
	desc = "Whether used to filth, or simply a quirk of biology, horrid smells don't bother me."
	added_traits = list(TRAIT_NOSTINK)
	ui_fa_icon = "cloud"

/datum/quirk/nistean
	name = "Nistean"
	desc = "For religious or digestive reasons, I've sworn off meat. Abyssor's gifts, however, are fair game."
	added_traits = list(TRAIT_NISTEAN)
	ui_fa_icon = "fish-fins"

/datum/quirk/nihilist
	name = "Nihilist"
	desc = "My past was not a gentle one—through service, desperation, or repeated exposure, I have become desensitized to death and dismemberment. The soul recoils in disgust as the body stands on business unmoved."
	added_traits = list(TRAIT_NIHILIST)
	ui_fa_icon = "skull"
