/datum/job/roguetown/goblinsmith
	title = "Goblin Smith"
	flag = GOBLINSMITH
	department_flag = GOBLIN
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = list(SPEC_ID_GOBLINP)
	allowed_patrons = list(/datum/patron/inhumen/graggar)
	tutorial = "Goblin rensposible for fresh iron and steel"
	display_order = JDO_GOBLINSMITH
	outfit = /datum/outfit/job/roguetown/goblinsmith
	job_traits = list(TRAIT_SMITHING_EXPERT)
	min_pq = 0
	max_pq = null

/datum/outfit/job/roguetown/goblinsmith/pre_equip(mob/living/carbon/human/H)
	..()
	armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
	belt = /obj/item/storage/belt/rogue/leather
	neck = /obj/item/storage/belt/rogue/pouch/coins/poor
	cloak = /obj/item/clothing/cloak/apron/blacksmith
	backl = /obj/item/storage/backpack/rogue/satchel

	H.adjust_skillrank(/datum/skill/combat/knives, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, pick(0,0,1), TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, pick(1,1,2), TRUE)
	H.adjust_skillrank(/datum/skill/craft/crafting, 2 , TRUE)
	H.adjust_skillrank(/datum/skill/craft/masonry, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/engineering, pick(2,2,3), TRUE)
	H.adjust_skillrank(/datum/skill/craft/sewing, pick(1,1,2), TRUE)
	H.adjust_skillrank(/datum/skill/craft/traps, pick(1,1,2), TRUE)
	H.adjust_skillrank(/datum/skill/craft/blacksmithing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/armorsmithing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/weaponsmithing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/craft/carpentry, 3, TRUE)
	H.change_stat(STATKEY_STR, 1)
	H.change_stat(STATKEY_WIL, 1)
	H.change_stat(STATKEY_SPD, -2)
