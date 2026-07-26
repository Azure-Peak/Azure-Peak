#define ZOMBIE_FIRST_BITE_CHANCE 15
#define ZOMBIE_BITE_CONVERSION_TIME 1.5 MINUTES

/datum/antagonist/zombie
	name = "Deadite"
	antag_hud_type = ANTAG_HUD_ZOMBIE
	antag_hud_name = "zombie_hud"
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

	var/cmode_music
	var/list/base_intents

	/// Whether or not we have been turned
	var/has_turned = FALSE
	/// Last time we bit someone - Zombies will try to bite after 10 seconds of not biting
	var/last_bite
	/// Traits applied to the owner mob when we turn into a zombie
	var/static/list/traits_zombie = list(
		TRAIT_LIMBATTACHMENT,
		TRAIT_BREADY,
		TRAIT_NOMOOD,
		TRAIT_NOHUNGER,
		TRAIT_EASYDISMEMBER,
		TRAIT_NOPAIN,
		TRAIT_NOPAINSTUN,
		TRAIT_NOBREATH,
		TRAIT_DEATHLESS,
		TRAIT_TOXIMMUNE,
		TRAIT_CHUNKYFINGERS,
		TRAIT_NOSLEEP,
		TRAIT_BASHDOORS,
		TRAIT_SPELLCOCKBLOCK,
		TRAIT_BLOODLOSS_IMMUNE,
		TRAIT_ZOMBIE_SPEECH,
		TRAIT_ZOMBIE_IMMUNE,
		TRAIT_ROTMAN,
		//TRAIT_NORUN, re-add if zombies become too problematic
		TRAIT_SILVER_WEAK,
		TRAIT_DEADITE,
	)
	/// Traits applied to the owner when we are cured and turn into just "rotmen"
	var/static/list/traits_rotman = list(
		TRAIT_EASYDISMEMBER,
		TRAIT_NOPAIN,
		TRAIT_NOPAINSTUN,
		TRAIT_NOBREATH,
		TRAIT_DEATHLESS,
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
	if(istype(examined_datum, /datum/antagonist/lich))
		return span_boldnotice("Another deadite.")

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
		remove_antag_hud(antag_hud_type, owner.current) //No more HUD sire.
		zombie.infected = FALSE // Makes sure admins removing deadification removes the infected var if they do it before they turn
		remove_verb(zombie, /mob/living/carbon/human/proc/zombie_seek)
		zombie.mind?.special_role = special_role
		zombie.ambushable = ambushable

		if(zombie.dna?.species)
			zombie.dna.species.soundpack_m = soundpack_m
			zombie.dna.species.soundpack_f = soundpack_f
		zombie.base_intents = base_intents
		zombie.update_a_intents()
		for(var/datum/charflaw/cf in zombie.charflaws)
			cf.ephemeral = FALSE
		zombie.update_body()

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
	add_antag_hud(antag_hud_type, antag_hud_name, owner.current) //Easier for zombies to tell, fellow zombies.

	zombie.grant_language(/datum/language/undead) //Now we give you the language.
	var/datum/language_holder/language_holder = zombie.get_language_holder()
	language_holder.selected_default_language = /datum/language/undead

	for(var/trait_applied in traits_zombie)
		ADD_TRAIT(zombie, trait_applied, "[type]")
	if(zombie.mind)
		special_role = zombie.mind.special_role
		zombie.mind.special_role = name
	if(zombie.dna?.species)
		soundpack_m = zombie.dna.species.soundpack_m
		soundpack_f = zombie.dna.species.soundpack_f
		zombie.dna.species.soundpack_m = GLOB.voice_packs[/datum/voicepack/zombie/m]
		zombie.dna.species.soundpack_f = GLOB.voice_packs[/datum/voicepack/zombie/f]
	base_intents = zombie.base_intents
	zombie.base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB, /datum/intent/unarmed/claw)
	zombie.update_a_intents()
	ambushable = zombie.ambushable
	zombie.ambushable = FALSE

	for(var/datum/charflaw/cf in zombie.charflaws)
		cf.ephemeral = TRUE
	zombie.mob_biotypes |= MOB_UNDEAD
	zombie.faction += "undead"
	zombie.faction += "zombie"
	zombie.faction -= "neutral"
	add_verb(zombie, /mob/living/carbon/human/proc/zombie_seek)
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

//We greet them there, play a stinger and yeah.
	zombie.update_body()
	zombie.playsound_local(get_turf(zombie), 'sound/music/wolfintro.ogg', 80, FALSE, pressure_affected = FALSE) //Extra bit of AURA
	to_chat(zombie, span_infection("My mind grows numb and empty as unlyfe takes ahold of my body..."))
	zombie.cmode_music = 'sound/music/combat_weird.ogg'
	zombie.apply_status_effect(/datum/status_effect/debuff/deadite_grace)

	last_bite = world.time
	has_turned = TRUE
	// Drop whatever's in your mouth, a workaround for being gagged.
	// I know this has a flaw that Eora can shutdown deadites, I can't do much
	// About Eoran miracles being "no fun allowed", pacifistic zombies inherently
	// Are too funny, like absolver zombie just staring you down menacingly.
	var/static/list/removed_slots = list(
		SLOT_MOUTH,
	)
	for(var/slot in removed_slots)
		zombie.dropItemToGround(zombie.get_item_by_slot(slot), TRUE)

	record_round_statistic(STATS_DEADITES_WOKEN_UP) //Turning into a deadite in-general raises this now. ZIZO. ZIZO. ZIZO.

	//small cutscene now we are a zombie, phew! lets make it a little dramatic. This can probably be done in a far better way but whatever.

	sleep(0.1) //Quickly make sure we already cleared our stuns and stuff before applying more, we want to be lightning quick.
	zombie.Knockdown(33)
	zombie.Immobilize(33) //Don't want to move during this
	zombie.Stun(33)
	zombie.Jitter(15) //Convulse a bit.
	zombie.emote("groan") // First audio warning to nearby players on top of the above message
	zombie.drop_all_held_items()
	zombie.Unconscious(15) //Brief Knockout
	zombie.flash_fullscreen("redflash3")
	zombie.visible_message(span_warning("[zombie] convulses on the floor momentarily, skin rotting away unnaturally fast..."))
	sleep(2 SECONDS) //Second message, another small gap to notice something is very fucking wrong if the previous que wasn't enough.
	zombie.visible_message(span_warning("[zombie]'s lyfeless eyes begin to light up with an eerie glow."))
	zombie.vomit(1, blood = TRUE, stun = FALSE)
	playsound(get_turf(zombie), 'sound/magic/woundheal_crunch.ogg', 80, FALSE, -1) //Horrible noises
	to_chat(zombie, span_narsie("Death is not the end..."))
	sleep(2 SECONDS) //now get them up to go fight and die
	if(zombie.resting)
		zombie.set_resting(FALSE, FALSE) //GET UP, KILL, CONSUME.
	zombie.visible_message(span_danger("[zombie] stands back up.")) //On par with deadite animals reanimating.
	zombie.emote("rage") // This is where the fun begins
	playsound(get_turf(zombie), 'sound/magic/woundheal_crunch.ogg', 80, FALSE, -1) //More horrible noises
	to_chat(zombie, span_narsie(pick("SO... HUNGRY... CRAVE FLESH!", "FLESH... MUST HAVE FLESH!", "HUNGER... KILL... FLESH!")))
	zombie.set_blurriness(0) //Unblind us so we aren't blurred forever
	if(!zombie.cmode)	//Turns on combat mode if its not on, so you're immedately ready to do your thing
		zombie.toggle_cmode()

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
	zombie.handle_blood()
	zombie.refresh_blood_debuffs()
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

	// Heal the zombie
	zombie.blood_volume = BLOOD_VOLUME_NORMAL
	zombie.setOxyLoss(0, updating_health = FALSE, forced = TRUE) // Zombies don't breathe
	zombie.setToxLoss(0, updating_health = FALSE, forced = TRUE) // Zombies are immune to poison

	if (infected_wake || converted)
		zombie.adjustBruteLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
		zombie.adjustFireLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
		zombie.heal_wounds(INFINITY) // Heal all non-permanent wounds
		playsound(get_turf(zombie), 'sound/magic/woundheal_crunch.ogg', 80, FALSE, -1) //Horrible noises for yes, that.
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

/atom/movable/screen/alert/status_effect/debuff/deadite_grace
	name = "Necrotic Overdrive"
	desc = "My corroded Lux is ravaging throughout my decaying corpse. I cannot be stopped now, not while this lasts."
	icon_state = "rotted_body"

/datum/status_effect/debuff/deadite_grace
	id = "deadite_grace_period"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/deadite_grace
	duration = 3 MINUTES // this buff is cancelled early if you attack a mob with mind. Mind your targets, sire.

/datum/status_effect/debuff/deadite_grace/on_apply()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.status_flags |= GODMODE
	ADD_TRAIT(owner, TRAIT_NORUN, id)
	ADD_TRAIT(owner, TRAIT_IGNORESLOWDOWN, id)
	ADD_TRAIT(owner, TRAIT_LONGSTRIDER, id)
	ADD_TRAIT(owner, TRAIT_STRONG_GRABBER, id)
	to_chat(owner, span_userdanger("I feel my body tense up immensely in response to this hunger, tendrils of darkness crawling under my skin."))

/datum/status_effect/debuff/deadite_grace/on_remove()
	. = ..()
	var/mob/living/carbon/human/H = owner
	H.status_flags -= GODMODE
	REMOVE_TRAIT(owner, TRAIT_NORUN, id)
	REMOVE_TRAIT(owner, TRAIT_IGNORESLOWDOWN, id)
	REMOVE_TRAIT(owner, TRAIT_LONGSTRIDER, id)
	REMOVE_TRAIT(owner, TRAIT_STRONG_GRABBER, id)
	to_chat(owner, span_userdanger("I feel my body relax a little, and that is the last thing I feel as my Lux wanes... I am fading."))

#undef ZOMBIE_FIRST_BITE_CHANCE
#undef ZOMBIE_BITE_CONVERSION_TIME

