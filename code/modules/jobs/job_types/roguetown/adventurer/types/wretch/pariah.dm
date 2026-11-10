// WOE: SPELLBLADE DODGE EXPERT POLEARM BUILD UPON YE.
/datum/advclass/wretch/pariah
	name = "Black Oaken Pariah"
	tutorial = "Carrying extreme beliefs not even befit of the Black Oaks, you have decided to secede yourself from the group and everyone else. This land was once great...and now, wave after wave of monsters and outsiders trample your home. Your people were the ones that settled these lands, and the foreign-backed Crown, deceitful and arrogant, has denied your people the rewards they deserve! Your extensive training in the Black Oaks has given you skill in both blades and magycks. A bounty from the crown follows you, as you had already done enough to be officially condemned by the group that was not committed to the cause due to the lure of coin."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_BLACKOAK)
	outfit = /datum/outfit/job/roguetown/wretch/pariah
	cmode_music = 'sound/music/combat_blackoak.ogg'
	maximum_possible_slots = 1
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_WRETCH)
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_ARCYNE, TRAIT_WOODWALKER, TRAIT_EXPERT_HUNTER)
	//lower-than-avg stats for wretch but their traits are insanely good
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = 1, // 7 Weight if we consider the added +1 when selecting armor.
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 5)
	subclass_languages = list(/datum/language/oldazurian)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT, //Why the fuck did the treeclimber role have worse skills than THE KNIGHTS?
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/hunting = SKILL_LEVEL_NOVICE,
	)
	subclass_stashed_items = list(
		"Sewing Kit" =	/obj/item/repair_kit,
		"Stashed Funds" = /obj/item/roguecoin/silver/pile/wretchpile,
	)
	extra_context = "This class is restricted to the Elf, Half-Elf, and Dark Elf species."


/datum/outfit/job/roguetown/wretch/pariah

/datum/outfit/job/roguetown/wretch/pariah/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hatanga
	pants = /obj/item/clothing/under/roguetown/trou/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/elvish
	backpack_contents = list(
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/reagent_containers/glass/bottle/alchemical/healthpot = 1,
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/chalk = 1,
		)

	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	var/spellblade_chant_selected = prompt_spellblade_choice(H, get_spellblade_chant_html(src, H, "blackoak"))
	var/datum/spellblade_chant/chant = GLOB.spellblade_chants[spellblade_chant_selected]
	chant.apply_chant(H)

	var/helmets = list(
		"Woad Elven Helm"			= /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm,
		"Woad Elven Barbute"		= /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/light,
		"Elven Barbute"				= /obj/item/clothing/head/roguetown/helmet/elvenbarbute/blackoak,
		"Winged Elven Barbute"		= /obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/blackoak,
	)
	var/helmchoice = input(H, "Choose your HELMET.", "LEAVES OVER STEEL.") as anything in helmets
	head = helmets[helmchoice]
	var/armor_style = list("Haste (Light Armor, +1 Spd)", "Heritage (Medium Armor, +1 Wil/Con)")
	var/armor_choice = input(H, "Choose your ARMOR.", "FOR THE OAKS AND THE PEAKS") as anything in armor_style
	switch(armor_choice)
		if("Haste (Light Armor, +1 Spd)")
			ADD_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			H.change_stat(STATKEY_SPD, 1)
			armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/elven
		if("Heritage (Medium Armor, +1 Wil/Con)")
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			H.change_stat(STATKEY_WIL, 1)
			H.change_stat(STATKEY_CON, 1)
			armor = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate


	// used to handle skill assignment automatically
	var/obj/item/rogueweapon/granted_weapon = null
	switch(spellblade_chant_selected)
		if("blade")
			var/weapons = list("Elvish Longsword", "Elvish sabre", "Elvish Curveblade", "Elvish Dirk")
			var/weapon_choice = input(H, "Choose your WEAPON.", "FOR THE OAKS AND THE PEAKS.") as anything in weapons
			switch(weapon_choice)
				if("Elvish Longsword")
					r_hand = granted_weapon = /obj/item/rogueweapon/sword/long/elvish
					beltr = /obj/item/rogueweapon/scabbard/sword
					backr = /obj/item/rogueweapon/shield/wood
				if("Elvish sabre")
					r_hand = granted_weapon = /obj/item/rogueweapon/sword/sabre/elf
					beltr = /obj/item/rogueweapon/scabbard/sword
					backr = /obj/item/rogueweapon/shield/wood
				if("Elvish Curveblade")
					r_hand = granted_weapon = /obj/item/rogueweapon/greatsword/elvish
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Elvish Dirk")
					r_hand = granted_weapon = /obj/item/rogueweapon/huntingknife/idagger/steel/elvish
					backr = /obj/item/rogueweapon/shield/wood
		if("phalangite")
			r_hand = granted_weapon = /obj/item/rogueweapon/halberd/glaive/elvish
			backr = /obj/item/rogueweapon/scabbard/gwstrap
		if("macebearer")
			backr = /obj/item/rogueweapon/shield/wood
			var/mace_weapons = list("Steel Mace", "Steel Warhammer", "Grand Mace", "Battle Axe", "Steel Greataxe")
			var/mace_choice = input(H, "Choose your WEAPON.", "FOR THE OAKS AND THE PEAKS.") as anything in mace_weapons
			switch(mace_choice)
				if("Steel Mace")
					r_hand = granted_weapon = /obj/item/rogueweapon/mace/steel
				if("Steel Warhammer")
					r_hand = granted_weapon = /obj/item/rogueweapon/mace/warhammer/steel
				if("Grand Mace")
					r_hand = granted_weapon = /obj/item/rogueweapon/mace/goden/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Battle Axe")
					r_hand = granted_weapon = /obj/item/rogueweapon/stoneaxe/battle
				if("Steel Greataxe")
					r_hand = granted_weapon = /obj/item/rogueweapon/greataxe/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
	if(granted_weapon)
		H.adjust_skillrank_up_to(granted_weapon::associated_skill, SKILL_LEVEL_EXPERT, TRUE)

	wretch_select_bounty(H)
