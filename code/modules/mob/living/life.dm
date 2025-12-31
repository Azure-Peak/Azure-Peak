/mob/living/proc/Life(seconds, times_fired)
	set waitfor = FALSE
	set invisibility = 0

	if(!client && ai_controller && ai_controller.ai_status == AI_STATUS_OFF)
		return

	SEND_SIGNAL(src, COMSIG_LIVING_LIFE, seconds, times_fired)

	if((movement_type & FLYING) && !(movement_type & FLOATING))	//TODO: Better floating
		float(on = TRUE)

	if (client)
		var/turf/T = get_turf(src)
		if(!T)
			var/msg = "[ADMIN_LOOKUPFLW(src)] was found to have no .loc with an attached client, if the cause is unknown it would be wise to ask how this was accomplished."
			message_admins(msg)
			send2irc_adminless_only("Mob", msg, R_ADMIN)
			log_game("[key_name(src)] was found to have no .loc with an attached client.")

		// This is a temporary error tracker to make sure we've caught everything
		else if (registered_z != T.z)
#ifdef TESTING
			message_admins("[ADMIN_LOOKUPFLW(src)] has somehow ended up in Z-level [T.z] despite being registered in Z-level [registered_z]. If you could ask them how that happened and notify coderbus, it would be appreciated.")
#endif
			log_game("Z-TRACKING: [src] has somehow ended up in Z-level [T.z] despite being registered in Z-level [registered_z].")
			update_z(T.z)
	else if (registered_z)
		log_game("Z-TRACKING: [src] of type [src.type] has a Z-registration despite not having a client.")
		update_z(null)

	if (notransform)
		return
	if(!loc)
		return

	//Breathing, if applicable - CURRENTLY NOT IMPLEMENTED
	//handle_breathing(times_fired)

	if(HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		handle_wounds()
		handle_embedded_objects()
		handle_blood()
		//passively heal even wounds with no passive healing
		heal_wounds(1)

	/// ENDVRE AS HE DOES.
	if(!stat && HAS_TRAIT(src, TRAIT_PSYDONITE) && !HAS_TRAIT(src, TRAIT_PARALYSIS))
		handle_wounds()
		//passively heal wounds, when you're in trouble..
		if(blood_volume > BLOOD_VOLUME_SURVIVE)
			for(var/datum/wound/wound as anything in get_wounds())
				if(wound?.severity <= WOUND_SEVERITY_MODERATE)
					wound.heal_wound(0.4)

	if(!stat && HAS_TRAIT(src, TRAIT_LYCANRESILENCE) && !HAS_TRAIT(src, TRAIT_PARALYSIS))
		if(src.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || src.has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
			return
		handle_wounds()
		if(blood_volume > BLOOD_VOLUME_SURVIVE)
			for(var/datum/wound/wound as anything in get_wounds())
				wound.heal_wound(3)		

	if (QDELETED(src)) // diseases can qdel the mob via transformations
		return

	handle_environment()
	
	//Random events (vomiting etc)
	handle_random_events()

	handle_traits() // eye, ear, brain damages
	handle_status_effects() //all special effects, stun, knockdown, jitteryness, hallucination, sleeping, etc

	update_sneak_invis()

	if(machine)
		machine.check_eye(src)

	check_drowning()

	if(stat != DEAD)
		return 1

/mob/living/proc/check_drowning()
	if(istype(loc, /turf/open/water))
		handle_inwater(loc)

/mob/living/carbon/human/check_drowning()
	if(isdullahan(src))
		var/mob/living/carbon/human = src
		var/datum/species/dullahan/dullahan = human.dna.species
		if(dullahan.headless)
			var/obj/item/bodypart/head/dullahan/drownrelay = dullahan.my_head
			if(!drownrelay)
				return
			if(istype(drownrelay.loc, /turf/open/water))
				handle_inwater(drownrelay.loc, extinguish = FALSE, force_drown = TRUE)
			if(istype(loc, /turf/open/water)) // Extinguish ourselves if our body is in water.	
				extinguish_mob()
			return
	. =..()

/mob/living/proc/DeadLife()
	set invisibility = 0
	if (notransform)
		return
	if(!loc)
		return
	if(HAS_TRAIT(src, TRAIT_SIMPLE_WOUNDS))
		handle_wounds()
		handle_embedded_objects()
		handle_blood()
	update_sneak_invis()
	if(istype(loc, /turf/open/water))
		handle_inwater(loc)

/mob/living/proc/handle_random_events()
	//random painstun
	if(!stat && !HAS_TRAIT(src, TRAIT_NOPAINSTUN))
		if(world.time > mob_timers["painstun"] + 600)
			if(getBruteLoss() + getFireLoss() >= (STAWIL * 10))
				var/probby = 53 - (STAWIL * 2)
				if(!(mobility_flags & MOBILITY_STAND))
					probby = probby - 20
				if(prob(probby))
					mob_timers["painstun"] = world.time
					Immobilize(10)
					emote("painscream")
					visible_message(span_warning("[src] freezes in pain!"),
								span_warning("I'm frozen in pain!"))
					sleep(10)
					Stun(110)
					Knockdown(110)

/mob/living/proc/handle_environment()
	return

/mob/living/proc/handle_wounds()
	for(var/datum/wound/wound as anything in get_wounds())
		if(istype(wound, /datum/wound))
			if (stat != DEAD)
				wound.on_life()
			else
				wound.on_death()


/obj/item/proc/on_embed_life(mob/living/user, obj/item/bodypart/bodypart)
	return

/mob/living/proc/handle_embedded_objects()
	for(var/obj/item/embedded in simple_embedded_objects)
		if(embedded.on_embed_life(src))
			continue

		if(prob(embedded.embedding.embedded_pain_chance))
			if(embedded.is_silver && HAS_TRAIT(src, TRAIT_SILVER_WEAK) && !has_status_effect(STATUS_EFFECT_ANTIMAGIC))
				var/datum/component/silverbless/psyblessed = embedded.GetComponent(/datum/component/silverbless)
				adjust_fire_stacks(1, psyblessed?.is_blessed ? /datum/status_effect/fire_handler/fire_stacks/sunder/blessed : /datum/status_effect/fire_handler/fire_stacks/sunder)
			to_chat(src, span_danger("[embedded] in me hurts!"))

		if(prob(embedded.embedding.embedded_fall_chance))
			simple_remove_embedded_object(embedded)
			to_chat(src,span_danger("[embedded] falls out of me!"))

//this updates all special effects: knockdown, druggy, stuttering, etc..
/mob/living/proc/handle_status_effects()
	if(confused)
		confused = max(confused - 1, 0)
	if(slowdown)
		slowdown = max(slowdown - 1, 0)
	if(slowdown <= 0)
		remove_movespeed_modifier(MOVESPEED_ID_LIVING_SLOWDOWN_STATUS)

/mob/living/proc/handle_traits()
	//Eyes
	if(eye_blind)	//blindness, heals slowly over time
		if(HAS_TRAIT_FROM(src, TRAIT_BLIND, EYES_COVERED)) //covering your eyes heals blurry eyes faster
			adjust_blindness(-3)
		else if(!stat && !(HAS_TRAIT(src, TRAIT_BLIND)))
			adjust_blindness(-1)
	else if(eye_blurry)			//blurry eyes heal slowly
		adjust_blurriness(-1)

/mob/living/proc/update_damage_hud()
	return
