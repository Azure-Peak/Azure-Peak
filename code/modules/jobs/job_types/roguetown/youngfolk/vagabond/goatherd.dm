/datum/advclass/vagabond_goatherd
	name = "Lone Goatherd"
	tutorial = "Having lost your idyllic pastoral existence, only a solitary member of your herd now remains as a reminder of what was. Is your sole charge a friend, or is it food? You decide."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/goatherd
	traits_applied = list(TRAIT_HOMESTEAD_EXPERT)
	category_tags = list(CTAG_VAGABOND)
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/goatmale/tame
	subclass_stats = list(
		STATKEY_WIL = 2,
		STATKEY_INT = -1,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/labor/farming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/vagabond/goatherd/pre_equip(mob/living/carbon/human/H)
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

/mob/living/simple_animal/hostile/retaliate/rogue/goat/tame/Initialize()
	..()
	tamed()
