/datum/advclass/wretch/freeblade
	name = "Free Blade"
	tutorial = "You are a man of stories and legends, an unmatched swordsman and renowned thief - the type that Peasants speak of in the Nite and Nobles warn of. A liberator of the downtrodden and selfish bastard in equal measures. You are the Nobility's symbols turned to their guillotine. Matthios stares over you, make him proud."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/wretch/freeblade
	cmode_music = 'sound/music/cmode/antag/combat_cutpurse.ogg'
	class_select_category = CLASS_CAT_WARRIOR
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_FREEBLADE, TRAIT_FREEBLADEDEXTERITY)
	allowed_patrons = /datum/patron/inhumen/matthios
	maximum_possible_slots = 1

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_PER = 1,
		STATKEY_INT = 3,
		STATKEY_CON = 1,
		STATKEY_WIL = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_JOURNEYMAN
	)
	adv_stat_ceiling = list(STAT_STRENGTH = 12, STAT_CONSTITUTION = 13, STAT_SPEED = 12, STAT_WILLPOWER = 14)
	subclass_stashed_items = list(
		"Sewing Kit" =	/obj/item/repair_kit,
		"Armor Plates" =	/obj/item/repair_kit/metal,
	) // there's no money on purpose, because I think it's funny.

/datum/outfit/job/roguetown/wretch/freeblade/pre_equip(mob/living/carbon/human/H)
	..()
	pants = /obj/item/clothing/under/roguetown/brigandinelegs
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord/heavy
	backr = /obj/item/storage/backpack/rogue/satchel/short
	gloves = /obj/item/clothing/gloves/roguetown/chain
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	l_hand = /obj/item/rogueweapon/scabbard/sword
	id = /obj/item/clothing/neck/roguetown/psicross/inhumen/matthios
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/parrying = 1
		)
	if(H.mind)
		var/weapons = list("The Aristocrat's Choice","An Etruscan's Finesse", "A Southerner's Versatility")
		var/weapon_choice = input(H, "HOW WILL YOU BE ARMED?", "TAKE UP ARMS") as anything in weapons
		var/armors = list ("IN BRAZEN GLORY", "AS ANY OTHER MAN")
		var/armor_choice = input(H, "HOW WILL YOU BE OUTFITTED?", "TAKE UP ARMOR") as anything in armors

		switch(weapon_choice)
			if("The Aristocrat's Choice")
				r_hand = /obj/item/rogueweapon/sword/long/matthios
			if("An Etruscan's Finesse")
				r_hand = /obj/item/rogueweapon/sword/rapier/vaquero
			if ("A Southerner's Versatility")
				r_hand = /obj/item/rogueweapon/sword/sabre

		switch(armor_choice)
			if("IN BRAZEN GLORY")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted/grinning
				head = /obj/item/clothing/head/roguetown/helmet/sallet/visored/grinning
				neck = /obj/item/clothing/neck/roguetown/bevor
				wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain/alloyed
				belt = /obj/item/storage/belt/rogue/leather/plaquegold
			if("AS ANY OTHER MAN")
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted
				head = /obj/item/clothing/head/roguetown/helmet/sallet
				mask = /obj/item/clothing/mask/rogue/facemask/steel
				neck = /obj/item/clothing/neck/roguetown/chaincoif/full
				wrists = /obj/item/clothing/wrists/roguetown/bracers/jackchain
				belt = /obj/item/storage/belt/rogue/leather/steel/tasset
		wretch_select_bounty(H)
