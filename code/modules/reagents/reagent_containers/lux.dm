/obj/item/reagent_containers/lux
	name = "lux"
	desc = "The stuff of life and souls, retrieved from within a hopefully-willing donor. It's a bit clammy and squishy, like a half-fried egg."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux"
	item_state = "lux"
	possible_transfer_amounts = list()
	volume = 15
	list_reagents = list(/datum/reagent/vitae = 5)
	grind_results = list(/datum/reagent/vitae = 5)
	sellprice = 90

/datum/reagent/vitae
	name = "Vitae"
	description = "The extracted and processed essence of life."
	color = "#7d8e98" // rgb: 96, 165, 132
	overdose_threshold = 10
	metabolization_rate = 0.1

/datum/reagent/vitae/overdose_process(mob/living/M)
	M.adjustOrganLoss(ORGAN_SLOT_HEART, 0.25  * REAGENTS_EFFECT_MULTIPLIER)
	M.adjustFireLoss(0.25  * REAGENTS_EFFECT_MULTIPLIER, 0)
	..()
	. = 1

/datum/reagent/vitae/on_mob_life(mob/living/carbon/M)
	if(M.has_flaw(/datum/charflaw/addiction/junkie))
		M.sate_addiction()
	M.apply_status_effect(/datum/status_effect/buff/vitae)
	..()

/obj/item/reagent_containers/lux_impure
	name = "impure lux"
	desc = "The stuff of life and souls, retrieved from within a hopefully-willing donor. It's eerie and impure, requiring purification."
	icon = 'icons/roguetown/items/produce.dmi'
	icon_state = "lux_impure"
	item_state = "lux_impure"
	sellprice = 15
