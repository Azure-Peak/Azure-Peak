// Simple cooked meat from any animals.
// Only includes simple cooked meat instead of the meal.
// Try to order in the same order as raw meat file ok
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	eat_effect = null
	slices_num = 0
	name = "frysteak"
	desc = "A slab of beastflesh, fried to a perfect medium-rare"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "frysteak"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("warm steak" = 1)
	fried_type = null
	cooked_type = null
	smoked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/smoked
	eat_effect = null
	slices_num = 0
	name = "jerky bundle"
	desc = "Generic meats blessed by smoke for that rustic flavor, excellent for long travels"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "meat_smoked"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_NEUTRAL
	rotprocess = null
	tastes = list("smoky meat" = 1)
	fried_type = null
	cooked_type = null
	smoked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/smoked_z
	eat_effect = null
	slices_num = 0
	name = "foul jerky bundle"
	desc = "Harder than leather, devoid of soul. At least it seems to be purified to the point of being edible."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "meat_smoked_z"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	faretype = FARE_IMPOVERISHED
	rotprocess = null
	tastes = list("smoky meat" = 1)
	fried_type = null
	cooked_type = null
	smoked_type = null

/* .............	Roast Pork	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast
	cuisine = CUISINE_NORTHERN|CUISINE_SOUTHEASTERN
	eat_effect = null
	name = "roast pork"
	desc = "A hunk of pigflesh, roasted to a perfect crispy texture"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	faretype = FARE_FINE
	icon_state = "roastpork"
	tastes = list("crispy pork" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null
	smoked_type = null

/*	.............	Crispy bacon	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	eat_effect = null
	name = "fried bacon"
	desc = "A trufflepig's retirement plan."
	faretype = FARE_FINE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "friedbacon"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null
	smoked_type = null

/*	.............	Fryspider	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried
	name = "fried spidermeat"
	desc = "A spider leg, shaved and roasted."
	faretype = FARE_POOR
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "friedspider"
	eat_effect = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null
	smoked_type = null

/*	.................	Whole Chicken roast	................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	cuisine = CUISINE_NORTH_IMPERIAL
	desc = "A plump bird, roasted to a perfect temperature and bears a crispy skin."
	eat_effect = null
	slices_num = 0
	name = "roast bird"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "roastchicken"
	faretype = FARE_FINE
	portable = FALSE
	tastes = list("tasty birdmeat" = 1)
	cooked_type = null
	smoked_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_MEAL_AND_QUARTER)
	rotprocess = SHELFLIFE_DECENT

/*	.............	Frybird	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	cuisine = CUISINE_NORTHERN|CUISINE_SOUTHEASTERN
	eat_effect = null
	slices_num = 0
	name = "frybird"
	desc = "Poultry scorched to a perfect delicious crisp."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "frybird"
	faretype = FARE_FINE
	portable = FALSE
	fried_type = null
	smoked_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_DECENT

/* ............. Fried Crab ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried
	eat_effect = null
	slices_num = 0
	name = "fried crabmeat"
	faretype = FARE_NEUTRAL
	portable = FALSE
	desc = "A fried piece of crabmeat, yum."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "crabmeat"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	desc = ""
	fried_type = null
	cooked_type = null
	smoked_type = null

/* .............	Fried Cabbit	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	eat_effect = null
	slices_num = 0
	name = "fried cabbit"
	desc = "A slab of cabbit, fried to a perfect crispy texture."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "frycabbit"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)	//It's easier and cheaper than normal meat to find.
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("warm cabbit" = 1)
	fried_type = null
	cooked_type = null
	smoked_type = null

/* .............	Fried Volf	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/wolf/fried
	eat_effect = null
	slices_num = 0
	name = "fried volf"
	desc = "A slab of volf, fried to a perfect medium rare. A bit gamey and chewy, but tasty."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "fryvolf"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null
	smoked_type = null

/* .............	Fried Rous	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rat/fried
	eat_effect = null
	slices_num = 0
	name = "fried rous"
	desc = "A small, chewy chunk of rous meat. Certain races loves this, others... Not so much."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "rat"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null
	smoked_type = null

/* .............	Fried Bear	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/bear/fried
	eat_effect = null
	slices_num = 0
	bitesize = 4
	name = "T-bone bear steak"
	desc = "Real meat, for real men."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "bear"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null
	smoked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/bear/smoked
	eat_effect = null
	slices_num = 0
	bitesize = 4
	name = "Smoked bear slab"
	desc = "A slab of solid, smoked bear meat. A real warrior doesn't need anything else."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "bear_smoked"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_NEUTRAL
	rotprocess = null
	fried_type = null
	cooked_type = null
	smoked_type = null

/* .............	Fried Troll	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/troll/fried
	eat_effect = /datum/status_effect/debuff/uncookedfood
	slices_num = 0
	bitesize = 5
	name = "chewy troll blubber"
	desc = "Cooking it seems to have only caused the meat to toughen up. It is vile, disgusting, like partially hardened jello with greasy chunks hidden within. Perhaps it can be cooked further to stubbornly quell its spirit."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "troll"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	faretype = FARE_IMPOVERISHED
	rotprocess = SHELFLIFE_EXTREME
	fried_type = /obj/item/reagent_containers/food/snacks/fat
	cooked_type = /obj/item/reagent_containers/food/snacks/fat
	smoked_type = null
	// Takes a really long time unless you're a skilled cook.
	cooktime = 1500

/* .............	Seared Gnoll	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll/seared
	eat_effect = null
	slices_num = 0
	name = "seared gnoll"
	desc = "A disgusting sinewy mess of gnoll meat. Seems the muscle has only toughened after being seared."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "searedgnoll"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_EXTREME
	fried_type = null
	cooked_type = null
	smoked_type = null

/* .............	Fried Filet	................ */
// This is seafood but is one of the "simple cooked meat" so I put it here.
/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	eat_effect = null
	slices_num = 0
	name = "fryfilet"
	desc = "A slab of flaky fish, fried until falling apart."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "cooked_filet"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THIRD_MEAL)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("warm fish" = 1)
	fried_type = null
	cooked_type = null
	smoked_type = null

/* .............	Fried Salmon	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon/fried
	eat_effect = null
	slices_num = 0
	name = "fried salmon"
	desc = "A filet of flaky salmon, prized by Dendorites for its ability to dance upon river, sea, and your plate alike."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "salmon_cooked"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THIRD_MEAL)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("flaky salmon" = 1)
	fried_type = null
	cooked_type = null
	smoked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/fish/salmon/smoked
	eat_effect = null
	slices_num = 0
	name = "smoked salmon"
	desc = "A filet of smoked salmon, prized by Dendorites for its ability to dance upon river, sea, smoke, and your plate alike."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "salmon_smoked"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THIRD_MEAL)
	faretype = FARE_NEUTRAL
	rotprocess = null
	tastes = list("flaky salmon" = 1)
	fried_type = null
	cooked_type = null
	smoked_type = null

/* .............	Fried Shellfish	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	eat_effect = null
	slices_num = 0
	name = "fried shellfish"
	desc = "Fried shellfish meat. A bit salty, but delicious."
	faretype = FARE_NEUTRAL
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "shellfish_meat_cooked"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	fried_type = null
	cooked_type = null
	smoked_type = null

/*	.............	Sausage & Wiener	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	eat_effect = null
	name = "sausage"
	desc = "Delicious flesh stuffed in a intestine casing."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "wiener"
	faretype = FARE_NEUTRAL
	fried_type = null
	smoked_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	rotprocess = SHELFLIFE_EXTREME

/*	.............	Cooked Ham	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/ham/steamed
	name = "steamed ham"
	desc = "Salted cut of meat ready to be torn into further with a knife. You would be hard pressed to find this lacking in a pantry of anyone with modicum of wealth."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "ham5"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	bitesize = 6
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/ham_sliced
	faretype = FARE_POOR
	slices_num = 5
	slice_batch = FALSE
	rotprocess = null
	slice_sound = TRUE
	eat_effect = null
	tastes = list("hog" = 1)
	cooked_type = null
	fried_type = null
	smoked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/ham/smoked
	name = "smoked ham"
	desc = "An enormous piece of smoked ham. A crisp outer shell that demands to be cut into, to reveal the delicious pink flesh hidden beneath."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "ham_s6"
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	bitesize = 7
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/meat/ham_smoked_sliced
	faretype = FARE_NEUTRAL
	slices_num = 6
	slice_batch = FALSE
	rotprocess = null
	slice_sound = TRUE
	eat_effect = null
	tastes = list("smoky hog" = 1)
	cooked_type = null
	fried_type = null
	smoked_type = null

	// Funny
	possible_item_intents = list(/datum/intent/food, /datum/intent/mace/slap/pig)
	force = 15
	wdefense = 2.5
	associated_skill = /datum/skill/craft/cooking
	max_integrity = 75
	obj_integrity = 75

/obj/item/reagent_containers/food/snacks/rogue/meat/ham/steamed/update_icon()
	if(slices_num)
		icon_state = "ham[slices_num]"
	else
		icon_state = "ham_slice"

/obj/item/reagent_containers/food/snacks/rogue/meat/ham/smoked/update_icon()
	if(slices_num)
		icon_state = "ham_s[slices_num]"
	else
		icon_state = "ham_s_slice"

/obj/item/reagent_containers/food/snacks/rogue/meat/ham/steamed/On_Consume(mob/living/eater)
	..()
	if(slices_num)
		if(bitecount == 2)
			slices_num = 4
		if(bitecount == 3)
			slices_num = 3
		if(bitecount == 4)
			slices_num = 2
		if(bitecount == 5)
			changefood(slice_path, eater)

/obj/item/reagent_containers/food/snacks/rogue/meat/ham/smoked/On_Consume(mob/living/eater)
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

/obj/item/reagent_containers/food/snacks/rogue/meat/ham_sliced
	name = "sliced ham"
	desc = "A slice of steamed ham, inducer of happiness ever since the first humen steamed a ham."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "ham_slice"
	bitesize = 2
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	eat_effect = null
	tastes = list("hog" = 1)
	cooked_type = null
	fried_type = null
	smoked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/ham_smoked_sliced
	name = "sliced smoked ham"
	desc = "A slice of smoked ham. Usually, there's slightly more ham than can be eaten, owing to the majestic girth of the typical hog. They call this extra slice the Aasimar's slice"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "ham_s_slice"
	bitesize = 2
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	eat_effect = null
	rotprocess = null
	tastes = list("smoky hog" = 1)
	cooked_type = null
	fried_type = null
	smoked_type = null

/*	.............	Cooked Spidermeat	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/spider/meatball/cooked
	name = "fried spidermeatball"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "spidermeatball_cooked"
	bitesize = 3
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_HALF_MEAL)
	eat_effect = null
	tastes = list("crispy and slimy insectoid" = 1)
	smoked_type = null
	cooked_type = null
	fried_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/spider/surprise/cooked
	cuisine = CUISINE_NORTHERN
	name = "spider surprise"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "spider_surprise_cooked"
	bitesize = 4
	slices_num = FALSE
	slice_path = FALSE
	list_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_FULL_MEAL)
	eat_effect = null
	tastes = list("ridiculously raw texture but well-cooked insectoid" = 1)
	faretype = FARE_FINE
	smoked_type = null
	cooked_type = null
	fried_type = null

/*	.............	Cooked Mushroom	................ */
/obj/item/reagent_containers/food/snacks/rogue/mushroom/cooked
	slices_num = 0
	bitesize = 4
	name = "baked mushroom"
	desc = "Mushroom baked to perfection! It's tasty, but somehow you imagine it could taste even better if it was fried."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "mushroom"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_QUARTER_MEAL)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("mushroom" = 1)
	fried_type = null
	cooked_type = null
	smoked_type = null

/*	.............	Fried Mushroom	................ */
/obj/item/reagent_containers/food/snacks/rogue/mushroom/cooked/fried
	name = "grilled mushroom"
	desc = "Mushroom! It's grilled to perfection, a hardy snack adored by those of pale skin, and with pointy ears."
	icon_state = "mushroom_grill"
	// Slightly better than cooking it in an oven.
	bonus_reagents = list(/datum/reagent/consumable/nutriment = NUTRITION_THIRD_MEAL)
	tastes = list("mushroom grill" = 1)

/* .............	Fried Humanoid	................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/humanoid/fried
	eat_effect = null
	slices_num = 0
	name = "fried long pig"
	desc = "A forbidden taste for many, a delicacy for few."
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "longpig"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	// Only those with rawmeat eating will be fine eating this...
	eat_effect = /datum/status_effect/debuff/uncookedfood
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null
	smoked_type = null
