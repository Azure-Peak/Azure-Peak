/mob/living/carbon/Life(seconds, times_fired)
	set invisibility = 0

	if(notransform)
		return

	if(damageoverlaytemp)
		damageoverlaytemp = 0
		update_damage_hud()

	//Reagent processing needs to come before breathing, to prevent edge cases.
	handle_organs()

	. = ..()

	if (QDELETED(src))
		return

	if(hud_used?.stressies)
		hud_used.stressies.update_icon()

	handle_wounds()
	handle_embedded_objects()
	handle_blood()
	handle_roguebreath()

	var/bprv = handle_bodyparts()
	if(bprv & BODYPART_LIFE_UPDATE_HEALTH)
		update_stamina() //needs to go before updatehealth to remove stamcrit
		updatehealth()
	if(client)
		update_damage_hud()
	if (times_fired % 3 == 0) // every 3rd tick, fire stress handler. it isn't time-critical, so we don't particularly need it to go EVERY tick
		update_stress()
	handle_nausea()

	handle_sleep()

	if(HAS_TRAIT(src, TRAIT_IN_FRENZY))
		handle_automated_frenzy()

	if(stat != DEAD)
		return 1

/mob/living/carbon/DeadLife()
	set invisibility = 0

	if(notransform)
		return

	. = ..()
	if (QDELETED(src))
		return
	handle_wounds()
	handle_embedded_objects()
	handle_blood()

	check_cremation()

/mob/living/carbon/handle_random_events()//BP/WOUND BASED PAIN
	//Being sundered will shut off no_pain trait, until the sunder flames wear off.
	//Werewolves are exempt.
	if(HAS_TRAIT(src, TRAIT_NOPAIN) && !HAS_TRAIT(src, TRAIT_LYCANRESILENCE) && (!has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || !has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed)))
		return
	if(!stat)
		var/painpercent = get_complex_pain() / pain_threshold
		painpercent = painpercent * 100

		if(world.time > mob_timers["painstun"])
			mob_timers["painstun"] = world.time + 100
			var/probby = 40 - (STAWIL * 2)
			probby = max(probby, 10)
			if(lying || IsKnockdown())
				if(prob(3) && (painpercent >= 80) )
					emote("painmoan")
			else
				if(painpercent >= 100)
					if(prob(25) && (HAS_TRAIT(src, TRAIT_PSYDONIAN_GRIT) || STAWIL >= 15) && (!HAS_TRAIT(src, TRAIT_NOPAINSTUN) && !HAS_TRAIT(src, TRAIT_IRONMAN))) // PSYDONIC WEIGHTED COINFLIP. TWEAK THIS AS THOU WILT. DON'T LET THEM BE BROKEN, PSYDON WILLING. THROW CON-MAXXERS A BONE, TOO.
						Immobilize(15) // EAT A MICROSTUN. YOU'RE AVOIDING A PAINCRIT.
						if(HAS_TRAIT(src, TRAIT_PSYDONIAN_GRIT))
							visible_message(span_info("[src] audibly grits [src.p_their()] teeth, ENDURING through [src.p_their()] pain."), span_info("Through my faith in HIM, I ENDURE."))
						else
							visible_message(span_info("[src] trembles for a moment, but [src.p_they()] remain standing."), span_info("My strong constitution keeps me upright."))
						stuttering += 5
						emote("painmoan")
						return
					if(prob(probby) && !HAS_TRAIT(src, TRAIT_NOPAINSTUN) && !has_status_effect(/datum/status_effect/buff/psyhealing))
						Immobilize(10)
						emote("painscream")
						stuttering += 5
						addtimer(CALLBACK(src, PROC_REF(Stun), 110), 10)
						addtimer(CALLBACK(src, PROC_REF(Knockdown), 110), 10)
						mob_timers["painstun"] = world.time + 160
					if(prob(probby) && HAS_TRAIT(src, TRAIT_NOPAINSTUN) && !HAS_TRAIT(src, TRAIT_LYCANRESILENCE)	&& (has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) || has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed)))
						Immobilize(10)
						emote("superagony")
						to_chat(src, span_userdanger("THE SACRED FLAMES, I FEEL PAIN AGAIN!"))
						stuttering += 5
						cultslurring += 10 //To indicate this isn't a natural kind of agony
						addtimer(CALLBACK(src, PROC_REF(Stun), 110), 10)
						addtimer(CALLBACK(src, PROC_REF(Knockdown), 110), 10)
						mob_timers["painstun"] = world.time + 160
					else
						emote("painmoan")
						stuttering += 5
				else
					if(painpercent >= 80)
						if(probby)
							emote("painmoan")

		if(painpercent >= 100)
			add_stress(/datum/stressevent/painmax)

/mob/living/carbon/proc/handle_roguebreath()
	return

/mob/living/carbon/human/handle_roguebreath()
	..()
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return TRUE
	if(HAS_TRAIT(src, TRAIT_HOLDBREATH))
		adjustOxyLoss(10)
	if(istype(loc, /obj/structure/closet/dirthole))
		adjustOxyLoss(5)
	if(istype(loc, /obj/structure/closet/burial_shroud))
		var/obj/O = loc
		if(istype(O.loc, /obj/structure/closet/dirthole))
			adjustOxyLoss(10)
	if(isopenturf(loc))
		var/turf/open/T = loc
		if(reagents && T.pollution)
			T.pollution.breathe_act(src)
			if(next_smell <= world.time)
				next_smell = world.time + 30 SECONDS
				T.pollution.smell_act(src)

/mob/living/proc/handle_inwater()
	extinguish_mob()

/mob/living/carbon/human/handle_inwater(turf/onturf, extinguish = TRUE, force_drown = FALSE)
	..()

	if(!(mobility_flags & MOBILITY_STAND) || force_drown)
		if (HAS_TRAIT(src, TRAIT_NOBREATH) || HAS_TRAIT(src, TRAIT_WATERBREATHING))
			return TRUE
		if(stat == DEAD && client)
			record_round_statistic(STATS_PEOPLE_DROWNED)
		var/drown_damage = has_world_trait(/datum/world_trait/abyssor_rage) ? 10 : 5
		adjustOxyLoss(drown_damage)
		emote("drown")

	if(istype(onturf, /turf/open/water/sewer) && !HAS_TRAIT(src, TRAIT_HOLDBREATH))
		add_stress(/datum/stressevent/sewertouched)

	if(istype(onturf, /turf/open/water/swamp) && HAS_TRAIT(src, TRAIT_NOBLE_UNLANDED))
		add_stress(/datum/stressevent/sewertouched)

	if(istype(onturf, /turf/open/water/bath) && !wear_armor && !wear_shirt && !wear_pants)
		add_stress(/datum/stressevent/bathwater)

	return TRUE

#define BURN_PAIN_WEIGHT 0.6

/mob/living/carbon/proc/get_complex_pain()
	. = 0
	var/has_adrenaline = HAS_TRAIT(src, TRAIT_ADRENALINE_RUSH)
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		if(limb.status == BODYPART_ROBOTIC || limb.skeletonized && !has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder) && !has_status_effect(/datum/status_effect/fire_handler/fire_stacks/sunder/blessed))
			continue //If we're not sundered, skeletonised limbs do not hurt.
		var/bodypart_pain = ((limb.brute_dam + (limb.burn_dam * BURN_PAIN_WEIGHT)) / limb.max_damage) * limb.max_pain_damage
		for(var/datum/wound/wound as anything in limb.wounds)
			bodypart_pain += wound?.woundpain
		bodypart_pain = min(bodypart_pain, limb.max_pain_damage)
		if(has_adrenaline)
			bodypart_pain *= 0.5
		. += bodypart_pain

#undef BURN_PAIN_WEIGHT

/mob/living/carbon/human/get_complex_pain()
	. = ..()
	if(physiology)
		. *= physiology.pain_mod

///////////////
// BREATHING //
///////////////

/mob/living/carbon/proc/has_smoke_protection()
	if(HAS_TRAIT(src, TRAIT_NOBREATH))
		return TRUE
	return FALSE

/mob/living/carbon/proc/handle_bodyparts()
	var/stam_regen = stam_regen_start_time <= world.time
	if(stam_regen && stam_paralyzed)
		. |= BODYPART_LIFE_UPDATE_HEALTH
	for(var/obj/item/bodypart/BP as anything in bodyparts)
		if(!BP.needs_processing)
			continue
		. |= BP.on_life(stam_regen)

/mob/living/carbon/proc/handle_organs()
	if(stat != DEAD)
		for(var/obj/item/organ/O as anything in internal_organs)
			O.on_life()
	else
		for(var/obj/item/organ/O as anything in internal_organs)
			O.on_death()

/mob/living/carbon/handle_embedded_objects()
	for(var/obj/item/bodypart/bodypart as anything in bodyparts)
		for(var/obj/item/embedded as anything in bodypart.embedded_objects)
			if(embedded.on_embed_life(src, bodypart))
				continue

			if(prob(embedded.embedding.embedded_pain_chance))
				bodypart.receive_damage(embedded.w_class*embedded.embedding.embedded_pain_multiplier)
				to_chat(src, span_danger("[embedded] in my [bodypart.name] hurts!"))

			if(prob(embedded.embedding.embedded_fall_chance))
				bodypart.receive_damage(embedded.w_class*embedded.embedding.embedded_fall_pain_multiplier)
				bodypart.remove_embedded_object(embedded)
				to_chat(src,span_danger("[embedded] falls out of my [bodypart.name]!"))

/*
Alcohol Poisoning Chart
Note that all higher effects of alcohol poisoning will inherit effects for smaller amounts (i.e. light poisoning inherts from slight poisoning)
In addition, severe effects won't always trigger unless the drink is poisonously strong
All effects don't start immediately, but rather get worse over time; the rate is affected by the imbiber's alcohol tolerance

0: Non-alcoholic
1-10: Barely classifiable as alcohol - occasional slurring
11-20: Slight alcohol content - slurring
21-30: Below average - imbiber begins to look slightly drunk
31-40: Just below average - no unique effects
41-50: Average - mild disorientation, imbiber begins to look drunk
51-60: Just above average - disorientation, vomiting, imbiber begins to look heavily drunk
61-70: Above average - small chance of blurry vision, imbiber begins to look smashed
71-80: High alcohol content - blurry vision, imbiber completely shitfaced
81-90: Extremely high alcohol content - light brain damage, passing out
91-100: Dangerously toxic - swift death
*/
#define BALLMER_POINTS 5
GLOBAL_LIST_INIT(ballmer_good_msg, list("Hey guys, what if we rolled out a bluespace wiring system so mice can't destroy the powergrid anymore?",
										"Hear me out here. What if, and this is just a theory, we made R&D controllable from our PDAs?",
										"I'm thinking we should roll out a git repository for our research under the AGPLv3 license so that we can share it among the other stations freely.",
										"I dunno about you guys, but IDs and PDAs being separate is clunky as fuck. Maybe we should merge them into a chip in our arms? That way they can't be stolen easily.",
										"Why the fuck aren't we just making every pair of shoes into galoshes? We have the technology."))
GLOBAL_LIST_INIT(ballmer_windows_me_msg, list("Yo man, what if, we like, uh, put a webserver that's automatically turned on with default admin passwords into every PDA?",
												"So like, you know how we separate our codebase from the master copy that runs on our consumer boxes? What if we merged the two and undid the separation between codebase and server?",
												"Dude, radical idea: H.O.N.K mechs but with no bananium required.",
												"Best idea ever: Disposal pipes instead of hallways.",
												"We should store bank records in a webscale datastore, like /dev/null.",
												"You ever wonder if /dev/null supports sharding?",
												"Do you know who ate all the donuts?",
												"What if we use a language that was written on a napkin and created over 1 weekend for all of our servers?"))

//this updates all special effects: stun, sleeping, knockdown, druggy, stuttering, etc..
/mob/living/carbon/handle_status_effects()
	..()

	var/restingpwr = 1 + 4 * resting

	//Dizziness
	if(dizziness)
		var/client/C = client
		var/pixel_x_diff = 0
		var/pixel_y_diff = 0
		var/temp
		var/saved_dizz = dizziness
		if(C)
			var/oldsrc = src
			var/amplitude = dizziness*(sin(dizziness * world.time) + 1) // This shit is annoying at high strength
			src = null
			spawn(0)
				if(C)
					temp = amplitude * sin(saved_dizz * world.time)
					pixel_x_diff += temp
					C.pixel_x += temp
					temp = amplitude * cos(saved_dizz * world.time)
					pixel_y_diff += temp
					C.pixel_y += temp
					sleep(3)
					if(C)
						temp = amplitude * sin(saved_dizz * world.time)
						pixel_x_diff += temp
						C.pixel_x += temp
						temp = amplitude * cos(saved_dizz * world.time)
						pixel_y_diff += temp
						C.pixel_y += temp
					sleep(3)
					if(C)
						C.pixel_x -= pixel_x_diff
						C.pixel_y -= pixel_y_diff
			src = oldsrc
		dizziness = max(dizziness - restingpwr, 0)

	if(drowsyness)
		drowsyness = max(drowsyness - restingpwr, 0)
		blur_eyes(2)
		if(drowsyness >= 100)
			Sleeping(300)

	//Jitteriness
	if(jitteriness)
		do_jitter_animation(jitteriness)
		jitteriness = max(jitteriness - restingpwr, 0)

	if(stuttering)
		stuttering = max(stuttering-1, 0)

	if(slurring)
		slurring = max(slurring-1,0)

	if(cultslurring)
		cultslurring = max(cultslurring-1, 0)

	if(silent)
		silent = max(silent-1, 0)

	if(druggy)
		adjust_drugginess(-1)

	if(hallucination)
		handle_hallucinations()

	if(drunkenness)
		drunkenness = max(drunkenness - (drunkenness * 0.04) - 0.01, 0)
		if(drunkenness >= 3)
			if(prob(3))
				slurring += 2
			jitteriness = max(jitteriness - 3, 0)
			apply_status_effect(/datum/status_effect/buff/drunk)
			add_stress(/datum/stressevent/drunk)
		else
			remove_stress(/datum/stressevent/drunk)
		if(drunkenness >= 11 && slurring < 5)
			slurring += 1.2

		if(drunkenness >= 41)
			if(prob(25))
				confused += 2
			Dizzy(10)

		if(drunkenness >= 51)
			adjustToxLoss(1)
			if(prob(3))
				confused += 15
				vomit() // vomiting clears toxloss, consider this a blessing
			Dizzy(25)

		if(drunkenness >= 61)
			adjustToxLoss(1)
			if(prob(50))
				blur_eyes(5)

		if(drunkenness >= 71)
			adjustToxLoss(1)
			if(prob(10))
				blur_eyes(5)

		if(drunkenness >= 81)
			adjustToxLoss(3)
			if(prob(5) && !stat)
				to_chat(src, span_warning("Maybe I should lie down for a bit..."))

		if(drunkenness >= 91)
			adjustToxLoss(5)
//			adjustOrganLoss(ORGAN_SLOT_BRAIN, 0.4)
			if(prob(20) && !stat)
				to_chat(src, span_warning("Just a quick nap..."))
				Sleeping(900)

		if(drunkenness >= 101)
			adjustToxLoss(5) //Let's be honest you shouldn't be alive by now

//WE HANDLE SUNDERSTACKS HERE
	if(sunder_stacks)
		sunder_stacks = max(sunder_stacks - 1, 0) //Takes a bit to shrug off

		apply_status_effect(/datum/status_effect/debuff/sunder_stacks) //You survived an EXTREMELY lethal blow, you might want to keep back for now

		if(sunder_stacks >= 21)
			if(cultslurring < 5) //Fucks up our ability to talk, completely until we're below 20 stacks
				cultslurring += 1.2

		if(sunder_stacks >= 31)
			adjustBruteLoss(1)
			if(prob(3)) //3% chance of blood vomiting
				vomit(blood = TRUE, stun = FALSE) // vomiting blood, because you are actually pretty fucked up sire.
				Dizzy(5) //Tiny bit of Dizzy

		if(sunder_stacks >= 41) //At this point you've taken (2) blows (or are a vampire) or more and shouldn't be escaping death this easily.
			adjustBruteLoss(1)
			if(prob(12)) //12% chance to have random movement + stun + dizziness
				confused += 8
				vomit(blood = TRUE, stun = FALSE) // vomiting blood, because you are actually pretty fucked up sire.
				Dizzy(5)

		if(sunder_stacks >= 101) //We are beyond the point of lethal, somehow. This will cripple you severely.
			adjustBruteLoss(1)
			if(prob(50))
				blur_eyes(5)
				Knockdown(5) //can't stand at all hardly, mortality almost forced upon a form that cannot sustain it.
			Dizzy(25)//You are completely fucked up at this point, any more stacks of SUNDER and you're DEAD.


//used in human and monkey handle_environment()
/mob/living/carbon/proc/natural_bodytemperature_stabilization()
	var/body_temperature_difference = BODYTEMP_NORMAL - bodytemperature
	switch(bodytemperature)
		if(-INFINITY to BODYTEMP_COLD_DAMAGE_LIMIT) //Cold damage limit is 50 below the default, the temperature where you start to feel effects.
			return max((body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR), BODYTEMP_AUTORECOVERY_MINIMUM)
		if(BODYTEMP_COLD_DAMAGE_LIMIT to BODYTEMP_NORMAL)
			return max(body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR, min(body_temperature_difference, BODYTEMP_AUTORECOVERY_MINIMUM/4))
		if(BODYTEMP_NORMAL to BODYTEMP_HEAT_DAMAGE_LIMIT) // Heat damage limit is 50 above the default, the temperature where you start to feel effects.
			return min(body_temperature_difference * metabolism_efficiency / BODYTEMP_AUTORECOVERY_DIVISOR, max(body_temperature_difference, -BODYTEMP_AUTORECOVERY_MINIMUM/4))
		if(BODYTEMP_HEAT_DAMAGE_LIMIT to INFINITY)
			return min((body_temperature_difference / BODYTEMP_AUTORECOVERY_DIVISOR), -BODYTEMP_AUTORECOVERY_MINIMUM)	//We're dealing with negative numbers

/////////
//LIVER//
/////////

/mob/living/carbon/proc/undergoing_liver_failure()
	var/obj/item/organ/liver/liver = getorganslot(ORGAN_SLOT_LIVER)
	if(liver && (liver.organ_flags & ORGAN_FAILING))
		return TRUE

/mob/living/carbon/proc/liver_failure()
	reagents.end_metabolization(src, keep_liverless = TRUE) // Stops trait-based effects on reagents, to prevent permanent buffs
	reagents.metabolize(src, can_overdose = FALSE, liverless = TRUE)

	if(HAS_TRAIT(src, TRAIT_STABLELIVER) || HAS_TRAIT(src, TRAIT_NOMETABOLISM))
		return

	adjustToxLoss(4, TRUE,	TRUE)

/////////////
//CREMATION//
/////////////
/mob/living/carbon/proc/check_cremation()
	//Only cremate while actively on fire
	if(!on_fire)
		return

	if(stat != DEAD)
		return

	//Only starts when the chest has taken full damage
	var/obj/item/bodypart/chest = get_bodypart(BODY_ZONE_CHEST)
	if(!(chest.get_damage() >= chest.max_damage))
		return

	//Burn off limbs one by one
	var/obj/item/bodypart/limb
	var/list/limb_list = list(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM, BODY_ZONE_L_LEG, BODY_ZONE_R_LEG)
	var/still_has_limbs = FALSE
	var/should_update_body = FALSE
	for(var/zone in limb_list)
		limb = get_bodypart(zone)
		if(limb && !limb.skeletonized)
			still_has_limbs = TRUE
			if(limb.get_damage() >= limb.max_damage)
				limb.cremation_progress += rand(2,5)
				if(dna && dna.species && !(NOBLOOD in dna.species.species_traits))
					blood_volume = max(blood_volume - 10, 0)
				if(limb.cremation_progress >= 50)
					if(limb.status == BODYPART_ORGANIC) //Non-organic limbs don't burn
						limb.skeletonize()
						should_update_body = TRUE
//						limb.drop_limb()
//						limb.visible_message(span_warning("[src]'s [limb.name] crumbles into ash!"))
//						qdel(limb)
//					else
//						limb.drop_limb()
//						limb.visible_message(span_warning("[src]'s [limb.name] detaches from [p_their()] body!"))
	if(still_has_limbs)
		return

	//Burn the head last
	var/obj/item/bodypart/head = get_bodypart(BODY_ZONE_HEAD)
	if(head && !head.skeletonized)
		if(head.get_damage() >= head.max_damage)
			head.cremation_progress += 999
			if(head.cremation_progress >= 20)
				if(head.status == BODYPART_ORGANIC) //Non-organic limbs don't burn
					head.skeletonize()
					should_update_body = TRUE
//					head.drop_limb()
//					head.visible_message(span_warning("[src]'s head crumbles into ash!"))
//					qdel(head)
//				else
//					head.drop_limb()
//					head.visible_message(span_warning("[src]'s head detaches from [p_their()] body!"))
		return

	//Nothing left: dust the body, drop the items (if they're flammable they'll burn on their own)
	if(chest && !chest.skeletonized)
		if(chest.get_damage() >= chest.max_damage)
			chest.cremation_progress += 999
			if(chest.cremation_progress >= 19)
		//		visible_message(span_warning("[src]'s body crumbles into a pile of ash!"))
		//		dust(TRUE, TRUE)
				chest.skeletonized = TRUE
				if(ishuman(src))
					var/mob/living/carbon/human/H = src
					qdel(H.underwear)
				should_update_body = TRUE
				if(dna && dna.species)
					if(dna && dna.species && !(NOBLOOD in dna.species.species_traits))
						blood_volume = 0
					dna.species.species_traits |= NOBLOOD

	if(should_update_body)
		update_body()

/////////////////////////////////////
//MONKEYS WITH TOO MUCH CHOLOESTROL//
/////////////////////////////////////

/mob/living/carbon/proc/can_heartattack()
	if(!needs_heart())
		return FALSE
	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(!heart || (heart.organ_flags & ORGAN_SYNTHETIC))
		return FALSE
	return TRUE

/mob/living/carbon/proc/needs_heart()
	if(HAS_TRAIT(src, TRAIT_STABLEHEART))
		return FALSE
	if(dna && dna.species && (NOBLOOD in dna.species.species_traits)) //not all carbons have species!
		return FALSE
	return TRUE

/*
 * The mob is having a heart attack
 *
 * NOTE: this is true if the mob has no heart and needs one, which can be suprising,
 * you are meant to use it in combination with can_heartattack for heart attack
 * related situations (i.e not just cardiac arrest)
 */
/mob/living/carbon/proc/undergoing_cardiac_arrest()
	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(istype(heart) && heart.beating)
		return FALSE
	else if(!needs_heart())
		return FALSE
	return TRUE

/mob/living/carbon/proc/set_heartattack(status)
	if(!can_heartattack())
		return FALSE

	var/obj/item/organ/heart/heart = getorganslot(ORGAN_SLOT_HEART)
	if(!istype(heart))
		return

	heart.beating = !status

/// Handles sleep. Mobs with no_sleep trait cannot sleep.
/*
*	The mob tries to go to sleep or IS sleeping
*
*	Accounts for...
*	TRAIT_NOSLEEP
*	CANT_SLEEP_IN
*	Hunger and Hydration.
*/

/mob/living/carbon/proc/handle_sleep()
	if (!client) // not really relevant to NPCs at the moment
		return

	var/datum/charflaw/sleepless/sleepless_flaw = get_flaw()
	if(!istype(sleepless_flaw, /datum/charflaw/sleepless))
		sleepless_flaw = null

	if(HAS_TRAIT(src, TRAIT_NOSLEEP))
		if(!(mobility_flags & MOBILITY_STAND))
			energy_add(5)

	// SLEEP HEALING
	if(IsSleeping())
		dualwield_attack_count = 0

		// These don't heal when sleeping at all
		if(HAS_TRAIT(src, TRAIT_NOREGEN) || HAS_TRAIT(src, TRAIT_IRONMAN))
			return

		var/is_deathless = HAS_TRAIT(src, TRAIT_DEATHLESS)
		var/is_zombie_immune = HAS_TRAIT(src, TRAIT_ZOMBIE_IMMUNE)
		var/doesnt_hunger = HAS_TRAIT(src, TRAIT_NOHUNGER)

		// slow blood regen to prevent a blood loss softlock
		if(is_deathless || is_zombie_immune)
			if(blood_volume < BLOOD_VOLUME_BAD)
				blood_volume += (BLOOD_VOLUME_NORMAL * 0.002)

		// Checked once, before this tick's blood recovery, so the bonus reflects the state we fell asleep in
		var/critically_low_blood = (blood_volume < BLOOD_VOLUME_SURVIVE)

		// Trait based energy bonuses
		var/sleepy_mod = 0.5
		if(HAS_TRAIT(src, TRAIT_BETTER_SLEEP))
			energy_add(sleepy_mod * 4)
		if(HAS_TRAIT(src, TRAIT_MALUMCHOSEN))
			energy_add(sleepy_mod * 2)

		// Sleep quality goes here, we check where tf we are first for comfort
		if(buckled?.sleepy)
			sleepy_mod = buckled.sleepy

		if(HAS_TRAIT(src, TRAIT_REGROW_LIMBS))
			// Regrow missing limbs at the cost of nutrition for oozes
			for(var/zone in list(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG))
				if(get_bodypart(zone) || nutrition <= 250)
					continue
				regenerate_limb(zone)
				nutrition -= 250
		else if(isturf(loc)) //No illegal tech.
			var/obj/structure/bed/rogue/bed = locate() in loc
			if(bed)
				sleepy_mod = bed.sleepy
			else
				// Improvised sleeping spots go here, for the seasoned hobos only
				if(HAS_TRAIT(src, TRAIT_OUTDOORSMAN) && (locate(/obj/structure/flora/newbranch) in loc))
					sleepy_mod = 2 // just equivalent to a bedroll
				if(HAS_TRAIT(src, TRAIT_WATERSLEEP) && istype(loc, /turf/open/water))
					sleepy_mod = 2 // ditto

		// Energy needs food unless we don't hunger
		if(nutrition > 0 || doesnt_hunger)
			energy_add(sleepy_mod * 15)

		// Blood, wounds and toxins need water (unless we don't hunger, or we're deathless / zombie immune).
		if(hydration > 0 || doesnt_hunger || is_deathless || is_zombie_immune)
			if(!bleed_rate)
				blood_volume = min(blood_volume + (4 * sleepy_mod), BLOOD_VOLUME_NORMAL)

			for(var/obj/item/bodypart/affecting as anything in bodyparts)
				// A bodypart can't heal itself once it bleeds >= 1 (5 small cuts at 0.2, or 3 normal cuts at 0.4). To prevent cheese where normal people can just sleep off their bleeds, even though that's practically statistically impossible now due to pain increasing sleep timer
				if(affecting.get_bleed_rate() >= 1 && !(is_deathless || is_zombie_immune)) // deathless/zimmune needs this to prevent softlocks
					continue

				if(affecting.heal_damage(sleepy_mod, sleepy_mod, required_status = BODYPART_ORGANIC))
					update_damage_overlays()

				for(var/datum/wound/wound as anything in affecting.wounds)
					if(!wound.sleep_healing)
						continue
					var/heal_amount = wound.sleep_healing * sleepy_mod
					if(critically_low_blood)
						heal_amount += wound.whp * 0.05 // 5% of the wound's current whp, every tick, but only after you were totalled
					wound.heal_wound(heal_amount)

			adjustToxLoss(-sleepy_mod)

	// FALLING ASLEEP
	else
		// Sleep quality goes for wherever we buckled first, then the surface we're lying on (which overrides it) for convenience
		var/sleepy_mod = 0
		if(buckled?.sleepy)
			sleepy_mod = buckled.sleepy

		if(isturf(loc) && !(mobility_flags & MOBILITY_STAND))
			var/obj/structure/bed/rogue/bed = locate() in loc
			if(bed)
				SEND_SIGNAL(bed, COMSIG_SLEEPING_ON_BED, src)
				SEND_SIGNAL(src, COMSIG_SLEEPING_ON_BED, src) // send this to both the mob and bed, they're used for different things
				sleepy_mod = bed.sleepy
			else
				// Here we assuming bare floor, or an improv spot
				sleepy_mod = 1
				if(HAS_TRAIT(src, TRAIT_OUTDOORSMAN) && (locate(/obj/structure/flora/newbranch) in loc))
					sleepy_mod = 2 // Worse than a bedroll, better than nothing
				if(HAS_TRAIT(src, TRAIT_WATERSLEEP) && istype(loc, /turf/open/water))
					sleepy_mod = 2 // this too, duh

		// gotta commit to trying to sleep, if you ever open your eyes you're back to zero
		if(sleepy_mod <= 0)
			fallingas = FALSE

		// No eyes closed mean we're just resting for now, good for energy regen but doesn't heal
		else if(!eyesclosed)
			is_asleep = FALSE
			fallingas = FALSE
			if(!(HAS_TRAIT(src, TRAIT_IRONMAN) || HAS_TRAIT(src, TRAIT_NOREGEN)))
				energy_add(sleepy_mod * 10)

		// Eyes closed and we try to fall asleep
		else
			var/mob/living/carbon/human/H = ishuman(src) ? src : null

			// Heavy headgear or medium/heavy armor stops us from sleeping.
			var/armor_blocked = FALSE
			if(H && stat == CONSCIOUS)
				if(H.head?.armor?.stab > 70)
					armor_blocked = TRUE
				if(H.wear_armor && (H.wear_armor.armor_class in list(ARMOR_CLASS_HEAVY, ARMOR_CLASS_MEDIUM)))
					armor_blocked = TRUE

			// Things that stop us from sleeping (we warn once)
			if(HAS_TRAIT(src, TRAIT_NOSLEEP) && !sleepless_flaw)
				if(!fallingas)
					to_chat(src, span_warning("I am completely unable to sleep. I should just get up."))
				fallingas = TRUE
				return

			else if(armor_blocked)
				if(!fallingas)
					to_chat(src, span_warning("I can't sleep like this. My armor is burdening me."))
					fallingas = TRUE

			// Sleepless can't sleep unless drugged up
			else if(sleepless_flaw && !sleepless_flaw.drugged_up)
				if(!fallingas)
					to_chat(src, span_warning("I am completely unable to sleep without the help of drugs..."))
				fallingas = TRUE

			// Nothing in the way means we make progress towards the eeper
			else
				var/sleep_threshold = 30
				var/message = "I'll fall asleep soon..."
				if(sleepy_mod <= 1)
					sleep_threshold = 45
					message = "I'll fall asleep soon, but I am quite uncomfortable..."
				if(sleepless_flaw) // drugged up, but still hard
					sleep_threshold = 45
					message = "I'll fall asleep soon, but it's still quite difficult to..."
				// Pain keeps us awake, it takes 2x longer to fall asleep now
				if(H && !HAS_TRAIT(H, TRAIT_NOPAIN) && !HAS_TRAIT(H, TRAIT_NOPAINSTUN) && H.get_complex_pain() > (H.pain_threshold/2))
					sleep_threshold *= 2
					message = "I am struggling to fall asleep, this pain makes it hard to rest..."
					if(!fallingas)
						H.emote("whimper")

				if(!fallingas)
					to_chat(src, span_warning(message))

				var/previous_progress = fallingas
				fallingas += sleepy_mod
				if(HAS_TRAIT(src, TRAIT_FASTSLEEP)) // 2x sleep rate here, technically
					fallingas += sleepy_mod

				// Halfway there we yawn for sovl and also an indicator that we're actually very close to clonking out
				var/halfway = sleep_threshold / 2
				if(previous_progress < halfway && fallingas >= halfway && fallingas < sleep_threshold)
					emote("yawn")

				// The eeper is finally eeping...
				if(fallingas >= sleep_threshold)
					if(!is_asleep) // please don't spam chat again ser
						to_chat(src, span_blue("I've fallen asleep."))
						is_asleep = TRUE

					// Nobles need a good bed and a proper room, or they will bitch
					if((sleepy_mod < 3 || !istype(get_area(src), /area/rogue/indoors)) && (HAS_TRAIT(src, TRAIT_NOBLE_UNLANDED) || HAS_TRAIT(src, TRAIT_NOBLE)))
						add_stress(/datum/stressevent/unlanded_noble_poor_sleep)
					else if(sleepy_mod >= 3 && has_stress_event(/datum/stressevent/unlanded_noble_poor_sleep))
						remove_stress(/datum/stressevent/unlanded_noble_poor_sleep) // A good night's sleep in cozy conditions fixes it, ser!

					// those who have gazed upon zuranus may have... odd dreams.
					if(has_status_effect(/datum/status_effect/zuranus))
						var/list/dreams
						var/terrible_dreams = TRUE
						if(istype(mouth, /obj/item/roguecoin/aalloy)) // Psila will show you things
							terrible_dreams = FALSE // this sucks so much. free forgive me. please. its for sovl.
							dreams = list(span_gamedeadsay("My deft hands rattle along a table, odd machinery laid around me. I fetch my scalpel and begin shoving a rat into a box..."),
								span_gamedeadsay("I stand over sketches of a chair, swiftly inspeckting vial after vial of a queer green fluid. It's still not ready. Not just yet."),
								span_gamedeadsay("I speak, but I cannot comprehend my own words. Within a near pitch-black room, a corpse animates... I smile."))
						else
							dreams = list(span_cultsmall("It's as if all my other memories have been taken. It feels like hours, daes, only blood, only war. No friends. No family. Just war."),
								span_cultsmall("Every single one of my failures becomes clear to me. I am staring into a river flowing red, and within it is the reflection of everyone I've lost."),
								span_cultsmall("There is a dark star in the sky. The grassy field turns black. I begin coughing-- I clutch at my chest..."))
						to_chat(src, pick(dreams))
						remove_status_effect(/datum/status_effect/zuranus)
						if(terrible_dreams)
							add_stress(/datum/stressevent/terrible_dreams)

					var/dream_prob = 2
					if(sleepless_flaw) // If you're sleepless, you have a higher chance of going to a nightmare. Every time you sleep, the chance gets higher for the rest of the round.
						teleport_to_dream(src, 10000, sleepless_flaw.dream_prob, FALSE)
						sleepless_flaw.dream_prob += 500
						sleepless_flaw.drugged_up = FALSE
						Sleeping(250)
					else
						teleport_to_dream(src, 10000, dream_prob)
						Sleeping(300)
					SEND_SIGNAL(src, COMSIG_MOB_SLEEP)

	// Leaning against a wall: slowly regain stamina
	if(mobility_flags & MOBILITY_STAND && wallpressed && !IsSleeping() && !buckled && !lying && !climbing)
		energy_add(5)

#undef BALLMER_POINTS
