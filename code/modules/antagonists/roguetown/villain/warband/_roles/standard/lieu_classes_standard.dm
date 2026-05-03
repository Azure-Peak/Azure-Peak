

////////////////////////////////////////////
/////////////////////////////////// PREACHER
/*
	T4 Cleric
	splits into a Sect during a Warband Schism
*/
/datum/advclass/warband/standard/lieutenant/preacher
	title = "PREACHER"
	name = "Preacher"
	tutorial = "The PREACHER is an advisor upon matters of faith. A vital ally, for the warpath strays deathly close to Holy Ground."
	outfit = /datum/outfit/job/roguetown/warband/standard/lieutenant/preacher
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_RITUALIST, TRAIT_LAWEXPERT, TRAIT_FORMATIONFIGHTER)
	subclass_stats = list(
		STATKEY_CON = 3,
		STATKEY_WIL = 6,
		STATKEY_INT = 4,
		STATKEY_PER = -2,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_MASTER,
		/datum/skill/combat/unarmed = SKILL_LEVEL_MASTER,
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
		/datum/skill/magic/holy = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/medicine = SKILL_LEVEL_EXPERT,
		/datum/skill/craft/crafting = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/alchemy = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/craft/cooking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/sewing = SKILL_LEVEL_APPRENTICE,
		/datum/skill/labor/farming = SKILL_LEVEL_APPRENTICE,
	)
	subclass_languages = list(/datum/language/grenzelhoftian)

/datum/outfit/job/roguetown/warband/standard/lieutenant/preacher/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	pants = /obj/item/clothing/under/roguetown/tights/black
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	beltl = /obj/item/rogueweapon/scabbard/sheath
	belt = /obj/item/storage/belt/rogue/leather/rope/dark
	backl = /obj/item/storage/backpack/rogue/satchel
	l_hand = /obj/item/rogueweapon/woodstaff
	gloves = /obj/item/clothing/gloves/roguetown/bandages/pugilist
	backpack_contents = list(
		/obj/item/needle = 1,
		/obj/item/ritechalk = 1,
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 1,
		/obj/item/reagent_containers/glass/bottle/waterskin = 1
	)

	if(H.patron.type == /datum/patron/divine/undivided)
		wrists = /obj/item/clothing/neck/roguetown/psicross/undivided
	if(H.patron.type == /datum/patron/divine/astrata)
		wrists = /obj/item/clothing/neck/roguetown/psicross/astrata
		gloves = /obj/item/clothing/gloves/roguetown/leather
		cloak = /obj/item/clothing/cloak/templar/astratan
	if(H.patron.type == /datum/patron/divine/noc)
		wrists = /obj/item/clothing/neck/roguetown/psicross/noc
		backpack_contents = (/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot)
		cloak = /obj/item/clothing/suit/roguetown/shirt/robe/noc
	if(H.patron.type == /datum/patron/divine/ravox)
		head = /obj/item/clothing/head/roguetown/roguehood/ravoxgorget
		wrists = /obj/item/clothing/neck/roguetown/psicross/ravox
		cloak = /obj/item/clothing/cloak/templar/ravox
		neck = /obj/item/clothing/neck/roguetown/bevor
		backpack_contents = (/obj/item/book/rogue/law)
	if(H.patron.type == /datum/patron/divine/necra)
		wrists = /obj/item/clothing/neck/roguetown/psicross/necra
		cloak = /obj/item/clothing/cloak/templar/necran
		shirt = null
		ADD_TRAIT(H, TRAIT_NOSTINK, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_SOUL_EXAMINE, TRAIT_GENERIC)
	if(H.patron.type == /datum/patron/divine/abyssor)
		cloak = /obj/item/clothing/cloak/tabard/abyssorite
		wrists = /obj/item/clothing/neck/roguetown/psicross/abyssor
		ADD_TRAIT(H, TRAIT_WATERBREATHING, TRAIT_GENERIC)
	if(H.patron.type == /datum/patron/divine/dendor)
		head = /obj/item/clothing/head/roguetown/dendormask
		cloak = /obj/item/clothing/suit/roguetown/shirt/robe/dendor
		wrists = /obj/item/clothing/neck/roguetown/psicross/dendor
		gloves = /obj/item/clothing/gloves/roguetown/leather
	if(H.patron.type == /datum/patron/divine/malum)
		cloak = /obj/item/clothing/cloak/templar/malumite
		wrists = /obj/item/clothing/neck/roguetown/psicross/malum
		H.adjust_skillrank_up_to(/datum/skill/craft/blacksmithing = 3)
		H.adjust_skillrank_up_to(/datum/skill/craft/armorsmithing = 3)
		H.adjust_skillrank_up_to(/datum/skill/craft/weaponsmithing = 3)
		H.adjust_skillrank_up_to(/datum/skill/craft/smelting = 3)
	if(H.patron.type == /datum/patron/divine/xylix)
		wrists = /obj/item/clothing/neck/roguetown/luckcharm
		cloak = /obj/item/clothing/cloak/templar/xylixian
		shirt = null
		pants = /obj/item/clothing/under/roguetown/skirt/black
		wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
		H.adjust_skillrank_up_to(/datum/skill/misc/sneaking = 5)
		H.adjust_skillrank_up_to(/datum/skill/misc/music = 4)		
		H.adjust_skillrank_up_to(/datum/skill/misc/climbing = 3)
		H.adjust_skillrank_up_to(/datum/skill/misc/lockpicking = 3)
	if(H.patron.type == /datum/patron/divine/eora)
		wrists = /obj/item/clothing/neck/roguetown/psicross/eora
		cloak = /obj/item/clothing/suit/roguetown/shirt/robe/eora
		ADD_TRAIT(H, TRAIT_BEAUTIFUL, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_EMPATH, TRAIT_GENERIC)
		H.cmode_music = 'sound/music/cmode/church/combat_eora.ogg'
	if(H.patron.type == /datum/patron/divine/pestra)
		wrists = /obj/item/clothing/neck/roguetown/psicross/pestra
		head = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
		cloak = /obj/item/clothing/cloak/templar/pestran
		gloves = /obj/item/clothing/gloves/roguetown/leather
		beltr = /obj/item/storage/belt/rogue/surgery_bag/full
		backpack_contents = list(/obj/item/natural/bundle/cloth, /obj/item/needle/pestra)
	if(H.patron.type == /datum/patron/inhumen/zizo)
		wrists = /obj/item/clothing/neck/roguetown/psicross
	if(H.patron.type == /datum/patron/inhumen/graggar)
		wrists = /obj/item/clothing/neck/roguetown/psicross
	if(H.patron.type == /datum/patron/inhumen/matthios)
		wrists = /obj/item/clothing/neck/roguetown/psicross
	if(H.patron.type == /datum/patron/inhumen/baotha)
		wrists = /obj/item/clothing/neck/roguetown/psicross
	if(H.patron.type == /datum/patron/old_god)
		wrists = /obj/item/clothing/neck/roguetown/psicross/silver
		cloak = /obj/item/clothing/cloak/tabard/psydontabard
	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)


////////////////////////////////////////////
/////////////////////////////////// BANNERET
/*
	knight captain+

*/
/datum/advclass/warband/standard/lieutenant/knight
	title = "BANNERET"
	name = "Banneret"
	tutorial = "The BANNERET answered the call to arms clad in his finest steel. One can only hope it'll be enough."
	outfit = /datum/outfit/job/roguetown/warband/standard/lieutenant/knight
	horse = /mob/living/simple_animal/hostile/retaliate/rogue/saiga/tame/saddled
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_NOBLE, TRAIT_STEELHEARTED, TRAIT_FORMATIONFIGHTER, TRAIT_LAWEXPERT, TRAIT_COMBAT_AWARE)
	subclass_stats = list(
		STATKEY_STR = 5,
		STATKEY_SPD = -3,
		STATKEY_CON = 5,
		STATKEY_WIL = 5,
		STATKEY_INT = 2,
		STATKEY_PER = 4,
	)
	subclass_skills = list(
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/swords = SKILL_LEVEL_MASTER,
		/datum/skill/combat/axes = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_MASTER,
		/datum/skill/misc/riding = SKILL_LEVEL_MASTER,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/shields = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
	)


/datum/outfit/job/roguetown/warband/standard/lieutenant/knight/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)
	neck = /obj/item/clothing/neck/roguetown/bevor
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/chainlegs
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	cloak = /obj/item/clothing/cloak/tabard/stabard/warband
	backr = /obj/item/storage/backpack/rogue/satchel/black

	backpack_contents = list(
		/obj/item/rogueweapon/huntingknife/idagger/steel/special = 1, 
		/obj/item/rope/chain = 1, 
		/obj/item/rogueweapon/scabbard/sheath = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette = 1,
		/obj/item/reagent_containers/glass/bottle/waterskin = 1
	)

	var/weapons = list("Claymore","Great Mace","Battle Axe","Greataxe","Estoc","Lucerne", "Partizan", "Lance + Kite Shield")
	var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
	switch(weapon_choice)
		if("Claymore")
			r_hand = /obj/item/rogueweapon/greatsword/zwei
			backl = /obj/item/rogueweapon/scabbard/gwstrap
		if("Great Mace")
			r_hand = /obj/item/rogueweapon/mace/goden/steel
		if("Battle Axe")
			r_hand = /obj/item/rogueweapon/stoneaxe/battle
		if("Greataxe")
			r_hand = /obj/item/rogueweapon/greataxe/steel
			backl = /obj/item/rogueweapon/scabbard/gwstrap
		if("Estoc")
			r_hand = /obj/item/rogueweapon/estoc
			backl = /obj/item/rogueweapon/scabbard/gwstrap
		if("Lucerne")
			r_hand = /obj/item/rogueweapon/eaglebeak/lucerne
			backl = /obj/item/rogueweapon/scabbard/gwstrap
		if("Partizan")
			r_hand = /obj/item/rogueweapon/spear/partizan
			backl = /obj/item/rogueweapon/scabbard/gwstrap
		if("Lance + Kite Shield")
			r_hand = /obj/item/rogueweapon/spear/lance
			backl = /obj/item/rogueweapon/shield/tower/metal


	var/helmets = list(
		"Pigface Bascinet" 	= /obj/item/clothing/head/roguetown/helmet/bascinet/pigface,
		"Guard Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/guard,
		"Barred Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/sheriff,
		"Bucket Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/bucket,
		"Knight Helmet"		= /obj/item/clothing/head/roguetown/helmet/heavy/knight,
		"Visored Sallet"	= /obj/item/clothing/head/roguetown/helmet/sallet/visored,
		"Armet"				= /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet,
		"Hounskull Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/pigface/hounskull,
		"Etruscan Bascinet" = /obj/item/clothing/head/roguetown/helmet/bascinet/etruscan,
		"Slitted Kettle" = /obj/item/clothing/head/roguetown/helmet/heavy/knight/skettle,
		"None"
	)
	var/helmchoice = input("Choose your Helm.", "TAKE UP HELMS") as anything in helmets	
	if(helmchoice != "None")
		head = helmets[helmchoice]


/////////////////////////////////////////////
/////////////////////////////////// SPYMASTER
/*
	it's a rogue
*/
/datum/advclass/warband/standard/lieutenant/spymaster
	title = "SPYMASTER"
	name = "Spymaster"
	tutorial = "The SPYMASTER's foresight was pivotal in arranging the Duchy's invasion. Now, they shall personally oversee the final stretch of their plans."
	outfit = /datum/outfit/job/roguetown/warband/standard/lieutenant/spymaster
	subclass_languages = list(/datum/language/thievescant)
	traits_applied = list(TRAIT_MEDIUMARMOR, TRAIT_SENTINELOFWITS, TRAIT_DODGEEXPERT, TRAIT_PERFECT_TRACKER, TRAIT_LAWEXPERT, TRAIT_FORMATIONFIGHTER)
	subclass_stats = list(
		STATKEY_STR = -3,
		STATKEY_CON = -1,
		STATKEY_SPD = 6,
		STATKEY_WIL = 2,
		STATKEY_INT = 4,
		STATKEY_PER = 4,
	)
	subclass_skills = list(
		/datum/skill/misc/climbing = SKILL_LEVEL_LEGENDARY,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/stealing = SKILL_LEVEL_MASTER,
		/datum/skill/misc/lockpicking = SKILL_LEVEL_MASTER,	
		/datum/skill/combat/swords = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/crossbows = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/bows = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/tracking = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/unarmed = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/reading = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/warband/standard/lieutenant/spymaster/pre_equip(mob/living/carbon/human/H)
	..()
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)
	cloak = /obj/item/clothing/cloak/tabard/stabard/warband
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail
	backr = /obj/item/storage/backpack/rogue/satchel/black
	belt = /obj/item/storage/belt/rogue/leather
	beltl = /obj/item/rogueweapon/scabbard/sheath
	beltr = /obj/item/rogueweapon/scabbard/sword	
	l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying
	r_hand = /obj/item/rogueweapon/sword/rapier
	gloves = /obj/item/clothing/gloves/roguetown/angle
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	mask = /obj/item/clothing/mask/rogue/spectacles
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/poison = 1,
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew = 1,
		/obj/item/flashlight/flare/torch/lantern/prelit = 1,
		/obj/item/bomb/smoke = 2
		)



////////////////////////////////////////////
/////////////////////////////////// MAGICIAN
/*
	it's a wizard
*/
/datum/advclass/warband/standard/lieutenant/magician
	title = "MAGICIAN"
	name = "Wizard"
	tutorial = "A battlefield is no place for a MAGICIAN. Unfortunately for them, their sage mind and vast knowledge of the arcane makes them indispensible."
	outfit = /datum/outfit/job/roguetown/warband/standard/lieutenant/magician
	traits_applied = list(TRAIT_ARCYNE, TRAIT_ALCHEMY_EXPERT, TRAIT_FORMATIONFIGHTER, TRAIT_LAWEXPERT)
	subclass_stats = list(
		STATKEY_STR = -2,
		STATKEY_CON = 2,
		STATKEY_WIL = 3,
		STATKEY_INT = 6,
		STATKEY_PER = 4,
	)
	subclass_skills = list(
		/datum/skill/misc/reading = SKILL_LEVEL_LEGENDARY,
		/datum/skill/craft/alchemy = SKILL_LEVEL_EXPERT,
		/datum/skill/magic/arcane = SKILL_LEVEL_MASTER,
		/datum/skill/combat/polearms = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/swimming = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_NOVICE,
		/datum/skill/craft/crafting = SKILL_LEVEL_NOVICE,
	)
	subclass_mage_aspects = list("mastery" = FALSE, "major" = 2, "minor" = 3, "utilities" = 9, "ward" = TRUE)

/datum/outfit/job/roguetown/warband/standard/lieutenant/magician/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/wizhat/green/alt
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	gloves = /obj/item/clothing/gloves/roguetown/leather/black
	cloak = /obj/item/clothing/cloak/poncho/invader
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/tabardblack/alt
	pants = /obj/item/clothing/under/roguetown/tights/random
	shoes = /obj/item/clothing/shoes/roguetown/shortboots
	belt = /obj/item/storage/belt/rogue/leather/black
	beltl = /obj/item/storage/magebag
	r_hand = /obj/item/rogueweapon/woodstaff
	backl = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(
		/obj/item/flashlight/flare/torch/lantern/prelit, 
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew,
		/obj/item/recipe_book/alchemy,
		/obj/item/reagent_containers/glass/bottle/waterskin,
		/obj/item/book/spellbook,
		/obj/item/rogueweapon/huntingknife/idagger/silver/arcyne
	)
