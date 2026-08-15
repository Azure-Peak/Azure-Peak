GLOBAL_LIST_INIT(skeleton_aggro, list(
	",w Kill...",
	",w Fight...",
	",w Destroy...",
	"*laugh",
	"*laugh",
	"*rage",
	"*rage",
	"*rage",
)) //Single Words or noises, feral and empty of mind.

/mob/living/carbon/human/species/skeleton
	name = "skeleton"

	race = /datum/species/human/northern
	gender = MALE
	bodyparts = list(/obj/item/bodypart/chest, /obj/item/bodypart/head, /obj/item/bodypart/l_arm,
						/obj/item/bodypart/r_arm, /obj/item/bodypart/r_leg, /obj/item/bodypart/l_leg)
	faction = list(FACTION_UNDEAD)
	var/skel_outfit = /datum/outfit/job/roguetown/npc/skeleton
	var/skel_fragile = FALSE
	ambushable = FALSE
	rot_type = null
	base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY
	possible_mmb_intents = list(INTENT_SPECIAL, INTENT_JUMP, INTENT_KICK, INTENT_BITE)
	cmode_music = 'sound/music/combat_weird.ogg'

/mob/living/carbon/human/species/skeleton/npc
	ambush_faction = "undead"
	ai_controller = /datum/ai_controller/human_npc
	skel_fragile = TRUE
	blood_toll_bucket = STATS_KILLED_DEADITES

/mob/living/carbon/human/species/skeleton/npc/after_creation()
	..()
	gender = pick(MALE, FEMALE)
	dna.species.handle_body(src)
	update_body()
	src.grant_language(/datum/language/undead)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.skeleton_aggro, TRUE)
	src.regenerate_icons() //Fixes the weird body with random genders for NPCs.

/mob/living/carbon/human/species/skeleton/npc/ambush
	threat_point = THREAT_MODERATE

/mob/living/carbon/human/species/skeleton/Initialize(mapload)
	. = ..()
	cut_overlays()
	spawn(10)
		after_creation()

/mob/living/carbon/human/species/skeleton/after_creation()
	..()
	if(ai_controller)
		AddComponent(/datum/component/ai_aggro_system)
		ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	if(dna && dna.species)
		dna.species.species_traits |= NOBLOOD
		dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/skeleton]
		dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/skeleton]
	for(var/datum/charflaw/cf in charflaws)
		charflaws.Remove(cf)
		QDEL_NULL(cf)
	name = "Skeleton"
	real_name = "Skeleton"
	voice_type = VOICE_TYPE_MASC //So that "Unknown Man" properly substitutes in with face cover
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NO_VOICEPACK_OVERRIDE, TRAIT_GENERIC) //Yeah, no more daintly skeletons W/the moaning noises.
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DEATHLESS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	if(skel_fragile)
		ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	else
		ADD_TRAIT(src, TRAIT_SELF_SUSTENANCE, TRAIT_GENERIC) // If not fragile, then you're summoned by a real antag
		// Therefore you get the trait to grind up to Jman.
	skeletonize()
	if(skel_outfit)
		var/datum/outfit/OU = new skel_outfit
		if(OU)
			equipOutfit(OU)

/mob/living/carbon/human/species/skeleton/fully_heal(admin_revive = FALSE, break_restraints = FALSE)
	. = ..()
	skeletonize()

/mob/living/carbon/human/species/skeleton/proc/skeletonize()
	mob_biotypes |= MOB_UNDEAD
	var/obj/item/bodypart/O = get_bodypart(BODY_ZONE_R_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	O = get_bodypart(BODY_ZONE_L_ARM)
	if(O)
		O.drop_limb()
		qdel(O)
	regenerate_limb(BODY_ZONE_R_ARM)
	regenerate_limb(BODY_ZONE_L_ARM)
	var/obj/item/organ/eyes/eyes = getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)
	eyes = SSwardrobe.provide_type(/obj/item/organ/eyes/night_vision/zombie)
	eyes.Insert(src)
	for(var/obj/item/bodypart/B in bodyparts)
		B.skeletonize(FALSE)
	update_body()

/mob/living/carbon/human/species/skeleton/npc/no_equipment
	skel_outfit = null

/mob/living/carbon/human/species/skeleton/npc/no_equipment/after_creation()
	..()
	STAINT = 1

/mob/living/carbon/human/species/skeleton/no_equipment
	skel_outfit = null
	var/datum/weakref/crystal

/mob/living/carbon/human/species/skeleton/no_equipment/death(gibbed, nocutscene = FALSE)
	..()
	var/obj/item/necro_relics/necro_crystal/active_crystal = crystal?.resolve()
	if(active_crystal)
		for(var/datum/weakref/W in active_crystal.active_skeletons)
			if(W.resolve() == src)
				active_crystal.active_skeletons -= W
	active_crystal = null
	gib(no_brain = TRUE, no_organs = TRUE)

////////////////////////////////
////////////////////////////////
////////////////////////////////

/mob/living/carbon/human/species/skeleton/conjured
	ai_controller = /datum/ai_controller/human_npc/melee
	d_intent = INTENT_PARRY
	faction = list()
	ambushable = FALSE
	skel_fragile = TRUE
	skel_outfit = null

	var/loadout = "sword_shield"
	var/arcane_scale = 3
	var/gear_tier = 1
	var/datum/weakref/summoner_ref

/mob/living/carbon/human/species/skeleton/conjured/Destroy()
	release_conjured_gear()
	return ..()

/mob/living/carbon/human/species/skeleton/conjured/after_creation()
	..()

	patron = /datum/patron/inhumen/zizo

	AddComponent(/datum/component/ai_aggro_system)

	job = "Lesser Skeleton"
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUSTABLE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUST_DELETE_GEAR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_DUALWIELDER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CABAL, TRAIT_GENERIC)

	var/datum/component/conjured_minion/minion = GetComponent(/datum/component/conjured_minion)
	var/mob/living/master = minion?.summoner_ref?.resolve()

	if(master)
		if(master.mind && master.mind.current)
			master = master.mind.current
		summoner = master.real_name
		faction = list("[master.real_name]_faction")
		apply_fellowship_faction(master, src)
		faction -= FACTION_UNDEAD
		faction -= FACTION_SKELETON
		faction -= FACTION_DUNDEAD

	switch(loadout)
		if("sword_shield")
			outfit_skeleton(new /datum/outfit/job/roguetown/conjured_skeleton/sword_shield)
		if("spear")
			outfit_skeleton(new /datum/outfit/job/roguetown/conjured_skeleton/spear)
		if("dual_daggers")
			outfit_skeleton(new /datum/outfit/job/roguetown/conjured_skeleton/dual_daggers)

	def_intent_change(INTENT_PARRY)

	regenerate_icons()

/mob/living/carbon/human/species/skeleton/conjured/proc/outfit_skeleton(datum/outfit/outfit)
	if(!outfit)
		return

	equipOutfit(outfit)

	for(var/obj/item/gear in (get_equipped_items() + held_items))
		ADD_TRAIT(gear, TRAIT_NODROP, TRAIT_GENERIC)

/datum/outfit/job/roguetown/conjured_skeleton

/datum/outfit/job/roguetown/conjured_skeleton/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	H.STASTR = 10
	H.STASPD = 12
	H.STACON = 8
	H.STAWIL = 10
	H.STAPER = 10
	H.STAINT = 1
	H.STALUC = 10
	H.adjust_skillrank(/datum/skill/combat/swords, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/combat/polearms, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/combat/knives, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/combat/wrestling, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/combat/unarmed, SKILL_LEVEL_APPRENTICE, TRUE)
	H.adjust_skillrank(/datum/skill/misc/swimming, 3, TRUE)
	H.adjust_skillrank(/datum/skill/misc/climbing, 3, TRUE)

/datum/outfit/job/roguetown/conjured_skeleton/sword_shield/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	r_hand = /obj/item/rogueweapon/sword/sabre/palloy
	l_hand = /obj/item/rogueweapon/shield/tower/metal/palloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	neck = /obj/item/clothing/neck/roguetown/gorget/copper
	head = /obj/item/clothing/head/roguetown/headband/bloodied
	pants = /obj/item/clothing/under/roguetown/heavy_leather_pants/bronzeskirt
	shirt = /obj/item/clothing/suit/roguetown/armor/leather/studded/cuirbouilli
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper

/datum/outfit/job/roguetown/conjured_skeleton/spear/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	r_hand = /obj/item/rogueweapon/spear/paalloy
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	neck = /obj/item/clothing/neck/roguetown/gorget/copper
	head = /obj/item/clothing/head/roguetown/helmet/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper

/datum/outfit/job/roguetown/conjured_skeleton/dual_daggers/pre_equip(mob/living/carbon/human/H, visualsOnly)
	. = ..()
	r_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/zizo
	l_hand = /obj/item/rogueweapon/huntingknife/idagger/steel/zizo
	shoes = /obj/item/clothing/shoes/roguetown/boots/leather
	gloves = /obj/item/clothing/gloves/roguetown/leather
	neck = /obj/item/clothing/neck/roguetown/gorget/copper
	head = /obj/item/clothing/head/roguetown/helmet/leather
	pants = /obj/item/clothing/under/roguetown/trou/leather
	shirt = /obj/item/clothing/suit/roguetown/armor/gambeson/light
	armor = /obj/item/clothing/suit/roguetown/armor/plate/cuirass/copper
	wrists = /obj/item/clothing/wrists/roguetown/bracers/copper
