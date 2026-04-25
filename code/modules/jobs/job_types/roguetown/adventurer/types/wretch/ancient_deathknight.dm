/datum/advclass/wretch/ancient_deathknight
	name = "Unbound Ancient Death Knight"
	tutorial = "You were once a Death Knight - a warrior risen from death to serve a master. How long you have been dead - you do not remember anymore. And you find yourself severed from any master's command. Why do you fight? Does it matter? All that you know is to move forward. The world sees you as an abomination. Seek your own path."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/ancient_deathknight
	class_select_category = CLASS_CAT_ACCURSED
	category_tags = list(CTAG_WRETCH)
	maximum_possible_slots = 2 // Two so that the gimmick isn't overdon
	applies_post_equipment = TRUE
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_CON = 0,
		STATKEY_WIL = 1,
		STATKEY_INT = -2, // Weighted 1. 0 CON for limb reattachment tradeoff.
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
	)

/datum/outfit/job/roguetown/wretch/ancient_deathknight/pre_equip(mob/living/carbon/human/H)
	..()

	H.become_skeleton()

	// Skeleton antag datum + patron (matching greater_skeleton setup)
	H.set_patron(/datum/patron/inhumen/zizo)
	if(H.mind)
		H.mind.add_antag_datum(new /datum/antagonist/skeleton())

	H.choose_name_popup("Unbound Ancient Death Knight")

	H.cmode_music = 'sound/music/combat_cult.ogg'

	// Equipment — gilbranze loadout matching lich skeleton death knight
	beltl = /obj/item/rogueweapon/scabbard/sword
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/platelegs/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	armor = /obj/item/clothing/suit/roguetown/armor/plate/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/plate/paalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	backr = /obj/item/storage/backpack/rogue/satchel

	H.adjust_blindness(-3)

	var/helmets = list(
		"Gilbranze Knight Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/paalloy,
	)
	var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]

	var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in list("Longsword", "Ancient Warhammer", "Halberd")
	switch(weapon_choice)
		if("Longsword")
			beltl = /obj/item/rogueweapon/scabbard/sword
			l_hand = /obj/item/rogueweapon/sword/long/death
			backl = /obj/item/rogueweapon/shield/tower/metal/palloy
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Ancient Warhammer")
			beltr = /obj/item/rogueweapon/mace/warhammer/steel/paalloy
			backl = /obj/item/rogueweapon/shield/tower/metal/palloy
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
		if("Halberd")
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			r_hand = /obj/item/rogueweapon/halberd
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/corroded = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/book/spellbook = 1,
	)

	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonemend)

	H.set_blindness(0)

	var/tabards = list("Black Tabard", "Black Jupon")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich

	H.energy = H.max_energy

	to_chat(H, span_danger("You are playing an Antagonist role. Your very existence is an abomination — everyone is justified in laying you down. You are an ancient warrior risen from death, not a comedic skeleton. Having fun with your character is encouraged, but do not use the role to grief or disregard the setting — play it with gravitas and create memorable moments. Failure to maintain High Roleplay standards may result in punishment."))
