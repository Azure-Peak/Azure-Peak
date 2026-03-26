// Raw veggies. Sliced variant or something please just put the rest in produce.dm
// Don't define the same shit twice holy shit.
// please don't include fruits that's in raw_fruits.dm

/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced
	name = "sliced onion"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "onion_sliced"
	slices_num = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	cooked_smell = /datum/pollutant/food/fried_onion

/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced
	name = "shredded cabbage"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "cabbage_sliced"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried
	cooked_smell = /datum/pollutant/food/fried_cabbage

/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced
	name = "potato cuts"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "potato_sliced"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	cooked_smell = /datum/pollutant/food/baked_potato

/obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced
	name = "cucumber slice"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "cucumber_slices" // TG Sprite, replace it
	desc = ""
	tastes = list("crunchy freshness" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	name = "garlick clove"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "garlic_clove"
	faretype = FARE_POOR
	desc = "A clove of garlick, fit for stewage. Don't eat this."
	tastes = list("pungent savoriness" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1, /datum/reagent/water/blessed = 2)

/obj/item/reagent_containers/food/snacks/veg/turnip_sliced
	name = "cleaned turnip"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "turnip_sliced"
