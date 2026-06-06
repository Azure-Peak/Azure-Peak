/datum/advclass/gnoll/templar
	name = "Gnoll Templar"
	tutorial = "None are as valued to protect graggarite worship as his gnoll champions themselves."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/gnoll/templar
	category_tags = list(CTAG_GNOLL)
	traits_applied = list(TRAIT_HEAVYARMOR)
	reset_stats = TRUE
	subclass_stats = list(
		// Weighted towards 16 currently. They don't get statpacks or racial stats, so we could consider this about 2 less at least, maybe 3. For about a 13.
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
		STATKEY_SPD = 2,
		STATKEY_PER = 2,
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,

		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,

		/datum/skill/labor/butchering = SKILL_LEVEL_JOURNEYMAN,

		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/hunting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
	)
	cmode_music = 'sound/music/combat_graggar.ogg'

/datum/outfit/job/roguetown/gnoll/templar
	vamp_armor_type = /obj/item/clothing/suit/roguetown/armor/vampiric/gnoll/templar
	max_fury_stacks = 100
	shard_threshold = 40
	shard_repair_value = 16

/datum/outfit/job/roguetown/gnoll/templar/pre_equip(mob/living/carbon/human/H)
	if(H.mind)
		H.set_species(/datum/species/gnoll)
		H.skin_armor = new vamp_armor_type(H)
		H.AddComponent(/datum/component/vampiric_striker, shard_threshold, shard_repair_value, max_fury_stacks)
		neck = /obj/item/storage/belt/rogue/pouch
		wrists = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
		don_pelt(H)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/convert_heretic/free)
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/claws/gnoll/templar)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/gnoll/consume)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/gnoll/blood_rite)


/obj/item/rogueweapon/werewolf_claw/gnoll/templar
	name = "Templar Claw"
	wdefense = 6 // The Templar and the Berserker have the same parry capability due to skill difference.
	possible_item_intents = list(/datum/intent/simple/gnoll_cut, /datum/intent/mace/strike/gnoll, /datum/intent/mace/smash/werewolf/gnoll/templar, /datum/intent/spear/thrust)

/obj/item/rogueweapon/werewolf_claw/gnoll/templar/right
	icon_state = "claw_r"
	wlength = WLENGTH_SHORT

/obj/item/rogueweapon/werewolf_claw/gnoll/templar/left
	icon_state = "claw_l"
	wlength = WLENGTH_SHORT

/datum/intent/mace/smash/werewolf/gnoll/templar
	desc = "A powerful, smash of Gnoll muscle that deals normal damage but can throw a standing opponent back and slow them down, based on your strength. Ineffective below 10 strength. Slowdown & Knockback scales to your Strength up to 13 (1 - 3 tiles). Cannot be used consecutively more than every 5 seconds on the same target. Prone targets halve the knockback distance."
	maxrange = 3 // Templar and Knight gets 3 tiles if they are buffed, no more.
