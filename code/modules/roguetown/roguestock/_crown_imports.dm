/datum/crown_import
	var/name = ""
	var/desc = ""
	var/item_type = null
	var/base_cost = 100
	var/source_region_id
	var/import_amt = 1
	/// Times this crown_import has been ordered today. Each prior import adds CROWN_IMPORT_ELASTICITY
	/// to the next order's price. Resets on SSeconomy daily tick.
	var/daily_import_count = 0

/datum/crown_import/proc/get_import_price()
	var/region_mult = 1.0
	if(source_region_id)
		var/datum/economic_region/region = GLOB.economic_regions[source_region_id]
		if(region?.is_region_blockaded)
			region_mult = BLOCKADE_IMPORT_MULT
	var/elasticity_mult = 1.0 + (daily_import_count * CROWN_IMPORT_ELASTICITY)
	var/amount = round(base_cost * import_amt * elasticity_mult * region_mult)
	return max(amount, 5)

/datum/crown_import/proc/raise_demand()
	daily_import_count += 1

/datum/crown_import/proc/reset_daily_demand()
	daily_import_count = 0

/datum/crown_import/proc/is_blockaded()
	if(!source_region_id)
		return FALSE
	var/datum/economic_region/region = GLOB.economic_regions[source_region_id]
	return region?.is_region_blockaded

GLOBAL_LIST_INIT(crown_imports, init_crown_imports())

/proc/init_crown_imports()
	var/list/result = list()
	for(var/path in subtypesof(/datum/crown_import))
		var/datum/crown_import/instance = new path
		result += instance
	return result
