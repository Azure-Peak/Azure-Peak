GLOBAL_LIST_INIT(drowraider_aggro, world.file2list("strings/rt/drowaggrolines.txt"))

/mob/living/carbon/human/species/elf/dark/drowraider
	aggressive=1
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("drow")
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	possible_rmb_intents = list()
	var/is_silent = FALSE /// Determines whether or not we will scream our funny lines at people.

/mob/living/carbon/human/species/elf/dark/drowraider/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/elf/dark/drowraider/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
	if(!is_silent && target != newtarg)
		say(pick(GLOB.drowraider_aggro))
		pointed(target)

/mob/living/carbon/human/species/elf/dark/drowraider/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/elf/dark/drowraider/Initialize()
	. = ..()
	set_species(/datum/species/elf/dark)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE


/mob/living/carbon/human/species/elf/dark/drowraider/after_creation()
	..()
	job = "Drow Raider"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/elf/dark/drowraider)
	gender = pick(MALE, FEMALE)
	regenerate_icons()

	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	var/obj/item/organ/ears/organ_ears = getorgan(/obj/item/organ/ears)
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/himecut,
						/datum/sprite_accessory/hair/head/countryponytailalt,
						/datum/sprite_accessory/hair/head/stacy,
						/datum/sprite_accessory/hair/head/kusanagi_alt))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytailwitcher,
						/datum/sprite_accessory/hair/head/dave,
						/datum/sprite_accessory/hair/head/emo,
						/datum/sprite_accessory/hair/head/sabitsuki,
						/datum/sprite_accessory/hair/head/sabitsuki_ponytail))

	var/datum/bodypart_feature/hair/head/new_hair = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)

	new_hair.accessory_colors = "#DDDDDD"
	new_hair.hair_color = "#DDDDDD"
	hair_color = "#DDDDDD"

	head.add_bodypart_feature(new_hair)
	head.sellprice = 40

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#FFBF00"
		organ_eyes.accessory_colors = "#FFBF00#FFBF00"

	if(organ_ears)
		organ_ears.accessory_colors = "#5f5f70"

	skin_tone = "5f5f70"

	if(gender == FEMALE)
		real_name = pick(world.file2list("strings/rt/names/elf/elfdf.txt"))
	else
		real_name = pick(world.file2list("strings/rt/names/elf/elfdm.txt"))
	update_hair()
	update_body()

/mob/living/carbon/human/species/elf/dark/drowraider/npc_idle()
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

/mob/living/carbon/human/species/elf/dark/drowraider/handle_combat()
	if(mode == NPC_AI_HUNT)
		if(prob(5))
			emote("laugh")
	. = ..()

/datum/outfit/job/roguetown/human/species/elf/dark/drowraider/pre_equip(mob/living/carbon/human/H)
	armor = /obj/item/clothing/suit/roguetown/armor/plate/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	cloak = /obj/item/clothing/cloak/raincloak/furcloak/black
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
	if(prob(50))
		mask = /obj/item/clothing/mask/rogue/ragmask/black
	head = /obj/item/clothing/head/roguetown/helmet/sallet/visored/iron
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
	neck = /obj/item/clothing/neck/roguetown/bevor/iron
	if(prob(50))
		neck = /obj/item/clothing/neck/roguetown/gorget
	gloves = /obj/item/clothing/gloves/roguetown/chain/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	H.STASTR = 14 // 8 Points
	H.STASPD = 11 // +1 - Drow
	H.STACON = 14 // 4 points
	H.STAWIL = 12 // 2 points - 14 points spread. Equal to 1 more than a KC accounting for Statpack.
	H.STAPER = 10
	H.STAINT = 10
	if(prob(50))
		r_hand = /obj/item/rogueweapon/sword/falx
		l_hand = /obj/item/rogueweapon/shield/tower
	else
		r_hand = /obj/item/rogueweapon/halberd/bardiche
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)
