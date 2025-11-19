//These guys are intended to be no joke, if they are getting stomped something is wrong
//Intended difficulty [HARD]
/mob/living/carbon/human/species/lizardfolk/psy_vault_guard
	race = /datum/species/lizardfolk
	aggressive=1
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("psy_vault_guard")
	ambushable = FALSE
	cmode = 1
	setparrytime = 20
	flee_in_pain = FALSE
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_STEAL)
	possible_rmb_intents = list(
		/datum/rmb_intent/feint,\
		/datum/rmb_intent/aimed,\
		/datum/rmb_intent/strong,\
		/datum/rmb_intent/riposte,\
		/datum/rmb_intent/weak
	)
	var/is_silent = FALSE /// Determines whether or not we will scream our funny lines at people.
	npc_max_jump_stamina = 0

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/ambush
	aggressive=1
	wander = TRUE

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
		if(!is_silent && target != newtarg)
			say(pick(GLOB.highwayman_aggro))
			pointed(target)

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/Initialize()
	. = ..()
	set_species(/datum/species/lizardfolk)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE
	transform = transform.Scale(1.25, 1.25)
	transform = transform.Translate(0, 0.25 * 16)
	update_transform()

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/after_creation()
	..()
	//This Stuff handles their parts
	var/obj/item/organ/tail/lizard/tail = src.getorganslot(ORGAN_SLOT_TAIL)
	var/obj/item/organ/snout/lizard/psy_vault_guard/snout = src.getorganslot(ORGAN_SLOT_SNOUT)
	var/obj/item/organ/ears/psy_vault_guard/ears = src.getorganslot(ORGAN_SLOT_EARS)
	if(tail)
		tail.Remove(src,1)
		QDEL_NULL(tail)
	tail = new /obj/item/organ/tail/lizard
	tail.Insert(src)
	if(snout)
		snout.Remove(src,1)
		QDEL_NULL(snout)
	snout = new /obj/item/organ/snout/lizard/psy_vault_guard
	snout.Insert(src)
	if(ears)
		ears.Remove(src,1)
		QDEL_NULL(ears)
	ears = new /obj/item/organ/ears/psy_vault_guard
	ears.Insert(src)
	//This Stuff handles their parts
	job = "Zardman Jailer"
	real_name = "Zardman Jailer"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_RESISTANCE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BIGGUY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STRONGBITE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard)
	patron = /datum/patron/old_god
	update_hair()
	update_body()
	update_overlays()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 50 // Big sellprice for these guys

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/npc_idle()
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

/mob/living/carbon/human/species/lizardfolk/psy_vault_guard/handle_combat()
	if(mode == NPC_AI_HUNT)
		if(prob(2)) // do not make this big or else they NEVER SHUT UP
			emote("fsalute")
	. = ..()

/datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard/pre_equip(mob/living/carbon/human/H)
	..()
	//Body Stufff
	H.skin_tone = "e9d298"
	//Stat Stuff
	H.STASTR = 15
	H.STASPD = 13
	H.STACON = 15
	H.STAWIL = 15
	H.STAPER = 12
	H.STAINT = 10
	H.STALUC = 13
	//skill Stuff
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE) //NPCs do not get these skills unless a mind takes them over, hopefully in the future someone can fix
	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/athletics, 4, TRUE)
	ADD_TRAIT(H, TRAIT_NIGHT_VISION, TRAIT_GENERIC)
	//Clothing Stuff
	//Head Gear
	shirt = /obj/item/clothing/suit/roguetown/armor/chainmail/hauberk
	armor = /obj/item/clothing/suit/roguetown/shirt/undershirt/priest
	add_random_psy_vault_guard_mask(H)
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	//wrist Gear
	add_random_psy_vault_guard_psycross(H)
	//Lower Gear
	belt = /obj/item/storage/belt/rogue/leather/sash
	add_random_psy_vault_guard_beltr_stuff(H)
	add_random_psy_vault_guard_beltl_stuff(H)
	pants = /obj/item/clothing/under/roguetown/chainlegs/kilt
	//Weapons
	add_random_psy_vault_guard_weapon(H)

/datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard/proc/add_random_psy_vault_guard_weapon(mob/living/carbon/human/H)
	var/add_random_psy_vault_guard_weapon = rand(1, 7)
	switch(add_random_psy_vault_guard_weapon)
		if(1)
			r_hand = /obj/item/rogueweapon/sword/short/messer
			l_hand = /obj/item/rogueweapon/shield/tower/metal
		if(2)
			r_hand = /obj/item/rogueweapon/sword/long/kriegmesser
		if(3)
			r_hand = /obj/item/rogueweapon/eaglebeak
		if(4)
			r_hand = /obj/item/rogueweapon/mace/warhammer/steel
			l_hand = /obj/item/rogueweapon/shield/tower/metal
		if(5)
			r_hand = /obj/item/rogueweapon/greatsword/grenz
		if(6)
			r_hand = /obj/item/rogueweapon/greataxe/steel
		if(7)
			r_hand = /obj/item/rogueweapon/mace/goden/steel
		// 2 hand weapon to dilute the pool to keep ranged viable

/datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard/proc/add_random_psy_vault_guard_mask(mob/living/carbon/human/H)
	var/add_random_psy_vault_guard_mask = rand(1,5)
	switch(add_random_psy_vault_guard_mask)
		if(1)
			mask = /obj/item/clothing/mask/rogue/facemask/psydonmask
		if(2)
			mask = /obj/item/clothing/mask/rogue/sack/psy
		if(3)
			head = /obj/item/clothing/head/roguetown/helmet/blacksteel/psythorns
		if(4)
			head = /obj/item/clothing/head/roguetown/roguehood/psydon

/datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard/proc/add_random_psy_vault_guard_psycross(mob/living/carbon/human/H)
	var/add_random_psy_vault_guard_psycross = rand(1,5)
	switch(add_random_psy_vault_guard_psycross)
		if(1)
			wrists = /obj/item/clothing/neck/roguetown/psicross/aalloy
		if(2)
			wrists = /obj/item/clothing/neck/roguetown/psicross/wood
		if(3)
			wrists = /obj/item/clothing/neck/roguetown/psicross/silver
		if(4)
			wrists = /obj/item/clothing/neck/roguetown/psicross
		if(5)
			wrists = /obj/item/clothing/wrists/roguetown/bracers/psythorns

/datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard/proc/add_random_psy_vault_guard_beltl_stuff(mob/living/carbon/human/H)
	var/add_random_psy_vault_guard_beltl_stuff = rand(1,11)
	switch(add_random_psy_vault_guard_beltl_stuff)
		if(1)
			beltl = /obj/item/storage/belt/rogue/pouch/food
		if(2)
			beltl = /obj/item/storage/belt/rogue/pouch/medicine
		if(3)
			beltl = /obj/item/storage/belt/rogue/pouch/coins/poor
		if(4)
			beltl = /obj/item/storage/belt/rogue/pouch/coins/mid
		if(5)
			beltl = /obj/item/reagent_containers/glass/bottle/waterskin
		if(6)
			beltl = /obj/item/reagent_containers/glass/bottle/alchemical/healthpot
		if(7)
			beltl = /obj/item/rope/chain
		if(8)
			beltl = /obj/item/clothing/neck/roguetown/psicross/aalloy
		if(9)
			beltl = /obj/item/clothing/neck/roguetown/psicross/wood
		if(10)
			beltl = /obj/item/clothing/neck/roguetown/psicross/silver
		if(11)
			beltl = /obj/item/clothing/neck/roguetown/psicross

/datum/outfit/job/roguetown/human/species/lizardfolk/psy_vault_guard/proc/add_random_psy_vault_guard_beltr_stuff(mob/living/carbon/human/H)
	var/add_random_psy_vault_guard_beltr_stuff = rand(1,11)
	switch(add_random_psy_vault_guard_beltr_stuff)
		if(1)
			beltr = /obj/item/storage/belt/rogue/pouch/food
		if(2)
			beltr = /obj/item/storage/belt/rogue/pouch/medicine
		if(3)
			beltr = /obj/item/storage/belt/rogue/pouch/coins/poor
		if(4)
			beltr = /obj/item/storage/belt/rogue/pouch/coins/mid
		if(5)
			beltr = /obj/item/reagent_containers/glass/bottle/waterskin
		if(6)
			beltr = /obj/item/reagent_containers/glass/bottle/alchemical/healthpot
		if(7)
			beltr = /obj/item/rope/chain
		if(8)
			beltr = /obj/item/clothing/neck/roguetown/psicross/aalloy
		if(9)
			beltr = /obj/item/clothing/neck/roguetown/psicross/wood
		if(10)
			beltr = /obj/item/clothing/neck/roguetown/psicross/silver
		if(11)
			beltr = /obj/item/clothing/neck/roguetown/psicross
