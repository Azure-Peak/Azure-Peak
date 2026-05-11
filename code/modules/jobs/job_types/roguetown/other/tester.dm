/datum/job/roguetown/tester
	title = "Tester"
	flag = TESTER
	department_flag = SLOP
	faction = "Station"
#ifdef TESTSERVER
	total_positions = 99
	spawn_positions = 99
#else
	total_positions = 0
	spawn_positions = 0
#endif
	min_pq = null //no pq
	allowed_sexes = list(MALE, FEMALE)
	
	tutorial = ""
	outfit = /datum/outfit/job/roguetown/tester
	plevel_req = 0
	display_order = JDO_MERCENARY

/datum/outfit/job/roguetown/tester/pre_equip(mob/living/carbon/human/H)
	..()
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	belt = /obj/item/storage/belt/rogue/leather
	armor = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
	if(prob(50))
		armor = /obj/item/clothing/suit/roguetown/armor/gambeson
	neck = /obj/item/roguekey/mercenary
	beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
	beltr = /obj/item/rogueweapon/sword/sabre
	if(prob(50))
		beltr = /obj/item/rogueweapon/sword
	shirt = /obj/item/clothing/suit/roguetown/shirt/shortshirt/merc
	pants = /obj/item/clothing/under/roguetown/trou/leather
	neck = /obj/item/clothing/neck/roguetown/gorget
	if(should_wear_femme_clothes(H))
		pants = /obj/item/clothing/under/roguetown/tights/black
		beltr = /obj/item/rogueweapon/sword/sabre
	H.adjust_skillrank(/datum/skill/misc/swimming, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/combat/bows, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/combat/crossbows, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, rand(1,5), TRUE)
	H.adjust_skillrank(/datum/skill/misc/reading, rand(1,5), TRUE)
	H.change_stat(STATKEY_STR, 1)
