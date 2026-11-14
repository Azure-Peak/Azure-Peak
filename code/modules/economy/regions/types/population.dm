/datum/region_type/population/settlement
	name = "Settlement"
	demands = list(
		TRADE_GOOD_GRAIN = TG_VOLUME_BULK,
		TRADE_GOOD_CLOTH = TG_VOLUME_BULK,
		TRADE_GOOD_IRON_INGOT = TG_VOLUME_STANDARD,
	)
	standing_orders = list(
		/datum/standing_order/demand_construction_bulk,
		/datum/standing_order/demand_birthday_gift,
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
	standing_orders = list(
		/datum/standing_order/demand_rations,
		/datum/standing_order/demand_armaments,
		/datum/standing_order/demand_victualling_garrison,
		/datum/standing_order/demand_equipment_armaments,
		/datum/standing_order/demand_equipment_armor_heavy,
		/datum/standing_order/demand_equipment_armor_light,
		/datum/standing_order/demand_frontier_gear,
		/datum/standing_order/demand_prosthetic_run,
		/datum/standing_order/demand_alchemical,
		/datum/standing_order/demand_alchemical_warband,
	)

/datum/region_type/population/mariners
	name = "Mariners"
	demands = list(
		/datum/trade_good_group/preserved_meats = TG_VOLUME_STANDARD,
		/datum/trade_good_group/dairy = TG_VOLUME_STANDARD,
		/datum/trade_good_group/pulses = TG_VOLUME_MODEST,
		TRADE_GOOD_DRIED_FISH = TG_VOLUME_STANDARD,
	)
	standing_orders = list(
		/datum/standing_order/demand_victualling_fleet,
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
	standing_orders = list(
		/datum/standing_order/demand_textile,
		/datum/standing_order/demand_smithing,
		/datum/standing_order/demand_artificery,
		/datum/standing_order/demand_alchemical,
		/datum/standing_order/demand_salt,
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
	standing_orders = list(
		/datum/standing_order/demand_court_finery,
		/datum/standing_order/demand_fine_joinery,
		/datum/standing_order/demand_jewelry,
		/datum/standing_order/demand_great_feast_proteins,
		/datum/standing_order/demand_tournament_arms,
		/datum/standing_order/demand_trophy_heads,
		/datum/standing_order/demand_arcane_commission,
		/datum/standing_order/demand_artificed_panoply,
		/datum/standing_order/demand_exotic,
		/datum/standing_order/demand_orchard,
	)
