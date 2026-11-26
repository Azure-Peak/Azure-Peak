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
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/ancient/decrepit
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt/ancient/decrepit
	shoes = /obj/item/clothing/shoes/roguetown/boots/ancient/decrepit
	gloves = /obj/item/clothing/gloves/roguetown/chain/ancient/decrepit
	wrists = /obj/item/clothing/wrists/roguetown/bracers/ancient/decrepit
	neck = /obj/item/clothing/neck/roguetown/chaincoif/ancient/decrepit
	head = /obj/item/clothing/head/roguetown/helmet/kettle/ancient/decrepit

/datum/outfit/job/roguetown/undead_horde/khopesh/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
	r_hand = /obj/item/rogueweapon/sword/sabre/ancient/decrepit
	l_hand = /obj/item/rogueweapon/shield/tower/ancient/decrepit

/datum/outfit/job/roguetown/undead_horde/greatsword/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, SKILL_LEVEL_JOURNEYMAN, TRUE)
	r_hand = /obj/item/rogueweapon/greatsword/ancient/decrepit

/datum/outfit/job/roguetown/undead_horde/bardiche/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
	r_hand = /obj/item/rogueweapon/halberd/bardiche/ancient/decrepit

/datum/outfit/job/roguetown/undead_horde/spear/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, SKILL_LEVEL_JOURNEYMAN, TRUE)
	r_hand = /obj/item/rogueweapon/spear/ancient/decrepit

/datum/outfit/job/roguetown/undead_horde/mace/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/shields, SKILL_LEVEL_JOURNEYMAN, TRUE)
	r_hand = /obj/item/rogueweapon/mace/ancient/decrepit
	l_hand = /obj/item/rogueweapon/shield/tower/ancient/decrepit

/datum/outfit/job/roguetown/undead_horde/crossbow/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.STAPER = 12
	H.adjust_skillrank_up_to(/datum/skill/combat/crossbows, SKILL_LEVEL_JOURNEYMAN, TRUE)
	H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/ancient
	backl = /obj/item/quiver/bolt/conjured
