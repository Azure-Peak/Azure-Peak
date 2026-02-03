
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
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_PER = 1,
		STATKEY_INT = 2,
		STATKEY_CON = 3,
		STATKEY_WIL = 2,
		STATKEY_SPD = -1,
	)

	subclass_skills = list(
	/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/whipsflails = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
	/datum/skill/combat/unarmed =SKILL_LEVEL_JOURNEYMAN,
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

	gloves = /obj/item/clothing/gloves/roguetown/plate
	pants = /obj/item/clothing/under/roguetown/platelegs
	cloak = /obj/item/clothing/cloak/tabard
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
	neck = /obj/item/clothing/neck/roguetown/bevor
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	beltr = /obj/item/rogueweapon/scabbard/sword/noble
	l_hand = /obj/item/rogueweapon/sword/long
	r_hand = /obj/item/rogueweapon/mace/goden/steel
	beltl = /obj/item/flashlight/flare/torch/lantern
	belt = /obj/item/storage/belt/rogue/leather/steel
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backl = /obj/item/rogueweapon/scabbard/gwstrap
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/noble = 1,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		/obj/item/natural/bundle/cloth/bandage/full = 1,
	)
	// This code is broken but also not, I assume because it has 1 Advanced Class at the moment DO NOT UNCOMMENT. 
	// IT WORKS :TM: still gives them a helm and grandmace, just not the choice
	
	H.adjust_blindness(-3)
	var/weapons = list("Zweihander","Great Mace","Battle Axe","Greataxe","Estoc","Lucerne", "Partizan")
	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Zweihander")
			r_hand = /obj/item/rogueweapon/greatsword/zwei
		if("Great Mace")
			r_hand = /obj/item/rogueweapon/mace/goden/steel
		if("Battle Axe")
			r_hand = /obj/item/rogueweapon/stoneaxe/battle
		if("Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe/steel
		if("Estoc")
			r_hand = /obj/item/rogueweapon/estoc
		if("Lucerne")
			r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
		if("Partizan")
			r_hand = /obj/item/rogueweapon/spear/partizan
		else //In case they DC or don't choose close the panel, etc
			r_hand = /obj/item/rogueweapon/eaglebeak/lucerne

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
		else //In case they DC or don't choose close the panel, etc
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight
