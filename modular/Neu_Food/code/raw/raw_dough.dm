// Dough, and variants thereof for usage in making various baked food items.
// Doesn't include raw variants of bread and others
/*	.................   Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/dough_base
	name = "unfinished dough"
	desc = "With a little more ambition, you will conquer."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi' // I know but we are following Raw as a pre-pender
	icon_state = "dough_base"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/dough
	name = "dough"
	desc = "The triumph of all bakers. Smother with butter, roll it flat with a rolling pin, speckle it with apples and raisins.. the possibilities are truly endless!"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "dough"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bread
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/*	.................   Flatdough  ................... */
/obj/item/reagent_containers/food/snacks/rogue/flatdough
	name = "flatdough"
	desc = "Flattened dough, bare for all to see. A sharp edge can prepare the lines for a sheet of crackerdough, while a smearing of tomatoes can set the stage for a peasant's feast."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "flatdough"
	slices_num = null
	slice_batch = FALSE
	slice_path = null
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/frybread
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/*	.................   Tomatoplate  ................... */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw
	name = "uncooked tomatoplate"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pizza_base"
	desc = "Flatdough with a healthy smearing of sauced tomatoes upon its surface. A sprinkling of fresh cheese should round it all out."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese
	name = "uncooked tomatoplate with cheese"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes - and sprinkling of fresh cheese - upon its surface. It is ready to be baked into a delicious tomatoplate, lest one wishes to further adorn it with sausages, fillets, onions, pears, or truffles."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/tomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

//

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_sausage
	name = "uncooked tomatoplate with sausages"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "sausage_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of sliced sausages upon its surface. It is ready to be baked into a deliciously rich tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_meat
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meattomatoplate
	foodtype = GRAIN | FRUIT | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_fish
	name = "uncooked tomatoplate with fishes"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "fish_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of filleted fishes upon its surface. It is ready to be baked into a deliciously oiled tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_fish
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fishtomatoplate
	foodtype = GRAIN | FRUIT | DAIRY | MEAT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_truffles
	name = "uncooked tomatoplate with truffles"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "truffle_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of rare truffles upon its surface. It is ready to be baked into a deliciously decadant tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_truffle
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/truffletomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_poisontruffles
	name = "uncooked tomatoplate with truffles"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "truffle_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of rare truffles upon its surface. It is ready to be baked into a deliciously decadant tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	list_reagents = list(/datum/reagent/berrypoison = 5)
	cooked_smell = /datum/pollutant/food/tomatoplate_truffle
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/poisontruffletomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_onion
	name = "uncooked tomatoplate with onions"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "onion_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of ringed onions upon its surface. It is ready to be baked into a deliciously earthsome tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_onion
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/oniontomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_pear
	name = "uncooked tomatoplate with pears"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pear_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of juicy pears upon its surface. It is ready to be baked into a deliciously creative tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_pear
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/peartomatoplate
	foodtype = GRAIN | FRUIT | DAIRY

/*	.................   Smalldough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/doughslice
	name = "smalldough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "doughslice"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bun
	cooked_smell = /datum/pollutant/food/bun
	w_class = WEIGHT_CLASS_NORMAL

/*	.................   Butterdough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/butterdough
	name = "butterdough"
	desc = "What is a triumph, to a legacy?"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough"
	color = "#feffc1"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bookbread
	cooked_smell = /datum/pollutant/food/bookbread
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

//

/obj/item/reagent_containers/food/snacks/rogue/pearbread_uncooked
	name = "pear-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_pear"
	desc = "A mound of pear-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pearbookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/plumbread_uncooked
	name = "plum-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_plum"
	desc = "A mound of plum-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/plumbookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/lemonbread_uncooked
	name = "lemon-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_lemon"
	desc = "A mound of lemon-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/lemonbookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/tangerinebread_uncooked
	name = "tangerine-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_tangerine"
	desc = "A mound of tangerine-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/blackberrybread_uncooked
	name = "blackberry-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_blackberry"
	desc = "A mound of blackberry-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/raspberrybread_uncooked
	name = "raspberry-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_raspberry"
	desc = "A mound of raspberry-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/jackberrybread_uncooked
	name = "jackberry-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_jacksberry"
	desc = "A mound of jacksberry-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/poisonberrybread_uncooked
	name = "jackberry-stuffed butterdough" //Like pies, these are Evil. Indistinguishable from traditional jackberried variants, until eaten.
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_jacksberry"
	desc = "A mound of jacksberry-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	list_reagents = list(/datum/reagent/berrypoison = 12)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/poisonberrybookbread
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/chocolatebread_uncooked
	name = "chocolate-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_chocolate"
	desc = "A mound of chocolate-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/chocolate_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread
	foodtype = GRAIN | DAIRY

/*	.................   Butterdough Piece   ................... */
/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	name = "butterdough piece"
	desc = "A slice of pedigree, to create lines of history."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdoughslice"
	color = "#feffc1"
	slices_num = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/frybread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pastry
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL

/*	.................   Muffindough Piece   ................... */
/obj/item/reagent_containers/food/snacks/rogue/muffindough
	name = "muffindough"
	desc = "It's muffin time!"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "muffindough"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin
	cooked_smell = /datum/pollutant/food/muffin
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/*	.................   Piedough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/piedough
	name = "piedough"
	desc = "The beginning of greater things to come."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "piedough"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	cooked_smell = /datum/pollutant/food/pie_base
	w_class = WEIGHT_CLASS_NORMAL

/*	.................   Strudel Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/strudeldough
	name = "strudeldough"
	desc = "An empty shell of a greatness to come."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "strudel_raw"
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/*	.................   Tartdough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/tartdough
	name = "dotted tartdough"
	desc = "A hollow bowl that has yet to show its fullest potential."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "dottart_base"
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_tangerine
	name = "uncooked dot tart with tangerines"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "tangerine_dottart_base"
	desc = "A hollow bowl of butterdough, filled with delicious tangerines. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/tangerine
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_plum
	name = "uncooked dot tart with plums"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "plum_dottart_base"
	desc = "A hollow bowl of butterdough, filled with homely plums. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/plum
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_blackberry
	name = "uncooked dot tart with blackberries"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "blackberry_dottart_base"
	desc = "A hollow bowl of butterdough, filled with sour blackberries. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/blackberry
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_raspberry
	name = "uncooked dot tart with raspberries"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "raspberry_dottart_base"
	desc = "A hollow bowl of butterdough, filled with tart raspberries. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/raspberry
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_strawberry
	name = "uncooked dot tart with strawberries"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "strawberry_dottart_base"
	desc = "A hollow bowl of butterdough, filled with sweet strawberries. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/strawberry
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_pear
	name = "uncooked dot tart with pears"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pear_dottart_base"
	desc = "A hollow bowl of butterdough, filled with honeyed pears. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/pear
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_apple
	name = "uncooked dot tart with apples"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "apple_dottart_base"
	desc = "A hollow bowl of butterdough, filled with apple slices. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/apple
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_goldapple
	name = "uncooked dot tart with ambrosia"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "gapple_dottart_base"
	desc = "A hollow bowl of butterdough, filled with a divine fruit. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/goldapple
	list_reagents = list(/datum/reagent/medicine/stronghealth = 6) //Because you're going to want something after vomiting up all your guts up for eating raw dough.
	foodtype = GRAIN | FRUIT

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_goldapple/Initialize()
  ..()
  add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_LIGHTNING, "alpha" = 100, "size" = 1))

/*	.................   Eggdough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/eggdough
	name = "eggdough"
	desc = "Without tradition, legacy is left solivagant."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "eggdough"
	color = "#feffc1"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/eggdoughslice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/challah
	cooked_smell = /datum/pollutant/food/bread
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/*	.................   Eggdough Piece   ................... */
/obj/item/reagent_containers/food/snacks/rogue/eggdoughslice
	name = "eggdough piece"
	desc = "A slice of childhood, to remember one's roots."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "eggdoughslice"
	color = "#feffc1"
	slices_num = 0
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL

/*	.................   Noodle Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/eggdoughnoodles
	dish_type = DISH_NOODLES
	cuisine = CUISINE_ETRUSCAN
	name = "uncooked noodles"
	desc = "A bundle of soft and wobbly uncooked noodles, ready to make dreams come true."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "eggdoughnoodle"
	color = "#feffc1"
	boiled_type = /obj/item/reagent_containers/food/snacks/rogue/noodles
	cooked_smell = /datum/pollutant/food/pasta
	w_class = WEIGHT_CLASS_NORMAL

/*	.................   Sheet Noodle Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/eggdoughsheetnoodles
	dish_type = DISH_NOODLES
	cuisine = CUISINE_ETRUSCAN
	name = "uncooked sheet noodles"
	desc = "Flat sheets of sheet noodles, ready to be mixed with sauce and/or cheese."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "eggdoughsheetnoodle"
	color = "#feffc1"
	slices_num = 0
	boiled_type = /obj/item/reagent_containers/food/snacks/rogue/sheetnoodles
	cooked_smell = /datum/pollutant/food/pasta
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/eggdoughsheetnoodles_red
	dish_type = DISH_NOODLES
	cuisine = CUISINE_ETRUSCAN
	name = "uncooked red lasagna"
	desc = "Flat sheets of sheet noodles smothered in tomato sauce, ready to be cooked in the oven or have cheese added."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "eggdoughsheetnoodle_red"
	color = "#feffc1"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/lasagna
	cooked_smell = /datum/pollutant/food/pasta
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/eggdoughsheetnoodles_white
	dish_type = DISH_NOODLES
	cuisine = CUISINE_ETRUSCAN
	name = "uncooked white lasagna"
	desc = "Flat sheets of sheet noodles smothered in cheese, Valorian style, ready to be cooked in the oven or have sauce added."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "eggdoughsheetnoodle_white"
	color = "#feffc1"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/lasagna_white
	cooked_smell = /datum/pollutant/food/pasta
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/eggdoughsheetnoodles_redwhite
	dish_type = DISH_NOODLES
	cuisine = CUISINE_ETRUSCAN
	name = "uncooked red and white lasagna"
	desc = "Flat sheets of sheet noodles smothered in cheese and sauce, Montecarinan style, ready to be cooked in the oven."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "eggdoughsheetnoodle_redwhite"
	color = "#feffc1"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/lasagna_redwhite
	cooked_smell = /datum/pollutant/food/pasta
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/eggdoughsheetnoodles_pesto
	dish_type = DISH_NOODLES
	cuisine = CUISINE_SOUTH_IMPERIAL
	name = "uncooked pesto lasagna"
	desc = "Flat sheets of sheet noodles spread with pesto, Azurian style, ready to be cooked in the oven."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "eggdoughsheetnoodle_pesto"
	color = "#feffc1"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/lasagna_pesto
	cooked_smell = /datum/pollutant/food/pasta
	w_class = WEIGHT_CLASS_NORMAL

/*	.................   Griddle Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/griddle_uncooked
	name = "griddle dough"
	desc = "A flat eggy mess of batter dough, desperate to be thrown onto a pan."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "griddle_uncooked"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/griddle
	w_class = WEIGHT_CLASS_NORMAL

