//////////////////////////////////////////////////////////////////
/////////////////////////////////// MILITIAMAN
/*
	guy w/militia weapons
	combined with a Towner class of their choice
*/
/datum/advclass/warband/rebellion/grunt/militiaman
	title = "MILITIAMAN"
	name = "Militiaman"
	tutorial = "In the coming tide of peasantry, scythes and pitchforks will be wielded in the hundreds. \
	Within every mob, one is held by a MILITIAMAN, whose skills are honed enough to strike true." // DELETENOTE
	outfit = /datum/outfit/job/roguetown/warband/rebellion/grunt/militiaman
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_FORMATIONFIGHTER)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_SPD = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = -1,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/slings = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)


/datum/outfit/job/roguetown/warband/rebellion/grunt/militiaman/pre_equip(mob/living/carbon/human/H)
	..()

	head = /obj/item/clothing/head/roguetown/armingcap
	mask = /obj/item/clothing/head/roguetown/roguehood
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	backl = /obj/item/storage/backpack/rogue/satchel
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	neck = /obj/item/clothing/neck/roguetown/coif
	pants =	/obj/item/clothing/under/roguetown/heavy_leather_pants

	var/background = list("Farmer","Hunter","Blacksmith","Fisherman","Cook","Tailor","Alchemist","Miner","Bum")
	var/background_choice = input("I was once a...", "I REMEMBER") as anything in background
	switch(background_choice)
		if("Farmer")
			H.adjust_skillrank_up_to(/datum/skill/labor/farming = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry = 2, TRUE)
			H.change_stat("strength", 1)
			H.change_stat("constitution", 1)
			H.change_stat("endurance", 1)
			ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		if("Hunter")
			H.adjust_skillrank_up_to(/datum/skill/combat/bows = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/slings = 2, TRUE)		
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming = 2, TRUE)		
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/fishing = 1, TRUE)
			H.change_stat("perception", 2)
			ADD_TRAIT(H, TRAIT_LONGSTRIDER, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_OUTDOORSMAN, TRAIT_GENERIC)
		if("Blacksmith")
			H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/smelting = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/engineering = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/masonry = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 1, TRUE)
			H.change_stat("strength", 1)
			H.change_stat("endurance", 1)
			ADD_TRAIT(H, TRAIT_TRAINED_SMITH, TRAIT_GENERIC)
		if("Fisherman")
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/fishing = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms = 1, TRUE)
			backr = /obj/item/fishingrod
			H.change_stat("intelligence", 1)
			H.change_stat("perception", 2)
		if("Cook")
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 1, TRUE)
			H.change_stat("endurance", 1)
			H.change_stat("constitution", 1)
			ADD_TRAIT(H, TRAIT_CICERONE, TRAIT_GENERIC)
		if("Tailor")
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking = 1, TRUE)
			beltl = /obj/item/rogueweapon/huntingknife/scissors/steel
			H.change_stat("intelligence", 1)
			H.change_stat("speed", 1)
		if("Alchemist")
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 1, TRUE)
			H.change_stat("intelligence", 1)
		if("Miner")
			H.adjust_skillrank_up_to(/datum/skill/craft/smelting = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/mining = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/masonry = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics = 1, TRUE)
			H.change_stat("endurance", 3)
			H.change_stat("strength", 1)
			ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
		if("Bum")
			H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/stealing = 4, TRUE)
			H.change_stat("strength", -3)
			H.change_stat("constitution", -3)
			H.change_stat("endurance", -3)
			H.change_stat("perception", -2)
			H.change_stat("intelligence", -2)			
			H.STALUC = rand(1, 20)
			ADD_TRAIT(H, TRAIT_LIMPDICK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)

	var/weapons = list("Flail & Shield","Heavy Flail","Spiked Greatclub","Axe","Spear","Scythe","Pick","Falchion","Sling")
	var/weapon_choice = input("I abandoned my peace and took up a...", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Heavy Flail")
			r_hand = /obj/item/rogueweapon/flail/peasantwarflail
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails = 1, TRUE)
		if("Flail")
			r_hand = /obj/item/rogueweapon/flail/militia
			l_hand = /obj/item/rogueweapon/shield/heater
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails = 1, TRUE)
		if("Spiked Greatclub")
			r_hand = /obj/item/rogueweapon/woodstaff/militia
			H.adjust_skillrank_up_to(/datum/skill/combat/maces = 1, TRUE)
		if("Axe")
			r_hand = /obj/item/rogueweapon/greataxe/militia
			H.adjust_skillrank_up_to(/datum/skill/combat/axes = 1, TRUE)
		if("Spear")
			r_hand = /obj/item/rogueweapon/spear/militia
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms = 1, TRUE)
		if("Scythe")
			r_hand = /obj/item/rogueweapon/scythe
			H.adjust_skillrank_up_to(/datum/skill/labor/farming = 1, TRUE)
		if("Pick")
			r_hand = /obj/item/rogueweapon/pick/militia/steel
			l_hand = /obj/item/rogueweapon/shield/heater
			H.adjust_skillrank_up_to(/datum/skill/labor/mining = 1, TRUE)
		if("Falchion")
			r_hand = /obj/item/rogueweapon/sword/falchion/militia
			l_hand = /obj/item/rogueweapon/shield/heater
			beltr = /obj/item/rogueweapon/scabbard
			H.adjust_skillrank_up_to(/datum/skill/combat/swords = 1, TRUE)
		if("Sling")
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			beltr = /obj/item/quiver/sling/iron
			H.adjust_skillrank_up_to(/datum/skill/combat/slings = 1, TRUE)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1
		)

///////////////////////////////////////////////
/////////////////////////////////// CONSPIRATOR
/*
	a rogue
	otherwise appears as a regular towner & spawns with the keys to their associated job

*/

/datum/advclass/warband/rebellion/grunt/conspirator
	title = "CONSPIRATOR"
	name = "Conspirator"
	tutorial = "The CONSPIRATOR is a citizen of the Azure Peak swayed to a new cause. A valuable thing - for in times like these, there's nothing deadlier than a friendly face."
	outfit = /datum/outfit/job/roguetown/warband/rebellion/grunt/conspirator
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_LIGHT_STEP, TRAIT_KEENEARS)
	subclass_stats = list(
		STATKEY_SPD = 4,
		STATKEY_CON = -2,
		STATKEY_INT = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
	)
	subclass_stashed_items = list(
		"Dagger" = /obj/item/rogueweapon/huntingknife/idagger/steel,
	)

/datum/outfit/job/roguetown/warband/rebellion/grunt/conspirator/pre_equip(mob/living/carbon/human/H)
	..()

	var/coverclass = list("Servant","Sexton","Guildsman","Farmer","Surgeon")
	var/coverclass_choice = input("Before I was inspired to join the Rebellion, I was an unremarkable...", "I REMEMBER") as anything in coverclass
	switch(coverclass_choice)
		if("Servant")
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking, 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting, 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing, 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading, 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming, 2, TRUE)
			var/subclass = list("Butler","Maid","Servant")
			var/subclass_choice = input("They still know me as a...", "I REMEMBER") as anything in subclass
			switch(subclass_choice)
				if("Butler")
					var/datum/outfit/job/roguetown/servant/butler/towner_outfit = new()
					towner_outfit.pre_equip(H)
					H.job = "Manservant"
					H.advjob = "Manservant"

				if("Maid")
					var/datum/outfit/job/roguetown/servant/maid/towner_outfit = new()
					towner_outfit.pre_equip(H)
					H.job = "Maid"
					H.advjob = "Maid"

				if("Servant")
					var/datum/outfit/job/roguetown/servant/servant/towner_outfit = new()
					towner_outfit.pre_equip(H)
					H.job = "Servant"
					H.advjob = "Servant"

		if("Sexton")
			var/datum/outfit/job/roguetown/sexton/groundskeeper/towner_outfit = new()
			towner_outfit.pre_equip(H)
			H.job = "Sexton"
			H.advjob = "Sexton"
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/magic/holy = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking = 1, TRUE)

		if("Guildsman")
			var/guild = list("Smith","Artificer","Architect")
			var/guild_choice = input("I was a...", "I REMEMBER") as anything in guild
			switch(guild_choice)
				if("Smith")
					var/datum/outfit/job/roguetown/guildsman/blacksmith/towner_outfit = new()
					towner_outfit.pre_equip(H)
					H.job = "Guild Blacksmith"
					H.advjob = "Guild Blacksmith"
				if("Artificer")
					var/datum/outfit/job/roguetown/guildsman/artificer/towner_outfit = new()
					towner_outfit.pre_equip(H)
					H.job = "Artificer"
					H.advjob = "Artificer"
				if("Architect")
					var/datum/outfit/job/roguetown/guildsman/architect/towner_outfit = new()
					towner_outfit.pre_equip(H)
					H.job = "Architect"
					H.advjob = "Architect"

		if("Farmer")
			var/datum/outfit/job/roguetown/farmer/towner_outfit = new()
			towner_outfit.pre_equip(H)
			if(should_wear_femme_clothes(H))
				H.job = "Soilbride"
				H.advjob = "Soilbride"
			else
				H.job = "Soilson"
				H.advjob = "Soilson"
			H.adjust_skillrank_up_to(/datum/skill/labor/farming = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/unarmed = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/riding = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/masonry = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 1, TRUE)
			H.change_stat("strength", 3)
			H.change_stat("constitution", 1)
			ADD_TRAIT(H, TRAIT_SEEDKNOW, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		if("Apothecary")
			var/datum/outfit/job/roguetown/apothecary/basic/towner_outfit = new()
			towner_outfit.pre_equip(H)
			H.job = "Apothecary"
			H.advjob = "Apothecary"			
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics = 1, TRUE)
			H.change_stat("intelligence", 3)
			H.change_stat("perception", 2)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_MEDICINE_EXPERT, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
