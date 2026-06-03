// High efforts (i.e. spiced / buttered / onioned or whatever) meal where meat
// Is the main ingredient.
/*	..................   Pepper steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/peppersteak
	list_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	tastes = list("steak" = 1, "pepper" = 1)
	name = "peppersteak"
	desc = "Roasted meat flanked with a generous coating of ground pepper for intense flavor."
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "peppersteak"
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/*	..................   Ducal steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal
	tastes = list("steak" = 1, "pepper" = 1, "garlick" = 1)
	name = "ducal steak"
	desc = "Roasted meat flanked with a generous coating of ground pepper for intense flavor and scribbled in with garlick. Said to have been favorite meal of the Mad Duke."
	faretype = FARE_LAVISH
	icon_state = "ducalsteak"
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	..................   Onion steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/onionsteak
	name = "onion steak"
	desc = "Roasted meat garnished with fragrant fried onions, then slathered with the juices of both for a perfect mouth-watering sauce."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "onionsteak"
	tastes = list("steak" = 1, "onions" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	foodtype = MEAT
	faretype = FARE_NEUTRAL
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/*	..................   Carrot Steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/carrotsteak
	name = "carrot steak"
	desc = "Roasted meat paired with a savory baked carrot, then slathered with the juices of both for a perfect mouth-watering sauce."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "carrotsteak"
	tastes = list("steak" = 1, "carrot" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	foodtype = MEAT
	faretype = FARE_FINE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/*	.................   Steak & carrot & onion   ................... */
/obj/item/reagent_containers/food/snacks/rogue/steakcarrotonion
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("steak" = 1, "onion" = 1, "carrots" = 1)
	name = "steak meal"
	desc = ""
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "steakmeal"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Wiener Cabbage   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienercabbage
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	tastes = list("savory sausage" = 1, "cabbage" = 1)
	name = "wiener on cabbage"
	desc = "A rich and hearty meal, perfect for a soldier on the march."
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wienercabbage"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff


/*	.................   Wiener & Fried potato   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienerpotato
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	tastes = list("savory sausage" = 1, "potato" = 1)
	name = "wiener on tato"
	desc = "Stout and nourishing."
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wienerpotato"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Wiener & Fried onions   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wieneronions
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	tastes = list("savory sausage" = 1, "fried onions" = 1)
	name = "wiener and onions"
	desc = "Stout and flavourful."
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wieneronion"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Wiener & potato & onions   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_HALF)
	tastes = list("savory sausage" = 1, "potato" = 1)
	name = "wiener meal"
	desc = "Stout and nourishing."
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wpotonion"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................  Spiced Baked Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced
	name = "spiced bird-roast"
	desc = "A plump bird, roasted perfection, spiced to taste divine."
	faretype = FARE_LAVISH
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "pepperchicken"
	tastes = list("spicy birdmeat" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................  Ducal Spiced Baked Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal
	name = "ducal bird-roast"
	desc = "A plump bird, roasted perfection, spiced to taste divine with touch of garlick to top it all off. Perfect to feast on while your son is dying in battle..."
	faretype = FARE_LAVISH
	icon_state = "ducalchicken"
	tastes = list("spicy birdmeat" = 1, "garlick" = 1)
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................  Baked Butter Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter
	name = "butter bird-roast"
	desc = "A plump bird, roasted perfection, overflowing with butter from the inside."
	faretype = FARE_LAVISH
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "butterchicken"
	tastes = list("buttery birdmeat" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................  Baked Double Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/doublestacked
	name = "bird filled bird-roast"
	desc = "A plump bird, roasted perfection.. filled with another bird - what compelled you to make this? Psydon Weeps at your hubris."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "stuffedchicken"
	eat_effect = /datum/status_effect/buff/mealbuff
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER*2)

/*	.................   Frybird & Tato   ................... */
/obj/item/reagent_containers/food/snacks/rogue/frybirdtato
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	tastes = list("frybird" = 1, "tato" = 1)
	name = "frybird with a tato"
	desc = "Hearty, comforting, and rich - Some say it was Ravox's favorite meal."
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frybirdtato"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Frybird Bucket   ................... */
/obj/item/reagent_containers/food/snacks/rogue/frybirdbucket
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER*3)
	tastes = list("frybird" = 1)
	name = "frybird bucket"
	desc = "Hearty, comforting, and rich - Azurean Frybirds are the best on the entire continent and now even in a convinient bucket!"
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frybirdbucket"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff

/* .............   Fried Cabbit w/ Garlick  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick
	name = "garlick cabbit"
	desc = "A slab of cabbit, fried to a perfect crispy texture - coated over in glove of garlick."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frycabbit_garlick"
	tastes = list("warm cabbit" = 1, "garlick" = 1)

/* .............   Fried Cabbit w/ Garlick & Cucumber ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick/cucumber
	name = "elven cabbit roast"
	desc = "A slab of cabbit, fried to a perfect crispy texture - coated over in glove of garlick and served with side of cucumber. Thought to bring good luck by rangers!"
	icon_state = "frycabbit_garlick_cucumber"
	tastes = list("warm cabbit" = 1, "garlick" = 1, "cucumber" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/* .............  Garlicked Fried Volf   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick
	name = "garlick volf"
	desc = "A slab of volf, fried to a perfect medium rare. A bit gamey and chewy, but tasty. This piece has been coated over in glove of garlick."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "fryvolf_garlick"
	tastes = list("gamey volf" = 1, "garlick" = 1)

/* .............  Garlicked Fried Volf w/ Cucumber  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick/cucumber
	name = "hunter's feast"
	desc = "A slab of volf, fried to a perfect medium rare. A bit gamey and chewy, but tasty. This piece has been coated over in glove of garlick and served with side of cucumber."
	icon_state = "fryvolf_garlick_cucumber"
	tastes = list("gamey volf" = 1, "garlick" = 1, "cucumber" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/* .............  Honey glazed venison ribs  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs/cooked/glazed
	name = "forest glaze"
	desc = "A helping of venison ribs glazed to perfection in honey. The golden brown flesh is almost shiny enough for you to see your own reflection."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "ribs_glazed"
	tastes = list("sweet venison" = 1, "honey" = 1)
	faretype = FARE_FINE
	eat_effect = /datum/status_effect/buff/mealbuff

/* .............  Wine glazed venison loins  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins/cooked/sauced
	name = "forest bounty"
	desc = "Venison tenderloin cut into fine slices, covered in a mixture of berry paste and wine-glazing. The liqour seems to have caramelized into a tasty layer of glaze."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "loins_sauced"
	tastes = list("tender venison" = 1, "caramelized wine" = 1, "berry paste")
	faretype = FARE_LAVISH
	eat_effect = /datum/status_effect/buff/mealbuff

/* .............  Choice venison cut  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime/cooked/choice
	name = "forest trove"
	desc = "A choice cut of venison seared to perfection with a hint of pink flesh still visible."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "choice_cut"
	tastes = list("mellow venison" = 1, "garlyck" = 1, "onion" = 1)
	faretype = FARE_LAVISH
	eat_effect = /datum/status_effect/buff/mealbuff

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime/cooked/choice/butter
	name = "mellow forest trove"
	desc = "A choice cut of venison seared to perfection with a hint of pink flesh still visible. Drowned in a good slice of butter, as if it weren't soft enough before."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "choice_cut_b"
	tastes = list("mellow venison" = 1, "garlyck" = 1, "onion" = 1, "butter" = 1)
	faretype = FARE_LAVISH
	eat_effect = /datum/status_effect/buff/mealbuff
	rotprocess = null

/* .............  Deadite saiga cube  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_loins_z/cooked/cubed
	name = "carrion coulis"
	desc = "A gelatinous, ghoulish delight fashioned from wyrd loins. Poke it to see it shudder and wobble."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "saiga_d_jelly"
	// At last, proper supper
	faretype = FARE_NEUTRAL
	tastes = list("gelatin" = 1, "squishy meat" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff
	rotprocess = null
	cooked_smell = /datum/pollutant/food/strange_meat

/* .............  Deadite saiga rib crown  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs_z/cooked/crown
	name = "couronne de baies-noires"
	desc = "A crown fashioned from wyrd meat rib-bones, cooked to the point most of the juicy meat has sagged to the bottom. The meat-mash is dotted with countless jackberries down below."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "saiga_d_ribs"
	tastes = list("mashed meat" = 1, "jackberries" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff
	rotprocess = null
	cooked_smell = /datum/pollutant/food/strange_meat

/* .............  Deadite saiga roses  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_prime_z/cooked/roses
	name = "bouquet des trépassés"
	desc = "A strange dish of prime wyrd meat, sliced thin and assembled to look like roses. These are typically left on graves to commemorate someone. Otavan vampires make a habit out of trying to steal these off graves, for they desire the strange flesh."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "saiga_d_roses"
	tastes = list("thin sticky meat" = 1, "garlyck" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff
	faretype = FARE_FINE
	rotprocess = null
	cooked_smell = /datum/pollutant/food/strange_meat

/* .............  Deadite saiga wellington  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked/meatloaf
	name = "grave galette"
	desc = "A patchwork amalgamation of various meats, but primarily that of wyrd meat. It is a meatloaf, but you'd rather it didn't exist at all."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "d_bread6"
	tastes = list("crumbly squishy meatloaf" = 1, "ghoul" = 1, "grout and grime" = 1)
	// Safe to eat, not much else, though.
	eat_effect = null
	slices_num = 6
	bitesize = 7
	slice_batch = FALSE
	rotprocess = null
	slice_sound = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked/meatloaf_slice
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	cooked_smell = /datum/pollutant/food/strange_meat

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked/meatloaf/update_icon()
	if(slices_num)
		icon_state = "d_bread[slices_num]"
	else
		icon_state = "d_bread_slice"

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked/meatloaf/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 2)
			slices_num = 5
		if(bitecount == 3)
			slices_num = 4
		if(bitecount == 4)
			slices_num = 3
		if(bitecount == 5)
			slices_num = 2
		if(bitecount == 6)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/rogue/meat/saiga_z/cooked/meatloaf_slice
	name = "galette slice"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	desc = "A singular slice of a truly vile meatloaf fashioned out of deadite saiga flesh."
	icon_state = "d_bread_slice"
	bitesize = 2
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	eat_effect = null
	tastes = list("crumbly squishy meatloaf" = 1, "ghoul" = 1, "grout and grime" = 1)
	cooked_type = null
	fried_type = null
	cooked_smell = /datum/pollutant/food/strange_meat
