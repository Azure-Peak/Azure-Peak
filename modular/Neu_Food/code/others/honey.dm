
// -------------- SPIDER HONEY -----------------
/obj/item/reagent_containers/food/snacks/rogue/honey
	name = "honey"
	icon = 'modular/Neu_Food/icons/others/honey.dmi'
	icon_state = "honeycomb"
	dropshrink = 0.8
	bitesize = 3
	possible_transfer_amounts = list()
	list_reagents = list(/datum/reagent/consumable/honey = 5, /datum/reagent/consumable/nutriment = SNACK_DECENT)
	grind_results = list()
	disease_amount = 0
	volume = 10
	amount_per_transfer_from_this = 0
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_TINY
	spillable = FALSE
	tastes = list("sweetness" = 1)
	eat_effect = null
	rotprocess = null

	var/honey_color = ""

/obj/item/reagent_containers/food/snacks/rogue/honey/Initialize()
	. = ..()
	pixel_x = rand(8,-8)
	pixel_y = rand(8,-8)
	update_icon()


/obj/item/reagent_containers/food/snacks/rogue/honey/update_icon()
	cut_overlays()
	var/mutable_appearance/honey_overlay = mutable_appearance(icon, /datum/reagent/consumable/honey)
	if(honey_color)
		honey_overlay.icon = 'modular/Neu_Food/icons/others/honey.dmi'
		honey_overlay.icon_state = "greyscale_honey"
		honey_overlay.color = honey_color
	add_overlay(honey_overlay)


/obj/item/reagent_containers/food/snacks/rogue/honey/proc/set_reagent(reagent)
	var/datum/reagent/R = GLOB.chemical_reagents_list[reagent]
	if(istype(R))
		name = "honeycomb ([R.name])"
		honey_color = R.color
		reagents.add_reagent(R.type,5)
	else
		honey_color = ""
	update_icon()

/obj/item/reagent_containers/food/snacks/rogue/honey/spider
	name = "spider honey"
	icon_state = "spiderhoney"
	tastes = list("sweetness and spiderwebs" = 1)
