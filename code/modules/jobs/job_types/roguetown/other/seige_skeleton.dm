/datum/job/roguetown/greater_skeleton/seige_skeleton
	advclass_cat_rolls = list(CTAG_SIEGESKELETON = 20) //Unique NPC-esc Disposable roles. 3 classes, intended to show up, lite antagonise and die instantly.
	//Unlike most roles of skeletons, these ones just dust. Rids you instantly out of the round so you can respawn.
	//These are exclusive to skeleton sieges, they're a threat in numbers but advs can usually kill them with some effort solo by design.
	tutorial = "You have arisen by the will of an unknown force, fight and die. This is a disposable antagonist role, do not expect to last long." //Disposable throwaway antag
	outfit = /datum/outfit/job/roguetown/greater_skeleton/seige_skeleton

/datum/outfit/job/roguetown/greater_skeleton/seige_skeleton //Basically just NPC skeleton but slightly tuned up for players, with decrepit gear that can't be fixed. YOU WILL DIE.
	beltr = /obj/item/rogueweapon/huntingknife/idagger/adagger //Softlock protection, can be used as a pick in a pinch.
/datum/outfit/job/roguetown/greater_skeleton/seige_skeleton/pre_equip(mob/living/carbon/human/H)
	..()
	REMOVE_TRAIT(H, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	H.cmode_music = 'sound/music/combat_weird.ogg' //Same as regular deadites

//SIEGE SKELETONS, THESE ARE INTENTIONALLY VERY THROWAWAY ROLES. DUST ON DEATH + CRIT WEAKNESS + LOW STATS + TERRIBLE DECREPIT GEAR


//FOOTSOLDIER, OORAH, OORAH
/datum/advclass/greater_skeleton/seige_skeleton/feralfootsoldier
	name = "Decrepit Feral Footsoldier"
	tutorial = "You have arisen from unknown means, your tarnished guardsman plate clinging to your form. fight and kill."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/seige_skeleton/feralfootsoldier
	traits_applied = list(TRAIT_CRITICAL_WEAKNESS, TRAIT_DUSTABLE, TRAIT_SILVER_WEAK, TRAIT_MEDIUMARMOR) // You are disposable, your entire role is to fight and die.
	category_tags = list(CTAG_SIEGESKELETON)
	subclass_skills = list(
		//No labor skills, go cause problems and die.
		/datum/skill/combat/polearms = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/whipsflails = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/shields = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/greater_skeleton/seige_skeleton/feralfootsoldier/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a disposable Antagonist, go drive up some quick roleplay and conflict, expect to die rapidly!")) //Go forth my Fraggers.
	to_chat(H, span_narsiesmall("Find... Fight... Destroy..."))
	H.STASTR = 12
	H.STASPD = 9
	H.STACON = 8
	H.STAWIL = 10
	H.STAPER = 10
	H.STAINT = 1
	//intentionally decrepit gear, you're going to die rapidly. You're just here to start some fights and do some shennagions.
	cloak = /obj/item/clothing/cloak/tabard/stabard/surcoat/guard
	head = /obj/item/clothing/head/roguetown/helmet/heavy/aalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	belt = /obj/item/storage/belt/rogue/leather/rope
	l_hand = /obj/item/rogueweapon/shield/tower/metal/alloy //guarrenteed ancient shield, its going to break pretty fast.
	H.adjust_blindness(-3)
	var/weapons = list("Gladius","Spear","Flail")
	var/weapon_choice = input(H, "Choose your decrepit WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Gladius")
			r_hand = /obj/item/rogueweapon/sword/short/gladius/agladius
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Spear")
			r_hand = /obj/item/rogueweapon/spear/aalloy
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Flail")
			r_hand = /obj/item/rogueweapon/flail/aflail
			H.adjust_skillrank(/datum/skill/combat/whipsflails, 1, TRUE)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser) //Softlock immunity
	H.energy = H.max_energy

//ARCHER, TAKE AIM, DRAW, FIRE
/datum/advclass/greater_skeleton/seige_skeleton/feralarcher
	name = "Decrepit Feral Archer"
	tutorial = "You have arisen from unknown means, your bow and arrows at hand. fight and kill."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/seige_skeleton/feralarcher
	traits_applied = list(TRAIT_CRITICAL_WEAKNESS, TRAIT_DUSTABLE, TRAIT_SILVER_WEAK, TRAIT_MEDIUMARMOR) // You are disposable, your entire role is to fight and die.
	category_tags = list(CTAG_SEIGESKELETON)
	subclass_skills = list(
		//No labor skills, go cause problems and die.
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_NOVICE, //Dies to grapples. Disposable, hardcounter intended.
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/bows = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/knives = SKILL_LEVEL_JOURNEYMAN,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)
/datum/outfit/job/roguetown/greater_skeleton/seige_skeleton/feralarcher/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a disposable Antagonist, go drive up some quick roleplay and conflict, expect to die rapidly!")) //Go forth my Fraggers.
	to_chat(H, span_narsiesmall("Find... Fight... Destroy..."))
	H.STASTR = 9
	H.STASPD = 9
	H.STACON = 6
	H.STAWIL = 10
	H.STAPER = 12 //Players are smarter than NPCs, so they don't get much if, any range at all.
	H.STAINT = 1
	//intentionally decrepit gear, you're going to die rapidly. You're just here to start some fights and do some shennagions.
	head = /obj/item/clothing/head/roguetown/helmet/heavy/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	l_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	belt = /obj/item/storage/belt/rogue/leather/rope
	backl = /obj/item/quiver/broadhead_aalloy
	beltl = /obj/item/rogueweapon/mace/alloy

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser) //Softlock immunity
	H.energy = H.max_energy

//BULWARK, YOU'RE UP AGAINST THE WALL, AND I AM THE WALL
/datum/advclass/greater_skeleton/seige_skeleton/feralbulwark
	name = "Decrepit Feral Bulwark"
	tutorial = "You have arisen from unknown means, your tarnished rotting plate still clinging to your body. fight and kill."
	outfit = /datum/outfit/job/roguetown/greater_skeleton/seige_skeleton/feralbulwark
	traits_applied = list(TRAIT_CRITICAL_WEAKNESS, TRAIT_DUSTABLE, TRAIT_SILVER_WEAK, TRAIT_HEAVYARMOR) // You are disposable, your entire role is to fight and die.
	category_tags = list(CTAG_SEIGESKELETON)
	subclass_skills = list(
		//No labor skills, go cause problems and die.
		/datum/skill/combat/maces = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/wrestling = SKILL_LEVEL_JOURNEYMAN, //Enough to maybe escape a grapple, terrible con + low speed make it hard to weaponise
		/datum/skill/combat/unarmed = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/athletics = SKILL_LEVEL_EXPERT,
		/datum/skill/combat/swords = SKILL_LEVEL_APPRENTICE,
		/datum/skill/combat/knives = SKILL_LEVEL_APPRENTICE,
		/datum/skill/misc/climbing = SKILL_LEVEL_APPRENTICE,
	)

/datum/outfit/job/roguetown/greater_skeleton/seige_skeleton/feralbulwark/pre_equip(mob/living/carbon/human/H)
	..()
	to_chat(H, span_warning("You are a disposable Antagonist, go drive up some quick roleplay and conflict, expect to die rapidly!")) //Go forth my Fraggers.
	to_chat(H, span_narsiesmall("Find... Fight... Destroy..."))
	H.STASTR = 13
	H.STASPD = 8 //slightly lower and weaker once the armor cracks
	H.STACON = 7 //Dies as soon as their armor gives in.
	H.STAWIL = 12
	H.STAPER = 9
	H.STAINT = 1
	//intentionally decrepit gear, you're going to die rapidly. You're just here to start some fights and do some shennagions.
	cloak = /obj/item/clothing/cloak/tabard/blkknight
	head = /obj/item/clothing/head/roguetown/helmet/heavy/guard/aalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/aalloy
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	pants = /obj/item/clothing/under/roguetown/platelegs/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	neck = /obj/item/clothing/neck/roguetown/gorget/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/plate/aalloy
	belt = /obj/item/storage/belt/rogue/leather
	H.adjust_blindness(-3)
	var/weapons = list("Greatsword","Grand Mace")
	var/weapon_choice = input(H, "Choose your decrepit WEAPON.", "RAGE AGAINST THE LYVING.") as anything in weapons
	H.set_blindness(0)
	switch(weapon_choice)
		if("Greatsword")
			r_hand = /obj/item/rogueweapon/greatsword/aalloy
			H.adjust_skillrank(/datum/skill/combat/swords, 1, TRUE)
		if("Grand Mace")
			r_hand = /obj/item/rogueweapon/mace/goden/aalloy
			H.adjust_skillrank(/datum/skill/combat/maces, 1, TRUE)

	if(H.mind)
		H.mind.AddSpell(new /obj/effect/proc_holder/spell/self/suicidebomb/lesser) //Softlock immunity
	H.energy = H.max_energy
