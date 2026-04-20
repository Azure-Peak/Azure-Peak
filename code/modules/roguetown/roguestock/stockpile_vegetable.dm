// Withdraw Price used to be designed to match export price.
// However this meant that food were often too expensive to buy as raw materials
// Now for food the withdraw price is set to be the same as the payout price
// Theoretically this does create a perverse incentive to export food instead of selling it locally
// But I live for the consequences of stewards deciding to neglect their local economy.
/datum/roguestock/stockpile/grain
	name = "Grain"
	desc = "Spelt grain."
	item_type = /obj/item/reagent_containers/food/snacks/grown/wheat
	held_items = list(0, 4)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	passive_generation = 3
	stockpile_limit = 50
	category = "Vegetable" //Not entirely accurate but it looks prettier in UI

/datum/roguestock/stockpile/oat
	name = "Oats"
	desc = "A cereal grain."
	item_type = /obj/item/reagent_containers/food/snacks/grown/oat
	held_items = list(0, 4)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	passive_generation = 3
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/rice
	name = "Rice"
	desc = "A grain used for cooking."
	item_type = /obj/item/reagent_containers/food/snacks/grown/rice
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Vegetable"

/datum/roguestock/stockpile/cabbage
	name = "Cabbage"
	desc = "A leafy vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/cabbage/rogue
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Vegetable"

/datum/roguestock/stockpile/potato
	name = "Potato"
	desc = "An interesting tuber."
	item_type = /obj/item/reagent_containers/food/snacks/grown/potato/rogue
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Vegetable"

/datum/roguestock/stockpile/onion
	name = "Onion"
	desc = "A bulb vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/onion/rogue
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Vegetable"

/datum/roguestock/stockpile/garlick
	name = "Garlick"
	desc = "A pungent root vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	held_items = list(0, 4)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	passive_generation = 3
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/turnip
	name = "Turnip"
	desc = "A hardy root vegetable suitable for soups. Favored by the poor"
	item_type = /obj/item/reagent_containers/food/snacks/grown/vegetable/turnip
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Vegetable"

/datum/roguestock/stockpile/carrot
	name = "Carrot"
	desc = "A long vegetable said to help with eyesight."
	item_type = /obj/item/reagent_containers/food/snacks/grown/carrot
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Vegetable"

/datum/roguestock/stockpile/cucumber
	name = "Cucumber"
	desc = "A refreshing, long and green vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/cucumber
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Vegetable"

/datum/roguestock/stockpile/eggplant
	name = "Eggplant"
	desc = "A large, purple vegetable with a mild taste."
	item_type = /obj/item/reagent_containers/food/snacks/grown/eggplant
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Vegetable"

/datum/roguestock/stockpile/sugar
	name = "Sugar"
	desc = "A sweet powder milled from sugarcane"
	item_type = /obj/item/reagent_containers/food/snacks/sugar

	held_items = list(0, 0)
	held_random_upper = 3
	held_random_lower = 1
	nothing_chance = 60
	export_only = TRUE

	payout_price = 4
	withdraw_price = 10
	transport_fee = 2
	export_price = 6
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 0
	category = "Vegetable"

/datum/roguestock/stockpile/coffee
	name = "Coffee Beans"
	desc = "The seed of the coffee plant, used to make a stimulating drink."
	item_type = /obj/item/reagent_containers/food/snacks/grown/coffeebeans
	held_items = list(0, 0)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Vegetable"

/datum/roguestock/stockpile/tea
	name = "Dried Tea Leaves"
	desc = "Dried tea leaves from the tea plant. Can be grounded and brewed to make tea."
	item_type = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	held_items = list(0, 0)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Vegetable"

/datum/roguestock/stockpile/poppy
	name = "Poppy"
	desc = "A seed with a sedative effect."
	item_type = /obj/item/reagent_containers/food/snacks/grown/rogue/poppy
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 4
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Vegetable"

/datum/roguestock/stockpile/rocknut
	name = "Rocknut"
	desc = "A nut with mild stimulant properties."
	item_type = /obj/item/reagent_containers/food/snacks/grown/nut

	held_items = list(0, 0)
	held_random_upper = 3
	held_random_lower = 1
	nothing_chance = 40
	export_only = TRUE

	payout_price = 2
	withdraw_price = 6
	transport_fee = 5
	export_price = 4
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 0
	category = "Vegetable"
