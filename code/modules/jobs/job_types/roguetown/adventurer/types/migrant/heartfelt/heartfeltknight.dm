
/datum/job/roguetown/heartfelt/knight
	title = "Knight of Heartfelt"
	tutorial = "You are a Knight of Heartfelt, part of a brotherhood in service to your Lord. \
	Now, alone and committed to safeguarding the court, you ride to the Peaks, resolved to ensure their safe arrival."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	total_positions = 1
	spawn_positions = 1
	job_traits = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_HEARTFELT)
	advclass_cat_rolls = list(CTAG_HFT_KNIGHT)
	job_subclasses = list(
		/datum/advclass/heartfelt/knight
		)

/datum/job/roguetown/heartfelt/knight/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(!ishuman(L))
		return
	var/mob/living/carbon/human/H = L
	if(istype(H.cloak, /obj/item/clothing/cloak/tabard))
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

/datum/advclass/heartfelt/knight
	name = "Knight of Heartfelt"
	tutorial = "You are a Knight of Heartfelt, once part of a brotherhood in service to your Lord. \
	Now, alone and committed to safeguarding what remains of your court, you ride to the Peaks, resolved to ensure their safe arrival."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/heartfelt/knight
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_KNIGHT)
	class_select_category = CLASS_CAT_HFT_COURT
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_HEARTFELT)

	subclass_stashed_items = list("Heartfelt Caparison" = /obj/item/caparison/heartfelt)
	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_stats = list(
		STATKEY_STR = 1,
		STATKEY_INT = 1,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = -2,
	)

	subclass_skills = list(
	/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
	/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/heartfelt/knight/pre_equip(mob/living/carbon/human/H)
	..()

	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	cloak = /obj/item/clothing/cloak/tabard
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	armor = /obj/item/clothing/suit/roguetown/armor/plate/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
	beltr = /obj/item/rogueweapon/scabbard/sword/noble
	beltl = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
	)
	H.adjust_blindness(-3)
	var/weapons = list("Dec Sword + Shield","Zweihander","Great Mace","Battle Axe","Greataxe","Estoc","Eagle Beak", "Partizan", "Lance + Shield")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Dec Sword + Shield")
			l_hand = /obj/item/rogueweapon/sword/long/dec
			backl = /obj/item/rogueweapon/shield/tower/metal
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Zweihander")
			l_hand = /obj/item/rogueweapon/sword/long
			r_hand = /obj/item/rogueweapon/greatsword/zwei
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Great Mace")
			l_hand = /obj/item/rogueweapon/sword/long
			r_hand = /obj/item/rogueweapon/mace/goden/steel
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
		if("Battle Axe")
			l_hand = /obj/item/rogueweapon/sword/long
			r_hand = /obj/item/rogueweapon/stoneaxe/battle
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
		if("Greataxe")
			l_hand = /obj/item/rogueweapon/sword/long
			r_hand = /obj/item/rogueweapon/greataxe/steel
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
		if("Estoc")
			l_hand = /obj/item/rogueweapon/sword/long
			r_hand = /obj/item/rogueweapon/estoc
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
		if("Eagle Beak")
			l_hand = /obj/item/rogueweapon/sword/long
			r_hand = /obj/item/rogueweapon/eaglebeak
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("Partizan")
			l_hand = /obj/item/rogueweapon/sword/long
			r_hand = /obj/item/rogueweapon/spear/partizan
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		if("Lance + Shield")
			l_hand = /obj/item/rogueweapon/spear/lance
			backl = /obj/item/rogueweapon/shield/tower/metal
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
		else //In case they DC or don't choose close the panel, etc
			r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)

	var/helmet = list("Pigface Bascinet","Guard Helmet","Barred Helmet","Bucket Helmet","Knight's Helmet","Knight's Armet","Volf Plate Helmet" ,"Visored Sallet","Armet","Hounskull Bascinet", "Etruscan Bascinet", "Slitted Kettle")
	var/helmet_choice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmet
	switch(helmet_choice)
		if("Pigface Bascinet") 
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface
		if("Guard Helmet")	
			head = /obj/item/clothing/head/roguetown/helmet/heavy/guard
		if("Barred Helmet")		
			head = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff
		if("Bucket Helmet")		
			head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket
		if("Knight's Helmet")		
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/old
		if("Knight's Armet")		
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
		if("Volf Plate Helmet") 
			head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate
		if("Visored Sallet")	
			head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
		if("Armet")			
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet
		if("Hounskull Bascinet")
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull
		if("Etruscan Bascinet")
			head = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan
		if("Slitted Kettle") 
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle
