/datum/roguestock/stockpile/wood
	name = "Wood"
	desc = "Wooden logs cut short for transport."
	item_type = /obj/item/grown/log/tree/small
	stockpile_amount = 2
	payout_price = 3
	withdraw_price = 3
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/coal
	name = "Coal"
	desc = "Chunks of coal used for fuel and alloying."
	item_type = /obj/item/rogueore/coal
	stockpile_amount = 5
	payout_price = 4
	withdraw_price = 4
	export_price = 6
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/stone
	name = "Stone"
	desc = "Stones. Used for construction"
	item_type = /obj/item/natural/stone
	stockpile_amount = 10
	payout_price = 1
	withdraw_price = 1
	export_price = 1
	importexport_amt = 10
	stockpile_limit = 50 // Allow a small amount of stones to be sold for chiselling

/datum/roguestock/stockpile/salt//Comes from rocks not a farm
	name = "Salt"
	desc = "Rock salt useful for curing and cooking."
	item_type = /obj/item/reagent_containers/powder/salt
	stockpile_amount = 2
	payout_price = 4
	withdraw_price = 4
	export_price = 8
	importexport_amt = 5
	stockpile_limit = 25

/datum/roguestock/stockpile/glass
	name = "Glass Batch"	//'Raw' glass
	desc = "A mixture of finely ground materials that is used to make glass."
	item_type = /obj/item/natural/clay/glassbatch
	stockpile_amount = 5
	payout_price = 4
	withdraw_price = 4
	export_price = 5
	importexport_amt = 5
	stockpile_limit = 25

/datum/roguestock/stockpile/iron
	name = "Raw Iron"
	desc = "Chunks of iron used for smithing."
	item_type = /obj/item/rogueore/iron
	stockpile_amount = 6
	payout_price = 5
	withdraw_price = 5
	export_price = 8
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/copper
	name = "Raw Copper"
	desc = "Chunks of copper used for smithing and alloying."
	item_type = /obj/item/rogueore/copper
	stockpile_amount = 6
	payout_price = 3
	withdraw_price = 3
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/tin
	name = "Raw Tin"
	desc = "Chunks of tin used for smithing and alloying."
	item_type = /obj/item/rogueore/tin
	stockpile_amount = 6
	payout_price = 4
	withdraw_price = 4
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/gold
	name = "Raw Gold"
	desc = "Chunks of unrefined gold."
	item_type = /obj/item/rogueore/gold
	payout_price = 50
	withdraw_price = 50
	export_price = 75
	stockpile_limit = 50
	importexport_amt = 10

/datum/roguestock/stockpile/silver
	name = "Raw Silver"
	desc = "Chunks of unrefined silver."
	item_type = /obj/item/rogueore/silver
	payout_price = 75
	withdraw_price = 75
	export_price = 100
	export_only = TRUE
	stockpile_limit = 25
	importexport_amt = 5

/datum/roguestock/stockpile/cinnabar
	name = "Cinnabar"
	desc = "A red mineral used to make quicksilver."
	item_type = /obj/item/rogueore/cinnabar
	payout_price = 5
	withdraw_price = 5
	export_price = 10
	stockpile_limit = 50
	importexport_amt = 5

/datum/roguestock/stockpile/cloth
	name = "Cloth"
	desc = "Lengths of cloth for sewing and tailoring."
	item_type = /obj/item/natural/cloth
	payout_price = 3
	withdraw_price = 3
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 100

/datum/roguestock/stockpile/fibers
	name = "Fibers"
	desc = "Strands used to make cloth and other items."
	item_type = /obj/item/natural/fibers
	payout_price = 1
	withdraw_price = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/silk
	name = "Silk"
	desc = "Strands of spider silk used to make exotic clothes."
	item_type = /obj/item/natural/silk
	payout_price = 2
	withdraw_price = 2
	export_price = 4
	importexport_amt = 5
	stockpile_limit = 25

//natural/hide/cured must be defined/populated in sstreasury before natural/hide, for istype stockpile check to work
/datum/roguestock/stockpile/cured
	name = "Cured Leather"
	desc = "Cured Leather ready to be worked."
	item_type = /obj/item/natural/hide/cured
	stockpile_amount = 2
	payout_price = 3
	withdraw_price = 3
	export_price = 7
	importexport_amt = 10
	stockpile_limit = 50

/datum/roguestock/stockpile/hide
	name = "Hide"
	desc = "Stripped hide from animals."
	item_type = /obj/item/natural/hide
	payout_price = 8
	withdraw_price = 8
	export_price = 12
	importexport_amt = 5
	stockpile_limit = 25

/datum/roguestock/stockpile/fur
	name = "Fur"
	desc = "Hide with a long winter coat from animals."
	item_type = /obj/item/natural/fur
	payout_price = 10
	withdraw_price = 10
	export_price = 15
	importexport_amt = 5
	stockpile_limit = 25
