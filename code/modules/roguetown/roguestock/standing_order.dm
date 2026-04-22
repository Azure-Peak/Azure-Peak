GLOBAL_LIST_EMPTY(standing_order_pool)

/datum/standing_order
	var/name
	var/description
	var/region_id
	var/list/required_items = list()
	var/total_payout = 0
	var/day_issued = 0
	var/day_expires = 0
	var/is_fulfilled = FALSE
	var/unfulfillable = FALSE

/// Override in subtypes. Returns assoc list of trade_good_id -> quantity. Called once when
/// SSeconomy instantiates an order from this template, to populate required_items with
/// randomized-but-in-range quantities.
/datum/standing_order/proc/generate_item_mix()
	return list()


/datum/standing_order/garrison_rations
	name = "GARRISON EMERGENCY RATIONS"
	description = "(description pending)"

/datum/standing_order/garrison_rations/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_GRAIN] = rand(15, 25)
	if(prob(40))
		mix[TRADE_GOOD_MEAT] = rand(5, 10)
	if(prob(30))
		mix[TRADE_GOOD_CHEESE] = rand(3, 8)
	return mix


/datum/standing_order/garrison_armaments
	name = "GARRISON ARMAMENT REQUISITION"
	description = "(description pending)"

/datum/standing_order/garrison_armaments/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_IRON_INGOT] = rand(5, 10)
	if(prob(50))
		mix[TRADE_GOOD_STEEL_INGOT] = rand(2, 5)
	if(prob(50))
		mix[TRADE_GOOD_CURED_LEATHER] = rand(3, 6)
	return mix


/datum/standing_order/kingsfield_surplus
	name = "KINGSFIELD SURPLUS PURCHASE"
	description = "(description pending)"

/datum/standing_order/kingsfield_surplus/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_GRAIN] = rand(20, 40)
	if(prob(40))
		mix[TRADE_GOOD_MEAT] = rand(8, 15)
	return mix


/datum/standing_order/rosawood_timber
	name = "ROSAWOOD TIMBER CONTRACT"
	description = "(description pending)"

/datum/standing_order/rosawood_timber/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_WOOD] = rand(15, 30)
	mix[TRADE_GOOD_FIBERS] = rand(10, 20)
	return mix


/datum/standing_order/daftsmarch_ore
	name = "DAFTSMARCH ORE DELIVERY"
	description = "(description pending)"

/datum/standing_order/daftsmarch_ore/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_IRON_ORE] = rand(10, 20)
	if(prob(50))
		mix[TRADE_GOOD_COPPER_ORE] = rand(8, 15)
	if(prob(50))
		mix[TRADE_GOOD_COAL] = rand(8, 15)
	return mix


/datum/standing_order/blackholt_exotic
	name = "WIZARDS' GUILD REQUISITION"
	description = "(description pending)"

/datum/standing_order/blackholt_exotic/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_DENDOR_ESSENCE] = rand(1, 3)
	if(prob(40))
		mix[TRADE_GOOD_SILK] = rand(2, 5)
	if(prob(40))
		mix[TRADE_GOOD_VISCERA] = rand(3, 8)
	return mix


/datum/standing_order/saltwick_catch
	name = "SALTWICK FISHING CONTRACT"
	description = "(description pending)"

/datum/standing_order/saltwick_catch/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_FISH_FILET] = rand(10, 20)
	if(prob(60))
		mix[TRADE_GOOD_SALT] = rand(5, 10)
	if(prob(30))
		mix[TRADE_GOOD_SALMON] = rand(3, 6)
	return mix


/datum/standing_order/rockhill_orchard
	name = "ROCKHILL ORCHARD HARVEST"
	description = "(description pending)"

/datum/standing_order/rockhill_orchard/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_APPLE] = rand(10, 20)
	if(prob(50))
		mix[TRADE_GOOD_JACKSBERRY] = rand(8, 15)
	if(prob(50))
		mix[TRADE_GOOD_HERBS] = rand(3, 8)
	return mix


/datum/standing_order/general_cloth
	name = "TAILOR'S GUILD REQUISITION"
	description = "(description pending)"

/datum/standing_order/general_cloth/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_CLOTH] = rand(10, 20)
	if(prob(50))
		mix[TRADE_GOOD_FIBERS] = rand(5, 10)
	return mix


/datum/standing_order/general_smith_supply
	name = "SMITHY SUPPLY ORDER"
	description = "(description pending)"

/datum/standing_order/general_smith_supply/generate_item_mix()
	var/list/mix = list()
	mix[TRADE_GOOD_IRON_INGOT] = rand(5, 10)
	if(prob(50))
		mix[TRADE_GOOD_COPPER_INGOT] = rand(3, 6)
	return mix
