/mob/living/carbon/human/species/elf/dark/drowraider/scourge
	threat_point = THREAT_ELITE
	dodgetime = 20
	drowraider_outfit = /datum/outfit/job/roguetown/human/species/elf/dark/drowraider/scourge

/mob/living/carbon/human/species/elf/dark/drowraider/scourge/after_creation()
	..()
	job = "Drow Scourge"
	real_name = "[real_name] [pick("the Scourge", "the Lasher", "the Venomed", "the Spiderkin", "the Flenser")]"
	name = real_name
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	for(var/obj/item/gear in get_equipped_items() + held_items)
		lock_gear_piece(gear, "drow_scourge_gear")

/mob/living/carbon/human/species/elf/dark/drowraider/scourge/death(gibbed, nocutscene = FALSE)
	. = ..()
	for(var/obj/item/gear in get_equipped_items() + held_items)
		REMOVE_TRAIT(gear, TRAIT_NODROP, "drow_scourge_gear")

/datum/outfit/job/roguetown/human/species/elf/dark/drowraider/scourge/pre_equip(mob/living/carbon/human/H)
	..()
	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	neck = /obj/item/clothing/neck/roguetown/gorget
	mask = /obj/item/clothing/mask/rogue/shepherd/shadowmask/delf
	belt = /obj/item/storage/belt/rogue/leather/black
	r_hand = /obj/item/rogueweapon/whip/spiderwhip
	l_hand = null
	H.STASTR = 13
	H.STASPD = 13
	H.STACON = 13
	H.STAWIL = 11
	H.STAPER = 12
	H.STAINT = 10
	H.STALUC = 10
	H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, SKILL_LEVEL_MASTER, TRUE)
