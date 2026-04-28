/datum/roguestock/stockpile/wood
	name = "Wood"
	desc = "Wooden logs cut short for transport."
	item_type = /obj/item/grown/log/tree/small
	trade_good_id = TRADE_GOOD_WOOD
	stockpile_amount = 10
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/coal
	name = "Coal"
	desc = "Chunks of coal used for fuel and alloying."
	item_type = /obj/item/rogueore/coal
	trade_good_id = TRADE_GOOD_COAL
	stockpile_amount = 10
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/stone
	name = "Stone"
	desc = "Stones. Used for construction"
	item_type = /obj/item/natural/stone
	trade_good_id = TRADE_GOOD_STONE
	stockpile_amount = 10
	importexport_amt = 10
	stockpile_limit = 50 // Allow a small amount of stones to be sold for chiselling

/datum/roguestock/stockpile/clay
	name = "Clay"
	desc = "Damp clay dug from bog sediment, ready to be shaped or fired."
	item_type = /obj/item/natural/clay
	trade_good_id = TRADE_GOOD_CLAY
	stockpile_amount = 10
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/salt//Comes from rocks not a farm
	name = "Salt"
	desc = "Rock salt useful for curing and cooking."
	item_type = /obj/item/reagent_containers/powder/salt
	trade_good_id = TRADE_GOOD_SALT
	stockpile_amount = 2
	importexport_amt = 5
	stockpile_limit = 25

/datum/roguestock/stockpile/glass
	name = "Glass Batch"	//'Raw' glass
	desc = "A mixture of finely ground materials that is used to make glass."
	item_type = /obj/item/natural/clay/glassbatch
	trade_good_id = TRADE_GOOD_GLASS_BATCH
	stockpile_amount = 5
	importexport_amt = 5
	stockpile_limit = 25

/datum/roguestock/stockpile/iron
	name = "Raw Iron"
	desc = "Chunks of iron used for smithing."
	item_type = /obj/item/rogueore/iron
	trade_good_id = TRADE_GOOD_IRON_ORE
	stockpile_amount = 15
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/copper
	name = "Raw Copper"
	desc = "Chunks of copper used for smithing and alloying."
	item_type = /obj/item/rogueore/copper
	trade_good_id = TRADE_GOOD_COPPER_ORE
	stockpile_amount = 12
	importexport_amt = 10
	stockpile_limit = 25

/datum/roguestock/stockpile/tin
	name = "Raw Tin"
	desc = "Chunks of tin used for smithing and alloying."
	item_type = /obj/item/rogueore/tin
	trade_good_id = TRADE_GOOD_TIN_ORE
	stockpile_amount = 12
	importexport_amt = 10
	stockpile_limit = 25

/datum/roguestock/stockpile/gold
	name = "Raw Gold"
	desc = "Chunks of unrefined gold."
	item_type = /obj/item/rogueore/gold
	trade_good_id = TRADE_GOOD_GOLD_ORE
	stockpile_limit = 50
	importexport_amt = 10

/datum/roguestock/stockpile/silver
	name = "Raw Silver"
	desc = "Chunks of unrefined silver."
	item_type = /obj/item/rogueore/silver
	trade_good_id = TRADE_GOOD_SILVER_ORE
	stockpile_amount = 0 // Explicitly empty - players must produce their own silver.
	stockpile_limit = 25
	importexport_amt = 5

/datum/roguestock/stockpile/cinnabar
	name = "Cinnabar"
	desc = "A red mineral used to make quicksilver."
	item_type = /obj/item/rogueore/cinnabar
	trade_good_id = TRADE_GOOD_CINNABAR
	stockpile_limit = 50
	importexport_amt = 5

/datum/roguestock/stockpile/cloth
	name = "Cloth"
	desc = "Lengths of cloth for sewing and tailoring."
	item_type = /obj/item/natural/cloth
	trade_good_id = TRADE_GOOD_CLOTH
	importexport_amt = 10
	stockpile_limit = 100

/datum/roguestock/stockpile/fibers
	name = "Fibers"
	desc = "Strands used to make cloth and other items."
	item_type = /obj/item/natural/fibers
	trade_good_id = TRADE_GOOD_FIBERS
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/silk
	name = "Silk"
	desc = "Strands of spider silk used to make exotic clothes."
	item_type = /obj/item/natural/silk
	trade_good_id = TRADE_GOOD_SILK
	importexport_amt = 5
	stockpile_limit = 25

//natural/hide/cured must be defined/populated in sstreasury before natural/hide, for istype stockpile check to work
/datum/roguestock/stockpile/cured
	name = "Cured Leather"
	desc = "Cured Leather ready to be worked."
	item_type = /obj/item/natural/hide/cured
	trade_good_id = TRADE_GOOD_CURED_LEATHER
	stockpile_amount = 15
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/hide
	name = "Hide"
	desc = "Stripped hide from animals."
	item_type = /obj/item/natural/hide
	trade_good_id = TRADE_GOOD_HIDE
	stockpile_amount = 10
	importexport_amt = 5
	stockpile_limit = 50

/datum/roguestock/stockpile/fur
	name = "Fur"
	desc = "Hide with a long winter coat from animals."
	item_type = /obj/item/natural/fur
	trade_good_id = TRADE_GOOD_FUR
	importexport_amt = 5
	stockpile_limit = 25
