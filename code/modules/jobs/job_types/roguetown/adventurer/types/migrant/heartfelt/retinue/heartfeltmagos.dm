
/datum/advclass/heartfelt/retinue/magos
	name = "Heartfeltian Magos"
	tutorial = "You are the Magos of Heartfelt, renowned for your arcane knowledge. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/magos
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_COURT

// HIGH COURT - /ONE SLOT/ Roles that were previously in the Court, but moved here.


	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T4, TRAIT_INTELLECTUAL, TRAIT_SEEPRICES, TRAIT_ALCHEMY_EXPERT, TRAIT_HEARTFELT)
	subclass_stats = list(
		STATKEY_INT = 5,
		STATKEY_PER = 3,
		STATKEY_WIL = 2,
		STATKEY_STR = -1,
		STATKEY_CON = -1,
	)

	subclass_spellpoints = 36

	subclass_skills = list(
	/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
	/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/magic/arcane = SKILL_LEVEL_MASTER,
	/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/staves = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
	/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
	/datum/skill/combat/swords = SKILL_LEVEL_NOVICE,
	/datum/skill/combat/knives = SKILL_LEVEL_NOVICE,
	/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/medicine = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
	)



/datum/outfit/job/roguetown/heartfelt/retinue/magos/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/clothing/neck/roguetown/talkstone
	cloak = /obj/item/clothing/cloak/black_cloak
	armor = /obj/item/clothing/suit/roguetown/shirt/robe/black
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/storage/magebag/starter
	id = /obj/item/clothing/ring/gold
	r_hand = /obj/item/rogueweapon/woodstaff/ruby //Two Levels down from CW
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/poison,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpot,
		/obj/item/recipe_book/alchemy,
		/obj/item/roguegem/amethyst,
		/obj/item/spellbook_unfinished/pre_arcyne,
		/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne,
		/obj/item/scrying,
		/obj/item/storage/belt/rogue/pouch/coins/rich = 1,
		)
	if(H.age == AGE_OLD)
		H.adjust_skillrank(/datum/skill/magic/arcane, 1, TRUE)
		H.change_stat("speed", -1)
		H.change_stat("intelligence", 1)
		H.change_stat("perception", 1)
	if(H.mind)
		H?.mind.adjust_spellpoints(6)
	if(ishumannorthern(H))
		belt = /obj/item/storage/belt/rogue/leather/plaquegold
		cloak = null
		head = /obj/item/clothing/head/roguetown/wizhat
		armor = /obj/item/clothing/suit/roguetown/shirt/robe/wizard
		H.dna.species.soundpack_m = new /datum/voicepack/male/wizard()
