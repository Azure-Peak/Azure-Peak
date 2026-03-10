/datum/brewing_recipe/voddena
	name = "Voddena"
	category = "Grain"
	bottle_name = "voddena"
	bottle_desc = "A bottle of locally-brewed voddena. Brewed from potatoes. It has a clean flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/voddena
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced = 12)
	brewed_amount = 6
	brew_time = 5 MINUTES // Special. Vodden is a bit more time consuming
	sell_value = 120 // But also more expensive. Accounts for 20c per bottle.
