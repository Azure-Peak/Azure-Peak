/datum/advclass/gnoll/berserker
	name = "Gnoll Berserker"
	tutorial = "You are a warrior feared for your brutality, dedicated to using your might for your own gain. Might equals right, and you are the reminder of such a saying."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/gnoll/berserker
	cmode_music = 'sound/music/combat_graggar.ogg'
	category_tags = list(CTAG_GNOLL)
	traits_applied = list(TRAIT_UNCONVERTIBLE)
	reset_stats = TRUE
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_CON = 3,
		STATKEY_WIL = 3,
		STATKEY_SPD = 3,
		STATKEY_INT = -3,
		STATKEY_PER = -1
	)
	// Messy butchers, alright hunters
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/gnoll/berserker/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new vamp_armor_type(H)
		H.AddComponent(/datum/component/vampiric_striker, shard_threshold, shard_repair_value, max_fury_stacks)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		backr = /obj/item/storage/backpack/rogue/satchel/gnoll
		don_pelt(H)
