/*
LICH SKELETONS
*/


/datum/job/roguetown/greater_skeleton/lich
	title = "Fortified Skeleton"
	advclass_cat_rolls = list(CTAG_LSKELETON = 20)
	tutorial = "You are bygone. Your will belongs to your master. Fulfil and kill."

	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich

/datum/outfit/job/roguetown/greater_skeleton/lich
	belt = /obj/item/storage/belt/rogue/leather/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	backl = /obj/item/storage/backpack/rogue/satchel

/datum/outfit/job/roguetown/greater_skeleton/lich/pre_equip(mob/living/carbon/human/H)
	..()
	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

// Melee goon w/ javelins. All-rounder.
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
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy

	backr = /obj/item/rogueweapon/shield/wood
	beltl = /obj/item/quiver/javelin/paalloy
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
	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak + Greathood")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/guardhood/lich

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
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	beltr = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
	gloves = /obj/item/clothing/gloves/roguetown/angle
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/ammo_casing/caseless/rogue/heavy_bolt = 1
	)
	H.adjust_blindness(-3)
	var/weapons = list("Bow & 20 Arrows", "Longbow & 20 Arrows", "Crossbow & 16 Bolts", "Sling")
	var/weapon_choice = input(H, "Choose your MISSILE.", "CONDEMN THE LYVING FROM AFAR.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Bow & 20 Arrows")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
			beltl = /obj/item/quiver/paalloy
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		if("Longbow & 20 Arrows")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
			beltl = /obj/item/quiver/paalloy
			H.adjust_skillrank(/datum/skill/combat/bows, 1, TRUE)
		if("Crossbow & 16 Bolts")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
			beltl = /obj/item/quiver/bolt/paalloy
			H.adjust_skillrank(/datum/skill/combat/crossbows, 1, TRUE)
			if(prob(30))
				r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy/paalloy
		if("Sling")
			l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			beltl = /obj/item/quiver/sling/paalloy
			H.adjust_skillrank(/datum/skill/combat/slings, 1, TRUE)
	var/tabards = list("Black Cloak + Greathood", "Black Jupon", "Black Tabard")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/guardhood/lich

	H.energy = H.max_energy

// Heavy/Tanky goon. Not heavy armor but due to the steel + weapons they'll fare just fine.
/datum/advclass/greater_skeleton/lich/bulwark
	name = "Ancient Death Bulwark"
	tutorial = "All throughout, you've borne the brunt. And even in death, will you continue. Shrug off terrible blows and deliver crushing sweeps with your greatweapons, in order to see your master's will done."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/bulwark

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/bulwark/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 13
	H.STASPD = 5
	H.STACON = 11
	H.STAWIL = 10
	H.STAINT = 1
	H.STAPER = 10

	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
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
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy
	neck = /obj/item/clothing/neck/roguetown/gorget/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy

	H.adjust_blindness(-3)
	var/weapons = list("Greatsword", "Bardiche", "Grand Mace", "Mace + Shield","Spear", "Warhammer + Shield")
	var/weapon_choice = input(H, "Choose your GREATWEAPON.", "DEVASTATE THE LYVING UP CLOSE.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Greatsword")
			r_hand = /obj/item/rogueweapon/greatsword/paalloy
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Bardiche")
			r_hand = /obj/item/rogueweapon/halberd/bardiche/paalloy
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		if("Grand Mace")
			r_hand = /obj/item/rogueweapon/mace/goden/steel/paalloy
		if("Mace + Shield")
			r_hand = /obj/item/rogueweapon/mace/steel/palloy
			l_hand = /obj/item/rogueweapon/shield/wood
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
		if("Spear")
			r_hand = /obj/item/rogueweapon/spear/paalloy
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		if("Warhammer + Shield")
			r_hand = /obj/item/rogueweapon/mace/warhammer/steel/paalloy
			l_hand = /obj/item/rogueweapon/shield/wood
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
	var/armors = list("Sayovard + Cuirass & Hauberk", "Bascinet + Heavy Hauberk")
	var/armor_choice = input(H, "Choose your PLATE.", "SHRUG OFF THINE BLOWS.") as anything in armors
	switch(armor_choice)
		if("Sayovard + Cuirass & Hauberk")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/paalloy
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/paalloy
		if("Bascinet + Heavy Hauberk")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/paalloy
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy/heavy
	var/tabards = list("Black Tabard", "Black Jupon", "Black Cloak + Greathood")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/guardhood/lich

	H.energy = H.max_energy

// non-Combat crafter goon. Worse weapons + armor but does base-building. Fortnite.
/datum/advclass/greater_skeleton/lich/sapper
	name = "Ancient 'Broken Bone' Sapper"
	tutorial = "Simple. Obedient. Like an ant in a colony. Toil, fortify, smelt and labor to the tune of your master's whims. After all; what good is an army if it hasn't a sword-nor-shield to wield?"
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/sapper

	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/sapper/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 10
	H.STASPD = 6
	H.STACON = 9
	H.STAWIL = 10
	H.STAINT = 6
	H.STAPER = 10

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows , 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/slings, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/traps, 4, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/mining, 4, TRUE)
	H.adjust_skillrank(/datum/skill/labor/lumberjacking, 3, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/kettle/minershelm
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	gloves = /obj/item/clothing/gloves/roguetown/angle
	neck = /obj/item/clothing/neck/roguetown/coif
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	backl = /obj/item/storage/backpack/rogue/satchel

	beltr = /obj/item/rogueweapon/stoneaxe/woodcut/steel/paaxe
	beltl = /obj/item/rogueweapon/pick/paalloy

	H.adjust_blindness(-3)
	var/tabards = list("Black Cloak + Greathood", "Black Jupon", "Black Tabard")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.") as anything in tabards
	H.set_blindness(0)
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/guardhood/lich

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
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy

	l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy
	beltl = /obj/item/quiver/bolt/heavy/paalloy

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
	var/tabards = list("Black Cloak + Greathood", "Black Jupon")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Cloak + Greathood")
			cloak = /obj/item/clothing/cloak/half/lich
			mask = /obj/item/clothing/cloak/tabard/stabard/guardhood/lich

	H.energy = H.max_energy

//Stronger sidegrade of the Bulwark. Fully armored with high Intelligence and Perception for baiting and riposting, but extremely low Constitution and Speed. Crack open the armor, and they're dead meat.
/datum/advclass/greater_skeleton/lich/bulwarkrare
	name = "Venerated Death Knight"
	tutorial = "Swerve, parry, riposte. The wetness along your mortal wound has dried centuries ago, yet your wit remains unsullied in the slightest. Bring your master's chivalry to the battlefield, through both plate-and-blade."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/lich/bulwarkrare
	maximum_possible_slots = 2 //Limited, but powerful. Could serve as either champions or commanders for the Lich's army.
	category_tags = list(CTAG_LSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/lich/bulwarkrare/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 14
	H.STASPD = 5
	H.STACON = 5
	H.STAWIL = 8
	H.STAINT = 14
	H.STAPER = 14

	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/platelegs/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/plate/paalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/paalloy

	H.adjust_blindness(-3)
	var/weapons = list("Flamberge", "Flail + Greatshield")
	var/weapon_choice = input(H, "Choose your GREATWEAPON.", "FELL THE CHAMPIONS OF THE LYVING.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Flamberge")
			r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge/paalloy
			backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Flail + Greatshield")
			r_hand = /obj/item/rogueweapon/flail/sflail/paflail
			l_hand = /obj/item/rogueweapon/shield/tower/metal/palloy
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
			H.adjust_skillrank(/datum/skill/combat/shields, 1, TRUE)
	var/tabards = list("Black Tabard", "Black Jupon")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich

	H.energy = H.max_energy

// Spellblade skeleton. Rarest of the bunch - a true Azurcaephan from the ancient era.
// Medium armor, high INT, same chant/spells as regular spellblade. No miracles.
/datum/advclass/greater_skeleton/lich/spellblade
	name = "Venerated Azurcaephan"
	tutorial = "Swerve, parry, cast. Your bones have dried, and your flesh have withered. But your wits, and the flow of the arcyne remains untamed. Fuse steel and sorcery, let the legends of the Azurcaephan be known again. Azurea, reborn in arcyne fyre! No! Tarichea! Tarichea! Tarichea! Long may she live! Long may she reign! Tarichea forevermore! My blade undulled, my chant unbroken, my wits untarnished!"
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

	H.STASTR = 8
	H.STASPD = 7
	H.STACON = 5
	H.STAWIL = 12
	H.STAINT = 14
	H.STAPER = 11

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_ARCYNE_T2, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/magic/arcane, 2, TRUE)

	H.adjust_skillrank(/datum/skill/craft/carpentry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 2, TRUE)

	head = /obj/item/clothing/head/roguetown/helmet/heavy/paalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/paalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
	neck = /obj/item/clothing/neck/roguetown/chaincoif/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/sandals/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/paalloy
	backr = /obj/item/rogueweapon/shield/wood


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
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/caedo)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/air_strike)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/leyline_anchor)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/blade_storm)
			if("phalangite")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/azurean_phalanx)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/projectile/azurean_javelin)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/advance)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/gate_of_reckoning)
			if("macebearer")
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/shatter)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/tremor)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/charge)
				H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/cataclysm)

		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/recall_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/empower_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/bind_weapon)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/mending)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/invoked/enchant_weapon)
		H.mind.set_spell_point_pools(list("utility" = 4))

	H.adjust_blindness(-3)
	switch(subclass_selected)
		if("blade")
			var/weapons = list("Ancient Khopesh", "Ancient Dagger")
			var/weapon_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
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
			var/weapon_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
			switch(weapon_choice)
				if("Ancient Spear")
					r_hand = /obj/item/rogueweapon/spear/paalloy
				if("Ancient Bardiche")
					r_hand = /obj/item/rogueweapon/halberd/bardiche/paalloy
					backr = /obj/item/rogueweapon/scabbard/gwstrap
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, 4, TRUE)
		if("macebearer")
			var/weapons = list("Ancient Mace", "Ancient Warhammer")
			var/weapon_choice = input(H, "Choose your WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
			switch(weapon_choice)
				if("Ancient Mace")
					beltr = /obj/item/rogueweapon/mace/steel/palloy
				if("Ancient Warhammer")
					beltr = /obj/item/rogueweapon/mace/warhammer/steel/paalloy
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

	var/tabards = list("Black Tabard", "Black Jupon")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR MASTER'S HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/lich
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/lich

	H.energy = H.max_energy

/////////////////////////////
// UNIQUE ITEMS!           //
/////////////////////////////

/obj/item/clothing/cloak/tabard/stabard/surcoat/lich
	name = "decrepit jupon"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who are condemned to march forevermore."
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/tabard/lich
	name = "decrepit tabard"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who once knew of chivalry's allure."
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/half/lich
	name = "decrepit cloak"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who fear what they've truly become."
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/tabard/stabard/guardhood/lich
	name = "decrepit greathood"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who have reaped what they've sown."
	color = CLOTHING_BLACK

/obj/item/rogueweapon/greatsword/grenz/flamberge/aalloy
	name = "decrepit flamberge"
	desc = "Tarnished bronze and decaying bogleather, meticulously woven together to fashion a flame-bladed swan song for Psydonia's final descendants. </br>'Oh, how valiant His sacrifice was! But now He lies, sleeping and witless to the world-anew.' </br>'And now, He sleeps. And now, He weeps.'"
	icon_state = "ancientflamb"
	smeltresult = /obj/item/ingot/aaslag
	max_integrity = 150
	force = 25
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
