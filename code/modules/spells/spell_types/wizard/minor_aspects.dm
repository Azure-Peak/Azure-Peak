/datum/magic_aspect/artifice
	name = "Artifice"
	latin_name = "Minor Aspectus Artificii"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_METAL
	binding_chants = list(
		"Grant me the craftsman's eye.",
		"Artificium, mihi adesse!",
	)
	unbinding_chants = list(
		"I set down the craftsman's tools.",
		"Artificium, me relinquere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/arcyne_forge,
		/datum/action/cooldown/spell/mending,
	)

/datum/magic_aspect/exowardry
	name = "Exowardry"
	latin_name = "Minor Aspectus Exotutelae"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_ARCANE
	binding_chants = list(
		"Let me raise walls against my foes.",
		"Exotutela, mihi adesse!",
	)
	unbinding_chants = list(
		"I lower the walls I have raised.",
		"Exotutela, me relinquere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/forcewall,
	)


/datum/magic_aspect/displacement
	name = "Displacement"
	latin_name = "Minor Aspectus Translationis"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_DISPLACEMENT
	binding_chants = list(
		"Let me step between the spaces between the realms.",
		"Translatio, mihi adesse!",
	)
	unbinding_chants = list(
		"I close the paths I have opened. I walk the realms no longer.",
		"Translatio, me relinquere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/phase,
	)

/datum/magic_aspect/autowardry
	name = "Autowardry"
	latin_name = "Minor Aspectus Autotutelae"
	desc = "Augment your existing arcyne ward with additional properties. The warding spell is replaced and an improved version takes its place while the aspect is active."
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_METAL
	binding_chants = list(
		"Let me clad myself in an armor of arcyne.",
		"Autotutela, mihi adesse!",
	)
	unbinding_chants = list(
		"I bare myself and shed the arcyne mantle.",
		"Autotutela, me relinquere!",
	)
	choice_spells = list(
		/datum/action/cooldown/spell/conjure_arcyne_ward/dragonhide,
		/datum/action/cooldown/spell/conjure_arcyne_ward/crystalhide,
	)

/datum/magic_aspect/lesser_augmentation
	name = "Lesser Augmentation"
	latin_name = "Minor Aspectus Augmenti"
	desc = "Scholars debate whether Augmentation is a first, second, or even third-order school. Its adherents consider themselves third-order - \
	with the honor of imitating the divine by augmenting the boundless potential of the humen form. Its spells are focused on enhancing the body, \
	never the mind directly - for the mind is the true province of the divine, and one cannot use magycks to enhance one's own ability to wield magycks so bluntly. \
	Woe betides those who face a warrior sharpened by the arcyne."
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_BUFF
	binding_chants = list(
		"Let me access the potent within.",
		"Augmentum, mihi adesse!",
	)
	unbinding_chants = list(
		"I calm the potent within.",
		"Augmentum, me relinquere!",
	)
	pointbuy_budget = 6
	pointbuy_spells = list(
		/datum/action/cooldown/spell/darkvision,
		/datum/action/cooldown/spell/augment_buff/blood_rush,
		/datum/action/cooldown/spell/augment_buff/guidance,
		/datum/action/cooldown/spell/featherfall,
		/datum/action/cooldown/spell/augment_buff/enlarge,
		/datum/action/cooldown/spell/leap,
		/datum/action/cooldown/spell/nondetection,
		/datum/action/cooldown/spell/augment_buff/surge,
		/datum/action/cooldown/spell/augment_buff/precognition,
		/datum/action/cooldown/spell/augment_buff/grasp,
		// 1-cost utility filler
		/datum/action/cooldown/spell/light,
		/datum/action/cooldown/spell/mending,
		/datum/action/cooldown/spell/create_campfire,
	)

/datum/magic_aspect/illusion
	name = "Illusion"
	latin_name = "Minor Aspectus Illusio"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_ILLUSION
	binding_chants = list(
		"Let me weave what is not there.",
		"Illusio, mihi adesse!",
	)
	unbinding_chants = list(
		"I unravel the veil I have spun.",
		"Illusio, me relinquere!",
	)
	fixed_spells = list(
		/obj/effect/proc_holder/spell/invoked/invisibility,
	)

/datum/magic_aspect/hearthcraft
	name = "Hearthcraft"
	latin_name = "Minor Aspectus Domus"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_HEARTH
	binding_chants = list(
		"Let me tend the hearth and home.",
		"Domus, mihi adesse!",
	)
	unbinding_chants = list(
		"I let the hearthfire fade.",
		"Domus, me relinquere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/great_shelter,
		/datum/action/cooldown/spell/create_campfire,
	)

/datum/magic_aspect/hex
	name = "Hex"
	latin_name = "Minor Aspectus Maleficii"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_HEX
	binding_chants = list(
		"Let me speak the crooked word.",
		"Maleficium, mihi adesse!",
	)
	unbinding_chants = list(
		"I unsay the crooked word.",
		"Maleficium, me relinquere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/wither,
	)
