/datum/advclass/gnoll/shaman
	name = "Gnoll Shaman"
	tutorial = "Leader in faith, often the main source of wisdom within a gnoll pack. Few are closer to Graggar himself as you are. You may chose to waylay the hunt, in order to nurture fallen oppponents back to health, so they may grow stronger, providing a true challenge in a future fight."
	outfit = /datum/outfit/job/roguetown/gnoll/shaman
	traits_applied = list(TRAIT_RITUALIST, TRAIT_DODGEEXPERT, TRAIT_ALCHEMY_EXPERT) // Surely this won't be broken.
	reset_stats = TRUE
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 3,
		STATKEY_INT = 2
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN
	)
	category_tags = list(CTAG_GNOLL)
	cmode_music = 'sound/music/combat_graggar.ogg'

/datum/outfit/job/roguetown/gnoll/shaman/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new /obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/shaman(H)
		var/obj/item/ritechalk/chalk = new /obj/item/ritechalk(H.loc)
		H.put_in_r_hand(chalk)
		neck = /obj/item/storage/belt/rogue/pouch/alchemy
		don_pelt(H)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/convert_heretic)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/shaman
	icon_state = "shaman"
	max_integrity = 400
	auto_repair_mode_base = 90
	armor = ARMOR_GNOLL_WEAK
