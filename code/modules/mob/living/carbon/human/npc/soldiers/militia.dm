//GLOBAL_LIST_INIT(militia_aggro, world.file2list("strings/rt/militiaaggrolines.txt")) //this doesn't exit but feel free to make it

/mob/living/carbon/human/species/human/northern/militia //weak peasant infantry. Neutral but can be given factions for events. doesn't attack players.
	aggressive=1 //they attack things. INCLUDING SAIGAS (THIS MEANS THEY WILL AGGRO ON PEOPLES MOUNTS)
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("neutral")
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	possible_rmb_intents = list()
	var/is_silent = TRUE /// Determines whether or not we will scream our funny lines at people.

/* /mob/living/carbon/human/species/human/northern/militia/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
		if(!is_silent && target != newtarg)
			say(pick(GLOB.militia_aggro))
			pointed(target) */

/mob/living/carbon/human/species/human/northern/militia/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/human/northern/militia/Initialize()
	. = ..()
	set_species(/datum/species/human/northern)
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE


/mob/living/carbon/human/species/human/northern/militia/after_creation()
	..()
	job = "Militia"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	equipOutfit(new /datum/outfit/job/roguetown/human/species/human/northern/militia)
	var/obj/item/organ/eyes/organ_eyes = getorgan(/obj/item/organ/eyes)
	if(organ_eyes)
		organ_eyes.eye_color = pick("27becc", "35cc27", "000000")
	update_hair()
	update_body()

/mob/living/carbon/human/species/human/northern/militia/npc_idle()
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

/* /mob/living/carbon/human/species/human/northern/militia/handle_combat()
	if(mode == NPC_AI_HUNT)
		if(prob(5)) // do not make this big or else they NEVER SHUT UP
			emote("laugh")
	. = ..() */

/datum/outfit/job/roguetown/human/species/human/northern/militia/pre_equip(mob/living/carbon/human/H)
	if(H.faction && ("viking" in H.faction))
		cloak = /obj/item/clothing/cloak/stabard/dungeon
	else
		cloak = /obj/item/clothing/cloak/stabard/guard
	wrists = /obj/item/clothing/wrists/roguetown/bracers/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	if(prob(50))
		shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/
	if(prob(25))
		armor = /obj/item/clothing/suit/roguetown/armor/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	if(prob(50))
		pants = /obj/item/clothing/under/roguetown/trou
	// Helmet, or lackthereof
	switch(rand(1, 7))
		if(1)
			head = /obj/item/clothing/head/roguetown/helmet/kettle/iron
		if(2)
			head = /obj/item/clothing/head/roguetown/helmet/sallet/iron
		if(3)
			head = /obj/item/clothing/head/roguetown/helmet/skullcap
		if(4 to 6)
			head = /obj/item/clothing/neck/roguetown/coif/heavypadding
		if(7)
			head = null
	// Neck protection, if there's no coif on head
	if(prob(50))
		neck = /obj/item/clothing/neck/roguetown/coif
	gloves = /obj/item/clothing/gloves/roguetown/fingerless_leather
	if(prob(25))
		gloves = /obj/item/clothing/gloves/roguetown/angle
	H.STASTR = rand(10,11) //GENDER EQUALITY!!
	H.STASPD = 10
	H.STACON = rand(10,12) //so their limbs no longer pop off like a skeleton
	H.STAWIL = 10
	H.STAPER = 10
	H.STAINT = 10
	switch(rand(1, 11))
		// Militia Weapon. Of course they spawn with it
		if(1)
			r_hand = /obj/item/rogueweapon/woodstaff/militia
		if(2)
			r_hand = /obj/item/rogueweapon/greataxe/militia
		if(3)
			r_hand = /obj/item/rogueweapon/spear/militia
		if(4)
			r_hand = /obj/item/rogueweapon/spear
			l_hand = /obj/item/rogueweapon/shield/wood
		if(5)
			r_hand = /obj/item/rogueweapon/scythe
		if(6)
			r_hand = /obj/item/rogueweapon/pick/militia
		if(7)
			r_hand = /obj/item/rogueweapon/sword/falchion/militia
		if(8)
			r_hand = /obj/item/rogueweapon/mace/cudgel
		if(9)
			r_hand = /obj/item/rogueweapon/mace/goden
		if(10)
			r_hand = /obj/item/rogueweapon/stoneaxe/woodcut
			l_hand = /obj/item/rogueweapon/shield/wood
		if(11)
			r_hand = /obj/item/rogueweapon/flail/peasantwarflail
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	H.eye_color = pick("27becc", "35cc27", "000000")
	H.hair_color = pick ("4f4f4f", "61310f", "faf6b9")
	H.facial_hair_color = H.hair_color
	if(H.gender == FEMALE)
		H.hairstyle = pick("Ponytail (Country)","Braid (Low)", "Braid (Short)", "Messy (Rogue)")
	else
		H.hairstyle = pick("Mohawk","Braid (Low)", "Braid (Short)", "Messy")
		H.facial_hairstyle = pick("Beard (Viking)", "Beard (Long)", "Beard (Manly)")
	H.adjust_skillrank(/datum/skill/combat/polearms, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 2, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 2, TRUE) // Trash mobs, untrained.
	H.adjust_skillrank(/datum/skill/combat/wrestling, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/mob/living/carbon/human/species/human/northern/militia/ambush
	wander = TRUE

/mob/living/carbon/human/species/human/northern/militia/guard //variant that doesn't wander, if you want to place them as set dressing. will aggro enemies and animals
	wander = FALSE

/mob/living/carbon/human/species/human/northern/militia/deserter // Bad deserter, trash mob
	faction = list("viking", "station")

/mob/living/carbon/human/species/human/northern/militia/after_creation()
	..()
	var/obj/item/bodypart/head/head = get_bodypart(BODY_ZONE_HEAD)
	head.sellprice = 20 // Gobbo sellprice
