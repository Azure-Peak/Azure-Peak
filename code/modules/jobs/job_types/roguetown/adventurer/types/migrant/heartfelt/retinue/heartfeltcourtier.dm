
/datum/advclass/heartfelt/retinue/courtier
	name = "Heartfelt Courtier"
	tutorial = "You are a Courtier of Heartfelt, a respected noblewoman looking to impress your lover. \
	Certain circumstances have compelled your Lord to visit the capital. Whether to request more aid for the borderlands against Aavnic raids, reconstruction, canal funding, or perhaps intrigue or a plot to finally seize the throne of Azuria, you have arrived here as part of their entourage."
	allowed_sexes = list(FEMALE)
	forbidden_races = list(RACES_CONSTRUCT RACES_DESPISED RACES_HEARTFELT)
	outfit = /datum/outfit/job/roguetown/heartfelt/retinue/courtier
	maximum_possible_slots = 1
	pickprob = 100
	category_tags = list(CTAG_HFT_RETINUE)
	class_select_category = CLASS_CAT_HFT_COURT
	vice_limits = list(/datum/charflaw/silverweakness)

// HIGH COURT - /ONE SLOT/ Roles that were previously in the Court, but moved here.

	traits_applied = list(TRAIT_SEEPRICES, TRAIT_NOBLE, TRAIT_NUTCRACKER, TRAIT_HEARTFELT)
	noble_rank = NOBLE_RANK_GENTRY

	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
		STATKEY_LCK = 5,
	)

	subclass_skills = list(
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
	belt = /obj/item/storage/belt/rogue/leather/cloth/upgraded/lady
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/silver
	id = /obj/item/clothing/ring/silver
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
	/obj/item/lockpickring/mundane = 1,
	/obj/item/reagent_containers/glass/bottle/rogue/elfred = 1,
	/obj/item/reagent_containers/glass/bottle/rogue/beer/kgunsake = 1,
	)
