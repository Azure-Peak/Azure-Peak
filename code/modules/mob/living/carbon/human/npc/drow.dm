GLOBAL_LIST_INIT(drowraider_aggro, world.file2list("strings/rt/drowaggrolines.txt"))

/mob/living/carbon/human/species/elf/dark/drowraider
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_DROW)
	ambushable = FALSE
	dodgetime = 30
	d_intent = INTENT_DODGE


/mob/living/carbon/human/species/elf/dark/drowraider/ambush
	threat_point = THREAT_TOUGH
	ambush_faction = "underdark"

// Testing-only subtype: forced whip loadout to verify NPC reach handling on weapons with reach > 1.
/mob/living/carbon/human/species/elf/dark/drowraider/whip_test

/mob/living/carbon/human/species/elf/dark/drowraider/whip_test/after_creation()
	..()
	for(var/obj/item/I in held_items)
		qdel(I)
	put_in_active_hand(new /obj/item/rogueweapon/whip(src))

// Testing-only subtype: forced spear loadout (reach 2) to verify polearm reach handling.
/mob/living/carbon/human/species/elf/dark/drowraider/spear_test

/mob/living/carbon/human/species/elf/dark/drowraider/spear_test/after_creation()
	..()
	for(var/obj/item/I in held_items)
		qdel(I)
	put_in_active_hand(new /obj/item/rogueweapon/spear(src))

// Testing-only subtype: forced short sword loadout (reach 1) as a baseline control.
/mob/living/carbon/human/species/elf/dark/drowraider/sword_test

/mob/living/carbon/human/species/elf/dark/drowraider/sword_test/after_creation()
	..()
	for(var/obj/item/I in held_items)
		qdel(I)
	put_in_active_hand(new /obj/item/rogueweapon/sword/short(src))

// Testing-only subtype: empty-handed spawn. Use to verify find_weapon pickup behavior —
// drop a rogueweapon nearby and watch them path to it.
/mob/living/carbon/human/species/elf/dark/drowraider/disarmed_test

/mob/living/carbon/human/species/elf/dark/drowraider/disarmed_test/after_creation()
	..()
	for(var/obj/item/I in held_items)
		qdel(I)



/mob/living/carbon/human/species/elf/dark/drowraider/Initialize()
	. = ..()
	set_species(/datum/species/elf/dark/raider)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)


/mob/living/carbon/human/species/elf/dark/drowraider/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.drowraider_aggro, TRUE)
	job = "Drow Raider"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DODGEEXPERT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/elf/dark/drowraider)
	if(prob(40))
		gender = MALE
	else
		gender = FEMALE
	regenerate_icons()

	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/organ/ears/organ_ears = getorgan(/obj/item/organ/ears)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/himecut,
						/datum/sprite_accessory/hair/head/countryponytailalt,
						/datum/sprite_accessory/hair/head/stacy,
						/datum/sprite_accessory/hair/head/kusanagi_alt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher,
						/datum/sprite_accessory/hair/head/dave,
						/datum/sprite_accessory/hair/head/emo,
						/datum/sprite_accessory/hair/head/sabitsuki,
						/datum/sprite_accessory/hair/head/sabitsuki_ponytail))

	var/datum/bodypart_feature/hair/head/new_hair = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)

	new_hair.accessory_colors = "#DDDDDD"
	new_hair.hair_color = "#DDDDDD"
	hair_color = "#DDDDDD"

	head.add_bodypart_feature(new_hair)
	head.sellprice = 40

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#FFBF00"
		organ_eyes.accessory_colors = "#FFBF00#FFBF00"

	if(organ_ears)
		organ_ears.accessory_colors = "#5f5f70"

	skin_tone = "5f5f70"

	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/rt/names/elf/elfdf.txt"))
	else
		real_name = pick(world.file2list("strings/rt/names/elf/elfdm.txt"))

	faction += "spider_lowers"

	update_hair()
	update_body()


/datum/outfit/job/roguetown/human/species/elf/dark/drowraider/pre_equip(mob/living/carbon/human/H)
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/drowraider
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest/drowraider
	shirt = /obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock/drowraider
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/facemask
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	// Stopgap: archer roll removed because the ranged NPC AI is unreliable.
	if(prob(45)) // whip
		r_hand = /obj/item/rogueweapon/whip
	else if(prob(50)) // dual falx
		r_hand = /obj/item/rogueweapon/sword/falx/stalker
		l_hand = /obj/item/rogueweapon/sword/falx/stalker
	else // dual dirk
		r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/corroded/dirk
		l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/corroded/dirk

	H.STASTR = 12 // 6 Points
	H.STASPD = 13 // 3 points
	H.STACON = 9
	H.STAWIL = 8
	H.STAPER = 10
	H.STAINT = 10
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/mob/living/carbon/human/species/elf/dark/drowraider/archer
	ai_controller = /datum/ai_controller/human_npc/archer

/mob/living/carbon/human/species/elf/dark/drowraider/archer/ambush
	threat_point = THREAT_TOUGH
	ambush_faction = "underdark"

/mob/living/carbon/human/species/elf/dark/drowraider/archer/after_creation()
	..()
	for(var/obj/item/I in held_items)
		qdel(I)
	for(var/obj/item/I in get_equipped_items(FALSE))
		if(istype(I, /obj/item/gun) || istype(I, /obj/item/quiver))
			qdel(I)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/elf/dark/drowraider/archer)

/datum/outfit/job/roguetown/human/species/elf/dark/drowraider/archer/pre_equip(mob/living/carbon/human/H)
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants/drowraider
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/shadowvest/drowraider
	shirt = /obj/item/clothing/suit/roguetown/shirt/shadowshirt/elflock/drowraider
	gloves = /obj/item/clothing/gloves/roguetown/fingerless/shadowgloves/elflock
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
	mask = /obj/item/clothing/mask/rogue/facemask
	neck = /obj/item/clothing/neck/roguetown/coif/heavypadding
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve
	backl = /obj/item/quiver/arrows
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/corroded/dirk
	H.STASTR = 10
	H.STASPD = 13
	H.STACON = 9
	H.STAWIL = 8
	H.STAPER = 13
	H.STAINT = 10
	H.adjust_skillrank(/datum/skill/combat/bows, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
