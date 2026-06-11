/datum/food_recipe/deepfried
	abstract_type = /datum/food_recipe/deepfried
	book_category = FOOD_CAT_DEEPFRIED
	cook_method = COOK_DEEPFRY
	required_station = null

/datum/food_recipe/deepfried/nitzel
	name = "Nitzel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel
	step_visuals = list(
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "nitzel_step2"),
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "nitzel_step3"),
	)

/datum/food_recipe/deepfried/schnitzel
	name = "Schnitzel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/schnitzel
	step_visuals = list(
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "schnitzel_step2"),
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "schnitzel_step3"),
	)

/datum/food_recipe/deepfried/chickentender
	name = "Tender Frybird"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/chickentender
	step_visuals = list(
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "chickentender_step2"),
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "chickentender_step3"),
	)

/datum/food_recipe/deepfried/wienernitzel
	name = "Wiener Nitzel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/wienernitzel
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/egg,
		/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/wiener
	step_visuals = list(
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "wienernitzel_step2"),
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "wienernitzel_step3"),
	)

/datum/food_recipe/deepfried/squires_delight
	name = "Squire's Delight"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs
	)
	result_type = /obj/item/reagent_containers/food/snacks/squiresdelight
	step_visuals = list(
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "squiresdelight_step2"),
	)

/datum/food_recipe/deepfried/sweetglass
	abstract_type = /datum/food_recipe/deepfried/sweetglass
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/honey
	)
	step_visuals = list(
		list('icons/roguetown/items/produce.dmi', "honeyraisins"),
	)

/datum/food_recipe/deepfried/sweetglass/jackberry
	name = "Sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass

/datum/food_recipe/deepfried/sweetglass/raspberry
	name = "Raspberried Sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/raspberry

/datum/food_recipe/deepfried/sweetglass/strawberry
	name = "Strawberried Sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/strawberry

/datum/food_recipe/deepfried/sweetglass/blackberry
	name = "Blackberried Sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/blackberry

/datum/food_recipe/deepfried/sweetglass/plum
	name = "Plummic Sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/plum
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/plum

/datum/food_recipe/deepfried/sweetglass/pear
	name = "Peared Sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/pear
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/pear

/datum/food_recipe/deepfried/sweetglass/tangerine
	name = "Tangerine Sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/tangerine

/datum/food_recipe/deepfried/sweetglass/lemon
	name = "Lemony Sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/lemon
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lemon

/datum/food_recipe/deepfried/sweetglass/lime
	name = "Limey Sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/lime
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lime

/datum/food_recipe/deepfried/marmalade
	name = "Marmalade"
	base_item = /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine_sugared
	result_type = /obj/item/reagent_containers/food/snacks/marmalade

/datum/food_recipe/deepfried/jamtallow
	name = "Jamtallow"
	base_item = /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry_sugared
	result_type = /obj/item/reagent_containers/food/snacks/jamtallow

/datum/food_recipe/deepfried/dragee
	name = "Dragee"
	base_item = /obj/item/reagent_containers/food/snacks/grown/nut_sugared
	result_type = /obj/item/reagent_containers/food/snacks/dragee

/datum/food_recipe/deepfried/caramel
	name = "Caramel"
	base_item = /obj/item/reagent_containers/food/snacks/sugar
	result_type = /obj/item/reagent_containers/food/snacks/caramel

/datum/food_recipe/deepfried/skysugar
	name = "Skysugar Slab"
	base_item = /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry/skysugarbase
	result_type = /obj/item/reagent_containers/food/snacks/grown/skysugarslab
