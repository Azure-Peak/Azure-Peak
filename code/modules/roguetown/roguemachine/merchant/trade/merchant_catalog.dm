/datum/merchant_catalog
	var/id
	var/name
	var/desc
	var/favor_cost = 750
	var/home_origin_name
	var/home_realm_id
	var/home_label
	var/list/stock = list()

/datum/merchant_catalog/rosawood
	id = "rosawood"
	name = "Rosawood Arsenal"
	desc = "The private arsenal of the Count of Rosawood, producing the finest elven arms in Azuria - fine steel weapons, bows and the bounty of Eveswood." //TODO: flavor
	favor_cost = ROSAWOOD_ARSENAL_FAVOR
	home_origin_name = "Azuria"
	home_realm_id = REALM_AZURIA
	home_label = "Azurian origin"
	stock = list(
		/datum/supply_pack/rogue/rosawood/elvish_longsword = 2,
		/datum/supply_pack/rogue/rosawood/elvish_shortsword = 2,
		/datum/supply_pack/rogue/rosawood/elvish_curveblade = 2,
		/datum/supply_pack/rogue/rosawood/elvish_glaive = 2,
		/datum/supply_pack/rogue/rosawood/woad_helm = 2,
		/datum/supply_pack/rogue/rosawood/woad_helm_light = 2,
		/datum/supply_pack/rogue/rosawood/blackoak_barbute = 2,
		/datum/supply_pack/rogue/rosawood/blackoak_barbute_winged = 2,
		/datum/supply_pack/rogue/rosawood/woad_plate = 1,
		/datum/supply_pack/rogue/rosawood/woad_plate_light = 2,
		/datum/supply_pack/rogue/rosawood/elven_boots = 3,
		/datum/supply_pack/rogue/rosawood/elven_gloves = 3,
		/datum/supply_pack/rogue/rosawood/forrester_cloak = 2,
		/datum/supply_pack/rogue/rosawood/woad_furcloak = 2,
		/datum/supply_pack/rogue/rosawood/recurve_bow = 2,
		/datum/supply_pack/rogue/rosawood/woad_recurve_bow = 2,
		/datum/supply_pack/rogue/rosawood/yew_longbow = 2,
		/datum/supply_pack/rogue/rosawood/arrows = 5,
		/datum/supply_pack/rogue/rosawood/bodkins = 4,
		/datum/supply_pack/rogue/rosawood/javelins = 4,
		/datum/supply_pack/rogue/rosawood/honey = 5,
		/datum/supply_pack/rogue/rosawood/raisin_loaf = 5,
		/datum/supply_pack/rogue/rosawood/apples = 5,
		/datum/supply_pack/rogue/rosawood/pears = 5,
		/datum/supply_pack/rogue/rosawood/berries = 5,
		/datum/supply_pack/rogue/rosawood/butter = 4,
	)

/datum/merchant_catalog/underdark
	id = "underdark"
	name = "Anthraxi Armory"
	desc = "Finely crafted drow weapons and armor, with a reputation for quality and lethality."
	favor_cost = UNDERDARK_CARAVAN_FAVOR
	home_origin_name = "the Underdark"
	home_realm_id = REALM_UNDERDARK
	home_label = "Underdark origin"
	stock = list(
		/datum/supply_pack/rogue/underdark/stalker_falx = 2,
		/datum/supply_pack/rogue/underdark/stalker_sabre = 2,
		/datum/supply_pack/rogue/underdark/stalker_dagger = 3,
		/datum/supply_pack/rogue/underdark/stalker_dirk = 2,
		/datum/supply_pack/rogue/underdark/spiderwhip = 2,
		/datum/supply_pack/rogue/underdark/spidershield = 1,
		/datum/supply_pack/rogue/underdark/drowcraft_vest = 2,
		/datum/supply_pack/rogue/underdark/scourge_breastplate = 1,
		/datum/supply_pack/rogue/underdark/darkplate_gauntlets = 2,
		/datum/supply_pack/rogue/underdark/skirmisher_gloves = 3,
		/datum/supply_pack/rogue/underdark/war_mask = 2,
		/datum/supply_pack/rogue/underdark/glossweave_shirt = 3,
		/datum/supply_pack/rogue/underdark/spidersilk_webbing = 3,
		/datum/supply_pack/rogue/underdark/crossbow = 2,
		/datum/supply_pack/rogue/underdark/recurve_bow = 2,
		/datum/supply_pack/rogue/underdark/arrows = 5,
		/datum/supply_pack/rogue/underdark/bolts = 5,
		/datum/supply_pack/rogue/underdark/chain = 4,
		/datum/supply_pack/rogue/underdark/shackles = 4,
		/datum/supply_pack/rogue/underdark/spider_honey = 5,
		/datum/supply_pack/rogue/underdark/repossessed_moondust = 2,
	)

/datum/controller/subsystem/merchant_trade/proc/catalog_unlocked(catalog_id)
	return (catalog_id in unlocked_catalogs)

/datum/controller/subsystem/merchant_trade/proc/unlock_catalog(catalog_id)
	var/datum/merchant_catalog/C = catalogs[catalog_id]
	if(!C || (catalog_id in unlocked_catalogs))
		return FALSE
	if(!spend_merchant_favor(C.favor_cost))
		return FALSE
	unlocked_catalogs += catalog_id
	return TRUE

/datum/controller/subsystem/merchant_trade/proc/catalog_origin_access(datum/merchant_catalog/C, mob/living/carbon/human/H)
	if(!istype(C) || !C.home_origin_name || !ishuman(H) || !H.client?.prefs)
		return FALSE
	var/datum/virtue/origin/O = H.client.prefs.virtue_origin
	if(!istype(O))
		return FALSE
	return O.origin_name == C.home_origin_name

/datum/controller/subsystem/merchant_trade/proc/catalog_company_kinship(datum/merchant_catalog/C)
	if(!istype(C) || !C.home_realm_id || !current_kinship_realm)
		return FALSE
	return C.home_realm_id == current_kinship_realm

/datum/controller/subsystem/merchant_trade/proc/catalog_agent_kinship(datum/merchant_catalog/C, mob/living/carbon/human/H)
	if(!istype(C) || !C.home_realm_id)
		return FALSE
	var/agent_realm = get_agent_personal_kinship_realm(H)
	return agent_realm && (agent_realm == C.home_realm_id)

/datum/controller/subsystem/merchant_trade/proc/catalog_access_basis(datum/merchant_catalog/C, mob/living/carbon/human/H)
	if(catalog_company_kinship(C))
		return "kinship"
	if(catalog_agent_kinship(C, H))
		return "agent"
	if(catalog_origin_access(C, H))
		return "origin"
	return null

/datum/controller/subsystem/merchant_trade/proc/init_catalog_stock()
	catalog_stock = list()
	for(var/cid in catalogs)
		var/datum/merchant_catalog/C = catalogs[cid]
		var/list/counts = list()
		for(var/path in C.stock)
			counts[path] = C.stock[path]
		catalog_stock[cid] = counts

/datum/controller/subsystem/merchant_trade/proc/restock_catalogs()
	for(var/cid in catalogs)
		var/datum/merchant_catalog/C = catalogs[cid]
		var/list/counts = catalog_stock[cid]
		if(!counts)
			continue
		for(var/path in C.stock)
			counts[path] = C.stock[path]

/datum/controller/subsystem/merchant_trade/proc/catalog_stock_remaining(catalog_id, path)
	var/list/counts = catalog_stock[catalog_id]
	if(!counts)
		return 0
	return counts[path] || 0

/datum/controller/subsystem/merchant_trade/proc/consume_catalog_stock(catalog_id, path)
	var/list/counts = catalog_stock[catalog_id]
	if(!counts || (counts[path] || 0) <= 0)
		return FALSE
	counts[path] -= 1
	return TRUE
