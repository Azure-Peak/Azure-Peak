/datum/crafting_recipe/roguetown/alchemy/fog_oil
	name = "fog lamptern oil (x5)"
	category = "Table"
	result = list(
		/obj/item/reagent_containers/glass/bottle/sanctified_oil,
		/obj/item/reagent_containers/glass/bottle/sanctified_oil,
		/obj/item/reagent_containers/glass/bottle/sanctified_oil,
		/obj/item/reagent_containers/glass/bottle/sanctified_oil,
		/obj/item/reagent_containers/glass/bottle/sanctified_oil,
	)
	reqs = list(
		/obj/item/reagent_containers/glass/bottle = 5,
		/obj/item/alch/golddust = 1,
		/obj/item/reagent_containers/lux = 1,
		/datum/reagent/water = 98
	)
	craftdiff = 2
	required_tech_node = "SANCTIFIED_LAMPTERNS"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/alchemy/fog_oil_simple
	name = "fog lamptern oil (x1)"
	category = "Table"
	result = list(
		/obj/item/reagent_containers/glass/bottle/sanctified_oil,
	)
	reqs = list(
		/obj/item/reagent_containers/glass/bottle = 5,
		/obj/item/alch/golddust = 1,
		/obj/item/reagent_containers/lux_impure = 1,
		/datum/reagent/water = 30
	)
	craftdiff = 2
	required_tech_node = "SANCTIFIED_LAMPTERNS"
	tech_unlocked = FALSE
