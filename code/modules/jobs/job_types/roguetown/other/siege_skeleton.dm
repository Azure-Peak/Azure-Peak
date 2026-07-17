/datum/job/roguetown/greater_skeleton/siege_skeleton
	advclass_cat_rolls = list(CTAG_SSKELETON = 20) //Unique NPC-esc Disposable roles. 3 classes, intended to show up, lite antagonise and die instantly.
	title = "Siege Skeleton"
	flag = SKELETON
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null //no pq
	max_pq = null
	announce_latejoin = FALSE
	vice_restrictions = list(/datum/charflaw/hunted, /datum/charflaw/targeted)

	//Unlike most roles of skeletons, these ones just dust. Rids you instantly out of the round so you can respawn.
	//These are exclusive to skeleton sieges, they're a threat in numbers but advs can usually kill them with some effort solo by design.
	//Your entire existance is to pick fights in town or around it and die. Then spawn in and do it over and over until the seige ends.

	tutorial = "You are bygone, your mynd barely above the average feral. Find the lyving and kill. This is a disposable antagonist role, do not expect to last long." //Disposable throwaway antag

	outfit = /datum/outfit/job/roguetown/greater_skeleton/siege_skeleton

/datum/outfit/job/roguetown/greater_skeleton/siege_skeleton //Basically just NPC skeleton but slightly tuned up for players, with decrepit gear that can't be fixed. YOU WILL DIE.
	belt = /obj/item/storage/belt/rogue/leather //Enough to hold some things, go kill for a satchel, literally.
	beltr = /obj/item/rogueweapon/huntingknife/idagger/adagger //Softlock protection, can be used as a pick in a pinch.

////WARNING, SHITCODE GALORE BELOW, THIS THING IS HELD TOGETHER WITH TAPE AND PRAYERS, IT ALWAYS WAS BUT NOW MORESO////

/datum/outfit/job/roguetown/greater_skeleton/siege_skeleton/pre_equip(mob/living/carbon/human/H)
	..()
	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(H, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC) // You are disposable, your entire role is to fight and die.
	ADD_TRAIT(H, TRAIT_DUSTABLE, TRAIT_GENERIC) // No corpse, lets you get back to lobby rapidly.
	H.cmode_music = 'sound/music/combat_weird.ogg' //Same as regular deadites

//SIEGE SKELETONS, THESE ARE INTENTIONALLY VERY THROWAWAY ROLES. DUST ON DEATH + CRIT WEAKNESS + LOW STATS + TERRIBLE DECREPIT GEAR
//Loyal to nobody, your existance is to fight and die, very very very quickly.


//FOOTSOLDIER, OORAH, OORAH
/datum/advclass/greater_skeleton/siege_skeleton/feralfootsoldier
	name = "Decrepit Feral Footsoldier"
	tutorial = "You have arisen from unknown means, your tarnished guardsman plate clinging to your form. A single directive fills your once purposeless mind, Slay the ignorant and remake them in her name."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/siege_skeleton/feralfootsoldier

	category_tags = list(CTAG_SSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/siege_skeleton/feralfootsoldier/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 12
	H.STASPD = 9
	H.STACON = 8 //Can put up a decent fight, suffers from not having much special about them.
	H.STAWIL = 10
	H.STAPER = 10
	H.STAINT = 1

	H.become_skeleton() //Ensures no matter what, we become a skeleton correctly.
	H.choose_name_popup("Decrepit Feral")
	to_chat(H, span_danger("You are a disposable antagonist, expect to die rather quickly. Now go cause problems and stirr some conflict! Remember to roleplay where possible."))

	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	//intentionally decrepit gear, you're going to die rapidly. You're just here to start some fights and do some shennagions.
	head = /obj/item/clothing/head/roguetown/helmet/heavy/aalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	l_hand = /obj/item/rogueweapon/shield/tower/metal/alloy //guarrenteed ancient shield, its going to break pretty fast.
	H.adjust_blindness(-3)
	var/weapons = list("Gladius","Spear","Flail","Khopesh","Axe","Mace")
	var/weapon_choice = input(H, "Choose your DECREPIT WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Gladius")
			r_hand = /obj/item/rogueweapon/sword/short/gladius/agladius
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Spear")
			r_hand = /obj/item/rogueweapon/spear/aalloy
			H.adjust_skillrank(/datum/skill/combat/polearms, 1, TRUE)
		if("Khopesh")
			beltr = /obj/item/rogueweapon/sword/sabre/alloy
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Axe")
			beltr = /obj/item/rogueweapon/stoneaxe/woodcut/aaxe
			H.adjust_skillrank(/datum/skill/combat/axes, 1, TRUE)
		if("Flail")
			r_hand = /obj/item/rogueweapon/flail/aflail
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)
		if("Mace")
			beltr = /obj/item/rogueweapon/mace/alloy
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)

	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/necro
		if("Black Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser) //Softlock immunity
	H.energy = H.max_energy

//ARCHER, TAKE AIM, DRAW, FIRE
/datum/advclass/greater_skeleton/siege_skeleton/feralarcher
	name = "Decrepit Feral Archer"
	tutorial = "You have arisen from unknown means, your bow still remains in hand and your rotted arrows in a quiver. A single directive fills your once purposeless mind, Slay the ignorant and remake them in her name."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/siege_skeleton/feralarcher

	category_tags = list(CTAG_SSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/siege_skeleton/feralarcher/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 9
	H.STASPD = 9
	H.STACON = 6 //Dies as soon as their weak armor gives in.
	H.STAWIL = 10
	H.STAPER = 12 //Players are smarter than NPCs, so they don't get much if, any range at all.
	H.STAINT = 1

	H.become_skeleton() //Ensures no matter what, we become a skeleton correctly.
	H.choose_name_popup("Decrepit Feral")
	to_chat(H, span_danger("You are a disposable antagonist, expect to die rather quickly. Now go cause problems and stirr some conflict! Remember to roleplay where possible."))
	
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/bows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	//intentionally decrepit gear, you're going to die rapidly. You're just here to start some fights and do some shennagions.
	head = /obj/item/clothing/head/roguetown/helmet/kettle/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve //No picks, you're a minor antagonist and this is already more than enough
	backl = /obj/item/quiver/broadhead_aalloy
	//Knife is default softlock protection sidearm, difference is you don't suck at it here as much.

	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/necro
		if("Black Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser) //Softlock immunity
	H.energy = H.max_energy

//BULWARK, YOU'RE UP AGAINST THE WALL, AND I AM THE WALL
/datum/advclass/greater_skeleton/siege_skeleton/feralbulwark
	name = "Decrepit Feral Bulwark"
	tutorial = "You have arisen from unknown means, your tarnished rotting plate still clinging to your body. A single directive fills your once purposeless mind, Slay the ignorant and remake them in her name."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/siege_skeleton/feralbulwark

	category_tags = list(CTAG_SSKELETON)

/datum/outfit/job/roguetown/greater_skeleton/siege_skeleton/feralbulwark/pre_equip(mob/living/carbon/human/H)
	..()

	H.STASTR = 13
	H.STASPD = 6 //slightly slower than their NPC varient and weaker once the armor cracks
	H.STACON = 6 //Dies as soon as their armor gives in.
	H.STAWIL = 12
	H.STAPER = 9
	H.STAINT = 1

	H.become_skeleton() //Ensures no matter what, we become a skeleton correctly.
	H.choose_name_popup("Decrepit Feral")
	to_chat(H, span_danger("You are a disposable antagonist, expect to die rather quickly. Now go cause problems and stirr some conflict! Remember to roleplay where possible."))

	ADD_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

	//intentionally decrepit gear, you're going to die rapidly. You're just here to start some fights and do some shennagions.
	cloak = /obj/item/clothing/cloak/tabard/blkknight
	pants = /obj/item/clothing/under/roguetown/platelegs/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/gorget/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/plate/aalloy
	H.adjust_blindness(-3)
	var/weapons = list("Greatsword","Grand Mace")
	var/weapon_choice = input(H, "Choose your DECREPIT WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Greatsword")
			r_hand = /obj/item/rogueweapon/greatsword/aalloy
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Grand Mace")
			r_hand = /obj/item/rogueweapon/mace/goden/aalloy
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)
	var/armors = list("Sayovard + Cuirass & Hauberk", "Bascinet + Heavy Hauberk")
	var/armor_choice = input(H, "Choose your PLATE.", "SHRUG OFF THINE BLOWS.") as anything in armors
	switch(armor_choice)
		if("Sayovard + Cuirass & Hauberk")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/aalloy
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy
			wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
			armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy
		if("Bascinet + Heavy Hauberk")
			head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/aalloy
			wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy/chain
			shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
			armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy/heavy
	var/tabards = list("Black Jupon", "Black Tabard", "Black Cloak", "Black Toga")
	var/tabard_choice = input(H, "Choose your CLOAK.", "BARE YOUR HERALDRY.") as anything in tabards
	switch(tabard_choice)
		if("Black Jupon")
			cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/necro
		if("Black Tabard")
			cloak = /obj/item/clothing/cloak/tabard/necro
		if("Black Cloak")
			cloak = /obj/item/clothing/cloak/half/lich
		if("Black Toga")
			cloak = /obj/item/clothing/cloak/tabard/toga/lich

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser) //Softlock immunity
	H.energy = H.max_energy
