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

/datum/magic_aspect/aegiscraft
	name = "Aegiscraft"
	latin_name = "Minor Aspectus Aegidis"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_ARCANE
	binding_chants = list(
		"Let me the shield that will protect me.",
		"Aegis, mihi adesse!",
	)
	unbinding_chants = list(
		"I set aside the shield, peace be with me.",
		"Aegis, me relinquere!",
	)
	choice_spells = list(
		/datum/action/cooldown/spell/conjure_aegis,
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
		/datum/action/cooldown/spell/blink,
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

/datum/magic_aspect/lesser_kinesis
	name = "Lesser Kinesis"
	latin_name = "Minor Aspectus Vis"
	desc = "TODO"
	aspect_type = ASPECT_MINOR
	school_color = GLOW_COLOR_KINESIS
	binding_chants = list(
		"Let me push and pull at the threads of force.",
		"Vis Minor, mihi adesse!",
	)
	unbinding_chants = list(
		"I release the threads of force.",
		"Vis Minor, me relinquere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/fetch,
		/datum/action/cooldown/spell/projectile/repel,
	)

/datum/magic_aspect/lesser_augmentation
	name = "Lesser Augmentation"
	latin_name = "Minor Aspectus Augmenti"
	desc = "TODO"
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
	pointbuy_budget = 4
	// Budget: 1x 3-cost or 2x 2-cost or 1x 2-cost + fillers
	pointbuy_spells = list(
		/datum/action/cooldown/spell/haste,
		/datum/action/cooldown/spell/darkvision,
		/datum/action/cooldown/spell/stoneskin,
		/datum/action/cooldown/spell/hawks_eyes,
		/datum/action/cooldown/spell/giants_strength,
		/datum/action/cooldown/spell/guidance,
		/datum/action/cooldown/spell/featherfall,
		/datum/action/cooldown/spell/leap,
		/datum/action/cooldown/spell/nondetection,
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
