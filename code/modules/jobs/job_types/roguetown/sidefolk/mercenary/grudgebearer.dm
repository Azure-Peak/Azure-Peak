//Dwarf-exclusive mercenary class with unique armor setups.
/datum/advclass/mercenary/grudgebearer
	name = "Grudgebearer Smith"
	tutorial = "Bound by eternal grudges of eons past that have not been forgotten, the Grudgebearers are left to wander the surface, as every other clan has a grudge against you, and you against them. This putrid swampland of a Duchy has also wronged you and your people, you care little for it. Coins are a means to an end -- something you can mine and forge yourself. Trinkets -- made by true smiths, now that will carry respect among your clan. However, such artifacts might not buy you food, or a roof."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/dwarf,
		/datum/species/dwarf/mountain
	)
	outfit = /datum/outfit/job/roguetown/mercenary/grudgebearer
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_dwarf.ogg'
	extra_context = "This subclass is race-limited to: Dwarves."
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT) // Another one off exception for a combat role
	subclass_stats = list(
		STATKEY_INT = 3,
		STATKEY_WIL = 3,
		STATKEY_PER = 3,//Anvil"Strikes deftly" is based on PER
		STATKEY_STR = 1,
		STATKEY_SPD = -2
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_EXPERT,	//Shouldn't be better than the smith (though the stats are already)
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	)

//Because the armor is race-exclusive for repairs, these guys *should* be able to repair their own guys armor layers. A Dwarf smith isn't guaranteed, after all.
/datum/outfit/job/roguetown/mercenary/grudgebearer/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		shoes = /obj/item/clothing/shoes/roguetown/boots/armor/dwarven
		cloak = /obj/item/clothing/cloak/forrestercloak/snow
		belt = /obj/item/storage/belt/rogue/leather/black
		beltr = /obj/item/rogueweapon/mace
		beltl = /obj/item/flashlight/flare/torch
		backl = /obj/item/storage/backpack/rogue/backpack
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		gloves = /obj/item/clothing/gloves/roguetown/plate/dwarven
		pants = /obj/item/clothing/under/roguetown/trou/leather
		armor = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/smith
		head = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith
		backpack_contents = list(
			/obj/item/roguekey/mercenary,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/hammer/iron,
			/obj/item/paper/scroll/grudge,
			/obj/item/natural/feather,
			/obj/item/rogueweapon/tongs = 1,
			)
		var/weapons = list("Grand Mace", "Spiked Maul")
		var/wepchoice = input("Choose your weapon", "Available weapons") as anything in weapons
		switch(wepchoice)
			if("Grand Mace")
				backr = /obj/item/rogueweapon/mace/goden/steel
			if("Spiked Maul")
				r_hand = /obj/item/rogueweapon/mace/maul/spiked
				backr = /obj/item/rogueweapon/scabbard/gwstrap
		H.merctype = 8

/datum/advclass/mercenary/grudgebearer/soldier
	name = "Grudgebearer Soldier"
	tutorial = "Bound by eternal grudges of eons past that have not been forgotten, the Grudgebearers are left to wander the surface, as every other clan has a grudge against you, and you against them. This putrid swampland of a Duchy has also wronged you and your people, you care little for it. Coins are a means to an end -- something you can mine and forge yourself. Trinkets -- made by true smiths, now that will carry respect among your clan. However, such artifacts might not buy you food, or a roof."
	outfit = /datum/outfit/job/roguetown/mercenary/grudgebearer_soldier
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_CON = 5,
		STATKEY_WIL = 4,
		STATKEY_STR = 2,
		STATKEY_SPD = -2
	)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,	//Only here so they'd be able to repair their own armor integrity
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	)
/datum/outfit/job/roguetown/mercenary/grudgebearer_soldier/pre_equip(mob/living/carbon/human/H)
	..()
	if(H.mind)
		shoes = /obj/item/clothing/shoes/roguetown/boots/armor/dwarven
		cloak = /obj/item/clothing/cloak/forrestercloak/snow
		belt = /obj/item/storage/belt/rogue/leather/black
		beltl = /obj/item/flashlight/flare/torch
		backl = /obj/item/storage/backpack/rogue/satchel
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
		gloves = /obj/item/clothing/gloves/roguetown/plate/dwarven
		pants = /obj/item/clothing/under/roguetown/trou/leather
		armor = /obj/item/clothing/suit/roguetown/armor/plate/full/dwarven
		head = /obj/item/clothing/head/roguetown/helmet/heavy/dwarven
		backpack_contents = list(
			/obj/item/roguekey/mercenary,
			/obj/item/storage/belt/rogue/pouch/coins/poor,
			/obj/item/rogueweapon/hammer/iron,
			/obj/item/paper/scroll/grudge,
			/obj/item/natural/feather,
			)
		if(H.mind)
			var/weapons = list("Axe", "Grand Mace", "Maul")
			var/wepchoice = input("Choose your weapon", "Available weapons") as anything in weapons
			switch(wepchoice)
				if("Axe")
					backr = /obj/item/rogueweapon/stoneaxe/battle
				if("Grand Mace")
					backr = /obj/item/rogueweapon/mace/goden/steel
				if("Maul")
					r_hand = /obj/item/rogueweapon/mace/maul/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
		H.merctype = 8


// Soldier: Full plate equivalent — ARMOR_PLATE with steel-tier integrity
/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven
	name = "grudgebearer dwarven plate"
	desc = "A sturdy set of dwarven plate armor, forged in the old ways. It cannot be worked on without intrinsic dwarven knowledge."
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon_state = "dwarfchest"
	item_state = "dwarfchest"
	armor = ARMOR_PLATE
	body_parts_covered = COVERAGE_ALL_BUT_HANDFEET
	max_integrity = ARMOR_INT_CHEST_PLATE_STEEL
	smelt_bar_num = 4

// Smith: Maille-tier protection, medium armor class
/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/smith
	name = "grudgebearer splint apron"
	desc = "A mixture of plate and maille, worn by dwarven smiths. It cannot be worked on without intrinsic dwarven knowledge."
	icon_state = "dsmithchest"
	item_state = "dsmithchest"
	armor = ARMOR_PLATE
	armor_class = ARMOR_CLASS_MEDIUM
	body_parts_covered = CHEST|GROIN|VITALS|LEGS
	max_integrity = ARMOR_INT_CHEST_MEDIUM_STEEL
	smelt_bar_num = 3

/obj/item/clothing/head/roguetown/helmet/heavy/dwarven
	name = "grudgebearer dwarven helm"
	desc = "A hardy dwarven helmet. It lets one's dwarvenly beard to poke out."
	body_parts_covered = (HEAD | MOUTH | NOSE | EYES | EARS | NECK)	//This specifically omits hair so you could hang your beard out of the helm
	armor = ARMOR_PLATE
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "dwarfhead"
	item_state = "dwarfhead"
	block2add = FOV_BEHIND
	stack_fovs = TRUE
	bloody_icon = 'icons/effects/blood64.dmi'
	smeltresult = /obj/item/ingot/steel
	max_integrity = ARMOR_INT_HELMET_HEAVY_STEEL
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith
	name = "grudgebearer smith helm"
	desc = "A hardy dwarven helmet. It lets one's dwarvenly beard to poke out. \
	This one is intended for the smiths of the clan. No less protective. All the more stylish."
	icon_state = "dsmithhead"
	item_state = "dsmithhead"

/obj/item/clothing/gloves/roguetown/plate/dwarven
	name = "grudgebearer dwarven gauntlets"
	desc = "Forged to fit the stubbiest of fingers."
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon_state = "dwarfhand"
	item_state = "dwarfhand"
	armor = ARMOR_PLATE
	max_integrity = ARMOR_INT_SIDE_STEEL

/obj/item/clothing/shoes/roguetown/boots/armor/dwarven
	name = "grudgebearer dwarven boots"
	desc = "Clatters mightily."
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon_state = "dwarfshoe"
	item_state = "dwarfshoe"
	armor = ARMOR_PLATE
	max_integrity = ARMOR_INT_SIDE_STEEL


