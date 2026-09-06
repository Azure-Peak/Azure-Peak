/obj/item/organ/stomach
	name = "stomach"
	icon_state = "stomach"
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_PRECISE_STOMACH
	slot = ORGAN_SLOT_STOMACH
	attack_verb = list("gored", "squished", "slapped", "digested")
	desc = ""

	medical_organ = TRUE
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	low_threshold_passed = span_info("My stomach flashes with pain before subsiding. Food doesn't seem like a good idea right now.")
	high_threshold_passed = span_warning("My stomach flares up with constant pain- you can hardly stomach the idea of food right now!")
	high_threshold_cleared = span_info("The pain in my stomach dies down for now, but food still seems unappealing.")
	low_threshold_cleared = span_info("The last bouts of pain in my stomach have died out.")

	var/disgust_metabolism = 1

/obj/item/organ/stomach/on_life()
	var/mob/living/carbon/human/H = owner
	..()	//base -> apply_injury_effects (hunger clamp)
	if(istype(H))
		if(injury != ORGAN_INJURY_DEAD)
			H.dna.species.handle_digestion(H)
		handle_disgust(H)

// An injured stomach can no longer keep you fed: it locks your nutrition at a ceiling you cannot
// climb above until it is repaired. Minor: Hungry. Severe: Starving. Dead/missing: Starving + slow toxloss.
/obj/item/organ/stomach/apply_injury_effects()
	if(!owner)
		return
	switch(injury)
		if(ORGAN_INJURY_MINOR)
			if(owner.nutrition > NUTRITION_LEVEL_HUNGRY)
				owner.set_nutrition(NUTRITION_LEVEL_HUNGRY)
		if(ORGAN_INJURY_SEVERE)
			if(owner.nutrition > NUTRITION_LEVEL_STARVING)
				owner.set_nutrition(NUTRITION_LEVEL_STARVING)
		if(ORGAN_INJURY_DEAD)
			if(owner.nutrition > NUTRITION_LEVEL_STARVING)
				owner.set_nutrition(NUTRITION_LEVEL_STARVING)
			owner.adjustToxLoss(0.5)	//a ruined gut slowly poisons you

/obj/item/organ/stomach/on_injury_changed()
	if(!owner)
		return
	switch(injury)
		if(ORGAN_INJURY_MINOR)
			to_chat(owner, span_warning("My stomach cramps - no matter how I eat, the hunger lingers."))
		if(ORGAN_INJURY_SEVERE)
			to_chat(owner, span_danger("My stomach twists violently - I am wracked with starving hunger!"))
		if(ORGAN_INJURY_DEAD)
			to_chat(owner, span_userdanger("My stomach is ruined - I starve, and the rot of it seeps into me!"))
		if(ORGAN_INJURY_NONE)
			to_chat(owner, span_info("My stomach settles, able to hold food once more."))

/obj/item/organ/stomach/proc/handle_disgust(mob/living/carbon/human/H)
	if(H.disgust)
		var/pukeprob = 5 + 0.05 * H.disgust
		if(H.disgust >= DISGUST_LEVEL_GROSS)
			if(prob(10))
				H.stuttering += 1
				H.confused += 2
			if(prob(10) && !H.stat)
				to_chat(H, span_warning("I feel kind of iffy..."))
			H.jitteriness = max(H.jitteriness - 3, 0)
		if(H.disgust >= DISGUST_LEVEL_VERYGROSS)
			if(prob(pukeprob)) //iT hAndLeS mOrE ThaN PukInG
				H.confused += 2.5
				H.stuttering += 1
				H.vomit(10, 0, 1, 0, 1, 0)
			H.Dizzy(5)
		if(H.disgust >= DISGUST_LEVEL_DISGUSTED)
			if(prob(25))
				H.blur_eyes(3) //We need to add more shit down here

		H.adjust_disgust(-0.5 * disgust_metabolism)
	switch(H.disgust)
		if(0 to DISGUST_LEVEL_GROSS)
			H.clear_alert("disgust")
		if(DISGUST_LEVEL_GROSS to DISGUST_LEVEL_VERYGROSS)
			H.throw_alert("disgust", /atom/movable/screen/alert/gross)
		if(DISGUST_LEVEL_VERYGROSS to DISGUST_LEVEL_DISGUSTED)
			H.throw_alert("disgust", /atom/movable/screen/alert/verygross)
		if(DISGUST_LEVEL_DISGUSTED to INFINITY)
			H.throw_alert("disgust", /atom/movable/screen/alert/disgusted)

/obj/item/organ/stomach/Remove(mob/living/carbon/M, special = 0)
	var/mob/living/carbon/human/H = owner
	if(istype(H))
		H.clear_alert("disgust")
	..()

/obj/item/organ/stomach/fly
	name = "insectoid stomach"
	icon_state = "stomach-x" //xenomorph liver? It's just a black liver so it fits.
	desc = ""

/obj/item/organ/stomach/plasmaman
	name = "digestive crystal"
	icon_state = "stomach-p"
	desc = ""

/obj/item/organ/stomach/construct
	name = "construct soulseed"
	icon_state = "stomach-con"
	desc = "The seat of a construct's soul, where a stomach would go. Wisps of lux cycle about, impossible to grab."
	two_state = TRUE	//the soulseed: whole, or shattered

/obj/item/organ/stomach/ethereal
	name = "biological battery"
	icon_state = "stomach-p" //Welp. At least it's more unique in functionaliy.
	desc = ""
	var/crystal_charge = ETHEREAL_CHARGE_FULL

/obj/item/organ/stomach/ethereal/on_life()
	..()
	adjust_charge(-ETHEREAL_CHARGE_FACTOR)

/obj/item/organ/stomach/ethereal/Insert(mob/living/carbon/M, special = 0)
	..()
	RegisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT, PROC_REF(charge))
	RegisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT, PROC_REF(on_electrocute))

/obj/item/organ/stomach/ethereal/Remove(mob/living/carbon/M, special = 0)
	UnregisterSignal(owner, COMSIG_PROCESS_BORGCHARGER_OCCUPANT)
	UnregisterSignal(owner, COMSIG_LIVING_ELECTROCUTE_ACT)
	..()

/obj/item/organ/stomach/ethereal/proc/charge(datum/source, amount, repairs)
	adjust_charge(amount / 70)

/obj/item/organ/stomach/ethereal/proc/on_electrocute(datum/source, shock_damage, siemens_coeff = 1, flags = NONE)
	if(flags & SHOCK_ILLUSION)
		return
	adjust_charge(shock_damage * siemens_coeff * 2)
	to_chat(owner, span_notice("I absorb some of the shock into my body!"))

/obj/item/organ/stomach/ethereal/proc/adjust_charge(amount)
	crystal_charge = CLAMP(crystal_charge + amount, ETHEREAL_CHARGE_NONE, ETHEREAL_CHARGE_FULL)
