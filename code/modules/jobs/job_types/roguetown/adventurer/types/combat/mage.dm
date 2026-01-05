/datum/advclass/mage
	name = "Sorcerer"
	tutorial = "You are a learned mage and a scholar, having spent your life studying the arcane and its ways."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/mage
	class_select_category = CLASS_CAT_MAGE
	category_tags = list(CTAG_ADVENTURER, CTAG_COURTAGENT)
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_ALCHEMY_EXPERT)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
	)
	age_mod = /datum/class_age_mod/adv_mage
	subclass_spellpoints = 14
	subclass_skills = list(
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/mage/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a learned mage and a scholar, having spent your life studying the arcane and its ways."))
	head = /obj/item/clothing/head/roguetown/roguehood/mage
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/mage
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/reagent_containers/glass/bottle/rogue/manapot
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltl = /obj/item/rogueweapon/huntingknife
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/woodstaff
	H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
	if(H.mind)
		var/spec = list("Sorcerer", "Alchemist") // Much smaller selection with only three swords. You will probably want to upgrade.
		var/spec_choice = input(H, "Choose your specialization.", "WHO AM I?") as anything in spec
		switch(spec_choice)
			if("Sorcerer") //standart adventure mage
				H.mind?.adjust_spellpoints(4) //18, standart
				backpack_contents = list(
					/obj/item/spellbook_unfinished/pre_arcyne = 1,
					/obj/item/roguegem/amethyst = 1,
					/obj/item/chalk = 1
					)
			if("Alchemist") //less points, no book and chalk, but good alchemistry skill with roundstart and folding cauldron it backpack.
				H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_JOURNEYMAN, TRUE)
				backl = /obj/item/storage/backpack/rogue/backpack
				backpack_contents = list(
					/obj/item/folding_alchcauldron_stored = 1,
					/obj/item/reagent_containers/glass/bottle = 3,
					/obj/item/reagent_containers/glass/bottle/alchemical = 3,
					/obj/item/recipe_book/alchemy = 1,
					)
	backpack_contents |= list(
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/recipe_book/magic = 1,
		)
	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander4.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/mage/spellblade
	name = "Spellblade"
	tutorial = "You are skilled in both the arcyne art and the art of the blade. But you are not a master of either nor could you channel your magick in armor."
	outfit = /datum/outfit/job/roguetown/adventurer/spellblade
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T2)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_spellpoints = 12
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/adventurer/spellblade/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are skilled in both the arcyne art and the art of the blade. But you are not a master of either nor could you channel your magick in armor."))
	head = /obj/item/clothing/head/roguetown/bucklehat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/recipe_book/survival = 1)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/airblade)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/conjure_weapon)
	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	if(H.mind)
		var/weapons = list("Longsword", "Falchion & Wooden Shield", "Messer & Wooden Shield", "Hwando") // Much smaller selection with only three swords. You will probably want to upgrade.
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Longsword")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
			if("Falchion & Wooden Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/wood
				r_hand = /obj/item/rogueweapon/sword/short/falchion
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Messer & Wooden Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				backr = /obj/item/rogueweapon/shield/wood
				r_hand = /obj/item/rogueweapon/sword/short/messer/iron
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_APPRENTICE, TRUE)
			if("Hwando")
				r_hand = /obj/item/rogueweapon/sword/sabre/mulyeog // Meant to not have the special foreign scabbards.
				beltr = /obj/item/rogueweapon/scabbard/sword
				armor = /obj/item/clothing/suit/roguetown/armor/basiceast
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'

/datum/advclass/mage/spellsinger
	name = "Spellsinger"
	tutorial = "You belong to a school of bards renowned for their study of both the arcane and the arts."
	outfit = /datum/outfit/job/roguetown/adventurer/spellsinger
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T2, TRAIT_EMPATH, TRAIT_GOODLOVER)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_WIL = 1,
	)
	subclass_spellpoints = 10
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/music = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)
/datum/outfit/job/roguetown/adventurer/spellsinger/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You belong to a school of bards renowned for their study of both the arcane and the arts."))
	head = /obj/item/clothing/head/roguetown/spellcasterhat
	shoes = /obj/item/clothing/shoes/roguetown/boots
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/dark
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/spellcasterrobe
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/sabre
	backpack_contents = list(/obj/item/flashlight/flare/torch = 1, /obj/item/recipe_book/survival = 1)
	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T2)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mockery)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/conjure_weapon)
	H.cmode_music = 'sound/music/cmode/adventurer/combat_outlander3.ogg'
	switch(H.patron?.type)
		if(/datum/patron/inhumen/zizo)
			H.cmode_music = 'sound/music/combat_heretic.ogg'
	if(H.mind)
		var/weapons = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman", "Psyaltery", "Flute")
		var/weapon_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", weapons)
		H.set_blindness(0)
		switch(weapon_choice)
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Flute")
				backr = /obj/item/rogue/instrument/flute
