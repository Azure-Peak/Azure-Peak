/datum/advclass/wretch/ancient_deathknight
	name = "Unbound Ancient Death Knight"
	tutorial = "You were once a Death Knight - a warrior risen from death to serve a master. How long you have been dead - you do not remember anymore. And you find yourself severed from any master's command. Why do you fight? Does it matter? All that you know is to move forward. The world sees you as an abomination. Seek your own path."
	allowed_sexes = list(MALE, FEMALE)
	
	outfit = /datum/outfit/job/roguetown/wretch/ancient_deathknight
	class_select_category = CLASS_CAT_ACCURSED
	category_tags = list(CTAG_WRETCH)
	maximum_possible_slots = 2 // Two so that the gimmick isn't overdone
	applies_post_equipment = TRUE
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_SHATTER_KILL, TRAIT_BLOODLOSS_IMMUNE, TRAIT_DUSTABLE)
	subclass_stats = list(
		STATKEY_STR = 2,
		STATKEY_WIL = 1,
		STATKEY_SPD = -1,
		STATKEY_INT = -2, // Weighted 1. 0 CON for limb reattachment tradeoff.
	)
	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
	)

	adv_stat_ceiling = list(STAT_INTELLIGENCE = 8, STAT_SPEED = 9, STAT_CONSTITUTION = 10, STAT_WILLPOWER = 12) //infinite fatigue + decent skills vs vamp
	extra_context = "This class is unable to be revived and all forms of death will dust you."

/datum/outfit/job/roguetown/wretch/ancient_deathknight/pre_equip(mob/living/carbon/human/H)
	..()

	H.become_skeleton()

	// Skeleton antag datum + patron (matching greater_skeleton setup)
	H.set_patron(/datum/patron/inhumen/zizo)
	if(H.mind)
		H.mind.add_antag_datum(new /datum/antagonist/skeleton())

	H.choose_name_popup("Unbound Ancient Death Knight")

	H.cmode_music = 'sound/music/combat_weird.ogg'

	// Equipment — gilbranze loadout loosely matching lich skeleton death knight/bulwark -> helm picks and stuff come later
	belt = /obj/item/storage/belt/rogue/leather/black
	pants = /obj/item/clothing/under/roguetown/platelegs/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/plate/paalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	backr = /obj/item/storage/backpack/rogue/satchel/black

	H.taints_loot = TRUE //For that shitty-ass reanimated corpse gear look.

	H.adjust_blindness(-3)

	var/helmets = list(
		"Gilbranze Knight Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/knight/paalloy,
		"Gilbranze Sayovard Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/guard/paalloy,
	)
	var/helmchoice = input(H, "Choose your Helm.", "A VISAGE UNBOUND.") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]

	var/armor_choice = input(H, "Choose your Armor.", "A BULWARK TO LAST FOREVER.") as anything in list("Halfplate", "Cuirass & Haulberk", "Heavy Haulberk")
	switch(armor_choice)
		if("Halfplate")
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
			armor = /obj/item/clothing/suit/roguetown/armor/plate/paalloy
			wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
		if("Cuirass & Haulberk")
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy
			wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
		if("Heavy Haulberk")
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy
			wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy/chain
			
	var/weapon_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in list("Longsword + Shield", "Ancient Greatsword", "Ancient Axe + Shield", "Ancient Mace + Shield", "Ancient Warhammer + Shield", "Bardiche", "Grand Mace")
	switch(weapon_choice)
		if("Longsword + Shield")
			beltl = /obj/item/rogueweapon/scabbard/sword
			l_hand = /obj/item/rogueweapon/sword/long/death
			backl = /obj/item/rogueweapon/shield/tower/metal/palloy
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Ancient Greatsword") //No Flameberge, go be a REAL death knight for that.
			r_hand = /obj/item/rogueweapon/greatsword/paalloy
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("Ancient Axe + Shield")
			beltl = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
			backl = /obj/item/rogueweapon/shield/tower/metal/palloy
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
		if("Ancient Mace + Shield")
			beltr = /obj/item/rogueweapon/mace/steel/palloy
			backl = /obj/item/rogueweapon/shield/tower/metal/palloy
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
		if("Ancient Warhammer + Shield")
			beltr = /obj/item/rogueweapon/mace/warhammer/steel/paalloy
			backl = /obj/item/rogueweapon/shield/tower/metal/palloy
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
		if("Bardiche")
			backl = /obj/item/rogueweapon/scabbard/gwstrap
			r_hand = /obj/item/rogueweapon/halberd/bardiche/paalloy
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("Grand Mace") //Arguably amongst the stronger picks.
			r_hand = /obj/item/rogueweapon/mace/goden/steel/paalloy
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/padagger = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/natural/feather = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 1, //Hilarious
	)

	if(H.mind)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)

	H.set_blindness(0)

	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/necro
		if("Black Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

	to_chat(H, span_danger("You are playing an Antagonist role. Your very existence is an abomination — everyone is justified in laying you down. You are an ancient warrior risen from death, not a comedic skeleton. Having fun with your character is encouraged, but do not use the role to grief or disregard the setting — play it with gravitas and create memorable moments. Failure to maintain High Roleplay standards may result in punishment."))
	H.select_skeleton_features()
