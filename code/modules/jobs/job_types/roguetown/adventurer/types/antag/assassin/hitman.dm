/datum/advclass/assassin_hitman
	name = "Assassin - Professional Hitman"
	tutorial = "You are no street-thug or yoeman, you have honed your trade for years if not outright decades. Your craft? Blending in anywhere possible, waiting for your target to be alone, and finishing the hit. After all, dead men tell no tales."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/assassin/hitman
	category_tags = list(CTAG_ASSASSIN)
	traits_applied = list(TRAIT_BLACKBAGGER)	// Agent (15)47 - Lets you use the blackbag and garrote you
	// Weighted 14
	subclass_stats = list(
		STATKEY_PER = 1,
		STATKEY_SPD = 2,
		STATKEY_STR = 1,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_INT = 1,
		STATKEY_LCK = 2,	//Bit quirky but should be good for them with maces etc.
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,			// Main weapon is going to be their garrote but maces are a good backup. (Cudgel prob)
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,		// GRAB HEEEE!!!
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,		// Viable to punch shit or use brass-knuckles as a backup.
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,	// Niche but I guess incase they get a ranged weapon on-hand.
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/assassin/hitman/pre_equip(mob/living/carbon/human/H)
	..()
	cloak = /obj/item/clothing/cloak/raincloak/mortus
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
					/obj/item/flashlight/flare/torch/lantern/prelit = 1,
					/obj/item/lockpickring/mundane = 1,
					/obj/item/clothing/head/inqarticles/blackbag = 1,
					/obj/item/inqarticles/garrote = 1,
					)
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	head = /obj/item/clothing/head/roguetown/helmet/kettle
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	backl = /obj/item/rogueweapon/mace/cudgel
	beltl = /obj/item/rogueweapon/knuckles

	if(!istype(H.patron, /datum/patron/inhumen/graggar))
		var/inputty = input(H, "Would you like to change your patron to Graggar?", "The beast roars", "No") as anything in list("Yes", "No")
		if(inputty == "Yes")
			to_chat(H, span_warning("My former deity has abandoned me.. Graggar is my new master."))
			H.set_patron(/datum/patron/inhumen/graggar)
