/datum/container_craft/cooking/boil
	abstract_type = /datum/container_craft/cooking/boil
	category = FOOD_CAT_BOILED
	eject_output = TRUE
	crafting_time = 5 SECONDS
	reagent_requirements = list(
		/datum/reagent/water = 5
	)

/datum/container_craft/cooking/boil/noodles
	name = "Noodles"
	requirements = list(/obj/item/reagent_containers/food/snacks/rogue/eggdoughnoodles = 1)
	output = /obj/item/reagent_containers/food/snacks/rogue/noodles
	cooked_smell = /datum/pollutant/food/pasta

/datum/container_craft/cooking/boil/sheetnoodles
	name = "Sheet Noodles"
	requirements = list(/obj/item/reagent_containers/food/snacks/rogue/eggdoughsheetnoodles = 1)
	output = /obj/item/reagent_containers/food/snacks/rogue/sheetnoodles
	cooked_smell = /datum/pollutant/food/pasta
