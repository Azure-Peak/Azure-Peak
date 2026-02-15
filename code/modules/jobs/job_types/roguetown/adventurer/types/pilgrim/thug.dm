/datum/advclass/thug/goon
	name = "Goon"
	tutorial = "You are a goon, a low-lyfe thug in a painful world - not good enough for war, not smart enough for peace. What you lack in station you make up for in daring."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/adventurer/thug/goon
	category_tags = list(CTAG_TOWNER)
	traits_applied = list(TRAIT_SEEPRICES_SHITTY)
	cmode_music = 'sound/music/combat_bum.ogg'
	maximum_possible_slots = 2 // i dont want an army of towner thugs
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_CON = 2,
		STATKEY_SPD = -1,
		STATKEY_INT = -2,
		STATKEY_PER = -2
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/mining = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/thug/goon/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	backpack_contents = list(
				/obj/item/flashlight/flare/torch/metal = 1,
				/obj/item/recipe_book/survival = 1,
				/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1,
				/obj/item/rogueweapon/huntingknife = 1,
				)
	var/options = list("Frypan", "Knuckles", "Navaja", "Bare Hands", "My Trusty Cudgel", "Whatever I Can Find")
	var/option_choice = input("Choose your means.", "TAKE UP ARMS") as anything in options
	switch(option_choice)
		if("Frypan")
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_EXPERT, TRUE) // expert cook; expert pan-handler
			r_hand = /obj/item/cooking/pan
		if("Knuckles")
			r_hand = /obj/item/rogueweapon/knuckles/bronzeknuckles
		if("Navaja") //Switchblade aura farm
			r_hand = /obj/item/rogueweapon/huntingknife/idagger/navaja
		if("Bare Hands")
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
		if("My Trusty Cudgel") //The classic.
			r_hand = /obj/item/rogueweapon/mace/cudgel
		if("Whatever I Can Find") // random weapon from the dungeon table; could be a wooden club, could be a halberd
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_APPRENTICE, TRUE)
			r_hand = /obj/effect/spawner/lootdrop/roguetown/dungeon/weapons
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_CLASS, H, "Savings.")

/datum/advclass/thug/wiseguy
	name = "Wise Guy"
	tutorial = "You're smarter than the rest, by a stone's throw - and you know better than to get up close and personal. Unlike most others, you can read."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/adventurer/thug/wiseguy
	category_tags = list(CTAG_TOWNER)
	traits_applied = list(TRAIT_SEEPRICES_SHITTY, TRAIT_CICERONE, TRAIT_NUTCRACKER)
	cmode_music = 'sound/music/combat_bum.ogg'
	maximum_possible_slots = 2 // i dont want an army of towner thugs
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_WIL = -2,
		STATKEY_CON = -2,	
		STATKEY_STR = -1,
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/fishing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/thug/wiseguy/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/metal = 1,
		/obj/item/recipe_book/survival = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		)
	var/options = list("Sling", "Magic Bricks", "Lockpicking Equipment")
	var/option_choice = input("Choose your means.", "TAKE UP ARMS") as anything in options
	switch(option_choice)
		if("Sling")
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, SKILL_LEVEL_JOURNEYMAN, TRUE)
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			l_hand = /obj/item/quiver/sling/iron
		if("Magic Bricks")
			H.adjust_skillrank_up_to(/datum/skill/magic/arcane, SKILL_LEVEL_EXPERT, TRUE) // i fear not the man that has practiced a thousand moves one time, but the man that has practiced one move a thousand times
			H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/magicians_brick)
		if("Lockpicking Equipment")
			H.adjust_skillrank_up_to(/datum/skill/misc/stealing, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_EXPERT, TRUE)
			ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
			r_hand = /obj/item/lockpickring/mundane
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_CLASS, H, "Savings.")

/datum/advclass/thug/bigman
	name = "Big Man"
	tutorial = "More akin to a cabbage-fed monster than a normal man, your size and strength are your greatest weapons; though they hardly supplement what's missing of your brains."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/adventurer/thug/bigman
	category_tags = list(CTAG_TOWNER)
	traits_applied = list(TRAIT_SEEPRICES_SHITTY, TRAIT_STEELHEARTED, TRAIT_HARDDISMEMBER)
	cmode_music = 'sound/music/combat_bum.ogg'
	maximum_possible_slots = 1 // i dont want an army of towner thugs
	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 5,
		STATKEY_SPD = -4,
		STATKEY_INT = -6,
		STATKEY_PER = -3,
		STATKEY_FOR = -1,
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/adventurer/thug/bigman/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather/rope
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backr = /obj/item/storage/backpack/rogue/satchel
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	backpack_contents = list(
				/obj/item/flint = 1,
				/obj/item/bait = 1,
				/obj/item/rogueweapon/huntingknife = 1,
				/obj/item/recipe_book/survival = 1,
				/obj/item/recipe_book/leatherworking = 1,
				/obj/item/rogueweapon/scabbard/sheath = 1
				)
	var/options = list("Hands-On", "Big Axe")
	var/option_choice = input("Choose your means.", "TAKE UP ARMS") as anything in options
	switch(option_choice) // you are big dumb guy, none of your options give you expert-level weapons skill
		if("Hands-On")
			ADD_TRAIT(H, TRAIT_BASHDOORS, TRAIT_GENERIC) // deal 200 damage to a door you sprint-charge into
			ADD_TRAIT(H, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
		if("Big Axe")
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			r_hand = /obj/item/rogueweapon/greataxe // not steel
	var/prev_real_name = H.real_name
	var/prev_name = H.name
	var/prefix = "Skinny" // if i see someone named "Boss" pick big man for this bit i will kill them
	H.real_name = "[prefix] [prev_real_name]"
	H.name = "[prefix] [prev_name]"	
