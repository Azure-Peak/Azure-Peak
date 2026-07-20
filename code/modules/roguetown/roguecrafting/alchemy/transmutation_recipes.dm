/datum/transmutation_recipe/florid
	abstract_type = /datum/transmutation_recipe/florid
	name = "Base Florid Recipe"
	category = "Florid Transmutation"
	catalyst = /obj/item/alch/catalyst/florid

/datum/transmutation_recipe/florid/fiber_to_grain
	materia_aspects = list(/datum/materia_aspect/plant)
	input_items = list(/obj/item/natural/fibers = 4)
	output_items = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)

/datum/transmutation_recipe/florid/grain_to_fibers
	materia_aspects = list(/datum/materia_aspect/air)
	input_items = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)
	output_items = list(/obj/item/natural/fibers = 3)
