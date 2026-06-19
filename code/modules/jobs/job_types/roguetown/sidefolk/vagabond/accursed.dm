/datum/advclass/vagabond_accursed
	name = "The Accursed"
	tutorial = "Cursed by the wilds themselves — or by the god who rules them. You do not remember what you did to earn this fate, if anything at all. A hunter's patience, a farmer's grit, these are etched into your bones, but the face you wore before the first transformation has long since blurred."
	allowed_sexes = list(MALE, FEMALE)
	outfit = /datum/outfit/job/roguetown/vagabond/accursed
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	maximum_possible_slots = 2
	category_tags = list(CTAG_VAGABOND)
	subclass_stats = list(
		STATKEY_STR = -2,
		STATKEY_WIL = 2
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_APPRENTICE
	)
	extra_context = "Contains randomized skills and stats. Transforms into beast under moonlight."

/datum/outfit/job/roguetown/vagabond/accursed/pre_equip(mob/living/carbon/human/H)
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
	
	r_hand = /obj/item/rogueweapon/stoneaxe

	if(H.mind)
		if(!H.GetComponent(/datum/component/night_form))
			H.mind.AddComponent(/datum/component/night_form)
		H.adjust_skillrank(/datum/skill/labor/farming, rand(1,4), TRUE)
		H.adjust_skillrank(/datum/skill/labor/fishing, rand(1,4), TRUE)
		H.adjust_skillrank(/datum/skill/labor/butchering, rand(1,4), TRUE)
		H.adjust_skillrank(/datum/skill/craft/cooking, rand(1,4), TRUE)
		H.STAINT = rand(9, 12)
		H.STACON = rand(6, 13)
