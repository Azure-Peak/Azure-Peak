/datum/advclass/vagabond_wanted
	name = "Wanted"
	tutorial = "The long arm of the law reaches out for you - are you slippery enough to evade its grip this time, or is your head destined to end up in an Excidium's maw?"
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/vagabond/wanted
	category_tags = list(CTAG_VAGABOND)
	traits_applied = list(TRAIT_OUTLAW)
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_SPD = 2,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
	)
	extra_context = "This class starts with a bounty and cannot use miesters/excidiums. Luck is randomized. Max bounty level heretic/outlaw brands you."

/datum/outfit/job/roguetown/vagabond/wanted/pre_equip(mob/living/carbon/human/H)
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
	
	if(H.mind)
		H.change_stat(STATKEY_LCK, rand(-2, 2))
		if(!H.has_flaw(/datum/charflaw/wanted))
			vagabond_select_bounty(H)
		to_chat(H, span_notice("I'm on the run from the law, and there's a sum of mammons out on my head... better lay low."))
