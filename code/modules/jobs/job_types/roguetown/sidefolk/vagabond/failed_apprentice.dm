/datum/advclass/vagabond_mage
	name = "Exiled Apprentice"
	tutorial = "Your master found you talentless, and cast you from their tower with nothing but your staff and dreams of what could've been."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/mage
	traits_applied = list(TRAIT_MAGEARMOR, TRAIT_ARCYNE_T3, TRAIT_ALCHEMY_EXPERT)
	category_tags = list(CTAG_VAGABOND)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_CON = -2,
		STATKEY_WIL = -2,
		STATKEY_SPD = -1
	)
	subclass_spellpoints = 9
	subclass_skills = list(
		/datum/skill/magic/arcane = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/alchemy = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/vagabond/mage/pre_equip(mob/living/carbon/human/H)
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

	r_hand = /obj/item/rogueweapon/woodstaff

	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_DESTITUTE, H, "Savings.")
