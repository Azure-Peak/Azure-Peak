/datum/advclass/wretch/pyromaniac
	name = "Pyromaniac"
	tutorial = "A notorious arsonist with a penchant for fire, you wield your own personal vendetta against the chaotic forces within Azuria. Bring mayhem and destruction with flame and misfortune! Just... try not to hit yourself with your explosives - you aren't fireproof, after all."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/wretch/pyromaniac
	cmode_music = 'sound/music/Iconoclast.ogg'
	class_select_category = CLASS_CAT_ROGUE
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ALCHEMY_EXPERT, TRAIT_EXPLOSIVE_SUPPLY, TRAIT_BOMBER_EXPERT)
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_CON = 3,
		STATKEY_INT = 2,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, // To escape grapplers, fuck you
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT, // rogue archetype needs this
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"Armor Plates" = /obj/item/repair_kit/metal,
		"Stashed Funds" = /obj/item/roguecoin/silver/pile/wretchpile,
	)

/datum/outfit/job/roguetown/wretch/pyromaniac/pre_equip(mob/living/carbon/human/H)
	ADD_TRAIT(H, TRAIT_BOMBER_EXPERT, ROUNDSTART_TRAIT) // to prevent us from lighting up in flames, oughghhh
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/pyro // this is practically the sheriff helmet but a hijab, mostly for the new drip really without making them eat shit to any knife swinging peasant going for the head
	mask = /obj/item/clothing/mask/rogue/facemask/steel/confessor/lensed // huff puff, huff puff...
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	pants = /obj/item/clothing/under/roguetown/brigandinelegs
	cloak = /obj/item/clothing/cloak/bandolier
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	belt = 	/obj/item/storage/backpack/rogue/satchel/beltpack
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/bronze
	backl = /obj/item/twstrap/bombstrap/firebomb
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/natural/bundle/fibers/full = 3,
		/obj/item/flint = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,	//Small health vial
		/obj/item/runicflask/charged = 1,
		)
	if(H.mind)
		var/weapons = list("Archery", "Crossbows")
		var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		H.set_blindness(0)
		switch(weapon_choice)
			if("Archery")
				H.adjust_skillrank_up_to(/datum/skill/combat/bows, 4, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
				beltr = /obj/item/quiver/arrows
				beltl = /obj/item/rogueweapon/huntingknife/combat

			if("Crossbows")
				H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, 4, TRUE)
				backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
				beltr = /obj/item/quiver/bolt/pyro
				beltl = /obj/item/rogueweapon/huntingknife/combat

		wretch_select_bounty(H)
