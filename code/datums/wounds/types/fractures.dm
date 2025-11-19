/datum/wound/fracture
	name = "fracture"
	check_name = span_bone("<B>FRACTURE</B>")
	severity = WOUND_SEVERITY_SEVERE
	crit_message = list(
		"The bone shatters!",
		"The bone is broken!",
		"The %BODYPART is mauled!",
		"The bone snaps through the skin!",
	)
	sound_effect = "wetbreak"
	whp = 40
	woundpain = 100
	mob_overlay = "frac"
	can_sew = FALSE
	can_cauterize = FALSE
	disabling = TRUE
	critical = TRUE
	sleep_healing = 0 // no sleep healing that is silly

	werewolf_infection_probability = 0
	/// Whether or not we can be surgically set
	var/can_set = TRUE
	/// Emote we use when applied
	var/gain_emote = "paincrit"

	// Limbs bleed worse, but bleed for far shorter periods than slashes etc.
	bleed_rate = 15				// Artery is 20, but doesn't stop.
	clotting_threshold = 0.25	// Grusome slash is 0.4
	clotting_rate = 0.60		// Normally it's only 0.02, this is huge compared to that.
	bypass_bloody_wound_check = TRUE	//We bypass this proc-checkfor fractures.

/datum/wound/fracture/get_visible_name(mob/user)
	. = ..()
	if(passive_healing)
		. += " <span class='green'>(set)</span>"

/datum/wound/fracture/can_stack_with(datum/wound/other)
	if(istype(other, /datum/wound/fracture) && (type == other.type))
		return FALSE
	return TRUE

/datum/wound/fracture/on_bodypart_gain(obj/item/bodypart/affected)
	. = ..()
	affected.temporary_crit_paralysis(20 SECONDS)
	ADD_TRAIT(affected, TRAIT_FINGERLESS, "[type]")
	ADD_TRAIT(affected, TRAIT_BRITTLE, "[type]")
	switch(affected.body_zone)
		if(BODY_ZONE_R_LEG)
			affected.owner.add_movespeed_modifier(MOVESPEED_ID_FRACTURE_RIGHT_LEG, multiplicative_slowdown = FRACTURED_ADD_SLOWDOWN)
		if(BODY_ZONE_L_LEG)
			affected.owner.add_movespeed_modifier(MOVESPEED_ID_FRACTURE_LEFT_LEG, multiplicative_slowdown = FRACTURED_ADD_SLOWDOWN)

/datum/wound/fracture/on_bodypart_loss(obj/item/bodypart/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_FINGERLESS, "[type]")
	REMOVE_TRAIT(affected, TRAIT_BRITTLE, "[type]")
	if(!affected.owner)
		return
	switch(affected.body_zone)
		if(BODY_ZONE_R_LEG)
			affected.owner.remove_movespeed_modifier(MOVESPEED_ID_FRACTURE_RIGHT_LEG)
		if(BODY_ZONE_L_LEG)
			affected.owner.remove_movespeed_modifier(MOVESPEED_ID_FRACTURE_LEFT_LEG)

/datum/wound/fracture/on_mob_gain(mob/living/affected)
	. = ..()
	if(gain_emote)
		affected.emote(gain_emote, TRUE)
	affected.Slowdown(20)
	shake_camera(affected, 2, 2)

/datum/wound/fracture/proc/set_bone()
	if(!can_set)
		return FALSE
	sleep_healing = max(sleep_healing, 1)
	passive_healing = max(passive_healing, 1)
	heal_wound(initial(whp)/1.6) //heal a little more than of maximum fracture
	can_set = FALSE
	return TRUE

/datum/wound/fracture/head
	name = "cranial fracture"
	check_name = span_bone("<B>SKULLCRACK</B>")
	crit_message = list(
		"The skull shatters in a gruesome way!",
		"The head is smashed!",
		"The skull is broken!",
		"The skull caves in!",
	)
	sound_effect = "headcrush"
	whp = 150
	sleep_healing = 0
	/// Most head fractures are serious enough to cause paralysis.
	var/paralysis = TRUE
	/// Some head fractures instantly kill you if you have critical weakness. Others won't.
	mortal = TRUE
	/// Some head fractures will knock your lights out, if not flat-out paralyze you.
	var/knockout = 10	//10 tick knockout (1 sec)

/datum/wound/fracture/head/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_DISFIGURED, "[type]")
	if(knockout)
		affected.Unconscious(knockout)
	if(paralysis)
		ADD_TRAIT(affected, TRAIT_NO_BITE, "[type]")
		ADD_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
		ADD_TRAIT(affected, TRAIT_NOPAIN, "[type]")
		if(iscarbon(affected))
			var/mob/living/carbon/carbon_affected = affected
			carbon_affected.update_disabled_bodyparts()

/datum/wound/fracture/head/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_DISFIGURED, "[type]")
	if(paralysis)
		REMOVE_TRAIT(affected, TRAIT_NO_BITE, "[type]")
		REMOVE_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
		REMOVE_TRAIT(affected, TRAIT_NOPAIN, "[type]")
		if(iscarbon(affected))
			var/mob/living/carbon/carbon_affected = affected
			carbon_affected.update_disabled_bodyparts()

/datum/wound/fracture/head/on_life()
	. = ..()
	owner?.stuttering = max(owner.stuttering, 5)

/datum/wound/fracture/head/brain
	name = "depressed cranial fracture"
	severity = WOUND_SEVERITY_FATAL
	crit_message = list(
		"The cranium is punctured!",
		"The cranium is pierced!",
		"The cranium is torn!",
	)
	embed_chance = 100	// Didn't we remove embeding..?
	bleed_rate = 10		// Aooouuugh.. my brain..
	knockout = 20
	paralysis = TRUE

/datum/wound/fracture/head/eyes
	name = "orbital fracture"
	crit_message = list(
		"The orbital bone is punctured!",
		"The orbital bone is pierced!",
		"The eye socket is punctured!",
		"The eye socket is pierced!",
	)
	embed_chance = 100
	clotting_threshold = 0.4	//Eye-bone fucked
	paralysis = FALSE			//Fucks your eyes, but won't paralyze you anymore.

/datum/wound/fracture/head/eyes/on_mob_gain(mob/living/affected)
	. = ..()
	affected.become_blind("[type]")
	addtimer(CALLBACK(affected, TYPE_PROC_REF(/mob/living, cure_blind), "[type]"), 30 SECONDS)
	affected.become_nearsighted("[type]")

/datum/wound/fracture/head/eyes/on_mob_loss(mob/living/affected)
	. = ..()
	affected.cure_blind("[type]")	//Fallback incase you somehow get un-skullcracked before the timer.
	affected.cure_nearsighted("[type]")

/datum/wound/fracture/head/ears
	name = "temporal fracture"
	severity = WOUND_SEVERITY_FATAL
	crit_message = list(
		"The orbital bone is punctured!",
		"The temporal bone is pierced!",
		"The ear canal is punctured!",
		"The ear canal is pierced!",
	)
	embed_chance = 100
	paralysis = FALSE
	knockout = 25
	clotting_threshold = 0.3	//Ears gonna bleed worse than just a fracture

/datum/wound/fracture/head/ears/on_mob_gain(mob/living/affected)
	. = ..()
	to_chat(affected, span_warning("My ears ring before suddenly cutting out all sound!"))
	affected.confused += 25	//Drunk-walk effect, basically.
	affected.dizziness += 25
	ADD_TRAIT(affected, TRAIT_DEAF, "[type]")

/datum/wound/fracture/head/ears/on_mob_loss(mob/living/affected)
	. = ..()
	to_chat(affected, span_notice("Slowly my hearing comes back to me.."))
	affected.confused -= 25
	affected.dizziness -= 25
	REMOVE_TRAIT(affected, TRAIT_DEAF, "[type]")

/datum/wound/fracture/head/nose
	name = "nasal fracture"
	crit_message = list(
		"The nasal bone is punctured!",
		"The nasal bone is pierced!",
	)
	paralysis = FALSE	//Fucks your nose, but won't paralyze you anymore.
	knockout = 20		//Longer knockout than a normal head-fracture
	clotting_threshold = 0.3	//Nose bleeds as bad as ears gonna bleed worse than just a fracture

/datum/wound/fracture/head/nose/on_mob_gain(mob/living/affected)
	. = ..()
	affected.confused += 15	//Strong-drunk-walk effect, basically.
	affected.dizziness += 15
	ADD_TRAIT(affected, TRAIT_MISSING_NOSE, "[type]")
	ADD_TRAIT(affected, TRAIT_DISFIGURED, "[type]")

/datum/wound/fracture/head/nose/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_MISSING_NOSE, "[type]")
	REMOVE_TRAIT(affected, TRAIT_DISFIGURED, "[type]")

/datum/wound/fracture/mouth
	name = "mandibular fracture"
	check_name = span_bone("JAW FRACTURE")
	crit_message = list(
		"The mandible comes apart beautifully!",
		"The jaw is smashed!",
		"The jaw is shattered!",
		"The jaw caves in!",
	)
	mortal = FALSE
	whp = 50
	bleed_rate = 5				//Lower than others, still bad though. 
	clotting_threshold = 0.3	//Slightly higher still
	clotting_rate = 0.1			//Slower clotting, not bad though for bleeder wound.

/datum/wound/fracture/mouth/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_NO_BITE, "[type]")
	ADD_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/fracture/mouth/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_NO_BITE, "[type]")
	REMOVE_TRAIT(affected, TRAIT_GARGLE_SPEECH, "[type]")

/datum/wound/fracture/neck
	name = "cervical fracture"
	check_name = span_bone("<B>NECK</B>")
	crit_message = list(
		"The spine shatters in a spectacular way!",
		"The spine snaps!",
		"The spine cracks!",
		"The spine is broken!",
	)
	whp = 100

/datum/wound/fracture/neck/on_mob_gain(mob/living/affected)
	. = ..()
	ADD_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
	ADD_TRAIT(affected, TRAIT_NOPAIN, "[type]")
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.update_disabled_bodyparts()
	if(HAS_TRAIT(affected, TRAIT_CRITICAL_WEAKNESS))
		affected.death()

/datum/wound/fracture/neck/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_PARALYSIS, "[type]")
	REMOVE_TRAIT(affected, TRAIT_NOPAIN, "[type]")
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.update_disabled_bodyparts()

/datum/wound/fracture/chest
	name = "rib fracture"
	check_name = span_bone("<B>RIBS</B>")
	crit_message = list(
		"The ribs shatter in a splendid way!",
		"The ribs are smashed!",
		"The ribs are mauled!",
		"The ribcage caves in!",
	)
	whp = 50
	bleed_rate = 25				//Higher than artery
	clotting_threshold = 1		//Will always bleed bad
	clotting_rate = 1			//Good clotting rate; within 24 ticks (~3 seconds) will lower heavily.

/datum/wound/fracture/chest/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Immobilize(15)		//Stuns you, major downside
	if(istype(affected, /mob/living/carbon)) // Intended for PVE skeletons
		var/mob/living/carbon/CA = affected
		if(HAS_TRAIT(CA, TRAIT_CRITICAL_WEAKNESS) && (NOBLOOD in CA.dna.species.species_traits))
			CA.death()

/datum/wound/fracture/chest/on_life()
	. = ..()
	if(!iscarbon(owner))
		return
	var/mob/living/carbon/carbon_owner = owner
	if(!carbon_owner.stat && prob(5))
		carbon_owner.vomit(1, blood = TRUE, stun = TRUE)

/datum/wound/fracture/groin
	name = "pelvic fracture"
	check_name = span_bone("<B>PELVIS</B>")
	crit_message = list(
		"The pelvis shatters in a magnificent way!",
		"The pelvis is smashed!",
		"The pelvis is mauled!",
		"The pelvic floor caves in!",
	)
	whp = 50
	gain_emote = "groin"	//MY PIINTLE!!!!
	mortal = FALSE
	bleed_rate = 5
	clotting_threshold = 1
	clotting_rate = 0.5

/datum/wound/fracture/groin/on_mob_gain(mob/living/affected)
	. = ..()
	affected.Immobilize(15)
	ADD_TRAIT(affected, TRAIT_PARALYSIS_R_LEG, "[type]")
	ADD_TRAIT(affected, TRAIT_PARALYSIS_L_LEG, "[type]")
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.update_disabled_bodyparts()

/datum/wound/fracture/groin/on_mob_loss(mob/living/affected)
	. = ..()
	REMOVE_TRAIT(affected, TRAIT_PARALYSIS_R_LEG, "[type]")
	REMOVE_TRAIT(affected, TRAIT_PARALYSIS_L_LEG, "[type]")
	if(iscarbon(affected))
		var/mob/living/carbon/carbon_affected = affected
		carbon_affected.update_disabled_bodyparts()
