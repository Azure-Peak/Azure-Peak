/datum/advclass/tomorzurkh/lord
	name = "Tomorzurkh Lord"
	tutorial = "You're one of many Lords of Tomorzurkh who've sworn loyalty to the Aavnic Potentate. You've come here for matters of diplomacy, conflicts, or simply passing through to assist in old alliances. You are to lead your Retinue and bring honor to the Potentate."
	outfit = /datum/outfit/job/roguetown/tomorzurkh/lord
	traits_applied = list(TRAIT_NOBLE, TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED)
	category_tags = list(CTAG_TOMOR_LORD)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
		/datum/skill/combat/crossbows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/tomorzurkh/lord/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/hussarhelm
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	belt = /obj/item/storage/belt/rogue/leather/black
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	pants = /obj/item/clothing/under/roguetown/platelegs
	cloak = /obj/item/clothing/cloak/lepoardcloak
	armor = /obj/item/clothing/suit/roguetown/armor/plate/hussar
	neck = /obj/item/clothing/neck/roguetown/bevor
	beltl = /obj/item/rogueweapon/scabbard/sword/royal
	l_hand = /obj/item/rogueweapon/sword/long/marlin
	r_hand = /obj/item/rogueweapon/huntingknife
	beltr = /obj/item/rogueweapon/scabbard/sheath/royal
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	backl = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern = 1,
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 2,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 2,
		)
	H.cmode_music = 'sound/music/combat_tomorzurkh.ogg'
	H.grant_language(/datum/language/aavnic)
