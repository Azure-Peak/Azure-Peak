
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
		/obj/item/scrying
		)

	ADD_TRAIT(H, TRAIT_SEEPRICES, "[type]")
	ADD_TRAIT(H, TRAIT_ARCYNE_T4, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_HEARTFELT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_INTELLECTUAL, TRAIT_GENERIC)
	H.adjust_skillrank(/datum/skill/misc/reading, 6, TRUE)
	H.adjust_skillrank(/datum/skill/craft/alchemy, 3, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/staves, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/riding, 1, TRUE)
	H.change_stat("strength", -1)
	H.change_stat("constitution", -1)
	H.change_stat("willpower", 2)
	H.change_stat("perception", 3)
	H.change_stat("intelligence", 5)
	if(H.mind)
		H?.mind.adjust_spellpoints(36)
	ADD_TRAIT(H, TRAIT_MAGEARMOR, TRAIT_GENERIC)
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
