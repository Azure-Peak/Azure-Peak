#define LIVER_DEFAULT_TOX_TOLERANCE 3 //amount of toxins the liver can filter out
#define LIVER_DEFAULT_TOX_LETHALITY 0.01 //lower values lower how harmful toxins are to the liver

/obj/item/organ/liver
	name = "liver"
	icon_state = "liver"
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LIVER
	desc = ""

	medical_organ = TRUE
	maxHealth = STANDARD_ORGAN_THRESHOLD
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	var/alcohol_tolerance = ALCOHOL_RATE//affects how much damage the liver takes from alcohol
	var/toxTolerance = LIVER_DEFAULT_TOX_TOLERANCE//maximum amount of toxins the liver can just shrug off
	var/toxLethality = LIVER_DEFAULT_TOX_LETHALITY//affects how much damage toxins do to the liver
	var/filterToxins = FALSE //whether to filter toxins

/obj/item/organ/liver/on_life()
	var/mob/living/carbon/C = owner
	..()	//base on_life -> apply_injury_effects (per-state toxloss/puke)
	if(!istype(C))
		return
	//A working liver (not dead) still filters toxins and drives reagent metabolism.
	if(injury != ORGAN_INJURY_DEAD && !HAS_TRAIT(C, TRAIT_NOMETABOLISM))
		if(filterToxins && !HAS_TRAIT(owner, TRAIT_TOXINLOVER))
			//handle liver toxin filtration (no longer self-damaging - the liver is stateful, not HP-based)
			for(var/datum/reagent/toxin/T in C.reagents.reagent_list)
				var/thisamount = C.reagents.get_reagent_amount(T.type)
				if (thisamount && thisamount <= toxTolerance)
					C.reagents.remove_reagent(T.type, 1)
		//metabolize reagents - a faster pulse burns them through quicker
		C.reagents.metabolize(C, can_overdose=TRUE, rate_mult = pulse_metabolism_mult(C.pulse))
	else	//a dead liver cannot metabolize - same as having none
		C.liver_failure()

// Minor: puke now and then. Severe: toxloss rises slowly. Dead/missing: toxloss rises fast
// (handled by liver_failure()/the liver_failure status, the same as having no liver).
/obj/item/organ/liver/apply_injury_effects()
	if(!owner)
		return
	switch(injury)
		if(ORGAN_INJURY_MINOR)
			if(prob(2))
				owner.vomit(10)
		if(ORGAN_INJURY_SEVERE)
			owner.adjustToxLoss(0.5)

/obj/item/organ/liver/on_injury_changed()
	if(!owner)
		return
	switch(injury)
		if(ORGAN_INJURY_MINOR)
			to_chat(owner, span_warning("My gut churns uneasily."))
		if(ORGAN_INJURY_SEVERE)
			to_chat(owner, span_danger("A sickly heat spreads through my belly - I feel poison seeping into me."))
		if(ORGAN_INJURY_DEAD)
			to_chat(owner, span_userdanger("My liver fails utterly!"))
		if(ORGAN_INJURY_NONE)
			to_chat(owner, span_info("The sickness in my gut subsides."))

/obj/item/organ/liver/Remove(mob/living/carbon/carbon, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	carbon.apply_status_effect(/datum/status_effect/debuff/liver_failure)

/obj/item/organ/liver/Insert(mob/living/carbon/carbon, special = FALSE, drop_if_replaced = TRUE)
	. = ..()
	carbon.remove_status_effect(/datum/status_effect/debuff/liver_failure)

/obj/item/organ/liver/prepare_eat()
	var/obj/S = ..()
	S.reagents.add_reagent(/datum/reagent/iron, 5)
	return S

/obj/item/organ/liver/fly
	name = "insectoid liver"
	icon_state = "liver-x" //xenomorph liver? It's just a black liver so it fits.
	desc = ""
	alcohol_tolerance = 0.007 //flies eat vomit, so a lower alcohol tolerance is perfect!

/obj/item/organ/liver/plasmaman
	name = "reagent processing crystal"
	icon_state = "liver-p"
	desc = ""

/obj/item/organ/liver/construct
	name = "construct decay regulator"
	icon_state = "liver-con"
	desc = "A construct's decay regulator. Swirling with pestran energies, it prevents corrosion and rot. Unfortunately, this makes them susceptible to toxins."
	two_state = TRUE	//a pestran regulator: whole, or shattered

/obj/item/organ/liver/alien
	name = "alien liver" // doesnt matter for actual aliens because they dont take toxin damage
	icon_state = "liver-x" // Same sprite as fly-person liver.
	desc = ""
	toxLethality = LIVER_DEFAULT_TOX_LETHALITY * 2.5 // rejects its owner early after too much punishment
	toxTolerance = 15 // complete toxin immunity like xenos have would be too powerful

/obj/item/organ/liver/cybernetic
	name = "cybernetic liver"
	icon_state = "liver-c"
	desc = ""
	organ_flags = ORGAN_SYNTHETIC
	maxHealth = 1.1 * STANDARD_ORGAN_THRESHOLD
	toxTolerance = 3.3
	toxLethality = 0.009

/obj/item/organ/liver/cybernetic/upgraded
	name = "upgraded cybernetic liver"
	icon_state = "liver-c-u"
	desc = ""
	alcohol_tolerance = 0.001
	maxHealth = 2 * STANDARD_ORGAN_THRESHOLD
	toxTolerance = 15 //can shrug off up to 15u of toxins
	toxLethality = 0.008 //20% less damage than a normal liver

/obj/item/organ/liver/cybernetic/emp_act(severity)
	. = ..()
	if(. & EMP_PROTECT_SELF)
		return
	damage += 100/severity

#undef LIVER_DEFAULT_TOX_TOLERANCE
#undef LIVER_DEFAULT_TOX_LETHALITY
