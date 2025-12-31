/datum/job/roguetown/manorguard
	title = "Man at Arms"
	flag = MANATARMS
	department_flag = GARRISON
	faction = "Station"
	total_positions = 5
	spawn_positions = 5 //Not getting filled either way

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED)
	tutorial = "Having proven yourself loyal and capable, you are entrusted to defend the town and enforce its laws. \
				Trained regularly in combat and siege warfare, you deal with threats - both within and without. \
				Obey your Sergeant-at-Arms, the Marshal, and the Crown. Show the nobles and knights your respect, so that you may earn it in turn. Not as a commoner, but as a soldier.."
	display_order = JDO_CASTLEGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/manorguard
	advclass_cat_rolls = list(CTAG_MENATARMS = 20)

	give_bank_account = TRUE
	min_pq = 3
	max_pq = null
	round_contrib_points = 2

	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	job_subclasses = list(
		/datum/advclass/manorguard/footsman,
		/datum/advclass/manorguard/skirmisher,
		/datum/advclass/manorguard/cavalry,
		/datum/advclass/manorguard/bailiff
	)

/datum/outfit/job/roguetown/manorguard
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/manorguard/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/stabard/surcoat/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "man-at-arms jupon ([index])"

/datum/outfit/job/roguetown/manorguard
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/guard
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	beltl = /obj/item/rogueweapon/mace/cudgel
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone/bad/garrison

// Melee goon
/datum/advclass/manorguard/footsman
	name = "Footman"
	tutorial = "You are a professional soldier of the realm, specializing in melee warfare. Stalwart and hardy, your body can both withstand and dish out powerful strikes.."
	outfit = /datum/outfit/job/roguetown/manorguard/footsman

	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,// seems kinda lame but remember guardsman bonus!!
		STATKEY_INT = 1,
		STATKEY_CON = 3, //Like other footman classes their main thing is constitution more so than anything else
		STATKEY_WIL = 1
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
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/manorguard/footsman/pre_equip(mob/living/carbon/human/H)
	..()

	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Warhammer & Shield","Axe & Shield","Sword & Shield","Halberd & Sword","Greataxe & Sword")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Warhammer & Shield")
				beltr = /obj/item/rogueweapon/mace/warhammer
				backl = /obj/item/rogueweapon/shield/iron
			if("Axe & Shield")
				beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/iron
			if("Sword & Shield")
				l_hand = /obj/item/rogueweapon/sword
				beltr = /obj/item/rogueweapon/scabbard/sword
				backl = /obj/item/rogueweapon/shield/iron
			if("Halberd & Sword")
				l_hand = /obj/item/rogueweapon/sword
				r_hand = /obj/item/rogueweapon/halberd
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Greataxe & Sword")
				l_hand = /obj/item/rogueweapon/sword
				r_hand = /obj/item/rogueweapon/greataxe
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/scabbard/sword
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		var/armor_options = list("Light Brigandine Set", "Maille Set")
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in armor_options

		switch(armor_choice)
			if("Light Brigandine Set")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				wrists = /obj/item/clothing/wrists/roguetown/splintarms
				pants = /obj/item/clothing/under/roguetown/splintlegs

			if("Maille Set")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				pants = /obj/item/clothing/under/roguetown/chainlegs

		var/helmets = list(
		"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"Bascinet Helmet"	= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"Winged Helmet" 	= /obj/item/clothing/head/roguetown/helmet/winged,
		"Skull Cap"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")

// Ranged weapons and daggers on the side - lighter armor, but fleet!
/datum/advclass/manorguard/skirmisher
	name = "Skirmisher"
	tutorial = "You are a professional soldier of the realm, specializing in ranged implements. You sport a keen eye, looking for your enemies weaknesses."
	outfit = /datum/outfit/job/roguetown/manorguard/skirmisher

	category_tags = list(CTAG_MENATARMS)
	//Garrison ranged/speed class. Time to go wild
	subclass_stats = list(
		STATKEY_STR = 1, //Xbow
		STATKEY_SPD = 2,// seems kinda lame but remember guardsman bonus!!
		STATKEY_PER = 2,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE, 		// Still have a cugel.
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,		//Only effects draw and reload time.
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,			//Only effects draw times.
		/datum/skill/combat/slings = SKILL_LEVEL_MASTER,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT, // A little better; run fast, weak boy.
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)
	extra_context = "Chooses between Light Armor (Dodge Expert) & Medium Armor."

/datum/outfit/job/roguetown/manorguard/skirmisher/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	pants = /obj/item/clothing/under/roguetown/splintlegs
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Crossbow","Bow","Sling")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		var/armor_options = list("Light Armor", "Medium Armor")
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in armor_options
		H.set_blindness(0)
		switch(weapon_choice)
			if("Crossbow")
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("Bow") // They can head down to the armory to sideshift into one of the other bows.
				beltr = /obj/item/quiver/arrows
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("Sling")
				beltr = /obj/item/quiver/sling/iron
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling // Both are belt slots and it's not worth setting where the cugel goes for everyone else, sad.

		switch(armor_choice)
			if("Light Armor")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			if("Medium Armor")
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

		backpack_contents = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/rope/chain = 1,
			/obj/item/storage/keyring/guardcastle = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
			)
		H.verbs |= /mob/proc/haltyell

		var/helmets = list(
		"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"Bascinet Helmet"	= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"Winged Helmet" 	= /obj/item/clothing/head/roguetown/helmet/winged,
		"Skull Cap"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")


/datum/advclass/manorguard/cavalry
	name = "Cavalryman"
	tutorial = "You are a professional soldier of the realm, specializing in the steady beat of hoof falls. Lighter and more expendable then the knights, you charge with lance in hand."
	outfit = /datum/outfit/job/roguetown/manorguard/cavalry
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled //Since knights start with the Buck

	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	//Garrison mounted class; charge and charge often.
	subclass_stats = list(
		STATKEY_CON = 2,// seems kinda lame but remember guardsman bonus!!
		STATKEY_WIL = 2,// Your name is speed, and speed is running.
		STATKEY_STR = 1,
		STATKEY_INT = 1, // No strength to account for the nominally better weapons. We'll see.
		STATKEY_PER = 2 //Trackers
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN, 		// Still have a cugel.
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,	//Best whip training out of MAAs, they're strong.
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,			// We discourage horse archers, though.
		/datum/skill/combat/slings = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT, 		// Like the other horselords.
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,	//Best tracker. Might as well give it something to stick-out utility wise.
	)

/datum/outfit/job/roguetown/manorguard/cavalry/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Bardiche & Sword","Sword & Shield")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Bardiche & Sword")
				l_hand = /obj/item/rogueweapon/sword
				r_hand = /obj/item/rogueweapon/halberd/bardiche
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/scabbard/sword
			if("Sword & Shield")
				beltr = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/wood

		backpack_contents = list(
			/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
			/obj/item/rope/chain = 1,
			/obj/item/storage/keyring/guardcastle = 1,
			/obj/item/rogueweapon/scabbard/sheath = 1,
			/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
			)
		H.verbs |= /mob/proc/haltyell

		var/armor_options = list("Brigandine Set", "Maille Set")
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in armor_options

		switch(armor_choice)
			if("Brigandine Set")
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				wrists = /obj/item/clothing/wrists/roguetown/splintarms
				pants = /obj/item/clothing/under/roguetown/splintlegs

			if("Maille Set")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				pants = /obj/item/clothing/under/roguetown/chainlegs

		var/helmets = list(
		"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"Bascinet Helmet"	= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"Winged Helmet" 	= /obj/item/clothing/head/roguetown/helmet/winged,
		"Skull Cap"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")

// Unarmed goon - Dungeoneer replacement
/datum/advclass/manorguard/bailiff
	name = "Bailiff"
	tutorial = "You are a professional soldier of the realm, specializing in melee warfare. Stalwart and hardy, your body can both withstand and dish out powerful strikes.."
	outfit = /datum/outfit/job/roguetown/manorguard/bailiff
	maximum_possible_slots = 1 //Had one dungeoneer before, this is how many we get to keep still.

	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_CIVILIZEDBARBARIAN)//This is surely going to be funny
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 1,
		STATKEY_LCK = 1 //Master skill and barbarian doesn't need that much more.
	)
	subclass_skills = list(
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER, //hilarious
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,//Funny
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,//Enough for majority of surgeries without grinding.
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,//Since they are MAA now I guess
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE
	)

/datum/outfit/job/roguetown/manorguard/bailiff/pre_equip(mob/living/carbon/human/H)
	..()

	neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/clothing/wrists/roguetown/splintarms
	pants = /obj/item/clothing/under/roguetown/splintlegs
	beltr = /obj/item/rogueweapon/whip/antique
	backl = /obj/item/rogueweapon/sword/long/exe/cloth

	H.adjust_blindness(-3)
	if(H.mind)
		H.set_blindness(0)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/guardcastle = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		var/helmets = list(
		"Simple Helmet" 	= /obj/item/clothing/head/roguetown/helmet,
		"Kettle Helmet" 	= /obj/item/clothing/head/roguetown/helmet/kettle,
		"Bascinet Helmet"	= /obj/item/clothing/head/roguetown/helmet/bascinet,
		"Sallet Helmet"		= /obj/item/clothing/head/roguetown/helmet/sallet,
		"Winged Helmet" 	= /obj/item/clothing/head/roguetown/helmet/winged,
		"Skull Cap"			= /obj/item/clothing/head/roguetown/helmet/skullcap,
		"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
