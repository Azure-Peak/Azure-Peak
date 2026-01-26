/datum/advclass/gnoll/berserker
	name = "Gnoll Berserker"
	tutorial = "You are a warrior feared for your brutality, dedicated to using your might for your own gain. Might equals right, and you are the reminder of such a saying."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/gnoll/berserker
	cmode_music = 'sound/music/combat_graggar.ogg'
	category_tags = list(CTAG_GNOLL)
	traits_applied = list()
	reset_stats = TRUE
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 2,
		STATKEY_WIL = 3,
		STATKEY_SPD = 4,
		STATKEY_INT = -3,
		STATKEY_PER = -1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE
	)

/datum/outfit/job/roguetown/gnoll/berserker/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor(H)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		don_pelt(H)
