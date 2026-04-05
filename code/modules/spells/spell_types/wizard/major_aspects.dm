/datum/magic_aspect/pyromancy
	name = "Pyromancy"
	latin_name = "Maior Aspectus Ignis"
	desc = "A first-order school focused on roasting the Magi's enemy alive with the primal fury of fire\
	Its heritage is ancient, and it is often considered a sacred magick associated with Astrata's light.\
	Pyromancers are notorious for rivalry with Cryomancers - though many mages in the modern age attune to both depending on the circumstances\
	Their spells tends to negate a Cryomancer's effects - and vice versa."
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_PYROMANCY
	school_color = GLOW_COLOR_FIRE
	binding_chants = list(
		"Invoco flammam aeternam!",
		"I implore the flame within to burn bright, rise!",
		"Ignis, in me ligare!",
	)
	unbinding_chants = list(
		"Solvo flammam vinctam!",
		"I becalm the flame that dwells within, rest.",
		"Ignis, a me discedere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/spitfire,
		/datum/action/cooldown/spell/projectile/fireball,
		/datum/action/cooldown/spell/fire_blast,
		/datum/action/cooldown/spell/fire_curtain,
		/datum/action/cooldown/spell/create_campfire,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/projectile/fireball/greater,
		),
		"grenzelhoftian" = list(
			/datum/action/cooldown/spell/projectile/fireball = /datum/action/cooldown/spell/projectile/fireball/artillery,
		),
	)

/datum/magic_aspect/cryomancy
	name = "Cryomancy"
	latin_name = "Maior Aspectus Glaciei"
	desc = "A first-order school focused on degrading its opponents with every strike. What it lacks for in pure destruction \
	or speed, it makes up for in building, debilitating effects as the Magi's opponent shudders, slows, then finally freezes under every blow.\
	This school is most prevalent in Gronn, Hammerhold and Grenzelhoftian circle, and likely originated from one of these countries where frost is a daily \
	reoccurence, making it easy for Magi to imagine themselves wielding its power. Cryomancers are notorious for rivalry with Pyromancers - \
	though many mages in the modern age attune to one of the two depending on the circumstances."
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_CRYOMANCY
	school_color = GLOW_COLOR_ICE
	binding_chants = list(
		"Invoco glaciem aeternam!",
		"I invoke the cold that lingers deep, come forth!",
		"Glacies, in me ligare!",
	)
	unbinding_chants = list(
		"Solvo glaciem vinctam!",
		"I release the chill that grips my veins, thaw.",
		"Glacies, a me discedere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/frost_bolt,
		/datum/action/cooldown/spell/frost_blast,
		/datum/action/cooldown/spell/projectile/ice_burst,
		/datum/action/cooldown/spell/snap_freeze,
		/datum/action/cooldown/spell/chill_food,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/frozen_mist,
		),
	)

/datum/magic_aspect/fulgurmancy
	name = "Fulgurmancy"
	latin_name = "Maior Aspectus Fulminis"
	desc = "A first-order school focused on striking with numbing speed and overwhelming force. \
	Fulgurmancers are valued for their reliability - their spells are fast, accurate, and consistent in ways that flashier schools are not. \
	It is said the most skilled Fulgurmancer has never once seen their bolt go wide."
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_FULGURMANCY
	school_color = GLOW_COLOR_LIGHTNING
	binding_chants = list(
		"Invoco furorem tempestatis!",
		"I beckon the storm that churns above, strike!",
		"Fulmen, in me ligare!",
	)
	unbinding_chants = list(
		"Solvo tempestatem vinctam!",
		"I quiet the storm that rages within, be still.",
		"Fulmen, a me discedere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/arc_bolt,
		/datum/action/cooldown/spell/projectile/lightning_bolt,
		/datum/action/cooldown/spell/heavens_strike,
		/datum/action/cooldown/spell/thunderstrike,
		/datum/action/cooldown/spell/light,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/greater_thunderstrike,
		),
	)

/datum/magic_aspect/geomancy
	name = "Geomancy"
	latin_name = "Maior Aspectus Terrae"
	desc = "A first-order school focused on controlling the very ground. Rock was the oldest weapon known to man, and Geomancy is just as ancient as the earth. \
	Every spell is heavy and weighty, and a nimble opponent might find themselves dodging out of the way. But a Geomancer fears not - with a blast of rocks \
	they extinguish the possibility of evasion, with the grasp of earth they pin down their opponent, with a boulder they crush their foes into pulp. \
	When the very earth fights you, how can one stand before such ancient might?"
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_GEOMANCY
	school_color = GLOW_COLOR_EARTHEN
	binding_chants = list(
		"Invoco terram perennem!",
		"I entreat the stone that stands unyielding, answer!",
		"Terra, in me ligare!",
	)
	unbinding_chants = list(
		"Solvo terram vinctam!",
		"I relinquish the stone that fortifies me, crumble.",
		"Terra, a me discedere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/gravel_blast,
		/datum/action/cooldown/spell/emergence,
		/datum/action/cooldown/spell/projectile/boulder_strike,
		/datum/action/cooldown/spell/ensnare,
		/datum/action/cooldown/spell/magicians_stone,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/meteor_strike,
		),
	)

/datum/magic_aspect/kinesis
	name = "Kinesis"
	latin_name = "Maior Aspectus Vis"
	desc = "Often called the Origin school. Kinesis, or Pure Arcana as it is known by others, is said to be the oldest school of magic - \
	for magic itself is the art of converting raw energy into reality. Magicks are divided into three orders by their distance from pure force: \
	first-order schools shape primal matters like fire, ice, and stone. Second-order schools work in things forged or made by humen hands. \
	Third-order schools bend abstract concepts - the province of the divine. Kinesis alone stands apart from this ordering, for it converts nothing at all. \
	It wields raw, undiluted, barely-shaped Mana directly. With it, a mage crushes and bends the world through will alone."
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_KINESIS
	school_color = GLOW_COLOR_KINESIS
	binding_chants = list(
		"Invoco vim invisibilem!",
		"I summon the force that bends all things, obey!",
		"Vis, in me ligare!",
	)
	unbinding_chants = list(
		"Solvo vim vinctam!",
		"I unshackle the force that moves through me, disperse.",
		"Vis, a me discedere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/crush,
		/datum/action/cooldown/spell/gravity,
		/datum/action/cooldown/spell/gravity_anchor,
		/datum/action/cooldown/spell/greater_cleaning,
	)
	choice_spells = list(
		/datum/action/cooldown/spell/projectile/soulshot,
		/datum/action/cooldown/spell/projectile/greater_arcyne_bolt,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/mass_crush,
		),
	)

/datum/magic_aspect/augmentation
	name = "Augmentation"
	latin_name = "Maior Aspectus Augmenti"
	desc = "Scholars debate whether Augmentation is a first, second, or even third-order school. Its adherents consider themselves third-order - \
	with the honor of imitating the divine by augmenting the boundless potential of the humen form. Its spells are focused on enhancing the body, \
	never the mind directly - for the mind is the true province of the divine, and one cannot use magycks to enhance one's own ability to wield magycks so bluntly. \
	Woe betides those who face a warrior sharpened by the arcyne."
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_AUGMENTATION
	school_color = GLOW_COLOR_BUFF
	binding_chants = list(
		"Invoco potentiam perfectionis!",
		"I beseech the arcyne to hone my form, sharpen!",
		"Augmentum, in me ligare!",
	)
	unbinding_chants = list(
		"Solvo augmentum vinctum!",
		"I forfeit the strength bestowed upon me, diminish.",
		"Augmentum, a me discedere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/forcewall,
		/datum/action/cooldown/spell/mending,
	)
	choice_spells = list(
		/datum/action/cooldown/spell/projectile/soulshot,
		/datum/action/cooldown/spell/projectile/greater_arcyne_bolt,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE = /datum/action/cooldown/spell/ascension,
		),
	)
	pointbuy_budget = 12
	pointbuy_spells = list(
		/datum/action/cooldown/spell/haste,
		/datum/action/cooldown/spell/darkvision,
		/datum/action/cooldown/spell/stoneskin,
		/datum/action/cooldown/spell/hawks_eyes,
		/datum/action/cooldown/spell/giants_strength,
		/datum/action/cooldown/spell/fortitude,
		/datum/action/cooldown/spell/guidance,
		/datum/action/cooldown/spell/featherfall,
		/datum/action/cooldown/spell/enlarge,
		/datum/action/cooldown/spell/leap,
		/datum/action/cooldown/spell/nondetection,
		// 1-cost utility filler
		/datum/action/cooldown/spell/light,
		/datum/action/cooldown/spell/mending,
		/datum/action/cooldown/spell/create_campfire,
		/datum/action/cooldown/spell/message,
	)

/datum/magic_aspect/ferramancy
	name = "Ferramancy"
	latin_name = "Maior Aspectus Ferri"
	desc = "Ferramancy is a second-order magical school. Amongst the many major aspects, it is likely the youngest - \
	though this merely puts it as younger than the other aspects by only a millennium or so. Ferramancers conceptualize primal matters \
	rendered unto weapons and tools by humen hands, materialize them, and then send them out to slash and rend their foes apart. \
	Of the major aspects, it is the only one often associated with Ravox instead of Noc - likely because of the myth that he slew Graggar \
	by hurling weapons at him. Dedicated Ferramancers are proud of their arts, and oft think themselves superior \
	by bridging the gap between primal forces and humen ingenuity. For the same reasons, some other scholars look down on it for the impureness of its power. \
	But perhaps the true reason is that metal rends wards and a mage's robe apart more efficiently than any other school of magick."
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_FERRAMANCY
	school_color = GLOW_COLOR_METAL
	binding_chants = list(
		"Invoco chalybem indomitum!",
		"I call upon the forge within, create!",
		"Chalybs, imperio meo parere!",
	)
	unbinding_chants = list(
		"Exstinguo fornacem internam!",
		"I silence the ring of hammer and steel, grow cold.",
		"Chalybs, ad quietem redire!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/projectile/sawblade_volley,
		/datum/action/cooldown/spell/blade_burst,
		/datum/action/cooldown/spell/projectile/iron_tempest,
		/datum/action/cooldown/spell/iron_skin,
		/datum/action/cooldown/spell/arcyne_forge,
	)
	choice_spells = list(
		/datum/action/cooldown/spell/projectile/stygian_efflorescence,
		/datum/action/cooldown/spell/projectile/arcyne_lance,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/blade_dance,
		),
	)

/datum/magic_aspect/battlewardry
	name = "Battlewardry"
	latin_name = "Maior Aspectus Bellitutelae"
	desc = "Battlewardry is a second-order magical school. Most other schools channel destruction - battlewardry specializes in the prevention of destruction. Battlewardens use a modified, tactical form of ward traps to punish the reckless, and shape the battlefields with force walls while layering protection onto their fortunate allies. Though warding is often associated with passive protection, Battlewardens are anything but passive - under their spells, the battlefield is molded and shaped to their will."
	aspect_type = ASPECT_MAJOR
	attuned_name = ASPECT_NAME_BATTLEWARDRY
	school_color = GLOW_COLOR_WARD
	binding_chants = list(
		"Invoco tutelam bellicam!",
		"I raise the wards of war, protect!",
		"Bellitutela, in me ligare!",
	)
	unbinding_chants = list(
		"Solvo tutelam vinctam!",
		"I lower the wards I have raised, rest.",
		"Bellitutela, a me discedere!",
	)
	fixed_spells = list(
		/datum/action/cooldown/spell/battle_ward,
		/datum/action/cooldown/spell/forcewall,
		/datum/action/cooldown/spell/arrow_ward,
		/datum/action/cooldown/spell/bestow_ward,
		/datum/action/cooldown/spell/touch/rune_ward,
	)
	choice_spells = list(
		/datum/action/cooldown/spell/projectile/soulshot,
		/datum/action/cooldown/spell/projectile/greater_arcyne_bolt,
	)
	variants = list(
		"mastery" = list(
			VARIANT_ADDITIVE =/datum/action/cooldown/spell/arcyne_fortress,
		),
	)
