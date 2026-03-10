#define FILTER_UNDERWATER_BLUR "uw_blur"
#define FILTER_UNDERWATER_WAVE "uw_wave"

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
	handle_swimming()
	
	
	var/bprv = handle_bodyparts()
	if(bprv & BODYPART_LIFE_UPDATE_HEALTH)
		update_stamina() //needs to go before updatehealth to remove stamcrit
		updatehealth()
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
	if(HAS_TRAIT(src, TRAIT_NOPAIN))
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
					if(prob(25) && (HAS_TRAIT(src, TRAIT_PSYDONIAN_GRIT) || STAWIL >= 15) && !HAS_TRAIT(src, TRAIT_NOPAINSTUN)) // PSYDONIC WEIGHTED COINFLIP. TWEAK THIS AS THOU WILT. DON'T LET THEM BE BROKEN, PSYDON WILLING. THROW CON-MAXXERS A BONE, TOO.
						Immobilize(15) // EAT A MICROSTUN. YOU'RE AVOIDING A PAINCRIT.
						if(HAS_TRAIT(src, TRAIT_PSYDONIAN_GRIT))
							visible_message(span_info("[src] audibly grits their teeth. ENDURING through their pain."), span_info("Through my faith in HIM, I ENDURE."))
						else
							visible_message(span_info("[src] trembled for a moment, but they remain stood."), span_info("My strong constitution keeps me upright."))
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
		
		var/breath_drain = HAS_TRAIT(src, TRAIT_HOLDBREATH) ? 1 : 2
		breath_remaining = max(0, breath_remaining - breath_drain)

	
	if(istype(onturf, /turf/open/water/sewer) && !HAS_TRAIT(src, TRAIT_HOLDBREATH))
		add_stress(/datum/stressevent/sewertouched)
	
	if(istype(onturf, /turf/open/water/bath) && !wear_armor && !wear_shirt && !wear_pants)
		add_stress(/datum/stressevent/bathwater)

	return TRUE




/mob/living/carbon/proc/get_complex_pain()
	. = 0
	var/has_adrenaline = HAS_TRAIT(src, TRAIT_ADRENALINE_RUSH)
	for(var/obj/item/bodypart/limb as anything in bodyparts)
		if(limb.status == BODYPART_ROBOTIC || limb.skeletonized)
			continue
		var/bodypart_pain = ((limb.brute_dam + limb.burn_dam) / limb.max_damage) * limb.max_pain_damage
		for(var/datum/wound/wound as anything in limb.wounds)
			bodypart_pain += wound?.woundpain
		bodypart_pain = min(bodypart_pain, limb.max_pain_damage)
		if(has_adrenaline)
			bodypart_pain *= 0.5
		. += bodypart_pain

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
1-10: Barely classifiable as alcohol - occassional slurring
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
		if(drunkenness >= 8.5) // Roughly 2 cups
			sate_addiction(/datum/charflaw/addiction/alcoholic)
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

	adjustToxLoss(4, TRUE,  TRUE)

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
		if(mind?.has_antag_datum(/datum/antagonist/vampire))
			if(!(mobility_flags & MOBILITY_STAND))
				energy_add(10)
			energy_add(4)
	//Healing while sleeping in a bed
	if(IsSleeping())
		var/sleepy_mod = 0.5
		var/doesnt_hunger = HAS_TRAIT(src, TRAIT_NOHUNGER)
		if(HAS_TRAIT(src, TRAIT_BETTER_SLEEP))
			energy_add(sleepy_mod * 4)
		if(buckled?.sleepy)
			sleepy_mod = buckled.sleepy
		else if(isturf(loc)) //No illegal tech.
			var/obj/structure/bed/rogue/bed = locate() in loc
			if(bed)
				sleepy_mod = bed.sleepy
			else
				if(HAS_TRAIT(src, TRAIT_OUTDOORSMAN))
					var/obj/structure/flora/newbranch/branch = locate() in loc
					if(branch)
						sleepy_mod = 2 // just equivalent to a bedroll
		if(nutrition > 0 || doesnt_hunger)
			energy_add(sleepy_mod * 15)
		if(hydration > 0 || doesnt_hunger)
			if(!bleed_rate)
				blood_volume = min(blood_volume + (4 * sleepy_mod), BLOOD_VOLUME_NORMAL)
			for(var/obj/item/bodypart/affecting as anything in bodyparts)
				//for context, it takes 5 small cuts (0.2 x 5) or 3 normal cuts (0.4 x 3) for a bodypart to not be able to heal itself
				if(affecting.get_bleed_rate() >= 1)
					continue
				if(affecting.heal_damage(sleepy_mod, sleepy_mod, required_status = BODYPART_ORGANIC))
					src.update_damage_overlays()
				for(var/datum/wound/wound as anything in affecting.wounds)
					if(!wound.sleep_healing)
						continue
					wound.heal_wound(wound.sleep_healing * sleepy_mod)
			adjustToxLoss(-sleepy_mod)
	else
		var/sleepy_mod = 0
		var/sleep_threshold = 30
		var/message = "I'll fall asleep soon..."
		var/dream_prob = 2
		if(buckled?.sleepy)
			sleepy_mod = buckled.sleepy
		if(isturf(loc) && !(mobility_flags & MOBILITY_STAND))
			var/obj/structure/bed/rogue/bed = locate() in loc
			if(bed)
				sleepy_mod = bed.sleepy
			else
				sleepy_mod = 1
				if(HAS_TRAIT(src, TRAIT_OUTDOORSMAN))
					var/obj/structure/flora/newbranch/branch = locate() in loc
					if(branch)
						sleepy_mod = 2 //Worse than a bedroll, better than nothing.
		if(sleepy_mod > 0)
			if(eyesclosed)
				if(HAS_TRAIT(src, TRAIT_NOSLEEP) && !sleepless_flaw)
					message = "I am completely unable to sleep. I should just get up."
					if(!fallingas)
						to_chat(src, span_warning(message))
					fallingas = TRUE
					return
				var/armor_blocked = FALSE
				if(ishuman(src) && stat == CONSCIOUS)
					var/mob/living/carbon/human/H = src
					if(H.head && H.head.armor?.stab > 70)
						armor_blocked = TRUE
					if(H.wear_armor && (H.wear_armor.armor_class in list(ARMOR_CLASS_HEAVY, ARMOR_CLASS_MEDIUM)))
						armor_blocked = TRUE
					if(armor_blocked && !fallingas)
						to_chat(src, span_warning("I can't sleep like this. My armor is burdening me."))
						fallingas = TRUE
				if(!armor_blocked)
					if (sleepy_mod > 1)
						sleep_threshold = 30
					else
						sleep_threshold = 45
						message = "I'll fall asleep soon, although a proper bed would be more comfortable..."
					if(sleepless_flaw)
						if(!sleepless_flaw.drugged_up)
							message = "I am unable to sleep. I should just get up."
							if(!fallingas)
								to_chat(src, span_warning(message))
							fallingas = TRUE
						else
							sleep_threshold = 45
							message = "I'll fall asleep soon, although it's still very hard for me to..."
					if(!fallingas)
						to_chat(src, span_warning(message))
					fallingas += sleepy_mod
					if(HAS_TRAIT(src, TRAIT_FASTSLEEP))
						fallingas += sleepy_mod
					if(fallingas >= sleep_threshold)
						if(!is_asleep) //to not spam chat
							to_chat(src, span_blue("I've fallen asleep."))
							is_asleep = TRUE
						// those who have gazed upon zuranus may have... odd dreams.
						if(has_status_effect(/datum/status_effect/zuranus))
							var/zizo_dream = has_status_effect(/datum/status_effect/zuranus) // this is stupid im sorry
							var/list/evil_dreams = list(
								span_cultsmall("It's as if all my other memories have been taken. It feels like hours, daes, only blood, only war. No friends. No family. Just war."),
								span_cultsmall("Every single one of my failures becomes clear to me. I am staring into a river flowing red, and within it is the reflection of everyone I've lost."),
								span_cultsmall("There is a dark star in the sky. The grassy field turns black. I begin coughing-- I clutch at my chest...")
							)
							var/terrible_dreams = TRUE
							if(istype(src.mouth, /obj/item/roguecoin/aalloy)) // psila will Show You Things. i talked 2 ambrose about this like 2 months ago.
								evil_dreams = list(
									span_gamedeadsay("My deft hands rattle along a table, odd machinery laid around me. I fetch my scalpel and begin shoving a rat into a box..."),
									span_gamedeadsay("I stand over sketches of a chair, swiftly inspeckting vial after vial of a queer green fluid. It's still not ready. Not just yet."),
									span_gamedeadsay("I speak, but I cannot comprehend my own words. Within a near pitch-black room, a corpse animates... I smile.")
								)
								terrible_dreams = FALSE // this sucks so much. free forgive me. please. its for sovl.
							var/picked_dream = pick(evil_dreams)
							to_chat(src, picked_dream)
							src.remove_status_effect(zizo_dream)
							if(terrible_dreams)
								src.add_stress(/datum/stressevent/terrible_dreams)
						if(sleepless_flaw) // If you're sleepless, you have a higher chance of going to a nightmare. Every time you sleep, the chance gets higher for the rest of the round.
							teleport_to_dream(src, 10000, sleepless_flaw.dream_prob, FALSE)
							sleepless_flaw.dream_prob += 500
							sleepless_flaw.drugged_up = FALSE
							Sleeping(250)
						else
							teleport_to_dream(src, 10000, dream_prob)
							Sleeping(300)

			else
				is_asleep = FALSE
				fallingas = FALSE
				energy_add(sleepy_mod * 10)
		else if(fallingas)
			fallingas = FALSE

	// Leaning against a wall: slowly regain stamina
	if(mobility_flags & MOBILITY_STAND && wallpressed && !IsSleeping() && !buckled && !lying && !climbing)
		energy_add(5)

/mob/living/proc/start_swimming()
	if(is_swimming) return
	is_swimming = TRUE
	

/mob/living/proc/stop_swimming()
	if(!is_swimming) return
	is_swimming = FALSE
	

/mob/living/proc/start_submersion()
	if(is_underwater) return
	is_underwater = TRUE
	add_client_colour(/datum/client_colour/underwater)
	apply_underwater_filters()
	
	remove_filter("swimming_cutter")
	update_icon()
	
	animate(src, pixel_x = pixel_x + 2, time = 20, loop = -1, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
	animate(pixel_x = pixel_x - 2, time = 20, easing = SINE_EASING)

/mob/living/proc/stop_submersion()
	if(!is_underwater) return
	is_underwater = FALSE
	remove_client_colour(/datum/client_colour/underwater)
	remove_underwater_filters()
	animate(src) 
	pixel_x = get_standard_pixel_x_offset()
	update_icon()

/mob/living/proc/apply_underwater_filters()
	if(!client) return
	if(swimming_filter_client == client) return

	var/list/planes = list(
		OPENSPACE_PLANE, 
		OPENSPACE_BACKDROP_PLANE, 
		FLOOR_PLANE, 
		WALL_PLANE, 
		GAME_PLANE, 
		GAME_PLANE_FOV_HIDDEN
	)
	for(var/atom/movable/screen/plane_master/PM in client.screen)
		if(PM.plane in planes)
			PM.add_filter(FILTER_UNDERWATER_BLUR, 10, list("type" = "blur", "size" = 0.8))
			PM.add_filter(FILTER_UNDERWATER_WAVE, 11, list("type" = "wave", "x" = 1, "y" = 1, "size" = 1))
			var/F = PM.get_filter(FILTER_UNDERWATER_WAVE)
			if(F) animate(F, offset = 10, time = 40, loop = -1)
			
	swimming_filter_client = client 

/mob/living/proc/remove_underwater_filters()
	if(!client) return
	for(var/atom/movable/screen/plane_master/PM in client.screen)
		PM.remove_filter(FILTER_UNDERWATER_BLUR)
		PM.remove_filter(FILTER_UNDERWATER_WAVE)
		
	swimming_filter_client = null

/mob/living/proc/handle_swimming()
	var/turf/T = get_turf(src)
	var/area/A = get_area(src)
	

	var/is_on_water = istype(T, /turf/open/water)

	var/is_on_new_water = istype(T, /turf/open/water/transparent)
	
	var/is_true_swimming = is_swimming || is_underwater || istype(A, /area/underwater) || is_on_new_water
	var/is_area_underwater = istype(A, /area/underwater)
	var/sw_skill = get_skill_level(/datum/skill/misc/swimming)
	var/new_max_breath = (STACON * 5) + (sw_skill * 5)

	if(new_max_breath != max_breath)
		if(max_breath > 10)
			var/ratio = breath_remaining / max_breath
			max_breath = new_max_breath
			breath_remaining = max_breath * ratio
		else
			max_breath = new_max_breath
			breath_remaining = max_breath
	
	if(!is_on_water && !is_area_underwater)
		
		if(breath_remaining < max_breath)
			breath_remaining = min(breath_remaining + (max_breath / 5), max_breath)

		if(is_swimming || is_underwater || get_filter("swimming_cutter") || swimming_filter_client)
			is_swimming = FALSE
			is_underwater = FALSE
			
			remove_filter("swimming_cutter")
			update_icon() 
			

			if(swimming_filter_client)
				remove_underwater_filters()
		
		if(ishuman(src))
			var/mob/living/carbon/human/H = src
			H.update_breath_hud()
			
		return

	if(!is_on_water && !is_true_swimming && breath_remaining >= max_breath)
		if(get_filter("swimming_cutter"))
			remove_filter("swimming_cutter")
			update_icon()
		update_breath_hud()
		return

	if(is_true_swimming && !is_underwater)
		if(stat == UNCONSCIOUS || IsImmobilized() || IsKnockdown())
			var/turf/below = GET_TURF_BELOW(T)
			if(below && istype(below, /turf/open/water/transparent))
				forceMove(below)
				set_resting(TRUE)
				return

	var/is_choking = FALSE
	if(is_underwater && !can_breathe_underwater())
		is_choking = TRUE
	else if(resting && is_on_water)
		is_choking = TRUE
		handle_inwater(T) 
	
	if(HAS_TRAIT(src, TRAIT_NOBREATH) || HAS_TRAIT(src, TRAIT_WATERBREATHING))
		breath_remaining = max_breath
		is_choking = FALSE

	if(is_choking)
		last_breath_spent = world.time
		var/breath_drain = (m_intent == MOVE_INTENT_RUN) ? 1.2 : 0.8
		breath_remaining = max(0, breath_remaining - (breath_drain / (1 + sw_skill * 0.1)))
		
		if(breath_remaining <= 0)
			var/oxy_damage = (stat == UNCONSCIOUS) ? 3.5 : 5 
			adjustOxyLoss(oxy_damage)
			if(prob(20) && stat != DEAD)
				playsound(src, (stat < UNCONSCIOUS ? 'sound/vo/throat.ogg' : 'sound/effects/bubbles.ogg'), 60, FALSE)
	else
		if(breath_remaining < max_breath)
			var/regen_speed = max_breath / 3.5 
			breath_remaining = min(breath_remaining + regen_speed, max_breath)

	if(!resting && stat == CONSCIOUS && (is_on_new_water || is_true_swimming))
		var/drain = 0
		if(is_true_swimming)
			switch(sw_skill)
				if(SKILL_LEVEL_NONE)       drain = 6.0 
				if(SKILL_LEVEL_NOVICE)     drain = 4.5
				if(SKILL_LEVEL_APPRENTICE) drain = 3.0
				if(SKILL_LEVEL_JOURNEYMAN) drain = 1.5
				if(SKILL_LEVEL_EXPERT)     drain = 1.0
				if(SKILL_LEVEL_MASTER)     drain = 0.5
				if(SKILL_LEVEL_LEGENDARY)  drain = 0.2
			drain *= 1.5 
		else
			drain = 1.2 

		if(m_intent == MOVE_INTENT_RUN) drain *= 1.4
		if(!client) drain *= 1.2
		stamina_add(drain, force_emote = FALSE)
		
	if(is_underwater && !resting)
		if(stamina >= max_stamina || IsKnockdown())
			set_resting(TRUE)

	update_breath_hud()

	
	if(is_true_swimming && !is_underwater && is_on_new_water)
		if(!get_filter("swimming_cutter"))
			add_filter("swimming_cutter", 1, alpha_mask_filter(y=-6, icon=icon('icons/effects/icon_cutter.dmi', "icon_cutter"), flags=MASK_INVERSE))
	else
		if(get_filter("swimming_cutter"))
			remove_filter("swimming_cutter")
			update_icon()

	if(stat != DEAD && is_underwater && client)
		var/filter_ok = FALSE
		if(!filter_ok) apply_underwater_filters()
	
	if(is_true_swimming && !is_underwater && is_on_new_water)
		if(!get_filter("swimming_cutter"))
			add_filter("swimming_cutter", 1, alpha_mask_filter(y=-6, icon=icon('icons/effects/icon_cutter.dmi', "icon_cutter"), flags=MASK_INVERSE))
	else
		if(get_filter("swimming_cutter"))
			remove_filter("swimming_cutter")
			update_icon()

	
	if(is_underwater && client)
		
		if(swimming_filter_client != client) 
			apply_underwater_filters()
	else if(!is_underwater && swimming_filter_client)
		remove_underwater_filters()

	
	if(stat >= UNCONSCIOUS || IsKnockdown())
		drowning_drowniness++
		if(drowning_drowniness >= 3) adjustOxyLoss(10)
	else
		drowning_drowniness = max(0, drowning_drowniness - 1)

/mob/living/proc/update_breath_hud()
	if(!client || !hud_used || !hud_used.breath_bar) 
		return

	var/should_show = FALSE
	if(!HAS_TRAIT(src, TRAIT_NOBREATH) && !HAS_TRAIT(src, TRAIT_WATERBREATHING))
		if(is_underwater || is_swimming || breath_remaining < max_breath)
			should_show = TRUE

	var/target_alpha = should_show ? 255 : 0
	
	if(hud_used.breath_bar.alpha != target_alpha)
		animate(hud_used.breath_bar, alpha = target_alpha, time = 10)

	if(target_alpha == 0) return
	
	var/ratio = breath_remaining / max_breath
	hud_used.breath_bar.set_value(ratio)

/mob/living/proc/can_breathe_underwater()
	if(HAS_TRAIT(src, TRAIT_WATERBREATHING) || HAS_TRAIT(src, TRAIT_NOBREATH))
		return TRUE
		
	return FALSE

/mob/living/proc/calculate_breath_values()
	var/sw_skill = get_skill_level(/datum/skill/misc/swimming)
	var/new_max = (STACON * 1.5) + (sw_skill * 10)
	
	if(new_max != max_breath)
		if(max_breath > 10)
			var/ratio = breath_remaining / max_breath
			max_breath = new_max
			breath_remaining = max_breath * ratio
		else
			max_breath = new_max
			breath_remaining = max_breath

#undef BALLMER_POINTS
#undef FILTER_UNDERWATER_BLUR
#undef FILTER_UNDERWATER_WAVE
