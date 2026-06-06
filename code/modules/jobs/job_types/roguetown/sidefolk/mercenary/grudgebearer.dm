//Dwarf-exclusive mercenary class with unique armor setups.
/datum/advclass/mercenary/grudgebearer
	name = "Grudgebearer Smith"
	tutorial = "Bound by eternal grudges of eons past that have not been forgotten, the Grudgebearers are left to wander the surface, as every other clan has a grudge against you, and you against them. This putrid swampland of a Duchy has also wronged you and your people, you care little for it. Coins are a means to an end -- something you can mine and forge yourself. Trinkets -- made by true smiths, now that will carry respect among your clan. However, such artifacts might not buy you food, or a roof."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_GRUDGE)
	outfit = /datum/outfit/job/roguetown/mercenary/grudgebearer
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_dwarf.ogg'
	extra_context = "This subclass is race-limited to: Dwarves."
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_TRAINED_SMITH, TRAIT_SMITHING_EXPERT) //Another one off exception for a combat role
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
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/smelting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/mercenary/grudgebearer/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/dwarven
	cloak = /obj/item/clothing/cloak/forrestercloak/snow
	belt = /obj/item/storage/belt/rogue/leather
	beltr = /obj/item/flashlight/flare/torch/lantern
	backl = /obj/item/storage/backpack/rogue/backpack
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers
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
		/obj/item/rogueweapon/tongs,
		)
	H.merctype = 8

/datum/outfit/job/roguetown/mercenary/grudgebearer/choose_loadout(mob/living/carbon/human/H)
    . = ..()
    var/weapons = list("Spiked Maul", "Grand Mace")
    var/weapon_choice = input(H, "Choose your WEAPON.", "FOR THE ANVIL AND THE CLAN.") as anything in weapons
    switch(weapon_choice)
        if("Spiked Maul")
            H.put_in_hands(new /obj/item/rogueweapon/mace/maul/spiked)
            H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
        if("Grand Mace")
            H.put_in_hands(new /obj/item/rogueweapon/mace/goden/steel)
            H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)

/datum/advclass/mercenary/grudgebearer_soldier
	name = "Grudgebearer Soldier"
	tutorial = "Bound by eternal grudges of eons past that have not been forgotten, the Grudgebearers are left to wander the surface, as every other clan has a grudge against you, and you against them. This putrid swampland of a Duchy has also wronged you and your people, you care little for it. Coins are a means to an end -- something you can mine and forge yourself. Trinkets -- made by true smiths, now that will carry respect among your clan. However, such artifacts might not buy you food, or a roof."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_GRUDGE)
	outfit = /datum/outfit/job/roguetown/mercenary/grudgebearer_soldier
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_dwarf.ogg'
	extra_context = "This subclass is race-limited to: Dwarves."
	traits_applied = list(TRAIT_HEAVYARMOR)
	subclass_stats = list(
		STATKEY_CON = 5,
		STATKEY_WIL = 4,
		STATKEY_STR = 2,
		STATKEY_SPD = -2
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,	//Only here so they'd be able to repair their own armor integrity
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/mercenary/grudgebearer_soldier/pre_equip(mob/living/carbon/human/H)
	..()
	has_loadout = TRUE
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/dwarven
	cloak = /obj/item/clothing/cloak/forrestercloak/snow
	belt = /obj/item/storage/belt/rogue/leather
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
	H.merctype = 8

/datum/outfit/job/roguetown/mercenary/grudgebearer_soldier/choose_loadout(mob/living/carbon/human/H)
    . = ..()
    var/weapons = list("Dwarven Warpick + Dwarven Shield", "Battle Axe + Dwarven Shield", "Flanged Mace + Dwarven Shield", "Dwarven Maul", "Grand Mace", "Great Axe")
    var/weapon_choice = input(H, "Choose your WEAPON.", "REPAY THE GRUDGE.") as anything in weapons
    switch(weapon_choice)
        if("Dwarven Warpick + Dwarven Shield")
            H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal/dwarf, SLOT_BACK_R, TRUE)
            H.put_in_hands(new /obj/item/rogueweapon/pick/militia/steel/warpick)
            H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
        if("Battle Axe + Dwarven Shield")
            H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal/dwarf, SLOT_BACK_R, TRUE)
            H.put_in_hands(new /obj/item/rogueweapon/stoneaxe/battle)
            H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
        if("Flanged Mace + Dwarven Shield")
            H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/tower/metal/dwarf, SLOT_BACK_R, TRUE)
            H.put_in_hands(new /obj/item/rogueweapon/mace/cudgel/flanged)
            H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
        if("Dwarven Maul")
            H.put_in_hands(new /obj/item/rogueweapon/mace/maul/steel)
            H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
            H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
        if("Grand Mace")
            H.put_in_hands(new /obj/item/rogueweapon/mace/goden/steel)
            H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
            H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
        if("Great Axe")
            H.put_in_hands(new /obj/item/rogueweapon/greataxe/steel)
            H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
            H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT, TRUE)
