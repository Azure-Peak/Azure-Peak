GLOBAL_LIST_EMPTY(standing_order_pool)
GLOBAL_LIST_INIT(request_kinds, init_request_kinds())

/proc/init_request_kinds()
	var/list/kinds = list()
	for(var/path in subtypesof(/datum/request_kind))
		kinds[path] = new path()
	return kinds

/datum/standing_order
	var/name
	var/description
	var/region_id
	var/list/required_items = list()
	var/total_payout = 0
	var/day_issued = 0
	var/day_expires = 0
	var/is_fulfilled = FALSE
	/// Spawned by a Steward petition. Payout is shaved by PETITION_TAX_MULT and the UI tags it.
	var/petitioned = FALSE
	var/partly_delivered = FALSE
	var/crafted = FALSE

/// Called after region_id is set. Return the order's display name.
/datum/standing_order/proc/generate_name(datum/economic_region/region)
	return "[uppertext(region.name)] - STANDING ORDER"

/// Called after region_id is set. Return a flavor paragraph.
/datum/standing_order/proc/generate_description(datum/economic_region/region)
	return "A standing order has been posted from [region.name]."

/datum/standing_order/request
	var/good_id

/datum/standing_order/request/generate_name(datum/economic_region/region)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	return "[uppertext(region.name)] - [uppertext(tg ? tg.name : good_id)]"

/datum/standing_order/request/generate_description(datum/economic_region/region)
	return ""

/datum/request_kind
	var/name
	var/roll_weight = 1
	var/crafted = TRUE
	var/list/goods = list()

/datum/request_kind/arms
	name = "Arms"
	roll_weight = REQUEST_WEIGHT_ARMS
	goods = list(
		TRADE_GOOD_STEEL_ARMING_SWORD,
		TRADE_GOOD_STEEL_SHORTSWORD,
		TRADE_GOOD_STEEL_FALCHION,
		TRADE_GOOD_STEEL_MESSER,
		TRADE_GOOD_STEEL_SABRE,
		TRADE_GOOD_STEEL_MACE,
		TRADE_GOOD_STEEL_FLANGED_MACE,
		TRADE_GOOD_STEEL_FLAIL,
		TRADE_GOOD_STEEL_LONGSWORD,
		TRADE_GOOD_STEEL_BROADSWORD,
		TRADE_GOOD_STEEL_WARHAMMER,
		TRADE_GOOD_STEEL_BATTLEAXE,
		TRADE_GOOD_HURLBAT,
		TRADE_GOOD_RECURVE_BOW,
	)

/datum/request_kind/heavy_armor
	name = "Heavy Armor"
	roll_weight = REQUEST_WEIGHT_HEAVY_ARMOR
	goods = list(
		TRADE_GOOD_STEEL_CHAINMAIL,
		TRADE_GOOD_STEEL_HAUBERK,
		TRADE_GOOD_BRIGANDINE,
		TRADE_GOOD_BRIGANDINE_HEAVY,
		TRADE_GOOD_STEEL_CUIRASS,
		TRADE_GOOD_STEEL_COATPLATES,
		TRADE_GOOD_STEEL_HALFPLATE,
		TRADE_GOOD_STEEL_FULLPLATE,
		TRADE_GOOD_STEEL_HELM_KNIGHT,
		TRADE_GOOD_STEEL_HELM_BASCINET,
		TRADE_GOOD_STEEL_HELM_KETTLE,
		TRADE_GOOD_STEEL_MASK,
		TRADE_GOOD_CHAIN_GLOVES,
		TRADE_GOOD_PLATE_GAUNTLETS,
		TRADE_GOOD_STEEL_PLATE_LEGS,
	)

/datum/request_kind/light_armor
	name = "Light Armor"
	roll_weight = REQUEST_WEIGHT_LIGHT_ARMOR
	goods = list(
		TRADE_GOOD_PADDED_GAMBESON,
		TRADE_GOOD_HEAVY_LEATHER_COAT,
		TRADE_GOOD_HARDENED_LEATHER_HELMET,
		TRADE_GOOD_HARDENED_LEATHER_GORGET,
		TRADE_GOOD_HEAVY_LEATHER_GLOVES,
	)

/datum/request_kind/potions
	name = "Potions"
	roll_weight = REQUEST_WEIGHT_POTIONS
	crafted = FALSE
	goods = list(
		TRADE_GOOD_HEALTH_POTION,
		TRADE_GOOD_ANTIDOTE_POTION,
		TRADE_GOOD_MANA_POTION,
		TRADE_GOOD_STRONG_HEALTH_POTION,
		TRADE_GOOD_STRONG_MANA_POTION,
		TRADE_GOOD_STRONG_ANTIDOTE_POTION,
		TRADE_GOOD_PERCEPTION_POTION,
		TRADE_GOOD_INTELLIGENCE_POTION,
		TRADE_GOOD_SPEED_POTION,
		TRADE_GOOD_STAM_POTION,
		TRADE_GOOD_STRONG_STAM_POTION,
	)

/datum/request_kind/prosthetics
	name = "Prosthetics"
	roll_weight = REQUEST_WEIGHT_PROSTHETICS
	goods = list(
		TRADE_GOOD_BRONZE_PROSTHETIC,
		TRADE_GOOD_IRON_PROSTHETIC,
		TRADE_GOOD_STEEL_PROSTHETIC,
	)

/datum/request_kind/artificery
	name = "Artificery"
	roll_weight = REQUEST_WEIGHT_ARTIFICERY
	goods = list(
		TRADE_GOOD_FOLD_TABLE,
		TRADE_GOOD_MOBILE_STOVE,
		TRADE_GOOD_KEY,
		TRADE_GOOD_LOCK,
		TRADE_GOOD_WATER_PURIFIER,
		TRADE_GOOD_MESS_KIT,
		TRADE_GOOD_SCISSORS,
	)

/datum/request_kind/artificed_panoply
	name = "Artificed Panoply"
	roll_weight = REQUEST_WEIGHT_PANOPLY
	goods = list(
		TRADE_GOOD_CROSSBOW,
		TRADE_GOOD_VOLTIC_GAUNTLETS,
		TRADE_GOOD_STEAM_SHIELD,
		TRADE_GOOD_AUTO_SHEARS,
		TRADE_GOOD_GRAPPLING_HOOK,
	)

/datum/request_kind/finery
	name = "Finery"
	roll_weight = REQUEST_WEIGHT_FINERY
	goods = list(
		TRADE_GOOD_NOBLECOAT,
		TRADE_GOOD_SILK_TUNIC,
		TRADE_GOOD_SEASONAL_GOWN,
		TRADE_GOOD_MAID_DRESS,
		TRADE_GOOD_ROYAL_DRESS,
	)

/datum/request_kind/jewelry
	name = "Jewelry"
	roll_weight = REQUEST_WEIGHT_JEWELRY
	goods = list(
		TRADE_GOOD_AMBER_RING,
		TRADE_GOOD_GOLD_RING,
		TRADE_GOOD_EMERALD_RING,
		TRADE_GOOD_DIAMOND_RING,
		TRADE_GOOD_AMBER_AMULET,
		TRADE_GOOD_JADE_AMULET,
	)

/datum/request_kind/enchantment_scrolls
	name = "Enchantment Scrolls"
	roll_weight = REQUEST_WEIGHT_SCROLLS
	goods = list(
		TRADE_GOOD_ENCHSCROLL_BASIC,
		TRADE_GOOD_ENCHSCROLL_SUPERIOR,
		TRADE_GOOD_ENCHSCROLL_GREATER,
	)

/datum/request_kind/hunt_trophies
	name = "Hunt Trophies"
	roll_weight = REQUEST_WEIGHT_TROPHIES
	crafted = FALSE
	goods = list(
		TRADE_GOOD_TROPHY_WHITE_STAG,
		TRADE_GOOD_TROPHY_MINOTAUR,
		TRADE_GOOD_TROPHY_DIREBEAR,
		TRADE_GOOD_TROPHY_TROLL,
	)
