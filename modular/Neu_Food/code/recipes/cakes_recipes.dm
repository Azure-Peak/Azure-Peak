// Cake Base + Frosting -> Frosted Cake Base (Raw)
/datum/food_recipe/frosted_cake_base
	name = "Frosted Cake Base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/frosting
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frostedcakeuncooked
	time_per_step = 3 SECONDS

// Cake Base + Cheese -> Cheesecake (Raw)
/datum/food_recipe/cheesecake_base
	name = "Cheesecake Base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheese
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ccakeuncooked
	time_per_step = 5 SECONDS

// Cake Base + Honey -> Honey Cake (Raw)
/datum/food_recipe/honeycake_base
	name = "Honey Cake Base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/honey
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/hcakeuncooked
	time_per_step = 5 SECONDS

// Cooked Cake + Frosting -> Frosted Cake (for those who forgot to frost first)
/datum/food_recipe/frosted_cake_postbake
	name = "Frosted Cake (Post-Bake)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/frosting
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	time_per_step = 5 SECONDS

// Frosted Cake + Apple -> Apple Cake
/datum/food_recipe/apple_cake
	name = "Apple Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/apple
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/applecake
	time_per_step = 5 SECONDS

// Frosted Cake + Berries -> Berry Cake
/datum/food_recipe/berry_cake
	name = "Berry Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/berrycake
	time_per_step = 5 SECONDS

// Frosted Cake + Poison Berries -> Poison Berry Cake
/datum/food_recipe/berry_cake_poison
	name = "Poison Berry Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/berrycake/poison
	time_per_step = 5 SECONDS

// Frosted Cake + Blackberry -> Blackberry Cake
/datum/food_recipe/blackberry_cake
	name = "Blackberry Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/blackberrycake
	time_per_step = 5 SECONDS

// Frosted Cake + Carrot -> Carrot Cake
/datum/food_recipe/carrot_cake
	name = "Carrot Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/carrotcake
	time_per_step = 5 SECONDS

// Frosted Cake + Raw Carrot -> Carrot Cake (alternative)
/datum/food_recipe/carrot_cake_alt
	name = "Carrot Cake (Raw Carrot)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/carrot
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/carrotcake
	time_per_step = 5 SECONDS

// Frosted Cake + Lemon -> Lemon Cake
/datum/food_recipe/lemon_cake
	name = "Lemon Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lemon
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/lemoncake
	time_per_step = 5 SECONDS

// Frosted Cake + Lime -> Lime Cake
/datum/food_recipe/lime_cake
	name = "Lime Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lime
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/limecake
	time_per_step = 5 SECONDS

// Frosted Cake + Mentha -> Mentha Cake
/datum/food_recipe/mentha_cake
	name = "Mentha Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/alch/mentha
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/menthacake
	time_per_step = 5 SECONDS

// Frosted Cake + Peaceflower -> Peace Cake
/datum/food_recipe/peace_cake
	name = "Peace Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/clothing/head/peaceflower
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/peacecake
	time_per_step = 5 SECONDS

// Frosted Cake + Raspberry -> Raspberry Cake
/datum/food_recipe/raspberry_cake
	name = "Raspberry Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raspberrycake
	time_per_step = 5 SECONDS

// Frosted Cake + Rocknut -> Rocknut Cake
/datum/food_recipe/rocknut_cake
	name = "Rocknut Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/nut
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/rocknutcake
	time_per_step = 5 SECONDS

// Frosted Cake + Strawberry -> Strawberry Cake
/datum/food_recipe/strawberry_cake
	name = "Strawberry Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/strawberrycake
	time_per_step = 5 SECONDS

// Frosted Cake + Tangerine -> Tangerine Cake
/datum/food_recipe/tangerine_cake
	name = "Tangerine Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/tangerinecake
	time_per_step = 5 SECONDS

// Apple Cake + Nut -> Applenut Cake
/datum/food_recipe/applenut_cake
	name = "Applenut Cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/applecake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/nut
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/applenutcake
	time_per_step = 3 SECONDS

// Rocknut Cake + Apple -> Applenut Cake (alternative path)
/datum/food_recipe/applenut_cake_alt
	name = "Applenut Cake (from Rocknut)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/rocknutcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/apple
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/applenutcake
	time_per_step = 3 SECONDS
