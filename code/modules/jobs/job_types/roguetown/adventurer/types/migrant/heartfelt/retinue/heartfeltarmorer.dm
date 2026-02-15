
/datum/advclass/heartfelt/retinue/armorer
	name = "Heartfelt Armorer"
	tutorial = "You are the Heartfelt Armorer destined for greatness,\
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be. \
	Travellers often warn of Heartfelt having fallen already, and words of secretive cultists isn't unheard of."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/armorer
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_WORKER

// Master Smith role for Heartfelt

	traits_applied = list(TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT, TRAIT_MEDIUMARMOR, TRAIT_HEARTFELT)
	subclass_stats = list(
		STATKEY_LCK = 1,
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/engineering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_MASTER, //One level above Towner Smiths
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_MASTER,
		/datum/skill/craft/smelting = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
	)

/datum/outfit/job/roguetown/heartfelt/retinue/armorer/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/rogueweapon/hammer/iron
	beltl = /obj/item/rogueweapon/tongs
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	mouth = /obj/item/rogueweapon/huntingknife
	gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves/blacksmith
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	pants = /obj/item/clothing/under/roguetown/trou
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
						/obj/item/flint = 1,
						/obj/item/rogueore/coal=2,
						/obj/item/rogueore/iron=2,
						/obj/item/rogueore/silver=1,
						/obj/item/flashlight/flare/torch/lantern = 1,
						/obj/item/rogueweapon/scabbard/sheath = 1,
						)

	if(H.pronouns == HE_HIM)
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather
		shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt
	else
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
		shoes = /obj/item/clothing/shoes/roguetown/shortboots
