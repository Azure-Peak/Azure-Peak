/datum/advclass/mercenary/desert_rider/sahir
	name = "Desert Rider Sahir"
	tutorial = "You're a Sahir - a wisened Magi from the desert of Raneshen. You have spent your lyfe studying the arcyne arts, and also knows of of the way of the sword - a necessity when one happens upon monstrsities that are resilient to magyck in the desert."
	outfit = /datum/outfit/job/roguetown/mercenary/desert_rider_sahir
	traits_applied = list(TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_SPD = 1,
		STATKEY_WIL = 2,
		STATKEY_INT = 3,
		STATKEY_PER = 2
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 6, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/desert_rider_sahir/pre_equip(mob/living/carbon/human/H)
	..()

	// Gear - same as Almah but 1x blade + scholar's pouch
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/raneshen
	neck = /obj/item/clothing/neck/roguetown/gorget/copper
	mask = /obj/item/clothing/mask/rogue/facemask/copper
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/raneshen
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
	gloves = /obj/item/clothing/gloves/roguetown/angle
	pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/raneshen
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal
	backr = /obj/item/storage/backpack/rogue/satchel/black
	beltl = /obj/item/rogueweapon/scabbard/sword
	beltr = /obj/item/rogueweapon/scabbard/sword
	r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
	l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife/idagger/navaja,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/clothing/neck/roguetown/shalal,
		/obj/item/book/spellbook,
		/obj/item/flashlight/flare/torch,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)

	H.merctype = 4
