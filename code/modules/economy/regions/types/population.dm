/datum/region_type/population/settlement
	name = "Settlement"
	demands = list(
		TRADE_GOOD_GRAIN = TG_VOLUME_BULK,
		TRADE_GOOD_CLOTH = TG_VOLUME_BULK,
		TRADE_GOOD_IRON_INGOT = TG_VOLUME_STANDARD,
	)

/datum/region_type/population/garrison
	name = "Garrison"
	demands = list(
		/datum/trade_good_group/iron_ingots = TG_VOLUME_STANDARD,
		/datum/trade_good_group/bronze_ingots = TG_VOLUME_STANDARD,
		/datum/trade_good_group/hides_and_furs = TG_VOLUME_MODEST,
		/datum/trade_good_group/staple_meats = TG_VOLUME_STANDARD,
		/datum/trade_good_group/dairy = TG_VOLUME_STANDARD,
		/datum/trade_good_group/root_vegetables = TG_VOLUME_MODEST,
		/datum/trade_good_group/preserved_meats = TG_VOLUME_STANDARD,
		TRADE_GOOD_CURED_LEATHER = TG_VOLUME_MODEST,
		TRADE_GOOD_DRIED_FISH = TG_VOLUME_STANDARD,
		TRADE_GOOD_OATS = TG_VOLUME_BULK,
		TRADE_GOOD_MEAT = TG_VOLUME_BULK,
		TRADE_GOOD_EGG = TG_VOLUME_BULK,
		TRADE_GOOD_SALT = TG_VOLUME_STANDARD,
		TRADE_GOOD_COAL = TG_VOLUME_STANDARD,
		TRADE_GOOD_CLAY = TG_VOLUME_STANDARD,
	)
	request_kinds = list(
		/datum/request_kind/arms,
		/datum/request_kind/heavy_armor,
		/datum/request_kind/light_armor,
		/datum/request_kind/prosthetics,
		/datum/request_kind/potions,
	)

/datum/region_type/population/mariners
	name = "Mariners"
	demands = list(
		/datum/trade_good_group/preserved_meats = TG_VOLUME_STANDARD,
		/datum/trade_good_group/dairy = TG_VOLUME_STANDARD,
		/datum/trade_good_group/pulses = TG_VOLUME_MODEST,
		TRADE_GOOD_DRIED_FISH = TG_VOLUME_STANDARD,
	)

/datum/region_type/population/urban
	name = "Urban"
	demands = list(
		TRADE_GOOD_IRON_ORE = TG_VOLUME_STANDARD,
		TRADE_GOOD_COPPER_ORE = TG_VOLUME_MODEST,
		TRADE_GOOD_TIN_ORE = TG_VOLUME_MODEST,
		TRADE_GOOD_CINNABAR = TG_VOLUME_STANDARD,
		TRADE_GOOD_COAL = TG_VOLUME_STANDARD,
		TRADE_GOOD_STONE = TG_VOLUME_STANDARD,
		TRADE_GOOD_CLAY = TG_VOLUME_STANDARD,
		TRADE_GOOD_WOOD = TG_VOLUME_MASS,
		/datum/trade_good_group/hides_and_furs = TG_VOLUME_MODEST,
		TRADE_GOOD_CURED_LEATHER = TG_VOLUME_MODEST,
		TRADE_GOOD_FIBERS = TG_VOLUME_BULK,
		TRADE_GOOD_GLASS_BATCH = TG_VOLUME_LOW,
		TRADE_GOOD_SALT = TG_VOLUME_STANDARD,
		TRADE_GOOD_VISCERA = TG_VOLUME_MODEST,
		TRADE_GOOD_SINEW = TG_VOLUME_MODEST,
		TRADE_GOOD_FISH_FILET = TG_VOLUME_HEAVY,
		TRADE_GOOD_FISH_MINCE = TG_VOLUME_HEAVY,
	)
	request_kinds = list(
		/datum/request_kind/artificery,
		/datum/request_kind/potions,
	)

/datum/region_type/population/noble_presence
	name = "Noble Presence"
	demands = list(
		/datum/trade_good_group/precious_metals = TG_VOLUME_MODEST,
		/datum/trade_good_group/herbs = TG_VOLUME_MODEST,
		/datum/trade_good_group/fine_fish = TG_VOLUME_BULK,
		/datum/trade_good_group/orchard_fruit = TG_VOLUME_STANDARD,
		/datum/trade_good_group/exotic_fruit = TG_VOLUME_LOW,
		/datum/trade_good_group/luxuries = TG_VOLUME_LOW,
		/datum/trade_good_group/dairy = TG_VOLUME_STANDARD,
		TRADE_GOOD_SILK = TG_VOLUME_MODEST,
		TRADE_GOOD_GLASS_BATCH = TG_VOLUME_LOW,
		TRADE_GOOD_DENDOR_ESSENCE = TG_VOLUME_LOW,
	)
	request_kinds = list(
		/datum/request_kind/finery,
		/datum/request_kind/jewelry,
		/datum/request_kind/hunt_trophies,
		/datum/request_kind/enchantment_scrolls,
		/datum/request_kind/artificed_panoply,
	)
