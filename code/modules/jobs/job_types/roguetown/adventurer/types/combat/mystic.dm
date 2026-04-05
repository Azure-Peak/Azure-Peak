/datum/advclass/mystic
	name = "Mystic"
	tutorial = "I have spent my youth deepening my faith, only to be lured by the way of the magi, to the great regret of my family"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/mystic
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_ARCYNE)
	subclass_stats = list( // stat spread of 6 points, lower than the 7 adventurer gets on average
			STATKEY_INT = 2,
			STATKEY_CON = 2,
			STATKEY_WIL = 2,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN, // average weapon skill for an adventurer role
	)

/datum/outfit/job/roguetown/adventurer/mystic/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("I have spent my youth deepening my faith, only to be lured by the way of the magi, to the great regret of my family"))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
	l_hand = /obj/item/rogueweapon/scabbard/gwstrap
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/book/spellbook = 1,
		)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
	if(H.mind)
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/blood_heal)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/undivided)
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			H.grant_language(/datum/language/abyssal)
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/mystic/resilientsoul
	name = "Sage"
	tutorial = "I have spent my youth studying both the Arcyne and Miraculous ways, and developed my mastery of shielding and preserving lyfe under my care."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/resilient
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_ARCYNE)
	subclass_stats = list(
			STATKEY_INT = 1,
			STATKEY_CON = 3,
			STATKEY_WIL = 2,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4, "locked_aspects" = list(/datum/magic_aspect/lesser_augmentation), "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/resilient/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("I have spent my youth deepening my faith, but soon followed closely on the side of a generous enchantor who taught me a few tricks to preserve and save lyves"))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/backpack
	backr = /obj/item/rogueweapon/woodstaff
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/folding_alchcauldron_stored = 1,
		/obj/item/reagent_containers/glass/bottle = 3,
		/obj/item/reagent_containers/glass/bottle/alchemical = 3,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/book/spellbook = 1,
		)
	H.mind.AddSpell(new /datum/action/cooldown/spell/stoneskin)
	H.mind.AddSpell(new /datum/action/cooldown/spell/bestow_ward)
	var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Gravel Blast", "Stygian Efflorescence", "Arcyne Lance")
	var/poke_choice = input(H, "Choose your offensive cantrip.", "Arcyne Training") as anything in poke_options
	switch(poke_choice)
		if("Spitfire")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
		if("Frost Bolt")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
		if("Arc Bolt")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
		if("Gravel Blast")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast)
		if("Stygian Efflorescence")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
		if("Arcyne Lance")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_DEVOTEE, devotion_limit = CLERIC_REQ_1)
	if(H.mind)
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/blood_heal)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/undivided)
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			H.grant_language(/datum/language/abyssal)
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/mystic/holyblade
	name = "Holyblade"
	tutorial = "I have spent my youth deepening my faith and one day a spellblade was under my care at the church, ever since their recovery they accepted me as their pupil and taught me the way of the blade and arcyne"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/holyblade
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_ARCYNE)
	subclass_stats = list(
			STATKEY_STR = 1,
			STATKEY_PER = 1,
			STATKEY_INT = 1,
			STATKEY_CON = 1,
			STATKEY_WIL = 1,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 2, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN, // usual weapon proficiency, baseline apprentice is pretty coal to work with
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE, // trainable on a target dummy/with other players/simple mobs, slight time sink
	)

/datum/outfit/job/roguetown/adventurer/holyblade/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("I have spent my youth deepening my faith and one day a spellblade was under my care at the church, ever since their recovery they accepted me as their pupil and taught me the way of the blade and arcyne"))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/wood
	beltr = /obj/item/rogueweapon/scabbard/sword
	neck = /obj/item/clothing/neck/roguetown/coif/padded

	if(H.mind)
		var/weapons = list("Arming Sword", "Shortsword", "Falchion") // you may want to upgrade for a better sword
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Arming Sword")
				r_hand = /obj/item/rogueweapon/sword
			if("Shortsword")
				r_hand = /obj/item/rogueweapon/sword/short
			if("Falchion")
				r_hand = /obj/item/rogueweapon/sword/short/falchion

	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/book/spellbook = 1,
		)
	var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Gravel Blast", "Stygian Efflorescence", "Arcyne Lance")
	var/poke_choice = input(H, "Choose your offensive cantrip.", "Arcyne Training") as anything in poke_options
	switch(poke_choice)
		if("Spitfire")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
		if("Frost Bolt")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
		if("Arc Bolt")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
		if("Gravel Blast")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast)
		if("Stygian Efflorescence")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
		if("Arcyne Lance")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_1)
	if(H.mind)
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/blood_heal)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			id = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/undivided)
			id = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			id = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			id = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			id = /obj/item/clothing/neck/roguetown/psicross/abyssor
			H.grant_language(/datum/language/abyssal)
		if(/datum/patron/divine/dendor)
			id = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			id = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			id = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			id = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			id = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			id = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			id = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/mystic/theurgist
	name = "Theurgist"
	tutorial = "I have spent my youth deepening my faith among Noccite acolytes, and was shown the wonders of the Arcyne. Ever since, I have studied the arcyne arts."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/theurgist
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_ARCYNE)
	subclass_stats = list(
			STATKEY_INT = 3,
			STATKEY_CON = 1,
			STATKEY_WIL = 2,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 3, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE, // arcyne focused class, they ought to have better alchemy knowledge than their counterpart
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN, // what the bookworm gonna do? smash your head with their stick, they are better casting a spell
	)

/datum/outfit/job/roguetown/adventurer/theurgist/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("I have spent my youth deepening my faith among Noccite acolytes, and was shown the wonders of the Arcyne. Ever since, I have studied the arcyne arts."))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/book/spellbook = 1,
		)

	var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Gravel Blast", "Stygian Efflorescence", "Arcyne Lance")
	var/poke_choice = input(H, "Choose your offensive cantrip.", "Arcyne Training") as anything in poke_options
	switch(poke_choice)
		if("Spitfire")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
		if("Frost Bolt")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
		if("Arc Bolt")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
		if("Gravel Blast")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast)
		if("Stygian Efflorescence")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
		if("Arcyne Lance")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_1)
	if(H.mind)
		H.mind.RemoveSpell(/obj/effect/proc_holder/spell/invoked/blood_heal)
	switch(H.patron?.type)
		if(/datum/patron/old_god)
			neck = /obj/item/clothing/neck/roguetown/psicross
		if(/datum/patron/divine/undivided)
			neck = /obj/item/clothing/neck/roguetown/psicross/undivided
		if(/datum/patron/divine/astrata)
			neck = /obj/item/clothing/neck/roguetown/psicross/astrata
			H.cmode_music = 'sound/music/cmode/church/combat_astrata.ogg'
		if(/datum/patron/divine/noc)
			neck = /obj/item/clothing/neck/roguetown/psicross/noc
		if(/datum/patron/divine/abyssor)
			neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
			H.grant_language(/datum/language/abyssal)
		if(/datum/patron/divine/dendor)
			neck = /obj/item/clothing/neck/roguetown/psicross/dendor
			H.cmode_music = 'sound/music/cmode/garrison/combat_warden.ogg' // see: druid.dm
		if(/datum/patron/divine/necra)
			neck = /obj/item/clothing/neck/roguetown/psicross/necra
			H.cmode_music = 'sound/music/cmode/church/combat_necra.ogg'
		if(/datum/patron/divine/pestra)
			neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		if(/datum/patron/divine/ravox)
			neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		if(/datum/patron/divine/malum)
			neck = /obj/item/clothing/neck/roguetown/psicross/malum
		if(/datum/patron/divine/eora)
			neck = /obj/item/clothing/neck/roguetown/psicross/eora
			H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'
