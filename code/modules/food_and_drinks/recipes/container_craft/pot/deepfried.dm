/datum/container_craft/cooking/deepfry
	abstract_type = /datum/container_craft/cooking/deepfry
	category = FOOD_CAT_DEEPFRIED
	eject_output = TRUE
	crafting_time = 5 SECONDS
	cook_method = COOK_DEEPFRY
	synthesize_recipes = TRUE
	reagent_requirements = list(
		/datum/reagent/consumable/oil/tallow = 5
	)

/datum/container_craft/cooking/deepfry/try_craft(obj/item/crafter, list/pathed_items, mob/initiator, datum/callback/on_craft_start, datum/callback/on_craft_failed)
	if(crafter.reagents?.has_reagent(/datum/reagent/water))
		return FALSE
	. = ..()

/datum/container_craft/cooking/deepfry/check_failure(obj/item/crafter, mob/user)
	if(crafter.reagents?.has_reagent(/datum/reagent/water))
		return TRUE
	return ..()

/datum/container_craft/cooking/deepfry/handoff
	abstract_type = /datum/container_craft/cooking/deepfry/handoff
	synthesize_recipes = FALSE
	handoff_craft = TRUE

/datum/container_craft/cooking/deepfry/marmalade
	name = "Marmalade"
	requirements = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine_sugared = 1)
	output = /obj/item/reagent_containers/food/snacks/marmalade

/datum/container_craft/cooking/deepfry/jamtallow
	name = "Blackberry Jam"
	requirements = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry_sugared = 1)
	output = /obj/item/reagent_containers/food/snacks/jamtallow

/datum/container_craft/cooking/deepfry/dragee
	name = "Dragee"
	requirements = list(/obj/item/reagent_containers/food/snacks/grown/nut_sugared = 1)
	output = /obj/item/reagent_containers/food/snacks/dragee

/datum/container_craft/cooking/deepfry/caramel
	name = "Caramel"
	requirements = list(/obj/item/reagent_containers/food/snacks/sugar = 1)
	output = /obj/item/reagent_containers/food/snacks/caramel

/datum/container_craft/cooking/deepfry/skysugarslab
	name = "Skysugar Slab"
	requirements = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry/skysugarbase = 1)
	output = /obj/item/reagent_containers/food/snacks/grown/skysugarslab
