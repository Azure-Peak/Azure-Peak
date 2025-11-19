/////////////////////////////////////////////
/////////////////////////////////// JUSTICIAR
/*
	a templar, but a little stronger
	that's really it
*/
/datum/advclass/warband/sect/lieutenant/justiciar
	title = "JUSTICIAR"
	name = "Justiciar"
	tutorial = "No weapon formed against the JUSTICIAR shall prosper."
	outfit = /datum/outfit/job/roguetown/warband/sect/lieutenant/justiciar
	traits_applied = list(TRAIT_HEAVYARMOR, TRAIT_LAWEXPERT, TRAIT_FORMATIONFIGHTER, TRAIT_COMBAT_AWARE)
	subclass_stats = list(
		STATKEY_STR = 4,
		STATKEY_CON = 4,
		STATKEY_WIL = 2,
		STATKEY_SPD = 3
	)
	subclass_skills = list(
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/unarmed = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/swimming = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/sneaking = SKILL_LEVEL_APPRENTICE,
		/datum/skill/craft/cooking = SKILL_LEVEL_NOVICE,
		/datum/skill/misc/medicine = SKILL_LEVEL_APPRENTICE,
		/datum/skill/magic/holy = SKILL_LEVEL_JOURNEYMAN,
	) // fixnote: give weapon skills & set their patron trait

/datum/outfit/job/roguetown/warband/sect/lieutenant/justiciar/pre_equip(mob/living/carbon/human/H)
	..()

	backl = /obj/item/storage/backpack/rogue/satchel
	backr = /obj/item/clothing/cloak/volfmantle
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/platelegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor

	if(H.patron.type == /datum/patron/divine/undivided)
		head = /obj/item/clothing/head/roguetown/helmet/bascinet
		mask = /obj/item/clothing/mask/rogue/facemask/steel
		id = /obj/item/clothing/neck/roguetown/psicross/undivided
		r_hand = /obj/item/rogueweapon/sword/long/undivided
		cloak = /obj/item/clothing/cloak/templar/undivided
	if(H.patron.type == /datum/patron/divine/astrata)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/astratahelm
		r_hand = /obj/item/rogueweapon/sword/long/exe/astrata
		id = /obj/item/clothing/neck/roguetown/psicross/astrata
		cloak = /obj/item/clothing/cloak/cape/crusader

	if(H.patron.type == /datum/patron/divine/noc)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/nochelm
		mask = /obj/item/clothing/mask/rogue/facemask
		id = /obj/item/clothing/neck/roguetown/psicross/noc
		r_hand = /obj/item/rogueweapon/sword/sabre/nockhopesh
		cloak = /obj/item/clothing/cloak/templar/noc

	if(H.patron.type == /datum/patron/divine/dendor)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/dendorhelm
		id = /obj/item/clothing/neck/roguetown/psicross/dendor
		cloak = /obj/item/clothing/cloak/templar/dendor
		r_hand = /obj/item/rogueweapon/halberd/bardiche/scythe

	if(H.patron.type == /datum/patron/divine/abyssor)
		var/weapons = list("TIDECLEAVER","BAROTRAUMA")
		var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("TIDECLEAVER")
				r_hand = /obj/item/rogueweapon/stoneaxe/battle/abyssoraxe
			if("BAROTRAUMA")
				r_hand = /obj/item/rogueweapon/katar/abyssor
		head = /obj/item/clothing/head/roguetown/helmet/heavy/abyssorgreathelm
		id = /obj/item/clothing/neck/roguetown/psicross/abyssor
		cloak = /obj/item/clothing/cloak/abyssortabard

	if(H.patron.type == /datum/patron/divine/ravox)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/ravoxhelm
		id = /obj/item/clothing/neck/roguetown/psicross/ravox
		cloak = /obj/item/clothing/cloak/templar/ravox
		r_hand = /obj/item/rogueweapon/mace/goden/steel/ravox
	
	if(H.patron.type == /datum/patron/divine/necra)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/necran
		id = /obj/item/clothing/neck/roguetown/psicross/necra
		cloak = /obj/item/clothing/cloak/templar/necran
		r_hand = /obj/item/rogueweapon/flail/sflail/necraflail

	if(H.patron.type == /datum/patron/divine/eora)
		var/weapons = list("HEARTSTRING","CLOSE CARESS")
		var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("TIDECLEAVER")
				r_hand = /obj/item/rogueweapon/sword/rapier/eora
			if("CLOSE CARESS")
				r_hand = /obj/item/rogueweapon/knuckles/eora
		head = /obj/item/clothing/head/roguetown/helmet/sallet/eoran
		mask = /obj/item/clothing/mask/rogue/facemask/steel
		id = /obj/item/clothing/neck/roguetown/psicross/eora

	if(H.patron.type == /datum/patron/divine/pestra)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/pestran
		cloak = /obj/item/clothing/cloak/templar/pestran
		r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle
		l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/pestrasickle
		id = /obj/item/clothing/neck/roguetown/psicross/pestra
	
	if(H.patron.type == /datum/patron/divine/malum)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/malum
		id = /obj/item/clothing/neck/roguetown/psicross/malum
		cloak = /obj/item/clothing/cloak/templar/malumite
		r_hand = /obj/item/rogueweapon/greatsword/grenz/flamberge/malum

	
	if(H.patron.type == /datum/patron/divine/xylix)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/xylixhelm
		cloak = /obj/item/clothing/cloak/templar/xylixian
		r_hand = /obj/item/rogueweapon/whip/xylix


	if(H.patron.type == /datum/patron/inhumen/graggar)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/graggar
		armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar
		r_hand = /obj/item/rogueweapon/halberd
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy

	if(H.patron.type == /datum/patron/inhumen/zizo)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
		armor = /obj/item/clothing/suit/roguetown/armor/plate/full/zizo
		r_hand = /obj/item/rogueweapon/sword/long/zizo
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy

	if(H.patron.type == /datum/patron/inhumen/baotha)
		head = /obj/item/clothing/head/roguetown/helmet/heavy/guard
		mask = /obj/item/flowercrown/salvia
		cloak = /obj/item/clothing/cloak/forrestercloak/snow/alt
		r_hand = /obj/item/rogueweapon/spear/partizan
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
		belt = /obj/item/storage/belt/rogue/leather
		id = /obj/item/clothing/neck/roguetown/psicross
		cloak = /obj/item/clothing/cloak/psydontabard
		shoes = /obj/item/clothing/shoes/roguetown/boots/psydonboots
		var/weapons = list("LONGSWORD","SPEAR","FLAIL","MACE","HANDAXE","WHIP")
		var/weapon_choice = input("Choose your weapon.", "TAKE UP ARMS") as anything in weapons
		switch(weapon_choice)
			if("LONGSWORD")
				r_hand = /obj/item/rogueweapon/sword/long/psysword
			if("SPEAR")
				r_hand = /obj/item/rogueweapon/spear/psyspear
			if("FLAIL")
				r_hand = /obj/item/rogueweapon/flail/sflail/psyflail
			if("MACE")
				r_hand = /obj/item/rogueweapon/mace/goden/psymace
			if("HANDAXE")
				r_hand = /obj/item/rogueweapon/stoneaxe/battle/psyaxe
			if("WHIP")
				r_hand = /obj/item/rogueweapon/whip/psywhip_lesser
		return TRUE
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)

///////////////////////////////////////////////
/////////////////////////////////// VERSEKEEPER
/*
	T4 Cleric
	T3 Bard
	dodge expert w/low speed
	reliant on Sentinel of Wits + high INT
	additionally, the only class aside from the Cultist that's a Cleric without getting it via the prophet's enlightenment verb
*/
/datum/advclass/warband/sect/lieutenant/versekeeper
	title = "VERSEKEEPER"
	name = "Versekeeper"
	tutorial = "Of all the prophet's apostles, the VERSEKEEPER is the most essential. What good is the cult's truth without a herald to spread it?"
	outfit = /datum/outfit/job/roguetown/warband/sect/lieutenant/versekeeper
	traits_applied = list(TRAIT_SENTINELOFWITS, TRAIT_DODGEEXPERT, TRAIT_FORMATIONFIGHTER, TRAIT_LAWEXPERT)
	subclass_stats = list(
		STATKEY_INT = 7,		
		STATKEY_SPD = -3,
		STATKEY_WIL = 6,
	)
	subclass_skills = list(
		/datum/skill/misc/music = SKILL_LEVEL_MASTER,
		/datum/skill/combat/polearms = SKILL_LEVEL_MASTER,
		/datum/skill/combat/maces = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/reading = SKILL_LEVEL_MASTER,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/axes = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/riding = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
	)



/datum/outfit/job/roguetown/warband/sect/lieutenant/versekeeper/pre_equip(mob/living/carbon/human/H)
	..()

	neck = /obj/item/clothing/neck/roguetown/bevor/keeper
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant/keeper
	cloak = /obj/item/clothing/cloak/thief_cloak/keeper
	head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/keeper
	shirt = /obj/item/clothing/suit/roguetown/shirt/robe/monk
	mask = /obj/item/clothing/mask/rogue/duelmask/keeper
	belt = /obj/item/storage/belt/rogue/leather/rope/dark
	backl = /obj/item/storage/backpack/rogue/backpack
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	backpack_contents = list(
		/obj/item/reagent_containers/glass/bottle/rogue/strongmanapot,
		/obj/item/rope/chain, 
		/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew,
		/obj/item/flashlight/flare/torch/lantern/prelit
	)


	if(H.mind)
		var/weapons = list("Harp","Lute","Accordion","Guitar","Hurdy-Gurdy","Viola","Vocal Talisman", "Psyaltery", "Flute")
		var/weapon_choice = tgui_input_list(H, "Choose your instrument.", "TAKE UP ARMS", weapons)
		switch(weapon_choice)
			if("Harp")
				backr = /obj/item/rogue/instrument/harp
			if("Lute")
				backr = /obj/item/rogue/instrument/lute
			if("Accordion")
				backr = /obj/item/rogue/instrument/accord
			if("Guitar")
				backr = /obj/item/rogue/instrument/guitar
			if("Hurdy-Gurdy")
				backr = /obj/item/rogue/instrument/hurdygurdy
			if("Viola")
				backr = /obj/item/rogue/instrument/viola
			if("Vocal Talisman")
				backr = /obj/item/rogue/instrument/vocals
			if("Psyaltery")
				backr = /obj/item/rogue/instrument/psyaltery
			if("Flute")
				backr = /obj/item/rogue/instrument/flute

	if(H.patron.type == /datum/patron/divine/undivided)
		id = /obj/item/clothing/neck/roguetown/psicross/undivided
		cloak = /obj/item/clothing/cloak/undivided

	if(H.patron.type == /datum/patron/divine/astrata)
		cloak = /obj/item/clothing/cloak/templar/astratan
		id = /obj/item/clothing/neck/roguetown/psicross/astrata

		
	if(H.patron.type == /datum/patron/divine/noc)
		id = /obj/item/clothing/neck/roguetown/psicross/noc


	if(H.patron.type == /datum/patron/divine/dendor)
		id = /obj/item/clothing/neck/roguetown/psicross/dendor

	if(H.patron.type == /datum/patron/divine/abyssor)
		id = /obj/item/clothing/neck/roguetown/psicross/abyssor

	if(H.patron.type == /datum/patron/divine/ravox)
		id = /obj/item/clothing/neck/roguetown/psicross/ravox
	
	if(H.patron.type == /datum/patron/divine/necra)
		id = /obj/item/clothing/neck/roguetown/psicross/necra

	if(H.patron.type == /datum/patron/divine/eora)
		id = /obj/item/clothing/neck/roguetown/psicross/eora

	if(H.patron.type == /datum/patron/divine/pestra)
		cloak = /obj/item/clothing/cloak/templar/pestran
		id = /obj/item/clothing/neck/roguetown/psicross/pestra

	if(H.patron.type == /datum/patron/divine/malum)
		id = /obj/item/clothing/neck/roguetown/psicross/malum
		cloak = /obj/item/clothing/cloak/templar/malumite

	
	if(H.patron.type == /datum/patron/divine/xylix)
		cloak = /obj/item/clothing/cloak/templar/xylixian
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy

	if(H.patron.type == /datum/patron/inhumen/graggar)
		cloak = /obj/item/clothing/cloak/graggar
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy

	if(H.patron.type == /datum/patron/inhumen/baotha)
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy

	if(H.patron.type == /datum/patron/inhumen/matthios)
		cloak = /obj/item/clothing/cloak/half/purple
		id = /obj/item/clothing/neck/roguetown/psicross/inhumen/aalloy

	if(H.patron.type == /datum/patron/old_god)
		armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
		id = /obj/item/clothing/neck/roguetown/psicross
		cloak = /obj/item/clothing/cloak/psydontabard

	var/datum/inspiration/I = new /datum/inspiration(H)
	I.grant_inspiration(H, bard_tier = BARD_T3)

	var/datum/devotion/C = new /datum/devotion(H, H.patron)
	C.grant_miracles(H, cleric_tier = CLERIC_T4, passive_gain = CLERIC_REGEN_MAJOR, start_maxed = TRUE)
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)







////////////////////////////////////////////
/////////////////////////////////// SENTINEL
/*
	T3 Cleric
	20 Perception Plate Archer w/a Froggemund
	Who Cares Anymore, Bro
*/
/datum/advclass/warband/sect/lieutenant/sentinel
	title = "SENTINEL"
	name = "Sentinel"
	tutorial = "Pity the infidel who dares to cross grounds overseen by the SENTINEL - for any hope of their redemption will be struck down by a single arrow."
	outfit = /datum/outfit/job/roguetown/warband/sect/lieutenant/sentinel
	traits_applied = list(TRAIT_KEENEARS, TRAIT_LAWEXPERT, TRAIT_FORMATIONFIGHTER)
	subclass_stats = list(
		STATKEY_PER = 10,
		STATKEY_SPD = -2,
		STATKEY_CON = 2,
		STATKEY_WIL = 2,
		STATKEY_INT = 2,
	)
	subclass_skills = list(
		/datum/skill/combat/bows = SKILL_LEVEL_LEGENDARY,
		/datum/skill/combat/slings = SKILL_LEVEL_MASTER,
		/datum/skill/misc/sneaking = SKILL_LEVEL_MASTER,
		/datum/skill/misc/tracking = SKILL_LEVEL_MASTER,		
		/datum/skill/misc/climbing = SKILL_LEVEL_EXPERT,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/reading = SKILL_LEVEL_NOVICE,
	)

/datum/outfit/job/roguetown/warband/sect/lieutenant/sentinel/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/frogmouth
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/platelegs
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather/plaquesilver
	beltr = /obj/item/quiver/pyroarrows
	beltl = /obj/item/quiver/javelin/steel
	cloak = /obj/item/clothing/cloak/volfmantle
	backl = /obj/item/quiver/bodkin

	if(H.patron.type == /datum/patron/divine/undivided)
		id = /obj/item/clothing/neck/roguetown/psicross/undivided
		cloak = /obj/item/clothing/cloak/undivided

	if(H.patron.type == /datum/patron/divine/astrata)
		cloak = /obj/item/clothing/cloak/templar/astratan
		id = /obj/item/clothing/neck/roguetown/psicross/astrata

	if(H.patron.type == /datum/patron/divine/noc)
		id = /obj/item/clothing/neck/roguetown/psicross/noc
		cloak = /obj/item/clothing/cloak/templar/noc

	if(H.patron.type == /datum/patron/divine/dendor)
		id = /obj/item/clothing/neck/roguetown/psicross/dendor
		cloak = /obj/item/clothing/cloak/templar/dendor

	if(H.patron.type == /datum/patron/divine/abyssor)
		id = /obj/item/clothing/neck/roguetown/psicross/abyssor
		cloak = /obj/item/clothing/cloak/abyssortabard

	if(H.patron.type == /datum/patron/divine/ravox)
		id = /obj/item/clothing/neck/roguetown/psicross/ravox
		cloak = /obj/item/clothing/cloak/templar/ravox
	
	if(H.patron.type == /datum/patron/divine/necra)
		id = /obj/item/clothing/neck/roguetown/psicross/necra
		cloak = /obj/item/clothing/cloak/templar/necran

	if(H.patron.type == /datum/patron/divine/eora)
		id = /obj/item/clothing/neck/roguetown/psicross/eora

	if(H.patron.type == /datum/patron/divine/pestra)
		cloak = /obj/item/clothing/cloak/templar/pestran
		id = /obj/item/clothing/neck/roguetown/psicross/pestra

	if(H.patron.type == /datum/patron/divine/malum)
		id = /obj/item/clothing/neck/roguetown/psicross/malum
		cloak = /obj/item/clothing/cloak/templar/malumite

	
	if(H.patron.type == /datum/patron/divine/xylix)
		cloak = /obj/item/clothing/cloak/templar/xylixian
		
	if(H.patron.type == /datum/patron/inhumen/graggar)
		cloak = /obj/item/clothing/cloak/graggar

	if(H.patron.type == /datum/patron/inhumen/baotha)
		mask = /obj/item/flowercrown/salvia

	if(H.patron.type == /datum/patron/inhumen/matthios)
		cloak = /obj/item/clothing/cloak/half/purple

	if(H.patron.type == /datum/patron/old_god)
		armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/ornate
		id = /obj/item/clothing/neck/roguetown/psicross
		cloak = /obj/item/clothing/cloak/psydontabard
	H.mind?.AddSpell(new /obj/effect/proc_holder/spell/invoked/sweep)
