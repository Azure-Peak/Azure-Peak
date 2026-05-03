//////////////////////////////////////////////
/////////////////////////////////// RINGLEADER
/*

*/
/datum/advclass/warband/rebellion/warlord/ringleader
	title = "RINGLEADER"
	name = "Ringleader"
	tutorial = ""
	outfit = /datum/outfit/job/roguetown/warband/rebellion/warlord/ringleader
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_FORMATIONFIGHTER, TRAIT_STEELHEARTED, TRAIT_LAWEXPERT, TRAIT_LONGSTRIDER)
	subclass_stats = list(
		STATKEY_LCK = 3,
		STATKEY_WIL = 8,
		STATKEY_PER = 1,
		STATKEY_SPD = 3,
		STATKEY_STR = 2,
		STATKEY_CON = 1,
	)

	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,		
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/staves = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,		
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,		
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,		
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,		
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/warband/rebellion/warlord/ringleader/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/guard
	mask = /obj/item/clothing/head/roguetown/roguehood/ringleader
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	beltr = /obj/item/rogueweapon/sword/falchion/militia
	beltl = /obj/item/rogueweapon/shield/buckler
	belt = /obj/item/storage/belt/rogue/leather/battleskirt/ringleader
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backl = /obj/item/storage/backpack/rogue/satchel
	r_hand = /obj/item/rogueweapon/woodstaff/militia
	backpack_contents = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew = 1, 
	/obj/item/flashlight/flare/torch/lantern = 1, 
	/obj/item/flint = 1)

	var/background = list("Farmer","Hunter","Blacksmith","Fisherman","Cook","Tailor","Alchemist","Miner","Bum")
	var/background_choice = input("I was once a...", "I REMEMBER") as anything in background
	switch(background_choice)
		if("Farmer")
			H.adjust_skillrank_up_to(/datum/skill/labor/farming = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry = 2, TRUE)
		if("Hunter")
			H.adjust_skillrank_up_to(/datum/skill/combat/bows = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/slings = 2, TRUE)		
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming = 2, TRUE)		
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/fishing = 1, TRUE)
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
			ADD_TRAIT(H, TRAIT_TRAINED_SMITH, TRAIT_GENERIC)
		if("Fisherman")
			H.adjust_skillrank_up_to(/datum/skill/misc/swimming = 5, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/fishing = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms = 1, TRUE)
		if("Cook")
			H.adjust_skillrank_up_to(/datum/skill/combat/knives = 6, TRUE)		
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 1, TRUE)
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
		if("Alchemist")
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/reading = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/wrestling = 1, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/crafting = 1, TRUE)
		if("Miner")
			H.adjust_skillrank_up_to(/datum/skill/craft/smelting = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/mining = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/masonry = 3, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes = 2, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/athletics = 1, TRUE)
			ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
		if("Bum")
			H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking = 4, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/stealing = 4, TRUE)
			H.change_stat("strength", -3)
			H.change_stat("constitution", -3)
			H.change_stat("endurance", -3)
			H.change_stat("perception", -3)
			H.change_stat("intelligence", -3)			
			H.STALUC = rand(1, 20)
			ADD_TRAIT(H, TRAIT_LIMPDICK, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
