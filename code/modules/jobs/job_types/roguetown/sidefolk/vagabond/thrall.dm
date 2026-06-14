/datum/advclass/vagabond_thrall
	name = "Abandoned Thrall"
	tutorial = "An unfortunate victim of a vampire attack, you were never much of anything in life... and with vampiric blood so thin you likely won't be much of anything in undeath."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/vagabond/thrall
	category_tags = list(CTAG_VAGABOND)
	traits_applied = list(TRAIT_SILVER_WEAK)
	maximum_possible_slots = 3
	subclass_stats = list(
		STATKEY_STR = -1,
		STATKEY_SPD = 2,
		STATKEY_CON = -2,
		STATKEY_INT = 1
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN
	)

/datum/outfit/job/roguetown/vagabond/thrall/pre_equip(mob/living/carbon/human/H)
	..()

	head = /obj/item/clothing/head/roguetown/roguehood
	
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
		H.job = "Stray" //Used for my shitcode job checks to remove certain vampire abilties, edited to make it not be obvious in the stewardry who is a vamp
		H.change_stat(STATKEY_WIL, rand(-2, 2))
		var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(generation = GENERATION_THINNERBLOOD)
		H.mind.add_antag_datum(new_antag)
		H.apply_status_effect(STATUS_EFFECT_VAMPIRE_SPAWN_PROTECTION)
		H.maxbloodpool = 1000
		H.set_bloodpool (750)
		to_chat(H, span_danger("By nature this is an inherently antagonistic vagabond subclass. You are not required to create conflict, but if you show your face in town you should expect problems. Your character should be aware that the consequence of getting found out is likely death, and you should roleplay this appropriately."))

