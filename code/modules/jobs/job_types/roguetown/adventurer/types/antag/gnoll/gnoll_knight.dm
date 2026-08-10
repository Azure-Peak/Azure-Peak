/datum/advclass/gnoll/knight
	name = "Gnoll Knight"
	tutorial = "You were forged in the fires of the volcano, burn marks have long since healed, but the armor hammered against your muscle isn't so fleeting."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/gnoll/knight
	category_tags = list(CTAG_GNOLL)
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_UNCONVERTIBLE) // Flavoring
	
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	reset_stats = TRUE
	subclass_stats = list(
		STATKEY_WIL = 5,
		STATKEY_CON = 5,
		STATKEY_SPD = 2,
		STATKEY_INT = 1
	)
	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
	)
	cmode_music = 'sound/music/combat_graggar.ogg'

/datum/outfit/job/roguetown/gnoll/knight
	vamp_armor_type = /obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/knight
	max_fury_stacks = 100
	shard_threshold = 44
	shard_repair_value = 20

/datum/outfit/job/roguetown/gnoll/knight/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new vamp_armor_type(H)
		H.AddComponent(/datum/component/vampiric_striker, shard_threshold, shard_repair_value, max_fury_stacks)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		backr = /obj/item/storage/backpack/rogue/satchel/gnoll
		don_pelt(H)
