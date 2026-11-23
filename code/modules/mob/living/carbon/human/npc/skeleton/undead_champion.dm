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
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/ancient
	armor = /obj/item/clothing/suit/roguetown/armor/plate/ancient
	pants = /obj/item/clothing/under/roguetown/platelegs/ancient
	shoes = /obj/item/clothing/shoes/roguetown/boots/ancient
	gloves = /obj/item/clothing/gloves/roguetown/plate/ancient
	wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient
	neck = /obj/item/clothing/neck/roguetown/gorget/ancient
	head = /obj/item/clothing/head/roguetown/helmet/heavy/knight/ancient

/datum/outfit/job/roguetown/undead_champion/khopesh/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
	r_hand = /obj/item/rogueweapon/sword/sabre/ancient
	l_hand = /obj/item/rogueweapon/shield/tower/ancient

/datum/outfit/job/roguetown/undead_champion/greatsword/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_EXPERT, TRUE)
	r_hand = /obj/item/rogueweapon/greatsword/ancient

/datum/outfit/job/roguetown/undead_champion/bardiche/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
	r_hand = /obj/item/rogueweapon/halberd/bardiche/ancient

/datum/outfit/job/roguetown/undead_champion/spear/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_EXPERT, TRUE)
	r_hand = /obj/item/rogueweapon/spear/ancient

/datum/outfit/job/roguetown/undead_champion/mace/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_EXPERT, TRUE)
	r_hand = /obj/item/rogueweapon/mace/ancient
	l_hand = /obj/item/rogueweapon/shield/tower/ancient

/datum/outfit/job/roguetown/undead_champion/grand_mace/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_EXPERT, TRUE)
	r_hand = /obj/item/rogueweapon/mace/goden/ancient
