/datum/food_recipe/deepfried
	abstract_type = /datum/food_recipe/deepfried
	book_category = FOOD_CAT_DEEPFRIED
	cook_method = COOK_DEEPFRY
	required_station = null

/datum/food_recipe/deepfried/nitzel
	name = "nitzel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/nitzel
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/egg,
		/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel
	step_visuals = list(
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "nitzel_step2"),
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "nitzel_step3"),
	)

/datum/food_recipe/deepfried/schnitzel
	name = "schnitzel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/schnitzel
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/egg,
		/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/schnitzel
	step_visuals = list(
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "schnitzel_step2"),
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "schnitzel_step3"),
	)

/datum/food_recipe/deepfried/chickentender
	name = "tender frybird"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/chickentender
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/egg,
		/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/chickentender
	step_visuals = list(
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "chickentender_step2"),
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "chickentender_step3"),
	)

/datum/food_recipe/deepfried/wienernitzel
	name = "wiener nitzel"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/wienernitzel
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/egg,
		/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/wiener
	step_visuals = list(
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "wienernitzel_step2"),
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "wienernitzel_step3"),
	)

/datum/food_recipe/deepfried/squires_delight
	name = "squire's delight"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/squires_delight
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs
	)
	result_type = /obj/item/reagent_containers/food/snacks/squiresdelight
	step_visuals = list(
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "squiresdelight_step2"),
	)

/datum/food_recipe/deepfried/griddlewiener
	name = "griddlewiener"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/wienerstick
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/griddle_uncooked,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/meat/griddlewiener
	step_visuals = list(
		list('modular/Neu_Food/icons/raw/raw_deep_fried.dmi', "griddlewiener_step2"),
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
	name = "sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass

/datum/food_recipe/deepfried/sweetglass/raspberry
	name = "raspberried sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/raspberry
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/raspberry

/datum/food_recipe/deepfried/sweetglass/strawberry
	name = "strawberried sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/strawberry
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/strawberry

/datum/food_recipe/deepfried/sweetglass/blackberry
	name = "blackberried sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/blackberry
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/blackberry

/datum/food_recipe/deepfried/sweetglass/plum
	name = "plummic sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/plum
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/plum

/datum/food_recipe/deepfried/sweetglass/pear
	name = "peared sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/pear
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/pear

/datum/food_recipe/deepfried/sweetglass/tangerine
	name = "tangerine sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/tangerine
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/tangerine

/datum/food_recipe/deepfried/sweetglass/lemon
	name = "lemony sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/lemon
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lemon

/datum/food_recipe/deepfried/sweetglass/lime
	name = "limey sweetglass"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/raisins/lime
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raisins/sweetglass/lime

/datum/food_recipe/deepfried/toastcrumbs
	name = "toastcrumbs"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	result_type = /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs
	cook_method = null
	extra_steps = list("Grind it in a millstone")
