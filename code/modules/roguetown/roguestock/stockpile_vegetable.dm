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
	category = "Vegetable" //Not entirely accurate but it looks prettier in UI

/datum/roguestock/stockpile/oat
	market_target = MARKET_TARGET_STAPLE
	name = "Oats"
	desc = "A cereal grain."
	item_type = /obj/item/reagent_containers/food/snacks/grown/oat
	trade_good_id = TRADE_GOOD_OATS
	category = "Vegetable"

/datum/roguestock/stockpile/rice
	market_target = MARKET_TARGET_STAPLE
	name = "Rice"
	desc = "A grain used for cooking."
	item_type = /obj/item/reagent_containers/food/snacks/grown/rice
	trade_good_id = TRADE_GOOD_RICE
	category = "Vegetable"

/datum/roguestock/stockpile/maize
	market_target = MARKET_TARGET_STAPLE
	name = "Maize"
	desc = "Cob of maize."
	item_type = /obj/item/reagent_containers/food/snacks/grown/maize
	trade_good_id = TRADE_GOOD_MAIZE
	category = "Vegetable"

/datum/roguestock/stockpile/mushroom
	market_target = MARKET_TARGET_LOW
	name = "Mushroom"
	desc = "A fungus that goes well in soups or grilled."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/mushroom
	trade_good_id = TRADE_GOOD_MUSHROOM
	category = "Vegetable"

/datum/roguestock/stockpile/cabbage
	market_target = MARKET_TARGET_LOW
	name = "Cabbage"
	desc = "A leafy vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/cabbage/rogue
	trade_good_id = TRADE_GOOD_CABBAGE
	category = "Vegetable"

/datum/roguestock/stockpile/potato
	market_target = MARKET_TARGET_STAPLE
	name = "Potato"
	desc = "An interesting tuber."
	item_type = /obj/item/reagent_containers/food/snacks/grown/potato/rogue
	trade_good_id = TRADE_GOOD_POTATO
	category = "Vegetable"

/datum/roguestock/stockpile/onion
	market_target = MARKET_TARGET_LOW
	name = "Onion"
	desc = "A bulb vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/onion/rogue
	trade_good_id = TRADE_GOOD_ONION
	category = "Vegetable"

/datum/roguestock/stockpile/garlick
	market_target = MARKET_TARGET_LOW
	name = "Garlick"
	desc = "A pungent root vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	trade_good_id = TRADE_GOOD_GARLICK
	category = "Vegetable"

/datum/roguestock/stockpile/turnip
	market_target = MARKET_TARGET_LOW
	name = "Turnip"
	desc = "A hardy root vegetable suitable for soups. Favored by the poor."
	item_type = /obj/item/reagent_containers/food/snacks/grown/vegetable/turnip
	trade_good_id = TRADE_GOOD_TURNIP
	category = "Vegetable"

/datum/roguestock/stockpile/carrot
	market_target = MARKET_TARGET_LOW
	name = "Carrot"
	desc = "A long vegetable said to help with eyesight."
	item_type = /obj/item/reagent_containers/food/snacks/grown/carrot
	trade_good_id = TRADE_GOOD_CARROT
	category = "Vegetable"

/datum/roguestock/stockpile/cucumber
	market_target = MARKET_TARGET_LOW
	name = "Cucumber"
	desc = "A refreshing, long and green vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/cucumber
	trade_good_id = TRADE_GOOD_CUCUMBER
	category = "Vegetable"

/datum/roguestock/stockpile/eggplant
	market_target = MARKET_TARGET_LOW
	name = "Eggplant"
	desc = "A large, purple vegetable with a mild taste."
	item_type = /obj/item/reagent_containers/food/snacks/grown/eggplant
	trade_good_id = TRADE_GOOD_EGGPLANT
	category = "Vegetable"

/datum/roguestock/stockpile/sugar
	market_target = MARKET_TARGET_LOW
	name = "Sugar"
	desc = "A sweet powder milled from sugarcane."
	item_type = /obj/item/reagent_containers/food/snacks/sugar
	trade_good_id = TRADE_GOOD_SUGAR
	category = "Vegetable"

/datum/roguestock/stockpile/coffee
	market_target = MARKET_TARGET_LOW
	name = "Coffee Beans"
	desc = "The seed of the coffee plant. It makes a stimulating drink."
	item_type = /obj/item/reagent_containers/food/snacks/grown/coffeebeans
	trade_good_id = TRADE_GOOD_COFFEE
	category = "Vegetable"

/datum/roguestock/stockpile/tea
	market_target = MARKET_TARGET_LOW
	name = "Dried Tea Leaves"
	desc = "Dried tea leaves from the tea plant. Can be ground and brewed to make tea."
	item_type = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	trade_good_id = TRADE_GOOD_TEA
	category = "Vegetable"

/datum/roguestock/stockpile/poppy
	market_target = MARKET_TARGET_LOW
	name = "Poppy"
	desc = "A seed with a sedative effect."
	item_type = /obj/item/reagent_containers/food/snacks/grown/rogue/poppy
	trade_good_id = TRADE_GOOD_POPPY
	category = "Vegetable"

/datum/roguestock/stockpile/rocknut
	market_target = MARKET_TARGET_LOW
	name = "Rocknut"
	desc = "A nut with mild stimulant properties."
	item_type = /obj/item/reagent_containers/food/snacks/grown/nut
	trade_good_id = TRADE_GOOD_ROCKNUT
	category = "Vegetable"

/datum/roguestock/stockpile/beans
	market_target = MARKET_TARGET_STAPLE
	name = "Beans"
	desc = "Red beans from Naledi."
	item_type = /obj/item/reagent_containers/food/snacks/grown/beans
	trade_good_id = TRADE_GOOD_BEANS
	category = "Vegetable"

/datum/roguestock/stockpile/lentils
	market_target = MARKET_TARGET_STAPLE
	name = "Lentils"
	desc = "Multicolored nutty lentils from Naledi."
	item_type = /obj/item/reagent_containers/food/snacks/grown/lentils
	trade_good_id = TRADE_GOOD_LENTILS
	category = "Vegetable"
