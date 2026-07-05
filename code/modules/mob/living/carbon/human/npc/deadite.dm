/mob/living/carbon/human/species/npc/deadite
	d_intent = INTENT_PARRY //Test if stuff breaks because make_deadite() should override this.
	dodgetime = 30
	ambushable = FALSE

/mob/living/carbon/human/species/npc/deadite/Initialize()
	. = ..()
	//picked from a list because 1: Races that look better w/deaditing here 2: We need deadite infectable races for immersion's sake I.E not sun elves 3: we can bias towards common azurian races
	//Yes it requires spamming the list with several entries to weight it, if you can do better. please do so. this sucks.
	var/species = list(
		/datum/species/human/northern,
		/datum/species/human/northern,
		/datum/species/human/northern,
		/datum/species/human/northern,
		/datum/species/elf/wood, //Extra bias towards humens and elves/half elves Because deadites are locals likely
		/datum/species/elf/wood,
		/datum/species/elf/wood,
		/datum/species/elf/wood,
		/datum/species/human/halfelf,
		/datum/species/human/halfelf,
		/datum/species/human/halfelf,
		/datum/species/human/halfelf,
		/datum/species/dwarf/mountain, //Racial bias ticks of w/other races from here on
		/datum/species/goblinp,
		/datum/species/elf/dark,
		/datum/species/aasimar,
		/datum/species/halforc,
		/datum/species/tieberian,
		/datum/species/anthromorph,
		/datum/species/anthromorphsmall,
		/datum/species/demihuman,
		/datum/species/akula,
		/datum/species/moth,
		/datum/species/tabaxi,
		/datum/species/vulpkanin,
		/datum/species/vulpkanin,
		/datum/species/dracon,
	)

	set_species(pick(species))
	gender = pick(MALE, FEMALE)
	dna.species.handle_body(src)
	dna.species.random_character(src)
	//Random voices, this can probably be more random-ish but it'll do for now
	random_voice_NPC()
	random_hair_NPC()

	var/list/deadite_firstnames = world.file2list("strings/rt/names/other/deaditenpcfirst.txt")
	var/list/deadite_lastnames  = world.file2list("strings/rt/names/other/deaditenpclast.txt")


	real_name = "[pick(deadite_firstnames)] [pick(deadite_lastnames)]"

	addtimer(CALLBACK(src, PROC_REF(after_creation)), 1 SECONDS) //A second delay, let us race up first

/mob/living/carbon/human/species/npc/deadite/after_creation()
	. = ..()
	equipOutfit(new /datum/outfit/job/roguetown/deadite)
	make_deadite()

/datum/outfit/job/roguetown/deadite/pre_equip(mob/living/carbon/human/H)
	..()
	//We simulate being a """deadite""" here
	head = null
	beltr = null
	beltl = null
	if(prob(30))
		cloak = /obj/item/clothing/cloak/raincloak/brown
	else
		cloak = null
	if(prob(10))
		gloves = /obj/item/clothing/gloves/roguetown/fingerless
	else
		gloves = null

	if(H.gender == FEMALE)
		armor = /obj/item/clothing/suit/roguetown/shirt/rags
	else
		armor = null
		pants = /obj/item/clothing/under/roguetown/tights/vagrant
		if(prob(50))
			pants = /obj/item/clothing/under/roguetown/tights/vagrant/l
		shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant
		if(prob(50))
			shirt = /obj/item/clothing/suit/roguetown/shirt/undershirt/vagrant/l

/mob/living/carbon/human/proc/deadite_get_aimheight(victim)
	if(!(mobility_flags & MOBILITY_STAND))
		return rand(1, 2) // Bite their ankles!
	return pick(rand(11, 13), rand(14, 17), rand(5, 8)) // Chest, neck, and mouth; face and ears; arms and hands.

// This proc exists because non-converted deadites don't have minds and can't have the antag datum
// So we need two separate entry points for this logic
/mob/living/carbon/human/proc/do_deadite_attack(mob/living/victim)
	// first, we try to bite
	if(try_do_deadite_bite(victim))
		return TRUE // spent our turn
	return FALSE

/mob/living/carbon/human/proc/try_do_deadite_bite(mob/living/victim)
	if(!src || stat >= DEAD)
		return FALSE
	
	var/obj/item/grabbing/bite/bite = get_item_by_slot(SLOT_MOUTH)
	if(istype(bite))
		// 50% chance to continue biting if already started
		if(prob(50))
			bite.bitelimb(src)
			return TRUE
		return FALSE // try something else like grappling

	if(!victim) // if we aren't passed a target, find one at random from nearby. this is currently unused
		for(var/mob/living/carbon/human in view(1, src))
			if(human == src) //prevent self biting
				continue
			if((human.mob_biotypes & MOB_UNDEAD) || ("undead" in human.faction) || HAS_TRAIT(human, TRAIT_ZOMBIE_IMMUNE))
				continue
			victim = human

	if(!victim) // still no one to bite
		return FALSE

	if(!get_location_accessible(src, BODY_ZONE_PRECISE_MOUTH, grabs = TRUE)) // can't bite, mouth is covered!
		return FALSE

	victim.onbite(src)
	// onbite doesn't directly apply the attack delay so we do it here
	changeNext_move(/datum/intent/bite::clickcd)
	return TRUE // use up our turn regardless of if the bite succeeded or not

/mob/living/carbon/human/proc/try_do_deadite_idle()

	if(mob_timers["deadite_idle"])
		if(world.time < mob_timers["deadite_idle"] + rand(5 SECONDS, 10 SECONDS))
			return
	mob_timers["deadite_idle"] = world.time
	emote("idle")
/// Use this to attempt to add the zombie antag datum to a human
/mob/living/carbon/human/proc/zombie_check()
	if(!mind)
		return
	var/already_zombie = mind.has_antag_datum(/datum/antagonist/zombie)
	if(already_zombie)
		return already_zombie
	if(mind.has_antag_datum(/datum/antagonist/vampire))
		return
	if(mind.has_antag_datum(/datum/antagonist/werewolf))
		return
	if(mind.has_antag_datum(/datum/antagonist/gnoll))
		return
	if(mind.has_antag_datum(/datum/antagonist/hag))
		return
	if(mind.has_antag_datum(/datum/antagonist/skeleton))
		return
	if(HAS_TRAIT(src, TRAIT_ZOMBIE_IMMUNE))
		return
	return mind.add_antag_datum(/datum/antagonist/zombie)
/**
 * This occurs when one zombie infects a living human, going into instadeath from here is kind of shit and confusing
 * We instead just transform at the end
 */
/mob/living/carbon/human/proc/zombie_infect_attempt()
	var/datum/antagonist/zombie/zombie_antag = zombie_check()
	if(!zombie_antag)
		return
	if(stat >= DEAD) //do shit the natural way i guess
		return FALSE
	if(HAS_TRAIT(src, TRAIT_ZOMBIE_IMMUNE))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_BLACKBLOOD) && prob(80))
		to_chat(src, span_danger("I feel something churning within my body... Luckily, it doesn't take hold."))
		return FALSE
	var/datum/status_effect/zombie_infection/infection = has_status_effect(/datum/status_effect/zombie_infection)
	if(infection)
		var/time_remaining = infection.transformation_time - world.time
		infection.transformation_time = world.time + (time_remaining * 0.8)
		return
	if(!prob(ZOMBIE_INFECTION_PROBABILITY))	//Failed the probability of infection
		return
	to_chat(src, span_danger("I feel horrible... REALLY horrible..."))
	mob_timers["puke"] = world.time
	vomit(1, blood = TRUE, stun = FALSE)
	src.infected = TRUE //Is this in use? Just in case it is
	apply_status_effect(/datum/status_effect/zombie_infection, 5 MINUTES, FALSE)
	return zombie_antag

/mob/living/carbon/human/proc/wake_zombie()
	var/datum/antagonist/zombie/zombie_antag = mind?.has_antag_datum(/datum/antagonist/zombie)
	if(!zombie_antag || zombie_antag.has_turned)
		return FALSE
	flash_fullscreen("redflash3")
	to_chat(src, span_danger("It hurts... Is this really the end for me?"))
	emote("scream") // heres your warning to others bro
	Knockdown(1)
	drop_all_held_items()
	zombie_antag.wake_zombie(TRUE)
	return TRUE
