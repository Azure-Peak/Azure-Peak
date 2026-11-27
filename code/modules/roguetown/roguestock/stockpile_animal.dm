/datum/roguestock/stockpile/meat
	name = "Meat"
	desc = "Edible flesh harvested from most animals."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak
	trade_good_id = TRADE_GOOD_MEAT
	category = "Animal"

/datum/roguestock/stockpile/rat
	market_target = MARKET_TARGET_MODEST
	name = "Lesser Meat"
	desc = "Barely edible flesh harvested from rous."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rat
	trade_good_id = TRADE_GOOD_LESSER_MEAT
	category = "Animal"

/datum/roguestock/stockpile/deer
	market_target = MARKET_TARGET_MODEST
	name = "Venison"
	desc = "Delicious and edible flesh harvested from saiga or deer."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga
	trade_good_id = TRADE_GOOD_VENISON
	category = "Animal"

/datum/roguestock/stockpile/deerribs
	market_target = MARKET_TARGET_MODEST
	name = "Venison Ribs"
	desc = "Luxuriously edible flesh on-the-bone harvested from saiga."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs
	trade_good_id = TRADE_GOOD_VENISON_RIBS
	category = "Animal"

/datum/roguestock/stockpile/volf
	market_target = MARKET_TARGET_MODEST
	name = "Bushmeat"
	desc = "Barely edible flesh harvested from volfs."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/wolf
	trade_good_id = TRADE_GOOD_BUSHMEAT
	category = "Animal"

/datum/roguestock/stockpile/bear
	market_target = MARKET_TARGET_MODEST
	name = "Greater Bushmeat"
	desc = "Barely edible flesh harvested from bears."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/bear
	trade_good_id = TRADE_GOOD_GREATER_BUSHMEAT
	category = "Animal"

/datum/roguestock/stockpile/spider
	market_target = MARKET_TARGET_MODEST
	name = "Bogmeat"
	desc = "Barely edible flesh harvested from mirelurkers."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/spider
	trade_good_id = TRADE_GOOD_BOGMEAT
	category = "Animal"

/datum/roguestock/stockpile/crabbo
	market_target = MARKET_TARGET_MODEST
	name = "Crab Meat"
	desc = "Edible flesh harvested from crabs."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/crab
	trade_good_id = TRADE_GOOD_CRAB_MEAT
	category = "Seafood"

/datum/roguestock/stockpile/poultry
	market_target = MARKET_TARGET_MODEST
	name = "Bird Meat"
	desc = "Edible flesh harvested from birds and fowl."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry
	trade_good_id = TRADE_GOOD_POULTRY
	category = "Animal"

/datum/roguestock/stockpile/rabbit
	market_target = MARKET_TARGET_MODEST
	name = "Cabbit Meat"
	desc = "Edible flesh harvested from cabbits."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit
	trade_good_id = TRADE_GOOD_RABBIT
	category = "Animal"

/datum/roguestock/stockpile/pork
	market_target = MARKET_TARGET_MODEST
	name = "Pork"
	desc = "Edible flesh harvested from swine."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty
	trade_good_id = TRADE_GOOD_PORK
	category = "Animal"

/datum/roguestock/stockpile/ham
	market_target = MARKET_TARGET_MODEST
	name = "Ham"
	desc = "A prime cut of swine flesh, raw and ready for steaming."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/ham
	trade_good_id = TRADE_GOOD_HAM
	category = "Animal"

/datum/roguestock/stockpile/ham/check_item(obj/item/I)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/ham/boar))
		return FALSE
	return ..()

/datum/roguestock/stockpile/boarham
	market_target = MARKET_TARGET_MODEST
	name = "Boar Ham"
	desc = "Delicious flesh carved from a wild boar, perfect for smoking or steaming."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/ham/boar
	trade_good_id = TRADE_GOOD_BOAR_HAM
	category = "Animal"

/datum/roguestock/stockpile/pork_belly
	market_target = MARKET_TARGET_MODEST
	name = "Pork Belly"
	desc = "A fatty slab of swine belly, raw and ready to be cured into bacon."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/pork_belly
	trade_good_id = TRADE_GOOD_PORK_BELLY
	category = "Animal"

/datum/roguestock/stockpile/bones
	market_target = MARKET_TARGET_MODEST
	name = "Bones"
	desc = "Nondescript leftovers that make a good stock for soup and other things."
	item_type = /obj/item/natural/bone
	trade_good_id = TRADE_GOOD_BONES
	category = "Animal"

/datum/roguestock/stockpile/fat
	market_target = MARKET_TARGET_MODEST
	name = "Fat"
	desc = "Greasy flesh from an animal."
	item_type = /obj/item/reagent_containers/food/snacks/fat
	trade_good_id = TRADE_GOOD_FAT
	category = "Animal"

/datum/roguestock/stockpile/tallow
	market_target = MARKET_TARGET_MODEST
	name = "Tallow"
	desc = "Shelf-stabilized fatty tissue."
	item_type = /obj/item/reagent_containers/food/snacks/tallow
	trade_good_id = TRADE_GOOD_TALLOW
	category = "Animal"

/datum/roguestock/stockpile/honey
	market_target = MARKET_TARGET_LOW
	name = "Honey"
	desc = "Sweet delicious from a sweet place."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/honey
	trade_good_id = TRADE_GOOD_HONEY
	category = "Animal"

/datum/roguestock/stockpile/egg
	market_target = MARKET_TARGET_MODEST
	name = "Egg"
	desc = "Egg laid by a hen."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/egg
	trade_good_id = TRADE_GOOD_EGG
	category = "Animal"

/datum/roguestock/stockpile/butter
	market_target = MARKET_TARGET_MODEST
	name = "Butter"
	desc = "The product of milk and salt."
	item_type = /obj/item/reagent_containers/food/snacks/butter
	trade_good_id = TRADE_GOOD_BUTTER
	category = "Animal"

/datum/roguestock/stockpile/cheese
	market_target = MARKET_TARGET_MODEST
	name = "Cheese"
	desc = "The product of milk and salt."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/cheese
	trade_good_id = TRADE_GOOD_CHEESE
	category = "Animal"

/datum/roguestock/stockpile/salumoi
	market_target = MARKET_TARGET_MODEST
	name = "Salumoi"
	desc = "Dwarven smoked sausage cured to keep for ten yils."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/salami
	trade_good_id = TRADE_GOOD_SALUMOI
	category = "Animal"

/datum/roguestock/stockpile/sausage
	name = "Sausage"
	desc = "Cooked meat stuffed into a casing. It keeps for the season."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	trade_good_id = TRADE_GOOD_SAUSAGE
	category = "Animal"
