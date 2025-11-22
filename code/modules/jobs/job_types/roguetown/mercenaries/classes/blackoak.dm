// Elven unique mercenary type; should be scary in a way solo but easy to kill with a group or bow.
/datum/advclass/mercenary/blackoak
	name = "Black Oak's Guardian"
	tutorial = "A shady guardian of the Black Oaks. Half mercenary band, half irregular militia fighting for control of their ancestral elven homeland of the Peaks. Thankfully, you are not here today to shed the blood of the Duke's men — unless someone pays you to..."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		SPEC_ID_HALFELF,
		SPEC_ID_WOODELF,
		SPEC_ID_DARKELF
	)
	outfit = /datum/outfit/job/roguetown/mercenary/blackoak
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_blackoak.ogg'
	extra_context = "This subclass is race-restricted to: Half-Elves, Elves, Dark Elves."
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_RACISMISBAD, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_PER = 1,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/blackoak/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm
	armor = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	beltr = /obj/item/flashlight/flare/torch
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	pants = /obj/item/clothing/under/roguetown/trou/leather
	r_hand = /obj/item/rogueweapon/halberd/glaive
	backr = /obj/item/rogueweapon/scabbard/gwstrap
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/book/rogue/blackoak = 1
		)
	H.merctype = 2
/datum/advclass/mercenary/blackoak/ranger
	name = "Black Oak's Ranger"
	tutorial = "A shady guardian of the Black Oaks. Half mercenary band, half irregular militia fighting for control of their ancestral elven homeland of the Peaks. Thankfully, you are not here today to shed the blood of the Duke's men — unless someone pays you to..."
	outfit = /datum/outfit/job/roguetown/mercenary/blackoak_ranger
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_RACISMISBAD, TRAIT_DODGEEXPERT)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/blackoak_ranger/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/sallet/elven
	armor = /obj/item/clothing/suit/roguetown/armor/leather/trophyfur
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	beltr = /obj/item/rogueweapon/scabbard/sheath
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/silver/elvish
	beltl = /obj/item/quiver/arrows
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife/idagger/navaja = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/book/rogue/blackoak = 1
		)

	H.merctype = 2
