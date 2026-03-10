/datum/brewing_recipe/limoncello
	name = "Limoncello"
	category = "Liquor"
	bottle_name = "limoncello"
	bottle_desc = "A bottle of locally-distilled limoncello. Has a sweet, citrusy and burning flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/limoncello
	pre_reqs = /datum/reagent/consumable/ethanol/voddena
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 2, /obj/item/reagent_containers/food/snacks/sugar = 1)
	brewed_amount = 4
	brew_time = 4 MINUTES
	sell_value = 100
	heat_required = 360
