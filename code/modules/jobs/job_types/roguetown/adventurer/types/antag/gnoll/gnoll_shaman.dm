/datum/advclass/gnoll/shaman
	name = "Gnoll Shaman"
	tutorial = "Leader in faith, often the main source of wisdom within a gnoll pack. Few are closer to Graggar himself as you are. You may chose to waylay the hunt, in order to nurture fallen oppponents back to health, so they may grow stronger, providing a true challenge in a future fight."
	outfit = /datum/outfit/job/roguetown/gnoll/shaman
	traits_applied = list(TRAIT_RITUALIST, TRAIT_ALCHEMY_EXPERT)
	reset_stats = TRUE
	subclass_stats = list(
		// Weighted towards 16 currently. They don't get statpacks or racial stats, so we could consider this about 2 less at least, maybe 3. For about a 13.
		STATKEY_STR = 2,
		STATKEY_WIL = 2,
		STATKEY_SPD = 3,
		STATKEY_CON = 2,
		STATKEY_INT = 2
	)
	subclass_skills = list(
		/datum/skill/magic/holy = SKILL_LEVEL_MASTER,

		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,

		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,

		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,

		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/hunting = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT, // To give them more of a surgery capability
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_LEGENDARY,
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
		wrists = /obj/item/clothing/neck/roguetown/psicross/inhumen/graggar
		don_pelt(H)
		H.mind?.AddSpell(new /datum/action/cooldown/spell/convert_heretic/free)
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/self/claws/gnoll/shaman)
		H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/extract_heart) // Shamans had no real way to get hearts. This is very thematic.
		H.mind?.AddSpell(new /datum/action/cooldown/spell/gnoll/gnoll_battlecry)

/obj/item/clothing/suit/roguetown/armor/regenerating/skin/gnoll_armor/shaman
	icon_state = "shaman"

/obj/item/rogueweapon/werewolf_claw/gnoll/shaman
	name = "Shaman Claw"
	force = 25
	wdefense = 6
	/* 
	Shaman does 25 * 1.2 = 30 force with their base STR.
	*/
	possible_item_intents = list(/datum/intent/whip/punish, /datum/intent/effect/daze/shield, /datum/intent/mace/smash/werewolf/gnoll, /datum/intent/mace/strike/gnoll)

/obj/item/rogueweapon/werewolf_claw/gnoll/shaman/right
	icon_state = "claw_r"
	wlength = WLENGTH_SHORT

/obj/item/rogueweapon/werewolf_claw/gnoll/shaman/left
	icon_state = "claw_l"
	wlength = WLENGTH_SHORT
