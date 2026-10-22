/datum/advclass/mercenary/desert_rider_almah
	name = "Desert Rider Almah"
	tutorial = "You're an Almah - a blade dancer, trained in the arts of spellbladery, an art originating from Azurea in ancient time. Your people have refined spellbladery into an artform. They call you a bladedancer - for the beautiful, bloody tapestry of magycks and blade you weave out of your foes in battle."
	allowed_sexes = list(MALE, FEMALE)

	outfit = /datum/outfit/job/roguetown/mercenary/desert_rider_almah
	class_select_category = CLASS_CAT_RANESHENI
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_WARMAGE)
	cmode_music = 'sound/music/combat_desertrider.ogg'
	subclass_languages = list(/datum/language/raneshi)
	traits_applied = list(TRAIT_ARCYNE, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_SPD = 1, // Weighted 7. Swap str for spd
		STATKEY_INT = 1, // Weighted 7. But a very nice statblock
		STATKEY_PER = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 2, // With 2 Wil they should not be struggling
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 5)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/desert_rider_almah

/datum/outfit/job/roguetown/mercenary/desert_rider_almah/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	// Gear - mirrors Zeybek
	head = /obj/item/clothing/head/roguetown/helmet/sallet/raneshen
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
	wrists = /obj/item/clothing/wrists/roguetown/bracers/brigandine
	gloves = /obj/item/clothing/gloves/roguetown/chain
	pants = /obj/item/clothing/under/roguetown/brigandinelegs
	shoes = /obj/item/clothing/shoes/roguetown/shalal
	belt = /obj/item/storage/belt/rogue/leather/shalal
	backr = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/huntingknife/idagger/navaja,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/clothing/neck/roguetown/shalal,
		/obj/item/flashlight/flare/torch,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/spellbook/greater
		)

	// Spellblade chant selection - almah faction, blade choice is locked to shamshirs
	var/spellblade_chant_selected = prompt_spellblade_choice(H, get_spellblade_chant_html(src, H, "almah"))
	var/datum/spellblade_chant/chant = GLOB.spellblade_chants[spellblade_chant_selected]
	chant.apply_chant(H)

	var/obj/item/rogueweapon/granted_weapon = null
	switch(spellblade_chant_selected)
		if("blade")
			var/blade_weapons = list("Dual Shamshirs", "Shalal sabre & Shield")
			var/weapon_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in blade_weapons
			switch(weapon_choice)
				if("Dual Shamshirs")
					ADD_TRAIT(H, TRAIT_DUALWIELDER, TRAIT_GENERIC)
					r_hand = granted_weapon = /obj/item/rogueweapon/sword/sabre/shamshir
					l_hand = /obj/item/rogueweapon/sword/sabre/shamshir
					beltl = /obj/item/rogueweapon/scabbard/sword
					beltr = /obj/item/rogueweapon/scabbard/sword
				if("Shalal sabre & Shield")
					r_hand = granted_weapon = /obj/item/rogueweapon/sword/long/marlin
					beltr = /obj/item/rogueweapon/scabbard/sword
					backl = /obj/item/rogueweapon/shield/tower/raneshen
		if("phalangite")
			var/polearm_weapons = list("Spear", "Dory & Shield")
			var/polearm_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in polearm_weapons
			switch(polearm_choice)
				if("Spear")
					r_hand = granted_weapon = /obj/item/rogueweapon/spear
					backl = /obj/item/rogueweapon/scabbard/gwstrap
				if("Dory & Shield")
					r_hand = granted_weapon = /obj/item/rogueweapon/spear/spellblade
					backl = /obj/item/rogueweapon/shield/tower/raneshen
		if("macebearer")
			var/mace_weapons = list("Steel Mace", "Steel Warhammer & Shield", "Grand Mace", "Battle Axe", "Steel Greataxe")
			var/mace_choice = input(H, "Choose your weapon.", "TAKE UP ARMS") as anything in mace_weapons
			switch(mace_choice)
				if("Steel Mace")
					r_hand = granted_weapon = /obj/item/rogueweapon/mace/steel
				if("Steel Warhammer & Shield")
					r_hand = granted_weapon = /obj/item/rogueweapon/mace/warhammer/steel
					backl = /obj/item/rogueweapon/shield/tower/raneshen
				if("Grand Mace")
					r_hand = granted_weapon = /obj/item/rogueweapon/mace/goden/steel
					backl = /obj/item/rogueweapon/scabbard/gwstrap
				if("Battle Axe")
					r_hand = granted_weapon = /obj/item/rogueweapon/stoneaxe/battle
				if("Steel Greataxe")
					r_hand = granted_weapon = /obj/item/rogueweapon/greataxe/steel
					backl = /obj/item/rogueweapon/scabbard/gwstrap
	if(granted_weapon)
		H.adjust_skillrank_up_to(granted_weapon::associated_skill, SKILL_LEVEL_EXPERT, TRUE)

	H.merctype = 4
