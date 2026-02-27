/* 
*	based on pages from elden ring in terms of visual design, these guys are intended to be a speedbump to solo adventurers at mount decap
*	deadly but small in numbers. come back with a party, chump
*/

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter
	aggressive=1
	mode = AI_IDLE
	faction = list("viking", "station")
	ambushable = FALSE
	dodgetime = 15
	flee_in_pain = FALSE
	possible_rmb_intents = list()

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush
	aggressive = 1
	wander = TRUE

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/after_creation()
	..()
	job = "Mad-touched Treasure Hunter"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_INFINITE_STAMINA, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRIT_THRESHOLD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_DISFIGURED, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAINSTUN, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/mad_touched_treasure_hunter)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 40

/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/npc_idle()
	if(m_intent == MOVE_INTENT_SNEAK)
		return
	if(world.time < next_idle)
		return
	next_idle = world.time + rand(30, 70)
	if((mobility_flags & MOBILITY_MOVE) && isturf(loc) && wander)
		if(prob(20))
			var/turf/T = get_step(loc,pick(GLOB.cardinals))
			if(!istype(T, /turf/open/transparent/openspace))
				Move(T)
		else
			face_atom(get_step(src,pick(GLOB.cardinals)))
	if(!wander && prob(10))
		face_atom(get_step(src,pick(GLOB.cardinals)))

/datum/outfit/job/roguetown/human/species/human/northern/mad_touched_treasure_hunter/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/paalloy
	mask = /obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	if(prob(20))
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/platelegs/paalloy
	belt = /obj/item/storage/belt/rogue/leather
	if(prob(33))
		beltl = /obj/item/reagent_containers/glass/bottle/alchemical/healthpot
	head = /obj/item/clothing/head/roguetown/menacing/mad_touched_treasure_hunter
	neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
	gloves = /obj/item/clothing/gloves/roguetown/plate/paalloy
	cloak = /obj/item/clothing/cloak/wickercloak
	if(prob(33))
		r_hand = /obj/item/rogueweapon/greatsword/paalloy
	else if(prob(33))
		r_hand = /obj/item/rogueweapon/shield/buckler
		l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/padagger
	else
		r_hand = /obj/item/rogueweapon/sword/sabre/palloy
		l_hand = /obj/item/rogueweapon/sword/sabre/palloy

	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	//carbon ai is still pretty dumb so making them a threat to players requires pretty crazy looking stats. don't think too hard about it.
	H.STASTR = 15
	H.STASPD = 15
	H.STACON = 15
	H.STAWIL = 15
	H.STAPER = 15
	H.STAINT = 12
	H.eye_color = "27becc"
	H.hair_color = "61310f"
	H.facial_hair_color = H.hair_color
	if(H.gender == FEMALE)
		H.hairstyle =  "Messy (Rogue)"
	else
		H.hairstyle = "Messy"
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
	H.real_name = pick(world.file2list("strings/rt/names/human/mad_touched_names.txt"))

/obj/item/clothing/head/roguetown/menacing/mad_touched_treasure_hunter //its here so it doesnt wind up on some class' loadout.
	name = "sack hood"
	desc = "A ragged hood of thick jute fibres. The itchiness is unbearable."
	sewrepair = TRUE
	color = "#999999"
	armor = ARMOR_LEATHER

/obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched
	name = "eerie ancient mask"

/obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_WEAR_MASK)
		ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
		var/mob/living/carbon/human/mad_touched = user
		mad_touched.apply_damage(25, BRUTE, BODY_ZONE_HEAD)

/obj/item/clothing/mask/rogue/facemask/steel/paalloy/mad_touched/dropped(mob/user)
	. = ..()
	REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/datum/ambush_config/solo_treasure_hunter
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush = 1,
	)

/datum/ambush_config/duo_treasure_hunter
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush = 2,
	)

/datum/ambush_config/treasure_hunter_posse
	mob_types = list(
		/mob/living/carbon/human/species/human/northern/mad_touched_treasure_hunter/ambush = 3,
	)
