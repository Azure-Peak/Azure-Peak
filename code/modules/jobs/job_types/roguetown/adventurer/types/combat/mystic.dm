/datum/advclass/mystic
	name = "Mystic"
	tutorial = "I have spent my youth deepening my faith, only to be lured by the way of the magi, to the great regret of my family and scorn of the Church, they will treat my wounds but they wont ever accept me within the fold"
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/mystic
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	townie_contract_gate_exempt = TRUE
	townie_contract_gate_hide_in_list = TRUE
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
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE, 
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/mystic/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("I have spent my youth deepening my faith, only to be lured by the way of the magi, to the great regret of my family and scorn of the Church, they will treat my wounds but they wont ever accept me within the fold"))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/backpack
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard]
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/folding_alchcauldron_stored = 1,
		/obj/item/reagent_containers/glass/bottle = 3,
		/obj/item/reagent_containers/glass/bottle/alchemical = 3,
		/obj/item/recipe_book/alchemy = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
		)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
	
	if(H.mind)
		H.mind.RemoveSpell(/datum/action/cooldown/spell/miracle/heal)
		H.mind.RemoveSpell(/datum/action/cooldown/spell/miracle/heal/undivided)

	switch(H.patron?.type)
		if(/datum/patron/divine/undivided)
			var/list/heal = list("Greater Miracle (Divine)", "Fortifying Vapors (Secular)")
			var/highheal_options = input(H, "Choose your healing training.", "Experientia Medica") as anything in heal
			switch(highheal_options)
				if("Greater Miracle (Divine)")
					H.mind.AddSpell(new /datum/action/cooldown/spell/miracle/heal/undivided)
				if("Fortifying Vapors (Secular)")
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fortifyingvapors)

		if(/datum/patron/old_god) // ENDVRE LIKE THE MAN(or woman, or nonbinary) YOU ARE SUPPOSED TO BE, CHUD!
			to_chat(H, span_blue("No matter how much you pray, you weep, and you endure. HE does not answer... Your trial begins now."))
			H.emote("cry")

		else
			var/list/heal = list("Miracle (Divine)", "Fortifying Vapors (Secular)")
			var/heal_options = input(H, "Choose your healing training.", "Experientia Medica") as anything in heal
			switch(heal_options)
				if("Miracle (Divine)")
					H.mind.AddSpell(new /datum/action/cooldown/spell/miracle/heal)
				if("Fortifying Vapors (Secular)")
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fortifyingvapors)


	if(H.mind)
		var/weapons = list("Lesser Staff", "Lesser Tome", "Quarterstaff")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Lesser Staff")
				r_hand = /obj/item/rogueweapon/woodstaff/implement
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Lesser Tome")
				r_hand = /obj/item/rogueweapon/spellbook
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Quarterstaff")
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)

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
			neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/mystic/resilientsoul
	name = "Sage"
	tutorial = "I have spent my youth studying both the Arcyne in secret and Miraculous ways in the open, and developed my mastery of shielding and preserving lyfe under my care. to the great displeasure of the Church they will still treat my wounds but will never welcome me back amoung the flock."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/resilient
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
			STATKEY_STR = -1,
			STATKEY_INT = 2,
			STATKEY_CON = 3,
			STATKEY_WIL = 3,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 2, "utilities" = 4, "locked_aspects" = list(/datum/magic_aspect/lesser_augmentation))
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE, //limited at apprentice, they have tools to reduce damage taken and slowing down bleeding
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/resilient/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("I have spent my youth studying both the Arcyne in secret and Miraculous ways in the open, and developed my mastery of shielding and preserving lyfe under my care. to the great displeasure of the Church they will still treat my wounds but will never welcome me back amoung the flock."))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard]
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
		)

	grant_poke_spell(H)
	H.mind.AddSpell(new /datum/action/cooldown/spell/stoneskin)
	H.mind.AddSpell(new /datum/action/cooldown/spell/bestow_ward)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_MINOR, devotion_limit = CLERIC_REQ_1)
	if(H.mind)
		H.mind.RemoveSpell(/datum/action/cooldown/spell/miracle/bloodmiracle)
		H.mind.RemoveSpell(/datum/action/cooldown/spell/miracle/heal)
		H.mind.RemoveSpell(/datum/action/cooldown/spell/miracle/heal/undivided)

	switch(H.patron?.type)
		if(/datum/patron/divine/undivided)
			var/list/heal = list("Greater Miracle (Miracle)", "Fortifying Vapors (Medical)")
			var/highheal_options = input(H, "Choose your healing training.", "Experientia Medica") as anything in heal
			switch(highheal_options)
				if("Greater Miracle (Divine)")
					H.mind.AddSpell(new /datum/action/cooldown/spell/miracle/heal/undivided)
				if("Fortifying Vapors (Secular)")
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fortifyingvapors)

		if(/datum/patron/old_god) // ENDVRE LIKE THE MAN(or woman, or nonbinary) YOU ARE SUPPOSED TO BE, CHUD!
			to_chat(H, span_blue("No matter how much you pray, you weep, and you endure. HE does not answer... Your trial begins now."))
			H.emote("cry")

		else
			var/list/heal = list("Miracle (Divine)", "Fortifying Vapors (Secular)")
			var/heal_options = input(H, "Choose your healing training.", "Experientia Medica") as anything in heal
			switch(heal_options)
				if("Miracle (Divine)")
					H.mind.AddSpell(new /datum/action/cooldown/spell/miracle/heal)
				if("Fortifying Vapors (Secular)")
					H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fortifyingvapors)

	if(H.mind)
		var/weapons = list("Lesser Staff", "Lesser Tome")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Lesser Staff")
				r_hand = /obj/item/rogueweapon/woodstaff/implement
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Lesser Tome")
				r_hand = /obj/item/rogueweapon/spellbook
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)

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
			neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			neck = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			neck = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'

/datum/advclass/mystic/holyblade
	name = "Luminary"
	tutorial = "I have spent my youth deepening my faith and one day a spellblade was under my care at the church, after they recovered they taught me a thing of two of the arcyne, abandoning my duties for but a few daes infuriated the Bishop that banished me from the flock, they will still gladely treat my wounds in their infinite goodness."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/adventurer/holyblade
	class_select_category = CLASS_CAT_MYSTIC
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_SEEDKNOW, TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
			STATKEY_PER = 2,
			STATKEY_INT = 1,
			STATKEY_CON = 2,
			STATKEY_WIL = 2,
	)
	age_mod = /datum/class_age_mod/mystic
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 1, "utilities" = 2)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/holyblade/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("I have spent my youth deepening my faith and one day a spellblade was under my care at the church, after they recovered they taught me a thing of two of the arcyne, abandoning my duties for but a few daes infuriated the Bishop that banished me from the flock, they will still gladely treat my wounds in their infinite goodness."))
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
		var/weapons = list("Arming Sword", "Shortsword + Shield", "Mace + Shield", "Quarterstaff", "Spear") // you may want to upgrade for a better sword
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Arming Sword")
				r_hand = /obj/item/rogueweapon/sword
				beltr = /obj/item/rogueweapon/scabbard/sword
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
			if("Shortsword + Shield")
				r_hand = /obj/item/rogueweapon/sword/short
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/wood
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 3, TRUE)
			if("Quarterstaff")
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/staves, SKILL_LEVEL_JOURNEYMAN, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/arcyne, SKILL_LEVEL_JOURNEYMAN, TRUE)
			if("Mace + Shield")
				r_hand = /obj/item/rogueweapon/mace
				backr = /obj/item/rogueweapon/shield/wood
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 3, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 3, TRUE)
			if("Spear")
				r_hand = /obj/item/rogueweapon/spear
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 3, TRUE)

	H.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/male/wizard]
	backpack_contents = list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
		)
	grant_poke_spell(H)
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T1, passive_gain = CLERIC_REGEN_WITCH, devotion_limit = CLERIC_REQ_1)
	if(H.mind)
		H.mind.RemoveSpell(/datum/action/cooldown/spell/miracle/bloodmiracle)
		H.mind.AddSpell(new /datum/action/cooldown/spell/selfbuff)
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
			id = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_heretic.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/matthios)
			id = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_matthios.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/graggar)
			id = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_graggar.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/inhumen/baotha)
			id = /obj/item/clothing/neck/roguetown/psicross
			H.cmode_music = 'sound/music/combat_baotha.ogg'
			ADD_TRAIT(H, TRAIT_HERESIARCH, TRAIT_GENERIC)
		if(/datum/patron/divine/xylix)
			id = /obj/item/clothing/neck/roguetown/luckcharm
			H.cmode_music = 'sound/music/combat_jester.ogg'
