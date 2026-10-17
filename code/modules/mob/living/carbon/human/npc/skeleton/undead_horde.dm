/mob/living/carbon/human/species/skeleton/conjured/undead/horde
	undead_job = "Undead Horde"

/datum/outfit/job/roguetown/undead_horde/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.STASTR = 10
	H.STASPD = 10
	H.STACON = 10
	H.STAWIL = 10
	H.STAPER = 10
	H.STAINT = 10
	H.STALUC = 10
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/aalloy
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/aalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/aalloy
	gloves = /obj/item/clothing/gloves/roguetown/chain/aalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/aalloy
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron/aalloy
	head = /obj/item/clothing/head/roguetown/helmet/kettle/aalloy

/datum/outfit/job/roguetown/undead_horde/khopesh/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
	r_hand = /obj/item/rogueweapon/sword/sabre/alloy
	l_hand = /obj/item/rogueweapon/shield/tower/metal/alloy

/datum/outfit/job/roguetown/undead_horde/greatsword/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
	r_hand = /obj/item/rogueweapon/greatsword/aalloy

/datum/outfit/job/roguetown/undead_horde/bardiche/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
	r_hand = /obj/item/rogueweapon/halberd/bardiche/aalloy

/datum/outfit/job/roguetown/undead_horde/spear/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
	r_hand = /obj/item/rogueweapon/spear/aalloy

/datum/outfit/job/roguetown/undead_horde/mace/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
	r_hand = /obj/item/rogueweapon/mace/alloy
	l_hand = /obj/item/rogueweapon/shield/tower/metal/alloy

/datum/outfit/job/roguetown/undead_horde/crossbow/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.STAPER = 12
	H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/aalloy
	backl = /obj/item/quiver/bolt/conjured
