/datum/advclass/wretch/mistwalker
	name = "Mistwalker" //works
	tutorial = "Hailing from Kazengun you were once a sacred guardian, dedicating your lyfe to protecting your chosen shrine of the twelve against brigands and fiends from beyond alike... now? Your sacred home has fallen, claimed by ruinous forces and you are banished to wander the realm. What will you find in your search for purpose?"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT //i wonder if i will regret letting them be revs
	allowed_patrons = ALL_KAZENGUN_PATRONS //guardian of the twelve... and saidon but no undivided
	outfit = /datum/outfit/job/roguetown/wretch/mistwalker
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_NOPAINSTUN, TRAIT_BLOOD_RESISTANCE, TRAIT_JOURNEYS_END) //no armour, literally made to bleed
	maximum_possible_slots = 1 //you probably don't want many of these

	cmode_music = 'sound/music/combat_Kazengun_Firestorm.ogg'
	subclass_stats = list(
		STATKEY_STR = 2, //8 weighted with weapon buff, same as berserker
		STATKEY_CON = 1,
		STATKEY_WIL = 1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN, //wish there was an oni axe or something
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN, //you'll get real familiar with bleeding
		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN, //flavour and useful for making armour
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE, //social outcast but can still read protective charms
	)
	subclass_stashed_items = list(
        "Sewing Kit" =  /obj/item/repair_kit, //I am sure you'll find a way to repair your bracers
    )
	extra_context = "This subclass gains addition stat points from weapon selection, and is race-limited from: Constructs."
	adv_stat_ceiling = list(STAT_STRENGTH = 14, STAT_CONSTITUTION = 14, STAT_WILLPOWER = 14) //no thank you to stat stacking

/datum/outfit/job/roguetown/wretch/mistwalker/pre_equip(mob/living/carbon/human/H)
	..()
	
	change_origin(H, /datum/virtue/origin/kazengun, "guardian duty")
	to_chat(H, span_warning("Failed in your duty, outcast from whence you came you wander. Only the steel in your hand can be trusted."))
	
	if(H.dna.species.type in NON_DWARVEN_RACE_TYPES)
		armor = /obj/item/clothing/suit/roguetown/armor/basiceast/mentorsuit
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants1
	else
		armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/black
		pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/black

	head = /obj/item/clothing/head/roguetown/mentorhat
	gloves = /obj/item/clothing/gloves/roguetown/eastgloves1
	neck = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun //eh could be a regular one too
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
	mask = /obj/item/clothing/mask/rogue/facemask/steel/kazengun //let them have this
	wrists = /obj/item/clothing/wrists/roguetown/bracers/black
	shoes = /obj/item/clothing/shoes/roguetown/boots
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/kazengun = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rope/chain = 1,
		/obj/item/rogueweapon/scabbard/sheath/kazengun = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		)

	if(H.mind)
		var/weapons = list("Ssangsudo +2 CON", "Kanabo +1 STR", "Naginata +2 PER", "Hwando +2 WIL", "Kodachi +1 SPD")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Ssangsudo +2 CON")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/noparry
				H.change_stat(STATKEY_CON, 2)
			if("Kanabo +1 STR")
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/mace/goden/kanabo
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.change_stat(STATKEY_STR, 1)
			if("Naginata +2 PER")
				H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/spear/naginata
				backr = /obj/item/rogueweapon/scabbard/gwstrap
				H.change_stat(STATKEY_PER, 2)
			if("Hwando +2 WIL")
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/sabre/mulyeog
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun
				H.change_stat(STATKEY_WIL, 2)
			if("Kodachi +1 SPD") //SPD you can dodge, probably
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
				r_hand = /obj/item/rogueweapon/sword/short/kazengun
				beltr = /obj/item/rogueweapon/scabbard/sword/kazengun/kodachi
				H.change_stat(STATKEY_SPD, 1)

		wretch_select_bounty(H)

/obj/item/clothing/wrists/roguetown/bracers/black
	color = CLOTHING_BLACK
/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/black
	color = CLOTHING_BLACK
/obj/item/clothing/suit/roguetown/armor/leather/heavy/jacket/black
	color = CLOTHING_BLACK
/obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/black
	color = CLOTHING_BLACK
