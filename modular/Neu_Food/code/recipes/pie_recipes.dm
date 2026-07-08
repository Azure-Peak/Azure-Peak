#define PIE_DMI 'modular/Neu_Food/icons/raw/raw_pies.dmi'
#define POT_PIE_FILLER list(\
	/obj/item/reagent_containers/food/snacks/rogue/cheddarwedge,\
	/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced,\
	/obj/item/reagent_containers/food/snacks/rogue/cheese,\
	/obj/item/reagent_containers/food/snacks/rogue/egg,\
	/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,\
	/obj/item/reagent_containers/food/snacks/rogue/meat/mince/poultry,\
	/obj/item/reagent_containers/food/snacks/fat\
)

/datum/food_recipe/pie
	abstract_type = /datum/food_recipe/pie
	book_category = FOOD_CAT_PIES
	base_item = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	cook_method = COOK_BAKE
	required_station = null
	inline_ancestry = TRUE

/datum/food_recipe/pie/bottom
	name = "pie bottom"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/piedough
	result_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom

/datum/food_recipe/pie/fish
	name = "fish pie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish,
		/obj/item/reagent_containers/food/snacks/rogue/piedough,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/fish
	result_smell = /datum/pollutant/food/fish_pie
	step_overlays = list(
		list(PIE_DMI, "fill_fish1"),
		list(PIE_DMI, "fill_fish2"),
		list(PIE_DMI, "fill_fish3"),
	)
	step_visuals = list(null, null, null, list(PIE_DMI, "fishpie_raw"))

/datum/food_recipe/pie/meat
	name = "meat pie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/beef,
		/obj/item/reagent_containers/food/snacks/rogue/piedough,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat
	result_smell = /datum/pollutant/food/meat_pie
	step_overlays = list(
		list(PIE_DMI, "fill_meat1"),
		list(PIE_DMI, "fill_meat2"),
		list(PIE_DMI, "fill_meat3"),
	)
	step_visuals = list(null, null, null, list(PIE_DMI, "meatpie_raw"))

/datum/food_recipe/pie/spider
	name = "spider pie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/spider,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/spider,
		/obj/item/reagent_containers/food/snacks/rogue/meat/mince/spider,
		/obj/item/reagent_containers/food/snacks/rogue/piedough,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/meat/spider
	result_smell = /datum/pollutant/food/spider_pie
	step_overlays = list(
		list(PIE_DMI, "fill_spider1"),
		list(PIE_DMI, "fill_spider2"),
		list(PIE_DMI, "fill_spider3"),
	)
	step_visuals = list(null, null, null, list(PIE_DMI, "spiderpie_raw"))
	restricted_message = "You lack knowledge of underdark delicacies!"
	hidden = TRUE

/datum/food_recipe/pie/spider/user_can_make(mob/user)
	return isdarkelf(user)

/datum/food_recipe/pie/pumpkin
	name = "pumpkin pie"
	ingredients = list(
		list(
			/obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced,
			/obj/item/reagent_containers/food/snacks/rogue/preserved/pumpkin_mashed,
		),
		/obj/item/reagent_containers/food/snacks/rogue/cheese,
		/obj/item/reagent_containers/food/snacks/rogue/egg,
		/obj/item/reagent_containers/food/snacks/sugar,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pumpkin
	result_smell = /datum/pollutant/food/pumpkin_pie
	step_overlays = list(
		list(PIE_DMI, "fill_pumpkin1"),
		list(PIE_DMI, "fill_pumpkin2"),
		list(PIE_DMI, "fill_pumpkin3"),
	)
	step_visuals = list(null, null, null, list(PIE_DMI, "pumpkinpie"))

/datum/food_recipe/pie/pot
	name = "pot pie"
	ingredients = list(
		POT_PIE_FILLER,
		POT_PIE_FILLER,
		POT_PIE_FILLER,
		/obj/item/reagent_containers/food/snacks/rogue/piedough,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/pot
	result_smell = /datum/pollutant/food/pot_pie
	step_overlays = list(
		list(PIE_DMI, "fill_pot1"),
		list(PIE_DMI, "fill_pot2"),
		list(PIE_DMI, "fill_pot3"),
	)
	step_visuals = list(null, null, null, list(PIE_DMI, "pieuncooked"))

/datum/food_recipe/pie/apple
	name = "apple pie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/rogue/piedough,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/apple
	result_smell = /datum/pollutant/food/apple_pie
	step_overlays = list(
		list(PIE_DMI, "fill_apple1"),
		list(PIE_DMI, "fill_apple2"),
		list(PIE_DMI, "fill_apple3"),
	)
	step_visuals = list(null, null, null, list(PIE_DMI, "pieuncooked"))

/datum/food_recipe/pie/berry
	name = "berry pie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/rogue/piedough,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/berry
	result_smell = /datum/pollutant/food/berry_pie
	step_overlays = list(
		list(PIE_DMI, "fill_berry1"),
		list(PIE_DMI, "fill_berry2"),
		list(PIE_DMI, "fill_berry3"),
	)
	step_visuals = list(null, null, null, list(PIE_DMI, "pieuncooked"))

/datum/food_recipe/pie/poisonberry
	name = "berry pie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/rogue/piedough,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/poison
	result_smell = /datum/pollutant/food/berry_pie
	step_overlays = list(
		list(PIE_DMI, "fill_berry1"),
		list(PIE_DMI, "fill_berry2"),
		list(PIE_DMI, "fill_berry3"),
	)
	step_visuals = list(null, null, null, list(PIE_DMI, "pieuncooked"))
	hidden = TRUE

/datum/food_recipe/pie/crab
	name = "crab pie"
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/crab,
		list(
			/obj/item/reagent_containers/food/snacks/rogue/meat/crab,
			/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced,
		),
		list(
			/obj/item/reagent_containers/food/snacks/rogue/meat/crab,
			/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced,
		),
		/obj/item/reagent_containers/food/snacks/rogue/piedough,
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/pie/cooked/crab
	result_smell = /datum/pollutant/food/crab_pie
	step_overlays = list(
		list(PIE_DMI, "fill_crab1"),
		list(PIE_DMI, "fill_crab2"),
		list(PIE_DMI, "fill_crab3"),
	)
	step_visuals = list(null, null, null, list(PIE_DMI, "pieuncooked"))

#undef PIE_DMI
#undef POT_PIE_FILLER
