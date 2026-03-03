/datum/advclass/czwarteki/heir
	name = "Tomorzurkh Lord's Heir"
	tutorial = "You are the Tomorzurkh Lord's Heir, or perhaps one of many. Your parent has brought you into this venture - willingly or not - for the sake of gaining experience and knowing the realms beyond your home."
	outfit = /datum/outfit/job/roguetown/czwarteki/heir
	traits_applied = list(TRAIT_NOBLE, TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED)
	category_tags = list(CTAG_CZWAR_HEIR)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_stats = list(
	STATKEY_STR = 2,
	STATKEY_WIL = 2,
	STATKEY_INT = 1,
	STATKEY_SPD = 1,
	STATKEY_LCK = 3,
	)

	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/czwarteki/heir/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/nyle/consortcrown
	pants = /obj/item/clothing/under/roguetown/chainlegs
	armor = /obj/item/clothing/suit/roguetown/armor/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	shoes = /obj/item/clothing/shoes/roguetown/boots/nobleboot
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/flashlight/flare/torch/lantern
	l_hand = /obj/item/rogueweapon/sword/sabre/dec
	beltl = /obj/item/rogueweapon/scabbard/sword/noble
	neck = /obj/item/clothing/neck/roguetown/bevor
	backr = /obj/item/storage/backpack/rogue/satchel
	id = /obj/item/scomstone
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1, 
		/obj/item/natural/feather = 1,
		/obj/item/paper/scroll = 1,
		/obj/item/storage/belt/rogue/pouch/coins/veryrich = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpotnew = 1,
		)
	H.cmode_music = 'sound/music/combat_czwarteki.ogg'
	H.grant_language(/datum/language/aavnic)
