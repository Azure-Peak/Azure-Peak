/datum/brewing_recipe/fermentedcrab
	name = "Crab, Fermented"
	category = "Other"
	bottle_name = "fermented crab" // magical penis wine
	bottle_desc = "Fermented. Crab. One barrel of this triples the brothel's earnings for the week. A man thinks he's done, drinks a mouthful of this. Five minutes later he's back in the race."
	reagent_to_brew = /datum/reagent/fermented_crab
	output_bottle_type = /obj/item/reagent_containers/glass/bottle/brewing_bottle/fermentedcrab
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
	name = "Medicinal Fish Vinegar, Fermented"
	category = "Other"
	bottle_name = "medicinal fish vinegar"
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

/datum/brewing_recipe/zarum/bog
	name = "Medicinal Fish Honeygar, Fermented"
	category = "Other"
	bottle_name = "medicinal fish honeygar"
	bottle_desc = "A Terrorbog-learned variation of the classic medicinal fish vinegar. Spider's honey softens the vinegar's bite into a richer, sweeter savor while hastening fermentation. Easier to drink, yet harder to procure and mass produce for obvious reasons."
	reagent_to_brew = /datum/reagent/medicine/healthpot/zarum/bog
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish = 3,
		/obj/item/reagent_containers/food/snacks/rogue/honey/spider = 1,
		/obj/item/reagent_containers/powder/salt = 1,
		/obj/item/alch/calendula = 1,
	)
	brewed_amount = 3
	brew_time = 8 MINUTES
	sell_value = 100
