/datum/food_recipe/cake
	abstract_type = /datum/food_recipe/cake
	book_category = FOOD_CAT_CAKES
	inline_ancestry = TRUE

/datum/food_recipe/cake/frosting
	name = "frosting"
	base_item = /obj/item/reagent_containers/food/snacks/butterslice
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/sugar
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frosting

// Cake Base + Frosting -> Frosted Cake Base (Raw)
/datum/food_recipe/cake/frosted_cake_base
	name = "frosted cake base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/frosting
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frostedcakeuncooked
	time_per_step = 3 SECONDS

// Cake Base + Cheese -> Cheesecake (Raw)
/datum/food_recipe/cake/cheesecake_base
	name = "cheesecake base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/cheese
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/ccakeuncooked
	time_per_step = 5 SECONDS

// Cake Base + Honey -> Honey Cake (Raw)
/datum/food_recipe/cake/honeycake_base
	name = "honey cake base"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake_base
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/honey
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/hcakeuncooked
	time_per_step = 5 SECONDS

// Cooked Cake + Frosting -> Frosted Cake (for those who forgot to frost first)
/datum/food_recipe/cake/frosted_cake_postbake
	name = "frosted cake (post-bake)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/cake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/frosting
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	time_per_step = 5 SECONDS

// Frosted Cake + Apple -> Apple Cake
/datum/food_recipe/cake/apple_cake
	name = "apple cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/apple
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/applecake
	time_per_step = 5 SECONDS

// Frosted Cake + Berries -> Berry Cake
/datum/food_recipe/cake/berry_cake
	name = "berry cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/berrycake
	time_per_step = 5 SECONDS

// Frosted Cake + Poison Berries -> Poison Berry Cake
/datum/food_recipe/cake/berry_cake_poison
	name = "poison berry cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/berrycake/poison
	time_per_step = 5 SECONDS

// Frosted Cake + Blackberry -> Blackberry Cake
/datum/food_recipe/cake/blackberry_cake
	name = "blackberry cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/blackberrycake
	time_per_step = 5 SECONDS

// Frosted Cake + Carrot -> Carrot Cake
/datum/food_recipe/cake/carrot_cake
	name = "carrot cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/carrotcake
	time_per_step = 5 SECONDS

// Frosted Cake + Raw Carrot -> Carrot Cake (alternative)
/datum/food_recipe/cake/carrot_cake_alt
	name = "carrot cake (raw carrot)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/carrot
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/carrotcake
	time_per_step = 5 SECONDS

// Frosted Cake + Lemon -> Lemon Cake
/datum/food_recipe/cake/lemon_cake
	name = "lemon cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lemon
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/lemoncake
	time_per_step = 5 SECONDS

// Frosted Cake + Lime -> Lime Cake
/datum/food_recipe/cake/lime_cake
	name = "lime cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lime
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/limecake
	time_per_step = 5 SECONDS

// Frosted Cake + Mentha -> Mentha Cake
/datum/food_recipe/cake/mentha_cake
	name = "mentha cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/alch/mentha
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/menthacake
	time_per_step = 5 SECONDS

// Frosted Cake + Peaceflower -> Peace Cake
/datum/food_recipe/cake/peace_cake
	name = "peace cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/clothing/head/peaceflower
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/peacecake
	time_per_step = 5 SECONDS

// Frosted Cake + Raspberry -> Raspberry Cake
/datum/food_recipe/cake/raspberry_cake
	name = "raspberry cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/raspberrycake
	time_per_step = 5 SECONDS

// Frosted Cake + Rocknut -> Rocknut Cake
/datum/food_recipe/cake/rocknut_cake
	name = "rocknut cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/nut
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/rocknutcake
	time_per_step = 5 SECONDS

// Frosted Cake + Strawberry -> Strawberry Cake
/datum/food_recipe/cake/strawberry_cake
	name = "strawberry cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/strawberrycake
	time_per_step = 5 SECONDS

// Frosted Cake + Tangerine -> Tangerine Cake
/datum/food_recipe/cake/tangerine_cake
	name = "tangerine cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/tangerinecake
	time_per_step = 5 SECONDS

// Apple Cake + Nut -> Applenut Cake
/datum/food_recipe/cake/applenut_cake
	name = "applenut cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/applecake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/nut
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/applenutcake
	time_per_step = 3 SECONDS

// Rocknut Cake + Apple -> Applenut Cake (alternative path)
/datum/food_recipe/cake/applenut_cake_alt
	name = "applenut cake (from rocknut)"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/rocknutcake
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/apple
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/applenutcake
	time_per_step = 3 SECONDS

/datum/food_recipe/cake/corncake
	name = "corn cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/corndough
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/rogue/egg
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/corncake_uncooked
	time_per_step = 3 SECONDS

/datum/food_recipe/cake/corncake_lemon
	name = "lemon corn cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/corncake_uncooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lemon
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/corncake_uncooked_lemon
	time_per_step = 3 SECONDS

/datum/food_recipe/cake/corncake_lime
	name = "lime corn cake"
	base_item = /obj/item/reagent_containers/food/snacks/rogue/corncake_uncooked
	ingredients = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/lime
	)
	result_type = /obj/item/reagent_containers/food/snacks/rogue/corncake_uncooked_lime
	time_per_step = 3 SECONDS
