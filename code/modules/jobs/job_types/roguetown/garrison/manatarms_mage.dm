/datum/advclass/manorguard/mage
	name = "Magician-at-Arms"
	tutorial = "Those who seek to master the arcane arts know that it is primarily an art of destruction. \
	Most magicians wander around in Azuria, or take up a position in the cloistered environs of the University. \
	But occasionally, there are times where a Mage's service is required in defense of the realm. \
	And thus you serve and fight for the Duchy as a Magician-at-Arms, trading safety for the thrill of battle \
	and the certainty of salary. If the Steward pays you in time."
	outfit = /datum/outfit/job/roguetown/manorguard/mage
	category_tags = list(CTAG_MENATARMS)
	traits_applied = list(TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_PER = 2,
		STATKEY_SPD = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 1, "minor" = 2, "utilities" = 6, "ward" = TRUE)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/staves = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/magic/arcane = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/manorguard/mage/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
	pants = /obj/item/clothing/under/roguetown/tights/random
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	head = /obj/item/clothing/head/roguetown/roguehood
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/storage/magebag/associate
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/book/spellbook = 1,
		/obj/item/storage/keyring/manatarms = 1,
	)

	H.verbs |= /mob/proc/haltyell
	if(H.mind)
		var/implement_type = choose_implement(H, "lesser")
		if(implement_type)
			H.put_in_hands(new implement_type(H))
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
