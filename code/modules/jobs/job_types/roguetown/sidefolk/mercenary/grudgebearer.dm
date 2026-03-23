//Dwarf-exclusive mercenary class with unique armor setups.
/datum/advclass/mercenary/grudgebearer
	name = "Isenban Smith"
	tutorial = "It is the Isenban that lead the vanguard when the Mountainhomes march to war. \
	You are the pride of your clan, armed and armored with the finest craftsmanship of its finest \
	smiths and sent far afield to gain experience in battle, and to accrue riches for your kin. \
	Despite this prestige, you have a ways still to go; you are only a smith, a junior member of \
	your clan's company, equipped with relatively light equipment and expected to help maintain the \
	arms and armor of your superiors. Fight with a stalwart spirit, serve with honor, and perhaps \
	one day you too will be entrusted with the greatest of your company's equipment."
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
	name = "Isenban Dreng"
	tutorial = "Dwarven steel is the envy of the world. You are a member of your clan's Isenban \
	company, a formation of professional warriors entrusted with the finest craftsmanship your clan \
	has to offer - and of your company you are among the finest equipped, having spent many years \
	in service as a smith to earn this honor. Until your kin have need of you, you travel through \
	foreign lands in service to men and elves and things further afield, accruing your fortune and \
	reputation as a mercenary beyond equal. Serve your employers with stalwart pride, do nothing \
	to dishonor your kin, and trust in the perfection of your arms to see you through any battle."
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


/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven
	name = "isenban plate"
	desc = "A standard, layered plate worn by many dwarven troops. It cannot be worked on without intrinsic dwarven knowledge."
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon_state = "dwarfchest"
	item_state = "dwarfchest"
	armor = ARMOR_GRUDGEBEARER
	prevent_crits = PREVENT_CRITS_NONE
	body_parts_covered = CHEST|GROIN|VITALS|ARMS|LEGS
	equip_delay_self = 5 SECONDS
	unequip_delay_self = 5 SECONDS
	equip_delay_other = 4 SECONDS
	strip_delay = 12 SECONDS
	smelt_bar_num = 4
	max_integrity = 1000	//They have their own unique integrity

/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/layeredarmor/grudgebearer)

/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/smith
	name = "isenban splint apron"
	desc = "A standard, layered mixture of plate and maille, worn by many dwarven smiths. \
	It cannot be worked on without intrinsic dwarven knowledge."
	icon_state = "dsmithchest"
	item_state = "dsmithchest"
	armor_class = ARMOR_CLASS_MEDIUM
	body_parts_covered = CHEST|GROIN|VITALS|LEGS
	smelt_bar_num = 3

/obj/item/clothing/head/roguetown/helmet/heavy/dwarven
	name = "isenban dwarven helm"
	desc = "A hardy, layered helmet. It lets one's dwarvenly beard to poke out."
	body_parts_covered = (HEAD | MOUTH | NOSE | EYES | EARS | NECK)	//This specifically omits hair so you could hang your beard out of the helm
	armor = ARMOR_GRUDGEBEARER
	prevent_crits = PREVENT_CRITS_NONE
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	icon_state = "dwarfhead"
	item_state = "dwarfhead"
	block2add = FOV_BEHIND
	stack_fovs = TRUE
	bloody_icon = 'icons/effects/blood64.dmi'
	smeltresult = /obj/item/ingot/steel
	max_integrity = 1000
	experimental_inhand = FALSE
	experimental_onhip = FALSE

/obj/item/clothing/head/roguetown/helmet/heavy/dwarven/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/layeredarmor/grudgebearer/helmet)

/obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith
	name = "isenban smith helm"
	desc = "'There hammer on the anvil smote, There chisel clove, and graver wrote; \
	There forged was blade, and bound was hilt; The delver mined, the mason built. \
	There beryl, pearl, and opal pale, And metal wrought like fishes' mail, Buckler \
	and corslet, axe and sword, And shining spears were laid in hoard.'"
	icon_state = "dsmithhead"
	item_state = "dsmithhead"

/obj/item/clothing/gloves/roguetown/plate/dwarven
	name = "isenban dwarven gauntlets"
	desc = "Finely sculpted gauntlets, composed of several carefully engineered layers of steel \
	shaped to the stout silhouette of a dwarf's hand."
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	prevent_crits = PREVENT_CRITS_NONE
	icon_state = "dwarfhand"
	item_state = "dwarfhand"
	armor = ARMOR_GRUDGEBEARER
	max_integrity = 1000

/obj/item/clothing/gloves/roguetown/plate/dwarven/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/layeredarmor/grudgebearer/limbs)

/obj/item/clothing/shoes/roguetown/boots/armor/dwarven
	name = "isenban dwarven boots"
	desc = "A pair of stout plate boots, perhaps two-thirds the length at the sole of any \
	such footwear designed for a humen. It is heavily padded on the interior for the wearer's \
	comfort; no self-respecting dwarf abides blisters while travelling through the mountains, \
	nor risks abandoning their plate while on the march."
	icon = 'icons/roguetown/clothing/special/race_armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/race_armor.dmi'
	allowed_race = list(/datum/species/dwarf, /datum/species/dwarf/mountain)
	prevent_crits = PREVENT_CRITS_NONE
	icon_state = "dwarfshoe"
	item_state = "dwarfshoe"
	armor = ARMOR_GRUDGEBEARER
	max_integrity = 1000

/obj/item/clothing/shoes/roguetown/boots/armor/dwarven/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/layeredarmor/grudgebearer/limbs)

/datum/component/layeredarmor/grudgebearer
	layer_repair = 2

	layer_max = list(
		"blunt" = 40,
		"slash" = 200,
		"stab" = 200,
		"piercing" = 100,
	)

	hits_to_shred = list(
		"blunt" = 3,
		"slash" = 3,
		"stab" = 3,
		"piercing" = 5,
	)

	damtype_shred_ratio = list(
		"blunt" = 1,
		"slash" = 1,
		"stab" = 1,
		"piercing" = 5,
	)

	hits_per_layer = list(
		"200"	= 3,
		"100" 	= 3,
		"90" 	= 3,
		"80" 	= 5,
		"70" 	= 5,
		"60" 	= 5,
		"50"	= 10,
		"40"	= 10,
		"30"	= 20,
		"20"	= 30,
		"10"	= 50,
	)

	repair_items = list(/obj/machinery/anvil)

	repair_skills = list(
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,
	)

	race_repair = list(
		/datum/species/dwarf,
		/datum/species/dwarf/mountain,
	)

/datum/component/layeredarmor/grudgebearer/helmet

/datum/component/layeredarmor/grudgebearer/limbs
	hits_to_shred = list(
		"blunt" = 2,
		"slash" = 2,
		"stab" = 2,
		"piercing" = 2,
	)

	layer_max = list(
		"blunt" = 40,
		"slash" = 200,
		"stab" = 200,
		"piercing" = 90,
	)

	hits_per_layer = list(
		"200"	= 2,
		"100" 	= 2,
		"90" 	= 2,
		"80" 	= 2,
		"70" 	= 2,
		"60" 	= 2,
		"50"	= 2,
		"40"	= 2,
		"30"	= 4,
		"20"	= 20,
		"10"	= 30,
	)

	shred_amt = 20	//Limbs lose 2 grades per layer shred, but also repair 4.
	layer_repair = 2


