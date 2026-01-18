/datum/advclass/mercenary/forlorn
	name = "Forlorn Hope Mercenary"
	tutorial = "The Order of the Forlorn Hope, a order formed off the back of a Ranesheni slave revolt. Drawing from all walks of life, this mercenary company now takes ranks from both purchased and liberated slaves. Coin is power, and power is the path to freedom."
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	outfit = /datum/outfit/job/roguetown/mercenary/forlorn
	class_select_category = CLASS_CAT_RANESHENI
	min_pq = 2
	cmode_music = 'sound/music/combat_blackstar.ogg'
	subclass_languages = list(/datum/language/celestial)
	category_tags = list(CTAG_MERCENARY)
	traits_applied = list(TRAIT_NOPAINSTUN, TRAIT_CRITICAL_RESISTANCE) // We're going back to the original gimmick of Forlorn Hope, having Critical Resistance
	// Since we demoted them to light armor, I think it is fair they have access to expert weapons as that is also the unarmed barbarian gimmick
	// And unarmed now have weapons in AP's new meta. So nothing wrong with it.
	subclass_stats = list(
		STATKEY_WIL = 3,
		STATKEY_STR = 2,
		STATKEY_CON = 2
	)
	subclass_skills = list(
		/datum/skill/misc/swimming = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/crossbows = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,	// This was arguably the OG shield + 1hand weapon merc. If this is too much, we can cut it back again.
		// I don't want anyone to suffer FOMO because they picked another weapon choice. Therefore shield is no longer gated behind weapon choice
	)
	extra_context = "This subclass gains Expert skill in their weapon of choice."

/datum/outfit/job/roguetown/mercenary/forlorn/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots
	neck = /obj/item/clothing/neck/roguetown/gorget/forlorncollar
	head = /obj/item/clothing/head/roguetown/helmet/heavy/volfplate
	pants = /obj/item/clothing/under/roguetown/splintlegs		// They're brigandinejaks. ergo have them start w/the whole thing
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	wrists = /obj/item/clothing/wrists/roguetown/splintarms		// They're brigandinejaks. ergo have them start w/the whole thing
	belt = /obj/item/storage/belt/rogue/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife,
		/obj/item/roguekey/mercenary,
		/obj/item/rogueweapon/scabbard/sheath,
		/obj/item/storage/belt/rogue/pouch/coins/poor
		)
	H.merctype = 5

/datum/outfit/job/roguetown/mercenary/forlorn
	has_loadout = TRUE

/datum/outfit/job/roguetown/mercenary/forlorn/choose_loadout(mob/living/carbon/human/H)
	. = ..()
	var/weapons = list("Warhammer", // The OG
	"Militia Steel Warpick", // Militia / Peasant weapons to slay the oppressors
	"Maciejowski (Pair)",
	"Militia Spear",
	"Militia War Axe",
	"Militia Thresher",
	"Militia Goedendag (Pair)") // Any that scales off labor skill isn't included
	var/weapon_choice = input(H, "Choose your weapon.", "ARMS TO SLAY THE OPPRESSORS") as anything in weapons
	switch(weapon_choice)
		if("Warhammer")
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/mace/warhammer/steel, SLOT_BELT_L)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/heater, SLOT_BACK_L)
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT)
		if("Militia Steel Warpick")
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/pick/militia/steel, SLOT_BELT_L) // This is super good so you only get ONE
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/heater, SLOT_BACK_L)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT)
		if("Maciejowski (Pair)")
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/sword/falchion/militia, SLOT_BELT_L) // I think this is really mid one handed so they get two
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/sword/falchion/militia, SLOT_BELT_R)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/shield/heater, SLOT_BACK_L)
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT)
		if("Militia Spear")
			H.put_in_hands(new /obj/item/rogueweapon/spear/militia)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT)
		if("Militia War Axe")
			H.put_in_hands(new /obj/item/rogueweapon/greataxe/militia)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L)
			H.adjust_skillrank_up_to(/datum/skill/combat/axes, SKILL_LEVEL_EXPERT)
		if("Militia Thresher")
			H.put_in_hands(new /obj/item/rogueweapon/flail/peasantwarflail)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/scabbard/gwstrap, SLOT_BACK_L)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT)
		if("Militia Goedendag (Pair)")
			H.put_in_hands(new /obj/item/rogueweapon/woodstaff/militia)
			H.equip_to_slot_or_del(new /obj/item/rogueweapon/woodstaff/militia, SLOT_BACK_L)
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT)
