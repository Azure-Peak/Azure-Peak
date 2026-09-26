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
	allowed_virtues = list(/datum/virtue/combat/second_chance, /datum/virtue/utility/feytouched) // hacky, but w/e
	allowed_quirks = list(/datum/quirk/feytouched)
	ui_fa_icon = "person-rays"

/datum/quirk/ugly
	name = "Disfigured"
	desc = "My face is distressing to look upon."
	mechdesc = "This will grant no mechanical stress."
	added_traits = list(TRAIT_UNSEEMLY)
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
	added_traits = list(TRAIT_NIGHT_OWL_LESSER)
	ui_fa_icon = "moon"

/datum/quirk/nistean
	name = "Nistean"
	desc = "For religious or digestive reasons, I've sworn off meat. Abyssor's gifts, however, are fair game."
	added_traits = list(TRAIT_NISTEAN)
	ui_fa_icon = "fish-fins"

/datum/quirk/vegan
	name = "Végétal" // it's otavan. why? was a suggestion, and it fits best with genesism as a religious thing (loving all creation or w/e as opposed to "dendor wants us to eat each other")
	desc = "For religious or digestive reasons, I've sworn off meat, dairy, and everything else that comes from animals."
	added_traits = list(TRAIT_VEGAN) // this is really, _really_ restrictive - it's genuinely kind of impressive to stick to this?
	ui_fa_icon = "seedling"

/datum/quirk/nihilist
	name = "Nihilist"
	desc = "My past was not a gentle one—through service, desperation, or repeated exposure, I have become desensitized to death and dismemberment. The soul recoils in disgust as the body stands on business unmoved."
	added_traits = list(TRAIT_NIHILIST)
	ui_fa_icon = "skull"

/datum/quirk/feytouched
	name = "Feytouched"
	desc = "While I may not be as changed as some, I'm bound by pact or nature to the hag's cause."
	mechdesc = "You and the hag will know each other automatically and can communicate; however, you don't get the mechanical effects of the feybound virtue. You can reach out to the hag by interacting with a heartroot tree and whispering to the roots. You're expected to cooperate with them."
	ui_fa_icon = "ghost"
	added_traits = list(TRAIT_FEYTOUCHED)
	restricted_virtues = list(/datum/virtue/utility/feytouched)

/datum/quirk/feytouched/apply_to_human(mob/living/carbon/human/recipient)
	if(!recipient.mind)
		return
	for(var/mob/living/hag_mob in GLOB.active_hags)
		var/datum/mind/hag_mind = hag_mob.mind
		if(!hag_mind)
			continue
		hag_mind.i_know_person(recipient)
		recipient.mind.i_know_person(hag_mind)
		if(hag_mind.current)
			to_chat(hag_mind.current, span_boldnotice("A familiar rhythm pulses in the roots... [recipient.real_name], a feytouched, is walking the lands this week."))
	to_chat(recipient, span_boldnotice("The Mossmother's gaze lingers upon you. You are recognized by her daughters."))

/datum/quirk/wellknown
	name = "Well-known"
	desc = "I may not be a resident of Azure Peak myself, but I spend enough time in and around the city that my face and name are known."
	mechdesc = "You will be treated as a resident for purposes of knowing, and being known by, those in town. Be warned: this will allow others to message, scry, and otherwise know about you from afar."
	ui_fa_icon = "user-group"
	restricted_virtues = list(/datum/virtue/utility/notable) // can't already be a resident
	var/static/list/blacklisted_antag_datums = list( // should be self-explanatory. no town-known gnolls, lich skeletons, etc
		/datum/antagonist/assassin,
		/datum/antagonist/bandit,
		/datum/antagonist/gnoll,
		/datum/antagonist/goblin,
		/datum/antagonist/hag,
		/datum/antagonist/lich,
		/datum/antagonist/skeleton,
		/datum/antagonist/unbound_death_knight,
		/datum/antagonist/unbound_spellblade,
	)

/datum/quirk/wellknown/apply_to_human(mob/living/carbon/human/recipient)
	. = ..()
	var/static/list/all_resident_positions = (GLOB.peasant_positions + GLOB.burgher_positions + GLOB.retinue_positions + GLOB.garrison_positions + GLOB.noble_positions + GLOB.inquisition_positions)
	if((recipient.job in all_resident_positions) || HAS_TRAIT(recipient, TRAIT_RESIDENT)) // congrats, you wasted your quirk
		to_chat(recipient, span_warning("I am already a resident of Azure Peak. I cannot become more well-known.")) // let them know to pick a different quirk lol
		return
	if(recipient.mind)
		for(var/antag in blacklisted_antag_datums)
			if(recipient.mind.has_antag_datum(antag, TRUE))
				to_chat(recipient, span_warning("My nature is not conducive to being welcomed in town. I am not well-known amongst them.")) // tell them why it's not applied
				return
		for(var/X in all_resident_positions)
			for(var/datum/mind/MF in get_minds(X))
				recipient.mind.person_knows_me(MF)
				recipient.mind.i_know_person(MF)
			for(var/mob/living/carbon/human/H in GLOB.player_list)
				if(HAS_TRAIT(H, TRAIT_RESIDENT)) // we have to do this to handle resident virtue; quirks are applied after virtues, so this works fine
					recipient.mind.person_knows_me(H)
					recipient.mind.i_know_person(H)
