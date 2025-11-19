// for consistent stat & stat resets
#define GRUNTSTR 14
#define GRUNTSPD 12
#define GRUNTCON 13
#define GRUNTWIL 14
#define GRUNTLCK 10
#define GRUNTINT 10
#define GRUNTPER 10

/mob/living/carbon/human/species/human/northern/grunt
	aggressive=1
	rude = FALSE
	mode = NPC_AI_IDLE
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	d_intent = INTENT_PARRY
	possible_rmb_intents = list()
	faction = list() // we don't want to start w/the 'neutral' faction
	var/is_silent = FALSE
	var/warband_ID
	var/datum/warbands/warband
	var/datum/warbands/subtypes/subtype
	var/list/abandon_textoptions = list("succumbs to an old infection - collapsing first to their knees, then crashing down face first.", "succumbs to the elements.", "goes pale, and faints soon afterwards. Their breathing stills.", "is lost to a hunger long unsated. They die thin and frail.")
	npc_jump_chance = 0 	// if we leave this on, they get really excited & hyper & start jumping into walls and each other 24/7 | calm down! god damn!!

/mob/living/carbon/human/species/human/northern/grunt/ambush
	aggressive=1

	wander = TRUE

/mob/living/carbon/human/species/human/northern/grunt/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
		if(!is_silent && target != newtarg)
			say(pick(GLOB.highwayman_aggro))
			linepoint(target)

/mob/living/carbon/human/species/human/northern/grunt/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()


// ends the effects of a grunt's special order
/mob/living/carbon/human/species/human/northern/grunt/proc/end_special_order()
	// end a Survive order
	src.STACON = GRUNTCON
	src.STAWIL = GRUNTWIL
	src.flee_in_pain = TRUE
	// end a Kill order
	src.STASTR = GRUNTSTR

/mob/living/carbon/human/species/human/northern/grunt/proc/end_charge()
	src.mode = NPC_AI_IDLE

// used when a grunt squad is cleared out
/mob/living/carbon/human/species/human/northern/grunt/proc/abandonevent(living)
	if(living)
		var/abandon_message = pick(abandon_textoptions)
		src.visible_message(span_info("[src] [abandon_message]"))
		src.adjustOxyLoss(200)
		src.adjustToxLoss(200)
		addtimer(CALLBACK(src, PROC_REF(rot_event)), 60 SECONDS) // repeats itself after 1 minute, clearing out the grunt's corpse
	else
		src.rot_event()

/mob/living/carbon/human/species/human/northern/grunt/proc/rot_event()
	src.visible_message(span_info("[src]'s corpse is taken by the Rot."))
	new /obj/effect/decal/remains/human(src.loc)
	qdel(src)

// killed by ocean & sewer tiles, so the warband's avenues of attack are limited
/mob/living/carbon/human/species/human/northern/grunt/proc/drownevent()
	src.emote("agony", forced = TRUE)
	src.visible_message(span_warning("[src] thrashes and flails in the water, drowning under the weight of their gear!"))
	addtimer(CALLBACK(src, PROC_REF(drown_followup)), 3 SECONDS)

/mob/living/carbon/human/species/human/northern/grunt/proc/drown_followup()
		src.adjustOxyLoss(200)
		src.adjustToxLoss(200)

/mob/living/carbon/human/species/human/northern/grunt/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE


/mob/living/carbon/human/species/human/northern/grunt/after_creation()
	..()
	job = "Grunt"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_FORMATIONFIGHTER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)

	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/grunt/base_grunt_stats)
	if(istype(warband, /datum/warbands/standard))
		equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/grunt)

	else if(istype(warband, /datum/warbands/sect))
		equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/grunt/cultist)

	else if(istype(warband, /datum/warbands/mercenary))
		equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/grunt/mercenary)

	else if(istype(warband, /datum/warbands/storyteller/peasant))
		equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/grunt/peasant)

	else if(istype(warband, /datum/warbands/storyteller/wizard))
		equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/grunt/layman)



	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	var/hairf = pick(list(/datum/sprite_accessory/hair/head/bedhead, 
						/datum/sprite_accessory/hair/head/bob))
	var/hairm = pick(list(/datum/sprite_accessory/hair/head/ponytail1, 
						/datum/sprite_accessory/hair/head/shaved))
	var/beard = pick(list(/datum/sprite_accessory/hair/facial/vandyke,
						/datum/sprite_accessory/hair/facial/croppedfullbeard))

	var/datum/bodypart_feature/hair/head/new_hair = new()
	var/datum/bodypart_feature/hair/facial/new_facial = new()

	if(gender == FEMALE)
		new_hair.set_accessory_type(hairf, null, src)
	else
		new_hair.set_accessory_type(hairm, null, src)
		new_facial.set_accessory_type(beard, null, src)
	if(subtype && (subtype.type == WARBAND_MERC_DROW || subtype.type == WARBAND_MERC_HANGYAKU || subtype.type == WARBAND_MERC_RUMA || subtype.type == WARBAND_MERC_DESERTRIDER || subtype.type == WARBAND_MERC_CONDO || subtype.type == WARBAND_MERC_FORLORN))
		if(prob(50))
			new_hair.accessory_colors = "#1d1d1d"
			new_hair.hair_color = "#1d1d1d"
			new_facial.accessory_colors = "#1d1d1d"
			new_facial.hair_color = "#1d1d1d"
			hair_color = "#1d1d1d"		
		else
			new_hair.accessory_colors = "#24160a"
			new_hair.hair_color = "#24160a"
			new_facial.accessory_colors = "#24160a"
			new_facial.hair_color = "#24160a"
			hair_color = "#24160a"
	else
		if(prob(50))
			new_hair.accessory_colors = "#96403d"
			new_hair.hair_color = "#96403d"
			new_facial.accessory_colors = "#96403d"
			new_facial.hair_color = "#96403d"
			hair_color = "#96403d"
		else
			new_hair.accessory_colors = "#C7C755"
			new_hair.hair_color = "#C7C755"
			new_facial.accessory_colors = "#C7C755"
			new_facial.hair_color = "#C7C755"
			hair_color = "#C7C755"

	head.add_bodypart_feature(new_hair)
	head.add_bodypart_feature(new_facial)

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)


	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		var/picked_eye_color = pick("#365334", "#395c70", "#30261e")
		organ_eyes.eye_color = picked_eye_color
		organ_eyes.accessory_colors = picked_eye_color + picked_eye_color


	update_hair()
	update_body()

/mob/living/carbon/human/species/human/northern/grunt/npc_idle()
	if(m_intent == MOVE_INTENT_SNEAK)
		return
	if(world.time < next_idle)
		return
	next_idle = world.time + rand(30, 70)
	if((mobility_flags & MOBILITY_MOVE) && isturf(loc) && wander)
		if(prob(20))
			var/turf/T = get_step(loc,pick(GLOB.cardinals))
			if(!istype(T, /turf/open/transparent/openspace) && !istype(T, /turf/open/water))
				Move(T)
		else
			face_atom(get_step(src,pick(GLOB.cardinals)))
	if(!wander && prob(10))
		face_atom(get_step(src,pick(GLOB.cardinals)))

/mob/living/carbon/human/species/human/northern/grunt/handle_combat()
	if(mode == NPC_AI_HUNT)
		if(prob(2)) 
			emote("rage")
	. = ..()

/datum/outfit/job/roguetown/human/species/human/northern/grunt
	var/datum/warbands/subtypes/subtype

/datum/outfit/job/roguetown/human/species/human/northern/grunt/base_grunt_stats/pre_equip(mob/living/carbon/human/species/human/northern/grunt/H)
	if(prob(50))
		H.real_name = pick(world.file2list("strings/rt/names/human/humsoum.txt"))
	else
		H.real_name = pick(world.file2list("strings/rt/names/human/humnorm.txt"))
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, 3, TRUE)	
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/sneaking, 2, TRUE)
	H.STASTR = 14
	H.STASPD = 12
	H.STACON = 13
	H.STAWIL = 14
	H.STAINT = 10
	H.STAPER = 12


/datum/outfit/job/roguetown/human/species/human/northern/grunt/pre_equip(mob/living/carbon/human/species/human/northern/grunt/H)
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/stabard/warband
	r_hand = /obj/item/rogueweapon/shield/heater
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	l_hand = /obj/item/rogueweapon/sword/iron

// EXTRA ARMOR
	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/sallet/iron
	else
		head = null	
	if(prob(50))
		gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	else
		gloves = /obj/item/clothing/gloves/roguetown/chain/iron

/datum/outfit/job/roguetown/human/species/human/northern/grunt/peasant/pre_equip(mob/living/carbon/human/species/human/northern/grunt/H)
	head = /obj/item/clothing/head/roguetown/armingcap
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	belt = /obj/item/storage/belt/rogue/leather/rope
	neck = /obj/item/clothing/neck/roguetown/coif
	pants =	/obj/item/clothing/under/roguetown/heavy_leather_pants

	if(should_wear_femme_clothes(H))
		armor = /obj/item/clothing/suit/roguetown/shirt/dress/gen/random
		shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
		cloak = /obj/item/clothing/cloak/apron/brown
	else
		armor = /obj/item/clothing/suit/roguetown/armor/leather/vest
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/random

	if(prob(50)) 	// spear
		if(prob(30))
			l_hand = /obj/item/rogueweapon/spear/militia
		else
			l_hand = /obj/item/rogueweapon/pitchfork
	else
		if(prob(30))// club
			l_hand = /obj/item/rogueweapon/flail/peasantwarflail
		else
			l_hand = /obj/item/rogueweapon/mace/woodclub/crafted


/datum/outfit/job/roguetown/human/species/human/northern/grunt/layman/pre_equip(mob/living/carbon/human/species/human/northern/grunt/H)
	r_hand = /obj/item/rogueweapon/mace/goden/steel
	cloak = /obj/item/clothing/cloak/thrall
	belt = /obj/item/storage/belt/rogue/leather/black
	head = /obj/item/clothing/mask/rogue/facemask/goldmask/layman/alt
	mask = /obj/item/clothing/head/roguetown/roguehood/shalal/thrall
	armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron/layman
	wrists = /obj/item/clothing/wrists/roguetown/bracers/iron/layman
	shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest/thrall
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt
	neck = /obj/item/clothing/neck/roguetown/bevor/iron/layman
	gloves = /obj/item/clothing/gloves/roguetown/plate/iron/layman
	shoes = /obj/item/clothing/shoes/roguetown/sandals


/datum/outfit/job/roguetown/human/species/human/northern/grunt/cultist/pre_equip(mob/living/carbon/human/species/human/northern/grunt/H)
	subtype = H.subtype
	if(prob(60))
		r_hand = /obj/item/rogueweapon/whip
	else
		r_hand = /obj/item/rogueweapon/mace/goden/aalloy
	belt = /obj/item/storage/belt/rogue/leather
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper/cultist
	gloves = /obj/item/clothing/gloves/roguetown/angle
	armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	if(subtype.type == WARBAND_SECT_PSYDON)
		mask = /obj/item/clothing/mask/rogue/sack/psy
	else
		mask = /obj/item/clothing/mask/rogue/sack


/datum/outfit/job/roguetown/human/species/human/northern/grunt/mercenary/pre_equip(mob/living/carbon/human/species/human/northern/grunt/H)
	subtype = H.subtype
	if(subtype)
		switch(subtype.type)
			if(WARBAND_MERC_ATGERVI)
				H.skin_tone = SKIN_COLOR_GRONN
				H.update_body()
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi
				l_hand = /obj/item/rogueweapon/shield/atgervi
				head = /obj/item/clothing/head/roguetown/helmet
				gloves = /obj/item/clothing/gloves/roguetown/angle/atgervi
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/gronn
				pants = /obj/item/clothing/under/roguetown/trou/leather/atgervi
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/atgervi
				belt = /obj/item/storage/belt/rogue/leather
				neck = /obj/item/clothing/neck/roguetown/chaincoif/chainmantle
			if(WARBAND_MERC_DROW)
				H.set_species(/datum/species/elf/dark)
				H.skin_tone = SKIN_COLOR_LLURTH_DREIR
				H.update_body()
				r_hand = /obj/item/rogueweapon/shield/tower/spidershield
				l_hand = /obj/item/rogueweapon/sword/sabre/stalker
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				belt = /obj/item/storage/belt/rogue/leather/black
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/shadowpants
				head = /obj/item/clothing/neck/roguetown/chaincoif/full/black
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/shadowrobe
				gloves = /obj/item/clothing/gloves/roguetown/plate/shadowgauntlets
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather/heavy
				mask = /obj/item/clothing/mask/rogue/facemask/shadowfacemask
			if(WARBAND_MERC_BLACKOAK)
				H.set_species(pick(/datum/species/human/halfelf, /datum/species/elf/dark, /datum/species/elf/wood))
				H.update_body()
				head = /obj/item/clothing/head/roguetown/helmet/heavy/elven_helm
				armor = /obj/item/clothing/suit/roguetown/armor/plate/elven_plate
				neck = /obj/item/clothing/neck/roguetown/chaincoif
				beltl = /obj/item/rogueweapon/huntingknife/idagger/steel/special
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/elven_boots
				cloak = /obj/item/clothing/cloak/forrestercloak
				gloves = /obj/item/clothing/gloves/roguetown/elven_gloves
				belt = /obj/item/storage/belt/rogue/leather/black
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
				pants = /obj/item/clothing/under/roguetown/trou/leather
				r_hand = /obj/item/rogueweapon/halberd/glaive
			if(WARBAND_MERC_CONDO)
				H.skin_tone = SKIN_COLOR_ETRUSCA
				H.update_body()
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				cloak = /obj/item/clothing/cloak/half/red
				gloves = /obj/item/clothing/gloves/roguetown/angle
				belt = /obj/item/storage/belt/rogue/leather/knifebelt/black/iron
				head = /obj/item/clothing/head/roguetown/helmet
				armor = /obj/item/clothing/suit/roguetown/armor/leather/studded
				l_hand = /obj/item/rogueweapon/sword/short
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
				pants = /obj/item/clothing/under/roguetown/trou/leather
				neck = /obj/item/clothing/neck/roguetown/chaincoif
			if(WARBAND_MERC_DESERTRIDER)
				H.skin_tone = SKIN_COLOR_LALVESTINE
				H.update_body()
				r_hand = /obj/item/rogueweapon/sword/sabre/shamshir
				l_hand = /obj/item/rogueweapon/shield/tower/raneshen
				head = /obj/item/clothing/head/roguetown/helmet/sallet/raneshen
				neck = /obj/item/clothing/neck/roguetown/bevor
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/raneshen
				wrists = /obj/item/clothing/wrists/roguetown/splintarms
				gloves = /obj/item/clothing/gloves/roguetown/chain
				pants = /obj/item/clothing/under/roguetown/splintlegs
				shoes = /obj/item/clothing/shoes/roguetown/shalal
				belt = /obj/item/storage/belt/rogue/leather/shalal
			if(WARBAND_MERC_FORLORN)
				H.skin_tone = SKIN_COLOR_LALVESTINE
				H.update_body()
				if(prob(60))
					r_hand = /obj/item/rogueweapon/sword/falchion/militia
					l_hand = /obj/item/rogueweapon/shield/heater
				else
					r_hand = /obj/item/rogueweapon/greataxe/militia
				shoes = /obj/item/clothing/shoes/roguetown/boots
				neck = /obj/item/clothing/neck/roguetown/gorget/forlorncollar
				mask = /obj/item/clothing/mask/rogue/wildguard
				pants = /obj/item/clothing/under/roguetown/splintlegs
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				wrists = /obj/item/clothing/wrists/roguetown/splintarms
				belt = /obj/item/storage/belt/rogue/leather
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
			if(WARBAND_MERC_FREI)
				H.skin_tone = SKIN_COLOR_AVAR
				H.update_body()
				r_hand = /obj/item/rogueweapon/sword/long/etruscan
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/fencer
				belt = /obj/item/storage/belt/rogue/leather/sash
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/freifechter
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan/generic
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/short
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
			if(WARBAND_MERC_GRENZEL)
				H.skin_tone = SKIN_COLOR_GRENZELHOFT
				H.update_body()
				if(prob(60))
					r_hand = /obj/item/rogueweapon/greatsword/grenz
				else
					r_hand = /obj/item/rogueweapon/halberd
				belt = /obj/item/storage/belt/rogue/leather
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/grenzelhoft
				head = /obj/item/clothing/head/roguetown/grenzelhofthat
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/grenzelpants
				shoes = /obj/item/clothing/shoes/roguetown/grenzelhoft
				gloves = /obj/item/clothing/gloves/roguetown/angle/grenzelgloves
			if(WARBAND_MERC_GRUDGE)
				H.set_species(/datum/species/dwarf/mountain)
				H.update_body()
				if(prob(60))
					r_hand = /obj/item/rogueweapon/stoneaxe/battle
				else
					r_hand = /obj/item/rogueweapon/mace/goden/steel
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
				neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
				cloak = /obj/item/clothing/cloak/forrestercloak/snow
				belt = /obj/item/storage/belt/rogue/leather/black
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/black
				wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
				gloves = /obj/item/clothing/gloves/roguetown/angle
				pants = /obj/item/clothing/under/roguetown/trou/leather
				armor = /obj/item/clothing/suit/roguetown/armor/plate/half/iron
				head = /obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron
				mask = /obj/item/clothing/mask/rogue/facemask
			if(WARBAND_MERC_HANGYAKU)
				H.skin_tone = SKIN_COLOR_KAZENGUN
				H.update_body()
				r_hand = /obj/item/rogueweapon/spear/naginata
				belt = /obj/item/storage/belt/rogue/leather
				neck = /obj/item/clothing/neck/roguetown/gorget/steel/kazengun
				head = /obj/item/clothing/head/roguetown/helmet/kettle/jingasa/npc
				armor = /obj/item/clothing/suit/roguetown/armor/brigandine/haraate/npc
				shirt = /obj/item/clothing/suit/roguetown/shirt/tunic/random
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/kazengun/npc
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced/kazengun/npc
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
				gloves = /obj/item/clothing/gloves/roguetown/plate/kote/npc
			if(WARBAND_MERC_ROUTIER)
				H.skin_tone = SKIN_COLOR_OTAVA
				H.update_body()
				if(prob(60))
					r_hand = /obj/item/rogueweapon/sword/short/falchion
				else
					r_hand = /obj/item/rogueweapon/mace/steel/morningstar
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				belt = /obj/item/storage/belt/rogue/leather
				neck = /obj/item/clothing/neck/roguetown/fencerguard
				armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/otavan
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/otavan
				shoes = /obj/item/clothing/shoes/roguetown/boots/otavan
				gloves = /obj/item/clothing/gloves/roguetown/otavan
			if(WARBAND_MERC_RUMA)
				H.skin_tone = SKIN_COLOR_KAZENGUN
				H.update_body()
				r_hand = /obj/item/rogueweapon/sword/sabre/mulyeog/rumahench
				l_hand = /obj/item/rogueweapon/scabbard/sword/kazengun/steel
				belt = /obj/item/storage/belt/rogue/leather
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/easttats
				cloak = /obj/item/clothing/cloak/eastcloak1
				armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/eastshirt2
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/eastpants2
				shoes = /obj/item/clothing/shoes/roguetown/armor/rumaclan
				gloves = /obj/item/clothing/gloves/roguetown/eastgloves2
			if(WARBAND_MERC_STEPPE)
				H.skin_tone = SKIN_COLOR_AVAR
				H.update_body()
				mask = /obj/item/clothing/mask/rogue/facemask/steel/steppesman
				belt = /obj/item/storage/belt/rogue/leather/black
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
				head = /obj/item/clothing/head/roguetown/helmet/sallet/shishak
				gloves = /obj/item/clothing/gloves/roguetown/chain
				armor = /obj/item/clothing/suit/roguetown/armor/plate/scale/steppe
				wrists = /obj/item/clothing/wrists/roguetown/bracers
				r_hand = /obj/item/rogueweapon/shield/iron/steppesman
				l_hand = /obj/item/rogueweapon/sword/sabre/steppesman
				neck = /obj/item/clothing/neck/roguetown/chaincoif
			if(WARBAND_MERC_UNDERDWELLER)
				H.set_species(/datum/species/elf/dark)
				H.skin_tone = SKIN_COLOR_LLURTH_DREIR
				H.update_body()
				head = /obj/item/clothing/head/roguetown/helmet/kettle/minershelm
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				wrists = /obj/item/clothing/wrists/roguetown/bracers/iron
				gloves = /obj/item/clothing/gloves/roguetown/chain/iron
				mask = /obj/item/clothing/mask/rogue/ragmask/black
				shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/lord
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
				belt = /obj/item/storage/belt/rogue/leather/black
				neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
				r_hand = /obj/item/rogueweapon/stoneaxe/woodcut/pick
				l_hand = /obj/item/rogueweapon/shield/wood
			if(WARBAND_MERC_VAQUERO)
				H.skin_tone = SKIN_COLOR_ETRUSCA
				H.update_body()
				head = /obj/item/clothing/head/roguetown/bardhat
				shoes = /obj/item/clothing/shoes/roguetown/boots
				neck = /obj/item/clothing/neck/roguetown/gorget
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
				belt = /obj/item/storage/belt/rogue/leather
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
				cloak = /obj/item/clothing/cloak/half/rider/red
				l_hand = /obj/item/rogueweapon/sword/rapier/vaquero
				r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/parrying/vaquero
			if(WARBAND_MERC_WARSCHOLAR)
				H.skin_tone = SKIN_COLOR_NALEDI
				H.update_body()
				r_hand = /obj/item/rogueweapon/woodstaff/quarterstaff/iron
				mask = /obj/item/clothing/mask/rogue/lordmask/naledi
				head = /obj/item/clothing/head/roguetown/roguehood/shalal/hijab/npc
				head = /obj/item/clothing/head/roguetown/roguehood/pontifex
				armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex
				shirt = /obj/item/clothing/suit/roguetown/shirt/robe/pointfex
				pants = /obj/item/clothing/under/roguetown/trou/leather/pontifex/npc
				wrists = /obj/item/clothing/wrists/roguetown/allwrappings/npc
				belt = /obj/item/storage/belt/rogue/leather
				shoes = /obj/item/clothing/shoes/roguetown/boots
	else // if there isn't an available subtype loadout for whatever reason, we just use the grunts from Feud
		H.equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/grunt)
