/datum/advclass/seamstress
	name = "Seamster"
	tutorial = "You know your trade by the passage of a needle through cloth and leather alike. Mend and sew garments for the townsfolk - Coats, pants, hats, hoods, and so much more. So what if you overcharge? You're the reason everyone looks good in the first place."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/seamstress
	traits_applied = list(TRAIT_SEWING_EXPERT)

	category_tags = list(CTAG_PILGRIM, CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_PER = 1,
		STATKEY_STR = -1
	)
	subclass_skills = list(
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)
	maximum_possible_slots = 20 // Should not fill, just a hack to make it shows what types of towners are in round

/datum/outfit/job/roguetown/adventurer/seamstress/pre_equip(mob/living/carbon/human/H)
	..()
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/raincloak/furcloak
	armor = /obj/item/clothing/suit/roguetown/armor/armordress
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/white
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/cloth/lady
	beltl = /obj/item/needle
	beltr = /obj/item/rogueweapon/huntingknife/scissors
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
						/obj/item/natural/cloth = 2,
						/obj/item/natural/bundle/fibers/full = 1,
						/obj/item/flashlight/flare/torch = 1,
						/obj/item/needle/thorn = 1,
						/obj/item/recipe_book/sewing = 1,
						/obj/item/recipe_book/leatherworking = 1
						)
	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/fittedclothing)
		SStreasury.give_money_account(ECONOMIC_LOWER_MIDDLE_CLASS, H, "Savings.")
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/leather/unique/furlinedjacket)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/leather/unique/artipants)//Artificer
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/leather/unique/buckleshoes)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/leather/unique/winterjacket)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/leatherunique/gladsandals)
		H.mind.teach_crafting_recipe(/datum/crafting_recipe/roguetown/leather/unique/monkrobes)//Generic
//Seamster should get the local stuff, makes sense really.
		var/regions = list("The Familiar", "The Unfamiliar")
		var/regional_specilization = input(H, "Choose your specilization.", "TAKE UP NEEDLE") as anything in regions
		H.set_blindness(0)
		switch(regional_specilization)
			if("The Familiar")
				r_hand = /obj/item/book/granter/crafting_recipe/tailor/western
			if("The Unfamiliar")
				r_hand = /obj/item/book/granter/crafting_recipe/tailor/eastern
