// Elven unique mercenary type; should be scary in a way solo but easy to kill with a group or bow.
/datum/advclass/mercenary/blackoak
	name = "Black Oak's Guardian"
	tutorial = "A shady guardian of the Black Oaks. Half mercenary band, half irregular militia fighting for control of their ancestral elven homeland of the Peaks. Thankfully, you are not here today to shed the blood of the Duke's men — unless someone pays you to..."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(
		/datum/species/human/halfelf,
		/datum/species/elf/wood,
		/datum/species/elf/dark,
	)
	outfit = /datum/outfit/job/roguetown/mercenary/blackoak
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY)
	cmode_music = 'sound/music/combat_blackoak.ogg'
	extra_context = "This subclass is race-restricted to: Half-Elves, Elves, Dark Elves."
	subclass_languages = list(/datum/language/oldazurian)
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_STR = 3,
		STATKEY_WIL = 2,
		STATKEY_CON = 1,
		STATKEY_PER = 1,
		STATKEY_INT = -1
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/blackoak/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	head = /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm
	armor = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	beltr = /obj/item/flashlight/flare/torch
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		)
	H.merctype = 2

/datum/outfit/job/roguetown/mercenary/blackoak/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Elvish Glaive", "Elvish Curveblade", "Elvish Longsword")
	var/weapon_choice = input(H, "Choose your weapon.", "FOR THE OAKS AND THE PEAKS") as anything in weapons
	switch(weapon_choice)
		if("Elvish Glaive")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/halberd/glaive/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if("Elvish Curveblade")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/greatsword/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if("Elvish Longsword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BACK_R, TRUE)

/datum/advclass/mercenary/blackoak/ranger
	name = "Black Oak's Ranger"
	tutorial = "A shady ranger of the Black Oaks. Half mercenary band, half irregular militia fighting for control of their ancestral elven homeland of the Peaks. Thankfully, you are not here today to shed the blood of the Duke's men — unless someone pays you to..."
	outfit = /datum/outfit/job/roguetown/mercenary/blackoak_ranger
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_DODGEEXPERT, TRAIT_WOODWALKER)
	subclass_stats = list(
		STATKEY_SPD = 3,
		STATKEY_WIL = 2,
		STATKEY_PER = 2,
		STATKEY_CON = -1
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_MASTER,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/sneaking = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/blackoak_ranger/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	beltl = /obj/item/quiver/arrows
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/huntingknife = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch = 1,
		)
	H.merctype = 2

/datum/outfit/job/roguetown/mercenary/blackoak_ranger/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Elvish Dagger", "Elvish Saber", "Elvish Shortsword")
	var/weapon_choice = input(H, "Choose your weapon.", "FOR THE OAKS AND THE PEAKS") as anything in weapons
	switch(weapon_choice)
		if("Elvish Dagger")
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/silver/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_R, TRUE)
		if("Elvish Saber")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE) //I think it will be fair for the silver and high defense
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/elf)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
		if("Elvish Shortsword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE) //Still 4 defence, fair enough
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
	var/armors = list("Trophy Fur Robes", "Elven Cuirass")
	var/armor_choice = input(H, "Choose your armor.", "THE FOREST CLOAKS YOU") as anything in armors
	switch(armor_choice)
		if("Trophy Fur Robes")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/trophyfur, SLOT_ARMOR, TRUE)
		if("Elven Cuirass")
			REMOVE_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/cuirass/fencer/elven, SLOT_ARMOR, TRUE)
	var/helmets = list("Elven Barbute", "Winged Elven Barbute")
	var/helmet_choice = input(H, "Choose your helmet.", "LEAVES OVER STEEL") as anything in helmets
	switch(helmet_choice)
		if("Elven Barbute")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/elvenbarbute/blackoak, SLOT_HEAD, TRUE)
		if("Winged Elven Barbute")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/blackoak, SLOT_HEAD, TRUE)
