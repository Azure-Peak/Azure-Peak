// Split this file into folder and individual food type

/obj/item/reagent_containers/food/snacks/squiresdelight
	name = "squire's delight"
	desc = "A deep-fried butter stick. Beloved by squires, often stolen by knights."
	icon = 'modular/Neu_Food/icons/cooked/cooked_deep_fried.dmi'
	icon_state = "squiresdelight"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTER_NUTRITION * 2)
	foodtype = DAIRY | GRAIN
	bitesize = 6 // Consistent with butter
	faretype = FARE_FINE // Now you can eat butter as a knight...
	tastes = list("crunchy toastcrumbs" = 1, "molten butter" = 1)
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	rotprocess = SHELFLIFE_DECENT

// Cooked results
/obj/item/reagent_containers/food/snacks/rogue/meat/nitzel
	name = "nitzel"
	desc = "A deep-fried nitzel, coated in toastcrumbs and ready to eat."
	icon = 'modular/Neu_Food/icons/cooked/cooked_deep_fried.dmi'
	icon_state = "nitzel"
	faretype = FARE_LAVISH
	foodtype = MEAT | GRAIN
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_CHUNKY * 2)
	bitesize = 5 // If you go through all of the efforts to make this it should have big portion
	tastes = list("crunchy toastcrumbs" = 1, "tender pork" = 1)
	cooked_type = null
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	rotprocess = SHELFLIFE_DECENT

// Doesn't matter it was spider meat if you go through the effort it should be as good
/obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/schnitzel
	name = "schnitzel"
	desc = "A deep-fried schnitzel, coated in toastcrumbs and ready to eat."
	icon_state = "schnitzel"
	tastes = list("crunchy toastcrumbs" = 1, "tender spidermeat" = 1)
