#define ZOMBIE_REANIMATION_CHANCE 25

/datum/component/deadite_npc_reanimation
	var/reanimation_timer
	var/undead_to_spawn

/datum/component/deadite_npc_reanimation/Initialize(mapload)
	if(!istype(parent, /mob/living/carbon/human))
		return COMPONENT_INCOMPATIBLE

	var/mob/living/carbon/human/zombie = parent
	if(zombie.stat != DEAD || HAS_TRAIT(zombie, TRAIT_DNR) || HAS_TRAIT(zombie, TRAIT_DEADITE) || zombie.mind) //we don't want to reanimate deadites out of players or deadites or DNRs
		// Not an error, we don't want this logged.
		return COMPONENT_INCOMPATIBLE_SILENT

	//KEEP IN MIND. IF YOU EDIT THIS TIMER TO BE LONGER THAN THE ROT COMPONENT, YOU WILL BREAK THIS.
	reanimation_timer = addtimer(CALLBACK(src, PROC_REF(reanimate)), DEAD_TO_ZOMBIE_TIME, TIMER_STOPPABLE)

/datum/component/deadite_npc_reanimation/Destroy()
	if(reanimation_timer)
		deltimer(reanimation_timer)
	return ..()

/datum/component/deadite_npc_reanimation/proc/reanimate()
	var/mob/living/carbon/human/zombie = parent
	if(QDELETED(zombie) || QDELETED(zombie) || zombie.stat != DEAD)
		UnregisterFromParent()
		qdel(src)
		return
	var/obj/item/bodypart/head = zombie.get_bodypart(BODY_ZONE_HEAD)
	if(!head || HAS_TRAIT(zombie, TRAIT_DNR) || HAS_TRAIT(zombie, TRAIT_DEADITE))
		UnregisterFromParent()
		return
	if(istype(zombie.loc, /obj/structure/closet/dirthole) || istype(zombie.loc, /obj/structure/closet/crate/coffin))
		UnregisterFromParent()
		return

	addtimer(CALLBACK(zombie, TYPE_PROC_REF(/mob/living/carbon/human, make_deadite)), 0.1 SECONDS)

	zombie.blood_volume = BLOOD_VOLUME_NORMAL
	zombie.setOxyLoss(0, updating_health = FALSE, forced = TRUE)
	zombie.setToxLoss(0, updating_health = FALSE, forced = TRUE)

	zombie.adjustBruteLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
	zombie.adjustFireLoss(-INFINITY, updating_health = FALSE, forced = TRUE)
	zombie.heal_wounds(INFINITY)
	zombie.stat = UNCONSCIOUS
	zombie.updatehealth()
	zombie.update_mobility()
	zombie.handle_blood()
	zombie.refresh_blood_debuffs()

	var/static/list/removed_slots = list(
		SLOT_MOUTH,
	)
	for(var/slot in removed_slots)
		zombie.dropItemToGround(zombie.get_item_by_slot(slot), TRUE)
	//spit out any cloth, don't bother trying this dumbass

	//now we're good to do the funny brains thing

	record_round_statistic(STATS_DEADITES_WOKEN_UP) //Turning into a deadite in-general raises this now. ZIZO. ZIZO. ZIZO.

	//small cutscene now we are a zombie, phew! lets make it a little dramatic. This can probably be done in a far better way but whatever.
	sleep(0.1) //Quickly make sure we already cleared our stuns and stuff before applying more, we want to be lightning quick.
	zombie.Knockdown(33)
	zombie.Immobilize(33) //Don't want to move during this
	zombie.Stun(33)
	zombie.Jitter(15) //Convulse a bit.
	zombie.emote("idle") // First audio warning to nearby players on top of the above message
	zombie.drop_all_held_items()
	zombie.Unconscious(15) //Brief Knockout
	zombie.flash_fullscreen("redflash3")
	zombie.visible_message(span_warning("[zombie] convulses on the floor momentarily, skin rotting away unnaturally fast..."))
	sleep(2 SECONDS) //Second message, another small gap to notice something is very fucking wrong if the previous que wasn't enough.
	zombie.visible_message(span_warning("[zombie]'s lyfeless eyes begin to light up anew with an eerie glow."))
	zombie.vomit(1, blood = TRUE, stun = FALSE)
	playsound(get_turf(zombie), 'sound/magic/woundheal_crunch.ogg', 80, FALSE, -1) //Horrible noises
	sleep(2 SECONDS) //now get them up to go fight and die
	if(zombie.resting)
		zombie.set_resting(FALSE, FALSE) //GET UP, KILL, CONSUME.
	zombie.visible_message(span_danger("[zombie] [pick("stands back up!","shambles upright!","lumbers to [zombie.p_their()] feet!","rises from [zombie.p_their()] shallow grave!","snaps to [zombie.p_their()] feet!","reanimates onto [zombie.p_their()] feet!")]")) //On par with deadite animals reanimating.
	zombie.emote("rage") // This is where the fun begins
	playsound(get_turf(zombie), 'sound/magic/woundheal_crunch.ogg', 80, FALSE, -1) //More horrible noises
	zombie.set_blurriness(0) //Unblind us so we aren't blurred forever
	if(!zombie.cmode)	//Turns on combat mode if its not on, so you're immedately ready to do your thing
		zombie.toggle_cmode()

	UnregisterFromParent()

/datum/component/deadite_npc_reanimation/proc/get_reanimation_chance()
	if(has_world_trait(/datum/world_trait/zizo_defilement))
		return 100
	return ZOMBIE_REANIMATION_CHANCE

#undef ZOMBIE_REANIMATION_CHANCE
