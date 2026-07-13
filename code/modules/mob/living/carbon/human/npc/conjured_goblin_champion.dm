/mob/living/carbon/human/species/goblin/npc/conjured/champion
	gob_outfit = /datum/outfit/job/roguetown/conjured_goblin_champion
	d_intent = INTENT_PARRY
	dodgetime = 25
	var/loadout = "brute"

/mob/living/carbon/human/species/goblin/npc/conjured/champion/after_creation()
	..()
	name = "phantasmal goblin champion"
	real_name = "phantasmal goblin champion"
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.large_goblin_aggro, TRUE)
	ADD_TRAIT(src, TRAIT_BIGGUY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NODISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	REMOVE_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	src.transform = src.transform.Scale(1.25, 1.25)
	src.pixel_y += round(0.25 * 16)

/datum/outfit/job/roguetown/conjured_goblin_champion/proc/goblin_tier(mob/living/carbon/human/H)
	if(istype(H, /mob/living/carbon/human/species/goblin/npc/conjured/champion))
		var/mob/living/carbon/human/species/goblin/npc/conjured/champion/G = H
		return G.gear_tier
	return 1

/datum/outfit/job/roguetown/conjured_goblin_champion/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/lvl = 3
	var/loadout = "brute"
	var/tier = goblin_tier(H)
	if(istype(H, /mob/living/carbon/human/species/goblin/npc/conjured/champion))
		var/mob/living/carbon/human/species/goblin/npc/conjured/champion/G = H
		lvl = clamp(G.arcane_scale, 1, 6)
		loadout = G.loadout
	var/stat_bonus = (tier == 3) ? 4 : ((tier == 2) ? 2 : 0)
	var/skill = clamp(1 + round(lvl / 2) + (tier - 1), 2, 4)
	H.STASTR = 12 + tier
	H.STASPD = 11
	H.STACON = 12 + lvl + stat_bonus
	H.STAWIL = 10 + lvl + (tier - 1)
	H.STAPER = 6
	H.STAINT = 8
	H.STALUC = 4
	H.adjust_skillrank(/datum/skill/combat/maces, skill, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, skill, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, skill, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, skill, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, skill, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, max(skill - 1, 2), TRUE)
	if(tier >= 2)
		armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/goblin
		head = /obj/item/clothing/head/roguetown/helmet/goblin
	else
		armor = /obj/item/clothing/suit/roguetown/armor/leather/hide/goblin
		head = /obj/item/clothing/head/roguetown/helmet/leather/goblin
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	switch(loadout)
		if("berserker")
			r_hand = (tier == 3) ? /obj/item/rogueweapon/greataxe/steel : /obj/item/rogueweapon/greataxe/militia
		if("flailman")
			r_hand = /obj/item/rogueweapon/flail
			l_hand = (tier >= 2) ? /obj/item/rogueweapon/shield/tower/metal : /obj/item/rogueweapon/shield/wood
		else
			r_hand = /obj/item/rogueweapon/mace
			l_hand = (tier >= 2) ? /obj/item/rogueweapon/shield/tower/metal : /obj/item/rogueweapon/shield/wood
