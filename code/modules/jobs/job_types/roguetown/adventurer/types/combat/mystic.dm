/datum/advclass/mystic
	name = "Mystic"
	tutorial = "I have spent my youth deepening my faith, only to be lured by the way of the magi, to the great regret of my family"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/mystic
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_SEEDKNOW, TRAIT_ARCYNE_T1)
	subclass_stats = list( // stat spread of 6 points, lower than the 7 adventurer gets on average
			STATKEY_INT = 2,
			STATKEY_CON = 2,
			STATKEY_WIL = 2,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_spellpoints = 8 // +2 spellpoints the mystic is quite iltteraly the toolbox of casters, capable of a lot while not having much for offense
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
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
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
	l_hand = /obj/item/rogueweapon/scabbard/gwstrap
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
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
	name = "Resilient Soul"
	tutorial = "I have spent my youth deepening my faith, but soon followed closely on the side of a generous enchantor who taught me a few tricks to preserve and save lyves"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/resilient
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_SEEDKNOW, TRAIT_ARCYNE_T1)
	subclass_stats = list(
			STATKEY_INT = 1,
			STATKEY_CON = 3,
			STATKEY_WIL = 2,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_spellpoints = 4 // +2 spellpoint, added flexibility, this is a healer focussed class and should be able to a bit more than just healing with the arcyne-holy training
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE, // lower weapon profficiency because of specialization/unique spell pack
	)

/datum/outfit/job/roguetown/adventurer/resilient/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("I have spent my youth deepening my faith, but soon followed closely on the side of a generous enchantor who taught me a few tricks to preserve and save lyves"))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/roguegem/amethyst = 1, // for their starting staff or a gem-bound spellbook if they take the time to craft one, increase how fast they cast stoneskin/fortitude
		)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/stoneskin)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fortitude)
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
	tutorial = "I have spent my youth deepening my faith and one day a spellblade was under my care at the church, ever since their recovery they accepted me as their pupil and taught the way of the blade and arcyne"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/holyblade
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_SEEDKNOW, TRAIT_ARCYNE_T1)
	subclass_stats = list(
			STATKEY_STR = 1,
			STATKEY_PER = 1,
			STATKEY_INT = 1,
			STATKEY_CON = 1,
			STATKEY_WIL = 1,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_spellpoints = 4 // +3 spellpoints, despite your training to melee weapon and spell you are still not capable of good defense and offense
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE, // lower weapon profficiency because of specialization/unique spell pack
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE, // trainable on a target dummy/with other players/simple mobs, slight time sink
	)

/datum/outfit/job/roguetown/adventurer/holyblade/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("I have spent my youth deepening my faith and one day a spellblade was under my care at the church, ever since their recovery they accepted me as their pupil and taught the way of the blade and arcyne"))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/shield/wood
	beltr = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/iron
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/arcynestrike)
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

/datum/advclass/mystic/theurgist
	name = "Theurgist"
	tutorial = "I have spent my youth deepening my faith among Noctite acolytes and where shown the wonders of the Arcynes, one day i decided to begins my studies of the arcyne art"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/theurgist
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_SEEDKNOW, TRAIT_ARCYNE_T1)
	subclass_stats = list(
			STATKEY_INT = 3,
			STATKEY_CON = 1,
			STATKEY_WIL = 2,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_spellpoints = 3 // +2 spellpoints, you focused on offensive training and loose on utility
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE, // lower weapon profficiency because of specialization/unique spell pack
	)

/datum/outfit/job/roguetown/adventurer/theurgist/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("I have spent my youth deepening my faith among Noctite acolytes and where shown the wonders of the Arcynes, one day i decided to begins my studies of the arcyne art"))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/roguegem/amethyst = 1,
		)

	var/options = list("Arcyne bolt and Repulse", "Arcyne bolt and Blink", "Frost bolt and Repulse", "Frost bolt and Blink", "Spitfire and Repulse", "Spitfire and Blink", "Lightning bolt and Repulse", "Lightning bolt and Blink")
	var/option_choice = input("Shape your offense", "Rain Destruction!") as anything in options
	switch(option_choice)
		if("Arcyne bolt and Repulse")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/arcynebolt)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/repulse)
		if("Arcyne bolt and Blink")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/arcynebolt)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/blink)
		if("Frost bolt and Repulse")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/frostbolt)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/repulse)
		if("Frost bolt and Blink")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/frostbolt)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/blink)
		if("Spitfire and Repulse")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/spitfire)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/repulse)
		if("Spitfire and Blink")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/spitfire)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/blink)
		if("Lightning bolt and Repulse")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/repulse)
		if("Lightning bolt and Blink")
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/lightningbolt)
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/blink)



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
