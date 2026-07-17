/datum/species/hobgoblin
	name = "hobgoblin"
	id = "hobgoblin"
	species_traits = list(NO_UNDERWEAR,NOEYESPRITES)
	inherent_traits = list(TRAIT_RESISTCOLD,
		TRAIT_RESISTHIGHPRESSURE,
		TRAIT_RESISTLOWPRESSURE,
		TRAIT_RADIMMUNE,
		TRAIT_NASTY_EATER,
		TRAIT_LEECHIMMUNE,
		TRAIT_HEAVYARMOR)
	no_equip = list(SLOT_SHIRT, SLOT_WEAR_MASK, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,-2), OFFSET_HANDS_F = list(0,-2))
	damage_overlay_type = ""
	changesource_flags = MIRROR_BADMIN | WABBAJACK | MIRROR_MAGIC | MIRROR_PRIDE | RACE_SWAP | SLIME_EXTRACT
	var/raceicon = "hobgoblin"
	race_bonus = list(STAT_FORTUNE = 1)

/datum/species/hobgoblin/regenerate_icons(mob/living/carbon/human/H)
	H.icon_state = ""
	if(H.notransform)
		return 1
	H.update_inv_hands()
	H.update_inv_handcuffed()
	H.update_inv_legcuffed()
	H.update_body()
	var/mob/living/carbon/human/species/hobgoblin/G = H
	G.update_wearable()
	H.update_transform()
	return TRUE

/datum/species/hobgoblin/update_damage_overlays(mob/living/carbon/human/H)
	return

/mob/living/carbon/human/species/hobgoblin
	name = "hoblin"
	icon = 'icons/roguetown/mob/monster/hobgoblins.dmi'
	icon_state = "hobgoblin"
	race = /datum/species/hobgoblin
	gender = MALE
	blood_toll_bucket = STATS_KILLED_GOBLINS
	bodyparts = list(/obj/item/bodypart/chest/hobgoblin, /obj/item/bodypart/head/hobgoblin, /obj/item/bodypart/l_arm/hobgoblin,
					/obj/item/bodypart/r_arm/hobgoblin, /obj/item/bodypart/r_leg/hobgoblin, /obj/item/bodypart/l_leg/hobgoblin)
	rot_type = /datum/component/rot/corpse/goblin
	var/hobgob_outfit = /datum/outfit/job/roguetown/npc/hobgoblin
	ambushable = FALSE
	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	a_intent = INTENT_HELP
	possible_mmb_intents = list(INTENT_SPECIAL, INTENT_JUMP, INTENT_KICK, INTENT_BITE)

//////////////////   BODYPARTS	//////////////////
	// Dismemberable by default (unlike goblins); high CON is the counterweight.
/obj/item/bodypart/chest/hobgoblin
	max_pain_damage = 100

/obj/item/bodypart/head/hobgoblin
	max_pain_damage = 100

/obj/item/bodypart/l_arm/hobgoblin
	max_pain_damage = 75

/obj/item/bodypart/r_arm/hobgoblin
	max_pain_damage = 75

/obj/item/bodypart/l_leg/hobgoblin
	max_pain_damage = 75

/obj/item/bodypart/r_leg/hobgoblin
	max_pain_damage = 75


//////////////////   PROCS	//////////////////
/obj/item/bodypart/head/hobgoblin/update_icon_dropped()
	return

/obj/item/bodypart/head/hobgoblin/get_limb_icon(dropped, hideaux = FALSE)
	return

/mob/living/carbon/human/species/hobgoblin/update_inv_head(hide_nonstandard = FALSE)
	update_wearable()

/mob/living/carbon/human/species/hobgoblin/update_inv_armor()
	update_wearable()

/mob/living/carbon/human/species/hobgoblin/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/obj/item/bodypart/head/hobgoblin/skeletonize()
	. = ..()
	icon_state = "hobgoblin_skel_head"
	sellprice = 2


/mob/living/carbon/human/species/hobgoblin/update_body()
	remove_overlay(BODY_LAYER)
	if(!dna || !dna.species)
		return
	var/datum/species/hobgoblin/G = dna.species
	if(!istype(G))
		return
	icon_state = ""
	var/list/standing = list()
	var/mutable_appearance/body_overlay
	var/obj/item/bodypart/chesty = get_bodypart("chest")
	var/obj/item/bodypart/headdy = get_bodypart("head")
	if(!headdy)
		if(chesty && chesty.skeletonized)
			body_overlay = mutable_appearance(icon, "hobgoblin_skel_decap", -BODY_LAYER)
		else
			body_overlay = mutable_appearance(icon, "[G.raceicon]_decap", -BODY_LAYER)
	else
		if(chesty && chesty.skeletonized)
			body_overlay = mutable_appearance(icon, "hobgoblin_skel", -BODY_LAYER)
		else
			body_overlay = mutable_appearance(icon, "[G.raceicon]", -BODY_LAYER)

	if(body_overlay)
		standing += body_overlay
	if(standing.len)
		overlays_standing[BODY_LAYER] = standing

	apply_overlay(BODY_LAYER)
	dna.species.update_damage_overlays()

/mob/living/carbon/human/species/hobgoblin/proc/update_wearable()
	remove_overlay(ARMOR_LAYER)

	var/list/standing = list()
	var/mutable_appearance/body_overlay
	if(wear_armor)
		body_overlay = mutable_appearance(icon, "[wear_armor.item_state]", -ARMOR_LAYER)
		if(body_overlay)
			standing += body_overlay
	if(head)
		body_overlay = mutable_appearance(icon, "[head.item_state]", -ARMOR_LAYER)
		if(body_overlay)
			standing += body_overlay
	if(standing.len)
		overlays_standing[ARMOR_LAYER] = standing

	apply_overlay(ARMOR_LAYER)

/mob/living/carbon/human/species/hobgoblin/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	ADD_TRAIT(src, TRAIT_HARDSOLE, INNATE_TRAIT)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.goblin_aggro, TRUE)
	gender = MALE
	if(src.dna && src.dna.species)
		src.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/other/goblin]
		src.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/other/goblin]
		var/obj/item/headdy = get_bodypart("head")
		if(headdy)
			headdy.icon = 'icons/roguetown/mob/monster/hobgoblins.dmi'
			headdy.icon_state = "[src.dna.species.id]_head"
			headdy.sellprice = 40
	src.grant_language(/datum/language/orcish)
	var/obj/item/organ/eyes/eyes = src.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/nightmare
	eyes.Insert(src)
	src.underwear = "Nude"
	for(var/datum/charflaw/cf in src.charflaws)
		QDEL_NULL(cf)
	update_body()
	faction = list(FACTION_ORCS)
	name = "hoblin"
	real_name = "hoblin"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	AddComponent(/datum/component/npc_death_line, GLOB.npc_death_lines_goblin, 25)
	if(hobgob_outfit)
		var/datum/outfit/O = new hobgob_outfit
		if(O)
			equipOutfit(O)


//////////////////   OUTFITS	//////////////////

/datum/outfit/job/roguetown/npc/hobgoblin/pre_equip(mob/living/carbon/human/H)
	..()
	H.STASTR = 9
	H.STAINT = 5
	H.STACON = 10
	H.STAWIL = 10
	H.STASPD = 8

	var/loadout = rand(1,10)
	switch(loadout)
		if(1) //spear + leathers
			r_hand = /obj/item/rogueweapon/spear
			if(prob(50))
				head = /obj/item/clothing/head/roguetown/helmet/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(2) //handaxe + leathers
			r_hand = /obj/item/rogueweapon/stoneaxe/handaxe
			if(prob(50))
				head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(3) //mace + leathers
			r_hand = /obj/item/rogueweapon/mace
			if(prob(50))
				head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(4) //iron messer + leathers
			r_hand = /obj/item/rogueweapon/sword/short/messer/iron
			if(prob(15))
				head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(5) //sword & shield
			r_hand = /obj/item/rogueweapon/sword/short/iron
			l_hand = /obj/item/rogueweapon/shield/heater
			if(prob(75))
				head = /obj/item/clothing/head/roguetown/helmet/hobgoblin
			else
				head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			if(prob(75))
				armor =	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin
			else
				armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(6) //warhammer
			r_hand = /obj/item/rogueweapon/mace/warhammer
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(7) //dual iron daggers
			r_hand = /obj/item/rogueweapon/huntingknife/idagger
			l_hand = /obj/item/rogueweapon/huntingknife/idagger
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(8) //brass knuckles + plate
			gloves = /obj/item/clothing/gloves/roguetown/knuckles/bronze
			armor =	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin
		if(9) //spear & shield
			r_hand = /obj/item/rogueweapon/spear
			l_hand = /obj/item/rogueweapon/shield/heater
			if(prob(33))
				head = /obj/item/clothing/head/roguetown/helmet/leather/hobgoblin
			armor = /obj/item/clothing/suit/roguetown/armor/leather/hobgoblin
		if(10) //greatsword + full plate (rare)
			r_hand = /obj/item/rogueweapon/greatsword/iron
			head = /obj/item/clothing/head/roguetown/helmet/hobgoblin
			armor =	/obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron/hobgoblin

	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

/mob/living/carbon/human/species/hobgoblin/npc
	ai_controller = /datum/ai_controller/human_npc
	dodgetime = 20

/mob/living/carbon/human/species/hobgoblin/npc/ambush
	threat_point = THREAT_MODERATE
	ambush_faction = "goblins"
