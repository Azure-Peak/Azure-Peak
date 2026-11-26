/datum/region_type/wilds/forest
	name = "Forestry (General)"
	produces = list(
		TRADE_GOOD_WOOD = TG_VOLUME_STAPLE,
		TRADE_GOOD_FIBERS = TG_VOLUME_HEAVY,
		TRADE_GOOD_MUSHROOM = TG_VOLUME_STANDARD,
	)

/datum/region_type/wilds/elven_forest
	name = "Forestry (Elven)"
	produces = list(
		TRADE_GOOD_WOOD = TG_VOLUME_STAPLE,
		TRADE_GOOD_ROCKNUT = TG_VOLUME_STANDARD,
		TRADE_GOOD_DENDOR_ESSENCE = TG_VOLUME_RARE,
	)

/datum/region_type/wilds/hunting
	name = "Hunting"
	produces = list(
		TRADE_GOOD_HIDE = TG_VOLUME_STANDARD,
		TRADE_GOOD_FUR = TG_VOLUME_STANDARD,
		TRADE_GOOD_RABBIT = TG_VOLUME_STANDARD,
		/datum/trade_good_group/game_meats = TG_VOLUME_LOW,
		TRADE_GOOD_BONES = TG_VOLUME_LOW,
	)
	seasonal_produces = list(
		SEASON_WINTER = list(
			TRADE_GOOD_FUR = REGION_SEASON_HIGH,
		),
	)

/datum/region_type/wilds/swamp
	name = "Swamp"
	produces = list(
		TRADE_GOOD_SILK = TG_VOLUME_MODEST,
		TRADE_GOOD_VISCERA = TG_VOLUME_MODEST,
		TRADE_GOOD_SINEW = TG_VOLUME_MODEST,
		TRADE_GOOD_BOGMEAT = TG_VOLUME_MODEST,
		TRADE_GOOD_DENDOR_ESSENCE = TG_VOLUME_RARE,
		TRADE_GOOD_CALENDULA = TG_VOLUME_MODEST,
		TRADE_GOOD_HONEY = TG_VOLUME_MODEST,
		TRADE_GOOD_MUSHROOM = TG_VOLUME_STANDARD,
	)
