/mob/living/carbon/human/species/skeleton/conjured/undead/champion
	skel_fragile = FALSE
	undead_job = "Undead Champion"

/datum/outfit/job/roguetown/undead_champion/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.STASTR = 12
	H.STASPD = 11
	H.STACON = 13
	H.STAWIL = 13
	H.STAPER = 10
	H.STAINT = 10
	H.STALUC = 10
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/wrestling, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/swimming, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/misc/climbing, SKILL_LEVEL_JOURNEYMAN, TRUE)
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/paalloy
	armor = /obj/item/clothing/suit/roguetown/armor/plate/paalloy
	pants = /obj/item/clothing/under/roguetown/platelegs/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/paalloy
	gloves = /obj/item/clothing/gloves/roguetown/plate/paalloy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	neck = /obj/item/clothing/neck/roguetown/gorget/paalloy
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/paalloy

/datum/outfit/job/roguetown/undead_champion/khopesh/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
	r_hand = /obj/item/rogueweapon/sword/sabre/palloy
	l_hand = /obj/item/rogueweapon/shield/tower/metal/palloy

/datum/outfit/job/roguetown/undead_champion/greatsword/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
	r_hand = /obj/item/rogueweapon/greatsword/paalloy

/datum/outfit/job/roguetown/undead_champion/bardiche/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
	r_hand = /obj/item/rogueweapon/halberd/bardiche/paalloy

/datum/outfit/job/roguetown/undead_champion/spear/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
	r_hand = /obj/item/rogueweapon/spear/paalloy

/datum/outfit/job/roguetown/undead_champion/mace/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
	r_hand = /obj/item/rogueweapon/mace/steel/palloy
	l_hand = /obj/item/rogueweapon/shield/tower/metal/palloy

/datum/outfit/job/roguetown/undead_champion/grand_mace/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
	r_hand = /obj/item/rogueweapon/mace/goden/steel/paalloy
