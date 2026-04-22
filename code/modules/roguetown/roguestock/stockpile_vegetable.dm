// Withdraw Price used to be designed to match export price.
// However this meant that food were often too expensive to buy as raw materials
// Now for food the withdraw price is set to be the same as the payout price
// Theoretically this does create a perverse incentive to export food instead of selling it locally
// But I live for the consequences of stewards deciding to neglect their local economy.
/datum/roguestock/stockpile/grain
	name = "Grain"
	desc = "Spelt grain."
	item_type = /obj/item/reagent_containers/food/snacks/grown/wheat
	trade_good_id = TRADE_GOOD_GRAIN
	payout_price = 2
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable" //Not entirely accurate but it looks prettier in UI

/datum/roguestock/stockpile/oat
	name = "Oats"
	desc = "A cereal grain."
	item_type = /obj/item/reagent_containers/food/snacks/grown/oat
	trade_good_id = TRADE_GOOD_OATS
	payout_price = 2
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/rice
	name = "Rice"
	desc = "A grain used for cooking."
	item_type = /obj/item/reagent_containers/food/snacks/grown/rice
	trade_good_id = TRADE_GOOD_RICE
	payout_price = 2
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/cabbage
	name = "Cabbage"
	desc = "A leafy vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/cabbage/rogue
	trade_good_id = TRADE_GOOD_CABBAGE
	payout_price = 2
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/potato
	name = "Potato"
	desc = "An interesting tuber."
	item_type = /obj/item/reagent_containers/food/snacks/grown/potato/rogue
	trade_good_id = TRADE_GOOD_POTATO
	payout_price = 2
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/onion
	name = "Onion"
	desc = "A bulb vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/onion/rogue
	trade_good_id = TRADE_GOOD_ONION
	payout_price = 2
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/garlick
	name = "Garlick"
	desc = "A pungent root vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	trade_good_id = TRADE_GOOD_GARLICK
	payout_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/turnip
	name = "Turnip"
	desc = "A hardy root vegetable suitable for soups. Favored by the poor"
	item_type = /obj/item/reagent_containers/food/snacks/grown/vegetable/turnip
	trade_good_id = TRADE_GOOD_TURNIP
	payout_price = 2
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/carrot
	name = "Carrot"
	desc = "A long vegetable said to help with eyesight."
	item_type = /obj/item/reagent_containers/food/snacks/grown/carrot
	trade_good_id = TRADE_GOOD_CARROT
	payout_price = 2
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/cucumber
	name = "Cucumber"
	desc = "A refreshing, long and green vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/cucumber
	trade_good_id = TRADE_GOOD_CUCUMBER
	payout_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/eggplant
	name = "Eggplant"
	desc = "A large, purple vegetable with a mild taste."
	item_type = /obj/item/reagent_containers/food/snacks/grown/eggplant
	trade_good_id = TRADE_GOOD_EGGPLANT
	payout_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/sugar
	name = "Sugar"
	desc = "A sweet powder milled from sugarcane"
	item_type = /obj/item/reagent_containers/food/snacks/sugar
	trade_good_id = TRADE_GOOD_SUGAR

	export_only = TRUE

	payout_price = 5
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/coffee
	name = "Coffee Beans"
	desc = "The seed of the coffee plant, used to make a stimulating drink."
	item_type = /obj/item/reagent_containers/food/snacks/grown/coffeebeans
	trade_good_id = TRADE_GOOD_COFFEE
	payout_price = 5
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/tea
	name = "Dried Tea Leaves"
	desc = "Dried tea leaves from the tea plant. Can be grounded and brewed to make tea."
	item_type = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	trade_good_id = TRADE_GOOD_TEA
	payout_price = 5
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/poppy
	name = "Poppy"
	desc = "A seed with a sedative effect."
	item_type = /obj/item/reagent_containers/food/snacks/grown/rogue/poppy
	trade_good_id = TRADE_GOOD_POPPY
	payout_price = 2
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"

/datum/roguestock/stockpile/rocknut
	name = "Rocknut"
	desc = "A nut with mild stimulant properties."
	item_type = /obj/item/reagent_containers/food/snacks/grown/nut
	trade_good_id = TRADE_GOOD_ROCKNUT

	export_only = TRUE

	payout_price = 4
	importexport_amt = 10
	stockpile_limit = 50
	category = "Vegetable"
