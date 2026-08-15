/datum/advclass/gnoll/shaman
	name = "Gnoll Shaman"
	tutorial = "Leader in faith, often the main source of wisdom within a gnoll pack. Few are closer to Graggar himself as you are. You may chose to waylay the hunt, in order to nurture fallen oppponents back to health, so they may grow stronger, providing a true challenge in a future fight."
	outfit = /datum/outfit/job/roguetown/gnoll/shaman
	traits_applied = list(TRAIT_RITUALIST, TRAIT_DODGEEXPERT, TRAIT_ALCHEMY_EXPERT, TRAIT_UNCONVERTIBLE, TRAIT_HALLOWED) // Surely this won't be broken.
	reset_stats = TRUE
	subclass_stats = list(
		STATKEY_PER = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 3,
		STATKEY_CON = 1,
		STATKEY_INT = 2
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,
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
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/hunting = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
	)
	category_tags = list(CTAG_GNOLL)
	cmode_music = 'sound/music/combat_graggar.ogg'

/datum/outfit/job/roguetown/gnoll/shaman
	vamp_armor_type = /obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/shaman
	max_fury_stacks = 79
	shard_threshold = 44
	shard_repair_value = 20

/datum/outfit/job/roguetown/gnoll/shaman/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new vamp_armor_type(H)
		H.AddComponent(/datum/component/vampiric_striker, shard_threshold, shard_repair_value, max_fury_stacks)
		var/obj/item/ritechalk/chalk = new /obj/item/ritechalk(H.loc)
		H.put_in_r_hand(chalk)
		neck = /obj/item/storage/belt/rogue/pouch/healing
		backr = /obj/item/storage/backpack/rogue/satchel/gnoll
		don_pelt(H)
		var/datum/devotion/C = new /datum/devotion(H, H.patron)
		C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MINOR, start_maxed = TRUE)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/convert_heretic)
		H.mind?.RemoveSpell(/datum/action/cooldown/spell/miracle/heal)
