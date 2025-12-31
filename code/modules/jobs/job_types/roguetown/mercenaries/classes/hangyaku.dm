/datum/advclass/mercenary/hangyaku
	name = "Hangyaku-Kounen"
	tutorial = "Rebel. Outlaw. Failure. Once, you served the upper echelons of Kazengun society as more than just a 'knight'- you were a champion, a beacon of virtue, a legend in the making. Now you wander distant Psydonia, seeking a fresh start... or fresh coin, at least."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_NO_CONSTRUCT //do they have constructs in kazengun?
	outfit = /datum/outfit/job/roguetown/mercenary/hangyaku
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_NOBLE) //i hate nobles but it's thematic
	cmode_music = 'sound/music/combat_kazengite.ogg'
	maximum_possible_slots = 3
	subclass_stats = list(  // mounted knight, but slower.
		STATKEY_STR = 2,
		STATKEY_INT = 1,
		STATKEY_CON = 1,
		STATKEY_WIL = 1,
		STATKEY_PER = 2,
		STATKEY_SPD = -1
	)
	subclass_skills = list( //impressively limited in terms of what they can do. this is a wall that doesn't do much else.
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN, //doesn't do much, but they're meant to be noblemen.
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
	)
	extra_context = "This subclass is race-limited from: Constructs."

/datum/outfit/job/roguetown/mercenary/hangyaku/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	to_chat(H, span_warning("Rebel. Outlaw. Failure. Once, you served the upper echelons of Kazengun society as more than just a 'knight'- you were a champion, a beacon of virtue, a legend in the making. Now you wander distant Psydonia, seeking a fresh start... or fresh coin, at least."))
	head = /obj/item/clothing/head/roguetown/helmet/heavy/kabuto
	belt = /obj/item/storage/belt/rogue/leather/cloth
	neck = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun
	cloak = /obj/item/clothing/cloak/kazengun
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/kote
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		/obj/item/rogueweapon/scabbard/sheath/kazengun
		)
	H.merctype = 9

/datum/outfit/job/roguetown/mercenary/hangyaku/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Sword","Great Mace","Spear","Bow")
	var/weapon_choice = input(H, "Choose your weapon.", "WHEN STEEL MUST SPEAK...") as anything in weapons
	switch(weapon_choice)
		if("Sword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/long/kriegmesser/ssangsudo)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword/kazengun/noparry, SLOT_BELT_L, TRUE)	
		if("Great Mace")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/mace/goden/kanabo)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if("Spear")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/spear/naginata) 
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if("Bow")
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, SKILL_LEVEL_EXPERT, TRUE)
			H.put_in_hands(new /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve) 
			H.equip_to_slot_or_del(new /obj/item/quiver/arrows, SLOT_BELT_L, TRUE) 
	var/armors = list("Heavy Armor","Medium Armor")
	var/armor_choice = input(H, "Choose your armor.", "...THE TONGUE MUST STAY QUIET.") as anything in armors
	switch(armor_choice)
		if("Heavy Armor")
			ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/plate/full/samsibsa, SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk, SLOT_SHIRT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/chainlegs, SLOT_PANTS, TRUE)
		if("Medium Armor")
			ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/brigandine/haraate, SLOT_ARMOR, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/suit/roguetown/armor/gambeson/heavy, SLOT_SHIRT, TRUE)
			H.equip_to_slot_or_del(new /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun, SLOT_PANTS, TRUE)
			H.change_stat(STATKEY_SPD, 1) //+1 speed for taking the worse armor, which is identical to mounted knight, but with worse armor
	var/masks = list("Full Mask","Half-Mask")
	var/mask_choice = input(H, "Choose your mask.", "GREET THE SUN?") as anything in masks
	switch(mask_choice)
		if("Full Mask")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun/full, SLOT_WEAR_MASK, TRUE)
		if("Half-Mask")
			H.equip_to_slot_or_del(new /obj/item/clothing/mask/rogue/facemask/steel/kazengun, SLOT_WEAR_MASK, TRUE)

/datum/advclass/mercenary/chonin
	name = "Hangyaku-Chonin"
	tutorial = "Once, you were a farmer, a miner, a seamstress, a commoner. Now the sword is your plow and war your field. You’ve hammered your scythes into spears and recast your knives into swords. Past the door, your daimyo is calling - and destiny awaits."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = ALL //do they have constructs in kazengun?
	outfit = /datum/outfit/job/roguetown/mercenary/chonin
	subclass_languages = list(/datum/language/kazengunese)
	class_select_category = CLASS_CAT_KAZENGUN
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_DECEIVING_MEEKNESS, TRAIT_MEDIUMARMOR) //peasant levy turned mercenary. the underdog.
	cmode_music = 'sound/music/combat_kazengite.ogg'
	subclass_stats = list(  
		STATKEY_STR = 2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_PER = 1,
	)
	subclass_skills = list( 
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE, 
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN
	)

/datum/outfit/job/roguetown/mercenary/chonin/pre_equip(mob/living/carbon/human/H)
	..()
	H.adjust_blindness(-3)
	has_loadout = TRUE
	to_chat(H, span_warning("Once, you were a farmer, a miner, a seamstress, a commoner. Now the sword is your plow and war your field. You’ve hammered your scythes into spears and recast your knives into swords. Past the door, your daimyo is calling - and destiny awaits."))
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun
	head = /obj/item/clothing/head/roguetown/helmet/kettle/jingasa
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/haraate
	shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	gloves = /obj/item/clothing/gloves/roguetown/plate/kote
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/roguekey/mercenary,
		/obj/item/flashlight/flare/torch/lantern,
		/obj/item/storage/belt/rogue/pouch/coins/poor,
		)
	H.merctype = 9

/datum/outfit/job/roguetown/mercenary/chonin/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/trades = list("Town Physician","Farmer","Tailor","Laborer","Merchant","Levy") //JMAN COMBAT SKILLS... AND TOWNER TRADES. GOD I HOPE THIS ISN'T A TERRIBLE IDEA.
	var/trade_choice = input(H, "Choose your former trade.", "WHO ARE YOU?") as anything in trades
	switch(trade_choice)
		if("Town Physician") //alchemy and medicine. that's pretty strong as-is, so...
			ADD_TRAIT(H, TRAIT_MEDICINE_EXPERT, TRAIT_GENERIC)
			ADD_TRAIT(H, TRAIT_ALCHEMY_EXPERT, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/alchemy, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/medicine, SKILL_LEVEL_APPRENTICE, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/woodstaff/militia)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
		if("Farmer") //farming, cooking, butchery, fishing
			ADD_TRAIT(H, TRAIT_SURVIVAL_EXPERT, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/farming, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/cooking, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/fishing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/spear/militia)
		if("Tailor") // sewing/etc.
			ADD_TRAIT(H, TRAIT_SEWING_EXPERT, TRAIT_GENERIC)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sword, SLOT_BELT_R, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/sewing, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/tanning, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/butchering, SKILL_LEVEL_APPRENTICE, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/sword/falchion/militia)
		if("Laborer") //physical labor; smelting, pottery, mining. you'll have to get the smithing yourself.
			ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/smelting, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/ceramics, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/carpentry, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/craft/masonry, SKILL_LEVEL_APPRENTICE, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/labor/mining, SKILL_LEVEL_APPRENTICE, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/pick/militia/steel)
		if("Merchant") //the sneaky one.
			ADD_TRAIT(H, TRAIT_SEEPRICES, TRAIT_GENERIC)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/misc/sneaking, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.equip_to_slot_or_del(new /obj/item/storage/belt/rogue/pouch/coins/mid, SLOT_BELT_L, TRUE) 
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath/kazengun, SLOT_BELT_R, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun)
		if("Levy") //straight-up fighter. gets a naginata AND a tanto.
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/knives, SKILL_LEVEL_JOURNEYMAN, TRUE)
			H.put_in_hands(new /obj/item/rogueweapon/spear/naginata)
			H.put_in_hands(new /obj/item/rogueweapon/huntingknife/idagger/steel/kazengun)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_R, TRUE)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/sheath/kazengun, SLOT_BELT_R, TRUE)
