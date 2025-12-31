/datum/job/roguetown/knight
	title = "Knight" //Back to proper knights.
	flag = KNIGHT
	department_flag = NOBLEMEN
	faction = "Station"
	total_positions = 3
	spawn_positions = 3
	allowed_races = RACES_NO_CONSTRUCT
	allowed_sexes = list(MALE, FEMALE)
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	tutorial = "Having proven yourself both loyal and capable, you have been knighted to serve the realm as the royal family's sentry. \
				You listen to your Liege, the Marshal, and the Knight Captain, defending your Lord and realm - the last beacon of chivalry in these dark times."
	display_order = JDO_KNIGHT
	whitelist_req = TRUE
	outfit = /datum/outfit/job/roguetown/knight
	advclass_cat_rolls = list(CTAG_ROYALGUARD = 20)
	job_traits = list(TRAIT_NOBLE, TRAIT_STEELHEARTED, TRAIT_GOODTRAINER, TRAIT_GUARDSMAN)
	give_bank_account = TRUE
	noble_income = 10
	min_pq = 8
	max_pq = null
	round_contrib_points = 2

	cmode_music = 'sound/music/combat_knight.ogg'

	job_subclasses = list(
		/datum/advclass/knight/heavy,
		/datum/advclass/knight/footknight,
		/datum/advclass/knight/mountedknight,
		/datum/advclass/knight/irregularknight
		)

/datum/outfit/job/roguetown/knight
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/knight/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/tabard/retinue))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "knight's tabard ([index])"
		var/prev_real_name = H.real_name
		var/prev_name = H.name
		var/honorary = "Ser"
		if(should_wear_femme_clothes(H))
			honorary = "Dame"
		// check if they already have it to avoid stacking titles
		if(findtextEx(H.real_name, "[honorary] ") == 0)
			H.real_name = "[honorary] [prev_real_name]"
			H.name = "[honorary] [prev_name]"

		for(var/X in peopleknowme)
			for(var/datum/mind/MF in get_minds(X))
				if(MF.known_people)
					MF.known_people -= prev_real_name
					H.mind.person_knows_me(MF)

/datum/outfit/job/roguetown/knight
	cloak = /obj/item/clothing/cloak/tabard/retinue
	neck = /obj/item/clothing/neck/roguetown/bevor
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel/black
	id = /obj/item/scomstone/bad/garrison
	backpack_contents = list(
		/obj/item/storage/keyring/guardknight = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
	)

/datum/advclass/knight/heavy
	name = "Heavy Knight"
	tutorial = "You've trained thoroughly and hit far harder than most - adept with massive swords, axes, maces, and polearms. People may fear the mounted knights, but they should truly fear those who come off their mount..."
	outfit = /datum/outfit/job/roguetown/knight/heavy

	category_tags = list(CTAG_ROYALGUARD)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 3,//Heavy hitters. Less con/end, high strength.
		STATKEY_INT = 3,
		STATKEY_CON = 1,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT, //Polearms are pretty much explicitly a two-handed weapon, so I gave them a polearm option.
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,	//Too heavy for horses.
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE, //This is not saving them considering plate but funny either way.
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/knight/heavy/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Claymore","Great Mace","Battle Axe","Greataxe","Estoc","Lucerne", "Partizan")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Claymore")
				r_hand = /obj/item/rogueweapon/greatsword/zwei
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Great Mace")
				r_hand = /obj/item/rogueweapon/mace/goden/steel
			if("Battle Axe")
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
			if("Greataxe")
				r_hand = /obj/item/rogueweapon/greataxe/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Estoc")
				r_hand = /obj/item/rogueweapon/estoc
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Lucerne")
				r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
				backl = /obj/item/rogueweapon/scabbard/gwstrap
			if("Partizan")
				r_hand = /obj/item/rogueweapon/spear/partizan
				backl = /obj/item/rogueweapon/scabbard/gwstrap

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs

	if(H.mind)
		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
			"Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"Fluted Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
	)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_CLASS, H, "Savings.")

/datum/advclass/knight/footknight
	name = "Foot Knight"
	tutorial = "You are accustomed to traditional foot-soldier training in one-handed weapons such as flails, swords, and maces. Your fortitude and mastery with the versatile combination of a shield and weapon makes you a fearsome opponent to take down!"
	outfit = /datum/outfit/job/roguetown/knight/footknight

	category_tags = list(CTAG_ROYALGUARD)
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 1,//Tanky, less strength, but high con/end.
		STATKEY_INT = 1,
		STATKEY_CON = 4,//If mercenaries can have this...
		STATKEY_WIL = 3,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/knight/footknight/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Longsword","Flail","Warhammer","Sabre")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Longsword")
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/long
			if("Flail")
				beltr = /obj/item/rogueweapon/flail/sflail
			if ("Warhammer")
				beltr = /obj/item/rogueweapon/mace/warhammer //Iron warhammer. This is one-handed and pairs well with shields. They can upgrade to steel in-round.
			if("Sabre")
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/sabre

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs
	backl = /obj/item/rogueweapon/shield/tower/metal
	if(H.mind)
		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
			"Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"Fluted Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
	)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_CLASS, H, "Savings.")

/datum/advclass/knight/mountedknight
	name = "Mounted Knight"
	tutorial = "You are the picture-perfect knight from a high tale, knowledgeable in riding steeds into battle. You specialize in weapons most useful on a saiga including spears, swords, maces, and a variety of ranged weaponry."
	outfit = /datum/outfit/job/roguetown/knight/mountedknight
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/saigabuck/tame/saddled

	category_tags = list(CTAG_ROYALGUARD)

	traits_applied = list(TRAIT_HEAVYARMOR)
	//Decent all-around stats. Nothing spectacular. Ranged/melee hybrid class on horseback.
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
		STATKEY_PER = 2
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/knight/mountedknight/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	if(H.mind)
		H.adjust_blindness(-3)
		var/weapons = list(
			"Longsword + Crossbow",
			"Billhook + Recurve Bow",
			"Grand Mace + Longbow",
			"Sabre + Recurve Bow",
			"Lance + Kite Shield"
		)
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Longsword + Crossbow")
				beltl = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/long
				beltr = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			if("Billhook + Recurve Bow")
				r_hand = /obj/item/rogueweapon/spear/billhook
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("Grand Mace + Longbow")
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/rogueweapon/mace/goden/steel
			if("Sabre + Recurve Bow")
				l_hand = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			if("Lance + Kite Shield")
				r_hand = /obj/item/rogueweapon/spear/lance
				backl = /obj/item/rogueweapon/shield/tower/metal
				H.adjust_skillrank_up_to(/datum/skill/combat/shields, 2, TRUE) // Let them skip dummy hitting

	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	pants = /obj/item/clothing/under/roguetown/chainlegs

	if(H.mind)
		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"None"
		)
		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]

		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
			"Coat of Plates"	= /obj/item/clothing/suit/roguetown/armor/brigandine/coatplates,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"Fluted Cuirass"	= /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
	)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_CLASS, H, "Savings.")


/datum/advclass/knight/irregularknight
	name = "Royal Champion"
	tutorial = "Your skillset is abnormal for a knight. Your swift maneuvers and masterful technique impress both lords and ladies alike, and you have a preference for quicker, more elegant blades. While you are an effective fighting force in medium armor, your evasive skills will only truly shine if you don even lighter protection."
	outfit = /datum/outfit/job/roguetown/knight/irregularknight

	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_DODGEEXPERT)
	category_tags = list(CTAG_ROYALGUARD)
	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 1,
		STATKEY_WIL = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 1,
		STATKEY_FOR = 1
	)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT, //Swords and knives class.
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT, //Whips can work as a light class weapon.
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT, //Bows fit a light/speedy class pretty well, gave them ranged options.
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE, //Should have Jman but wears medium/light so no
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
	)


/datum/outfit/job/roguetown/knight/irregularknight/pre_equip(mob/living/carbon/human/H)
	..()
	H.dna.species.soundpack_m = new /datum/voicepack/male/knight()
	H.verbs |= /mob/proc/haltyell

	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Rapier + Longbow","Estoc + Recurve Bow","Sabre + Buckler","Whip + Crossbow","Greataxe + Sling")
		var/armor_options = list("Light Armor", "Medium Armor", "Medium Cuirass")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		var/armor_choice = input(H, "Choose your armor.", "TAKE UP ARMS") as anything in armor_options
		H.set_blindness(0)
		switch(weapon_choice)
			if("Rapier + Longbow")
				r_hand = /obj/item/rogueweapon/sword/rapier
				beltl = /obj/item/rogueweapon/scabbard/sword
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
				beltr = /obj/item/quiver/arrows

			if("Estoc + Recurve Bow")
				r_hand = /obj/item/rogueweapon/estoc
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve

			if("Sabre + Buckler")
				beltl = /obj/item/rogueweapon/scabbard/sword
				r_hand = /obj/item/rogueweapon/sword/sabre
				backl = /obj/item/rogueweapon/shield/buckler

			if("Whip + Crossbow")
				beltl = /obj/item/rogueweapon/whip
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/bolts

			if("Greataxe + Sling")
				H.adjust_skillrank(/datum/skill/combat/slings, 4, TRUE)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
				r_hand = /obj/item/rogueweapon/greataxe/steel
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/quiver/sling/iron
				beltl = /obj/item/gun/ballistic/revolver/grenadelauncher/sling

		switch(armor_choice)
			if("Light Armor")
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
			if("Medium Armor")
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
				pants = /obj/item/clothing/under/roguetown/chainlegs
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light/retinue
			if("Medium Cuirass")
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
				pants = /obj/item/clothing/under/roguetown/chainlegs
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted

		var/helmets = list(
			"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
			"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
			"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
			"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
			"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
			"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
			"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
			"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
			"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
			"Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
			"None"
		)

		var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
		if(helmchoice != "None")
			head = helmets[helmchoice]
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
	)
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_CLASS, H, "Savings.")
