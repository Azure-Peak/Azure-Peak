/datum/advclass/gnoll/knight
	name = "Gnoll Knight"
	tutorial = "You were forged in the fires of the volcano, burn marks have long since healed, but the armor hammered against your muscle isn't so fleeting."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/gnoll/knight
	category_tags = list(CTAG_GNOLL)
	traits_applied = list(TRAIT_HEAVYARMOR) // Flavoring
	
	cmode_music = 'sound/music/cmode/antag/combat_thewall.ogg'
	reset_stats = TRUE
	subclass_stats = list(
		STATKEY_WIL = 3,
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
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE
	)
	cmode_music = 'sound/music/combat_graggar.ogg'

/datum/outfit/job/roguetown/gnoll/knight/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/knight(H)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		don_pelt(H)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/knight
	icon_state = "knight"
	max_integrity = 800
	armor = ARMOR_GNOLL_STRONG
	// Stronger, so repair less armor when it repairs
	auto_repair_mode_base = 75
	relative_repair_interval = 25 SECONDS
