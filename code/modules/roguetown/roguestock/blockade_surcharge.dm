GLOBAL_LIST_INIT(blockade_goldface_surcharges, list(
	TRADE_REGION_KINGSFIELD = list("pct" = BLOCKADE_SURCHARGE_CATEGORY_PCT, "categories" = list("Consumable", "Livestock", "Seeds")),
	TRADE_REGION_ROSAWOOD = list("pct" = BLOCKADE_SURCHARGE_CATEGORY_PCT, "categories" = list("Apparel", "Wardrobe", "Armor (Light)", "Instruments")),
	TRADE_REGION_ROCKHILL = list("pct" = BLOCKADE_SURCHARGE_CATEGORY_PCT, "categories" = list("Alcohols", "Potions")),
	TRADE_REGION_DAFTSMARCH = list("pct" = BLOCKADE_SURCHARGE_CATEGORY_PCT, "categories" = list("Gems", "Tools", "Armor (Iron)", "Weapons (Iron and Shields)", "Weapons (Bronze)")),
	TRADE_REGION_HAGENWALD = list("pct" = BLOCKADE_SURCHARGE_CATEGORY_PCT, "categories" = list("Armor (Iron)", "Armor (Steel)", "Weapons (Iron and Shields)", "Weapons (Bronze)", "Weapons (Steel)", "Tools")),
	TRADE_REGION_BLACKHOLT = list("pct" = BLOCKADE_SURCHARGE_CATEGORY_PCT, "categories" = list("Luxury", "Potions")),
	TRADE_REGION_SALTWICK = list("pct" = BLOCKADE_SURCHARGE_CATEGORY_PCT, "categories" = list("Consumable")),
	TRADE_REGION_BLEAKCOAST = list("pct" = BLOCKADE_SURCHARGE_PIRACY_PCT, "reason" = "from piracy"),
	TRADE_REGION_NORTHFORT = list("pct" = BLOCKADE_SURCHARGE_DEMAND_PCT, "reason" = "from higher demand"),
	TRADE_REGION_HEARTFELT = list("pct" = BLOCKADE_SURCHARGE_DEMAND_PCT, "reason" = "from higher demand"),
))

GLOBAL_LIST_INIT(blockade_gear_categories, list(
	"Armor (Light)",
	"Armor (Iron)",
	"Armor (Steel)",
	"Armor (Exotic)",
	"Weapons (Ranged)",
	"Weapons (Iron and Shields)",
	"Weapons (Bronze)",
	"Weapons (Steel)",
	"Weapons (Foreign)",
))

/proc/count_roundstart_blockades()
	var/count = 0
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		if(B.roundstart)
			count++
	return count

/proc/get_blockade_gear_surcharge_pct()
	return count_roundstart_blockades() * BLOCKADE_SURCHARGE_GEAR_PCT

/proc/get_blockade_goldface_surcharge_pct(category)
	var/total = 0
	if(category in GLOB.blockade_gear_categories)
		total += get_blockade_gear_surcharge_pct()
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		if(!B.roundstart)
			continue
		var/list/entry = GLOB.blockade_goldface_surcharges[B.region_id]
		if(!entry)
			continue
		var/list/cats = entry["categories"]
		if(cats && !(category in cats))
			continue
		total += entry["pct"]
	return total

/proc/build_blockade_goldface_rows()
	var/list/rows = list()
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		if(!B.roundstart)
			continue
		var/list/entry = GLOB.blockade_goldface_surcharges[B.region_id]
		if(!entry)
			continue
		var/datum/economic_region/ER = B.get_region()
		var/list/cats = entry["categories"]
		rows += list(list(
			"region" = ER ? ER.name : B.region_id,
			"pct" = entry["pct"],
			"categories" = cats ? cats.Copy() : list(),
			"reason" = entry["reason"] || "",
		))
	return rows
