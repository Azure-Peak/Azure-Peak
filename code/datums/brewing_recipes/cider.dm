/datum/brewing_recipe/cider
	name = "Cider, Apple"
	category = "Fruit"
	bottle_name = "apple cider"
	bottle_desc = "A bottle of locally-brewed apple cider. Has a sweet, crispy apple flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/cider
	needed_reagents = list(/datum/reagent/water = 198)
	needed_crops = list(/obj/item/reagent_containers/food/snacks/grown/apple = 6)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 90

/datum/brewing_recipe/cider/pear
	name = "Cider, Pear"
	bottle_name = "pear cider"
	bottle_desc = "A bottle of locally-brewed pear cider. Has a sweet, subtle pear flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/cider/pear
	needed_crops = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear = 6)

/datum/brewing_recipe/cider/strawberry
	name = "Cider, Strawberry"
	bottle_name = "strawberry cider"
	bottle_desc = "A bottle of locally-brewed strawberry cider. Has a sweet, subtle strawberry flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/cider/strawberry
	needed_crops = list(/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry = 6)

/datum/brewing_recipe/cider/ambrosia
	name = "Cider, Ambrosia"
	category = "Fruit"
	bottle_name = "ambrosia"
	bottle_desc = "A bottle of cider, faintly glowing with a golden hue. It holds the distilled essence of a divine fruit, made ludicrously intense for even the heartiest drinkers."
	reagent_to_brew = /datum/reagent/consumable/ethanol/cider/ambrosia
	needed_reagents = list(/datum/reagent/water = 198)
	needed_crops = list(/obj/item/reagent_containers/food/snacks/grown/apple/gold = 1, /obj/item/reagent_containers/food/snacks/sugar = 5)
	brewed_amount = 2
	brew_time = 15 MINUTES
	sell_value = 200
