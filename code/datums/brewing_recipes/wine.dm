/datum/brewing_recipe/jack_wine
	name = "Wine, Jackberry"
	category = "Fruit"
	bottle_name = "jackberry wine"
	bottle_desc = "A bottle of locally-brewed jackberry wine. Has a sweet, fruity flavor with a hint of tartness."
	reagent_to_brew = /datum/reagent/consumable/ethanol/jackberrywine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_crops = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 6)
	brewed_amount = 6
	brew_time = 5 MINUTES // Wine will have a standard brew time of 5 minutes
	sell_value = 60 //The sell value determines the price of the whole batch, and is divided by the amount of brewed bottles. Ergo, a value of 60 would be split into six bottles of 10c each.

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/jackberrywine/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/jackberrywine/delectable = 20 MINUTES
	)

/datum/brewing_recipe/plum_wine
	name = "Wine, Umeshu (Plum)"
	category = "Fruit"
	bottle_name = "umeshu wine"
	bottle_desc = "A bottle of locally-brewed plum wine. Has a sweet, slightly sour flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/plum_wine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/plum = 4, /obj/item/reagent_containers/food/snacks/sugar = 2)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 90 

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/plum_wine/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/plum_wine/delectable = 20 MINUTES
	)

/datum/brewing_recipe/tangerine_wine
	name = "Wine, Tangerine"
	category = "Fruit"
	bottle_name = "tangerine wine"
	bottle_desc = "A bottle of locally-brewed tangerine wine. Has a bittersweet, citrusy flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/tangerine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/tangerine = 4, /obj/item/reagent_containers/food/snacks/sugar = 2)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 90

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/tangerine/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/tangerine/delectable = 20 MINUTES
	)

/datum/brewing_recipe/raspberry_wine
	name = "Wine, Raspberry"
	category = "Fruit"
	bottle_name = "raspberry wine"
	bottle_desc = "A bottle of locally-brewed raspberry wine. Has a sweet, tart flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/raspberry
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/raspberry = 4, /obj/item/reagent_containers/food/snacks/sugar = 2)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 90

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/raspberry/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/raspberry/delectable = 20 MINUTES
	)

/datum/brewing_recipe/blackberry_wine
	name = "Wine, Blackberry"
	category = "Fruit"
	bottle_name = "blackberry wine"
	bottle_desc = "A bottle of locally-brewed blackberry wine. Has a bitter, tart flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/blackberry
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/blackberry = 4, /obj/item/reagent_containers/food/snacks/sugar = 2)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 90

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/blackberry/aged = 10 MINUTES,
		/datum/reagent/consumable/ethanol/blackberry/delectable = 20 MINUTES
	)

/datum/brewing_recipe/whipwine
	name = "Wine, Whip"
	category = "Other"
	bottle_name = "azurian whip-wine" // knockoff divine whip wine (magical penis wine)
	bottle_desc = "A bottle of locally-brewed Whipwine. Said to be based off a Kazengun recipe. It has a particularly... leathery flavor."
	reagent_to_brew = /datum/reagent/consumable/ethanol/whipwine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/alch/atropa = 1, /obj/item/reagent_containers/food/snacks/sugar = 1, /obj/item/alch/matricaria = 1,
						 /obj/item/alch/paris = 1, /obj/item/rogueweapon/whip = 1) // poisonous herbs, sugar, and an actual whip. the power of Mistranslations...
	brewed_amount = 4
	brew_time = 7 MINUTES
	sell_value = 160

/datum/brewing_recipe/luxintenebre
	name = "Wine, Lux"
	category = "Other"
	bottle_name = "luxintebere" // knockoff divine whip wine (magical penis wine)
	bottle_desc = "A potentially heretickal brew, Lux, when fermented, breaks down into Vitae, which can further ferment into a delectable wine."
	reagent_to_brew = /datum/reagent/consumable/ethanol/luxwine
	needed_reagents = list(/datum/reagent/water = 198) // standard
	needed_items = list(/obj/item/reagent_containers/lux_impure = 1, /obj/item/reagent_containers/food/snacks/sugar = 2,
						 /obj/item/alch/calendula = 1) // a single lux, sugar, and a healing herb. seems fair 2 me.
	brewed_amount = 2 // should make 2 bottles
	brew_time = 5 MINUTES
	sell_value = 200  // this shits heretical and has a high black market value - #Translates into 100c per bottle. Little devilish stuff, it is!

/datum/brewing_recipe/winespiced
	name = "Wine, Spiced"
	category = "Fruit"
	bottle_name = "spiced wine"
	bottle_desc = "A bottle of locally-brewed spiced jackberry wine. Traditionally reserved for the holidaes, it still remains deliciously rich and aromatic all yil-round. Championed as a remedy for childhood ailments and injuries, courtesy of dwarven mothers."
	reagent_to_brew = /datum/reagent/consumable/ethanol/spicedwine
	needed_reagents = list(/datum/reagent/water = 198)
	needed_crops = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2, /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine = 1,
						/obj/item/reagent_containers/food/snacks/sugar = 1, /obj/item/reagent_containers/food/snacks/pumpkinspice = 1, /obj/item/reagent_containers/food/snacks/grown/nut = 1)
	brewed_amount = 5
	brew_time = 5 MINUTES
	sell_value = 150 //Requires more time to fully age, and more materials to prepare than most non-luxwines. In exchange, it provides light healing and a very delicious taste.

	ages = TRUE
	age_times = list(
		/datum/reagent/consumable/ethanol/spicedwine/aged = 15 MINUTES,
		/datum/reagent/consumable/ethanol/spicedwine/delectable = 30 MINUTES
	)
