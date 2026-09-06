/obj/item/organ/lungs
	var/failed = FALSE
	var/operated = FALSE	//whether we can still have our damages fixed through surgery
	name = "lungs"
	icon_state = "lungs"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LUNGS
	gender = PLURAL
	w_class = WEIGHT_CLASS_SMALL

	medical_organ = TRUE
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

// Minor: occasional gasp + reduced stamina regen (see update_stamina). Severe: harsher stamina
// penalty + gasping that briefly blocks speech. Dead/missing: increasing oxyloss.
/obj/item/organ/lungs/on_injury_changed()
	if(!owner)
		return
	switch(injury)
		if(ORGAN_INJURY_MINOR)
			to_chat(owner, span_warning("My chest tightens; my breaths come short and quick."))
		if(ORGAN_INJURY_SEVERE)
			to_chat(owner, span_danger("Each breath is a ragged, wheezing struggle!"))
		if(ORGAN_INJURY_DEAD)
			to_chat(owner, span_userdanger("My lungs give out - I cannot draw breath!"))
		if(ORGAN_INJURY_NONE)
			to_chat(owner, span_info("My breathing settles, steady once more."))

/obj/item/organ/lungs/apply_injury_effects()
	if(!owner)
		return
	switch(injury)
		if(ORGAN_INJURY_MINOR)
			if(prob(40))
				owner.adjustOxyLoss(1)	//minor oxygen debt, mostly cleared by breathing
			if(prob(15))
				owner.emote("gasp")
				owner.silent = max(owner.silent, 1)	//a gasp clips your words
		if(ORGAN_INJURY_SEVERE)
			owner.adjustOxyLoss(3)	//now it builds faster than you can recover
			if(prob(25))
				owner.emote("gasp")
				owner.silent = max(owner.silent, 2)
		if(ORGAN_INJURY_DEAD)
			owner.adjustOxyLoss(6)	//rapid suffocation
			if(prob(20))
				owner.emote("gasp")

/obj/item/organ/lungs/prepare_eat()
	var/obj/S = ..()
	return S

/obj/item/organ/lungs/plasmaman
	name = "plasma filter"
	desc = ""
	icon_state = "lungs-plasma"


/obj/item/organ/lungs/slime
	name = "vacuole"
	desc = ""

/obj/item/organ/lungs/construct
	name = "construct aersource"
	desc = "A complex hollow crystal, which courses with air through unknowable means. Steam wisps around it in a vortex."
	icon_state = "lungs-con"
	two_state = TRUE	//a crystal aersource: whole, or shattered
