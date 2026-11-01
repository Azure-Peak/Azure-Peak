// File for all cooked seafood meals, not including those that count as pastries.

/* ............ Filet meals ................... */
/obj/item/reagent_containers/food/snacks/rogue/filetmeal
	abstract_type = /obj/item/reagent_containers/food/snacks/rogue/filetmeal
	cuisine = CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_SEAFOOD
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_FINE
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	var/fish_name
	var/filet_faretype = FARE_NEUTRAL
	var/fare_bonus = FARE_BONUS_GARNISH
	var/name_prefix
	var/name_suffix
	var/list/filet_tastes
	var/list/garnish_tastes
	var/fish_quality_mult = 1

/obj/item/reagent_containers/food/snacks/rogue/filetmeal/get_stockpile_quality_mult()
	return fish_quality_mult

/obj/item/reagent_containers/food/snacks/rogue/filetmeal/inherit_recipe_base(obj/item/reagent_containers/food/snacks/rogue/base)
	if(istype(base, /obj/item/reagent_containers/food/snacks/rogue/filetmeal))
		var/obj/item/reagent_containers/food/snacks/rogue/filetmeal/meal = base
		fish_name = meal.fish_name
		filet_faretype = meal.filet_faretype
		filet_tastes = meal.filet_tastes?.Copy()
		fish_quality_mult = meal.fish_quality_mult
	else if(istype(base, /obj/item/reagent_containers/food/snacks/rogue/meat/fish))
		var/obj/item/reagent_containers/food/snacks/rogue/meat/fish/filet = base
		fish_name = filet.fish_name
		filet_faretype = filet.faretype
		filet_tastes = filet.tastes?.Copy()
		fish_quality_mult = filet.fish_quality_mult
	else
		return
	faretype = min(filet_faretype + fare_bonus, FARE_LAVISH)
	if(fish_name)
		name = "[name_prefix ? "[name_prefix] " : ""][fish_name] filet[name_suffix ? " [name_suffix]" : ""]"
	if(length(filet_tastes))
		var/list/combined = filet_tastes.Copy()
		counterlist_combine(combined, garnish_tastes)
		set_tastes(combined)

/obj/item/reagent_containers/food/snacks/rogue/filetmeal/pepper
	cuisine = CUISINE_RANESHENI
	name = "pepperfilet"
	desc = "Roasted fish flipped against itself and coated in pepper."
	icon_state = "filet_pepper"
	tastes = list("warm fish" = 1, "pepper" = 1)
	garnish_tastes = list("pepper" = 1)
	name_prefix = "peppered"

/obj/item/reagent_containers/food/snacks/rogue/filetmeal/ducal
	name = "ducal filet"
	desc = "Fish fried and coated in pepper and garlick. The garlick gives a savory kick to the fish and neutralizes the fishy odor, and the pepper adds a bit of heat. The preferred way of royalty to eat fish since time immeorial in Azuria."
	icon_state = "filet_ducal"
	tastes = list("warm fish" = 1, "pepper" = 1, "garlick" = 1)
	garnish_tastes = list("pepper" = 1, "garlick" = 1)
	faretype = FARE_LAVISH
	fare_bonus = FARE_BONUS_DUCAL
	eat_effect = /datum/status_effect/buff/greatmealbuff
	name_prefix = "ducal"

/obj/item/reagent_containers/food/snacks/rogue/filetmeal/onion
	cuisine = CUISINE_NORTH_IMPERIAL
	dish_type = DISH_SEAFOOD|DISH_VEGETABLE
	name = "filet with onion"
	desc = "A simple and delicious preparation of fish filet with fried onions, which counters the fishy smell and add a bit of sweetness and aroma to the dish."
	icon_state = "filet_onion"
	tastes = list("warm fish" = 1, "onion" = 1)
	garnish_tastes = list("onion" = 1)
	name_suffix = "with onion"

/obj/item/reagent_containers/food/snacks/rogue/filetmeal/potato
	dish_type = DISH_SEAFOOD|DISH_VEGETABLE
	name = "filet with potatoes"
	desc = "A staple in the north in Rosawood amongst the Rossan elves. Lean fish fillets served with a side of roasted potatoes."
	icon_state = "filet_potato"
	tastes = list("warm fish" = 1, "potato" = 1)
	garnish_tastes = list("potato" = 1)
	name_suffix = "with potatoes"

/obj/item/reagent_containers/food/snacks/rogue/filetmeal/tomato
	dish_type = DISH_SEAFOOD|DISH_FRUIT
	name = "filet with tomato"
	desc = "Tomatoes have a savory and acidic taste to it, making it exceptionally suitable for pairing with fishes that have a mild taste. It is particularly popular amongst the Etruscan as a pairing."
	icon_state = "filet_tomato"
	tastes = list("warm fish" = 1, "tomato" = 1)
	garnish_tastes = list("tomato" = 1)
	name_suffix = "with tomato"

/obj/item/reagent_containers/food/snacks/rogue/filetmeal/jacksberry
	dish_type = DISH_SEAFOOD|DISH_FRUIT
	name = "filet with jacksberries"
	desc = "A sweet and tangy combination of jackberries with fish fillet. Sometimes served with salmons, as appropriate for a bear, or served with lighter fishes. It is said to be a Gronnic dish, but is also popular in Azuria particularly in the south due to its symbolic association with the first Bishop of the Azurian church. It is also wildly believed to be a 'pious' dish as it combines the domain of Dendor and Abyssor."
	icon_state = "filet_jacksberry"
	tastes = list("warm fish" = 1, "jacksberries" = 1)
	garnish_tastes = list("jacksberries" = 1)
	name_suffix = "with jacksberries"

/obj/item/reagent_containers/food/snacks/rogue/filetmeal/honey
	dish_type = DISH_SEAFOOD|DISH_HONEY
	name = "honeyed filet"
	desc = "Fish filets served with sweet honey. Often used with firm fishes like sturgeons or salmon to complement its rich taste. It is a popular Gronnic and Grenzelhoftian dish."
	icon_state = "filet_honey"
	tastes = list("warm fish" = 1, "honey" = 1)
	garnish_tastes = list("honey" = 1)
	name_prefix = "honeyed"

/obj/item/reagent_containers/food/snacks/rogue/filetmeal/cucumber
	dish_type = DISH_SEAFOOD|DISH_VEGETABLE
	name = "filet with cucumber"
	desc = "A cooked fish fillet paired with sliced raw cucumber. The cucumber have a refreshing and crisp tastes. Amongst the Kazengunese and Lingyuese, this is preferably served with some herbs and vinegar to make it light and refreshing. In Azuria, local herbs like oregano and thyme are usually sprinkled on top."
	icon_state = "filet_cucumber"
	tastes = list("warm fish" = 1, "cucumber" = 1)
	garnish_tastes = list("cucumber" = 1)
	name_suffix = "with cucumber"


/* salmon st dendor*/
/obj/item/reagent_containers/food/snacks/rogue/dendorsalmon
	cuisine = CUISINE_SOUTH_IMPERIAL|CUISINE_OTAVAIS
	dish_type = DISH_SEAFOOD
	name = "saint dendor's salmon"
	desc = "A dish invented in Otava, of a green sauce of fat and herbs atop salmon."
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "salmon_st_columbia"
	tastes = list("warm fish" = 1, "fatty herbaceousness" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_LAVISH
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'


/* salmon wit the berry on it */
/obj/item/reagent_containers/food/snacks/rogue/berrysalmon
	cuisine = CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_SEAFOOD|DISH_FRUIT
	name = "berrymash salmon"
	desc = "A dish of jacksberries mashed atop peppered salmon. Hearty."
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "salmon_berry"
	tastes = list("peppered fish" = 1, "fruity lightness" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_LAVISH
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'


/* lobsta with the pepper all over it*/
/obj/item/reagent_containers/food/snacks/rogue/pepperlobsta
	cuisine = CUISINE_SOUTH_IMPERIAL|CUISINE_OTAVAIS
	dish_type = DISH_SEAFOOD
	name = "peppertail"
	desc = "A sprinkle of pepper atop the tail of a cretinous, fighty beast. It adds a hint of kick to its sweet and succulent flesh."
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "pepper_tail"
	tastes = list("peppered crustacean" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	faretype = FARE_LAVISH
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'


/*garlick seabass*/
/obj/item/reagent_containers/food/snacks/rogue/garlickbass
	cuisine = CUISINE_SOUTH_IMPERIAL|CUISINE_OTAVAIS
	dish_type = DISH_SEAFOOD
	name = "garlicked seabass"
	desc = "Seabass, with cloves of garlick smothered onto it. Delicious."
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "garlick_seabass"
	tastes = list("pungent aromatics" = 1, "flaky fish goodness" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_FINE
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'


/*milk clam*/
/obj/item/reagent_containers/food/snacks/rogue/milkclam
	cuisine = CUISINE_SOUTH_IMPERIAL|CUISINE_OTAVAIS
	dish_type = DISH_SEAFOOD|DISH_DAIRY
	name = "milkclams"
	desc = "Clams, simmered in milk... How queer."
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "milk_clams"
	tastes = list("milky crustacean" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_LAVISH
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'


/*ale cod*/
/obj/item/reagent_containers/food/snacks/rogue/alecod
	cuisine = CUISINE_SOUTH_IMPERIAL|CUISINE_NORTHERN
	dish_type = DISH_SEAFOOD
	name = "alecod"
	desc = "Cod with ale poured over it right after cooking. A... choice pick."
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "ale_cod"
	tastes = list("flaky ale-soaked fish" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_FINE
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'


/*onion plaice*/
/obj/item/reagent_containers/food/snacks/rogue/onionplaice
	cuisine = CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_SEAFOOD|DISH_VEGETABLE
	name = "plaice with onion"
	desc = "A slab of plaice with fried onion. Delicious!"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "onion_plaice"
	tastes = list("oniony fish" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_LAVISH
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'


/*buttery soles*/
/obj/item/reagent_containers/food/snacks/rogue/buttersole
	cuisine = CUISINE_SOUTH_IMPERIAL|CUISINE_OTAVAIS
	dish_type = DISH_SEAFOOD|DISH_DAIRY
	name = "buttered sole"
	desc = "A slab of sole, buttered and crispy at the edges."
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "butter_sole"
	tastes = list("fatty fish" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_FINE
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'


/* ............ Sunny ................... */
/obj/item/reagent_containers/food/snacks/rogue/sunnypepper
	cuisine = CUISINE_RANESHENI
	dish_type = DISH_SEAFOOD
	name = "peppered sunny"
	desc = "Sunny, the furtive and abundant fishes that seek Astrata's light and considered a poor man's fish, is much elevated with the proper addition of pepper. It is a simple dish that is a staple in Raneshen, where pepper is cheap."
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "sunny_pepper"
	tastes = list("warm fish" = 1, "pepper" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_NEUTRAL
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/obj/item/reagent_containers/food/snacks/rogue/sunnypepper/ducal
	cuisine = CUISINE_SOUTH_IMPERIAL
	name = "ducal sunny"
	desc = "How to elevate a humble fish to a dish fit for the Grand Duke themselves? Add garlic on top of pepper. And besides, what more fitting fish for the blessed of Astrata than a fish named sunny? It is said that nobles really prefer any other fishes, but a pepper and garlicked sunny is always presented in most feast due to its symbolic value."
	icon_state = "sunny_ducal"
	tastes = list("warm fish" = 1, "pepper" = 1, "garlick" = 1)
	faretype = FARE_FINE
	eat_effect = /datum/status_effect/buff/greatmealbuff

/obj/item/reagent_containers/food/snacks/rogue/sunnypotato
	cuisine = CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_SEAFOOD|DISH_VEGETABLE
	name = "sunny with potatoes"
	desc = "A poor, bait fish served with potatoes, making for a proper peasant's meal. A common staple amongst coastal Azurians. But even peasants would prefer to eat any other fishes."
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "sunny_potato"
	tastes = list("warm fish" = 1, "potato" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_NEUTRAL
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/obj/item/reagent_containers/food/snacks/rogue/sunnyonion
	cuisine = CUISINE_NORTH_IMPERIAL
	dish_type = DISH_SEAFOOD|DISH_VEGETABLE
	name = "sunny with onion"
	desc = "The addition of fried onions add savoriness and aroma to a troublesome, furtive, tiny fish full of bone and lacking in meat."
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "sunny_onion"
	tastes = list("warm fish" = 1, "onion" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_NEUTRAL
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/* ............ Plaice ................... */
/obj/item/reagent_containers/food/snacks/rogue/plaicepepper
	cuisine = CUISINE_RANESHENI
	dish_type = DISH_SEAFOOD
	name = "peppered plaice"
	desc = "Plaice! A fish found in abundance and yet with delicious and delicate flesh. Adding pepper makes it properly suited for noble tastes."
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "plaice_pepper"
	tastes = list("warm fish" = 1, "pepper" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_LAVISH
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/obj/item/reagent_containers/food/snacks/rogue/plaicepepper/ducal
	cuisine = CUISINE_SOUTH_IMPERIAL
	name = "ducal plaice"
	desc = "Pepper alone may elevate the plaice, but the addition of garlick lends the dish some much needed complexity for the discerning gourmet."
	icon_state = "plaice_ducal"
	tastes = list("warm fish" = 1, "pepper" = 1, "garlick" = 1)
	faretype = FARE_LAVISH
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*jellied eel*/
/obj/item/reagent_containers/food/snacks/rogue/jelliedeel
	cuisine = CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_SEAFOOD
	name = "jellied eel"
	desc = "Jellied eel! Eel in jelly made of eel! By the ten!"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "jellied_eel"
	tastes = list("slimy, slippery fish" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	faretype = FARE_LAVISH
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/* ............ Shellfish ................... */
/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal
	dish_type = DISH_SEAFOOD|DISH_DAIRY
	cuisine = CUISINE_SOUTH_IMPERIAL|CUISINE_OTAVAIS
	name = "buttered lobster"
	desc = "A lobster, covered in butter. Delicious!"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "lobster_meal"
	tastes = list("lobster" = 1, "butter" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	faretype = FARE_LAVISH
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
// Close enough crab cake has two steps but it is a whatever

/obj/item/reagent_containers/food/snacks/rogue/crabcake
	cuisine = CUISINE_SOUTH_IMPERIAL
	dish_type = DISH_SEAFOOD|DISH_DAIRY
	name = "crab cake"
	desc = "A variant of the handpie filled with buttery, savory shellfish meat and made with a buttered slice of dough."
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "crab_cake"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	bitesize = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION + MEATSLAB_NUTRITION)
	tastes = list("crispy butterdough and shellfish meat" = 1)
	faretype = FARE_LAVISH
	rotprocess = null
	dropshrink = 0.8
