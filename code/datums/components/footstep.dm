///Footstep component. Plays footsteps at parents location when it is appropriate.
/datum/component/footstep
	///How many steps the parent has taken since the last time a footstep was played.
	var/steps = 0
	///volume determines the extra volume of the footstep. This is multiplied by the base volume, should there be one.
	var/volume
	///e_range stands for extra range - aka how far the sound can be heard. This is added to the base value and ignored if there isn't a base value.
	var/e_range
	///footstep_type is a define which determines what kind of sounds should get chosen.
	var/footstep_type
	///This can be a list OR a soundfile OR null. Determines whatever sound gets played.
	var/footstep_sounds
	var/last_sound
	///keen_footstep effects currently marking our position for listeners.
	var/list/active_prints

/datum/component/footstep/Initialize(footstep_type_ = FOOTSTEP_MOB_BAREFOOT, volume_ = 0.5, e_range_ = -1)
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE
	volume = volume_
	e_range = e_range_
	footstep_type = footstep_type_
	switch(footstep_type)
		if(FOOTSTEP_MOB_HUMAN)
			if(!ishuman(parent))
				return COMPONENT_INCOMPATIBLE
			RegisterSignal(parent, list(COMSIG_MOVABLE_MOVED), PROC_REF(play_humanstep))
			return
		if(FOOTSTEP_MOB_CLAW)
			footstep_sounds = GLOB.clawfootstep
		if(FOOTSTEP_MOB_BAREFOOT)
			footstep_sounds = GLOB.barefootstep
		if(FOOTSTEP_MOB_HEAVY)
			footstep_sounds = GLOB.heavyfootstep
		if(FOOTSTEP_MOB_SHOE)
			footstep_sounds = GLOB.footstep
		if(FOOTSTEP_MOB_SLIME)
			footstep_sounds = 'sound/blank.ogg'
	RegisterSignal(parent, list(COMSIG_MOVABLE_MOVED), PROC_REF(play_simplestep)) //Note that this doesn't get called for humans.

/datum/component/footstep/Destroy(force, silent)
	clear_prints()
	return ..()

///Prepares a footstep. Determines if it should get played. Returns the turf it should get played on. Note that it is always a /turf/open
/datum/component/footstep/proc/prepare_step()
	var/turf/open/T = get_turf(parent)
	if(!istype(T))
		return

	var/mob/living/LM = parent
	if(!T.footstep || LM.buckled || LM.lying || !CHECK_MULTIPLE_BITFIELDS(LM.mobility_flags, MOBILITY_STAND | MOBILITY_MOVE) || LM.throwing || LM.movement_type & (VENTCRAWLING | FLYING))
		if (LM.lying && !LM.buckled && !(!T.footstep || LM.movement_type & (VENTCRAWLING | FLYING))) //play crawling sound if we're lying
			playsound(T, 'sound/blank.ogg', 15 * volume)
		return

	if(iscarbon(LM))
		var/mob/living/carbon/C = LM
		if(!C.get_bodypart(BODY_ZONE_L_LEG) && !C.get_bodypart(BODY_ZONE_R_LEG))
			return
		if(C.m_intent == MOVE_INTENT_SNEAK && !T.footstepstealth)
			if(!C.loud_sneaking || C.rogue_sneaking)
				return// stealth
			steps++
			if(steps&2 == 2) // Hrrghn... Colonel, I'm trying to sneak around, but I'm dummy thicc, and the clap of my asscheeks keeps ALERTING THE GUARDS
				playsound(C, pick(list('sound/misc/mat/thicc (1).ogg','sound/misc/mat/thicc (2).ogg','sound/misc/mat/thicc (3).ogg','sound/misc/mat/thicc (4).ogg')), 15 * volume)
			if(steps >= 6)
				steps = 0
			return// uhm... stealth?
	steps++

	if(steps >= 6)
		steps = 0

	if(steps % 2)
		return

	return T

/datum/component/footstep/proc/play_simplestep()
	if(HAS_TRAIT(parent, TRAIT_SILENT_FOOTSTEPS))
		return
	var/turf/open/T = prepare_step()
	if(!T)
		return
	if(isfile(footstep_sounds) || istext(footstep_sounds))
		playsound(T, footstep_sounds, volume)
		return
	var/turf_footstep
	switch(footstep_type)
		if(FOOTSTEP_MOB_CLAW)
			turf_footstep = T.clawfootstep
		if(FOOTSTEP_MOB_BAREFOOT)
			turf_footstep = T.barefootstep
		if(FOOTSTEP_MOB_HEAVY)
			turf_footstep = T.heavyfootstep
		if(FOOTSTEP_MOB_SHOE)
			turf_footstep = T.footstep
	if(!turf_footstep)
		return
	//SANITY CHECK, WILL NOT PLAY A SOUND IF THE LIST IS INVALID
	if(!footstep_sounds[turf_footstep] || (LAZYLEN(footstep_sounds) < 3))
		return
	playsound(T, pick(footstep_sounds[turf_footstep][1]), footstep_sounds[turf_footstep][2], FALSE, footstep_sounds[turf_footstep][3] + e_range)

/datum/component/footstep/proc/play_humanstep()
	var/turf/open/step_location = prepare_step()
	if(!step_location)
		return
	if(HAS_TRAIT(parent, TRAIT_SILENT_FOOTSTEPS))
		return
	var/mob/living/carbon/human/human_parent = parent
	var/feetCover = (human_parent.wear_armor?.body_parts_covered | human_parent.wear_pants?.body_parts_covered) & FEET
	var/used_sound
	var/list/used_footsteps
	var/obj/item/clothing/shoes/humshoes = human_parent.shoes
	var/used_volume = 0
	var/used_extra_range = 0
	var/do_vary = FALSE
	var/feet_covered = ((istype(humshoes) && !humshoes?.is_barefoot) || feetCover)
	// decide between normal or bare step sounds based on shoe and armor coverage
	var/list/used_step_list = feet_covered ? GLOB.footstep : GLOB.barefootstep
	var/turf_used_step = feet_covered ? step_location.footstep : step_location.barefootstep
	var/list/step_data = used_step_list[turf_used_step]
	//SANITY CHECK, WILL NOT PLAY A SOUND IF THE LIST IS INVALID
	if((LAZYLEN(step_data) < 3))
		testing("SOME silly guy GAVE AN INVALID [feet_covered ? "FOOTSTEP" : "BAREFOOTSTEP"] VALUE ([turf_used_step]) TO [step_location.type]!!! FIX THIS SHIT!!!")
		return
	used_footsteps = step_data[1]
	used_volume = step_data[2]
	used_extra_range = step_data[3]
	do_vary = !feet_covered // only barefoot gets the pitch variation
	// this is fine without an explicit copy because it doesn't mutate the existing list
	used_sound = pick(used_footsteps - last_sound) || last_sound
	last_sound = used_sound
	var/list/heard = playsound(step_location, used_sound,
		volume * used_volume,
		do_vary,
		used_extra_range + e_range)
	reveal_footstep(step_location, heard)

/datum/component/footstep/proc/reveal_footstep(turf/T, list/heard)
	clear_prints()
	if(!length(heard))
		return
	var/mob/living/mover = parent
	for(var/mob/living/listener in heard)
		if(listener == mover)
			continue
		if(!listener.client || listener.stat != CONSCIOUS)
			continue
		if(!HAS_TRAIT(listener, TRAIT_KEENEARS) && !vision_obscured(listener))
			continue
		if(!vision_obscured(listener) && listener.can_see_cone(mover))
			continue
		var/obj/effect/temp_visual/keen_footstep/print = new(T, listener, mover.dir)
		LAZYADD(active_prints, print)
		RegisterSignal(print, COMSIG_PARENT_QDELETING, PROC_REF(on_print_deleted))

///A print we were tracking got deleted on its own (e.g. its turf was destroyed); drop our reference.
/datum/component/footstep/proc/on_print_deleted(obj/effect/temp_visual/keen_footstep/print)
	SIGNAL_HANDLER
	LAZYREMOVE(active_prints, print)

///Wipes the footprints marking our previous position.
/datum/component/footstep/proc/clear_prints()
	for(var/obj/effect/temp_visual/keen_footstep/print as anything in active_prints)
		UnregisterSignal(print, COMSIG_PARENT_QDELETING) //Unregister first so qdel doesn't mutate active_prints while we iterate it.
		qdel(print)
	active_prints = null
