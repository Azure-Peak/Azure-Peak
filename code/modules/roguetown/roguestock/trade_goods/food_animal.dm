/datum/trade_good/meat
	id = TRADE_GOOD_MEAT
	name = "Meat"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_MEAT
	source_region_id = TRADE_REGION_KINGSFIELD
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak

/datum/trade_good/pork
	id = TRADE_GOOD_PORK
	name = "Pork"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_PORK
	source_region_id = TRADE_REGION_KINGSFIELD
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty

/datum/trade_good/poultry
	id = TRADE_GOOD_POULTRY
	name = "Bird Meat"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_POULTRY
	source_region_id = TRADE_REGION_KINGSFIELD
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry

/datum/trade_good/rabbit
	id = TRADE_GOOD_RABBIT
	name = "Cabbit Meat"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_RABBIT
	source_region_id = TRADE_REGION_KINGSFIELD
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit

/datum/trade_good/egg
	id = TRADE_GOOD_EGG
	name = "Egg"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_EGG
	source_region_id = TRADE_REGION_KINGSFIELD
	item_type = /obj/item/reagent_containers/food/snacks/egg

/datum/trade_good/butter
	id = TRADE_GOOD_BUTTER
	name = "Butter"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_BUTTER
	source_region_id = TRADE_REGION_KINGSFIELD
	item_type = /obj/item/reagent_containers/food/snacks/butter

/datum/trade_good/cheese
	id = TRADE_GOOD_CHEESE
	name = "Cheese"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_CHEESE
	source_region_id = TRADE_REGION_KINGSFIELD
	item_type = /obj/item/reagent_containers/food/snacks/rogue/cheese

/datum/trade_good/fat
	id = TRADE_GOOD_FAT
	name = "Fat"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_FAT
	source_region_id = TRADE_REGION_KINGSFIELD
	item_type = /obj/item/reagent_containers/food/snacks/fat

/datum/trade_good/tallow
	id = TRADE_GOOD_TALLOW
	name = "Tallow"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_TALLOW
	source_region_id = TRADE_REGION_KINGSFIELD
	item_type = /obj/item/reagent_containers/food/snacks/tallow

// Preserved meats — raw-behavior stockpile goods produced from raw meat + salt.
// Standing orders (victualling) demand these in bulk; the warehouse scales accept
// them the same as any other foodstuff. Salumoi's path is /meat/salami (legacy),
// while its in-world name is "salumoi"; matching item_type binds correctly.
/datum/trade_good/salumoi
	id = TRADE_GOOD_SALUMOI
	name = "Salumoi"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_SALUMOI
	source_region_id = TRADE_REGION_KINGSFIELD
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/salami

// Cooked sausage — player-crafted butcher good. Coppiette was excluded from the trade
// pool because it's merchant-purchasable in bulk (arbitrage risk); salumoi and sausage
// are player-crafted only, keeping the Crown's larder honest.
/datum/trade_good/sausage
	id = TRADE_GOOD_SAUSAGE
	name = "Sausage"
	category = TRADE_CATEGORY_ANIMAL
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_SAUSAGE
	source_region_id = TRADE_REGION_KINGSFIELD
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked

/datum/trade_good/dried_fish
	id = TRADE_GOOD_DRIED_FISH
	name = "Dried Fish Filet"
	category = TRADE_CATEGORY_SEAFOOD
	behavior = TRADE_BEHAVIOR_RAW
	base_price = SELLPRICE_DRIED_FISH
	source_region_id = TRADE_REGION_SALTWICK
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet
