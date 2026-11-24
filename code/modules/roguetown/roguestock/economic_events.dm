/datum/economic_event/fish
	fish_crops = TRUE

/datum/economic_event/fish/great_storm
	name = "Great Storm"
	description = "A vicious gale has battered the Bleakisles. The fishing fleets are grounded."
	exclusive = list(ECON_EVENT_EXCLUSIVE_WEATHER)
	shortage_goods = ECON_GOODS_SEA_FISH

/datum/economic_event/fish/herring_swarm
	name = "Herring Swarm"
	description = "A huge shoal of herring has swum into the Bleakisles. There is not enough salt to salt them all."
	shortage_goods = list(TRADE_GOOD_SALT)
	glut_goods = ECON_GOODS_SEA_FISH

/datum/economic_event/fish/river_drought
	name = "River Drought"
	description = "A dry spell has dried out River Azur and fish ponds. Carp and eel are hard to find."
	exclusive = list(ECON_EVENT_EXCLUSIVE_WEATHER)
	shortage_goods = ECON_GOODS_FRESH_WATER_FISH

/datum/economic_event/fish/spawning_run
	name = "Spawning Run"
	description = "Salmon are running upriver and carp are spawning in large numbers."
	glut_goods = ECON_GOODS_FRESH_WATER_FISH

/datum/economic_event/fish/mirespider_swarm
	name = "Mirespider Swarm"
	description = "The mirespiders in the Terrorbog are unusually active, devouring all of the swamp fish. Their honey is plentiful."
	shortage_goods = ECON_GOODS_SWAMP_CATCH
	glut_goods = list(TRADE_GOOD_HONEY)

/datum/economic_event/fish/teeming_mire
	name = "Teeming Mire"
	description = "Blackholt reports the swamp is unusually rich and full of mudskippers."
	glut_goods = ECON_GOODS_SWAMP_CATCH

/datum/economic_event/crops
	fish_crops = TRUE

/datum/economic_event/crops/grain_blight
	name = "Grain Blight"
	description = "A rot has infested most of the grain in Kingsfield. Grain is short throughout Azuria."
	shortage_goods = ECON_GOODS_GRAINS

/datum/economic_event/crops/bumper_harvest
	name = "Bumper Harvest"
	description = "The grain harvest is unusually rich. Prices are down."
	glut_goods = ECON_GOODS_GRAINS

/datum/economic_event/crops/unseasonal_rain
	name = "Unseasonal Rain"
	description = "Weeks of heavy rain have flooded the fields. Root crops rot in the ground. Rice and mushrooms thrive."
	exclusive = list(ECON_EVENT_EXCLUSIVE_WEATHER)
	shortage_goods = ECON_GOODS_ROOTS
	glut_goods = list(TRADE_GOOD_RICE, TRADE_GOOD_MUSHROOM)

/datum/economic_event/crops/cellar_clearance
	name = "Cellar Clearance"
	description = "Kingsfield farmers are clearing last season's root cellars. Old potatoes and turnips are selling cheap."
	glut_goods = ECON_GOODS_ROOTS

/datum/economic_event/crops/dry_spell
	name = "Dry Spell"
	description = "A dry spell has withered the vegetable gardens."
	exclusive = list(ECON_EVENT_EXCLUSIVE_WEATHER)
	shortage_goods = ECON_GOODS_VEGETABLES

/datum/economic_event/crops/bean_weevils
	name = "Bean Weevils"
	description = "Weevils have gotten into stored beans and lentils."
	shortage_goods = ECON_GOODS_BEANS

/datum/economic_event/crops/caterpillar_plague
	name = "Caterpillar Plague"
	description = "Caterpillars have stripped the Rockhill orchards bare."
	shortage_goods = ECON_GOODS_ORCHARD_FRUIT

/datum/economic_event/crops/cidering_season
	name = "Cidering Season"
	description = "The Rockhill orchards report an unusually rich harvest, with fruit rotting on the ground."
	glut_goods = ECON_GOODS_ORCHARD_FRUIT

/datum/economic_event/crops/late_frost
	name = "Late Frost"
	description = "A late frost has killed the citrus blossoms in North Syons. Lemons, limes and tangerines are scarce."
	exclusive = list(ECON_EVENT_EXCLUSIVE_WEATHER)
	shortage_goods = ECON_GOODS_CITRUS

/datum/economic_event/crops/berry_season
	name = "Berry Season"
	description = "Berries are in utter abundance."
	glut_goods = ECON_GOODS_BERRIES

/datum/economic_event/crops/merchant_fleet
	name = "Merchant Fleet"
	description = "A foreign fleet has docked with sugar, coffee and tea. Prices are down."
	glut_goods = ECON_GOODS_CASH_CROPS

/datum/economic_event/primary

/datum/economic_event/primary/daftsmarch_mine_collapse
	name = "Daftsmarch Mine Collapse"
	description = "A shaft has collapsed in Daftsmarch and shut down three major mines. Iron ore and coal are scarce."
	exclusive = list(ECON_EVENT_EXCLUSIVE_METAL)
	shortage_goods = list(TRADE_GOOD_IRON_ORE, TRADE_GOOD_COAL)

/datum/economic_event/primary/azurbon_mine_flood
	name = "Azurbon Mine Flood"
	description = "Unusual rain has flooded the mineshafts of Azurbon, causing a copper and tin shortage."
	exclusive = list(ECON_EVENT_EXCLUSIVE_METAL, ECON_EVENT_EXCLUSIVE_WEATHER)
	shortage_goods = list(TRADE_GOOD_COPPER_ORE, TRADE_GOOD_TIN_ORE)

/datum/economic_event/primary/bullion_call
	name = "Bullion Call"
	description = "The Royal Mint is purchasing gold and silver ore to mint more coins. Prices are up."
	exclusive = list(ECON_EVENT_EXCLUSIVE_METAL)
	shortage_goods = list(TRADE_GOOD_GOLD_ORE, TRADE_GOOD_SILVER_ORE)

/datum/economic_event/primary/shipbuilding_frenzy
	name = "Shipbuilding Frenzy"
	description = "All of Azuria seems to be rebuilding ships at once. Timber prices are up."
	shortage_goods = list(TRADE_GOOD_WOOD)

/datum/economic_event/primary/trappers_frost
	name = "Trapper's Frost"
	description = "An unseasonal freeze has driven game into hiding. Fur and hide are scarce."
	exclusive = list(ECON_EVENT_EXCLUSIVE_WEATHER)
	shortage_goods = list(TRADE_GOOD_FUR, TRADE_GOOD_HIDE)

/datum/economic_event/primary/essence_scarcity
	name = "Essence Scarcity"
	description = "The essence harvest in Blackholt has failed. Essence of Dendor and viscera are scarce."
	shortage_goods = list(TRADE_GOOD_DENDOR_ESSENCE, TRADE_GOOD_VISCERA)

/datum/economic_event/primary/goblin_capture
	name = "Goblin Capture"
	description = "Crownsmen have rounded up an entire tribe of feral goblins and sent them to the quarry of Daftsmarch. Stone and coal are cheap."
	glut_goods = list(TRADE_GOOD_STONE, TRADE_GOOD_COAL)

/datum/economic_event/primary/rosawood_overcut
	name = "Rosawood Overcut"
	description = "Poor planning led to Rosawood and Eveswood lumber camps cutting far past quotas. Wood is cheap."
	glut_goods = list(TRADE_GOOD_WOOD)

/datum/economic_event/primary/unseasonal_fur
	name = "Unseasonal Fur"
	description = "Great herds are moving through the plains of Heartfelt. There are more pelts than ever."
	glut_goods = list(TRADE_GOOD_FUR, TRADE_GOOD_HIDE)

/datum/economic_event/secondary

/datum/economic_event/secondary/ironmongers_strike
	name = "Ironmongers' Strike"
	description = "The ironmongers' guild of Hagenwald has walked out after a violent brawl with squires and adventurers. Ingots are scarce."
	exclusive = list(ECON_EVENT_EXCLUSIVE_METAL)
	shortage_goods = list(TRADE_GOOD_IRON_INGOT, TRADE_GOOD_STEEL_INGOT)

/datum/economic_event/secondary/grenzelhoft_metal_glut
	name = "Grenzelhoft Metal Glut"
	description = "Grenzelhoft has dumped its surplus metal on the open market. Iron, copper and tin ingots are cheap."
	exclusive = list(ECON_EVENT_EXCLUSIVE_METAL)
	glut_goods = list(TRADE_GOOD_IRON_INGOT, TRADE_GOOD_COPPER_INGOT, TRADE_GOOD_TIN_INGOT)

/datum/economic_event/secondary/hagenwald_surplus
	name = "Hagenwald Surplus"
	description = "The Hagenwald furnaces have made more steel than was ordered. Steel is cheap."
	exclusive = list(ECON_EVENT_EXCLUSIVE_METAL)
	glut_goods = list(TRADE_GOOD_STEEL_INGOT)

/datum/economic_event/secondary/tanners_plague
	name = "Tanners' Plague"
	description = "A skin rot has spread through the tanneries of Heartfelt. Hides are being burned to stop it. Leather is scarce."
	shortage_goods = list(TRADE_GOOD_CURED_LEATHER)

/datum/economic_event/secondary/tannery_surplus
	name = "Tannery Surplus"
	description = "Last season's hide surplus has been tanned all at once. Leather is cheap."
	glut_goods = list(TRADE_GOOD_CURED_LEATHER)

/datum/economic_event/secondary/flax_pests
	name = "Flax Pests"
	description = "Pests have swarmed and eaten most of the flax in Azurian fields, causing cloth to go scarce."
	shortage_goods = list(TRADE_GOOD_CLOTH)

/datum/economic_event/secondary/cloth_fair
	name = "Cloth Fair"
	description = "The seasonal cloth fair is on. Cloth and fibers are cheap."
	glut_goods = list(TRADE_GOOD_CLOTH, TRADE_GOOD_FIBERS)

/datum/economic_event/tertiary

/datum/economic_event/tertiary/salt_caravan
	name = "Salt Caravan Arrives"
	description = "A Naledi caravan has arrived with wagons of salt. Salt is cheap."
	glut_goods = list(TRADE_GOOD_SALT)

/datum/economic_event/tertiary/salt_mine_flooding
	name = "Salt Mine Flooding"
	description = "Groundwater has flooded the Daftsmarch salt mines. Salt is scarce."
	shortage_goods = list(TRADE_GOOD_SALT)

/datum/economic_event/tertiary/blackholt_silk_collapse
	name = "Blackholt Silk Collapse"
	description = "A disease is killing the spiders of Blackholt. Silk is scarce."
	shortage_goods = list(TRADE_GOOD_SILK)

/datum/economic_event/tertiary/glass_furnace_failure
	name = "Glass Furnace Failure"
	description = "The Daftsmarch glass furnace has collapsed and must be rebuilt. Glass batch is scarce."
	shortage_goods = list(TRADE_GOOD_GLASS_BATCH)

/datum/economic_event/tertiary/clay_pit_collapse
	name = "Clay Pit Collapse"
	description = "Groundwater has caved in the Blackholt clay pits. Clay is scarce."
	shortage_goods = list(TRADE_GOOD_CLAY)

/datum/economic_event/tertiary/cattle_murrain
	name = "Cattle Murrain"
	description = "A wasting sickness is killing the Kingsfield and Heartfelt herds. Meat and dairy are scarce."
	shortage_goods = list(TRADE_GOOD_MEAT, TRADE_GOOD_BUTTER, TRADE_GOOD_CHEESE, TRADE_GOOD_SAUSAGE)

/datum/economic_event/tertiary/dairy_surplus
	name = "Dairy Surplus"
	description = "A mild season has filled the Kingsfield dairies. Butter and cheese are cheap."
	exclusive = list(ECON_EVENT_EXCLUSIVE_WEATHER)
	glut_goods = list(TRADE_GOOD_BUTTER, TRADE_GOOD_CHEESE)

/datum/economic_event/tertiary/fat_hog_season
	name = "Fat Hog Season"
	description = "Unusually rich masting has fattened the hogs of Rosawood beyond compare. Pork and fat are cheap."
	glut_goods = list(TRADE_GOOD_PORK, TRADE_GOOD_FAT, TRADE_GOOD_TALLOW, TRADE_GOOD_SAUSAGE, TRADE_GOOD_SALUMOI)

/datum/economic_event/tertiary/hive_collapse
	name = "Hive Collapse"
	description = "The hives of Rockhill have emptied. Honey is scarce."
	shortage_goods = list(TRADE_GOOD_HONEY)
