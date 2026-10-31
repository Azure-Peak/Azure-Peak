// Dough, and variants thereof for usage in making various baked food items.
// Doesn't include raw variants of bread and others
/*	.................	Dough	................... */
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

/*	.................	Flatdough	................... */
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

/*	.................	Tomatoplate	................... */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked tomatoplate"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pizza_base"
	desc = "Flatdough with a healthy smearing of sauced tomatoes upon its surface. A sprinkling of fresh cheese should round it all out."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_cheese
	dish_type = DISH_DAIRY|DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked tomatoplate with cheese"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes - and sprinkling of fresh cheese - upon its surface. It is ready to be baked into a delicious tomatoplate, lest one wishes to further adorn it with sausages, fillets, onions, pears, or truffles."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/tomatoplate

//

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_sausage
	dish_type = DISH_DAIRY|DISH_MEAT|DISH_FRUIT|DISH_VEGETABLE|DISH_POULTRY|DISH_SEAFOOD
	name = "uncooked tomatoplate with sausages"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "sausage_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of sliced sausages upon its surface. It is ready to be baked into a deliciously rich tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_meat
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/meattomatoplate

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_fish
	dish_type = DISH_DAIRY|DISH_SEAFOOD|DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked tomatoplate with fishes"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "fish_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of filleted fishes upon its surface. It is ready to be baked into a deliciously oiled tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_fish
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/fishtomatoplate

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_truffles
	dish_type = DISH_DAIRY|DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked tomatoplate with truffles"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "truffle_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of rare truffles upon its surface. It is ready to be baked into a deliciously decadent tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_truffle
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/truffletomatoplate

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_poisontruffles
	dish_type = DISH_DAIRY|DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked tomatoplate with truffles"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "truffle_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of rare truffles upon its surface. It is ready to be baked into a deliciously decadent tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	list_reagents = list(/datum/reagent/berrypoison = 5)
	cooked_smell = /datum/pollutant/food/tomatoplate_truffle
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/poisontruffletomatoplate

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_onion
	dish_type = DISH_DAIRY|DISH_VEGETABLE|DISH_FRUIT
	name = "uncooked tomatoplate with onions"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "onion_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of ringed onions upon its surface. It is ready to be baked into a deliciously earthsome tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_onion
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/oniontomatoplate

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tomatoplate_raw_pear
	dish_type = DISH_DAIRY|DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked tomatoplate with pears"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pear_pizza_uncooked"
	desc = "Flatdough with a healthy smearing of sauced tomatoes, a sprinkling of fresh cheese, and a dotting of juicy pears upon its surface. It is ready to be baked into a deliciously creative tomatoplate."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/tomatoplate_pear
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/peartomatoplate

/*	.................	Smalldough	................... */
/obj/item/reagent_containers/food/snacks/rogue/doughslice
	name = "smalldough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "doughslice"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bun
	cooked_smell = /datum/pollutant/food/bun
	w_class = WEIGHT_CLASS_NORMAL

/*	.................	Butterdough	................... */
/obj/item/reagent_containers/food/snacks/rogue/butterdough
	dish_type = DISH_DAIRY
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
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "pear-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_pear"
	desc = "A mound of pear-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pearbookbread

/obj/item/reagent_containers/food/snacks/rogue/plumbread_uncooked
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "plum-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_plum"
	desc = "A mound of plum-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/plumbookbread

/obj/item/reagent_containers/food/snacks/rogue/lemonbread_uncooked
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "lemon-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_lemon"
	desc = "A mound of lemon-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/lemonbookbread

/obj/item/reagent_containers/food/snacks/rogue/tangerinebread_uncooked
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "tangerine-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_tangerine"
	desc = "A mound of tangerine-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/tangerinebookbread

/obj/item/reagent_containers/food/snacks/rogue/blackberrybread_uncooked
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "blackberry-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_blackberry"
	desc = "A mound of blackberry-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/blackberrybookbread

/obj/item/reagent_containers/food/snacks/rogue/raspberrybread_uncooked
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "raspberry-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_raspberry"
	desc = "A mound of raspberry-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/raspberrybookbread

/obj/item/reagent_containers/food/snacks/rogue/jackberrybread_uncooked
	dish_type = DISH_DAIRY|DISH_FRUIT|DISH_VEGETABLE
	name = "jackberry-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_jacksberry"
	desc = "A mound of jacksberry-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/jackberrybookbread

/obj/item/reagent_containers/food/snacks/rogue/poisonberrybread_uncooked
	dish_type = DISH_DAIRY|DISH_FRUIT|DISH_VEGETABLE
	name = "jackberry-stuffed butterdough" //Like pies, these are Evil. Indistinguishable from traditional jackberried variants, until eaten.
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_jacksberry"
	desc = "A mound of jacksberry-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_bookbread
	list_reagents = list(/datum/reagent/berrypoison = 12)
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/poisonberrybookbread

/obj/item/reagent_containers/food/snacks/rogue/chocolatebread_uncooked
	dish_type = DISH_VEGETABLE
	name = "chocolate-stuffed butterdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough_chocolate"
	desc = "A mound of chocolate-speckled butterdough, yet to be elevated with the knowledge of an oven's warmth."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/chocolate_bookbread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/chocolatebookbread

/*	.................	Butterdough Piece	................... */
/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	dish_type = DISH_DAIRY
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

/*	.................	Muffindough Piece	................... */
/obj/item/reagent_containers/food/snacks/rogue/muffindough
	dish_type = DISH_DAIRY
	name = "muffindough"
	desc = "It's muffin time!"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "muffindough"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin
	cooked_smell = /datum/pollutant/food/muffin
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/*	.................	Piedough	................... */
/obj/item/reagent_containers/food/snacks/rogue/piedough
	dish_type = DISH_DAIRY
	name = "piedough"
	desc = "The beginning of greater things to come."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "piedough"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	cooked_smell = /datum/pollutant/food/pie_base
	w_class = WEIGHT_CLASS_NORMAL

/*	.................	Strudel Dough	................... */
/obj/item/reagent_containers/food/snacks/rogue/strudeldough
	dish_type = DISH_DAIRY
	name = "strudeldough"
	desc = "An empty shell of a greatness to come."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "strudel_raw"
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/*	.................	Tartdough	................... */
/obj/item/reagent_containers/food/snacks/rogue/tartdough
	dish_type = DISH_DAIRY
	name = "dotted tartdough"
	desc = "A hollow bowl that has yet to show its fullest potential."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "dottart_base"
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_tangerine
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked dot tart with tangerines"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "tangerine_dottart_base"
	desc = "A hollow bowl of butterdough, filled with delicious tangerines. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/tangerine

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_plum
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked dot tart with plums"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "plum_dottart_base"
	desc = "A hollow bowl of butterdough, filled with homely plums. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/plum

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_blackberry
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked dot tart with blackberries"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "blackberry_dottart_base"
	desc = "A hollow bowl of butterdough, filled with sour blackberries. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/blackberry

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_raspberry
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked dot tart with raspberries"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "raspberry_dottart_base"
	desc = "A hollow bowl of butterdough, filled with tart raspberries. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/raspberry

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_strawberry
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked dot tart with strawberries"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "strawberry_dottart_base"
	desc = "A hollow bowl of butterdough, filled with sweet strawberries. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/strawberry

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_pear
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked dot tart with pears"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "pear_dottart_base"
	desc = "A hollow bowl of butterdough, filled with honeyed pears. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/pear

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_apple
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked dot tart with apples"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "apple_dottart_base"
	desc = "A hollow bowl of butterdough, filled with apple slices. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/apple

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_goldapple
	dish_type = DISH_FRUIT|DISH_VEGETABLE
	name = "uncooked dot tart with ambrosia"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "gapple_dottart_base"
	desc = "A hollow bowl of butterdough, filled with a divine fruit. It merely needs a stint in the oven, now, to achieve its fullest potential."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fruity_dottart
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/dot_tart/goldapple
	list_reagents = list(/datum/reagent/medicine/stronghealth = 6) //Because you're going to want something after vomiting up all your guts up for eating raw dough.

/obj/item/reagent_containers/food/snacks/rogue/foodbase/tartdough_goldapple/Initialize(mapload)
	..()
	add_filter(FORCE_FILTER, 2, list("type" = "outline", "color" = GLOW_COLOR_LIGHTNING, "alpha" = 100, "size" = 1))

/*	.................	Eggdough	................... */
/obj/item/reagent_containers/food/snacks/rogue/eggdough
	dish_type = DISH_EGG
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

/*	.................	Eggdough Piece	................... */
/obj/item/reagent_containers/food/snacks/rogue/eggdoughslice
	dish_type = DISH_EGG
	name = "eggdough piece"
	desc = "A slice of childhood, to remember one's roots."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "eggdoughslice"
	color = "#feffc1"
	slices_num = 0
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL

/*	.................	Noodle Dough	................... */
/obj/item/reagent_containers/food/snacks/rogue/eggdoughnoodles
	dish_type = DISH_NOODLES|DISH_EGG
	cuisine = CUISINE_ETRUSCAN
	name = "uncooked noodles"
	desc = "A bundle of soft and wobbly uncooked noodles, ready to make dreams come true."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "eggdoughnoodle"
	color = "#feffc1"
	cooked_smell = /datum/pollutant/food/pasta
	w_class = WEIGHT_CLASS_NORMAL

/*	.................	Sheet Noodle Dough	................... */
/obj/item/reagent_containers/food/snacks/rogue/eggdoughsheetnoodles
	dish_type = DISH_NOODLES|DISH_EGG
	cuisine = CUISINE_ETRUSCAN
	name = "uncooked sheet noodles"
	desc = "Flat sheets of sheet noodles, ready to be mixed with sauce and/or cheese."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "eggdoughsheetnoodle"
	color = "#feffc1"
	slices_num = 0
	cooked_smell = /datum/pollutant/food/pasta
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/eggdoughsheetnoodles_red
	dish_type = DISH_NOODLES|DISH_EGG|DISH_FRUIT
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
	dish_type = DISH_NOODLES|DISH_DAIRY|DISH_EGG
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
	dish_type = DISH_NOODLES|DISH_DAIRY|DISH_EGG|DISH_FRUIT
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
	dish_type = DISH_NOODLES|DISH_EGG|DISH_VEGETABLE
	cuisine = CUISINE_SOUTH_IMPERIAL
	name = "uncooked pesto lasagna"
	desc = "Flat sheets of sheet noodles spread with pesto, Azurian style, ready to be cooked in the oven."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "eggdoughsheetnoodle_pesto"
	color = "#feffc1"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/lasagna_pesto
	cooked_smell = /datum/pollutant/food/pasta
	w_class = WEIGHT_CLASS_NORMAL

/*	.................	Griddle Dough	................... */
/obj/item/reagent_containers/food/snacks/rogue/griddle_uncooked
	dish_type = DISH_EGG
	name = "griddle dough"
	desc = "A flat eggy mess of batter dough, desperate to be thrown onto a pan."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "griddle_uncooked"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/griddle
	w_class = WEIGHT_CLASS_NORMAL

/*	.................	Dürümdough	................... */
/obj/item/reagent_containers/food/snacks/rogue/durumdough
	name = "dürümdough"
	desc = "Flattened enough to be almost as thin as a glass-pane, this dough needs a delicate hand to be handled - it will cook quickly."
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "durum"
	slices_num = null
	slice_batch = FALSE
	slice_path = null
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE
	tastes = list("raw, unleavened dough" = 1)
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/markook

/*	.................	Dürüm Variants (raw, filled)	................... */

// Dürümdough + Uncooked Bulgur
/obj/item/reagent_containers/food/snacks/rogue/foodbase/durum_bulgur
	dish_type = DISH_VEGETABLE
	name = "bulgur-stuffed dürümdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "durum_bulgur"
	desc = "The peasant's dürüm, yet unfinished. The epitome of hardy survival - or a vegetarian lyfestyle of some more stringent Yogis."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/bread
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/durum_bulgur

// Dürümdough + Poultry
/obj/item/reagent_containers/food/snacks/rogue/foodbase/durum_poultry
	dish_type = DISH_POULTRY|DISH_VEGETABLE
	name = "poultry-stuffed dürümdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "durum_poultry"
	desc = "A dürüm stuffed with delectable tender frybird. What shall we celebrate today, friend? It lacks some filling… Bulgur would lend itself well."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fried_meat

// Dürümdough + Poultry + Bulgur
/obj/item/reagent_containers/food/snacks/rogue/foodbase/durum_poultry_bulgur
	dish_type = DISH_POULTRY|DISH_VEGETABLE
	name = "poultry bulgur-stuffed dürümdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "durum_poultry_bulgur"
	desc = "A dürüm stuffed with delectable tender frybird. What shall we celebrate today, friend?"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fried_meat
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/durum_poultry_bulgur

// Dürümdough + Mince
/obj/item/reagent_containers/food/snacks/rogue/foodbase/durum_mince
	dish_type = DISH_MEAT|DISH_VEGETABLE
	name = "mince-stuffed dürümdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "durum_mince"
	desc = "Shaped and shaved flesh gristle and spices, surrounded by a starchy blanket. An ascension cannot be postponed indefinitely. This culinary alchemy requires still some filler… Cabbage or beans will suffice."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fried_meat

// Dürümdough + Cabbage
/obj/item/reagent_containers/food/snacks/rogue/foodbase/durum_cabbage
	dish_type = DISH_VEGETABLE
	name = "cabbage-stuffed dürümdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "durum_cabbage"
	desc = "leafy greenness, surrounded by a starchy blanket. An ascension cannot be postponed indefinitely. This culinary alchemy requires still some filler… minced meat will suffice."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fried_meat

// Dürümdough + Mince + Cabbage
/obj/item/reagent_containers/food/snacks/rogue/foodbase/durum_mince_cabbage
	dish_type = DISH_MEAT|DISH_VEGETABLE
	name = "mince cabbage-stuffed dürümdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "durum_mince_cabbage"
	desc = "Shaped and shaved flesh gristle and spices, surrounded by a starchy blanket. An ascension cannot be postponed indefinitely."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fried_meat
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/durum_mince_cabbage

// Dürümdough + Beans
/obj/item/reagent_containers/food/snacks/rogue/foodbase/durum_beans
	dish_type = DISH_VEGETABLE
	name = "bean-stuffed dürümdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "durum_beans"
	desc = "A humble set of red beans, surrounded by a starchy blanket. An ascension cannot be postponed indefinitely. This culinary alchemy requires still some filler… Cheese or mince will suffice."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/bread

// Dürümdough + Beans + Mince
/obj/item/reagent_containers/food/snacks/rogue/foodbase/durum_beans_mince
	dish_type = DISH_MEAT|DISH_VEGETABLE
	name = "bean mince-stuffed dürümdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "durum_mince_beans"
	desc = "Shaped and shaved flesh gristle and spices, surrounded by a starchy blanket. An ascension cannot be postponed indefinitely."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/fried_meat
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/durum_beans_mince

// Dürümdough + Cheese
/obj/item/reagent_containers/food/snacks/rogue/foodbase/durum_cheese
	dish_type = DISH_DAIRY|DISH_VEGETABLE
	name = "cheese-stuffed dürümdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "durum_cheese"
	desc = "A miracle of controlled rot, combined with the alchemy of starch. Now heat as a catalyst and it is complete. Or… Well, it still needs a filler. Beans?"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/pastry

// Dürümdough + Cheese + Beans
/obj/item/reagent_containers/food/snacks/rogue/foodbase/durum_cheese_beans
	dish_type = DISH_DAIRY|DISH_VEGETABLE
	name = "cheese bean-stuffed dürümdough"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "durum_cheese_beans"
	desc = "A miracle of controlled rot, combined with the alchemy of starch. Now heat as a catalyst and it is complete."
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	cooked_smell = /datum/pollutant/food/pastry
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/durum_cheese_beans
