/*
LICH SKELETONS
*/


/datum/job/roguetown/greater_skeleton/lich
	title = "Fortified Skeleton"
	advclass_cat_rolls = list(CTAG_LSKELETON = 20)
	tutorial = "You are bygone. Your will belongs to your master. Fulfil and kill."

	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich
	vice_restrictions = list(/datum/charflaw/hunted, /datum/charflaw/targeted, /datum/charflaw/wanted)

/datum/outfit/job/roguetown/greater_skeleton/lich
	belt = /obj/item/storage/belt/rogue/leather/black

/datum/outfit/job/roguetown/greater_skeleton/lich/pre_equip(mob/living/carbon/human/H)
	..()
	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_LICHLAIR, TRAIT_GENERIC) //Ability to leave/enter the lich's lair without being softlocked inside.
	H.taints_loot = TRUE

// Melee goon w/ sidearm picks like javs/sling/knife/single use net. All-rounder.
/datum/advclass/greater_skeleton/lich/legionnaire
	name = "Ancient Legionnaire"
	tutorial = "A veteran lineman - oh, how far you've fallen. Your old King is dead, yet your vigil has not yet ended. Bring the fight to those who'd dare to impede your master's rule, with shield-and-sword alike."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/legionnaire

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/legionnaire/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 12
	H.STASPD = 8
	H.STACON = 9
	H.STAWIL = 12
	H.STAINT = 3
	H.STAPER = 11

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy

	backl = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(
		/obj/item/natural/feather = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 1 //Hilarious
	)

	H.adjust_blindness(-3)
	var/weapons = list("Gladius","Khopesh","Shortsword","Axe","Flail")
	var/weapon_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Gladius")
			beltr = /obj/item/rogueweapon/sword/short/gladius/pagladius
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Khopesh")
			beltr = /obj/item/rogueweapon/sword/sabre/palloy
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Shortsword")
			beltr = /obj/item/rogueweapon/sword/short/pashortsword
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Axe")
			beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
			H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
		if("Flail")
			beltr = /obj/item/rogueweapon/flail/sflail/paflail
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
	var/legionnairesidearm = list("A Javelin's Bag + Ancient Shield", "A Throwing Net + Ancient Shield", "A Sling With Decrepit Pellets + Wooden Shield", "An Ancient Dagger + Ancient Shield")
	var/legionnairesidearm_choice = input(H, "Choose your SYDEARM.", "RAGE AGAINST THE LYVING.") as anything in legionnairesidearm
	switch(legionnairesidearm_choice)
		if("A Javelin's Bag + Ancient Shield")
			beltl = /obj/item/quiver/javelin/paalloy
			backr = /obj/item/rogueweapon/shield/bronze/paalloy
		if("A Throwing Net + Ancient Shield")
			beltl = /obj/item/net
			backr = /obj/item/rogueweapon/shield/bronze/paalloy
		if("A Sling With Decrepit Pellets + Wooden Shield")
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, 2, TRUE) //Only apprentice, enough to be annoying
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			beltl = /obj/item/quiver/sling/aalloy //Decrepit vs ballistaires, weak but good for harrassment
			backr = /obj/item/rogueweapon/shield/wood //Weaker, go ballistaire for a good shield w/this
		if("An Ancient Dagger + Ancient Shield")
			beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
			backr = /obj/item/rogueweapon/shield/bronze/paalloy
	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak + Greathood", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/hoodlich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

// Ranged goon w/ a dumb bow. Ranger, what else is there to say.
/datum/advclass/greater_skeleton/lich/ballistiares
	name = "Ancient Ballistiares"
	tutorial = "Your frame has wept off your skin. Your fingers are mere peaks. Yet your aim remains true. Assail those who defy your master's command with bolt-and-arrow from afar - weather them down to the soil."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/ballistiares

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/ballistiares/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 10
	H.STASPD = 10
	H.STACON = 7
	H.STAWIL = 14
	H.STAINT = 6
	H.STAPER = 15

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/bows , 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/slings, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/kettle/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backl = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(
		/obj/item/natural/cloth = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 1 //Hilarious
	)
	H.adjust_blindness(-3)
	var/weapons = list("Bow & 20 Arrows", "Bow & 20 Broadheads", "Longbow & 20 Arrows", "Longbow & 20 Broadheads", "Crossbow & 16 Bolts", "Sling + Ancient Shield")
	var/weapon_choice = input(H, "Choose your MISSILE.", "CONDEMN THE LYVING FROM AFAR.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Bow & 20 Arrows")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			beltl = /obj/item/quiver/paalloy
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		if("Bow & 20 Broadheads")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			beltl = /obj/item/quiver/broadhead_aalloy
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		if("Longbow & 20 Arrows")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
			beltl = /obj/item/quiver/paalloy
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		if("Longbow & 20 Broadheads")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
			beltl = /obj/item/quiver/broadhead_aalloy
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		if("Crossbow & 16 Bolts")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/aalloy
			beltl = /obj/item/quiver/bolt/paalloy
			H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
		if("Sling + Ancient Shield")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			beltl = /obj/item/quiver/sling/paalloy
			H.adjust_skillrank(/datum/skill/combat/slings, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE) //Not enough to do shield specials w/knifepick or stabs, go legionnaire for that.
			backr = /obj/item/rogueweapon/shield/bronze/paalloy // the midground for less damage output w/more defensive value vs ranged in turn. Yes you can use the sling with it.
	var/tabards = list("Black Cloak + Greathood", "Black Jupon", "Black Tabard", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/hoodlich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

// Heavy/Tanky goon. Heavy armor but without an armaments rite, their skill is locked at journeyman. Death knights perform better than them and thus lich is encouraged to arm those first.
// This one specialises in 3 different playstyles (disiplines) which your statline changes around the weapon choice, all choices are intended to have a noticable flaw as these are disposable goons.
/datum/advclass/greater_skeleton/lich/bulwark
	name = "Ancient Death Bulwark"
	tutorial = "All throughout, you've borne the brunt. And even in death, will you continue. Shrug off terrible blows and deliver crushing sweeps with your greatweapons, in order to see your master's will done."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/bulwark

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/bulwark/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 11
	H.STASPD = 6
	H.STACON = 11
	H.STAWIL = 10
	H.STAINT = 1
	H.STAPER = 10

	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy //Intended as non-plate, stands out from knights this way.
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy
	neck = /obj/item/clothing/neck/roguetown/gorget/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy
	backl = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(
		/obj/item/natural/feather = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 1 //Hilarious
	)

	H.adjust_blindness(-3)
	var/weapons = list("Greatweapon - Greatsword, -2 CON / +2 STR / -1 SPD", "Greatweapon - Grand Mace, -3 CON / +2 STR / -1 SPD", "Pikeman - Spear, +1 STR", "Pikeman - Bardiche, +1 STR", "Shieldbearer - Mace + Shield, +3 WIL / -1 SPD", "Shieldbearer - Warhammer + Shield, +3 WIL / -1 SPD")
	var/weapon_choice = input(H, "Choose your DISCIPLINE.", "DEVASTATE THE LYVING UP CLOSE.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Greatweapon - Greatsword, -2 CON / +2 STR / -1 SPD") //Nasty Special, decent strength, slower, lower con.
			r_hand = /obj/item/rogueweapon/greatsword/paalloy
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE) //Tradeoff is no expert shield skill + -2 CON
			H.change_stat(STATKEY_CON, -2)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_SPD, -1)
		if("Greatweapon - Grand Mace, -3 CON / +2 STR / -1 SPD") //Hurts your stamina, bad. decent strength, slower, lowest con.
			r_hand = /obj/item/rogueweapon/mace/goden/steel/paalloy
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE) //Tradeoff is no expert shield skill + -3 CON
			H.change_stat(STATKEY_CON, -3)
			H.change_stat(STATKEY_STR, 2)
			H.change_stat(STATKEY_SPD, -1)
		if("Pikeman - Spear, +1 STR") //Pikeman is the inbetween of picks, slightly faster.
			r_hand = /obj/item/rogueweapon/spear/paalloy
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			H.change_stat(STATKEY_STR, 1)
		if("Pikeman - Bardiche, +1 STR")
			r_hand = /obj/item/rogueweapon/halberd/bardiche/paalloy
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
			H.change_stat(STATKEY_STR, 1)
		if("Shieldbearer - Mace + Shield, +3 WIL / -1 SPD") //Bulwark in the name, these guys are harder than legionarries to tire but they don't do as much damage and are much slower.
			r_hand = /obj/item/rogueweapon/mace/steel/palloy
			l_hand = /obj/item/rogueweapon/shield/tower/metal/palloy
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE) //Upto expert
			H.change_stat(STATKEY_WIL, 3)
			H.change_stat(STATKEY_SPD, -1)
		if("Shieldbearer - Warhammer + Shield, +3 WIL / -1 SPD")
			r_hand = /obj/item/rogueweapon/mace/warhammer/steel/paalloy
			l_hand = /obj/item/rogueweapon/shield/tower/metal/palloy
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE) //Upto expert
			H.change_stat(STATKEY_WIL, 3)
			H.change_stat(STATKEY_SPD, -1)
	var/armors = list("Sayovard + Cuirass & Hauberk", "Bascinet + Heavy Hauberk")
	var/armor_choice = input(H, "Choose your PLATE.", "SHRUG OFF THINE BLOWS.") as anything in armors
	switch(armor_choice)
		if("Sayovard + Cuirass & Hauberk")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/paalloy
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy
			wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy
		if("Bascinet + Heavy Hauberk")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/paalloy
			wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy/chain
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy
	var/tabards = list("Black Tabard", "Black Jupon", "Black Cloak + Greathood", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/hoodlich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

// Fragile Non-Combat crafter/demolishing artificer goon with a seige-use cavet. Worse weapons + very little armor but does base-building. Fortnite.
// Has a unique extra varient calcic outburst choice that destroys walls and does a huge amount of damage on exploding but takes 8 seconds to prime, on top of their regular varient. 
/datum/advclass/greater_skeleton/lich/sapper
	name = "Ancient 'Broken Bone' Sapper"
	tutorial = "Simple. Obedient. Like an ant in a colony. Toil, fortify, smelt, labor and destroy to the tune of your master's whims. After all; what good is an army if it hasn't a sword-nor-shield to wield?"
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/sapper

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/sapper/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 10
	H.STASPD = 10
	H.STACON = 5 //Low con so you can kill them quickly since they're literally wall-leveling bombs.
	H.STAWIL = 10
	H.STAINT = 6
	H.STAPER = 9

	//No medium armor because avantyne half-plate exists and we don't want legionarrie ++
	ADD_TRAIT(H, TRAIT_HOMESTEAD_EXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_SMITHING_EXPERT, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_TRAINED_SMITH, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)

	H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4))
	//For summoning rocks or whatever, or utility like mending/mindlink

	// Sapper-exclusive self-exploding spell
	H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/sapperbomb)

	H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

	H.adjust_skillrank(/datum/skill/misc/reading, 1, TRUE) //Just give them a little extra for utility.
	H.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE) //For making traps mostly, since they need it for crafting amythortz, remove if the recipes change.
	H.adjust_skillrank(/datum/skill/craft/alchemy, 2, TRUE) //For the alchemy mortar + pestle for explosives, remove once the recipe changes.
	H.adjust_skillrank(/datum/skill/craft/carpentry, 5, TRUE) //Good for planks, build fast.
	H.adjust_skillrank(/datum/skill/craft/masonry, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/traps, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/blacksmithing, 3, TRUE) //Nessessities to work these better than virtue.
	H.adjust_skillrank(/datum/skill/craft/armorsmithing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/smelting, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 4, TRUE) //Artificer construction specialist, keep higher
	H.adjust_skillrank(/datum/skill/labor/mining, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 6, TRUE) //Get up a deathfort, very fast by maximal yields from logs.

	head = /obj/item/clothing/head/roguetown/helmet/kettle/minershelm
	mask = /obj/item/clothing/mask/rogue/spectacles/golden //Structure inspection
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/artificer/lich
	pants = /obj/item/clothing/under/roguetown/trou/artipants/lich
	armor = /obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/lich
	gloves = /obj/item/clothing/gloves/roguetown/angle
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	backl = /obj/item/storage/backpack/rogue/backpack
	backpack_contents = list(
		/obj/item/rogueweapon/hammer/paalloy = 1,
		/obj/item/rogueweapon/tongs/paalloy = 1,
		/obj/item/rogueweapon/hammer/wood = 1,
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 1, //Hilarious
		/obj/item/rogueweapon/chisel = 1, //avoiding a dupe glitch I have no idea how to fix atm
		/obj/item/rogueweapon/handsaw/bronze = 1,
		/obj/item/dye_brush = 1
	)

	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
	beltl = /obj/item/rogueweapon/pick/paalloy

	H.adjust_blindness(-3)
	var/tabards = list("Black Cloak", "Black Jupon", "Black Tabard", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	H.set_blindness(0)
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak") //No hood because spectacles.
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

/////////////////////////////
// SPECIAL / LIMITED SLOTS //
/////////////////////////////
// Use this section to drop slot-limited subclasses.
// Below is an example. You can adjust how many instances of a subclass can exist on any given round by changing the number that's attached to the 'maximum_possible_slots' variable.

// Limited slot. Exclusive access to the Siegebow and slightly better melee skills, but worse speed.
/datum/advclass/greater_skeleton/lich/rareballistiares
	name = "Venerated Siege-Ballistiares"
	tutorial = "Few in number, yet known in presence. Fleshless palms cradle the pinnacle of siegebreakage; a massive weapon, capable of sundering all the walls-and-defenses that'd impede your master's path."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/rareballistiares
	maximum_possible_slots = 3 //Limited, but powerful.
	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/rareballistiares/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 12
	H.STASPD = 7
	H.STACON = 7
	H.STAWIL = 16
	H.STAINT = 6
	H.STAPER = 16

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/crossbows, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/slings, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 1, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 1, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/kettle/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy
	backl = /obj/item/storage/backpack/rogue/satchel

	l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy/paalloy
	beltl = /obj/item/quiver/bolt/heavy/paalloy

	backpack_contents = list(
		/obj/item/natural/cloth = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy = 1 //Hilarious
	)

	H.adjust_blindness(-3)
	var/weapons = list("Gladius", "Dagger")
	var/weapon_choice = input(H, "Choose your SIDEARM.", "BREAK THE CASTLES WHICH HIDE THE LYVING.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Gladius")
			beltr = /obj/item/rogueweapon/sword/short/gladius/pagladius
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Dagger")
			beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
			H.adjust_skillrank(/datum/skill/combat/knives, 1, TRUE)
	var/tabards = list("Black Cloak + Greathood", "Black Jupon", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/hoodlich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

//Stronger sidegrade of the Bulwark. Fully armored juggetnaut with high Intelligence and Perception for baiting and riposting, but extremely low Speed and complete inability to sprint at all. Crack open the armor, overwhelm and they're dead meat.
//They lack the easily ability to escape fights including no climbing skill, they're tough and will tire you very fast. They have good armor off-the-bat. They're sturdy and difficult to tire but archers/mages/swarms of people will hardcounter them in open ground.
/datum/advclass/greater_skeleton/lich/bulwarkrare
	name = "Venerated Death Knight"
	tutorial = "Swerve, parry, riposte. The wetness along your mortal wound has dried centuries ago, yet your wit remains unsullied in the slightest. Bring your master's chivalry to the battlefield, through both plate-and-blade."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/bulwarkrare
	maximum_possible_slots = 2 //Limited, but powerful. Could serve as either champions or commanders for the Lich's army.
	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/bulwarkrare/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 16 //Zizo's strongest skeleton
	H.STASPD = 5 //Slow as they come, lock in or get overwhelmed. Can't do much to dodgers. No ability to sprint
	H.STACON = 9 //Rugged, but no sprinting vs other skeles so they need some leeway
	H.STAWIL = 12 //Can't retreat, needs this to not die to stamchecks as easily
	H.STAINT = 14
	H.STAPER = 14

	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_STRENGTH_UNCAPPED, TRAIT_GENERIC) //Unique perk, you can splash out a TON of damage.
	ADD_TRAIT(H, TRAIT_NORUN, TRAIT_GENERIC) //You can't sprint at all, lock in. Mages/Archers will wipe you.

	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
	//Again, their flaw is inability to escape, no climbing here.

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/paalloy
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich //Felt sovlful
	armor = /obj/item/clothing/suit/roguetown/armor/plate/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy //So you can't just shatter them with a mace + fients super quickly, aim for the head
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	pants = /obj/item/clothing/under/roguetown/platelegs/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/plate/paalloy
	neck = /obj/item/clothing/neck/roguetown/gorget/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/paalloy
	backl = /obj/item/storage/backpack/rogue/satchel/black

	backpack_contents = list(
		/obj/item/natural/feather = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy/rich = 1 //Hilarious
	)

	H.adjust_blindness(-3)
	var/weapons = list("Flamberge", "Flail + Greatshield")
	var/weapon_choice = input(H, "Choose your GREATWEAPON.", "FELL THE CHAMPIONS OF THE LYVING.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Flamberge")
			r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge/paalloy //Distance and damage as well as crowd control with high strength.
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Flail + Greatshield")
			r_hand = /obj/item/rogueweapon/flail/sflail/paflail
			l_hand = /obj/item/rogueweapon/shield/bronze/great/paalloy //study, range resistance vs range to tradeoff for no reach + sweep.
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
	var/tabards = list("Black Tabard", "Black Jupon", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	if(H.mind) //2 slot, irreplacable skeletons.
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending) //Gets replaced w/weaker version w/rituos armor, balances out.
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonemend)

	H.energy = H.max_energy

// Spellblade skeleton. Rarest of the bunch - a true Azurcaephan from the ancient era.
// Medium armor, high INT, same chant/spells as regular spellblade. No miracles.
/datum/advclass/greater_skeleton/lich/spellblade
	name = "Venerated Azurcaephan"
	tutorial = "Swerve, parry, cast. Your bones have dried, and your flesh have withered. But your wits, and the flow of the arcyne remains untamed. Fuse gilbranze and sorcery, let the legends of the Azurcaephan be known again. Azurea, reborn in arcyne fyre! No! Tarichea! Tarichea! Tarichea! Long may she live! Long may she reign! Tarichea forevermore! My blade undulled, my chant unbroken, my wits untarnished!"
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/spellblade
	maximum_possible_slots = 1
	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/spellblade
	var/subclass_selected

/datum/outfit/job/roguetown/greater_skeleton/lich/spellblade/Topic(href, href_list)
	. = ..()
	if(href_list["subclass"])
		subclass_selected = href_list["subclass"]
	else if(href_list["close"])
		if(!subclass_selected)
			subclass_selected = "blade"

/datum/outfit/job/roguetown/greater_skeleton/lich/spellblade/pre_equip(mob/living/carbon/human/H)
	..()

	//1:1 almost w/unbound not including statpacks
	H.STASTR = 9
	H.STASPD = 9
	H.STACON = 10
	H.STAWIL = 12
	H.STAINT = 14
	H.STAPER = 12

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ARCYNE, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 3, TRUE) //A true Azurcaephan, they know their stuff.

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/paalloy
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich //Stands out
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy/chain
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy
	backr = /obj/item/rogueweapon/shield/bronze/paalloy
	backl = /obj/item/storage/backpack/rogue/satchel

	backpack_contents = list(
		/obj/item/natural/feather = 1, //For your helm
		/obj/item/storage/belt/rogue/pouch/coins/aalloy/rich = 1 //Hilarious
	)


	to_chat(H, span_warning("You start with Bind Weapon. Remember to Bind your weapon so you can use your abilities and build up Arcyne Momentum."))

	subclass_selected = null
	var/selection_html = get_spellblade_chant_html(src, H, "undead")
	H << browse(selection_html, "window=spellblade_chant;size=1100x900")
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
				H.mind.AddSpell(new /datum/action/cooldown/spell/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /datum/action/cooldown/spell/azurean_phalanx)
				H.mind.AddSpell(new /datum/action/cooldown/spell/projectile/azurean_pilum)
				H.mind.AddSpell(new /datum/action/cooldown/spell/advance)
				H.mind.AddSpell(new /datum/action/cooldown/spell/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/shatter)
				H.mind.AddSpell(new /datum/action/cooldown/spell/telegraphed_strike/spellblade/tremor)
				H.mind.AddSpell(new /datum/action/cooldown/spell/charge)
				H.mind.AddSpell(new /datum/action/cooldown/spell/cataclysm)

		H.mind.AddSpell(new /datum/action/cooldown/spell/recall_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/empower_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bind_weapon)
		H.mind.AddSpell(new /datum/action/cooldown/spell/mending)
		H.mind.AddSpell(new /datum/action/cooldown/spell/bonemend) //So you don't die from damaging yourself by your own gameplay loop.
		H.mind.setup_mage_aspects(list("mastery" = FALSE, "major" = 0, "minor" = 0, "utilities" = 4))

	H.adjust_blindness(-3)
	switch(subclass_selected)
		if("blade")
			var/weapons = list("Ancient Khopesh", "Ancient Dagger")
			var/weapon_choice = input(H, "Choose your BLADE.", "RAGE AGAINST THE LYVING.") as anything in weapons
			switch(weapon_choice)
				if("Ancient Khopesh")
					beltr = /obj/item/rogueweapon/sword/sabre/palloy
				if("Ancient Dagger")
					beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
			if(weapon_choice == "Ancient Dagger")
				H.adjust_skillrank_up_to(/datum/skill/combat/knives, 4, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/swords, 4, TRUE)
		if("phalangite")
			var/weapons = list("Ancient Spear", "Ancient Bardiche")
			var/weapon_choice = input(H, "Choose your SPEAR.", "RAGE AGAINST THE LYVING.") as anything in weapons
			switch(weapon_choice)
				if("Ancient Spear")
					r_hand = /obj/item/rogueweapon/spear/paalloy
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Ancient Bardiche")
					r_hand = /obj/item/rogueweapon/halberd/bardiche/paalloy
					backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("macebearer")
			var/weapons = list("Ancient Mace", "Ancient Warhammer", "Ancient Grand Mace", "Ancient Alloy Axe", "Steel Greataxe")
			var/weapon_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
			var/picked_axe = FALSE
			switch(weapon_choice)
				if("Ancient Mace")
					beltr = /obj/item/rogueweapon/mace/steel/palloy
				if("Ancient Warhammer")
					beltr = /obj/item/rogueweapon/mace/warhammer/steel/paalloy
				if("Ancient Grand Mace")
					r_hand = /obj/item/rogueweapon/mace/goden/steel/paalloy
					backr = /obj/item/rogueweapon/scabbard/gwstrap
				if("Ancient Alloy Axe")
					beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
					picked_axe = TRUE
				if("Steel Greataxe")
					r_hand = /obj/item/rogueweapon/greataxe/steel
					backr = /obj/item/rogueweapon/scabbard/gwstrap
					picked_axe = TRUE
			if(picked_axe)
				H.adjust_skillrank_up_to(/datum/skill/combat/axes, 4, TRUE)
			else
				H.adjust_skillrank_up_to(/datum/skill/combat/maces, 4, TRUE)
	H.set_blindness(0)

	// Hack for ordering
	H.mind.RemoveSpell(/obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	H.mind.AddSpell(/obj/effect/proc_holder/spell/self/suicidebomb/lesser)
	// Reorder undead eyes action to the end
	var/obj/item/organ/eyes/existing_eyes = H.getorganslot(ORGAN_SLOT_EYES)
	if(existing_eyes)
		existing_eyes.Remove(H, TRUE)
		existing_eyes.Insert(H)

	var/tabards = list("Black Tabard", "Black Jupon", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

/////////////////////////////
// UNIQUE ITEMS!           //
/////////////////////////////
/obj/item/clothing/suit/roguetown/armor/leather/jacket/artijacket/lich
	name = "decrepit sapper jacket"
	desc = "A jacket of rugged leather with some scraps of fur and roughspun fabrics from beyond your lyfetime, donned by those who are condemned to toil forevermore."
	color = "#d6bbbb"

/obj/item/clothing/under/roguetown/trou/artipants/lich
	name = "decrepit sapper trousers"
	desc = "A set of trousers of leathers and roughspun fabric from beyond your lyfetime, donned by those who are condemned to toil forevermore."

/obj/item/clothing/suit/roguetown/shirt/undershirt/artificer/lich
	name = "decrepit sapper shirt"
	desc = "A shirt of roughspun fabrics and leather from beyond your lyfetime, donned by those who are condemned to toil forevermore."
	color = "#d6bbbb"

/obj/item/clothing/head/roguetown/roguehood/shalal/hijab/lich
	name = "decrepit hijab"
	desc = "Roughspun fabrics from beyond your lyfetime, donned oft upon a helm by those who are condemned to march forevermore."
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/tabard/stabard/surcoat/lich
	name = "decrepit jupon"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who are condemned to march forevermore."
	color = CLOTHING_BLACK
	detail_tag = "_quad"
	detail_color = CLOTHING_BURLAP

/obj/item/clothing/cloak/tabard/lich
	name = "decrepit tabard"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who once knew of chivalry's allure."
	color = CLOTHING_BLACK
	detail_tag = "_quad"
	detail_color = CLOTHING_BURLAP

/obj/item/clothing/cloak/half/lich
	name = "decrepit cloak"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who fear what they've truly become."
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/tabard/toga/lich
	name = "decrepit toga"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who fight a war without reason."
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/tabard/toga/lich/alt
	name = "opened decrepit toga"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who fight a war without reason, parted to reveal what remains beneath its cloth."
	body_parts_covered = GROIN
	icon_state = "whitepsydontabardalt"
	item_state = "whitepsydontabardalt"
	flags_inv = HIDECROTCH
	open_wear = TRUE

/obj/item/clothing/cloak/tabard/toga/lich/attack_right(mob/user)
	switch(open_wear)
		if(FALSE)
			name = "opened decrepit toga"
			desc = "Roughspun fabrics from beyond your lyfetime, donned by those who fight a war without reason, parted to reveal what remains beneath its cloth."
			body_parts_covered = GROIN
			icon_state = "whitepsydontabardalt"
			item_state = "whitepsydontabardalt"
			open_wear = TRUE
			flags_inv = HIDECROTCH // BARE YOUR CHEST, NOT YOUR WEEN! Not urm, you have one, you're a fucking skeleton sire.
			to_chat(usr, span_warning("You pull back the roughspun fabric, baring what remains to Psydonia's eyes."))
		if(TRUE)
			name = "decrepit toga"
			desc = "Roughspun fabrics from beyond your lyfetime, donned by those who fight a war without reason.."
			body_parts_covered = CHEST|GROIN
			icon_state = "whitepsydontabard"
			item_state = "whitekpsydontabard"
			flags_inv = HIDECROTCH|HIDEBOOB
			open_wear = FALSE
			to_chat(usr, span_warning("You cloak yourself in the roughspun fabric, veiling what remains from Psydonia's eyes."))
	update_icon()
	if(user)
		if(ishuman(user))
			var/mob/living/carbon/H = user
			H.update_inv_cloak()
			H.update_inv_armor()

/obj/item/clothing/cloak/tabard/stabard/hoodlich
	name = "decrepit greathood"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who have reaped what they've sown."
	color = CLOTHING_BLACK
	detail_color = CLOTHING_BURLAP
	detail_tag = "_spl"
	slot_flags = ITEM_SLOT_HEAD|ITEM_SLOT_NECK|ITEM_SLOT_MASK|ITEM_SLOT_CLOAK
	icon_state = "guard_hood" // The same as the guard hood however to break it from using the lords colors it has been given its own item path
	item_state = "guard_hood"
	body_parts_covered = CHEST

/obj/item/rogueweapon/greatsword/grenz/flamberge/aalloy
	name = "decrepit flamberge"
	desc = "Tarnished bronze and decaying bogleather, meticulously woven together to fashion a flame-bladed swan song for Psydonia's final descendants. </br>'Oh, how valiant His sacrifice was! But now He lies, sleeping and witless to the world-anew.' </br>'And now, He sleeps. And now, He weeps.'"
	icon_state = "ancientflamb"
	smeltresult = /obj/item/ingot/aaslag
	max_integrity = 150
	force = 12 //Lower than one-handed zwei, higher than decrepit greatsword
	force_wielded = 28 //Slightly lower than zwei wielded, +3 over decrepit greatsword
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	smeltresult = /obj/item/ingot/aaslag
	anvilrepair = null
	randomize_blade_int_on_init = TRUE

/obj/item/rogueweapon/greatsword/grenz/flamberge/paalloy
	name = "ancient flamberge"
	desc = "Polished gilbranze and velvety saigaleather, masterfully bound together to hewn a greatsword of archaic opulance. One must remember that even the undying aren't consigned to the Archdevil's grasp; for those of true faith and nobleheartedness can persist in penitence."
	icon_state = "ancientflamb"
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/shield/tower/metal/great/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.6,"sx" = -5,"sy" = -1,"nx" = 6,"ny" = -1,"wx" = 0,"wy" = -2,"ex" = 0,"ey" = -2,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
			if("onback")
				return list("shrink" = 0.6,"sx" = 1,"sy" = 4,"nx" = 1,"ny" = 2,"wx" = 3,"wy" = 3,"ex" = -3,"ey" = 3,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 8,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 1,"southabove" = 0,"eastabove" = 0,"westabove" = 0)

/obj/item/rogueweapon/shield/bronze/great/paalloy
	name = "ancient greatshield"
	desc = "A heavy venerable shield, taller and thicker than most of their contemporaries, yet masterfully crafted O' so much more as well, rebuking arrow and bolt alyke \
	and yet it serves in a twisted change against its old purpose to preserve lyfe, it shall serve as a bulwark to herald the march of Her legionarries to end lyfe."
	icon_state = "ancientgreatshield"
	item_state = "ancientgreatshield"
	max_integrity = 400 //High integrity and passive projectile-blocking as a difficult to obtain usually role exclusive shield.
	force = 30
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/shield/bronze/great/aalloy
	name = "decrepit greatshield"
	desc = "A tarnished heavy once-venerable shield of fraying bronze. It has survived unspeakable calamities and eons, once rebuking arrow and bolt alyke; yet now its no better than \
	a battered hunk of metal with dents threatening to rip open. It failed its former owner and it won't be long until its own frail husk is reduced to nothing."
	icon_state = "ancientgreatshield"
	item_state = "ancientgreatshield"
	max_integrity = 180 //Generous integrity and passive projectile-blocking for a decrepit shield.
	force = 18
	coverage = 60
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	minstr = 13 //Requires a hefty natural +STR modifier and statpack/potions to double as a melee weapon (not you'd want to use it as one), for most classes. Note that it has a heavier charge time and active stamina drain, too, as.. well, it's quite heavy.
	smeltresult = /obj/item/ingot/aaslag

/obj/item/rogueweapon/shield/bronze/paalloy
	name = "ancient hoplon shield"
	desc = "The finest companion to a javelin and gladius, in Her name; a deceptively thin-yet-sturdy shield of gilbronze. This alloy even this thin, used to once surpass steel yet despite aeon's grip being lyfted, it never will regain its former strength."
	icon_state = "ancientlegionshield"
	force = 15
	throwforce = 25 // DO NOT GIVE ANYTHING; BUT TAKE FROM THEM.. EVERYTHING!
	minstr = 9 //Decently heavy to use as a melee weapon. But lighter due to thinner material.
	max_integrity = 180 //Intended to be weaker than the bronze shield, for balance reasonings but its cheaper than an iron shield ingot wise
	//for lore's sake its thinner than steel shields since it used to work as well since gilbranze was once stronger than steel, now its sort of worn its former durability away.

/obj/item/rogueweapon/shield/bronze/aalloy
	name = "decrepit hoplon shield"
	desc = "A near-paradoxally thin-yet-somehow-intact shield of fraying bronze, impossibly remaining barely intact; yet in spite of this, a mere press of the thumb alone will bend a dent into it irreversably."
	icon_state = "ancientlegionshield"
	force = 10
	throwforce = 8 // Its basically a chunk of crumbling metal
	blade_dulling = DULLING_SHAFT_CONJURED
	color = "#bb9696"
	coverage = 25
	minstr = 8 //Barely anything left of it sire.
	max_integrity = 60
