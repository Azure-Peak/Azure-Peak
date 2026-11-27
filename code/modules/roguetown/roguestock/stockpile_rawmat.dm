/datum/roguestock/stockpile/wood
	market_target = MARKET_TARGET_MASS
	name = "Wood"
	desc = "Wooden logs cut short for transport."
	item_type = /obj/item/grown/log/tree/small
	trade_good_id = TRADE_GOOD_WOOD

/datum/roguestock/stockpile/coal
	market_target = MARKET_TARGET_BULK
	name = "Coal"
	desc = "Chunks of coal used for fuel and alloying."
	item_type = /obj/item/rogueore/coal
	trade_good_id = TRADE_GOOD_COAL

/datum/roguestock/stockpile/stone
	market_target = MARKET_TARGET_MASS
	name = "Stone"
	desc = "Stones. Used for construction"
	item_type = /obj/item/natural/stone
	trade_good_id = TRADE_GOOD_STONE

/datum/roguestock/stockpile/clay
	name = "Clay"
	desc = "Damp clay dug from bog sediment. It is ready to shape or fire."
	item_type = /obj/item/natural/clay
	trade_good_id = TRADE_GOOD_CLAY

/datum/roguestock/stockpile/salt//Comes from rocks not a farm
	name = "Salt"
	desc = "Rock salt useful for curing and cooking."
	item_type = /obj/item/reagent_containers/powder/salt
	trade_good_id = TRADE_GOOD_SALT

/datum/roguestock/stockpile/glass
	name = "Glass Batch"	//'Raw' glass
	desc = "A mixture of finely ground materials that is used to make glass."
	item_type = /obj/item/natural/glassbatch
	trade_good_id = TRADE_GOOD_GLASS_BATCH

/datum/roguestock/stockpile/iron
	market_target = MARKET_TARGET_STANDARD
	name = "Raw Iron"
	desc = "Chunks of iron used for smithing."
	item_type = /obj/item/rogueore/iron
	trade_good_id = TRADE_GOOD_IRON_ORE

/datum/roguestock/stockpile/copper
	market_target = MARKET_TARGET_MODEST
	name = "Raw Copper"
	desc = "Chunks of copper used for smithing and alloying."
	item_type = /obj/item/rogueore/copper
	trade_good_id = TRADE_GOOD_COPPER_ORE

/datum/roguestock/stockpile/tin
	name = "Raw Tin"
	desc = "Chunks of tin used for smithing and alloying."
	item_type = /obj/item/rogueore/tin
	trade_good_id = TRADE_GOOD_TIN_ORE

/datum/roguestock/stockpile/gold
	name = "Raw Gold"
	desc = "Chunks of unrefined gold."
	item_type = /obj/item/rogueore/gold
	trade_good_id = TRADE_GOOD_GOLD_ORE
	market_target = MARKET_TARGET_RARE

/datum/roguestock/stockpile/silver
	name = "Raw Silver"
	desc = "Chunks of unrefined silver."
	item_type = /obj/item/rogueore/silver
	trade_good_id = TRADE_GOOD_SILVER_ORE
	market_stock = 0
	market_target = MARKET_TARGET_RARE
	market_never_supplies = TRUE

/datum/roguestock/stockpile/cinnabar
	market_target = MARKET_TARGET_MODEST
	name = "Cinnabar"
	desc = "A red mineral used to make quicksilver."
	item_type = /obj/item/rogueore/cinnabar
	trade_good_id = TRADE_GOOD_CINNABAR

/datum/roguestock/stockpile/cloth
	market_target = MARKET_TARGET_BULK
	name = "Cloth"
	desc = "Lengths of cloth for sewing and tailoring."
	item_type = /obj/item/natural/cloth
	trade_good_id = TRADE_GOOD_CLOTH

/datum/roguestock/stockpile/fibers
	market_target = MARKET_TARGET_BULK
	name = "Fibers"
	desc = "Strands used to make cloth and other items."
	item_type = /obj/item/natural/fibers
	trade_good_id = TRADE_GOOD_FIBERS

/datum/roguestock/stockpile/silk
	market_target = MARKET_TARGET_MODEST
	name = "Silk"
	desc = "Strands of spider silk used to make exotic clothes."
	item_type = /obj/item/natural/silk
	trade_good_id = TRADE_GOOD_SILK

/datum/roguestock/stockpile/cured
	name = "Cured Leather"
	desc = "Cured Leather ready to be worked."
	item_type = /obj/item/natural/hide/cured
	trade_good_id = TRADE_GOOD_CURED_LEATHER
	market_never_buys = TRUE // Shut down any cheap hide -> leather exploit

/datum/roguestock/stockpile/hide
	name = "Hide"
	desc = "Stripped hide from animals."
	item_type = /obj/item/natural/hide
	trade_good_id = TRADE_GOOD_HIDE

/datum/roguestock/stockpile/hide/check_item(obj/item/I)
	if(istype(I, /obj/item/natural/hide/cured))
		return FALSE
	return ..()

/datum/roguestock/stockpile/fur
	market_target = MARKET_TARGET_MODEST
	name = "Fur"
	desc = "Hide with a long winter coat from animals."
	item_type = /obj/item/natural/fur
	trade_good_id = TRADE_GOOD_FUR
