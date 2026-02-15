#define DEAD_TO_ZOMBIE_TIME 7 MINUTES	//Time before death -> raised as zombie (when outside of the city)	
										//(This isn't exact time. Extended 5 -> 7 because only takes 2-3 min in testing at 5.)

/datum/component/rot
	var/amount = 0
	var/last_process = 0
	var/datum/looping_sound/fliesloop/soundloop

/datum/component/rot/Initialize(new_amount)
	..()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

	if(new_amount)
		amount = new_amount

	soundloop = new(parent, FALSE)

	START_PROCESSING(SSroguerot, src)

/datum/component/rot/Destroy()
	if(soundloop)
		soundloop.stop()
	. = ..()

/datum/component/rot/process()

	var/amt2add = 10 // 1 Second. Base increment. 
	var/current_time = world.time
    
	// time elapsed since the last rot/process
	var/elapsed_time = last_process ? (current_time - last_process) : 0
	last_process = current_time

	// Add amount based on the time elapsed. This is used to calculate when to wake/decompose
	amount += (elapsed_time / 10) * amt2add 

	return

/datum/component/rot/corpse/Initialize()
	if(!iscarbon(parent))
		return COMPONENT_INCOMPATIBLE
	. = ..()
/*
	ZOMBIFICATION
*/
/datum/component/rot/corpse/process()
	var/time_elapsed = last_process ? (world.time - last_process)/10 : 1
	..()
	if(has_world_trait(/datum/world_trait/pestra_mercy))
		amount -= 5 * time_elapsed

	var/mob/living/carbon/C = parent

	var/is_zombie
	if(HAS_TRAIT(C, TRAIT_DNR))
		return
	if(C.mind)
		if(C.mind.has_antag_datum(/datum/antagonist/zombie))
			is_zombie = TRUE
	if(!is_zombie)
		if(C.stat != DEAD)
			qdel(src)
			return

	var/area/A = get_area(C)
	if (istype(A, /area/rogue/indoors/town))	//Stops rotting inside town buildings; will stop your zombification such as at church or appothocary.
		return
	if (istype(A, /area/rogue/indoors/deathsedge))	//Stops rotting inside Death's Edge (Death's Door spell area)
		return

	if(!(C.mob_biotypes & (MOB_ORGANIC|MOB_UNDEAD)))
		qdel(src)
		return

	if(amount > DEAD_TO_ZOMBIE_TIME)
		if(is_zombie)
			var/datum/antagonist/zombie/Z = C.mind.has_antag_datum(/datum/antagonist/zombie)
			if(Z && !Z.has_turned && !Z.revived && C.stat == DEAD)
				C.infected = TRUE
				wake_zombie(C, infected_wake = TRUE, converted = FALSE)

	var/findonerotten = FALSE
	var/shouldupdate = FALSE
	var/dustme = FALSE
	for(var/obj/item/bodypart/B in C.bodyparts)
		if(!B.skeletonized && B.is_organic_limb())
			if(!B.rotted)
				if(amount > 20 MINUTES)
					B.rotted = TRUE
					findonerotten = TRUE
					shouldupdate = TRUE
					C.apply_status_effect(/datum/status_effect/debuff/rotted_zombie)	//-8 con to rotting zombie corpse.
			else
				if(amount > 40 MINUTES)
					if(!is_zombie)
						B.skeletonize()
						if(C.dna && C.dna.species)
							C.dna.species.species_traits |= NOBLOOD
						C.apply_status_effect(/datum/status_effect/debuff/rotted_zombie)	//-8 con to rotting zombie corpse - duplicate as a failsafe.
						shouldupdate = TRUE
				else
					findonerotten = TRUE
		if(amount > 35 MINUTES)  // Code to delete a corpse after 35 minutes if it's not a zombie and not skeletonized. Possible failsafe.
			if(!is_zombie)
				if(!C.client)	// We want to dust NPC bodies, not player bodies.
					if(B.skeletonized)
						dustme = TRUE

	if(dustme)
		qdel(src)
		return C.dust(drop_items=TRUE)

	if(findonerotten)
		var/turf/open/T = C.loc
		if(istype(T))
			T.pollute_turf(/datum/pollutant/rot, 5)
			if(soundloop && soundloop.stopped && !is_zombie)
				soundloop.start()
		else
			if(soundloop && !soundloop.stopped)
				soundloop.stop()
	else
		if(soundloop && !soundloop.stopped)
			soundloop.stop()
	if(shouldupdate)
		if(findonerotten)
			if(ishuman(C))
				var/mob/living/carbon/human/H = C
				H.skin_tone = "878f79" //elf ears
			if(soundloop && soundloop.stopped && !is_zombie)
				soundloop.start()
		C.update_body()

	// Sanity check: if we're a human and we've been buried, we kill the sound.
	if(ishuman(C))
		var/mob/living/carbon/human/H = C
		if(H.buried)
			soundloop.stop()

/datum/component/rot/simple/process()
	..()
	var/mob/living/L = parent
	if(L.stat != DEAD)
		qdel(src)
		return
	if(amount > 15 MINUTES)
		if(soundloop && soundloop.stopped)
			soundloop.start()
		var/turf/open/T = get_turf(L)
		if(istype(T))
			T.pollute_turf(/datum/pollutant/rot, 5)
	if(amount > 25 MINUTES)
		qdel(src)
		return L.dust(drop_items=TRUE)

/datum/component/rot/gibs
	amount = MIASMA_GIBS_MOLES

/datum/looping_sound/fliesloop
	mid_sounds = list('sound/misc/fliesloop.ogg')
	mid_length = 60
	volume = 50
	extra_range = 0

#undef DEAD_TO_ZOMBIE_TIME
