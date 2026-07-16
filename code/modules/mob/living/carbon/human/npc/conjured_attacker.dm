/mob/living/carbon/human/species/human/northern/conjured_attacker
	ai_controller = /datum/ai_controller/human_npc/melee
	d_intent = INTENT_DODGE
	faction = list(FACTION_NEUTRAL)
	ambushable = FALSE
	dodgetime = 20
	var/loadout = "sabre"
	var/arcane_scale = 3
	var/gear_tier = 1
	var/datum/weakref/summoner_ref

/mob/living/carbon/human/species/human/northern/conjured_attacker/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/conjured_attacker/proc/outfit_attacker(datum/outfit/outfit)
	if(!outfit)
		return
	equipOutfit(outfit)
	for(var/obj/item/gear in (get_equipped_items() + held_items))
		ADD_TRAIT(gear, TRAIT_NODROP, TRAIT_GENERIC)

/mob/living/carbon/human/species/human/northern/conjured_attacker/Destroy()
	release_conjured_gear()
	return ..()

/mob/living/carbon/human/species/human/northern/conjured_attacker/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Conjured Rogue"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NODISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUSTABLE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUST_DELETE_GEAR, TRAIT_GENERIC)
	var/mob/living/master = summoner_ref?.resolve()
	if(master)
		if(master.mind && master.mind.current)
			master = master.mind.current
		summoner = master.real_name
		faction = list("[master.real_name]_faction")
		apply_fellowship_faction(master, src)
	switch(loadout)
		if("axe")
			outfit_attacker(new /datum/outfit/job/roguetown/conjured_attacker/axe)
		if("rapier")
			outfit_attacker(new /datum/outfit/job/roguetown/conjured_attacker/rapier)
		if("dagger")
			outfit_attacker(new /datum/outfit/job/roguetown/conjured_attacker/dagger)
		if("hammer")
			outfit_attacker(new /datum/outfit/job/roguetown/conjured_attacker/hammer)
		else
			outfit_attacker(new /datum/outfit/job/roguetown/conjured_attacker/sabre)
	def_intent_change(INTENT_DODGE)
	ADD_TRAIT(src, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	random_voice_NPC()
	random_hair_NPC()
	random_eye_color_NPC()
	correct_features_NPC()
	update_hair()
	update_body()
	regenerate_icons()

/datum/outfit/job/roguetown/conjured_attacker/proc/attacker_tier(mob/living/carbon/human/H)
	if(istype(H, /mob/living/carbon/human/species/human/northern/conjured_attacker))
		var/mob/living/carbon/human/species/human/northern/conjured_attacker/A = H
		return A.gear_tier
	return 1

/datum/outfit/job/roguetown/conjured_attacker/proc/attacker_skill(mob/living/carbon/human/H)
	var/lvl = 3
	if(istype(H, /mob/living/carbon/human/species/human/northern/conjured_attacker))
		var/mob/living/carbon/human/species/human/northern/conjured_attacker/A = H
		lvl = clamp(A.arcane_scale, 1, 6)
	return clamp(max(lvl, SKILL_LEVEL_JOURNEYMAN), SKILL_LEVEL_JOURNEYMAN, 6)

/datum/outfit/job/roguetown/conjured_attacker/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/tier = attacker_tier(H)
	var/skill = attacker_skill(H)
	H.STASTR = 10
	H.STASPD = 10 + tier
	H.STACON = 10 + tier
	H.STAWIL = 10 + tier
	H.STAPER = 10 + tier
	H.STAINT = 10
	H.STALUC = 10
	H.adjust_skillrank(/datum/skill/combat/unarmed, skill, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, skill, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	mask = /obj/item/clothing/mask/rogue/padded
	head = /obj/item/clothing/head/roguetown/helmet/leather
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	belt = /obj/item/storage/belt/rogue/leather
	if(tier >= 2)
		armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat

/datum/outfit/job/roguetown/conjured_attacker/sabre/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/skill = attacker_skill(H)
	H.adjust_skillrank(/datum/skill/combat/swords, skill, TRUE)
	r_hand = /obj/item/rogueweapon/sword/sabre
	l_hand = /obj/item/rogueweapon/sword/sabre

/datum/outfit/job/roguetown/conjured_attacker/rapier/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/skill = attacker_skill(H)
	H.adjust_skillrank(/datum/skill/combat/swords, skill, TRUE)
	r_hand = /obj/item/rogueweapon/sword/rapier
	l_hand = /obj/item/rogueweapon/sword/rapier

/datum/outfit/job/roguetown/conjured_attacker/dagger/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/skill = attacker_skill(H)
	H.adjust_skillrank(/datum/skill/combat/knives, skill, TRUE)
	r_hand = /obj/item/rogueweapon/huntingknife/idagger
	l_hand = /obj/item/rogueweapon/huntingknife/idagger

/datum/outfit/job/roguetown/conjured_attacker/axe/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/skill = attacker_skill(H)
	H.adjust_skillrank(/datum/skill/combat/axes, skill, TRUE)
	r_hand = /obj/item/rogueweapon/stoneaxe/battle
	l_hand = /obj/item/rogueweapon/stoneaxe/battle

/datum/outfit/job/roguetown/conjured_attacker/hammer/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	var/skill = attacker_skill(H)
	H.adjust_skillrank(/datum/skill/combat/maces, skill, TRUE)
	r_hand = /obj/item/rogueweapon/mace/warhammer
	l_hand = /obj/item/rogueweapon/mace/warhammer
