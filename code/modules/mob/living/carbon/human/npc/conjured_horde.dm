/mob/living/carbon/human/species/goblin/npc/conjured
	gob_outfit = /datum/outfit/job/roguetown/npc/goblin/conjured
	var/datum/weakref/summoner_ref
	var/arcane_scale = 3
	var/gear_tier = 1

/mob/living/carbon/human/species/goblin/npc/conjured/after_creation()
	..()
	name = "phantasmal goblin"
	real_name = "phantasmal goblin"
	var/mob/living/master = summoner_ref?.resolve()
	if(master)
		if(master.mind && master.mind.current)
			master = master.mind.current
		summoner = master.real_name
		faction = list("[master.real_name]_faction")
		apply_fellowship_faction(master, src)
	for(var/obj/item/gear in (get_equipped_items() + held_items))
		ADD_TRAIT(gear, TRAIT_NODROP, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUSTABLE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUST_DELETE_GEAR, TRAIT_GENERIC)

/mob/living/carbon/human/species/goblin/npc/conjured/Destroy()
	release_conjured_gear()
	return ..()

/datum/outfit/job/roguetown/npc/goblin/conjured/pre_equip(mob/living/carbon/human/H)
	..()
	var/lvl = 3
	var/tier = 1
	if(istype(H, /mob/living/carbon/human/species/goblin/npc/conjured))
		var/mob/living/carbon/human/species/goblin/npc/conjured/G = H
		lvl = clamp(G.arcane_scale, 1, 6)
		tier = G.gear_tier
	H.STASTR = 8 + round(lvl / 2) + (tier - 1)
	H.STACON = 5 + round(lvl / 3) + (tier - 1)
	H.STAWIL = 5 + round(lvl / 3) + (tier - 1)
	var/skill = clamp(1 + round(lvl / 2) + (tier - 1), 2, 4)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, skill, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/axes, skill, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, skill, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, skill, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, skill, TRUE)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/goblin
	head = /obj/item/clothing/head/roguetown/helmet/goblin
	neck = null
	l_hand = null
	switch(rand(1, 3))
		if(1)
			r_hand = /obj/item/rogueweapon/spear/stone
		if(2)
			r_hand = /obj/item/rogueweapon/stoneaxe
		if(3)
			r_hand = /obj/item/rogueweapon/mace/woodclub
