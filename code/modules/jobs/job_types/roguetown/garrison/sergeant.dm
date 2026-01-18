/datum/job/roguetown/sergeant
	title = "Sergeant"
	flag = SERGEANT
	department_flag = GARRISON
	faction = "Station"
	total_positions = 1
	spawn_positions = 1
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ACCEPTED_RACES
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED, AGE_OLD)
	tutorial = "You are the most experienced of the Crown's Soldiery, leading the men-at-arms in maintaining order and attending to threats and crimes below the court's attention. \
				See to those under your command and fill in the gaps knights leave in their wake. Obey the orders of your Marshal and the Crown."
	display_order = JDO_SERGEANT
	selection_color = JCOLOR_GARRISON
	whitelist_req = TRUE
	round_contrib_points = 3


	outfit = /datum/outfit/job/roguetown/sergeant
	advclass_cat_rolls = list(CTAG_SERGEANT = 20)

	give_bank_account = TRUE
	min_pq = 6
	max_pq = null
	cmode_music = 'sound/music/combat_ManAtArms.ogg'
	job_traits = list(TRAIT_GUARDSMAN, TRAIT_STEELHEARTED, TRAIT_MEDIUMARMOR)
	job_subclasses = list(
		/datum/advclass/sergeant/sergeant
	)

/datum/outfit/job/roguetown/sergeant
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/sergeant/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(ishuman(L))
			if(istype(H.cloak, /obj/item/clothing/cloak/tabard/stabard/surcoat/guard))
				var/obj/item/clothing/S = H.cloak
				var/index = findtext(H.real_name, " ")
				if(index)
					index = copytext(H.real_name, 1,index)
				if(!index)
					index = H.real_name
				S.name = "sergeant jupon ([index])"

//All skills/traits are on the loadouts. All are identical. Welcome to the stupid way we have to make sub-classes...
/datum/outfit/job/roguetown/sergeant
	pants = /obj/item/clothing/under/roguetown/chainlegs
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/guard
	neck = /obj/item/clothing/neck/roguetown/gorget
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	saiga_shoes = /obj/item/clothing/shoes/roguetown/horseshoes
	belt = /obj/item/storage/belt/rogue/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	backr = /obj/item/storage/backpack/rogue/satchel
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	id = /obj/item/scomstone/garrison

//Rare-ish anti-armor two hander sword. Kinda alternative of a bastard sword type. Could be cool.
/datum/advclass/sergeant/sergeant
	name = "Sergeant-at-Arms"
	tutorial = "You are a not just anybody but the Sergeant-at-Arms of the Duchy's garrison. While you may have started as some peasant or mercenary, you have advanced through the ranks to that of someone who commands respect and wields it. Take up arms, sergeant!"
	outfit = /datum/outfit/job/roguetown/sergeant/sergeant

	category_tags = list(CTAG_SERGEANT)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_CON = 2,//Glorified footman
		STATKEY_PER = 1, //Gets bow-skills, so give a SMALL tad of perception to aid in bow draw.
		STATKEY_WIL = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,	// We are basically identical to a regular MAA, except having better athletics to help us manage our order usage better
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT, //John Athlete apparently
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,	//Decent tracking akin to Skirmisher.
	)

/datum/outfit/job/roguetown/sergeant/sergeant/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/movemovemove)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/takeaim)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/hold)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/order/onfeet)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/convertrole/guard) // We'll just use Watchmen as sorta conscripts yeag?
	H.verbs |= list(/mob/living/carbon/human/proc/request_outlaw, /mob/proc/haltyell, /mob/living/carbon/human/mind/proc/setorders)
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rope/chain = 1,
		/obj/item/storage/keyring/sergeant = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot = 1,
		)
	H.adjust_blindness(-3)
	if(H.mind)
		var/weapons = list("Flail & Shield","Axe & Iron Shield","Halberd & Heater","Longsword & Crossbow","Sabre & Iron Shield")	//Bit more unique than footsman, you are a jack-of-all-trades + slightly more 'elite'.
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Flail & Shield")	//Tower-shield, higher durability wood shield w/ more coverage. Plus a steel flail; maybe.. less broken that a steel mace?
				beltr = /obj/item/rogueweapon/mace/cudgel
				beltl = /obj/item/rogueweapon/flail/sflail
				backl = /obj/item/rogueweapon/shield/tower
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, 4, TRUE)
			if("Axe & Iron Shield")	//Steel Axe - basically exact same as MAA. Has it's niche due to axe's integrity vs swords.
				beltr = /obj/item/rogueweapon/mace/cudgel
				beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel
				backl = /obj/item/rogueweapon/shield/iron
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
			if("Halberd & Heater")	//Halberd - basically exact same as MAA. It's a really valid build. Spear thrust + sword chop + bash. (Gets a Heater for secondary)
				r_hand = /obj/item/rogueweapon/halberd
				l_hand = /obj/item/rogueweapon/sword
				backl = /obj/item/rogueweapon/scabbard/gwstrap
				beltr = /obj/item/rogueweapon/shield/heater
				beltl = /obj/item/rogueweapon/scabbard/sword
			if("Longsword & Crossbow")	//Longsword + Crossbow - Kind of hybrid fighter build; big sword and a crossbow.
				beltl = /obj/item/quiver/bolts
				backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				r_hand = /obj/item/rogueweapon/sword/long
				l_hand = /obj/item/rogueweapon/scabbard/sword
			if("Sabre & Iron Shield")	//Sabre + Shield - Standard sword-fighter with a shield, good combo for quick DPS weapon and a shield for defense.
				backl = /obj/item/rogueweapon/shield/iron
				r_hand = /obj/item/rogueweapon/sword/sabre
				l_hand = /obj/item/rogueweapon/scabbard/sword
				beltr = /obj/item/rogueweapon/mace/cudgel

		var/armors = list(
			"Brigandine"		= /obj/item/clothing/suit/roguetown/armor/brigandine/retinue,
			"Steel Cuirass"		= /obj/item/clothing/suit/roguetown/armor/plate/cuirass,
			"Scalemail"	= /obj/item/clothing/suit/roguetown/armor/plate/scale,
		)
		var/armorchoice = input(H, "Choose your armor.", "TAKE UP ARMOR") as anything in armors
		armor = armors[armorchoice]
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_UPPER_MIDDLE_CLASS, H, "Savings.")
