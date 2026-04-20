//human master chef

/datum/advclass/masterchef
	name = "Master Chef"
	tutorial = "A master chef, one of the best cooks to ever live. \
	With noble origins, you were taught by cooking masters in the secretive League of Fine Dining in exotic meals from all around the world \
	Now you wander, free to experiment, cook exotic dishes and gourmet meals, worthy for a king"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/adventurer/masterchef
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)

	maximum_possible_slots = 1
	pickprob = 5
	category_tags = list(CTAG_TOWNER)
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_CON = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/cooking = SKILL_LEVEL_LEGENDARY,
	)

/datum/outfit/job/roguetown/adventurer/masterchef/pre_equip(mob/living/carbon/human/H)
	..()
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/tights/random
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/random
	cloak = /obj/item/clothing/cloak/apron
	head = /obj/item/clothing/head/roguetown/chef
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backl = /obj/item/storage/backpack/rogue/backpack
	neck = /obj/item/storage/belt/rogue/pouch/coins/mid
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	beltr = /obj/item/cooking/pan
	mouth = /obj/item/rogueweapon/huntingknife/chefknife/cleaver
	beltl = /obj/item/flint
	r_hand = /obj/item/flashlight/flare/torch
	var/packcontents = pickweight(list("Honey" = 1, "Truffles" = 1, "Bacon" = 1)) // What is our special ingredient? Honey, truffles, or BACON?
	switch(packcontents)
		if("Honey")
			backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/kitchen/spoon = 1,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/peppermill = 1,
				/obj/item/reagent_containers/powder/flour = 2,
				/obj/item/reagent_containers/food/snacks/rogue/honey/spider = 2,
				/obj/item/reagent_containers/powder/salt = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1,
				/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
				/obj/item/reagent_containers/food/snacks/rogue/handpie = 1,
				/obj/item/book/rogue/yeoldecookingmanual = 1,
				)
		if("Truffles")
			backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/kitchen/spoon = 1,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/peppermill = 1,
				/obj/item/reagent_containers/powder/flour = 2,
				/obj/item/reagent_containers/food/snacks/rogue/truffles = 2,
				/obj/item/reagent_containers/powder/salt = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1,
				/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
				/obj/item/reagent_containers/food/snacks/rogue/handpie = 1,
				/obj/item/book/rogue/yeoldecookingmanual = 1,
				)
		if("Bacon")
			backpack_contents = list(
				/obj/item/kitchen/rollingpin = 1,
				/obj/item/flint = 1,
				/obj/item/kitchen/spoon = 1,
				/obj/item/natural/cloth = 1,
				/obj/item/reagent_containers/peppermill = 1,
				/obj/item/reagent_containers/powder/flour = 2,
				/obj/item/reagent_containers/food/snacks/rogue/meat/bacon = 2,
				/obj/item/reagent_containers/powder/salt = 1,
				/obj/item/reagent_containers/food/snacks/butter = 1,
				/obj/item/reagent_containers/food/snacks/rogue/meat/salami = 1,
				/obj/item/reagent_containers/food/snacks/rogue/handpie = 1,
				/obj/item/book/rogue/yeoldecookingmanual = 1,
				)
