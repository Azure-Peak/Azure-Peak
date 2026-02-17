/* *
 * Deranged Knight
 * A miniboss for quest system, designed to be a high-level challenge for multiple players.
 * Uses fuckoff gear that should not be looted - hence snowflake dismemberment code.
 */

GLOBAL_LIST_INIT(matthios_aggro, world.file2list("strings/rt/matthiosaggrolines.txt"))
GLOBAL_LIST_INIT(zizo_aggro, world.file2list("strings/rt/zizoaggrolines.txt"))
GLOBAL_LIST_INIT(graggar_aggro, world.file2list("strings/rt/graggaraggrolines.txt"))
GLOBAL_LIST_INIT(hedgeknight_aggro, world.file2list("strings/rt/hedgeknightaggrolines.txt"))

/mob/living/carbon/human/species/human/northern/deranged_knight
	aggressive = TRUE
	rude = TRUE
	mode = NPC_AI_IDLE
	faction = list("dundead")
	ambushable = FALSE
	dodgetime = 30
	flee_in_pain = TRUE
	possible_rmb_intents = list(
		/datum/rmb_intent/feint,\
		/datum/rmb_intent/aimed,\
		/datum/rmb_intent/strong,\
		/datum/rmb_intent/riposte,\
		/datum/rmb_intent/weak
	)
	npc_max_jump_stamina = 0
	var/is_silent = FALSE /// Determines whether or not we will scream our funny lines at people.
	var/preset = "matthios"
	var/forced_preset = "" // If set, force a specific preset instead of randomizing.

/mob/living/carbon/human/species/human/northern/deranged_knight/retaliate(mob/living/L)
	var/newtarg = target
	.=..()
	if(target)
		aggressive=1
		wander = TRUE
	if(!is_silent && target != newtarg)
		if(preset == "matthios")
			say(pick(GLOB.matthios_aggro))
		else if(preset == "zizo")
			say(pick(GLOB.zizo_aggro))
		else if(preset == "graggar")
			say(pick(GLOB.graggar_aggro))
		else if(preset == "hedgeknight")
			say(pick(GLOB.hedgeknight_aggro))
		pointed(target)

/mob/living/carbon/human/species/human/northern/deranged_knight/should_target(mob/living/L)
	if(L.stat != CONSCIOUS)
		return FALSE
	. = ..()

/mob/living/carbon/human/species/human/northern/deranged_knight/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS)
	is_silent = TRUE
	var/head = get_bodypart(BODY_ZONE_HEAD)
	RegisterSignal(head, COMSIG_MOB_DISMEMBER, PROC_REF(handle_drop_limb))

/mob/living/carbon/human/species/human/northern/deranged_knight/Destroy()
	var/head = get_bodypart(BODY_ZONE_HEAD)
	if(head)
		UnregisterSignal(head, COMSIG_MOB_DISMEMBER)
	return ..()

/// Snowflake DK behavior for decaps. Yes, they turn to dust prior to decaps.
/mob/living/carbon/human/species/human/northern/deranged_knight/proc/handle_drop_limb(obj/item/bodypart/bodypart, special)
	if(!istype(bodypart, /obj/item/bodypart/head))
		return

	death(FALSE, TRUE) // No, you won't loot that tasty helmet.
	return COMPONENT_CANCEL_DISMEMBER

/mob/living/carbon/human/species/human/northern/deranged_knight/after_creation()
	..()
	job = "Ascendant Knight"
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_STUCKITEMS, TRAIT_GENERIC)
	if(forced_preset)
		preset = forced_preset
	else
		switch(rand(1, 4))
			if(1)
				preset = "graggar"
			if(2)
				preset = "matthios"
			if(3)
				preset = "zizo"
			if(4)
				preset = "hedgeknight"
	switch(preset)
		if("graggar")
			ADD_TRAIT(src, TRAIT_HORDE, TRAIT_GENERIC)
			equipOutfit(new /datum/outfit/job/roguetown/quest_miniboss/graggar)
		if ("matthios")
			ADD_TRAIT(src, TRAIT_COMMIE, TRAIT_GENERIC)
			equipOutfit(new /datum/outfit/job/roguetown/quest_miniboss/matthios)
		if ("zizo")
			ADD_TRAIT(src, TRAIT_CABAL, TRAIT_GENERIC)
			equipOutfit(new /datum/outfit/job/roguetown/quest_miniboss/zizo)
		if ("hedgeknight")
			if(prob(50))
				equipOutfit(new /datum/outfit/job/roguetown/quest_miniboss/hedge_knight)
			else
				equipOutfit(new /datum/outfit/job/roguetown/quest_miniboss/blacksteel)
			// No special trait for hedgeknight, he's just a generic tough guy.

	gender = pick(MALE,FEMALE)
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

	dna.update_ui_block(DNA_HAIR_COLOR_BLOCK)
	dna.species.handle_body(src)

	if(organ_eyes)
		organ_eyes.eye_color = "#FFBF00"
		organ_eyes.accessory_colors = "#FFBF00#FFBF00"

	if(organ_ears)
		organ_ears.accessory_colors = "#5f5f70"

	skin_tone = "5f5f70"

	if(prob(1))
		real_name = "Taras Mura"
	update_hair()
	update_body()

	def_intent_change(INTENT_PARRY)

/mob/living/carbon/human/species/human/northern/deranged_knight/npc_idle()
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

/mob/living/carbon/human/species/human/northern/deranged_knight/handle_combat()
	if(prob(3))
		if(preset == "matthios")
			say(pick(GLOB.matthios_aggro))
		else if(preset == "zizo")
			say(pick(GLOB.zizo_aggro))
		else if(preset == "graggar")
			say(pick(GLOB.graggar_aggro))
		else if(preset == "hedgeknight")
			say(pick(GLOB.hedgeknight_aggro))
	if(mode == NPC_AI_HUNT)
		if(prob(5))
			emote("laugh")
		else if(prob(5))
			emote("warcry")
	. = ..()

/mob/living/carbon/human/species/human/northern/deranged_knight/death(gibbed, nocutscene)
	if(preset == "matthios")
		if(prob(95))
			say("Matthios, I have failed you...", forced = TRUE)
		else
			say("Matthios, is this true?!", forced = TRUE)
	else if(preset == "zizo")
		say("Zizo, forgive me!", forced = TRUE)
	else if(preset == "graggar")
		say("No more... Blood!")
	emote("painscream")
	. = ..()
	if(!gibbed)
		dust(FALSE, FALSE, TRUE)

/datum/outfit/job/roguetown/quest_miniboss/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.STASTR = 15
	H.STASPD = 14
	H.STACON = 15
	H.STAWIL = 14
	H.STAPER = 12
	H.STAINT = 12
	H.STALUC = 10

	H.adjust_skillrank(/datum/skill/combat/whipsflails, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/maces, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/axes, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/swords, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/shields, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, 4, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, 4, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 2, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 2, TRUE)

/datum/outfit/job/roguetown/quest_miniboss/matthios/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/matthios
	pants = /obj/item/clothing/under/roguetown/platelegs/matthios
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/matthios
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/matthios
	head = /obj/item/clothing/head/roguetown/helmet/heavy/matthios
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	r_hand = /obj/item/rogueweapon/flail/peasantwarflail/matthios
	mask = /obj/item/clothing/mask/rogue/facemask/steel

/datum/outfit/job/roguetown/quest_miniboss/zizo/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/zizo
	pants = /obj/item/clothing/under/roguetown/platelegs/zizo
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/zizo
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	gloves = /obj/item/clothing/gloves/roguetown/plate/zizo
	head = /obj/item/clothing/head/roguetown/helmet/heavy/zizo
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	r_hand = /obj/item/rogueweapon/sword/long/zizo
	mask = /obj/item/clothing/mask/rogue/facemask/steel

/datum/outfit/job/roguetown/quest_miniboss/graggar/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/fluted/graggar
	pants = /obj/item/clothing/under/roguetown/platelegs/graggar
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor/graggar
	gloves = /obj/item/clothing/gloves/roguetown/plate/graggar
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	head = /obj/item/clothing/head/roguetown/helmet/heavy/graggar
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	r_hand = /obj/item/rogueweapon/greataxe/steel/doublehead/graggar
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	cloak = /obj/item/clothing/cloak/graggar

/datum/outfit/job/roguetown/quest_miniboss/blacksteel/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/blacksteel/modern
	pants = /obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	shoes = /obj/item/clothing/shoes/roguetown/boots/blacksteel/modern/plateboots
	gloves = /obj/item/clothing/gloves/roguetown/blacksteel/modern/plategloves
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	head = /obj/item/clothing/head/roguetown/helmet/blacksteel/modern/armet
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	r_hand = /obj/item/rogueweapon/greatsword
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	wrists = /obj/item/clothing/wrists/roguetown/bracers

/datum/outfit/job/roguetown/quest_miniboss/hedge_knight/pre_equip(mob/living/carbon/human/H)
	. = ..()

	armor = /obj/item/clothing/suit/roguetown/armor/plate/full/fluted
	pants = /obj/item/clothing/under/roguetown/platelegs
	shoes = /obj/item/clothing/shoes/roguetown/boots/armor
	gloves = /obj/item/clothing/gloves/roguetown/plate
	head = /obj/item/clothing/head/roguetown/helmet/heavy/sheriff
	neck = /obj/item/clothing/neck/roguetown/gorget/steel
	r_hand = /obj/item/rogueweapon/greatsword/grenz
	mask = /obj/item/clothing/mask/rogue/facemask/steel
	belt = /obj/item/storage/belt/rogue/leather/steel/tasset
	beltl = /obj/item/flashlight/flare/torch/lantern
	beltr = /obj/item/rogueweapon/sword/long
	wrists = /obj/item/clothing/wrists/roguetown/bracers
	cloak = /obj/item/clothing/cloak/tabard/stabard/black

/*
 * Goon preset
 * Intended to support knight, but should not have any special/overly expensive gear.
*/

/mob/living/carbon/human/species/human/northern/highwayman/dk_goon
	faction = list("dundead")

/mob/living/carbon/human/species/human/northern/deranged_knight/matthios
	forced_preset = "matthios"

/mob/living/carbon/human/species/human/northern/deranged_knight/zizo
	forced_preset = "zizo"

/mob/living/carbon/human/species/human/northern/deranged_knight/graggar
	forced_preset = "graggar"

/mob/living/carbon/human/species/human/northern/deranged_knight/hedgeknight
	forced_preset = "hedgeknight"
