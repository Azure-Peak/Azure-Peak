/mob/living/carbon/human/species/goblin/npc/conjured
	gob_outfit = /datum/outfit/job/roguetown/npc/goblin/conjured
	var/datum/weakref/summoner_ref
	var/arcane_scale = 3
	var/gear_tier = 1
	var/loadout = "raider"

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
	var/tier = 1
	var/loadout = "raider"
	if(istype(H, /mob/living/carbon/human/species/goblin/npc/conjured))
		var/mob/living/carbon/human/species/goblin/npc/conjured/G = H
		tier = G.gear_tier
		loadout = G.loadout
	H.STASTR = 8 + tier
	H.STACON = 4 + tier
	H.STAWIL = 4 + tier
	H.STAPER = 7
	var/skill = clamp(tier * 2, 2, 4)
	H.adjust_skillrank_up_to(/datum/skill/combat/polearms, skill, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/axes, skill, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/maces, skill, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/swords, skill, TRUE)
	H.adjust_skillrank_up_to(/datum/skill/combat/unarmed, skill, TRUE)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/goblin
	head = /obj/item/clothing/head/roguetown/helmet/goblin
	neck = null
	l_hand = null
	switch(loadout)
		if("shieldwall")
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, skill, TRUE)
			r_hand = /obj/item/rogueweapon/mace
			l_hand = /obj/item/rogueweapon/shield/wood
		if("sling")
			H.adjust_skillrank_up_to(/datum/skill/combat/slings, skill, TRUE)
			r_hand = null
			wrists = /obj/item/gun/ballistic/revolver/grenadelauncher/sling
			neck = /obj/item/quiver/sling/stone
			H.STACON -= 1
			H.STAWIL -= 1
			H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
		if("flail")
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, skill, TRUE)
			H.adjust_skillrank_up_to(/datum/skill/combat/whipsflails, skill, TRUE)
			r_hand = /obj/item/rogueweapon/flail/aflail
			l_hand = /obj/item/rogueweapon/shield/wood
		if("spear")
			r_hand = /obj/item/rogueweapon/spear/stone
		if("bow")
			H.adjust_skillrank_up_to(/datum/skill/combat/bows, skill, TRUE)
			r_hand = /obj/item/gun/ballistic/revolver/grenadelauncher/bow
			backl = /obj/item/quiver/conjured_stone
			H.STACON -= 1
			H.STAWIL -= 1
			H.upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
		else
			H.adjust_skillrank_up_to(/datum/skill/combat/shields, skill, TRUE)
			r_hand = /obj/item/rogueweapon/sword/short/ashort
			l_hand = /obj/item/rogueweapon/shield/wood
