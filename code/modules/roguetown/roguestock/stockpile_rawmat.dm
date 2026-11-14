/datum/roguestock/stockpile/wood
	name = "Wood"
	desc = "Wooden logs cut short for transport."
	item_type = /obj/item/grown/log/tree/small
	trade_good_id = TRADE_GOOD_WOOD
	royal_stock = 10

/datum/roguestock/stockpile/coal
	name = "Coal"
	desc = "Chunks of coal used for fuel and alloying."
	item_type = /obj/item/rogueore/coal
	trade_good_id = TRADE_GOOD_COAL
	royal_stock = 10

/datum/roguestock/stockpile/stone
	name = "Stone"
	desc = "Stones. Used for construction"
	item_type = /obj/item/natural/stone
	trade_good_id = TRADE_GOOD_STONE
	royal_stock = 10

/datum/roguestock/stockpile/clay
	name = "Clay"
	desc = "Damp clay dug from bog sediment. It is ready to shape or fire."
	item_type = /obj/item/natural/clay
	trade_good_id = TRADE_GOOD_CLAY
	royal_stock = 10

/datum/roguestock/stockpile/salt//Comes from rocks not a farm
	name = "Salt"
	desc = "Rock salt useful for curing and cooking."
	item_type = /obj/item/reagent_containers/powder/salt
	trade_good_id = TRADE_GOOD_SALT
	royal_stock = 2

/datum/roguestock/stockpile/glass
	name = "Glass Batch"	//'Raw' glass
	desc = "A mixture of finely ground materials that is used to make glass."
	item_type = /obj/item/natural/glassbatch
	trade_good_id = TRADE_GOOD_GLASS_BATCH
	royal_stock = 5

/datum/roguestock/stockpile/iron
	name = "Raw Iron"
	desc = "Chunks of iron used for smithing."
	item_type = /obj/item/rogueore/iron
	trade_good_id = TRADE_GOOD_IRON_ORE
	royal_stock = 15

/datum/roguestock/stockpile/copper
	name = "Raw Copper"
	desc = "Chunks of copper used for smithing and alloying."
	item_type = /obj/item/rogueore/copper
	trade_good_id = TRADE_GOOD_COPPER_ORE
	royal_stock = 12

/datum/roguestock/stockpile/tin
	name = "Raw Tin"
	desc = "Chunks of tin used for smithing and alloying."
	item_type = /obj/item/rogueore/tin
	trade_good_id = TRADE_GOOD_TIN_ORE
	royal_stock = 12

/datum/roguestock/stockpile/gold
	name = "Raw Gold"
	desc = "Chunks of unrefined gold."
	item_type = /obj/item/rogueore/gold
	trade_good_id = TRADE_GOOD_GOLD_ORE
	market_target = MARKET_TARGET_RARE
	royal_stock = 4

/datum/roguestock/stockpile/silver
	name = "Raw Silver"
	desc = "Chunks of unrefined silver."
	item_type = /obj/item/rogueore/silver
	trade_good_id = TRADE_GOOD_SILVER_ORE
	market_target = MARKET_TARGET_RARE
	royal_stock = 0 // Explicitly empty - players must produce their own silver.
	market_never_supplies = TRUE

/datum/roguestock/stockpile/cinnabar
	name = "Cinnabar"
	desc = "A red mineral used to make quicksilver."
	item_type = /obj/item/rogueore/cinnabar
	trade_good_id = TRADE_GOOD_CINNABAR
	royal_stock = 20

/datum/roguestock/stockpile/cloth
	name = "Cloth"
	desc = "Lengths of cloth for sewing and tailoring."
	item_type = /obj/item/natural/cloth
	trade_good_id = TRADE_GOOD_CLOTH
	royal_stock = 10

/datum/roguestock/stockpile/fibers
	name = "Fibers"
	desc = "Strands used to make cloth and other items."
	item_type = /obj/item/natural/fibers
	trade_good_id = TRADE_GOOD_FIBERS
	royal_stock = 10

/datum/roguestock/stockpile/silk
	name = "Silk"
	desc = "Strands of spider silk used to make exotic clothes."
	item_type = /obj/item/natural/silk
	trade_good_id = TRADE_GOOD_SILK

//natural/hide/cured must be defined/populated in sstreasury before natural/hide, for istype stockpile check to work
/datum/roguestock/stockpile/cured
	name = "Cured Leather"
	desc = "Cured Leather ready to be worked."
	item_type = /obj/item/natural/hide/cured
	trade_good_id = TRADE_GOOD_CURED_LEATHER
	royal_stock = 15

/datum/roguestock/stockpile/hide
	name = "Hide"
	desc = "Stripped hide from animals."
	item_type = /obj/item/natural/hide
	trade_good_id = TRADE_GOOD_HIDE
	royal_stock = 10

/datum/roguestock/stockpile/fur
	name = "Fur"
	desc = "Hide with a long winter coat from animals."
	item_type = /obj/item/natural/fur
	trade_good_id = TRADE_GOOD_FUR
	royal_stock = 10
