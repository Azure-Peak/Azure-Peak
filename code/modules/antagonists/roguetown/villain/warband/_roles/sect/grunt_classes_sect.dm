////////////////////////////////////////////
/////////////////////////////////// CRUSADER
/*
	an INTless knight
*/
/datum/advclass/warband/sect/grunt/crusader
	title = "CRUSADER"
	name = "Crusader"
	tutorial = "As mighty in faith and arms as the CRUSADER may be, he walks without true miracles."
	outfit = /datum/outfit/job/roguetown/warband/sect/grunt/crusader
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_STEELHEARTED, TRAIT_FORMATIONFIGHTER)
	subclass_stats = list(
		STATKEY_STR = 4,
		STATKEY_INT = -1,
		STATKEY_CON = 4,
		STATKEY_WIL = 4,
		STATKEY_SPD = -3,
		STATKEY_PER = 1,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/axes = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_JOURNEYMAN,		
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/shields = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/riding = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/tracking = SKILL_LEVEL_NOVICE,
	)



/datum/outfit/job/roguetown/warband/sect/grunt/crusader/pre_equip(mob/living/carbon/human/H)
	..()

	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	backl = /obj/item/rogueweapon/shield/tower/metal
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced

	if(H.patron.type == /datum/patron/divine/undivided)
		head = /obj/item/clothing/head/roguetown/helmet/bascinet
		mask = /obj/item/clothing/mask/rogue/facemask
		id = /obj/item/clothing/neck/roguetown/psicross/undivided
		cloak = /obj/item/clothing/cloak/templar/undivided

	if(H.patron.type == /datum/patron/divine/astrata)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm
		id = /obj/item/clothing/neck/roguetown/psicross/astrata
		backr = /obj/item/clothing/cloak/cape/crusader
	if(H.patron.type == /datum/patron/divine/noc)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
		mask = /obj/item/clothing/mask/rogue/facemask
		id = /obj/item/clothing/neck/roguetown/psicross/noc
		cloak = /obj/item/clothing/cloak/templar/noc

	if(H.patron.type == /datum/patron/divine/dendor)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
		mask = /obj/item/clothing/mask/rogue/facemask
		id = /obj/item/clothing/neck/roguetown/psicross/dendor
		cloak = /obj/item/clothing/cloak/templar/dendor
		backr = /obj/item/clothing/cloak/cape/crusader
	
	if(H.patron.type == /datum/patron/divine/abyssor)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
		id = /obj/item/clothing/neck/roguetown/psicross/abyssor
		cloak = /obj/item/clothing/cloak/abyssortabard
		armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced

	if(H.patron.type == /datum/patron/divine/ravox)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm
		id = /obj/item/clothing/neck/roguetown/psicross/ravox
		cloak = /obj/item/clothing/cloak/templar/ravox
	
	if(H.patron.type == /datum/patron/divine/necra)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/necran
		id = /obj/item/clothing/neck/roguetown/psicross/necra
		cloak = /obj/item/clothing/cloak/templar/necran

	if(H.patron.type == /datum/patron/divine/eora)
		head = /obj/item/clothing/head/roguetown/helmet/sallet/eoran
		mask = /obj/item/clothing/mask/rogue/facemask/steel
		id = /obj/item/clothing/neck/roguetown/psicross/eora
		backr = /obj/item/clothing/cloak/cape/crusader

	if(H.patron.type == /datum/patron/divine/pestra)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
		cloak = /obj/item/clothing/cloak/templar/pestran
		id = /obj/item/clothing/neck/roguetown/psicross/pestra

	if(H.patron.type == /datum/patron/divine/malum)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/malum
		id = /obj/item/clothing/neck/roguetown/psicross/malum
		cloak = /obj/item/clothing/cloak/templar/malumite
		backr = /obj/item/clothing/cloak/cape/crusader
	
	if(H.patron.type == /datum/patron/divine/xylix)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm
		cloak = /obj/item/clothing/cloak/templar/xylixian
		r_hand = /obj/item/rogueweapon/whip/xylix

	if(H.patron.type == /datum/patron/inhumen/graggar)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/graggar
		armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy

	if(H.patron.type == /datum/patron/inhumen/zizo)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
		armor = /obj/item/clothing/suit/roguetown/armor/plate/full/zizo
		backr = /obj/item/clothing/cloak/cape/crusader
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy

	if(H.patron.type == /datum/patron/inhumen/baotha)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/guard
		armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
		mask = /obj/item/flowercrown/salvia
		cloak = /obj/item/clothing/cloak/forrestercloak/snow/alt
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy

	if(H.patron.type == /datum/patron/inhumen/matthios)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/matthios
		armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fluted
		cloak = /obj/item/clothing/cloak/half/purple
		belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/steel
		r_hand = /obj/item/rogueweapon/whip
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy

	if(H.patron.type == /datum/patron/old_god)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/psydonhelm
		armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
		id = /obj/item/clothing/neck/roguetown/psicross
		cloak = /obj/item/clothing/cloak/psydontabard
		shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
		var/weapons = list("LONGSWORD","SPEAR","FLAIL","MACE","WAR AXE")
		var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("LONGSWORD")
				r_hand = /obj/item/rogueweapon/sword/long/oldpsysword
			if("SPEAR")
				r_hand = /obj/item/rogueweapon/spear/psyspear/old
			if("FLAIL")
				r_hand = /obj/item/rogueweapon/flail/sflail/psyflail/old
			if("MACE")
				r_hand = /obj/item/rogueweapon/mace/goden/psymace/old
			if("WAR AXE")
				r_hand = /obj/item/rogueweapon/stoneaxe/battle/psyaxe/old
	else
		var/weapontype = list("SWORD","HAMMER","AXE","HALBERD")
		var/category_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapontype
		switch(category_choice)
			if("SWORD")
				r_hand = /obj/item/rogueweapon/greatsword
				beltl = /obj/item/rogueweapon/sword/short/messer
			if("HAMMER")
				r_hand = /obj/item/rogueweapon/mace/warhammer/steel
			if("AXE")
				r_hand = /obj/item/rogueweapon/stoneaxe/battle
				beltl = /obj/item/rogueweapon/stoneaxe/hurlbat
				beltr = /obj/item/rogueweapon/stoneaxe/hurlbat
			if("HALBERD")
				r_hand = /obj/item/rogueweapon/halberd
				beltl = /obj/item/rogueweapon/sword/short



//////////////////////////////////////////
/////////////////////////////////// ZEALOT
/*
	low-defense monk

*/
/datum/advclass/warband/sect/grunt/zealot
	title = "ZEALOT"
	name = "Zealot"
	tutorial = "The ZEALOT has ruined martial arts. Gone are graceful dodges, stances and maneuvers. \
	His victories are owed to blind fury, and fury alone."
	outfit = /datum/outfit/job/roguetown/warband/sect/grunt/zealot

	traits_applied = list(TRAIT_NOPAIN, TRAIT_STEELHEARTED, TRAIT_FORMATIONFIGHTER)
	subclass_stats = list(
		STATKEY_STR = 6,
		STATKEY_CON = 6,
		STATKEY_WIL = 6,
		STATKEY_INT = -2,
		STATKEY_PER = -4,
	)

	subclass_skills = list(
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/warband/sect/grunt/zealot/pre_equip(mob/living/carbon/human/H)
	..()

	pants = /obj/item/clothing/under/roguetown/splintlegs
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/full
	backl = /obj/item/storage/backpack/rogue/satchel

	if(H.patron.type == /datum/patron/divine/undivided)
		id = /obj/item/clothing/neck/roguetown/psicross/undivided

	if(H.patron.type == /datum/patron/divine/astrata)
		cloak = /obj/item/clothing/cloak/templar/astratan
		head = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		id = /obj/item/clothing/neck/roguetown/psicross/astrata
		backr = /obj/item/clothing/cloak/cape/crusader
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		belt = /obj/item/storage/belt/rogue/leather
		
	if(H.patron.type == /datum/patron/divine/noc)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
		mask = /obj/item/clothing/mask/rogue/facemask
		id = /obj/item/clothing/neck/roguetown/psicross/noc
		cloak = /obj/item/clothing/cloak/templar/noc
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		shirt = null
		belt = /obj/item/storage/belt/rogue/leather

	if(H.patron.type == /datum/patron/divine/dendor)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
		mask = /obj/item/clothing/mask/rogue/facemask
		id = /obj/item/clothing/neck/roguetown/psicross/dendor
		cloak = /obj/item/clothing/cloak/templar/dendor
		backr = /obj/item/clothing/cloak/cape/crusader
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		belt = /obj/item/storage/belt/rogue/leather

	if(H.patron.type == /datum/patron/divine/abyssor)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
		id = /obj/item/clothing/neck/roguetown/psicross/abyssor
		cloak = /obj/item/clothing/cloak/abyssortabard
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		belt = /obj/item/storage/belt/rogue/leather

	if(H.patron.type == /datum/patron/divine/ravox)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm
		id = /obj/item/clothing/neck/roguetown/psicross/ravox
		cloak = /obj/item/clothing/cloak/templar/ravox
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		belt = /obj/item/storage/belt/rogue/leather
	
	if(H.patron.type == /datum/patron/divine/necra)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/necran
		id = /obj/item/clothing/neck/roguetown/psicross/necra
		cloak = /obj/item/clothing/cloak/templar/necran
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		belt = /obj/item/storage/belt/rogue/leather

	if(H.patron.type == /datum/patron/divine/eora)
		head = /obj/item/clothing/head/roguetown/helmet/sallet/eoran
		mask = /obj/item/clothing/mask/rogue/facemask/steel
		id = /obj/item/clothing/neck/roguetown/psicross/eora
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		backr = /obj/item/clothing/cloak/cape/crusader
		belt = /obj/item/storage/belt/rogue/leather

	if(H.patron.type == /datum/patron/divine/pestra)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
		cloak = /obj/item/clothing/cloak/templar/pestran
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		belt = /obj/item/storage/belt/rogue/leather
		id = /obj/item/clothing/neck/roguetown/psicross/pestra

	if(H.patron.type == /datum/patron/divine/malum)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/malum
		id = /obj/item/clothing/neck/roguetown/psicross/malum
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		cloak = /obj/item/clothing/cloak/templar/malumite
		backr = /obj/item/clothing/cloak/cape/crusader
		belt = /obj/item/storage/belt/rogue/leather
	
	if(H.patron.type == /datum/patron/divine/xylix)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		cloak = /obj/item/clothing/cloak/templar/xylixian
		belt = /obj/item/storage/belt/rogue/leather

	if(H.patron.type == /datum/patron/inhumen/graggar)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/graggar
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		cloak = /obj/item/clothing/cloak/graggar
		belt = /obj/item/storage/belt/rogue/leather

	if(H.patron.type == /datum/patron/inhumen/zizo)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		belt = /obj/item/storage/belt/rogue/leather
		r_hand = /obj/item/rogueweapon/sword/long/zizo

	if(H.patron.type == /datum/patron/inhumen/baotha)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/guard
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		belt = /obj/item/storage/belt/rogue/leather
		mask = /obj/item/flowercrown/salvia
		cloak = /obj/item/clothing/cloak/forrestercloak/snow/alt

	if(H.patron.type == /datum/patron/inhumen/matthios)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/matthios
		armor = /obj/item/clothing/suit/roguetown/armor/brigandine/light
		shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
		cloak = /obj/item/clothing/cloak/half/purple
		belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/steel

	if(H.patron.type == /datum/patron/old_god)
		mask = /obj/item/clothing/mask/rogue/sack/psy
		armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
		id = /obj/item/clothing/neck/roguetown/psicross
		cloak = /obj/item/clothing/cloak/psydontabard
		shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
		belt = /obj/item/storage/belt/rogue/leather


///////////////////////////////////////////
/////////////////////////////////// CULTIST
/*
	an acolyte w/crafting & dagger skills
	strong faith regen
*/
/datum/advclass/warband/sect/grunt/cultist
	title = "CULTIST"
	name = "Cultist"
	tutorial = "The CULTIST has been shaped into the perfect tool for the Sect: a serf wise enough for skilled labor, \
	pious enough to channel the full might of their God, and foolish enough to serve their Prophet."
	outfit = /datum/outfit/job/roguetown/warband/sect/grunt/cultist
	
	traits_applied = list(TRAIT_RITUALIST, TRAIT_FORMATIONFIGHTER)
	subclass_stats = list(
		STATKEY_WIL = 4,
		STATKEY_INT = 4,
		STATKEY_PER = 2,
	)

	subclass_skills = list(
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/carpentry = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/sewing = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/traps = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/mining = SKILL_LEVEL_EXPERT,
		/datum/skill/labor/lumberjacking = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/engineering = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/weaponsmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/blacksmithing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/smelting = SKILL_LEVEL_APPRENTICE,
	)


/datum/outfit/job/roguetown/warband/sect/grunt/cultist/pre_equip(mob/living/carbon/human/H)
	..()

	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/corroded
	head = /obj/item/clothing/mask/rogue/sack
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper/cultist
	gloves = /obj/item/clothing/gloves/roguetown/angle
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backl = /obj/item/storage/backpack/rogue/satchel/black
	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special,
		/obj/item/flashlight/flare/torch/lantern/prelit,
		/obj/item/reagent_containers/glass/bottle/rogue/strongpoison,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/glass/bottle/waterskin
		)
	if(H.patron.type == /datum/patron/divine/undivided)
		neck = /obj/item/clothing/neck/roguetown/psicross/undivided
	if(H.patron.type == /datum/patron/divine/astrata)
		neck = /obj/item/clothing/neck/roguetown/psicross/astrata
	if(H.patron.type == /datum/patron/divine/noc)
		neck = /obj/item/clothing/neck/roguetown/psicross/noc
		backpack_contents = (/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot)
	if(H.patron.type == /datum/patron/divine/ravox)
		neck = /obj/item/clothing/neck/roguetown/psicross/ravox
		backpack_contents = (/obj/item/book/rogue/law)
	if(H.patron.type == /datum/patron/divine/necra)
		neck = /obj/item/clothing/neck/roguetown/psicross/necra
		backpack_contents = list(/obj/item/rogueweapon/shovel/small, /obj/item/natural/bundle/stick)
	if(H.patron.type == /datum/patron/divine/abyssor)
		neck = /obj/item/clothing/neck/roguetown/psicross/abyssor
	if(H.patron.type == /datum/patron/divine/dendor)
		neck = /obj/item/clothing/neck/roguetown/psicross/dendor
	if(H.patron.type == /datum/patron/divine/malum)
		neck = /obj/item/clothing/neck/roguetown/psicross/malum
	if(H.patron.type == /datum/patron/divine/xylix)
		neck = /obj/item/clothing/neck/roguetown/luckcharm
	if(H.patron.type == /datum/patron/divine/eora)
		neck = /obj/item/clothing/neck/roguetown/psicross/eora
	if(H.patron.type == /datum/patron/divine/pestra)
		neck = /obj/item/clothing/neck/roguetown/psicross/pestra
		backpack_contents = list(/obj/item/natural/bundle/cloth, /obj/item/needle)
	if(H.patron.type == /datum/patron/inhumen/zizo)
		neck = /obj/item/clothing/neck/roguetown/psicross
	if(H.patron.type == /datum/patron/inhumen/graggar)
		neck = /obj/item/clothing/neck/roguetown/psicross
	if(H.patron.type == /datum/patron/inhumen/matthios)
		neck = /obj/item/clothing/neck/roguetown/psicross
	if(H.patron.type == /datum/patron/inhumen/baotha)
		neck = /obj/item/clothing/neck/roguetown/psicross
	if(H.patron.type == /datum/patron/old_god)
		mask = /obj/item/clothing/mask/rogue/sack/psy
		neck = /obj/item/clothing/neck/roguetown/psicross
		shirt = /obj/item/clothing/suit/roguetown/shirt/robe/monk/holy
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)
	return
