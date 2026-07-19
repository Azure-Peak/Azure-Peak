/mob/living/carbon/human/species/human/northern/conjured_peasant
	ai_controller = /datum/ai_controller/human_npc/melee
	d_intent = INTENT_PARRY
	faction = list(FACTION_NEUTRAL)
	dodgetime = 25
	var/loadout = "pitchfork"
	var/arcane_scale = 3
	var/gear_tier = 1
	var/datum/weakref/summoner_ref

/mob/living/carbon/human/species/human/northern/conjured_peasant/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/conjured_peasant/proc/outfit_peasant(datum/outfit/outfit)
	if(!outfit)
		return
	equipOutfit(outfit)
	for(var/obj/item/gear in (get_equipped_items() + held_items))
		ADD_TRAIT(gear, TRAIT_NODROP, TRAIT_GENERIC)

/mob/living/carbon/human/species/human/northern/conjured_peasant/Destroy()
	release_conjured_gear()
	return ..()

/mob/living/carbon/human/species/human/northern/conjured_peasant/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	job = "Conjured Levy"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BADTRAINER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
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
		if("scythe")
			outfit_peasant(new /datum/outfit/job/roguetown/conjured_peasant/scythe)
		if("thresher")
			outfit_peasant(new /datum/outfit/job/roguetown/conjured_peasant/thresher)
		if("woodcutter")
			outfit_peasant(new /datum/outfit/job/roguetown/conjured_peasant/woodcutter)
		if("maciejowski")
			outfit_peasant(new /datum/outfit/job/roguetown/conjured_peasant/maciejowski)
		if("club")
			outfit_peasant(new /datum/outfit/job/roguetown/conjured_peasant/club)
		else
			outfit_peasant(new /datum/outfit/job/roguetown/conjured_peasant/pitchfork)
	def_intent_change(INTENT_PARRY)
	random_voice_NPC()
	random_hair_NPC()
	random_eye_color_NPC()
	correct_features_NPC()
	update_hair()
	update_body()
	regenerate_icons()

/datum/outfit/job/roguetown/conjured_peasant/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.STASTR = 10
	H.STASPD = 11
	H.STACON = 10
	H.STAWIL = 10
	H.STAPER = 10
	H.STAINT = 10
	H.STALUC = 10
	H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	cloak = /obj/item/clothing/cloak/tabard/stabard/bog/levy
	head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	neck = /obj/item/clothing/neck/roguetown/coif
	mask = /obj/item/clothing/mask/rogue/facemask
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots
	gloves = /obj/item/clothing/gloves/roguetown/leather

/datum/outfit/job/roguetown/conjured_peasant/pitchfork/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	r_hand = /obj/item/rogueweapon/spear/militia

/datum/outfit/job/roguetown/conjured_peasant/scythe/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	r_hand = /obj/item/rogueweapon/scythe/militia

/datum/outfit/job/roguetown/conjured_peasant/thresher/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	r_hand = /obj/item/rogueweapon/flail/militia

/datum/outfit/job/roguetown/conjured_peasant/woodcutter/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	r_hand = /obj/item/rogueweapon/greataxe/militia

/datum/outfit/job/roguetown/conjured_peasant/maciejowski/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	r_hand = /obj/item/rogueweapon/sword/falchion/militia

/datum/outfit/job/roguetown/conjured_peasant/club/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	r_hand = /obj/item/rogueweapon/mace/woodclub/militia
