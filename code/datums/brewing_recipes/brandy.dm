/datum/brewing_recipe/brandy
	name = "Brandy, Apple"
	category = "Liquor"
	bottle_name = "apple brandy"
	bottle_desc = "A bottle of locally-distilled apple brandy. Has a slight caramel flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy
	pre_reqs = /datum/reagent/consumable/ethanol/cider
	brewed_amount = 6
	brew_time = 4 MINUTES
	sell_value = 120
	heat_required = 360

/datum/brewing_recipe/brandy/pear
	name = "Brandy, Pear"
	bottle_name = "pear brandy"
	bottle_desc = "A bottle of locally-distilled pear brandy. Tastes of ripe pear, and a hint of spice."
	pre_reqs = /datum/reagent/consumable/ethanol/cider/pear
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy/pear

/datum/brewing_recipe/brandy/strawberry
	name = "Brandy, Strawberry"
	bottle_name = "strawberry brandy"
	bottle_desc = "A bottle of locally-distilled strawberry berry. Tastes of overwhelming sweetness with a smooth finish."
	pre_reqs = /datum/reagent/consumable/ethanol/cider/strawberry
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy/strawberry

/datum/brewing_recipe/brandy/tangerine
	name = "Brandy, Tangerine"
	bottle_name = "tangerine brandy"
	bottle_desc = "A bottle of locally-distilled tangerine brandy. Has a light, citrusty flavor with a hint of spice."
	pre_reqs = /datum/reagent/consumable/ethanol/tangerine
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy/tangerine

/datum/brewing_recipe/brandy/plum
	name = "Brandy, Plum"
	bottle_name = "plum brandy"
	bottle_desc = "A bottle of locally-distilled plum brandy. Has a sweet, vanilla flavor."
	pre_reqs = /datum/reagent/consumable/ethanol/plum_wine
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy/plum
