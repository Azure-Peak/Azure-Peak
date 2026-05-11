/datum/brewing_recipe/molasses
	name = "Molasses"
	category = "Other"
	bottle_name = "molasses"
	bottle_desc = "A bottle of molasses. A thick, dark syrup made from sugar."
	reagent_to_brew = /datum/reagent/consumable/sugar/molasses
	needed_items = list(/obj/item/reagent_containers/food/snacks/sugar = 6)
	brewed_amount = 6
	brew_time = 3 MINUTES
	sell_value = 60

/datum/brewing_recipe/rum
	name = "Rum"
	category = "Liquor"
	bottle_name = "rum"
	bottle_desc = "A bottle of locally-distilled rum. Has a sweet flavor with a hints of caramel and vanilla."
	reagent_to_brew = /datum/reagent/consumable/ethanol/rum
	pre_reqs = /datum/reagent/consumable/sugar/molasses
	brewed_amount = 4
	brew_time = 4 MINUTES
	sell_value = 100
	heat_required = 380
