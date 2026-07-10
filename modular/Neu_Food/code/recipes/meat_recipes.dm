// Fried Steak + Pepper -> Pepper Steak
/datum/food_recipe/pepper_steak
	name = "pepper steak"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/peppersteak

// Fried Steak + Fried Onion -> Onion Steak
/datum/food_recipe/onion_steak
	name = "onion steak"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/onionsteak

// Fried Steak + Baked Carrot -> Carrot Steak
/datum/food_recipe/carrot_steak_meat
	name = "carrot steak"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/carrotsteak

// Fried Bacon + Wiener Egg -> Wiener Egg with Bacon
/datum/food_recipe/bacon_wiener_egg
	name = "wiener egg with bacon (from bacon)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon

// Fried Bacon + Fried Egg -> Bacon and Eggs
/datum/food_recipe/bacon_egg
	name = "bacon and eggs"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon

// Roast Bird + Pepper -> Spiced Bird-Roast
/datum/food_recipe/spiced_bird
	name = "spiced bird-roast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced

// Roast Bird + Butter -> Butter Bird-Roast
/datum/food_recipe/butter_bird
	name = "butter bird-roast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/butter
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter

// Roast Bird + Roast Bird -> Double Stacked Bird-Roast
/datum/food_recipe/double_bird
	name = "double stacked bird-roast"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/doublestacked

// Frybird + Baked Potato -> Frybird Tato
/datum/food_recipe/frybird_tato_meat
	name = "frybird tato"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frybirdtato

// Frybird + Fried Potato -> Frybird Tato (alt)
/datum/food_recipe/frybird_tato_meat_alt
	name = "frybird tato (alt)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frybirdtato

// Fried Cabbit + Garlic Clove -> Garlick Cabbit
/datum/food_recipe/garlick_cabbit
	name = "garlick cabbit"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick

// Fried Volf + Garlic Clove -> Garlick Volf
/datum/food_recipe/garlick_volf
	name = "garlick volf"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/wolf/fried
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/wolf/fried/garlick

// Fried Fish Filet + Pepper -> Pepper Fish
/datum/food_recipe/pepper_fish
	name = "pepper fish"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	ingredients = list(
		/datum/reagent/consumable/blackpepper = 1
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pepperfish

// Cooked Sausage + Fried Egg -> Wiener Egg
/datum/food_recipe/wiener_egg_sausage
	name = "wiener egg (from sausage)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/friedegg/fried
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage

/datum/food_recipe/nitzel
	name = "nitzel"
	base_item = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak,
		/obj/item/reagent_containers/food/snacks/rogue/meat/wolf,
		/obj/item/reagent_containers/food/snacks/rogue/meat/rat,
		/obj/item/reagent_containers/food/snacks/rogue/meat/bear,
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll,
		/obj/item/reagent_containers/food/snacks/rogue/meat/fatty,
		/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit,
		/obj/item/reagent_containers/food/snacks/rogue/meat/ham,
		/obj/item/reagent_containers/food/snacks/rogue/meat/ham/boar,
	)
	ingredients = list(/obj/item/kitchen/rollingpin = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel
	time_per_step = 3 SECONDS
	hidden = TRUE

/datum/food_recipe/schnitzel
	name = "schnitzel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/spider
	ingredients = list(/obj/item/kitchen/rollingpin = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel
	time_per_step = 3 SECONDS
	hidden = TRUE

/datum/food_recipe/chickentender
	name = "chicken tender"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet
	ingredients = list(/obj/item/kitchen/rollingpin = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender
	time_per_step = 3 SECONDS
	hidden = TRUE

/datum/food_recipe/wienernitzel
	name = "wiener nitzel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage
	ingredients = list(/obj/item/kitchen/rollingpin = COOKSTEP_TOOL)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/wienernitzel
	time_per_step = 3 SECONDS
	hidden = TRUE

/datum/food_recipe/sausage
	name = "sausage"
	base_item = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/rabbit,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/humanoid,
	)
	ingredients = list(
		list(
			/obj/item/reagent_containers/food/snacks/rogue/meat/mince,
			/obj/item/reagent_containers/food/snacks/fat,
		)
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage
	time_per_step = 3 SECONDS
	book_category = FOOD_CAT_BASICS

/datum/food_recipe/tartar
	name = "tartar"
	base_item = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/rabbit,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry,
	)
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/egg
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/tartar
	time_per_step = 3 SECONDS

/datum/food_recipe/spider_meatball
	name = "spider meatball"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/spider
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/spider
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/spider/meatball
	time_per_step = 3 SECONDS
	restricted_message = "You lack knowledge of underdark delicacies!"

/datum/food_recipe/spider_meatball/user_can_make(mob/user)
	return isdarkelf(user)

/datum/food_recipe/spider_surprise
	name = "spider surprise"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/spider
	ingredients = list(
		/obj/item/reagent_containers/powder/flour
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/spider/surprise
	restricted_message = "You lack knowledge of underdark delicacies!"

/datum/food_recipe/spider_surprise/user_can_make(mob/user)
	return isdarkelf(user)

/datum/food_recipe/crabcake
	name = "crab cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/crab
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/crabcakeraw

/datum/food_recipe/wienerstick
	name = "wiener stick"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	ingredients = list(
		/obj/item/grown/log/tree/stake
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/wienerstick

/datum/food_recipe/humanoid_salted
	name = "salted long pig mince"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/humanoid
	ingredients = list(
		/obj/item/reagent_containers/powder/coarse_salt
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/humanoid_salted
