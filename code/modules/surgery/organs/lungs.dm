/obj/item/organ/lungs
	var/failed = FALSE
	var/operated = FALSE	//whether we can still have our damages fixed through surgery
	name = "lungs"
	icon_state = "lungs"
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_LUNGS
	gender = PLURAL
	w_class = WEIGHT_CLASS_SMALL

	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY

	high_threshold_passed = "<span class='warning'>I feel some sort of constriction around my chest as my breathing becomes shallow and rapid.</span>"
	now_fixed = "<span class='warning'>My lungs seem to once again be able to hold air.</span>"
	high_threshold_cleared = "<span class='info'>The constriction around my chest loosens as my breathing calms down.</span>"


/obj/item/organ/lungs/on_life()
	..()
	if((!failed) && ((organ_flags & ORGAN_FAILING)))
		if(owner.stat == CONSCIOUS)
			owner.visible_message("<span class='danger'>[owner] grabs [owner.p_their()] throat, struggling for breath!</span>", \
								"<span class='danger'>I suddenly feel like you can't breathe!</span>")
		failed = TRUE
	else if(!(organ_flags & ORGAN_FAILING))
		failed = FALSE
	return

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

/obj/item/organ/lungs/lux
	name = "artificed lungs"
	desc = "A set of gilbranze chambers, with bellows set into the bottom. A gilbranze tube extends from the top"
	icon_state = "lungs-lux"
	decay_factor = 0
	organ_flags = ORGAN_LUX

/obj/item/organ/lungs/lux/prepare_eat()
	return FALSE //this thing isn't edible flesh

/obj/item/organ/lungs/lux/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_LUX_ORGAN)

/obj/item/organ/lungs/lux/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("An Artificed Stomach harnesses its host's Lux, allowing them to ")
	. += span_info("If the user has no lux to spare, they can only support one Artificed Organ, or one pair of Gilbranze Limbs")
	. += span_info("Whilst the wearer has Lux, they can support up to two Artificed Organs, or pairs of Gilbranze Limbs, without failure. An Artificed Heart increases this capacity by one")

/obj/item/organ/lungs/lux/on_life()
	..()
	if(owner.check_lux_organ_cap())
		if((!failed))
			if(owner.stat == CONSCIOUS)
				owner.visible_message("<span class='danger'>[owner] grabs [owner.p_their()] throat, struggling for breath!</span>", \
									"<span class='danger'>I suddenly feel like you can't breathe!</span>")
			failed = TRUE
		return
	else if(!(organ_flags & ORGAN_FAILING))
		failed = FALSE
