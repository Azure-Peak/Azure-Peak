/obj/item/reagent_containers/food/snacks/rogue/cornbread
	name = "cornbread"
	desc = "A dense, golden loaf baked from cornmeal. With a crumbly texture and slightly savory flavor. A staple of the poor."
	icon = 'modular/Neu_Food/icons/cooked/cooked_corn.dmi'
	icon_state = "cornbread"
	faretype = FARE_POOR
	foodtype = GRAIN
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	rotprocess = SHELFLIFE_DECENT
	slices_num = 5
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cornbread_slice
	slice_sound = TRUE
	tastes = list("cornbread" = 1)

/obj/item/reagent_containers/food/snacks/rogue/cornbread_slice
	name = "cornbread slice"
	desc = "A crumbly slice of cornbread."
	icon = 'modular/Neu_Food/icons/cooked/cooked_corn.dmi'
	icon_state = "cornbreadslice"
	faretype = FARE_POOR
	foodtype = GRAIN
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	rotprocess = SHELFLIFE_DECENT
	tastes = list("cornbread" = 1)

/obj/item/reagent_containers/food/snacks/rogue/cornbread_honey
	name = "honey cornbread"
	desc = "Cornbread baked with honey - much sweeter than the plain version."
	icon = 'modular/Neu_Food/icons/cooked/cooked_corn.dmi'
	icon_state = "cornbread_honey"
	faretype = FARE_NEUTRAL
	foodtype = GRAIN
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	rotprocess = SHELFLIFE_DECENT
	slices_num = 3
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cornbread_honey_slice
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/snackbuff
	tastes = list("cornbread" = 1, "honey" = 1)

/obj/item/reagent_containers/food/snacks/rogue/cornbread_honey_slice
	name = "honey cornbread slice"
	desc = "A sweet, sticky slice of honey cornbread."
	icon = 'modular/Neu_Food/icons/cooked/cooked_corn.dmi'
	icon_state = "cornbreadhoneyslice"
	faretype = FARE_NEUTRAL
	foodtype = GRAIN
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_DECENT
	tastes = list("cornbread" = 1, "honey" = 1)

/obj/item/reagent_containers/food/snacks/rogue/cornfrybread
	name = "corn frybread"
	desc = "Corn flatbread fried golden and crisp. Great on its own, or topped with salsa or guacamole."
	icon = 'modular/Neu_Food/icons/cooked/cooked_corn.dmi'
	icon_state = "frybread"
	faretype = FARE_NEUTRAL
	foodtype = GRAIN
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	rotprocess = SHELFLIFE_DECENT
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cornfrybread_slice
	slice_sound = TRUE
	tastes = list("frybread" = 1)

/obj/item/reagent_containers/food/snacks/rogue/cornfrybread_slice
	name = "corn frybread slice"
	desc = "A crisp slice of fried corn flatbread."
	icon = 'modular/Neu_Food/icons/cooked/cooked_corn.dmi'
	icon_state = "frybread_slice"
	faretype = FARE_NEUTRAL
	foodtype = GRAIN
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_DECENT
	tastes = list("frybread" = 1)

/obj/item/reagent_containers/food/snacks/rogue/cornfrybread_salsa
	name = "salsa corn frybread"
	desc = "Frybread heaped with fresh-cut tomatoes. Bright and tangy."
	icon = 'modular/Neu_Food/icons/cooked/cooked_corn.dmi'
	icon_state = "frybread_salsa"
	faretype = FARE_FINE
	foodtype = GRAIN | FRUIT
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	rotprocess = SHELFLIFE_SHORT
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cornfrybread_salsa_slice
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/snackbuff
	tastes = list("frybread" = 1, "tomato" = 1)

/obj/item/reagent_containers/food/snacks/rogue/cornfrybread_salsa_slice
	name = "salsa corn frybread slice"
	desc = "A tangy, tomato-topped slice of corn frybread."
	icon = 'modular/Neu_Food/icons/cooked/cooked_corn.dmi'
	icon_state = "frybread_salsa_slice"
	faretype = FARE_FINE
	foodtype = GRAIN | FRUIT
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	rotprocess = SHELFLIFE_SHORT
	tastes = list("frybread" = 1, "tomato" = 1)

/obj/item/reagent_containers/food/snacks/rogue/cornfrybread_guac
	name = "Pesto corn frybread"
	desc = "Frybread slathered with a green, herby paste. Not quite authentic, but rich and fine."
	icon = 'modular/Neu_Food/icons/cooked/cooked_corn.dmi'
	icon_state = "frybread_guac"
	faretype = FARE_LAVISH
	foodtype = GRAIN | VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	rotprocess = SHELFLIFE_SHORT
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cornfrybread_guac_slice
	slice_sound = TRUE
	eat_effect = /datum/status_effect/buff/mealbuff
	tastes = list("frybread" = 1, "herbs" = 1)

/obj/item/reagent_containers/food/snacks/rogue/cornfrybread_guac_slice
	name = "Pesto corn frybread slice"
	desc = "A rich, herb-slathered slice of corn frybread."
	icon = 'modular/Neu_Food/icons/cooked/cooked_corn.dmi'
	icon_state = "frybread_guac_slice"
	faretype = FARE_LAVISH
	foodtype = GRAIN | VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THREE_QUARTER_MEAL)
	rotprocess = SHELFLIFE_SHORT
	tastes = list("frybread" = 1, "herbs" = 1)

/obj/item/reagent_containers/food/snacks/rogue/corn_ball_cooked
	name = "corn fritter"
	desc = "A golden fritter of fried corn dough, crisp outside and fluffy inside."
	icon = 'modular/Neu_Food/icons/cooked/cooked_corn.dmi'
	icon_state = "corn_ball_cooked"
	faretype = FARE_POOR
	foodtype = GRAIN
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_DECENT
	tastes = list("fried corn" = 1)

/obj/item/reagent_containers/food/snacks/rogue/grilledcorn
	name = "grilled corn"
	desc = "A whole cob of maize, grilled to perfection."
	icon = 'modular/Neu_Food/icons/cooked/cooked_corn.dmi'
	icon_state = "grilledcorn"
	faretype = FARE_NEUTRAL
	foodtype = GRAIN | VEGETABLES
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_DECENT
	tastes = list("corn" = 1)
	var/buttered = FALSE

/obj/item/reagent_containers/food/snacks/rogue/grilledcorn/attackby(obj/item/I, mob/living/user, params)
	if(!buttered && istype(I, /obj/item/reagent_containers/food/snacks/butterslice))
		buttered = TRUE
		name = "buttered grilled corn"
		desc += " Slathered with melting butter."
		faretype = FARE_FINE
		reagents?.add_reagent(/datum/reagent/consumable/nutriment, 2)
		add_overlay("butterforcorn")
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 30, TRUE, -1)
		qdel(I)
		return TRUE
	return ..()
