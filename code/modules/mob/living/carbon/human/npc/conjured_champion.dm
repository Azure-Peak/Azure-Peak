/mob/living/carbon/human/species/human/northern/conjured_champion
	ai_controller = /datum/ai_controller/human_npc/melee
	d_intent = INTENT_PARRY
	faction = list(FACTION_NEUTRAL)
	ambushable = FALSE
	dodgetime = 25
	var/loadout = "swordsman"
	var/arcane_scale = 3
	var/gear_tier = 1
	var/datum/weakref/summoner_ref

/mob/living/carbon/human/species/human/northern/conjured_champion/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/conjured_champion/proc/outfit_champion(datum/outfit/outfit)
	if(!outfit)
		return
	equipOutfit(outfit)
	for(var/obj/item/gear in (get_equipped_items() + held_items))
		ADD_TRAIT(gear, TRAIT_NODROP, TRAIT_GENERIC)

/mob/living/carbon/human/species/human/northern/conjured_champion/Destroy()
	release_conjured_gear()
	return ..()

/mob/living/carbon/human/species/human/northern/conjured_champion/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Conjured Champion"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NODISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUSTABLE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUST_DELETE_GEAR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	var/mob/living/master = summoner_ref?.resolve()
	if(master)
		if(master.mind && master.mind.current)
			master = master.mind.current
		summoner = master.real_name
		faction = list("[master.real_name]_faction")
		apply_fellowship_faction(master, src)
	switch(loadout)
		if("swordsman")
			outfit_champion(new /datum/outfit/job/roguetown/conjured_champion/swordsman)
			def_intent_change(INTENT_PARRY)
		if("archer")
			upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
			outfit_champion(new /datum/outfit/job/roguetown/conjured_champion/archer)
			def_intent_change(INTENT_DODGE)
		if("xbowman")
			upgrade_ai_controller(/datum/ai_controller/human_npc/archer)
			outfit_champion(new /datum/outfit/job/roguetown/conjured_champion/xbowman)
			def_intent_change(INTENT_DODGE)
		if("greataxeman")
			outfit_champion(new /datum/outfit/job/roguetown/conjured_champion/greataxeman)
			def_intent_change(INTENT_PARRY)
		if("axeman")
			outfit_champion(new /datum/outfit/job/roguetown/conjured_champion/axeman)
			def_intent_change(INTENT_PARRY)
		if("spearman")
			outfit_champion(new /datum/outfit/job/roguetown/conjured_champion/spearman)
			def_intent_change(INTENT_PARRY)
		if("maceman")
			outfit_champion(new /datum/outfit/job/roguetown/conjured_champion/maceman)
			def_intent_change(INTENT_PARRY)
		else
			outfit_champion(new /datum/outfit/job/roguetown/conjured_champion/greatswordman)
			def_intent_change(INTENT_PARRY)
	random_voice_NPC()
	random_hair_NPC()
	random_eye_color_NPC()
	correct_features_NPC()
	update_hair()
	update_body()
	regenerate_icons()

/datum/outfit/job/roguetown/conjured_champion/proc/champion_tier(mob/living/carbon/human/H)
	if(istype(H, /mob/living/carbon/human/species/human/northern/conjured_champion))
		var/mob/living/carbon/human/species/human/northern/conjured_champion/C = H
		return C.gear_tier
	return 1

/datum/outfit/job/roguetown/conjured_champion/proc/champion_skill(mob/living/carbon/human/H)
	var/lvl = 3
	if(istype(H, /mob/living/carbon/human/species/human/northern/conjured_champion))
		var/mob/living/carbon/human/species/human/northern/conjured_champion/C = H
		lvl = clamp(C.arcane_scale, 1, 6)
	var/skill_floor = SKILL_LEVEL_JOURNEYMAN
	if(champion_tier(H) == 3)
		skill_floor = SKILL_LEVEL_EXPERT
	return clamp(max(lvl, skill_floor), skill_floor, 6)

/datum/outfit/job/roguetown/conjured_champion/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/tier = champion_tier(H)
	var/skill = champion_skill(H)
	H.STASTR = 10 + tier
	H.STASPD = 11 // To prevent NPC following problem
	H.STACON = 11 + tier
	H.STAWIL = 11 + tier
	H.STAPER = 10
	H.STAINT = 10
	H.STALUC = 10
	H.adjust_skillrank(/datum/skill/combat/unarmed, skill, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, skill, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	switch(tier)
		if(2, 3)
			armor = /obj/item/clothing/suit/roguetown/armor/plate/full
			pants = /obj/item/clothing/under/roguetown/platelegs
			shoes = /obj/item/clothing/shoes/roguetown/boots/armor
			gloves = /obj/item/clothing/gloves/roguetown/plate
			head = /obj/item/clothing/head/roguetown/helmet/heavy
			neck = /obj/item/clothing/neck/roguetown/gorget
		else
			armor = /obj/item/clothing/suit/roguetown/armor/plate/full/iron
			pants = /obj/item/clothing/under/roguetown/platelegs/iron
			shoes = /obj/item/clothing/shoes/roguetown/boots/armor/iron
			gloves = /obj/item/clothing/gloves/roguetown/plate/iron
			head = /obj/item/clothing/head/roguetown/helmet/heavy/barbute/iron
			neck = /obj/item/clothing/neck/roguetown/gorget

/datum/outfit/job/roguetown/conjured_champion/swordsman/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/skill = champion_skill(H)
	var/tier = champion_tier(H)
	H.adjust_skillrank(/datum/skill/combat/swords, skill, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, skill, TRUE)
	r_hand = /obj/item/rogueweapon/sword
	l_hand = (tier >= 2) ? /obj/item/rogueweapon/shield/tower/metal : /obj/item/rogueweapon/shield/wood

/datum/outfit/job/roguetown/conjured_champion/greatswordman/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/skill = champion_skill(H)
	H.adjust_skillrank(/datum/skill/combat/swords, skill, TRUE)
	r_hand = /obj/item/rogueweapon/greatsword

/datum/outfit/job/roguetown/conjured_champion/greataxeman/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/skill = champion_skill(H)
	H.adjust_skillrank(/datum/skill/combat/axes, skill, TRUE)
	r_hand = /obj/item/rogueweapon/greataxe/steel

/datum/outfit/job/roguetown/conjured_champion/axeman/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/skill = champion_skill(H)
	var/tier = champion_tier(H)
	H.adjust_skillrank(/datum/skill/combat/axes, skill, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, skill, TRUE)
	r_hand = /obj/item/rogueweapon/stoneaxe/battle
	l_hand = (tier >= 2) ? /obj/item/rogueweapon/shield/tower/metal : /obj/item/rogueweapon/shield/wood

/datum/outfit/job/roguetown/conjured_champion/spearman/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/skill = champion_skill(H)
	H.adjust_skillrank(/datum/skill/combat/polearms, skill, TRUE)
	r_hand = /obj/item/rogueweapon/spear

/datum/outfit/job/roguetown/conjured_champion/maceman/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/skill = champion_skill(H)
	H.adjust_skillrank(/datum/skill/combat/maces, skill, TRUE)
	r_hand = /obj/item/rogueweapon/mace/maul

/datum/outfit/job/roguetown/conjured_champion/archer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/ranged_skill = min(champion_skill(H), SKILL_LEVEL_EXPERT)
	H.STAPER = 13 + champion_tier(H)
	H.adjust_skillrank(/datum/skill/combat/bows, ranged_skill, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, clamp(ranged_skill - 1, 2, 6), TRUE)
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow
	backl = /obj/item/quiver/conjured
	beltr = /obj/item/rogueweapon/sword/short/iron

/datum/outfit/job/roguetown/conjured_champion/xbowman/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/ranged_skill = min(champion_skill(H), SKILL_LEVEL_EXPERT)
	H.STAPER = 13 + champion_tier(H)
	H.adjust_skillrank(/datum/skill/combat/crossbows, ranged_skill, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, clamp(ranged_skill - 1, 2, SKILL_LEVEL_EXPERT), TRUE)
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	backl = /obj/item/quiver/bolt/conjured
	beltr = /obj/item/rogueweapon/sword/short/iron
