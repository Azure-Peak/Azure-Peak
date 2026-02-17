/datum/advclass/wretch/outlaw
	name = "Outlaw"
	tutorial = "You are the person folk fear at night - use your cunning and speed to strike fast and get out with your spoils before anyone notices."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/outlaw
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	category_tags = list(CTAG_WRETCH)
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_DODGEEXPERT, TRAIT_GRAVEROBBER) //Doubt you have much to say about robbing graves
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 1
	)
	subclass_skills = list(
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,
		/datum/skill/craft/traps = SKILL_LEVEL_MASTER,
	)
	subclass_stashed_items = list(
        "Sewing Kit" =  /obj/item/repair_kit,
    )

/datum/outfit/job/roguetown/wretch/outlaw/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are the person folk fear at night - use your cunning and speed to strike fast and get out with your spoils before anyone notices."))
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	cloak = /obj/item/clothing/cloak/tabard/stabard/dungeon
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backl = /obj/item/storage/backpack/rogue/satchel/short
	belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/steel
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	beltr = /obj/item/quiver/bolts
	backpack_contents = list(
		/obj/item/lockpickring/mundane = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1
		)
	if(H.mind)
		var/weapons = list("Rapier","Parrying Dagger", "Whip")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		var/specialization = list("Fleet-Footed","Marksmanship","Athleticism","Night-Burglar","Master-Tracker")
		var/specialization_choice = input(H, "Choose your talent.", "TAKE UP ARMS") as anything in specialization
		H.set_blindness(0)
		switch(weapon_choice)
			if("Rapier")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				beltl = /obj/item/rogueweapon/scabbard/sword
				l_hand = /obj/item/rogueweapon/sword/rapier
			if("Parrying Dagger")
				beltl = /obj/item/rogueweapon/scabbard/sheath
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
			if ("Whip")
				H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_EXPERT, TRUE)
				l_hand = /obj/item/rogueweapon/whip
		switch(specialization_choice)
			if("Fleet-Footed")
				H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_LEGENDARY, TRUE)
				ADD_TRAIT(H, TRAIT_LIGHT_STEP, TRAIT_GENERIC)
			if("Marksmanship")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_LEGENDARY, TRUE)
				H.change_stat(STATKEY_PER, 1)
			if("Athleticism")
				H.adjust_skillrank_up_to(/datum/skill/misc/athletics, SKILL_LEVEL_MASTER, TRUE)
				H.change_stat(STATKEY_CON, 1)
			if("Night-Burglar")
				H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking, SKILL_LEVEL_LEGENDARY, TRUE)
				ADD_TRAIT(H, TRAIT_DARKVISION, TRAIT_GENERIC)
			if("Master-Tracker")
				H.adjust_skillrank_up_to(/datum/skill/misc/tracking, SKILL_LEVEL_LEGENDARY, TRUE)
				ADD_TRAIT(H, TRAIT_SLEUTH, TRAIT_GENERIC)
				ADD_TRAIT(H, TRAIT_PERFECT_TRACKER, TRAIT_GENERIC)
		wretch_select_bounty(H)
