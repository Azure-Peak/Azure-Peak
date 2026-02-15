
/datum/advclass/heartfelt/retinue/courtier
	name = "Heartfelt Courtier"
	tutorial = "You are a Courtier of Heartfelt, a respected noblewoman looking to impress your lover. \
	However, with the increase in banditry, necromancy, deadite risings, and increasing sea raider raids, there are rumors abound that Heartfelt is not what it used to be. \
	Travellers often warn of Heartfelt having fallen already, and words of secretive cultists isn't unheard of."
	allowed_sexes = list(FEMALE)
	allowed_races = RACES_NO_CONSTRUCT
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/courtier
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_COURT
	
// HIGH COURT - /ONE SLOT/ Roles that were previously in the Court, but moved here.

	traits_applied = list(TRAIT_SEEPRICES, TRAIT_NOBLE, TRAIT_NUTCRACKER, TRAIT_HEARTFELT)

	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
	/datum/skill/misc/stealing = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
	/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
	/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
	/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
	/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
	)



/datum/outfit/job/roguetown/heartfelt/retinue/courtier/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/circlet
	neck = /obj/item/storage/belt/rogue/pouch/coins/rich
	cloak = /obj/item/clothing/cloak/heartfelt
	shirt = /obj/item/clothing/suit/roguetown/shirt/dress/silkydress/random
	if(isdwarf(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress
	else
		if(prob(66))
			armor = /obj/item/clothing/suit/roguetown/armor/armordress/alt
		else
			armor = /obj/item/clothing/suit/roguetown/armor/armordress
	belt = /obj/item/storage/belt/rogue/leather/cloth/lady
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/huntingknife/idagger/silver
	id = /obj/item/clothing/ring/silver
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
	/obj/item/lockpickring/mundane = 1,
	/obj/item/reagent_containers/glass/bottle/rogue/elfred = 1,
	/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunsake = 1,
	)
