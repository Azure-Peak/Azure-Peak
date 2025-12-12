/datum/advclass/mercenary/etrusca/condottiero
	name = "Condottiero Ringleader"
	tutorial = "Hailing from the Kingdom of Etrusca, you are a Condotierro - an upstart mercenary, dedicated to leading a group of trained soldiers of fortune oft found in the employ of powerful merchants and lords for your efficiency and grace. Without a war to fight back home, the Grand Duchy has become a much-needed source of contracts. Afterall, this land is rich in coin yet poor in manpower..."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/etrusca/condottiero
	class_select_category = CLASS_CAT_ETRUSCA
	category_tags = list(CTAG_MERCENARY)
	subclass_languages = list(/datum/language/etruscan, /datum/language/thievescant)
	cmode_music = 'sound/music/combat_condottiero.ogg'
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_INT = 2
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE, //Find your own ride asshole
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/etrusca/condottiero/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	cloak = /obj/item/clothing/cloak/tabard/blkknight //Aura farming
	gloves = /obj/item/clothing/gloves/roguetown/plate
	belt = /obj/item/storage/belt/rogue/leather/battleskirt
	head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan //Literally Etruscan. You don't get a choice, you're wearing this, sire. 
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine //It's THE Etruscan armor, come on!
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/shadowshirt //padded is too strong I guess.
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
		)
	if(H.mind)
		var/weapons = list("Intrepid Leader - Dual Longswords", "Calculating Tactician - Crossbow + Shortsword")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("Intrepid Leader - Dual Longswords") //It's badass fuck you
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/dec
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/long/dec
				beltr = /obj/item/rogueweapon/scabbard/sword
				ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
				H.change_stat(STATKEY_SPD, -2)
				H.change_stat(STATKEY_STR, 2)
				H.change_stat(STATKEY_CON, 2)
				H.change_stat(STATKEY_PER, -2)
			if("Calculating Tactician - Crossbow + Shortsword") 
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_MASTER, TRUE)
				beltr = /obj/item/quiver/bolts
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/short
	H.merctype = 3

/datum/advclass/mercenary/etrusca/balestrieri
	name = "Balestriero Guildsman"
	tutorial = "You are a Balestriero - one of many loyal crossbowmen who work under the Condotierro. Armed with your trusty arbalest and navaja, a single volley from the balestrieri are said to be more lethal than a thousand cuts of a blade."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/etrusca/balestrieri
	class_select_category = CLASS_CAT_ETRUSCA
	category_tags = list(CTAG_MERCENARY)
	subclass_languages = list(/datum/language/etruscan, /datum/language/thievescant)
	cmode_music = 'sound/music/combat_condottiero.ogg'
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_PER = 3, //sharpshooters
		STATKEY_SPD = 2
	)
	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER, //Possibly too high, no idea.
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/etrusca/balestrieri/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	cloak = /obj/item/clothing/cloak/thief_cloak
	gloves = /obj/item/clothing/gloves/roguetown/angle
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/steel
	head = /obj/item/clothing/head/roguetown/helmet/kettle/
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	backl = /obj/item/storage/backpack/rogue/satchel
	beltl = /obj/item/rogueweapon/scabbard/sword
	l_hand = /obj/item/rogueweapon/sword/short
	wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
	beltr = /obj/item/quiver/bolts
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
		/obj/item/lockpick = 1
		)
	H.merctype = 3
