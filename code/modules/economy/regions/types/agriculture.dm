/datum/region_type/agriculture/temperate
	name = "Agricultural (Temperate)"
	produces = list(
		TRADE_GOOD_GRAIN = TG_VOLUME_MASS,
		TRADE_GOOD_MAIZE = TG_VOLUME_STANDARD,
		TRADE_GOOD_RICE = TG_VOLUME_STANDARD,
		TRADE_GOOD_BEANS = TG_VOLUME_STANDARD,
		TRADE_GOOD_LENTILS = TG_VOLUME_STANDARD,
		TRADE_GOOD_CABBAGE = TG_VOLUME_STANDARD,
		TRADE_GOOD_ONION = TG_VOLUME_STANDARD,
		TRADE_GOOD_CARROT = TG_VOLUME_STANDARD,
		TRADE_GOOD_GARLICK = TG_VOLUME_STANDARD,
		TRADE_GOOD_CUCUMBER = TG_VOLUME_STANDARD,
		TRADE_GOOD_EGGPLANT = TG_VOLUME_STANDARD,
		TRADE_GOOD_TOMATO = TG_VOLUME_STANDARD,
		TRADE_GOOD_PUMPKIN = TG_VOLUME_TRICKLE,
	)
	seasonal_produces = list(
		SEASON_AUTUMN = REGION_SEASON_HIGH,
	)

/datum/region_type/agriculture/northern
	name = "Agricultural (Northern)"
	produces = list(
		TRADE_GOOD_OATS = TG_VOLUME_STANDARD,
		TRADE_GOOD_POTATO = TG_VOLUME_STANDARD,
		TRADE_GOOD_TURNIP = TG_VOLUME_STANDARD,
		TRADE_GOOD_CABBAGE = TG_VOLUME_STANDARD,
	)
	seasonal_produces = list(
		SEASON_WINTER = REGION_SEASON_LEAN,
	)

/datum/region_type/agriculture/orchard
	name = "Orchards"
	produces = list(
		TRADE_GOOD_APPLE = TG_VOLUME_BULK,
		TRADE_GOOD_PEAR = TG_VOLUME_BULK,
		TRADE_GOOD_JACKSBERRY = TG_VOLUME_BULK,
		TRADE_GOOD_BLACKBERRY = TG_VOLUME_BULK,
		TRADE_GOOD_RASPBERRY = TG_VOLUME_BULK,
		TRADE_GOOD_STRAWBERRY = TG_VOLUME_BULK,
		TRADE_GOOD_PLUM = TG_VOLUME_LOW,
		TRADE_GOOD_HONEY = TG_VOLUME_MODEST,
	)
	demands = list(
		TRADE_GOOD_GLASS_BATCH = TG_VOLUME_LOW,
		TRADE_GOOD_CLAY = TG_VOLUME_STANDARD,
	)
	seasonal_produces = list(
		SEASON_AUTUMN = REGION_SEASON_HIGH,
	)

/datum/region_type/agriculture/citrus_orchard
	name = "Citrus Orchards"
	produces = list(
		TRADE_GOOD_LEMON = TG_VOLUME_LOW,
		TRADE_GOOD_LIME = TG_VOLUME_LOW,
		TRADE_GOOD_TANGERINE = TG_VOLUME_LOW,
	)

/datum/region_type/agriculture/aquaculture
	name = "Aquaculture (Coastal)"
	produces = list(
		TRADE_GOOD_CARP = TG_VOLUME_BULK,
		TRADE_GOOD_EEL = TG_VOLUME_BULK,
	)

/datum/region_type/agriculture/herb_gardens
	name = "Herb Gardens"
	produces = list(
		/datum/trade_good_group/herbs = TG_VOLUME_MODEST,
	)
	seasonal_produces = list(
		SEASON_SUMMER = REGION_SEASON_HIGH,
	)
