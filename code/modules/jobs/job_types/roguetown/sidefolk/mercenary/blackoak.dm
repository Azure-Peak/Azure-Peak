// Elven unique mercenary type; should be scary in a way solo but easy to kill with a group or bow.
/datum/advclass/mercenary/blackoak
	name = "Black Oaken Guardian"
	tutorial = "A shady guardian of the Black Oaks. Half mercenary band, half irregular militia fighting for control of their ancestral elven homeland of the Peaks. Thankfully, you are not here today to shed the blood of the Duke's men — unless someone pays you to..."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_BLACKOAK)
	outfit = /datum/outfit/job/roguetown/mercenary/blackoak
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_VANGUARD)
	cmode_music = 'sound/music/combat_blackoak.ogg'
	extra_context = "This class is restricted to the Elf, Half-Elf, and Dark Elf species."
	subclass_languages = list(/datum/language/oldazurian)
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_MEDIUMARMOR, TRAIT_WOODWALKER)
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
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/elvish
	beltr = /obj/item/flashlight/flare/torch
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hatanga
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
	var/weapon_choice = input(H, "Choose your WEAPON.", "FOR THE OAKS AND THE PEAKS.") as anything in weapons
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

/datum/advclass/mercenary/blackoak_ranger
	name = "Black Oaken Ranger"
	tutorial = "A shady ranger of the Black Oaks. Half mercenary band, half irregular militia fighting for control of their ancestral elven homeland of the Peaks. Thankfully, you are not here today to shed the blood of the Duke's men — unless someone pays you to..."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_BLACKOAK)
	outfit = /datum/outfit/job/roguetown/mercenary/blackoak_ranger
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_MARKSMAN)
	cmode_music = 'sound/music/combat_blackoak.ogg'
	subclass_languages = list(/datum/language/oldazurian)
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
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve/blackoak
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hatanga
	pants = /obj/item/clothing/under/roguetown/trou/leather
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch = 1,
		)
	H.merctype = 2

/datum/outfit/job/roguetown/mercenary/blackoak_ranger/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Elvish Dagger", "Elvish sabre", "Elvish Shortsword")
	var/weapon_choice = input(H, "Choose your WEAPON.", "FOR THE OAKS AND THE PEAKS.") as anything in weapons
	switch(weapon_choice)
		if("Elvish Dagger")
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/silver/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath, SLOT_BELT_R, TRUE)
		if("Elvish sabre")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE) //I think it will be fair for the silver and high defense
			H.put_in_hands(new /obj/item/rogueweapon/sword/sabre/elf)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
		if("Elvish Shortsword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE) //Still 4 defence, fair enough
			H.put_in_hands(new /obj/item/rogueweapon/sword/short/elvish)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
	var/armors = list("Woad Elven Maille", "Fur-Lined Trophy Robes")
	var/armor_choice = input(H, "Choose your ARMOR.", "THE FOREST CLOAKS YOU.") as anything in armors
	switch(armor_choice)
		if("Woad Elven Maille")
			REMOVE_TRAIT(H, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/elven_plate/light, SLOT_ARMOR, TRUE)
		if("Fur-Lined Trophy Robes")
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/elven, SLOT_ARMOR, TRUE)
	var/helmets = list("Woad Elven Barbute", "Elven Barbute", "Winged Elven Barbute")
	var/helmet_choice = input(H, "Choose your HELMET.", "LEAVES OVER STEEL.") as anything in helmets
	switch(helmet_choice)
		if("Woad Elven Barbute")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm/light, SLOT_HEAD, TRUE)
		if("Elven Barbute")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/elvenbarbute/blackoak, SLOT_HEAD, TRUE)
		if("Winged Elven Barbute")
			H.equip_to_slot_or_del(new /obj/item/clothing/head/roguetown/helmet/elvenbarbute/winged/blackoak, SLOT_HEAD, TRUE)

/datum/advclass/mercenary/blackoak_adept
	name = "Black Oaken Adept"
	tutorial = "A spellblade of the Black Oaks. Half mercenary band, half irregular militia fighting for control of their ancestral elven homeland of the Peaks. You have honed the ancient Azurean art of spellbladery - an art that is yours and your people's alone. Thankfully, you are not here today to shed the blood of the Duke's men - unless someone pays you to..."
	allowed_sexes = list(MALE, FEMALE)
	forbidden_races = list(RACES_BLACKOAK)
	outfit = /datum/outfit/job/roguetown/mercenary/blackoak_adept
	class_select_category = CLASS_CAT_RACIAL
	category_tags = list(CTAG_MERCENARY, CTAG_MERCPARTY_WARMAGE)
	cmode_music = 'sound/music/combat_blackoak.ogg'
	subclass_languages = list(/datum/language/oldazurian)
	class_select_category = CLASS_CAT_RACIAL
	traits_applied = list(TRAIT_AZURENATIVE, TRAIT_OUTDOORSMAN, TRAIT_BLACKOAK, TRAIT_ARCYNE, TRAIT_MEDIUMARMOR)
	subclass_stats = list(
		STATKEY_INT = 1,
		STATKEY_PER = 1,
		STATKEY_SPD = 2,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 5)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/tracking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/arcane = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/mercenary/blackoak_adept

/datum/outfit/job/roguetown/mercenary/blackoak_adept/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	head = /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm
	armor = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate
	shoes = /obj/item/clothing/shoes/roguetown/boots/elven_boots
	cloak = /obj/item/clothing/cloak/forrestercloak
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
	belt = /obj/item/storage/belt/rogue/leather/black
	backl = /obj/item/storage/backpack/rogue/satchel/black
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hatanga
	pants = /obj/item/clothing/under/roguetown/trou/leather
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/special
	backpack_contents = list(
		/obj/item/roguekey/mercenary = 1,
		/obj/item/storage/belt/rogue/pouch/coins/poor = 1,
		/obj/item/flashlight/flare/torch = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/rogueweapon/spellbook/greater = 1,
		/obj/item/chalk = 1,
		)

	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	var/spellblade_chant_selected = prompt_spellblade_choice(H, get_spellblade_chant_html(src, H, "blackoak"))
	var/datum/spellblade_chant/chant = GLOB.spellblade_chants[spellblade_chant_selected]
	chant.apply_chant(H)

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
	H.merctype = 2
