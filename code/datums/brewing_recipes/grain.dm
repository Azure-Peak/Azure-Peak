/datum/brewing_recipe/beer
	name = "Wheat Beer"
	category = "Grain"
	bottle_name = "wheat beer"
	bottle_desc = "A bottle of locally-brewed wheat beer. Has a light flavor. Staple of the west."
	reagent_to_brew = /datum/reagent/consumable/ethanol/beer
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 6)
	brewed_amount = 6
	brew_time = 2 MINUTES
	sell_value = 60

/datum/brewing_recipe/beer/oat
	name = "Oat Ale"
	bottle_name = "oat ale"
	bottle_desc = "A bottle of locally-brewed oat ale. Has a rich, hearty flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/ale
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/oat = 6)

/datum/brewing_recipe/beer/rice
	name = "Rice Wine"
	bottle_name = "rice wine"
	bottle_desc = "A bottle of locally-brewed rice wine. Has a sweet, umami flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/ricewine
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/rice = 6)
