/datum/advclass/vagabond_deprived
	name = "Deprived"
	tutorial = "You have nothing left but your trusty shield and club - war took away everything you had but will you manage to reclaim what was yours or succumb to the horrors of Psydonia."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/vagabond/deprived
	category_tags = list(CTAG_VAGABOND)
	subclass_stats = list(
		STATKEY_LCK = 3
	)
	subclass_skills = list(
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/vagabond/deprived/pre_equip(mob/living/carbon/human/H)
	..()
	l_hand = /obj/item/rogueweapon/shield/wood
	r_hand = /obj/item/rogueweapon/mace/woodclub
	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else if(should_wear_masc_clothes(H))
		pants = /obj/item/clothing/under/roguetown/loincloth
	if(H.mind)
		SStreasury.give_money_account(ECONOMIC_DESTITUTE, H, "Savings.")
