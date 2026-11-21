/datum/advclass/vagabond_thrall
	name = "Abandoned Thrall"
	tutorial = "An unfortunate victim of a vampire attack, you were never much of anything in life... and with vampiric blood so thin you likely won't be much of anything in undeath."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/vagabond/thrall
	category_tags = list(CTAG_VAGABOND)
	maximum_possible_slots = 3
	subclass_stats = list(
		STATKEY_INT = -1,
		STATKEY_CON = -2,
		STATKEY_WIL = -2,
		STATKEY_SPD = 2,
		STATKEY_LCK = 1,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
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
		var/datum/antagonist/vampire/new_antag = new /datum/antagonist/vampire(/datum/clan/deject, FALSE, GENERATION_THINNERBLOOD)
		H.mind.add_antag_datum(new_antag)
		H.apply_status_effect(STATUS_EFFECT_VAMPIRE_SPAWN_PROTECTION)
		H.maxbloodpool = 560 // same volume as blood volume, sovl? additionally to limit the amount of time you can be under the sun while disguised
		H.set_bloodpool(67) // start relatively starved, so you have a reason to hunt
		to_chat(H, span_danger("By nature this is an inherently antagonistic vagabond subclass. You are not required to create conflict, but if you show your face in town you should expect problems. Your character should be aware that the consequence of getting found out is likely death, and you should roleplay this appropriately."))
