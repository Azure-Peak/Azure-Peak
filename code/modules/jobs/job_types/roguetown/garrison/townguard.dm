/datum/job/roguetown/guardsman
	title = "Watchman"
	flag = GUARDSMAN
	department_flag = GARRISON
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	selection_color = JCOLOR_SOLDIER
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_TOLERATED_UP // same as town guard
	allowed_ages = list(AGE_ADULT, AGE_MIDDLEAGED)
	tutorial = "Responsible for the safety of the town and the enforcement of the Grand Duke's law, you are the vanguard of the city faced with punishing those who defy his Royal Majesty. Though you've many lords to obey, as both the Church and the Bailiff have great sway over your life."
	display_order = JDO_TOWNGUARD
	whitelist_req = TRUE

	outfit = /datum/outfit/job/roguetown/guardsman
	advclass_cat_rolls = list(CTAG_WATCH = 20)

	give_bank_account = 16
	min_pq = 1 //Introductory guard role, but still requires knowledge of escalation.
	max_pq = null
	round_contrib_points = 2

	cmode_music = 'sound/music/combat_ManAtArms.ogg'

/datum/outfit/job/roguetown/guardsman
	job_bitflag = BITFLAG_GARRISON

/datum/job/roguetown/guardsman/after_spawn(mob/living/L, mob/M, latejoin = TRUE, visuals_only, client/player_client)
	. = ..()
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		if(istype(H.cloak, /obj/item/clothing/cloak/stabard/guard))
			var/obj/item/clothing/S = H.cloak
			var/index = findtext(H.real_name, " ")
			if(index)
				index = copytext(H.real_name, 1,index)
			if(!index)
				index = H.real_name
			S.name = "watchman tabard ([index])"

/datum/outfit/job/roguetown/guardsman
	pants = /obj/item/clothing/under/roguetown/chainlegs
	cloak = /obj/item/clothing/cloak/stabard/guard
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers		//Would seperate to leather bracers for archer for dodge but - funnily, armor class doesn't exist on bracers.
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(/obj/item/signal_horn = 1)

/*Design philosophy: Men and women from various areas of life, from hunters to street-brawlers and more 'veteran' levy-men. Know less skills overall than Bog, but far more specialized.
Footsman is basically a regular foots-soldier with gear to combat criminals, specializes in maces, polearms, and decent flail/sword training.
Archer is basically a 'bounty-catcher' in function, less specialized at close-quarters, beyond knives, but very capable of downing a fleeing criminal.*/
/datum/advclass/watchman/footsman
	name = "Watch Footsman"
	tutorial = "You are a footsman of the Town Watch. Well versed in various close-quarters weapons and aprehending street-savy criminals."
	outfit = /datum/outfit/job/roguetown/guardsman/footsman

	category_tags = list(CTAG_WATCH)
	traits_applied = list(TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_SPD = 1
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE, 
	)

/datum/outfit/job/roguetown/guardsman/footsman/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail
	beltr = /obj/item/rogueweapon/mace/cudgel
	backr = /obj/item/rogueweapon/shield/wood		//Maybe give a buckler? Gave wood because 40 coverage is better than 10 but dunno.
	backr = /obj/item/storage/backpack/rogue/satchel/black
	beltl = /obj/item/storage/keyring/guardcastle
	belt = /obj/item/storage/belt/rogue/leather/black
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/rope/chain = 1,
		)
	H.verbs |= /mob/proc/haltyell

/datum/advclass/watchman/archer
	name = "Watch Archer"
	tutorial = "You are an archer of the Town Watch. Once a hunter, now a man-hunter for your lord. Rooftops, bows, and daggers are your best friend."
	outfit = /datum/outfit/job/roguetown/guardsman/archer

	category_tags = list(CTAG_WATCH)
	traits_applied = list(TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
		STATKEY_STR = 1,
		STATKEY_INT = 1,
		STATKEY_CON = 1
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_MASTER,		//Why master? Because all it does is effect draw time, which is strength x skill / 1.2. (Bow is just skill / 1.0). You get poor bonus strength, so you get skill to offset.
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_NOVICE,		//Maybe take away? Leaving for now just as a fall-back for non-lethal ability.
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,	//For basic crafting; you'll need it due to relegated support role.
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE,	//Likely hunter background; very crappy basic skill.
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE, 
	)

/datum/outfit/job/roguetown/guardsman/archer/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/roguehood/red		//To-do: Make a guard hood come in kingdom's colors.
	armor = /obj/item/clothing/suit/roguetown/armor/leather		//So they get default-dodge expert usage.
	beltr = /obj/item/quiver/bolts
	backl = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backr = /obj/item/storage/backpack/rogue/satchel/black
	beltl = /obj/item/storage/keyring/guardcastle
	belt = /obj/item/storage/belt/rogue/leather/black
	gloves = /obj/item/clothing/gloves/roguetown/leather
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel = 1,
		/obj/item/rope/chain = 1,
		)
	H.verbs |= /mob/proc/haltyell

// Added to baliff under assumption townguard.dm will not be enabled.
// /mob/proc/haltyell()
//	set name = "HALT!"
//	set category = "Noises"
//	emote("haltyell")
