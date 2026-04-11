#define GRUNTSTR 14
#define GRUNTSPD 12
#define GRUNTCON 13
#define GRUNTWIL 14
#define GRUNTLCK 10
#define GRUNTINT 10
#define GRUNTPER 10

/mob/living/carbon/human/species/human/northern/goon
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
	var/list/abandon_textoptions = list("succumbs to an old infection - collapsing first to their knees, then crashing down face first.", "succumbs to the elements.", "goes pale and faints soon afterwards. Their breath stills.", "is lost to a hunger long unsated. They die thin and frail.")
	npc_jump_chance = 0 	// if we leave this on, they get really excited & hyper & start jumping into walls and each other 24/7 | calm down! god damn!!

	var/mob/squad_leader

	var/atom/walk_target
	var/last_moved_time = 0
	var/next_combat_process = 0

	// when a grunt is equipped, we cache the type of any item that can be disarmed/dismembered from them (gloves, weapons etc)
	// when they're recycled, we regenerate those items and only those items
	var/saved_r_weapon
	var/saved_l_weapon
	var/saved_mask
	var/saved_neck
	var/saved_head
	var/saved_gloves
	var/saved_shoes
	var/saved_mouth

///////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////// ALTERNATE PATHFINDING
/* 
	since we're expecting a shitload of goons to be fighting at once, we're throttling their pathfinding like crazy
	by default, they just nudge themselves in the general direction of their target
	if they don't move, they attempt a SINGLE complex path

	this makes them dumb, but ultimately they're not the main event so it doesn't really matter

*/
/mob/living/carbon/human/species/human/northern/goon/start_pathing_to(new_target, force = FALSE)
	if(mode == NPC_AI_MARCH)
		if(force || world.time >= next_complex_path_time)
			next_complex_path_time = world.time + rand(12, 19) SECONDS
			walk(src, 0)
			walk_target = null
			var/turf/turf_of_target = get_turf(new_target)
			if(!turf_of_target)
				return FALSE
			var/MARCH_MAX_RANGE = min(get_dist(src, new_target) + 65, 300)
			is_currently_pathing = TRUE
			myPath = get_path_to(src, turf_of_target, TYPE_PROC_REF(/turf, Heuristic_cardinal_3d), MARCH_MAX_RANGE + 1, 250, 1, adjacent = TYPE_PROC_REF(/turf, reachableTurftest3d))
			is_currently_pathing = FALSE
			if(length(myPath))
				myPath -= get_turf(src)
				pathing_frustration = 0
				return TRUE
			return FALSE
		if(length(myPath))
			return TRUE
	else if(force)
		walk(src, 0)
		walk_target = null
		return ..()

	if(length(myPath))
		return TRUE

	var/turf/next_turf = get_step(src, get_dir(src, new_target))

	if(!next_turf?.can_traverse_safely(src))
		if(world.time >= next_complex_path_time)
			next_complex_path_time = world.time + rand(12, 19) SECONDS  // 12-19 second cooldown for astar/complex pathfinding
			walk(src, 0)
			walk_target = null
			return ..(new_target)
		return

	if(mode == NPC_AI_FLEE)
		return

	if(mode == NPC_AI_HUNT && target && get_dist(src, target) <= 1)
		if(walk_target)
			walk(src, 0)
			walk_target = null
		return

	if(walk_target && (world.time - last_moved_time) > (maxStepsTick) && world.time >= next_complex_path_time)
		next_complex_path_time = world.time + rand(12, 19) SECONDS
		walk(src, 0)
		walk_target = null

		// if they failed to move, we also want to check & see if someone's blocking the next tile
		// if that Someone is worth targeting, we target them instead
		for(var/mob/living/carbon/human/blocker in next_turf)
			if(should_target(blocker))
				retaliate(blocker)
			break

		return ..(new_target, TRUE)

	if(walk_target == new_target)
		return TRUE

	walk_target = new_target
	if(mode != NPC_AI_MARCH)
		next_complex_path_time = 0
	walk_towards(src, new_target, 4)
	return TRUE

/mob/living/carbon/human/species/human/northern/goon/Moved()
	. = ..()
	last_moved_time = world.time

/mob/living/carbon/human/species/human/northern/goon/handle_combat()
	if(flee_in_pain && target && target.stat == CONSCIOUS)
		if(health > maxHealth * 0.5) // only bother calculating complex pain if they're below half health.
			flee_in_pain = FALSE
	. = ..()

/mob/living/carbon/human/species/human/northern/goon/process_ai()
	if(mode == NPC_AI_HUNT) // we're also throttling combat processing as a whole
		if(world.time < next_combat_process)
			return
		next_combat_process = world.time + rand(12, 19)
	. = ..()

/mob/living/carbon/human/species/human/northern/goon/clear_path()
	walk(src, 0)
	walk_target = null
	next_complex_path_time = 0
	return ..()

/mob/living/carbon/human/species/human/northern/goon/back_to_idle()
	if(mode == NPC_AI_HUNT && target && should_target(target))
		last_aggro_loss = null
		frustration = 0
		pathing_frustration = 0
		next_complex_path_time = 0
		clear_path()
		m_intent = MOVE_INTENT_WALK
		return
	return ..()

/mob/living/carbon/human/species/human/northern/goon/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/human/northern/goon/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
		if(!is_silent && target != newtarg)
			say(pick(GLOB.highwayman_aggro))
			linepoint(target)

/mob/living/carbon/human/species/human/northern/goon/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/human/northern/goon/proc/end_charge()
	src.mode = NPC_AI_IDLE

// used when a grunt squad is cleared out
/mob/living/carbon/human/species/human/northern/goon/proc/abandonevent()
	if(stat == CONSCIOUS || stat == SOFT_CRIT || stat == UNCONSCIOUS)
		src.adjustOxyLoss(200)
		src.adjustToxLoss(200)
		var/abandon_message = pick(abandon_textoptions)
		src.visible_message(span_info("[src] [abandon_message]"))
		addtimer(CALLBACK(src, PROC_REF(rot_event)), rand(1 MINUTES, 12 MINUTES))
	else
		src.rot_event()

/mob/living/carbon/human/species/human/northern/goon/proc/rot_event()
	src.visible_message(span_info("[src]'s corpse is taken by the Rot."))
	new /obj/effect/decal/remains/human(src.loc)
	recycle()

// killed by ocean & sewer tiles, so the warband's avenues of attack are limited
/mob/living/carbon/human/species/human/northern/goon/proc/drownevent()
	src.emote("agony", forced = TRUE)
	src.visible_message(span_warning("[src] thrashes and flails in the water, drowning under the weight of their gear!"))
	addtimer(CALLBACK(src, PROC_REF(drown_followup)), 3 SECONDS)

/mob/living/carbon/human/species/human/northern/goon/proc/drown_followup()
	src.adjustOxyLoss(200)
	src.adjustToxLoss(200)

/mob/living/carbon/human/species/human/northern/goon/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE


/mob/living/carbon/human/species/human/northern/goon/Destroy()
	if(friends.len) // atm, a goon's only "friend" will be whoever spawned them
		for(var/mob/living/carbon/human/pal in friends)
			if(pal)
				pal.friends -= src
				var/datum/component/squad_controller/squad = pal.GetComponent(/datum/component/squad_controller)
				if(squad)
					squad.remove_member(src)
	squad_leader = null
	walk_target = null
	saved_mask = null
	saved_neck = null
	saved_head = null
	saved_gloves = null
	saved_shoes = null
	saved_r_weapon = null
	saved_l_weapon = null
	warband = null
	subtype = null
	..()
	// it looks like complex mobs hard delete themselves. this happens so far back in the inheritance chain that i'm just completely lost
	// if that's ever made to Not Be The Case this harddel hint should probably be removed
	return QDEL_HINT_HARDDEL

// costs roughly the same CPU as equipping a mob (if they're wounded)
// but we're still avoiding hard deleting OR creating a fresh mob, so this is ok. i think. yeah it's fine
/mob/living/carbon/human/species/human/northern/goon/proc/recycle()
	if(health < maxHealth)
		fully_heal()
	else
		setOxyLoss(0, 0)
		setToxLoss(0, 0)
		updatehealth()
	revive(FALSE, TRUE)
	full_repair()
	wander = FALSE
	aggressive = FALSE
	target = null
	clear_path()
	moveToNullspace()
	mode = NPC_AI_SLEEP
	squad_leader = null
	friends = list()
	enemies = list()
	STOP_PROCESSING(SShumannpc, src)
	reequip_extremities()	
	refresh_eyes()
	for(var/atom/movable/screen/warband/manager/warband_manager in SSwarbands.warband_managers)
		if(warband_manager.warband_ID == src.warband_ID)
			var/list/cache_to_use = warband_manager.get_grunt_cache()
			cache_to_use += src
			break

/mob/living/carbon/human/species/human/northern/goon/proc/full_repair()
	for(var/obj/item/I in contents)
		if(I.obj_integrity < I.max_integrity)
			I.obj_integrity = I.max_integrity
			if(I.obj_broken)
				I.obj_fix()
		if(I.peel_count)
			I.peel_count = 0
		if(I.body_parts_covered_dynamic != I.body_parts_covered)
			I.repair_coverage()

// when a grunt is equipped, we cache the type of any item that can be disarmed/dismembered from them (gloves, weapons etc)
// when they're recycled, we regenerate those items and only those items
/mob/living/carbon/human/species/human/northern/goon/proc/reequip_extremities()
	// hands/weapons
	var/obj/item/current_r = get_held_items_for_side(RIGHT_HANDS)
	var/obj/item/current_l = get_held_items_for_side(LEFT_HANDS)	
	if(current_r && !istype(current_r, saved_r_weapon))
		dropItemToGround(current_r)
		current_r = null
	if(saved_r_weapon && !current_r)
		put_in_r_hand(new saved_r_weapon())
		
	if(current_l && !istype(current_l, saved_l_weapon))
		dropItemToGround(current_l)
		current_l = null
	if(saved_l_weapon && !current_l)
		put_in_l_hand(new saved_l_weapon())

	// extremities
	if(saved_mask	&& !istype(wear_mask,	saved_mask))	equip_to_slot_or_del(new saved_mask(),		SLOT_WEAR_MASK)
	if(saved_mouth	&& !istype(mouth,		saved_mouth))	equip_to_slot_or_del(new saved_mouth(),		SLOT_MOUTH)
	if(saved_neck	&& !istype(wear_neck,	saved_neck))	equip_to_slot_or_del(new saved_neck(),		SLOT_NECK)
	if(saved_head	&& !istype(head,		saved_head))	equip_to_slot_or_del(new saved_head(),		SLOT_HEAD)
	if(saved_gloves	&& !istype(gloves,		saved_gloves))	equip_to_slot_or_del(new saved_gloves(),	SLOT_GLOVES)
	if(saved_shoes	&& !istype(shoes,		saved_shoes))	equip_to_slot_or_del(new saved_shoes(),		SLOT_SHOES)

/mob/living/carbon/human/species/human/northern/goon/after_creation()
	..()
	job = "Goon"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_FORMATIONFIGHTER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STUCKITEMS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/goon/base_grunt_stats)

/mob/living/carbon/human/species/human/northern/goon/proc/equip_for_warband()
	if(!warband)
		return
	
	var/outfit_type
	switch(warband.type)
		if(/datum/warbands/standard)
			outfit_type = /datum/outfit/job/roguetown/human/species/human/northern/goon
		if(/datum/warbands/sect)
			outfit_type = /datum/outfit/job/roguetown/human/species/human/northern/goon/cultist
		if(/datum/warbands/mercenary)
			outfit_type = /datum/outfit/job/roguetown/human/species/human/northern/goon/mercenary
		if(/datum/warbands/storyteller/peasant)
			outfit_type = /datum/outfit/job/roguetown/human/species/human/northern/goon/peasant
		if(/datum/warbands/storyteller/wizard)
			outfit_type = /datum/outfit/job/roguetown/human/species/human/northern/goon/layman
		else
			outfit_type = /datum/outfit/job/roguetown/human/species/human/northern/goon
	equipOutfit(new outfit_type)
	apply_appearance()

	// cache anything they could lose via disarming/dismemberment
	var/obj/item/r = get_held_items_for_side(RIGHT_HANDS)
	var/obj/item/l = get_held_items_for_side(LEFT_HANDS)
	saved_r_weapon = r?.type
	saved_l_weapon = l?.type
	saved_mask = wear_mask?.type
	saved_neck = wear_neck?.type
	saved_head = head?.type
	saved_mouth = mouth?.type
	saved_gloves = gloves?.type
	saved_shoes = shoes?.type
	return

/mob/living/carbon/human/species/human/northern/goon/proc/apply_appearance()
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

	refresh_eyes()
	update_hair()
	update_body()

/mob/living/carbon/human/species/human/northern/goon/proc/refresh_eyes()
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		var/picked_eye_color = pick("#365334", "#395c70", "#30261e")
		organ_eyes.eye_color = picked_eye_color
		organ_eyes.accessory_colors = picked_eye_color + picked_eye_color

/mob/living/carbon/human/species/human/northern/goon/npc_idle()
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


/datum/outfit/job/roguetown/human/species/human/northern/goon
	var/datum/warbands/subtypes/subtype

/datum/outfit/job/roguetown/human/species/human/northern/goon/base_grunt_stats/pre_equip(mob/living/carbon/human/species/human/northern/goon/H)
	if(prob(50))
		H.real_name = pick(world.file2list("strings/rt/names/human/humsoum.txt"))
	else
		H.real_name = pick(world.file2list("strings/rt/names/human/humnorm.txt"))
	H.adjust_skillrank(/datum/skill/combat/polearms, 3, TRUE)
	H.adjust_skillrank(/datum/skill/combat/staves, 3, TRUE)
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

/datum/outfit/job/roguetown/human/species/human/northern/goon/pre_equip(mob/living/carbon/human/species/human/northern/goon/H)
	armor = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	pants = /obj/item/clothing/under/roguetown/chainlegs/iron
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather/reinforced
	belt = /obj/item/storage/belt/rogue/leather/black
	cloak = /obj/item/clothing/cloak/tabard/stabard/warband
	r_hand = /obj/item/rogueweapon/shield/heater
	neck = /obj/item/clothing/neck/roguetown/chaincoif/iron
	l_hand = /obj/item/rogueweapon/sword/iron

	if(prob(50))
		head = /obj/item/clothing/head/roguetown/helmet/sallet/iron
	else
		head = null	
	if(prob(50))
		gloves = /obj/item/clothing/gloves/roguetown/plate/iron
	else
		gloves = /obj/item/clothing/gloves/roguetown/chain/iron

/datum/outfit/job/roguetown/human/species/human/northern/goon/peasant/pre_equip(mob/living/carbon/human/species/human/northern/goon/H)
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

/datum/outfit/job/roguetown/human/species/human/northern/goon/layman/pre_equip(mob/living/carbon/human/species/human/northern/goon/H)
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

/datum/outfit/job/roguetown/human/species/human/northern/goon/cultist/pre_equip(mob/living/carbon/human/species/human/northern/goon/H)
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

/datum/outfit/job/roguetown/human/species/human/northern/goon/mercenary/pre_equip(mob/living/carbon/human/species/human/northern/goon/H)
	subtype = H.subtype
	if(subtype)
		switch(subtype.type)
			if(WARBAND_MERC_NORTHMEN)
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
				armor = /datum/anvil_recipe/armor/steel/lightcuirass
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
				armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/iron
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
				shirt = /obj/item/clothing/suit/roguetown/armor/regenerating/easttats
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
				shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/iron
				shoes = /obj/item/clothing/shoes/roguetown/boots/leather
				head = /obj/item/clothing/head/roguetown/helmet/sallet/shishak
				gloves = /obj/item/clothing/gloves/roguetown/chain
				armor = /obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah
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
				shoes = /obj/item/clothing/shoes/roguetown/boots
				neck = /obj/item/clothing/neck/roguetown/gorget
				pants = /obj/item/clothing/under/roguetown/heavy_leather_pants
				shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt
				belt = /obj/item/storage/belt/rogue/leather
				gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
				wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
				armor = /obj/item/clothing/suit/roguetown/armor/leather/heavy/coat
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
		H.equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/goon)

#undef GRUNTSTR
#undef GRUNTSPD
#undef GRUNTCON
#undef GRUNTWIL
#undef GRUNTLCK
#undef GRUNTINT
#undef GRUNTPER
