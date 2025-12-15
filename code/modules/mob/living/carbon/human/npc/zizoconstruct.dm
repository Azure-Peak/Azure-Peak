GLOBAL_LIST_INIT(zizoconstruct_aggro, world.file2list("strings/rt/zconstructaggrolines.txt"))

/mob/living/carbon/human/species/construct/metal/zizoconstruct

	race = /datum/species/construct/metal
	name_override = "Bronze Construct"
	desc = "A bio-mechanical construct given life by dubious magics. This one is made almost entirely of bronze. It seems poorly made."
	faction = list("dundead")
	var/zc_outfit = /datum/outfit/job/roguetown/human/species/construct/metal/zizoconstruct
	ambushable = FALSE
	mode = NPC_AI_IDLE
	wander = FALSE
	cmode = 1
	setparrytime = 30
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY //knocks your weapon away with with their big scary metal arms
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL) //intents given incase of player controlled
	possible_rmb_intents = list(/datum/rmb_intent/feint, /datum/rmb_intent/aimed, /datum/rmb_intent/strong, /datum/rmb_intent/weak)
	resize = 1.2

/mob/living/carbon/human/species/construct/metal/zizoconstruct/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/construct/metal/zizoconstruct/retaliate(mob/living/L)
	.=..()
	if(prob(5))
		say(pick(GLOB.zizoconstruct_aggro))
		pointed(target)

/mob/living/carbon/human/species/construct/metal/zizoconstruct/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/construct/metal/zizoconstruct/Initialize()
	. = ..()
	cut_overlays()
	spawn(10)
		after_creation()

/mob/living/carbon/human/species/construct/metal/zizoconstruct/after_creation()
	..()
	job = "Zizo Construct"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CIVILIZEDBARBARIAN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	gender = pick(MALE, FEMALE)
	regenerate_icons()
	skin_tone = "e2a670"

	if(gender == FEMALE)
		real_name = pick("Bronze Construct")
	else
		real_name = pick("Bronze Construct")
	update_body()
	if(zc_outfit)
		var/datum/outfit/OU = new zc_outfit
		if(OU)
			equipOutfit(OU)

/datum/outfit/job/roguetown/human/species/construct/metal/zizoconstruct/pre_equip(mob/living/carbon/human/H)
	..()
	shirt = /obj/item/clothing/suit/roguetown/armor/skin_armor/zizoconstructarmor
	l_hand = /obj/item/rogueweapon/knuckles/bronzeknuckles/zizoconstruct

	H.STASTR = 20
	H.STASPD = 8
	H.STACON = 20
	H.STAWIL = 20
	H.STAPER = 8
	H.STAINT = 1
	H.adjust_skillrank(/datum/skill/combat/unarmed, 5, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 5, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/obj/item/rogueweapon/knuckles/bronzeknuckles/zizoconstruct //I have no unarmed and I must parry. More interesting than defprob and gives construct PC a fun item to loot and use
	name = "construct knuckles"
	desc = "A vicous pair of bronze knuckles designed specifically for constructs. There is a terrifying, hollow spike in the center of the grip. There doesn't seem to be a way to wield it without impaling yourself."
	wdefense = 11
	color = "#5f1414"
	max_integrity = 500
	anvilrepair = /datum/skill/craft/engineering

/obj/item/rogueweapon/knuckles/bronzeknuckles/zizoconstruct/pickup(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_BLOODLOSS_IMMUNE))
		to_chat(user, "<font color='purple'> You attempt to wield the knuckles. The spike sinks deeply into your hand, piercing it and drinking deep of your vital energies!</font>")
		user.adjustBruteLoss(15)
		user.Stun(40)
		playsound(get_turf(user), 'sound/misc/drink_blood.ogg', 100)
	..()

/obj/item/clothing/suit/roguetown/armor/skin_armor/zizoconstructarmor //ww armor but for construct
	slot_flags = SHIRT_LAYER
	name = "construct plating"
	desc = ""
	icon_state = null
	body_parts_covered = FULL_BODY
	armor = ARMOR_ZIZOCONCSTRUCT
	blocksound = PLATEHIT
	blade_dulling = DULLING_BASHCHOP
	sewrepair = FALSE
	max_integrity = 600
	item_flags = DROPDEL
