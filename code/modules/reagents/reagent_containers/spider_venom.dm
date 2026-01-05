/datum/reagent/toxin/spidervenom_inert
	name = "Inert Aragn Essence"
	description = "Without the spider, the venom has weakened. It must be strengthened with a binding catalyst first."
	silent_toxin = TRUE
	reagent_state = SOLID
	color = "#003d99"
	toxpwr = 0
	taste_description = "blueberry"
	metabolization_rate = 10
	var/venom_resistance

/obj/item/reagent_containers/spidervenom_inert
	list_reagents = list(/datum/reagent/toxin/spidervenom_inert = 10)
	name = "Pale spider gland"
	desc = "A squishy pale gland, filled to the brim with venom of the deadly Aragn spider. Feels cold to the touch."
	icon = 'modular/Mapping/icons/webbing.dmi'
	icon_state = "gland"

/datum/reagent/toxin/spidervenom_paralytic
	name = "Aragn Essence"
	description = "A strong neurotoxin that makes muscles stiffen up and spasm."
	silent_toxin = TRUE
	reagent_state = SOLID
	color = "#99005e"
	toxpwr = 0
	taste_description = "raspberry"
	metabolization_rate = 0.01
	var/venom_resistance

/obj/item/reagent_containers/glass/bottle/alchemical/spidervenom_paralytic
	list_reagents = list(/datum/reagent/toxin/spidervenom_paralytic = 1)
	desc = "An ominous vial, filled with venom of the deadly Aragn spider. Feels hot to the touch."

/datum/reagent/toxin/spidervenom_paralytic/on_mob_metabolize(mob/living/L)
	..()
	venom_resistance += ((L.STACON - 10) * 5)
	venom_resistance += ((L.STAWIL - 10) * 3)
	venom_resistance += ((L.STASTR - 10) * 2)
	venom_resistance += (L.STALUC)
	
	if(venom_resistance <= 0)
		venom_resistance = 0
		venom_resistance += (L.STALUC * 5)

/datum/reagent/toxin/spidervenom_paralytic/on_mob_end_metabolize(mob/living/L)
	..()

/datum/reagent/toxin/spidervenom_paralytic/on_mob_life(mob/living/carbon/M)
	..()
	if(!(current_cycle % 5) && !(prob(venom_resistance / 5)))
		M.Paralyze(50)
	if(current_cycle >= 60 && !(current_cycle % 5) && prob(venom_resistance))
		M.reagents.remove_reagent(/datum/reagent/toxin/spidervenom_paralytic, 100)
