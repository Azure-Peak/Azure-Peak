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

/obj/item/organ/guts/floran
	icon = 'icons/obj/surgery_shrubbery.dmi'
	icon_state = "guts_plant"

/obj/item/organ/guts/myconid
	icon = 'icons/obj/surgery_shrubbery.dmi'
	icon_state = "guts_myco"

/obj/item/organ/guts/ent
	icon = 'icons/obj/surgery_shrubbery.dmi'
	icon_state = "guts_ent"
