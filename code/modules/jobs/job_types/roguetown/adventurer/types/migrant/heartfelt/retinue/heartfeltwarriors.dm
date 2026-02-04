
/datum/advclass/heartfelt/retinue/houseguard
	name = "Heartfeltian House Guard"
	tutorial = "You are a House Guard for the Lord of Heartfelt, a valiant defender of the prosperous borderlands. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/houseguard
	maximum_possible_slots = 4
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_GUARD
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_HEARTFELT) // MAA footman W/O Guardsman Trait
	subclass_stats = list( //
		STATKEY_STR = 2, 
		STATKEY_INT = 1,
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = 1,
	)

	subclass_skills = list(
	/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
	/datum/skill/combat/slings = SKILL_LEVEL_NOVICE,
	/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
	/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/heartfelt/retinue/houseguard/pre_equip(mob/living/carbon/human/H)
	..()

	cloak = /obj/item/clothing/cloak/raincloak/furcloak/black // Fur cloak, instead using the brigandine for 'identification'
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	beltl = /obj/item/rogueweapon/scabbard/sword
	l_hand = /obj/item/rogueweapon/sword
	belt = /obj/item/storage/belt/rogue/leather/black
	backr = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy		//Bit worse shirt protection than the archer
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine	//Makes up for worse shirt protection with kinda better armor protection
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/gorget/steel

	H.adjust_blindness(-3)
	var/weapons = list("Warhammer & Shield","Axe & Shield","Halberd","Greataxe")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Warhammer & Shield")
			beltr = /obj/item/rogueweapon/mace/warhammer
			backl = /obj/item/rogueweapon/shield/iron
		if("Axe & Shield")
			beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
			backl = /obj/item/rogueweapon/shield/iron
		if("Halberd")
			r_hand = /obj/item/rogueweapon/halberd
			backl = /obj/item/rogueweapon/scabbard/gwstrap
		if("Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe
			backl = /obj/item/rogueweapon/scabbard/gwstrap
		else
			r_hand = /obj/item/rogueweapon/halberd
			backl = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
	)
	H.verbs |= /mob/proc/haltyell

	var/helmet = list("Etruscan Bascinet","Volf Plate Helmet","Visored Sallet","Slitted Kettle","Simple Helmet","Kettle Helmet","Sallet Helmet","Winged Helmet",)
	var/helmet_choice = input("Choose your Helm.", "TAKE UP HELMS") as anything in helmet
	switch(helmet_choice)
		if("Etruscan Bascinet")
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
		if("Volf Plate Helmet") 
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate
		if("Visored Sallet")	
			head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
		if("Slitted Kettle") 
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
		if("Simple Helmet")		
			head = /obj/item/clothing/head/roguetown/helmet
		if("Kettle Helmet")		
			head = /obj/item/clothing/head/roguetown/helmet/kettle
		if("Sallet Helmet")		
			head = /obj/item/clothing/head/roguetown/helmet/sallet
		if("Winged Helmet") 
			head = /obj/item/clothing/head/roguetown/helmet/winged
		else //In case they DC or don't choose close the panel, etc
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan


// Ranged weapons
/datum/advclass/heartfelt/retinue/housearb
	name = "Heartfeltian Missilite"
	tutorial = "You are a Missilite for the Lord of Heartfelt, a ranged combatant of the prosperous borderlands. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/housearb
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_GUARD
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED, TRAIT_HEARTFELT) // Medium Armor Forced - Heavier 'Defensive' Class
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_STR = 1,
		STATKEY_CON = 2,				
	)

	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE, 		// Still have a cugel.
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,		//Only effects draw and reload time.
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,			//Only effects draw times.
		/datum/skill/combat/slings = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, // A little better; run fast, weak boy.
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/heartfelt/retinue/housearb/pre_equip(mob/living/carbon/human/H)
	..()

	cloak = /obj/item/clothing/cloak/raincloak/furcloak/black // Fur cloak, instead of tabard due to using the brigandine for 'identification'
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/angle
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	beltl = /obj/item/rogueweapon/scabbard/sword
	l_hand = /obj/item/rogueweapon/sword
	belt = /obj/item/storage/belt/rogue/leather/black
	backr = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy		
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine
	pants = /obj/item/clothing/under/roguetown/chainlegs
	neck = /obj/item/clothing/neck/roguetown/gorget/steel

	H.adjust_blindness(-3)
	var/weapons = list("Crossbow","Bow","Sling")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Crossbow")
			beltr = /obj/item/quiver/bolts
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			H.change_stat(STATKEY_STR, 1)
		if("Bow")
			beltr = /obj/item/quiver/arrows
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			H.change_stat(STATKEY_PER, 1)
		if("Sling")
			beltr = /obj/item/quiver/sling/iron
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling // Both are belt slots and it's not worth setting where the cugel goes for everyone else, sad.
			H.change_stat(STATKEY_SPD, 1)
		else
			beltr = /obj/item/quiver/bolts
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
	)
	H.verbs |= /mob/proc/haltyell

	var/helmet = list("Etruscan Bascinet","Volf Plate Helmet","Visored Sallet","Slitted Kettle","Simple Helmet","Kettle Helmet","Sallet Helmet","Winged Helmet",)
	var/helmet_choice = input("Choose your Helm.", "TAKE UP HELMS") as anything in helmet
	switch(helmet_choice)
		if("Etruscan Bascinet")
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
		if("Volf Plate Helmet") 
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate
		if("Visored Sallet")	
			head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
		if("Slitted Kettle") 
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
		if("Simple Helmet")		
			head = /obj/item/clothing/head/roguetown/helmet
		if("Kettle Helmet")		
			head = /obj/item/clothing/head/roguetown/helmet/kettle
		if("Sallet Helmet")		
			head = /obj/item/clothing/head/roguetown/helmet/sallet
		if("Winged Helmet") 
			head = /obj/item/clothing/head/roguetown/helmet/winged
		else //In case they DC or don't choose close the panel, etc
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan

// No Cavalry Option.

//  SQUIRE - Pseudo Cavalry/MAA/Skirmisher. Jack of All Trades. Master of None. Can't get trained due to Knight not getting good training.

/datum/advclass/heartfelt/retinue/squire
	name = "Heartfeltian Squire"
	tutorial = "You are a Squire for the Knights of Heartfelt, a trainee of the valiant defenders of the prosperous borderlands. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/squire
	maximum_possible_slots = 2 // Knight and Hand/Lord. 
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_GUARD
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_SQUIRE_REPAIR, TRAIT_STEELHEARTED, TRAIT_HEARTFELT)
	subclass_stats = list( // Made 9 points due to lack of Guardsman Trait
		STATKEY_STR = 1, 
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
	)
	cmode_music = 'sound/music/combat_squire.ogg'

	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,		
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,		
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,		//Only effects draw and reload time.
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,			//Only effects draw times.
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/heartfelt/retinue/squire/pre_equip(mob/living/carbon/human/H)
	..()

	armor = /obj/item/clothing/suit/roguetown/armor/brigandine
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	cloak = /obj/item/clothing/cloak/tabard
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger = 1,  
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
		/obj/item/rogueweapon/hammer/iron = 1, // Failed Squire Virtue Items
		/obj/item/polishing_cream = 1,
		/obj/item/armor_brush = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
	) 

	var/weapons = list("Sword & Shield","Mace & Shield","Spear","Crossbow", "Bow")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Sword & Shield")
			l_hand = /obj/item/rogueweapon/sword
			beltr = /obj/item/rogueweapon/scabbard/sword
			backl = /obj/item/rogueweapon/shield/iron
		if("Mace & Shield")
			beltr = /obj/item/rogueweapon/mace/steel
			backl = /obj/item/rogueweapon/shield/iron
		if("Spear")
			r_hand = /obj/item/rogueweapon/spear
			backl = /obj/item/rogueweapon/scabbard/gwstrap
		if("Crossbow")
			beltr = /obj/item/quiver/bolts
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
		if("Bow") // They can head down to the armory to sideshift into one of the other bows.
			beltr = /obj/item/quiver/arrows
			backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
		else
			beltr = /obj/item/rogueweapon/sword
			backl = /obj/item/rogueweapon/shield/iron

	var/helmet = list("Etruscan Bascinet","Volf Plate Helmet","Visored Sallet","Slitted Kettle","Simple Helmet","Kettle Helmet","Sallet Helmet","Winged Helmet",)
	var/helmet_choice = input("Choose your Helm.", "TAKE UP HELMS") as anything in helmet
	switch(helmet_choice)
		if("Etruscan Bascinet")
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
		if("Volf Plate Helmet") 
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate
		if("Visored Sallet")	
			head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
		if("Slitted Kettle") 
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
		if("Simple Helmet")		
			head = /obj/item/clothing/head/roguetown/helmet
		if("Kettle Helmet")		
			head = /obj/item/clothing/head/roguetown/helmet/kettle
		if("Sallet Helmet")		
			head = /obj/item/clothing/head/roguetown/helmet/sallet
		if("Winged Helmet") 
			head = /obj/item/clothing/head/roguetown/helmet/winged
		else //In case they DC or don't choose close the panel, etc
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
