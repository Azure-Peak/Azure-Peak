/datum/roguestock/stockpile/meat
	name = "Meat"
	desc = "Edible flesh harvested from most animals."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak
	trade_good_id = TRADE_GOOD_MEAT
	royal_stock = 5
	category = "Animal"

/datum/roguestock/stockpile/rat
	name = "Lesser Meat"
	desc = "Barely edible flesh harvested from rous."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rat
	trade_good_id = TRADE_GOOD_LESSER_MEAT
	royal_stock = 0
	category = "Animal"

/datum/roguestock/stockpile/deer
	name = "Venison"
	desc = "Delicious and edible flesh harvested from saiga or deer."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga
	trade_good_id = TRADE_GOOD_VENISON
	royal_stock = 0
	category = "Animal"

/datum/roguestock/stockpile/deerribs
	name = "Venison Ribs"
	desc = "Luxuriously edible flesh on-the-bone harvested from saiga."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/saiga_ribs
	trade_good_id = TRADE_GOOD_VENISON_RIBS
	royal_stock = 0
	category = "Animal"

/datum/roguestock/stockpile/volf
	name = "Bushmeat"
	desc = "Barely edible flesh harvested from volfs."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/wolf
	trade_good_id = TRADE_GOOD_BUSHMEAT
	royal_stock = 0
	category = "Animal"

/datum/roguestock/stockpile/bear
	name = "Greater Bushmeat"
	desc = "Barely edible flesh harvested from bears."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/bear
	trade_good_id = TRADE_GOOD_GREATER_BUSHMEAT
	royal_stock = 0
	category = "Animal"

/datum/roguestock/stockpile/spider
	name = "Bogmeat"
	desc = "Barely edible flesh harvested from mirelurkers."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/spider
	trade_good_id = TRADE_GOOD_BOGMEAT
	royal_stock = 0
	category = "Animal"

/datum/roguestock/stockpile/crabbo
	name = "Crab Meat"
	desc = "Edible flesh harvested from crabs."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/crab
	trade_good_id = TRADE_GOOD_CRAB_MEAT
	royal_stock = 0
	category = "Seafood"

/datum/roguestock/stockpile/poultry
	name = "Bird Meat"
	desc = "Edible flesh harvested from birds and fowl."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry
	trade_good_id = TRADE_GOOD_POULTRY
	royal_stock = 2
	category = "Animal"

/datum/roguestock/stockpile/rabbit
	name = "Cabbit Meat"
	desc = "Edible flesh harvested from cabbits."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit
	trade_good_id = TRADE_GOOD_RABBIT
	royal_stock = 2
	category = "Animal"

/datum/roguestock/stockpile/pork
	name = "Pork"
	desc = "Edible flesh harvested from swine."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty
	trade_good_id = TRADE_GOOD_PORK
	royal_stock = 2
	category = "Animal"

/datum/roguestock/stockpile/ham
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
	name = "Boar Ham"
	desc = "Delicious flesh carved from a wild boar, perfect for smoking or steaming."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/ham/boar
	trade_good_id = TRADE_GOOD_BOAR_HAM
	royal_stock = 0
	category = "Animal"

/datum/roguestock/stockpile/pork_belly
	name = "Pork Belly"
	desc = "A fatty slab of swine belly, raw and ready to be cured into bacon."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/pork_belly
	trade_good_id = TRADE_GOOD_PORK_BELLY
	category = "Animal"

/datum/roguestock/stockpile/bones
	name = "Bones"
	desc = "Nondescript leftovers that make a good stock for soup and other things."
	item_type = /obj/item/natural/bone
	trade_good_id = TRADE_GOOD_BONES
	royal_stock = 0
	category = "Animal"

/datum/roguestock/stockpile/fat
	name = "Fat"
	desc = "Greasy flesh from an animal."
	item_type = /obj/item/reagent_containers/food/snacks/fat
	trade_good_id = TRADE_GOOD_FAT
	royal_stock = 10
	category = "Animal"

/datum/roguestock/stockpile/tallow
	name = "Tallow"
	desc = "Shelf-stabilized fatty tissue."
	item_type = /obj/item/reagent_containers/food/snacks/tallow
	trade_good_id = TRADE_GOOD_TALLOW
	category = "Animal"

/datum/roguestock/stockpile/honey
	name = "Honey"
	desc = "Sweet delicious from a sweet place."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/honey
	trade_good_id = TRADE_GOOD_HONEY
	royal_stock = 1
	category = "Animal"

/datum/roguestock/stockpile/egg
	name = "Egg"
	desc = "Egg laid by a hen."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/egg
	trade_good_id = TRADE_GOOD_EGG
	royal_stock = 4
	category = "Animal"

/datum/roguestock/stockpile/butter
	name = "Butter"
	desc = "The product of milk and salt."
	item_type = /obj/item/reagent_containers/food/snacks/butter
	trade_good_id = TRADE_GOOD_BUTTER
	royal_stock = 5
	category = "Animal"

/datum/roguestock/stockpile/cheese
	name = "Cheese"
	desc = "The product of milk and salt."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/cheese
	trade_good_id = TRADE_GOOD_CHEESE
	royal_stock = 5
	category = "Animal"

/datum/roguestock/stockpile/salumoi
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
