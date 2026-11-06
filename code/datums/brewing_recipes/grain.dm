/datum/brewing_recipe/beer
	name = "Wheat Beer"
	category = "Grain"
	bottle_name = "wheat beer"
	bottle_desc = "A bottle of locally-brewed wheat beer. Has a light flavor. Staple of the west."
	reagent_to_brew = /datum/reagent/consumable/ethanol/beer
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/beer
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
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/beer_oat
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/oat = 6)

/datum/brewing_recipe/beer/rice
	name = "Rice Wine"
	bottle_name = "rice wine"
	bottle_desc = "A bottle of locally-brewed rice wine. Has a sweet, umami flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/ricewine
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/rice = 6)

/datum/brewing_recipe/maizewash
	name = "Maize Wash"
	category = "Other"
	bottle_name = "maize wash"
	bottle_desc = "A bottle of maize wash. Why did you bottle this? It's not even alcohol yet."
	reagent_to_brew = /datum/reagent/consumable/maizewash
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/powder/flour/cornmeal = 6)
	brewed_amount = 6
	brew_time = 2 MINUTES
	sell_value = 60

/datum/brewing_recipe/whiskey
	name = "Whiskey"
	category = "Liquor"
	bottle_name = "whiskey"
	bottle_desc = "A bottle of locally-distilled whiskey. Has a sweet, oakey flavor, with a kick."
	reagent_to_brew = /datum/reagent/consumable/ethanol/whiskey
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/whiskey
	pre_reqs = /datum/reagent/consumable/maizewash
	brewed_amount = 4
	brew_time = 4 MINUTES
	sell_value = 100
	heat_required = 380

/datum/brewing_recipe/fyreball
	name = "Fyreball Whiskey"
	category = "Liquor"
	bottle_name = "fyreball"
	bottle_desc = "A maniac's take on a spiced spirit. Where whiskey promises to keep your belly warm, Fyreball delivers."
	reagent_to_brew = /datum/reagent/consumable/ethanol/fyreball
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/fyreball
	pre_reqs = /datum/reagent/consumable/maizewash
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 4,
						/obj/item/reagent_containers/food/snacks/sugar = 1,
						/obj/item/reagent_containers/food/snacks/pumpkinspice = 1)
	brewed_amount = 4
	brew_time = 4 MINUTES
	sell_value = 150 // Requires legwork and a hint of danger to start off, as well as a distiller.
	heat_required = 380
