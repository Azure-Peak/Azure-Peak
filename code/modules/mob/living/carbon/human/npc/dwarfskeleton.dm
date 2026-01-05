GLOBAL_LIST_INIT(dwarfskeleton_aggro, world.file2list("strings/rt/dskeletonaggrolines.txt"))

/mob/living/carbon/human/species/dwarfskeleton

	race = /datum/species/dwarf/mountain
	gender = MALE
	faction = list("dundead")
	var/skel_outfit = /datum/outfit/job/roguetown/dwarfskeleton
	ambushable = FALSE
	mode = NPC_AI_IDLE
	wander = FALSE
	cmode = 1
	setparrytime = 30
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY //even in undeath dwarves parry. Dodging aint proper dorf behavior
	selected_default_language = /datum/language/dwarvish
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL) //intents given in case of player controlled
	possible_rmb_intents = list(/datum/rmb_intent/feint, /datum/rmb_intent/aimed, /datum/rmb_intent/strong, /datum/rmb_intent/weak)

/mob/living/carbon/human/species/dwarfskeleton/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/dwarfskeleton/retaliate(mob/living/L)
	.=..()
	if(prob(5))
		say(pick(GLOB.dwarfskeleton_aggro))
		pointed(target)

/mob/living/carbon/human/species/dwarfskeleton/Initialize()
	. = ..()
	cut_overlays()
	spawn(10)
		after_creation()

/mob/living/carbon/human/species/dwarfskeleton/after_creation()
	..()
	if(src.dna && src.dna.species)
		src.dna.species.species_traits |= NOBLOOD
		src.dna.species.soundpack_m = new /datum/voicepack/skeleton()
	if(src.charflaw)
		QDEL_NULL(src.charflaw)
	mob_biotypes = MOB_UNDEAD
	job = "Dwarf Skeleton"
	real_name = "Dwarven Skeleton"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC) // We're moving away from infinite green, even on skeletons.
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	var/obj/item/organ/eyes/eyes = src.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(src)
	for(var/obj/item/bodypart/B in src.bodyparts)
		B.skeletonize(FALSE)
	update_body()
	if(skel_outfit)
		var/datum/outfit/OU = new skel_outfit
		if(OU)
			equipOutfit(OU)

/datum/outfit/job/roguetown/dwarfskeleton/pre_equip(mob/living/carbon/human/H)
	..()
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/black
	if(prob(50))
		cloak = /obj/item/clothing/cloak/raincloak/mortus
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	if(prob(60))
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
		if(prob(10))
			shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	if(prob(40))
		pants =	/obj/item/clothing/under/roguetown/heavy_leather_pants
	head = /obj/item/clothing/head/roguetown/helmet
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/horned
	neck = /obj/item/clothing/neck/roguetown/gorget
	mask = /obj/item/clothing/mask/rogue/facemask
	if(prob(40))
		mask = /obj/item/clothing/mask/rogue/facemask/copper
		if(prob(10))
			mask = /obj/item/clothing/mask/rogue/facemask/steel
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	l_hand = /obj/item/rogueweapon/spear/bronze
	if(prob(50))
		l_hand = /obj/item/rogueweapon/sword/short/gladius
		r_hand = /obj/item/rogueweapon/shield/wood
		if(prob(20))
			l_hand = /obj/item/rogueweapon/knuckles/bronzeknuckles

	H.STASTR = 12
	H.STASPD = 11
	H.STACON = 12
	H.STAWIL = 12
	H.STAPER = 14
	H.STAINT = 11
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/mob/living/carbon/human/species/dwarfskeleton/ambush/knight
	skel_outfit = /datum/outfit/job/roguetown/dwarfskeleton/ambush/knight

/datum/outfit/job/roguetown/dwarfskeleton/ambush/knight/pre_equip(mob/living/carbon/human/H)
	. = ..()
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/armet
	gloves = /obj/item/clothing/gloves/roguetown/plate
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/platelegs
	cloak = /obj/item/clothing/cloak/tabard/stabard/dungeon
	neck = /obj/item/clothing/neck/roguetown/chaincoif
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	belt = /obj/item/storage/belt/rogue/leather
	l_hand = /obj/item/rogueweapon/greataxe
	r_hand = null

	H.STASTR = 16
	H.STASPD = 11
	H.STACON = 14
	H.STAWIL = 14
	H.STAPER = 14
	H.STAINT = 11
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
