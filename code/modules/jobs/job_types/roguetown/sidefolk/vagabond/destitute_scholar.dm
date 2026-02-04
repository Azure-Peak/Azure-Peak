/datum/advclass/vagabond_scholar
	name = "Destitute Scholar"
	tutorial = "Knowledge is often both a boon and a curse. Whatever you know has left you with little to your name but your wits, and even then..."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/scholar
	category_tags = list(CTAG_VAGABOND)
	traits_applied = list(TRAIT_CICERONE, TRAIT_SEEDKNOW)
	subclass_skills = list(
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
	)
	extra_context = "Contains randomized skills and stats."

/datum/outfit/job/roguetown/vagabond/scholar/pre_equip(mob/living/carbon/human/H)
	..()
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

	if(prob(33))
		cloak = /obj/item/clothing/cloak/half/brown
		gloves = /obj/item/clothing/gloves/roguetown/fingerless

	if(prob(10))
		r_hand = /obj/item/rogue/instrument/flute

	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_DESTITUTE, H, "Savings.")
		H.adjust_skillrank(/datum/skill/craft/alchemy, rand(1,4), TRUE)
		H.adjust_skillrank(/datum/skill/misc/medicine, rand(1,4), TRUE)
		H.adjust_skillrank(/datum/skill/misc/reading, rand(3,6), TRUE)
		H.STAINT = rand(8, 20)
		H.STACON = rand(5, 10)
