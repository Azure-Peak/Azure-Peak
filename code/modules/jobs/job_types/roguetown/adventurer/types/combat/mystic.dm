/datum/advclass/mystic
	name = "Mystic"
	tutorial = "I have spent my youth deepening my faith, only to be lured by the way of the magi, to the great regret of my family"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/mystic
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT) //so they can produce red+ and blue+
	subclass_stats = list( //only class with a 7 point spread to compensate their lack offensive cantrip
			STATKEY_INT = 3,
			STATKEY_CON = 2,
			STATKEY_WIL = 2,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE, 
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
	backl = /obj/item/storage/backpack/rogue/backpack
	r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
	l_hand = /obj/item/rogueweapon/scabbard/gwstrap
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/folding_alchcauldron_stored = 1,
		/obj/item/reagent_containers/glass/bottle = 3,
		/obj/item/reagent_containers/glass/bottle/alchemical = 3,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/book/spellbook = 1,
		/obj/item/chalk = 1,
		)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)

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
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
			STATKEY_INT = 2,
			STATKEY_CON = 2,
			STATKEY_WIL = 2,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4, "locked_aspects" = list(/datum/magic_aspect/lesser_augmentation))
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE, //limited at apprentice, they have tools to reduce damage taken and slowing down bleeding
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
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/book/spellbook = 1,
		/obj/item/chalk = 1,
		)

	H.mind.AddSpell(new /datum/action/cooldown/spell/stoneskin)
	H.mind.AddSpell(new /datum/action/cooldown/spell/bestow_ward)

	var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Greater Arcyne Bolt", "Stygian Efflorescence", "Arcyne Lance", "Lesser Gravel Blast")
	var/poke_choice = input(H, "Choose your offensive cantrip.", "Arcyne Training") as anything in poke_options
	switch(poke_choice)
		if("Spitfire")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
		if("Frost Bolt")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
		if("Arc Bolt")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
		if("Greater Arcyne Bolt")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/greater_arcyne_bolt)
		if("Stygian Efflorescence")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
		if("Arcyne Lance")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)
		if("Lesser Gravel Blast")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast/lesser)
			
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

/datum/advclass/mystic/holyblade
	name = "Luminary"
	tutorial = "I have spent my youth deepening my faith and one day an azurcaephan was under my care at the church, ever since their recovery i became the pupil of the noccite priests and templars"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/holyblade
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
			STATKEY_STR = 1,
			STATKEY_PER = 1,
			STATKEY_INT = 1,
			STATKEY_CON = 1,
			STATKEY_WIL = 1,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 2)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
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
	neck = /obj/item/clothing/neck/roguetown/coif/padded

	if(H.mind)
		var/weapons = list("Arming Sword", "Shortsword + shield", "Quarterstaff", "Mace + shield", "Spear") // you may want to upgrade for a better sword
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Arming Sword")
				r_hand = /obj/item/rogueweapon/sword
				beltr = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
			if("Shortsword + shield")
				r_hand = /obj/item/rogueweapon/sword/short
				beltr = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 3, TRUE)
			if("Quarterstaff")
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, 3, TRUE)
			if("Mace + shield")
				r_hand = /obj/item/rogueweapon/mace
				backr = /obj/item/rogueweapon/shield/wood
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 3, TRUE)
			if("Spear")
				r_hand = /obj/item/rogueweapon/spear
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)

	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/book/spellbook = 1,
		/obj/item/chalk = 1,
		)
	var/list/poke_options = list("Spitfire", "Frost Bolt", "Arc Bolt", "Greater Arcyne Bolt", "Stygian Efflorescence", "Arcyne Lance", "Lesser Gravel Blast")
	var/poke_choice = input(H, "Choose your offensive cantrip.", "Arcyne Training") as anything in poke_options
	switch(poke_choice)
		if("Spitfire")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/spitfire)
		if("Frost Bolt")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/frost_bolt)
		if("Arc Bolt")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arc_bolt)
		if("Greater Arcyne Bolt")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/greater_arcyne_bolt)
		if("Stygian Efflorescence")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/stygian_efflorescence)
		if("Arcyne Lance")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/arcyne_lance)
		if("Lesser Gravel Blast")
			H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/gravel_blast/lesser)
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

