/datum/job/roguetown/greater_skeleton
	title = "Greater Skeleton"
	flag = SKELETON
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null //no pq
	max_pq = null
	announce_latejoin = FALSE

	advclass_cat_rolls = list(CTAG_NSKELETON = 20)

	tutorial = "You are bygone. A wandering has-been. But maybe your luck has not run out, yet.."

	outfit = /datum/outfit/job/roguetown/greater_skeleton/necro
	show_in_credits = TRUE 
	give_bank_account = FALSE
	hidden_job = TRUE
	vice_restrictions = list(/datum/charflaw/hunted, /datum/charflaw/targeted)

/datum/outfit/job/roguetown/greater_skeleton/pre_equip(mob/living/carbon/human/H)
	..()

	ADD_TRAIT(H, TRAIT_OUTLAW, TRAIT_GENERIC) //No miesters for skeletons, you're an undead, bloodless skeletal abomination.
	ADD_TRAIT(H, TRAIT_SHATTER_KILL, TRAIT_GENERIC) //Softer version of crit weakness that only kills with paralysis/rib fractures and nothing else.
	ADD_TRAIT(H, TRAIT_NO_VOICEPACK_OVERRIDE, TRAIT_GENERIC) //In case we get edge-cases I.E siege skeletons. Otherwise its on the skeleton race too.

	H.set_patron(/datum/patron/inhumen/zizo)

	H.possible_rmb_intents = list(/datum/rmb_intent/feint,\
	/datum/rmb_intent/aimed,\
	/datum/rmb_intent/riposte,\
	/datum/rmb_intent/strong,\
	/datum/rmb_intent/weak)
	H.swap_rmb_intent(num=1)

	var/datum/antagonist/new_antag = new /datum/antagonist/skeleton()
	H.mind.add_antag_datum(new_antag)

	H.grant_language(/datum/language/undead)

	var/datum/language_holder/language_holder = H.get_language_holder()
	language_holder.selected_default_language = /datum/language/undead

/datum/job/roguetown/greater_skeleton/after_spawn(mob/living/L, mob/M, latejoin = FALSE)
	..()

	var/mob/living/carbon/human/H = L
	H.mob_biotypes |= MOB_UNDEAD

	H.advsetup = TRUE
	H.invisibility = INVISIBILITY_MAXIMUM
	H.become_blind("advsetup")
	for (var/obj/item/bodypart/B in H.bodyparts)
		B.skeletonize(FALSE)

/*
NECRO SKELETONS
*/


/datum/outfit/job/roguetown/greater_skeleton/necro
	belt = /obj/item/storage/belt/rogue/leather
	backl = /obj/item/storage/backpack/rogue/satchel
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron

// Melee fighter with a shield/spear. Holds the line. All-rounder
/datum/advclass/greater_skeleton/necro/legionnaire
	name = "Decrepit Legionnaire"
	tutorial = "Legions rise and you answer. Stand proud with your line; for you serve the architect. You know death. Memento mori. You just can't understand it."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/necro/legionnaire

	category_tags = list(CTAG_NSKELETON)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/maces = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/axes = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,

	)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_SILVER_WEAK)

/datum/outfit/job/roguetown/greater_skeleton/necro/legionnaire/pre_equip(mob/living/carbon/human/H)
	..()

	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.STASTR = 12
	H.STAPER = 11
	H.STASPD = 8
	H.STACON = 9
	H.STAWIL = 11
	H.STAINT = 3

	head = /obj/item/clothing/head/roguetown/helmet/sallet/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron

	var/helmets = list(
		"Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/iron,
		"Kettle Helmet"		= /obj/item/clothing/head/roguetown/helmet/kettle/iron,
		"None"
		)
	H.adjust_blindness(-3)
	var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]
	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/necro
		if("Black Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich
	var/weapon_choice = input(H, "Choose your weapon.", "RISE AGAINST THE LYVING.") as anything in list("Sword + Shield", "Spear", "Mace + Shield", "Axe + Shield", "Flail + Shield")
	H.set_blindness(0)
	switch(weapon_choice)
		if("Sword + Shield")
			beltr = /obj/item/rogueweapon/sword
			backr = /obj/item/rogueweapon/shield/wood
		if("Spear")
			r_hand = /obj/item/rogueweapon/spear
		if("Mace + Shield")
			backr = /obj/item/rogueweapon/shield/wood
			beltr = /obj/item/rogueweapon/mace
		if("Flail + Shield")
			backr = /obj/item/rogueweapon/shield/wood
			beltr = /obj/item/rogueweapon/flail
		if("Axe + Shield")
			backr = /obj/item/rogueweapon/shield/wood
			beltr = /obj/item/rogueweapon/stoneaxe/woodcut

	H.energy = H.max_energy

// Ranged skeleton with either a bow or a sling.
/datum/advclass/greater_skeleton/necro/ballistiare
	name = "Hollow Ballistiare"
	tutorial = "You're broken, cracked and risen anew. How do they expect a lesser rattler like you to shoot out the eyes of our enemies? The Dame of Progress smiles at you tonight. Make Her proud."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/necro/ballistiare

	category_tags = list(CTAG_NSKELETON)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/slings = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,
	)
	traits_applied = list(TRAIT_SILVER_WEAK)

/datum/outfit/job/roguetown/greater_skeleton/necro/ballistiare/pre_equip(mob/living/carbon/human/H)
	..()

	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.STASTR = 8
	H.STASPD = 8
	H.STACON = 8
	H.STAWIL = 12
	H.STAINT = 3
	H.STAPER = 14

	head = /obj/item/clothing/head/roguetown/helmet/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/iron
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	shirt = prob(50) ? /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant : /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	shoes = /obj/item/clothing/shoes/roguetown/boots
	beltr = /obj/item/rogueweapon/huntingknife/idagger

	H.adjust_blindness(-3)
	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/necro
		if("Black Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich
	var/weapon_choice = input(H, "Choose your weapon.", "RISE AGAINST THE LYVING.") as anything in list("Bow", "Sling")
	H.set_blindness(0)
	switch(weapon_choice)
		if("Bow")
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/short
			beltl = /obj/item/quiver/arrows
		if("Sling")
			backr = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			beltl = /obj/item/quiver/sling/iron

	H.energy = H.max_energy

// Melee Heavy-Plate fighter with a mace/spear. Heavy weapon specialist that cracks to fire/when their armor is busted up.
/datum/advclass/greater_skeleton/necro/bulwark
	name = "Shattered Bulwark"
	tutorial = "Legions rise and you answer. Stand rigid and unbreakable; for you serve the architect. Death comes for all but you delay and defy it."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/necro/bulwark

	category_tags = list(CTAG_NSKELETON)
	subclass_skills = list(
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/carpentry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/masonry = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_NOVICE,

	)
	traits_applied = list(TRAIT_SILVER_WEAK)

/datum/outfit/job/roguetown/greater_skeleton/necro/bulwark/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 12
	H.STAPER = 10
	H.STASPD = 7 //Slightly faster than lich one cause its got to keep up with the other necro's goons + less disposable + worse statline due to lux cost.
	H.STACON = 6 //Relies on armor
	H.STAWIL = 12
	H.STAINT = 1

	gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron/chain
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron/kilt
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron/heavy
	shirt = prob(50) ? /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant : /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron

	var/helmets = list(
		"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron,
		"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron,
		"Knight's Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron,
		"Knight's Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/old/iron,
		"Knight's Greatplumed Armet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight/iron/greatplume,
		"None"
		)
	H.adjust_blindness(-3)
	var/helmchoice = input(H, "Choose your Helm.", "TAKE UP HELMS") as anything in helmets
	if(helmchoice != "None")
		head = helmets[helmchoice]
	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/necro
		if("Black Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich
	var/weapon_choice = input(H, "Choose your weapon.", "RISE AGAINST THE LYVING.") as anything in list("Greatsword", "Spear", "Great Flail", "Warhammer + Shield")
	H.set_blindness(0)
	switch(weapon_choice)
		if("Greatsword")
			H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
			r_hand = /obj/item/rogueweapon/greatsword/iron
		if("Spear")
			H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
			r_hand = /obj/item/rogueweapon/spear
		if("Great Flail")
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_JOURNEYMAN, TRUE)
			r_hand = /obj/item/rogueweapon/flail/peasantwarflail/iron
		if("Warhammer + Shield")
			H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
			backr = /obj/item/rogueweapon/shield/wood
			beltr = /obj/item/rogueweapon/mace/warhammer

	H.energy = H.max_energy

// Crafting and labor skeleton. Tools double as weapons.
/datum/advclass/greater_skeleton/necro/sapper
	name = "Lesser Bone Sapper"
	tutorial = "Toil toil toil. You rise to work. You rise to rebell; but your rebellion is localized in the smithy, in the sawmills, in the plants. Create under the foreman and the architect."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/necro/sapper

	category_tags = list(CTAG_NSKELETON)
	subclass_skills = list(
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/carpentry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/masonry = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/sewing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/traps = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_APPRENTICE, //For the alchemy mortar + pestle for explosives, remove once the recipe changes.
		/datum/skill/craft/cooking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/armorsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/tanning = SKILL_LEVEL_NOVICE, //You /can/ do it, is the point here
		/datum/skill/labor/butchering = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/mining = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_EXPERT, //High because necromancer has a skeleton cap and they have /you/
	)
	/*Gimmic here is for smithing, you have to spect out into what you want.
	You remain mostly spread into utility as well as construction however this still remains a non-combat role,
	for skeles to pick into, expect to be pretty chill playing this.
	
	vs lich skele you can't artifice as-well as them, nor do you get free spells + wall destroying explosion + decent as they have armor
	Nor do you get yourself a free spec of golden specs to tell structure health, you're sort of a knockoff one to say the least.
	You don't get a backpack or free toolset either, this isn't to say you can't do some amazing stuff/virtues don't exist.
	*/
	traits_applied = list(TRAIT_SILVER_WEAK, TRAIT_HOMESTEAD_EXPERT, TRAIT_SMITHING_EXPERT, TRAIT_SELF_SUSTENANCE)

/datum/outfit/job/roguetown/greater_skeleton/necro/sapper/pre_equip(mob/living/carbon/human/H)
	..()

	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	H.STASTR = 10
	H.STASPD = 10
	H.STACON = 5 //Light armor, weak constition, high potental.
	H.STAWIL = 10
	H.STAINT = 6
	H.STAPER = 8

	head = /obj/item/clothing/head/roguetown/helmet/leather //Looks bad with volf helm vs archer so no ability to pick
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather //So you don't fall off a wall and gib yourself.
	shirt = prob(50) ? /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant : /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l
	pants = /obj/item/clothing/under/roguetown/trou/artipants/lich
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	beltr = /obj/item/rogueweapon/stoneaxe/woodcut
	beltl = /obj/item/rogueweapon/pick

	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BEAR YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/necro
		if("Black Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	H.energy = H.max_energy

/obj/item/clothing/cloak/tabard/stabard/surcoat/necro
	name = "decrepit jupon"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who are condemned to walk forevermore."
	color = CLOTHING_BLACK

/obj/item/clothing/cloak/tabard/necro
	name = "decrepit tabard"
	desc = "Roughspun fabrics from beyond your lyfetime, donned by those who once knew of class and place."
	color = CLOTHING_BLACK
