/datum/region_type/mining/iron_steel
	name = "Minerals (Iron and Steel)"
	produces = list(
		TRADE_GOOD_IRON_ORE = TG_VOLUME_HEAVY,
		TRADE_GOOD_COAL = TG_VOLUME_HEAVY,
	)
	demands = list(
		TRADE_GOOD_MEAT = TG_VOLUME_BULK,
	)

/datum/region_type/mining/copper_tin
	name = "Minerals (Copper and Tin)"
	produces = list(
		TRADE_GOOD_COPPER_ORE = TG_VOLUME_BULK,
		TRADE_GOOD_TIN_ORE = TG_VOLUME_BULK,
	)
	demands = list(
		TRADE_GOOD_MEAT = TG_VOLUME_BULK,
	)

/datum/region_type/mining/precious_veins
	name = "Precious Veins"
	produces = list(
		TRADE_GOOD_GOLD_ORE = TG_VOLUME_STANDARD,
		TRADE_GOOD_CINNABAR = TG_VOLUME_STANDARD,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_VOLUME_STANDARD,
	)

/datum/region_type/mining/stone_quarry
	name = "Stone Quarry"
	produces = list(
		TRADE_GOOD_STONE = TG_VOLUME_STAPLE,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_VOLUME_STANDARD,
	)

/datum/region_type/mining/glass_quarry
	name = "Glass Quarry"
	produces = list(
		TRADE_GOOD_GLASS_BATCH = TG_VOLUME_MODEST,
	)
	demands = list(
		TRADE_GOOD_WOOD = TG_VOLUME_MASS,
		TRADE_GOOD_IRON_INGOT = TG_VOLUME_STANDARD,
	)

/datum/region_type/mining/clay_pits
	name = "Clay Pits"
	produces = list(
		TRADE_GOOD_CLAY = TG_VOLUME_STAPLE,
	)

/datum/region_type/mining/salt_mines
	name = "Salt Mines"
	produces = list(
		TRADE_GOOD_SALT = TG_VOLUME_BULK,
	)
	demands = list(
		TRADE_GOOD_IRON_INGOT = TG_VOLUME_STANDARD,
	)

/datum/region_type/mining/salt_flats
	name = "Salt Flats"
	produces = list(
		TRADE_GOOD_SALT = TG_VOLUME_BULK,
	)
	seasonal_produces = list(
		SEASON_AUTUMN = REGION_SEASON_PEAK,
	)
