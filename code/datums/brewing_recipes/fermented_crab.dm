/datum/brewing_recipe/fermentedcrab
	name = "Crab, Fermented"
	category = "Other"
	bottle_name = "fermented crab" // magical penis wine
	bottle_desc = "Fermented. Crab. One barrel of this triples the brothel's earnings for the week. A man thinks he's done, drinks a mouthful of this. Five minutes later he's back in the race."
	reagent_to_brew = /datum/reagent/fermented_crab
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 2, 
		/obj/item/reagent_containers/food/snacks/sugar = 2,
		/obj/item/alch/viscera = 1,
		/obj/item/alch/valeriana = 1,
	)
	brewed_amount = 2
	brew_time = 7 MINUTES
	sell_value = 100 //The sell value determines the price of the whole batch, and is divided by the amount of brewed bottles. Ergo, a value of 100c would be split into two bottles of 50c each.

/datum/brewing_recipe/zarum
	name = "Medicinal Fish Vinegear, Fermented"
	category = "Other"
	bottle_name = "medicinal fish vinegear"
	bottle_desc = "Overpoweringly fishy, yet imbued with alchemical mirth. An ancient predecessor to refined lifeblood, more commonly diluted in the modern dae for use as a savory sauce. (Un)fortuantely, this batch isn't destinted for dilution."
	reagent_to_brew = /datum/reagent/medicine/healthpot/zarum
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish = 3, 
		/obj/item/reagent_containers/food/snacks/sugar = 1,
		/obj/item/reagent_containers/powder/salt = 1,
		/obj/item/alch/calendula = 1,
	)
	brewed_amount = 2
	brew_time = 15 MINUTES
	sell_value = 100 //Ditto. 
