GLOBAL_LIST_INIT(dwarfskeleton_aggro, world.file2list("strings/rt/dskeletonaggrolines.txt"))

/mob/living/carbon/human/species/dwarfskeleton

	race = /datum/species/dwarf/mountain
	gender = MALE
	faction = list(FACTION_DUNDEAD)
	ambushable = FALSE
	ai_controller = /datum/ai_controller/human_npc
	cmode = 1
	setparrytime = 30
	a_intent = INTENT_HELP
	d_intent = INTENT_PARRY //even in undeath dwarves parry. Dodging aint proper dorf behavior
	selected_default_language = /datum/language/dwarvish
	possible_mmb_intents = list(INTENT_BITE, INTENT_JUMP, INTENT_KICK, INTENT_SPECIAL) //intents given in case of player controlled
	npc_archetype = /datum/npc_archetype/dwarfskeleton/warrior

/mob/living/carbon/human/species/dwarfskeleton/ambush
	threat_point = THREAT_ELITE
	ambush_faction = "undead"


/mob/living/carbon/human/species/dwarfskeleton/Initialize(mapload)
	. = ..()
	cut_overlays()
	if(!npc_archetype)
		spawn(10)
			after_creation()

/mob/living/carbon/human/species/dwarfskeleton/after_creation()
	var/obj/item/organ/eyes/eyes = src.getorganslot(ORGAN_SLOT_EYES)
	if(eyes)
		eyes.Remove(src,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(src)
	for(var/obj/item/bodypart/B in src.bodyparts)
		B.skeletonize(FALSE)
	..()
	AddComponent(/datum/component/ai_aggro_system)
	SEND_SIGNAL(src, COMSIG_MOB_MODIFY_AGGRO_LINES, GLOB.dwarfskeleton_aggro, TRUE)
	if(src.dna && src.dna.species)
		src.dna.species.species_traits |= NOBLOOD
		src.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/skeleton]
	for(var/datum/charflaw/cf in charflaws)
		charflaws.Remove(cf)
		QDEL_NULL(cf)
	mob_biotypes = MOB_UNDEAD
	real_name = "Dwarven Skeleton"
	grant_language(/datum/language/undead)
	ADD_TRAIT(src, TRAIT_NOMOOD, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOHUNGER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_EASYDISMEMBER, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOBREATH, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_BREADY, TRAIT_GENERIC) // We're moving away from infinite green, even on skeletons.
	ADD_TRAIT(src, TRAIT_NOPAIN, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_TOXIMMUNE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_LEECHIMMUNE, INNATE_TRAIT)
	ADD_TRAIT(src, TRAIT_LIMBATTACHMENT, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_MEDIUMARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_HEAVYARMOR, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_SILVER_WEAK, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NPC_EXAMINE, TRAIT_GENERIC)
	ADD_TRAIT(src, TRAIT_NOZIZORECRUIT, TRAIT_GENERIC) //High-End Loot Dungeon - So no Taming these.
	update_body()

/mob/living/carbon/human/species/dwarfskeleton/ambush/knight
	npc_archetype = /datum/npc_archetype/dwarfskeleton/knight
