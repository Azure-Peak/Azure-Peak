/datum/advclass/czwarteki/journeyman
	name = "Hussar's Retainer"
	tutorial = "You're one of the Hussars' retainers, called forth by your Knight and  your Lord into their travels - experienced in riding and tending to your Hussar's needs."
	outfit = /datum/outfit/job/roguetown/czwarteki/journeyman
	traits_applied = list(TRAIT_NOBLE, TRAIT_MEDIUMARMOR, TRAIT_STEELHEARTED)
	category_tags = list(CTAG_CZWAR_JOURNEYMAN)

	subclass_virtues = list(
		/datum/virtue/utility/riding
	)

	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 2,
		STATKEY_PER = 1,
	)

	subclass_skills = list(
	/datum/skill/combat/maces = SKILL_LEVEL_NOVICE,
	/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
	/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
	/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
	/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
	/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
	/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
	/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
	/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,
	/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/czwarteki/journeyman/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/sword/sabre
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fluted
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/scabbard/sword
	beltl = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	r_hand = /obj/item/rogueweapon/spear
	backpack_contents = list(
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/clothing/neck/roguetown/chaincoif = 1,
		/obj/item/rogueweapon/hammer/iron = 1,
		/obj/item/storage/belt/rogue/pouch/coins/mid = 1,
	)
	H.cmode_music = 'sound/music/combat_czwarteki.ogg'
