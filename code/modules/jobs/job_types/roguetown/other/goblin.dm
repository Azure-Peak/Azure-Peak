/datum/job/roguetown/goblin
	title = "Goblin"
	flag = GOBLIN
	department_flag = ANTAGONIST
	faction = "Station"
	total_positions = 0
	spawn_positions = 0
	min_pq = null //no pq
	max_pq = null

	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	tutorial = "Make Graggar proud or die trying."

	outfit = /datum/outfit/job/roguetown/npc/goblin
	show_in_credits = FALSE
	give_bank_account = FALSE
/datum/job/roguetown/goblin/equip(mob/living/carbon/human/H, visualsOnly, announce, latejoin, datum/outfit/outfit_override, client/preference_source)
	. = ..()
	return  H.change_mob_type(/mob/living/carbon/human/species/goblin/cave, delete_old_mob = TRUE)

/datum/job/roguetown/goblin/after_spawn(mob/living/L, mob/M, latejoin = TRUE)
	..()
	if(L)
		var/mob/living/carbon/human/H = L
		H.set_species(/datum/species/goblin/cave)
		if(M.mind)
			M.mind.special_role = "goblin"
			M.mind.assigned_role = "goblin"
			M.mind.current.job = null
		if(H.dna && H.dna.species)
			H.dna.species.species_traits |= NOBLOOD
			H.dna.species.soundpack_m = new /datum/voicepack/other/goblin()
			H.dna.species.soundpack_f = new /datum/voicepack/other/goblin()
		var/obj/item/headdy = H.get_bodypart("head")
		if(headdy)
			headdy.icon = 'icons/roguetown/mob/monster/goblins.dmi'
			headdy.icon_state = "[H.dna.species.id]_head"
			headdy.sellprice = rand(7,20)
		H.regenerate_limb(BODY_ZONE_R_ARM)
		H.regenerate_limb(BODY_ZONE_L_ARM)
		H.remove_all_languages()
		H.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/simple/claw)
		H.update_a_intents()
		H.set_patron(/datum/patron/inhumen/graggar)

		var/obj/item/organ/eyes/eyes = H.getorganslot(ORGAN_SLOT_EYES)
		if(eyes)
			eyes.Remove(H,1)
			QDEL_NULL(eyes)
		eyes = new /obj/item/organ/eyes/night_vision/zombie
		eyes.Insert(H)
		H.ambushable = FALSE
		H.underwear = "Nude"
		if(H.charflaw)
			QDEL_NULL(H.charflaw)
		H.update_body()
		H.faction = list("orcs")
		H.name = "goblin"
		H.real_name = "goblin"
		ADD_TRAIT(H, TRAIT_NOMOOD, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_NOHUNGER, TRAIT_GENERIC)
		ADD_TRAIT(H, TRAIT_CRITICAL_WEAKNESS, TRAIT_GENERIC)
