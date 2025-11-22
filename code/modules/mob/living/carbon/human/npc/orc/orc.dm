/mob/living/carbon/human/species/orc/
	name = "orc"
	skin_tone = SKIN_COLOR_GROONN
	hairstyle = "Bald"
	facial_hairstyle = "Shaved"
	var/orc_outfit = /datum/outfit/job/roguetown/orc/npc

	race = /datum/species/orc
	gender = MALE
	bodyparts = list(/obj/item/bodypart/chest, /obj/item/bodypart/head, /obj/item/bodypart/l_arm,
					 /obj/item/bodypart/r_arm, /obj/item/bodypart/r_leg, /obj/item/bodypart/l_leg)
	ambushable = FALSE
	
	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_SPECIAL, INTENT_JUMP, INTENT_KICK, INTENT_BITE)
	possible_rmb_intents = list(/datum/rmb_intent/feint, /datum/rmb_intent/aimed, /datum/rmb_intent/strong, /datum/rmb_intent/weak, /datum/rmb_intent/swift, /datum/rmb_intent/riposte)

/mob/living/carbon/human/species/orc/npc
	faction = list("orcs", "station")
	aggressive = 1
	rude = TRUE
	mode = NPC_AI_IDLE
	wander = FALSE
	cmode_music = FALSE

/mob/living/carbon/human/species/orc/npc/Initialize()
	. = ..()
	set_species(/datum/species/orc)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/orc/npc/after_creation()
	..()
	job = "Savage Orc"
	equipOutfit(new orc_outfit)
	gender = pick(MALE, FEMALE)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/lowbraid, 
						/datum/sprite_accessory/hair/head/countryponytailalt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher, 
						/datum/sprite_accessory/hair/head/lowbraid))
	var/beard = pick(list(/datum/sprite_accessory/hair/facial/viking,
						/datum/sprite_accessory/hair/facial/manly,
						/datum/sprite_accessory/hair/facial/longbeard))
	head.sellprice = 30

	src.set_patron(/datum/patron/inhumen/graggar)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)

	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/datum/bodypart_feature/hair/facial/new_facial = new()
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/organ/ears/organ_ears = getorgan(/obj/item/organ/ears)

	if(organ_eyes)
		organ_eyes.eye_color = "#FF0000"
		organ_eyes.accessory_colors = "#FF0000#FF0000"

	skin_tone = "50715C"

	if(organ_ears)
		organ_ears.accessory_colors = "#50715C"

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)
		new_facial.set_accessory_type(beard, null, src)
		
	head.add_bodypart_feature(new_hair)
	head.add_bodypart_feature(new_facial)

	new_hair.accessory_colors = "#31302E"
	new_hair.hair_color = "#31302E"
	new_facial.accessory_colors = "#31302E"
	new_facial.hair_color = "#31302E"
	hair_color = "#31302E"

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)
	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/rt/names/other/halforcf.txt"))
	else
		real_name = pick(world.file2list("strings/rt/names/other/halforcm.txt"))
	update_hair()
	update_body()

/datum/outfit/job/roguetown/orc/npc/pre_equip(mob/living/carbon/human/H) //gives some default skills and equipment for player controlled orcs
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	head = /obj/item/clothing/head/roguetown/helmet/leather
	shoes = /obj/item/clothing/shoes/roguetown/gladiator
	r_hand = /obj/item/rogueweapon/stoneaxe/boneaxe
	l_hand = /obj/item/rogueweapon/shield/wood

	H.STASTR = 16
	H.STASPD = 8
	H.STACON = 15
	H.STAWIL = 15
	H.STAINT = 6

	//light labor skills for armor repairs and such, equipment is so-so, with good stats
	H.adjust_skillrank(/datum/skill/craft/carpentry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 1, TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, 1, TRUE)

	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)


