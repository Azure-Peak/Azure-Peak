/datum/region_type/industry/weaving
	name = "Weaving"
	produces = list(
		TRADE_GOOD_CLOTH = TG_VOLUME_BULK,
	)
	demands = list(
		TRADE_GOOD_FIBERS = TG_VOLUME_BULK,
	)

/datum/region_type/industry/refinement
	name = "Refinement"
	produces = list(
		TRADE_GOOD_IRON_INGOT = TG_VOLUME_BULK,
		TRADE_GOOD_STEEL_INGOT = TG_VOLUME_BULK,
		TRADE_GOOD_BRONZE_INGOT = TG_VOLUME_BULK,
		TRADE_GOOD_COPPER_INGOT = TG_VOLUME_BULK,
		TRADE_GOOD_TIN_INGOT = TG_VOLUME_BULK,
	)
	demands = list(
		TRADE_GOOD_IRON_ORE = TG_VOLUME_STANDARD,
		TRADE_GOOD_COPPER_ORE = TG_VOLUME_MODEST,
		TRADE_GOOD_TIN_ORE = TG_VOLUME_MODEST,
		TRADE_GOOD_SILVER_ORE = TG_VOLUME_MODEST,
		TRADE_GOOD_CINNABAR = TG_VOLUME_STANDARD,
		TRADE_GOOD_COAL = TG_VOLUME_STANDARD,
		TRADE_GOOD_MEAT = TG_VOLUME_BULK,
	)

/datum/region_type/industry/charcoal_burning
	name = "Charcoal Burning"
	produces = list(
		TRADE_GOOD_COAL = TG_VOLUME_HEAVY,
	)
	demands = list(
		TRADE_GOOD_WOOD = TG_VOLUME_MASS,
	)

/datum/region_type/industry/curing
	name = "Curing"
	produces = list(
		/datum/trade_good_group/preserved_meats = TG_VOLUME_STANDARD,
		TRADE_GOOD_DRIED_FISH = TG_VOLUME_STANDARD,
	)
	demands = list(
		TRADE_GOOD_SALT = TG_VOLUME_STANDARD,
		TRADE_GOOD_MEAT = TG_VOLUME_BULK,
		TRADE_GOOD_PORK = TG_VOLUME_STANDARD,
		TRADE_GOOD_FISH_FILET = TG_VOLUME_HEAVY,
	)

/datum/region_type/industry/tannery
	name = "Tannery"
	produces = list(
		TRADE_GOOD_CURED_LEATHER = TG_VOLUME_STANDARD,
	)
	demands = list(
		TRADE_GOOD_HIDE = TG_VOLUME_MODEST,
		TRADE_GOOD_SALT = TG_VOLUME_STANDARD,
	)

/datum/region_type/industry/shipyard
	name = "Shipyard"
	demands = list(
		/datum/trade_good_group/textiles = TG_VOLUME_BULK,
		TRADE_GOOD_WOOD = TG_VOLUME_MASS,
		TRADE_GOOD_TALLOW = TG_VOLUME_STANDARD,
		TRADE_GOOD_IRON_INGOT = TG_VOLUME_STANDARD,
	)

/datum/region_type/industry/toolworks
	name = "Toolworks"
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_VOLUME_STANDARD,
		TRADE_GOOD_STEEL_INGOT = TG_VOLUME_STANDARD,
		TRADE_GOOD_COAL = TG_VOLUME_STANDARD,
		TRADE_GOOD_WOOD = TG_VOLUME_MASS,
	)
	request_kinds = list(
		/datum/request_kind/artificery,
	)

/datum/region_type/industry/brewery
	name = "Brewery"
	demands = list(
		TRADE_GOOD_GRAIN = TG_VOLUME_BULK,
		TRADE_GOOD_OATS = TG_VOLUME_BULK,
		TRADE_GOOD_HONEY = TG_VOLUME_LOW,
	)

/datum/region_type/industry/mint
	name = "Mint"
	produces = list(
		TRADE_GOOD_GOLD_INGOT = TG_VOLUME_LOW,
	)
	demands = list(
		TRADE_GOOD_GOLD_ORE = TG_VOLUME_MODEST,
	)
