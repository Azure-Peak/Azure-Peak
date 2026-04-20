GLOBAL_LIST_INIT(highwayman_aggro, world.file2list("strings/rt/highwaymanaggrolines.txt"))

/mob/living/carbon/human/species/human/northern/highwayman
	ai_controller = /datum/ai_controller/human_npc
	faction = list(FACTION_VIKING, FACTION_STATION)
	ambushable = FALSE
	dodgetime = 30
	d_intent = INTENT_PARRY

/mob/living/carbon/human/species/human/northern/highwayman/ambush
	threat_point = THREAT_MODERATE
	ambush_faction = "bandits"



/mob/living/carbon/human/species/human/northern/highwayman/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)


/mob/living/carbon/human/species/human/northern/highwayman/after_creation()
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.highwayman_aggro, TRUE)
	job = "Highwayman"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/highwayman)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 30 // 50% More than goblin
	AddComponent(/datum/component/npc_death_line, null, 25)


/datum/outfit/job/roguetown/human/species/human/northern/highwayman/pre_equip(mob/living/carbon/human/H)
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	if(prob(50))
		mask = /obj/item/clothing/mask/rogue/ragmask/red
	armor = /obj/item/clothing/suit/roguetown/armor/leather
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
	if(prob(50))
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	pants = /obj/item/clothing/under/roguetown/trou/leather
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/leather
	if(prob(30))
		head = /obj/item/clothing/head/roguetown/helmet/leather/volfhelm
	if(prob(50))
		neck = /obj/item/clothing/neck/roguetown/coif
	gloves = /obj/item/clothing/gloves/roguetown/leather
	H.STASTR = rand(12,14) //GENDER EQUALITY!!
	H.STASPD = 11
	H.STACON = 6
	H.STAWIL = 6
	H.STAPER = 10
	H.STAINT = 6
	if(prob(50))
		r_hand = /obj/item/rogueweapon/sword/short/iron
	else
		r_hand = /obj/item/rogueweapon/mace/cudgel
	if(prob(20))
		r_hand = /obj/item/rogueweapon/sword/falchion/militia
	if(prob(20))
		r_hand = /obj/item/rogueweapon/pick/militia
	if(prob(25))
		l_hand = /obj/item/rogueweapon/shield/wood
	if(prob(10))
		l_hand = /obj/item/rogueweapon/shield/buckler/palloy
	if(prob(15))
		neck = /obj/item/storage/belt/rogue/pouch/bombs
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	if(prob(30))
		neck = /obj/item/clothing/neck/roguetown/leather
	H.eye_color = "27becc"
	H.hair_color = "61310f"
	H.facial_hair_color = H.hair_color
	if(H.gender == FEMALE)
		H.hairstyle =  "Messy (Rogue)"
	else
		H.hairstyle = "Messy"
		H.facial_hairstyle = "Beard (Manly)"
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE) // Trash mobs, untrained.
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
