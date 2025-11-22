/datum/job/roguetown/goblinguard
	title = "Goblin Guard"
	flag = GOBLINGUARD
	department_flag = GOBLIN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(SPEC_ID_GOBLINP)
	allowed_patrons = list(/datum/patron/inhumen/graggar)
	tutorial = "Goblin Guards rensposible for their kingdom and his majesty King."
	display_order = JDO_GOBLINGUARD
	outfit = /datum/outfit/job/roguetown/goblinguard
	min_pq = 1
	max_pq = null

/datum/outfit/job/roguetown/goblinguard/pre_equip(mob/living/carbon/human/H)
	. = ..()
	head = /obj/item/clothing/head/roguetown/helmet/leather/goblin
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
	belt = /obj/item/storage/belt/rogue/leather
	backr = /obj/item/storage/backpack/rogue/satchel
	backpack_contents = list(/obj/item/rope/chain = 1)
	H.verbs |= /mob/proc/haltyell
	ADD_TRAIT(H, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE) // Town guards have stronger street skills then castle guards.
	H.adjust_skillrank(/datum/skill/combat/bows, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 2 , TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3 , TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/medicine, 1, TRUE)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_PER, 2)
	H.change_stat(STATKEY_CON, 1)
	H.change_stat(STATKEY_WIL, 1)
	H.change_stat(STATKEY_INT, -1)
