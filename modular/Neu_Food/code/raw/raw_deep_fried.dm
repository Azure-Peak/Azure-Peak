/obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel
	name = "unfinished nitzel"
	desc = "Tenderized meat, awaiting a coating of toastcrumbs and a hot oil bath."
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "nitzel_step1"
	cooked_smell = /datum/pollutant/food/fried_meat

/obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel
	name = "schnitzel"
	desc = "Tenderized spider meat, awaiting a coating of toastcrumbs and a hot oil bath."
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "schnitzel_step1"
	cooked_smell = /datum/pollutant/food/fried_meat

// Squire's delight (deep fried butter)
/obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight
	name = "unfinished squire's delight"
	desc = "A butter stick with an egg cracked over it. It awaits toastcrumbs and a hot oil bath."
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "squiresdelight_step1"
	cooked_smell = /datum/pollutant/food/fried_butter

/obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender
	name = "unfinished tender frybird"
	desc = "Tenderized meat, awaiting a coating of toastcrumbs and a hot oil bath."
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "chickentender_step1"
	cooked_smell = /datum/pollutant/food/fried_chicken

/obj/item/reagent_containers/food/snacks/rogue/foodbase/wienernitzel
	name = "unfinished wiener nitzel"
	desc = "Tenderized meat, awaiting a coating of toastcrumbs and a hot oil bath."
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "wienernitzel_step1"
	cooked_smell = /datum/pollutant/food/fried_sausage

/obj/item/reagent_containers/food/snacks/rogue/wienerstick
	name = "wiener on a stick"
	desc = "Delicious flesh stuffed in a intestine casing, impaled onto a stick, enjoyed both at circuses and on the march by Grenzelhoft soldiers."
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "griddlewiener_step1"
	faretype = FARE_NEUTRAL
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	tastes = list("tender wiener" = 1)
	cooked_smell = /datum/pollutant/food/fried_sausage
	rotprocess = SHELFLIFE_EXTREME

