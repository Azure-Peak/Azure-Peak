/obj/item/organ/guts //This does nothing it's a nice placeholder though for when it could DO something.
	name = "guts"
	icon_state = "guts"
	w_class = WEIGHT_CLASS_SMALL
	zone = BODY_ZONE_PRECISE_STOMACH
	slot = ORGAN_SLOT_GUTS
	desc = ""

	maxHealth = STANDARD_ORGAN_THRESHOLD
	healing_factor = STANDARD_ORGAN_HEALING
	decay_factor = STANDARD_ORGAN_DECAY


/obj/item/organ/guts/lux
	name = "artificed guts"
	icon_state = "guts-lux"
	desc = "A detestable collection of artificed gilbranze tubes, and scrap offal."
	//organ_flags = ORGAN_LUX //this is for aesthetics for the time being
	decay_factor = 0

/obj/item/organ/guts/lux/prepare_eat()
	return FALSE //this thing isn't edible flesh

/obj/item/organ/guts/lux/get_examine_highlight_status()
	return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_SUSPICIOUS, HERESYDESC_LUX_ORGAN)
