/datum/advclass/wretch/ancient_spellblade
	name = "Unbound Ancient Azurcaephan"
	tutorial = "You were once an Azurcaephan - a Spellblade from aeons past, perhaps from even the day of Tarichea. You remember your chant, your oath, every move of your blade and the flow of the arcyne. Intellect and will, unlike most other skeletons. Yet, you are without a purpose, without a master. Why do you fight? You do not know. But fight you shall. The world sees you as an abomination. Seek your own path."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/wretch/ancient_spellblade
	class_select_category = CLASS_CAT_ACCURSED
	category_tags = list(CTAG_WRETCH)
	maximum_possible_slots = 2 // Two so that the gimmick isn't overdone
	applies_post_equipment = TRUE
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_ARCYNE)
	subclass_stats = list(
		STATKEY_INT = 2,
		STATKEY_WIL = 2,
		STATKEY_CON = 0,
		STATKEY_PER = 1,
		STATKEY_STR = -1,
	 ) // Weighted 3 - Loses str because Int makes sense for a caster. 0 CON for limb reattachment tradeoff.
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4)
	subclass_skills = list(
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/wretch/ancient_spellblade
	var/subclass_selected

/datum/outfit/job/roguetown/wretch/ancient_spellblade/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/wretch/ancient_spellblade/pre_equip(mob/living/carbon/human/H)
	..()

	H.become_skeleton()

	// Skeleton antag datum + patron (matching greater_skeleton setup)
	H.set_patron(/datum/patron/inhumen/zizo)
	if(H.mind)
		H.mind.add_antag_datum(new /datum/antagonist/skeleton())

	H.choose_name_popup("Ancient Azurcaephan")

	H.cmode_music = 'sound/music/combat_cult.ogg'

	// Equipment — gilbranze loadout matching lich skeleton spellblade
	belt = /obj/item/storage/belt/rogue/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	mask = /obj/item/clothing/mask/rogue/ragmask/black
	backr = /obj/item/rogueweapon/shield/heater
	backl = /obj/item/storage/backpack/rogue/satchel

	// DO NOT GIVE THEM MAGE CHALK. This is a SKELETON. Don't let them
	// grind the gameplay loop (without putting in the efforts to acquire a chalk)
	backpack_contents = list(/obj/item/book/spellbook = 1)

	// Chant selection — uses undead faction for "MEMORIES" UI
	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "undead")
	H << browse(selection_html, "window=spellblade_chant;size=1300x1000")
	onclose(H, "spellblade_chant", src)

	var/open_time = world.time
	while(!subclass_selected && world.time - open_time < 5 MINUTES)
		stoplag(1)
	H << browse(null, "window=spellblade_chant")

	if(!subclass_selected)
		subclass_selected = "blade"

	var/datum/status_effect/buff/arcyne_momentum/momentum = H.apply_status_effect(/datum/status_effect/buff/arcyne_momentum)
	if(momentum)
		momentum.chant = subclass_selected

	if(H.mind)
		switch(subclass_selected)
			if("blade")
				H.mind.AddSpell(new /datum/action/cooldown/spell/caedo)
				H.mind.AddSpell(new /datum/action/cooldown/spell/air_strike)
				H.mind.AddSpell(new /datum/action/cooldown/spell/leyline_anchor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
				H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
				H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/kastvyl)
				H.mind.AddSpell(new /datum/action/cooldown/spell/tremor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
				H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)

		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/bonemend)

	H.adjust_blindness(-3)
	var/helmets = list(
		"Gilbranze Helmet"	= /obj/item/clothing/head/roguetown/helmet/heavy/paalloy,
		"None",
	)
	var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]

	switch(subclass_selected)
		if("blade")
			var/weapons = list("Ancient Khopesh", "Sabre", "Corroded Dagger")
			var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Ancient Khopesh")
					beltr = /obj/item/rogueweapon/sword/sabre/palloy
				if("Sabre")
					beltr = /obj/item/rogueweapon/sword/sabre
				if("Corroded Dagger")
					beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/corroded
			if(weapon_choice == "Corroded Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("phalangite")
			var/weapons = list("Ancient Spear", "Ancient Bardiche", "Dory")
			var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS") as anything in weapons
			switch(weapon_choice)
				if("Ancient Spear")
					r_hand = /obj/item/rogueweapon/spear/paalloy
				if("Ancient Bardiche")
					r_hand = /obj/item/rogueweapon/halberd/bardiche/paalloy
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Dory")
					r_hand = /obj/item/rogueweapon/spear/spellblade
					backr = /obj/item/rogueweapon/shield/heater
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("macebearer")
			var/weapons = list("Ancient Mace", "Ancient Warhammer", "Ancient Grand Mace", "Ancient Alloy Axe", "Steel Greataxe")
			var/weapon_choice = input(H, "Choose your WEAPON.", "TAKE UP ARMS") as anything in weapons
			var/picked_axe = FALSE
			switch(weapon_choice)
				if("Ancient Mace")
					beltr = /obj/item/rogueweapon/mace/steel/palloy
				if("Ancient Warhammer")
					beltr = /obj/item/rogueweapon/mace/warhammer/steel/paalloy
				if("Ancient Grand Mace")
					r_hand = /obj/item/rogueweapon/mace/goden/steel/paalloy
				if("Ancient Alloy Axe")
					beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
					picked_axe = TRUE
				if("Steel Greataxe")
					r_hand = /obj/item/rogueweapon/greataxe/steel
					picked_axe = TRUE
			if(picked_axe)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
	H.set_blindness(0)

	var/tabards = list("Black Tabard", "Black Jupon")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich

	// Reorder undead eyes action to the end
	var/obj/item/organ/eyes/existing_eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if(existing_eyes)
		existing_eyes.Remove(H, TRUE)
		existing_eyes.Insert(H)

	H.energy = H.max_energy

	to_chat(H, span_danger("You are playing an Antagonist role. Your very existence is an abomination — everyone is justified in laying you down. You are an ancient warrior risen from death, not a comedic skeleton. Having fun with your character is encouraged, but do not use the role to grief or disregard the setting — play it with gravitas and create memorable moments. Failure to maintain High Roleplay standards may result in punishment."))
	H.select_skeleton_features()
