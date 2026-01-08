/datum/advclass/vagabond_original
	name = "The Vagabond"
	tutorial = "Fate's twists and turns lead many towards a wanderer's life. Find your fortunes in the shadows or in the pockets of another."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/original
	category_tags = list(CTAG_VAGABOND)
	subclass_stats = list(
		STATKEY_CON = -1,
		STATKEY_WIL = -1
	)
	subclass_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
	)
	extra_context = "FOR and INT are randomised."

/datum/outfit/job/roguetown/vagabond/original/pre_equip(mob/living/carbon/human/H)
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

	if (H.mind)
		H.STALUC = rand(5, 15)
		H.change_stat(STATKEY_INT, round(rand(-4,4)))

	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_DESTITUTE, H, "Savings.")
