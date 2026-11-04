/datum/advclass/wretch/ancient_spellblade
	name = "Unbound Ancient Azurcaephan"
	tutorial = "You were once an Azurcaephan - a Spellblade from aeons past, perhaps from even the day of Tarichea. You remember your chant, your oath, every move of your blade and the flow of the arcyne. Intellect and will, unlike most other skeletons. Yet, you are without a purpose, without a master. Why do you fight? You do not know. But fight you shall. The world sees you as an abomination. Seek your own path."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/wretch/ancient_spellblade
	class_select_category = CLASS_CAT_ACCURSED
	category_tags = list(CTAG_WRETCH)
	maximum_possible_slots = 2 // Two, so the gimmic isn't overdone. Keep in mind these are, very. very. strong.
	applies_post_equipment = TRUE
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_SHATTER_KILL, TRAIT_ARCYNE, TRAIT_SKELETAL_GIB_ON_DEATH, TRAIT_BLOODLOSS_IMMUNE)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
		STATKEY_SPD = -1,
		STATKEY_STR = -1,
		) // Weighted 3 - Loses str because Int makes sense for a caster. 0 CON for limb reattachment tradeoff.
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 5)
	subclass_skills = list(
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		//ex-servantry skills
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
	)
	tempo_capable = FALSE //already removed by being a skeleton, in case we add it to the UI in future.
	adv_stat_ceiling = list(STAT_INTELLIGENCE = 12, STAT_SPEED = 9, STAT_CONSTITUTION = 10, STAT_WILLPOWER = 12) //infinite fatigue + spellblade fuckery vs vamp
	extra_context = "This class is unable to be revived and all forms of death will gib you."

/datum/outfit/job/roguetown/wretch/ancient_spellblade

/datum/outfit/job/roguetown/wretch/ancient_spellblade/pre_equip(mob/living/carbon/human/H)
	..()

	H.become_skeleton()
	H.can_do_sex = FALSE
	change_origin(H, /datum/virtue/origin/unselectable/skeleton, "Legion")

	//no swift intent
	H.possible_rmb_intents = list(/datum/rmb_intent/feint,\
	/datum/rmb_intent/aimed,\
	/datum/rmb_intent/riposte,\
	/datum/rmb_intent/strong,\
	/datum/rmb_intent/weak)
	H.swap_rmb_intent(num=1)

	// Skeleton antag datum + patron (matching greater_skeleton setup)
	H.set_patron(/datum/patron/inhumen/zizo)
	if(H.mind)
		H.mind.add_antag_datum(new /datum/antagonist/skeleton())

	H.choose_name_popup("Ancient Azurcaephan")

	H.cmode_music = 'sound/music/combat_weird.ogg'

	// Equipment — gilbranze loadout matching lich skeleton spellblade
	belt = /obj/item/storage/belt/rogue/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy/chain
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich //Stands out
	backr = /obj/item/rogueweapon/shield/bronze/paalloy
	backl = /obj/item/storage/backpack/rogue/satchel

	H.taints_loot = TRUE //For that shitty-ass reanimated corpse gear look.

	// DO NOT GIVE THEM MAGE CHALK. This is a SKELETON. Please don't let them easily
	// grind the gameplay loop (without putting in the efforts/virtue to acquire a chalk)
	backpack_contents = list(
		/obj/item/rogueweapon/spellbook = 1,
		/obj/item/natural/feather = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy/rich = 1, //Hilarious
		)

	// Chant selection — uses undead faction for "MEMORIES" UI
	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	var/spellblade_chant_selected = prompt_spellblade_choice(H, get_spellblade_chant_html(src, H, "undead"))
	var/datum/spellblade_chant/chant = GLOB.spellblade_chants[spellblade_chant_selected]
	chant.apply_chant(H)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)

	H.adjust_blindness(-3)
	var/helmets = list(
		"Gilbranze Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/paalloy,
		"None",
	)
	var/helmchoice = input(H, "Choose your Helm.", "A VISAGE UNBOUND.") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]

	// used to handle skill assignment automatically
	var/obj/item/rogueweapon/granted_weapon = null
	switch(spellblade_chant_selected)
		if("blade")
			var/weapons = list("Ancient Khopesh", "Ancient Longsword", "Ancient Dagger")
			var/weapon_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
			switch(weapon_choice)
				if("Ancient Khopesh")
					beltr = granted_weapon = /obj/item/rogueweapon/sword/sabre/palloy
				if("Ancient Longsword")
					beltr = granted_weapon = /obj/item/rogueweapon/sword/long/palloy //role unique
				if("Ancient Dagger")
					beltr = granted_weapon = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
		if("phalangite")
			var/weapons = list("Ancient Spear", "Ancient Bardiche", "Dory")
			var/weapon_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
			switch(weapon_choice)
				if("Ancient Spear")
					r_hand = granted_weapon = /obj/item/rogueweapon/spear/paalloy
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Ancient Bardiche")
					r_hand = granted_weapon = /obj/item/rogueweapon/halberd/bardiche/paalloy
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Dory")
					r_hand = granted_weapon = /obj/item/rogueweapon/spear/spellblade
					backr = /obj/item/rogueweapon/shield/heater
		if("macebearer")
			var/weapons = list("Ancient Mace", "Ancient Warhammer", "Ancient Grand Mace", "Ancient Alloy Axe", "Steel Greataxe")
			var/weapon_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
			switch(weapon_choice)
				if("Ancient Mace")
					beltr = granted_weapon = /obj/item/rogueweapon/mace/steel/palloy
				if("Ancient Warhammer")
					beltr = granted_weapon = /obj/item/rogueweapon/mace/warhammer/steel/paalloy
				if("Ancient Grand Mace")
					r_hand = granted_weapon = /obj/item/rogueweapon/mace/goden/steel/paalloy
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Ancient Alloy Axe")
					beltr = granted_weapon = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
				if("Steel Greataxe")
					r_hand = granted_weapon = /obj/item/rogueweapon/greataxe/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
	if(granted_weapon)
		H.adjust_skillrank_up_to(granted_weapon::associated_skill, SKILL_LEVEL_EXPERT, TRUE)
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

	// Reorder undead eyes action to the end
	var/obj/item/organ/eyes/existing_eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if(existing_eyes)
		existing_eyes.Remove(H, TRUE)
		existing_eyes.Insert(H)

	H.energy = H.max_energy

	to_chat(H, span_danger("You are playing an Antagonist role. Your very existence is an abomination — everyone is justified in laying you down. You are an ancient warrior risen from death, not a comedic skeleton. Having fun with your character is encouraged, but do not use the role to grief or disregard the setting — play it with gravitas and create memorable moments. Failure to maintain High Roleplay standards may result in punishment."))
	H.select_skeleton_features()
