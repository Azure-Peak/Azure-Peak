#define ZOMBIE_FIRST_BITE_CHANCE 15
#define ZOMBIE_BITE_CONVERSION_TIME 1.5 MINUTES

/datum/antagonist/zombie
	name = "Deadite"
	antag_hud_type = ANTAG_HUD_TRAITOR
	antag_hud_name = "zombie"
	show_in_roundend = FALSE
	rogue_enabled = TRUE
	/// SET TO FALSE IF WE DON'T TURN INTO ROTMEN WHEN REMOVED
	var/become_rotman = FALSE
	var/zombie_start
	var/revived = FALSE
	var/next_idle_sound

	antag_flags = FLAG_FAKE_ANTAG

	// CACHE VARIABLES SO ZOMBIFICATION CAN BE CURED
	var/was_i_undead = FALSE
	var/special_role
	var/ambushable = TRUE
	var/soundpack_m
	var/soundpack_f

	var/STASTR
	var/STASPD
	var/STAINT
	var/STACON
	var/STAWIL
	var/cmode_music
	var/list/base_intents

	/// Whether or not we have been turned
	var/has_turned = FALSE
	/// Last time we bit someone - Zombies will try to bite after 10 seconds of not biting
	var/last_bite
	/// Traits applied to the owner mob when we turn into a zombie
	var/static/list/traits_zombie = list(
		TRAIT_INFINITE_STAMINA,
		TRAIT_NOMOOD,
		TRAIT_NOHUNGER,
		TRAIT_EASYDISMEMBER,
		TRAIT_NOPAIN,
		TRAIT_NOPAINSTUN,
		TRAIT_NOBREATH,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_CHUNKYFINGERS,
		TRAIT_NOSLEEP,
		TRAIT_BASHDOORS,
		TRAIT_SPELLCOCKBLOCK,
		TRAIT_BLOODLOSS_IMMUNE,
		TRAIT_ZOMBIE_SPEECH,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_ROTMAN,
		TRAIT_NORUN,
		TRAIT_SILVER_WEAK
	)
	/// Traits applied to the owner when we are cured and turn into just "rotmen"
	var/static/list/traits_rotman = list(
		TRAIT_EASYDISMEMBER,
		TRAIT_NOPAIN,
		TRAIT_NOPAINSTUN,
		TRAIT_NOBREATH,
		TRAIT_TOXIMMUNE,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_ROTMAN,
		TRAIT_SILVER_WEAK,
	)

/datum/antagonist/zombie/examine_friendorfoe(datum/antagonist/examined_datum,mob/examiner,mob/examined)
	if(istype(examined_datum, /datum/antagonist/vampire))
		if(!SEND_SIGNAL(examined_datum.owner, COMSIG_DISGUISE_STATUS))
			return span_boldnotice("Another deadite.")
	if(istype(examined_datum, /datum/antagonist/zombie))
		var/datum/antagonist/zombie/fellow_zombie = examined_datum
		return span_boldnotice("Another deadite. [fellow_zombie.has_turned ? "My ally." : span_warning("Hasn't turned yet.")]")
	if(istype(examined_datum, /datum/antagonist/skeleton))
		return span_boldnotice("Another deadite.")

//Housekeeping/saving variables from pre-zombie

/*Death transformation process goes:
	death ->
	/mob/living/carbon/human/death(gibbed) ->
	zombie_check_can_convert() ->
	zombie.on_gain() ->
	rotting.dm process ->
	time passes ->
	zombie.wake_zombie() ->
	transform
*/
/*
	Deadite transformation is 2 ways. First is on the initial bite (low chance) and second is on being chewed on.

	Initial bite is: other_mobs.dm, /mob/living/carbon/onbite(mob/living/carbon/human/user) ->
	bite_victim.zombie_infect_attempt() ->
	attempt_zombie_infection(src, "bite", ZOMBIE_BITE_CONVERSION_TIME) -> rng check here
	time passes ->
	wake_zombie.

	Wound transformation goes: grabbing.dm, /obj/item/grabbing/bite/proc/bitelimb(mob/living/carbon/human/user) ->
	/datum/wound/proc/zombie_infect_attempt() ->
	human_owner.attempt_zombie_infection(src, "wound", zombie_infection_time) ->
	time passes ->
	wake_zombie

	Infection transformation process goes -> infection -> timered transform in zombie_infect_attempt() [drink red/holy water and kill timer?] -> /datum/antagonist/zombie/proc/wake_zombie -> zombietransform
*/
/datum/antagonist/zombie/on_gain(admin_granted = FALSE)
	var/mob/living/carbon/human/zombie = owner?.current
	if(zombie)
		var/obj/item/bodypart/head = zombie.get_bodypart(BODY_ZONE_HEAD)
		if(!head)
			qdel(src)
			return
	zombie_start = world.time
	was_i_undead = zombie.mob_biotypes & MOB_UNDEAD
	special_role = zombie.mind?.special_role
	ambushable = zombie.ambushable
	if(zombie.dna?.species)
		soundpack_m = zombie.dna.species.soundpack_m
		soundpack_f = zombie.dna.species.soundpack_f
	base_intents = zombie.base_intents

	//Just need to clear it to snapshot. May get things we don't want to get.
	for(var/status_effect in zombie.status_effects)
		zombie.remove_status_effect(status_effect)
	zombie.grant_language(/datum/language/undead)
	var/datum/language_holder/language_holder = zombie.get_language_holder()
	language_holder.selected_default_language = /datum/language/undead

	src.STASTR = zombie.STASTR
	src.STASPD = zombie.STASPD
	src.STAINT = zombie.STAINT
	src.STACON = zombie.STACON
	src.STAWIL = zombie.STAWIL
	cmode_music = zombie.cmode_music

	//Special because deadite status is latent as opposed to the others.
	if(admin_granted)
		zombie.infected = TRUE
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(wake_zombie), zombie, FALSE, TRUE), 5 SECONDS, TIMER_STOPPABLE)
	return ..()

/*
	CHECK HERE IF ANY UN-ZOMBIFICATION ISSUES.
*/
///Remove zombification - cure rot, surgical rot remove
/datum/antagonist/zombie/on_removal()
	var/mob/living/carbon/human/zombie = owner?.current
	if(zombie)

		zombie.infected = FALSE // Makes sure admins removing deadification removes the infected var if they do it before they turn
		zombie.verbs -= /mob/living/carbon/human/proc/zombie_seek
		zombie.mind?.special_role = special_role
		zombie.ambushable = ambushable

		if(zombie.dna?.species)
			zombie.dna.species.soundpack_m = soundpack_m
			zombie.dna.species.soundpack_f = soundpack_f
		zombie.base_intents = base_intents
		zombie.update_a_intents()
		zombie.aggressive = FALSE
		zombie.mode = NPC_AI_OFF
		zombie.npc_jump_chance = initial(zombie.npc_jump_chance)
		zombie.rude = initial(zombie.rude)
		zombie.tree_climber = initial(zombie.tree_climber)
		for(var/datum/charflaw/cf in zombie.charflaws)
			cf.ephemeral = FALSE
		zombie.update_body()

		zombie.STASTR = src.STASTR
		zombie.STASPD = src.STASPD
		zombie.STAINT = src.STAINT
		zombie.STACON = src.STACON
		zombie.STAWIL = src.STAWIL



		GLOB.dead_mob_list -= zombie // Remove it from global dead/alive mob list here here, if they're a zombie they probably died.
									 // There is a better way to maintain it but needs overhaul. Will cover the two methods of zombie
		GLOB.alive_mob_list += zombie// in both cure rot and medicine.

		zombie.cmode_music = cmode_music

		for(var/trait in traits_zombie)
			REMOVE_TRAIT(zombie, trait, "[type]")
		zombie.remove_client_colour(/datum/client_colour/monochrome)
		zombie.remove_language(/datum/language/undead)
		var/datum/language_holder/language_holder = zombie.get_language_holder()
		language_holder.selected_default_language = null

		if(has_turned && become_rotman)
			zombie.STACON = max(zombie.STACON - 2, 1) //ur rotting bro
			zombie.STASPD = max(zombie.STASPD - 3, 1)
			zombie.STAINT = max(zombie.STAINT - 3, 1)
			for(var/trait in traits_rotman)
				ADD_TRAIT(zombie, trait, "[type]")
			to_chat(zombie, span_green("I no longer crave for flesh... <i>But I still feel ill.</i>"))
		else
			if(!was_i_undead)
				zombie.mob_biotypes &= ~MOB_UNDEAD
			zombie.faction -= "undead"
			zombie.faction -= "zombie"
			zombie.faction += "neutral"
			zombie.regenerate_organs()
			if(has_turned)
				to_chat(zombie, span_green("I no longer crave for flesh..."))

		for(var/obj/item/bodypart/zombie_part as anything in zombie.bodyparts) //Cure all limbs
			zombie_part.rotted = FALSE
			zombie_part.update_disabled()
			zombie_part.update_limb()
		zombie.update_body()
	// Bandaid to fix the zombie ghostizing not allowing you to re-enter
	if(zombie)
		var/mob/dead/observer/ghost = zombie.get_ghost(TRUE)
		if(ghost)
			ghost.can_reenter_corpse = TRUE
	return ..()

//Housekeeping's done. Transform into zombie.
/datum/antagonist/zombie/proc/transform_zombie()
	var/mob/living/carbon/human/zombie = owner.current
	if(!zombie)
		qdel(src)
		return
	var/obj/item/bodypart/head = zombie.get_bodypart(BODY_ZONE_HEAD)
	if(!head) //If no head then unable to become zombie
		qdel(src)
		return

	revived = TRUE //so we can die for real later

	for(var/trait_applied in traits_zombie)
		ADD_TRAIT(zombie, trait_applied, "[type]")
	if(zombie.mind)
		special_role = zombie.mind.special_role
		zombie.mind.special_role = name
	if(zombie.dna?.species)
		soundpack_m = zombie.dna.species.soundpack_m
		soundpack_f = zombie.dna.species.soundpack_f
		zombie.dna.species.soundpack_m = new /datum/voicepack/zombie/m()
		zombie.dna.species.soundpack_f = new /datum/voicepack/zombie/f()
	base_intents = zombie.base_intents
	zombie.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	zombie.update_a_intents()
	zombie.aggressive = TRUE
	zombie.mode = NPC_AI_IDLE
	zombie.handle_ai()
	ambushable = zombie.ambushable
	zombie.ambushable = FALSE

	for(var/datum/charflaw/cf in zombie.charflaws)
		cf.ephemeral = TRUE
	zombie.mob_biotypes |= MOB_UNDEAD
	zombie.faction += "undead"
	zombie.faction += "zombie"
	zombie.faction -= "neutral"
	zombie.verbs |= /mob/living/carbon/human/proc/zombie_seek
	for(var/obj/item/bodypart/zombie_part as anything in zombie.bodyparts)
		if(!zombie_part.rotted && !zombie_part.skeletonized)
			zombie_part.rotted = TRUE
		zombie_part.update_disabled()

	zombie.add_client_colour(/datum/client_colour/monochrome)
	var/obj/item/organ/eyes/eyes = zombie.getorganslot(ORGAN_SLOT_EYES) //Add zombie eyes(nightvision)
	if(eyes)
		eyes.Remove(zombie,1)
		QDEL_NULL(eyes)
	eyes = new /obj/item/organ/eyes/night_vision/zombie
	eyes.Insert(zombie)

//Drop held items

	zombie.dropItemToGround(zombie.get_active_held_item(), TRUE)
	zombie.dropItemToGround(zombie.get_inactive_held_item(), TRUE)

//Add claws here if wanted.

	zombie.update_body()
	to_chat(zombie, span_narsiesmall("Hungry... so hungry... I CRAVE FLESH!"))
	zombie.cmode_music = 'sound/music/combat_weird.ogg'


	// This is the original first commit values for it, aka 5-7
	zombie.STASPD = rand(5,7)

	zombie.STAINT = 1
	last_bite = world.time
	has_turned = TRUE
	// Drop your helm and gorgies boy you won't need it anymore!!!
	var/static/list/removed_slots = list(
		SLOT_HEAD,
		SLOT_WEAR_MASK,
		SLOT_MOUTH,
		//SLOT_NECK,
	)
	for(var/slot in removed_slots)
		zombie.dropItemToGround(zombie.get_item_by_slot(slot), TRUE)

// Infected wake param is just a transition from living to zombie, via zombie_infect()
// Prevoously you just died without warning in ~3 min, now you just become an antag instead of having to die first if infected.
/datum/antagonist/zombie/proc/wake_zombie(infected_wake = FALSE)
	if(!owner.current)
		return
	var/mob/living/carbon/human/zombie = owner.current
	if(!zombie || !istype(zombie))
		return
	var/obj/item/bodypart/head = zombie.get_bodypart(BODY_ZONE_HEAD)
	if(!head)
		qdel(src)
		return
	if(zombie.stat != DEAD && !infected_wake)
		qdel(src)
		return
	if(istype(zombie.loc, /obj/structure/closet/dirthole) || istype(zombie.loc, /obj/structure/closet/crate/coffin))
		qdel(src)
		return

	zombie.can_do_sex = FALSE	//no fuck off

	zombie.blood_volume = BLOOD_VOLUME_NORMAL
	zombie.setOxyLoss(0, updating_health = FALSE, forced = TRUE)
	zombie.setToxLoss(0, updating_health = FALSE, forced = TRUE)
	if(!infected_wake)	// if we died, heal all this too
		zombie.adjustBruteLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
		zombie.adjustFireLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
		zombie.heal_wounds(INFINITY)
	zombie.stat = UNCONSCIOUS
	zombie.updatehealth()
	zombie.update_mobility()
	zombie.update_sight()
	zombie.reload_fullscreen()
	transform_zombie()
	if(zombie.stat >= DEAD)
		//could not revive
		qdel(src)

/datum/antagonist/zombie/greet()
	to_chat(owner.current, span_userdanger("Death is not the end..."))
	return ..()

/*
	Proc for our newly infected to wake up as a zombie
*/
/proc/wake_zombie(mob/living/carbon/zombie, infected_wake = FALSE, converted = FALSE)
	if(!zombie.infected) //Ensure they werent cured
		return

	if (!zombie || QDELETED(zombie))
		return

	if (!istype(zombie, /mob/living/carbon/human)) // Ensure the zombie is human
		return

	var/obj/item/bodypart/head = zombie.get_bodypart(BODY_ZONE_HEAD)
	if (!head) // Missing head
		qdel(zombie)
		return

	if (zombie.stat != DEAD && infected_wake) // Died too hard
		qdel(zombie)
		return

	if (istype(zombie.loc, /obj/structure/closet/dirthole) || istype(zombie.loc, /obj/structure/closet/crate/coffin)) // Buried
		qdel(zombie)
		return

	record_round_statistic(STATS_DEADITES_WOKEN_UP)
	// Heal the zombie
	zombie.blood_volume = BLOOD_VOLUME_NORMAL
	zombie.setOxyLoss(0, updating_health = FALSE, forced = TRUE) // Zombies don't breathe
	zombie.setToxLoss(0, updating_health = FALSE, forced = TRUE) // Zombies are immune to poison

	if (infected_wake || converted)
		zombie.adjustBruteLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
		zombie.adjustFireLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
		zombie.heal_wounds(INFINITY) // Heal all non-permanent wounds
		to_chat(zombie, span_userdanger("Your bones snap back into place and your flesh knits itself back together as you rise again in undeath."))

	zombie.stat = UNCONSCIOUS // Start unconscious
	zombie.updatehealth() // Then check if the mob should wake up
	zombie.update_mobility()
	zombie.update_sight()
	zombie.reload_fullscreen()
	zombie.infected = FALSE //The infection has finished and they are now a zombie

	var/datum/antagonist/zombie/zombie_antag = zombie.mind?.has_antag_datum(/datum/antagonist/zombie)
	if(zombie_antag)
		zombie_antag.transform_zombie()
	else
		CRASH("[zombie] tried to wake up as a zombie but did not have the antag set.")

	if (zombie.stat >= DEAD) // We couldn't bring them back to life as a zombie. Nothing we can do.
		qdel(zombie)
		return


	if (converted || infected_wake)
		zombie.flash_fullscreen("redflash3")
		zombie.emote("scream") // Warning for nearby players
		zombie.Knockdown(1)

///Making sure they're not any other antag as well as adding the zombie datum to their mind
/mob/living/carbon/human/proc/zombie_check_can_convert()
	if(!mind)
		return
	if(mind.has_antag_datum(/datum/antagonist/vampire))
		return
	if(mind.has_antag_datum(/datum/antagonist/werewolf))
		return
	if(mind.has_antag_datum(/datum/antagonist/zombie))
		return
	if(mind.has_antag_datum(/datum/antagonist/skeleton))
		return
	if(mind.has_antag_datum(/datum/antagonist/gnoll))
		return FALSE
	if(HAS_TRAIT(src, TRAIT_ZOMBIE_IMMUNE))
		return
	return mind.add_antag_datum(/datum/antagonist/zombie)

#undef ZOMBIE_FIRST_BITE_CHANCE
#undef ZOMBIE_BITE_CONVERSION_TIME

