/datum/region_type/pastoral/mixed
	name = "Pastoral (Mixed)"
	produces = list(
		TRADE_GOOD_MEAT = TG_VOLUME_BULK,
		TRADE_GOOD_POULTRY = TG_VOLUME_STANDARD,
		TRADE_GOOD_EGG = TG_VOLUME_BULK,
		TRADE_GOOD_BUTTER = TG_VOLUME_STANDARD,
		TRADE_GOOD_CHEESE = TG_VOLUME_STANDARD,
		TRADE_GOOD_FAT = TG_VOLUME_STANDARD,
		TRADE_GOOD_TALLOW = TG_VOLUME_STANDARD,
	)
	demands = list(
		TRADE_GOOD_SALT = TG_VOLUME_STANDARD,
	)
	seasonal_produces = list(
		SEASON_AUTUMN = REGION_SEASON_PEAK,
	)
	seasonal_demands = list(
		SEASON_AUTUMN = list(
			TRADE_GOOD_SALT = REGION_SEASON_PEAK,
		),
	)

/datum/region_type/pastoral/saiga
	name = "Pastoral (Saigas)"
	produces = list(
		TRADE_GOOD_MEAT = TG_VOLUME_BULK,
		TRADE_GOOD_HIDE = TG_VOLUME_STANDARD,
		TRADE_GOOD_TALLOW = TG_VOLUME_STANDARD,
	)
	demands = list(
		TRADE_GOOD_OATS = TG_VOLUME_BULK,
	)

/datum/region_type/pastoral/mountain
	name = "Pastoral (Goats and Saigas)"
	produces = list(
		TRADE_GOOD_CHEESE = TG_VOLUME_STANDARD,
		TRADE_GOOD_BUTTER = TG_VOLUME_STANDARD,
		TRADE_GOOD_MEAT = TG_VOLUME_BULK,
		TRADE_GOOD_FUR = TG_VOLUME_STANDARD,
		TRADE_GOOD_HIDE = TG_VOLUME_STANDARD,
	)

/datum/region_type/pastoral/swine
	name = "Swine Herd"
	produces = list(
		TRADE_GOOD_PORK = TG_VOLUME_STANDARD,
		TRADE_GOOD_HAM = TG_VOLUME_STANDARD,
		TRADE_GOOD_PORK_BELLY = TG_VOLUME_STANDARD,
		TRADE_GOOD_FAT = TG_VOLUME_STANDARD,
	)
	demands = list(
		TRADE_GOOD_ROCKNUT = TG_VOLUME_MODEST,
	)
	seasonal_produces = list(
		SEASON_AUTUMN = REGION_SEASON_PEAK,
	)
