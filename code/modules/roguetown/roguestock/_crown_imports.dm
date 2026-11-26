/datum/crown_import
	var/name = ""
	var/desc = ""
	var/item_type = null
	var/base_cost = 100
	var/import_amt = 1
	var/daily_stock = CROWN_IMPORT_DAILY_STOCK
	var/stock = 0

/datum/crown_import/New()
	. = ..()
	stock = daily_stock

/datum/crown_import/proc/get_import_price()
	return max(round(base_cost * import_amt), 5)

/datum/crown_import/proc/restock()
	stock = daily_stock

GLOBAL_LIST_INIT(crown_imports, init_crown_imports())

/proc/init_crown_imports()
	var/list/result = list()
	for(var/path in subtypesof(/datum/crown_import))
		var/datum/crown_import/instance = new path
		result += instance
	return result
