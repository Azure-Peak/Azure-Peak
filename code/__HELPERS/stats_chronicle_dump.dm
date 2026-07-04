#define CHRONICLE_STATS_DIR "data/chronicle_stats"
#define CHRONICLE_STATS_DOWNLOAD_LIMIT_BYTES 5242880
#define CHRONICLE_STATS_ROUND_HEADER_PREFIX "=== ROUND "

/proc/chronicle_stats_weekly_bucket(realtime)
	var/datestamp = time2text(realtime || world.realtime, "YYYY-MM-DD")
	var/year_part = copytext(datestamp, 1, 5)
	var/month_part = copytext(datestamp, 6, 8)
	var/day = text2num(copytext(datestamp, 9, 11))
	var/week_of_month = ((day - 1) / 7) + 1
	return "[year_part]-[month_part]-W[week_of_month]"

/proc/chronicle_stats_file_path(realtime)
	return "[CHRONICLE_STATS_DIR]/chroniclestats_[chronicle_stats_weekly_bucket(realtime)].txt"

/proc/chronicle_stats_current_path()
	return chronicle_stats_file_path(world.realtime)

/proc/chronicle_stats_previous_week_path()
	return chronicle_stats_file_path(world.realtime - (7 * 24 * 36000))

/// Writes the current round's chronicle block to the weekly file.
/// If a block for this round_id already exists, replaces it; otherwise appends.
/proc/dump_chronicle_stats()
	var/round_id = "[GLOB.rogue_round_id || GLOB.round_id || "unknown"]"
	var/path = chronicle_stats_current_path()
	var/new_block = build_chronicle_stats_block(round_id)
	var/header_marker = "[CHRONICLE_STATS_ROUND_HEADER_PREFIX][round_id] "
	var/existing = ""
	if(fexists(path))
		existing = file2text(path)
	var/list/rebuilt = list()
	if(existing && findtext(existing, header_marker))
		var/list/round_blocks = splittext(existing, CHRONICLE_STATS_ROUND_HEADER_PREFIX)
		for(var/i in 1 to length(round_blocks))
			var/chunk = round_blocks[i]
			if(i == 1)
				if(length(chunk))
					rebuilt += chunk
				continue
			var/restored = "[CHRONICLE_STATS_ROUND_HEADER_PREFIX][chunk]"
			if(findtext(restored, header_marker) == 1)
				continue
			rebuilt += restored
		rebuilt += new_block
	else
		if(existing)
			rebuilt += existing
		rebuilt += new_block
	if(fexists(path))
		fdel(path)
	WRITE_FILE(file(path), jointext(rebuilt, ""))
	return path

/proc/build_chronicle_stats_block(round_id)
	var/list/out = list()
	out += "[CHRONICLE_STATS_ROUND_HEADER_PREFIX][round_id] | dumped [time2text(world.timeofday, "YYYY-MM-DD hh:mm:ss")] ===\n"
	var/round_minutes = round(world.time / 600)
	out += "Round duration: [round_minutes]m  |  Players joined: [GLOB.joined_player_list ? GLOB.joined_player_list.len : 0]  |  Live clients: [length(GLOB.clients)]\n"
	out += "\n"
	out += chronicle_section_population()
	out += chronicle_section_treasury()
	out += chronicle_section_foreign_trade()
	out += chronicle_section_merchant_ships()
	out += chronicle_section_navigator_buckets()
	out += chronicle_section_banking()
	out += chronicle_section_contracts()
	out += chronicle_section_events()
	out += chronicle_section_favors()
	out += chronicle_section_combat()
	out += "\n"
	return jointext(out, "")

/proc/chronicle_kv(label, value, width = 32)
	var/padded = label
	while(length(padded) < width)
		padded = "[padded] "
	return "  [padded][value]\n"

/proc/chronicle_section_header(label)
	return "--- [uppertext(label)] ---\n"

/proc/chronicle_section_population()
	var/list/out = list()
	out += chronicle_section_header("Population")
	out += chronicle_kv("Total population", "[GLOB.azure_round_stats[STATS_TOTAL_POPULATION]]")
	out += chronicle_kv("Garrison alive", "[GLOB.azure_round_stats[STATS_ALIVE_GARRISON]]")
	out += chronicle_kv("Clergy alive", "[GLOB.azure_round_stats[STATS_ALIVE_CLERGY]]")
	out += chronicle_kv("Tradesmen alive", "[GLOB.azure_round_stats[STATS_ALIVE_TRADESMEN]]")
	out += chronicle_kv("Nobles alive", "[GLOB.azure_round_stats[STATS_ALIVE_NOBLES]]")
	out += chronicle_kv("Gender (M/F/Other)", "[GLOB.azure_round_stats[STATS_MALE_POPULATION]] / [GLOB.azure_round_stats[STATS_FEMALE_POPULATION]] / [GLOB.azure_round_stats[STATS_OTHER_GENDER]]")
	out += chronicle_kv("Age (Adult/Mid/Elderly)", "[GLOB.azure_round_stats[STATS_ADULT_POPULATION]] / [GLOB.azure_round_stats[STATS_MIDDLEAGED_POPULATION]] / [GLOB.azure_round_stats[STATS_ELDERLY_POPULATION]]")
	out += "\n"
	return jointext(out, "")

/proc/chronicle_section_treasury()
	var/list/out = list()
	out += chronicle_section_header("Treasury")
	out += chronicle_kv("Starting treasury", "[GLOB.azure_round_stats[STATS_STARTING_TREASURY]]")
	out += chronicle_kv("Taxes collected", "[GLOB.azure_round_stats[STATS_TAXES_COLLECTED]]")
	out += chronicle_kv("  Contract levy", "[GLOB.azure_round_stats[STATS_REVENUE_CONTRACT_LEVY]]")
	out += chronicle_kv("  Headeater levy", "[GLOB.azure_round_stats[STATS_REVENUE_HEADEATER_LEVY]]")
	out += chronicle_kv("  Import tariff", "[GLOB.azure_round_stats[STATS_REVENUE_IMPORT_TARIFF]]")
	out += chronicle_kv("  Export duty", "[GLOB.azure_round_stats[STATS_REVENUE_EXPORT_DUTY]]")
	out += chronicle_kv("Poll tax collected", "[GLOB.azure_round_stats[STATS_POLL_TAX_COLLECTED]]")
	out += chronicle_kv("Taxes evaded", "[GLOB.azure_round_stats[STATS_TAXES_EVADED]]")
	var/exempt_total = GLOB.azure_round_stats[STATS_EXEMPTED_CONTRACT_LEVY] + GLOB.azure_round_stats[STATS_EXEMPTED_HEADEATER_LEVY] + GLOB.azure_round_stats[STATS_EXEMPTED_IMPORT_TARIFF] + GLOB.azure_round_stats[STATS_EXEMPTED_EXPORT_DUTY] + GLOB.azure_round_stats[STATS_EXEMPTED_FINE] + GLOB.azure_round_stats[STATS_EXEMPTED_POLL_TAX]
	out += chronicle_kv("Forgone revenue (exemptions)", "[exempt_total]")
	out += chronicle_kv("Wages paid", "[GLOB.azure_round_stats[STATS_WAGES_PAID]]")
	out += chronicle_kv("Fines income", "[GLOB.azure_round_stats[STATS_FINES_INCOME]]")
	out += chronicle_kv("Banditry losses", "[GLOB.azure_round_stats[STATS_BANDITRY_LOSSES]]")
	out += chronicle_kv("Direct treasury transfers", "[GLOB.azure_round_stats[STATS_DIRECT_TREASURY_TRANSFERS]]")
	out += "\n"
	return jointext(out, "")

/proc/chronicle_section_foreign_trade()
	var/list/out = list()
	out += chronicle_section_header("Foreign Trade")
	out += chronicle_kv("Trade exported (Real Market)", "[GLOB.azure_round_stats[STATS_TRADE_VALUE_EXPORTED]]")
	out += chronicle_kv("Trade exported (Black Market)", "[GLOB.azure_round_stats[STATS_TRADE_VALUE_EXPORTED_BM]]")
	out += chronicle_kv("Trade imported", "[GLOB.azure_round_stats[STATS_TRADE_VALUE_IMPORTED]]")
	out += chronicle_kv("GOLDFACE imports", "[GLOB.azure_round_stats[STATS_GOLDFACE_VALUE_SPENT]]")
	out += chronicle_kv("SILVERFACE imports", "[GLOB.azure_round_stats[STATS_SILVERFACE_VALUE_SPENT]]")
	out += chronicle_kv("COPPERFACE imports", "[GLOB.azure_round_stats[STATS_COPPERFACE_VALUE_SPENT]]")
	out += chronicle_kv("PURITY imports", "[GLOB.azure_round_stats[STATS_PURITY_VALUE_SPENT]]")
	if(SSmerchant_trade)
		out += chronicle_kv("Merchant levy collected", "[SSmerchant_trade.merchant_levy_collected]")
		out += chronicle_kv("Crown duty on levy", "[SSmerchant_trade.merchant_levy_taxed]")
		out += chronicle_kv("Company gnomes margin", "[SSmerchant_trade.gnome_margin_collected]")
	out += chronicle_kv("Peddler revenue", "[GLOB.azure_round_stats[STATS_PEDDLER_REVENUE]]")
	out += "\n"
	return jointext(out, "")

/proc/chronicle_section_merchant_ships()
	var/list/out = list()
	out += chronicle_section_header("Merchant Ships — Hails by Realm")
	if(!SSmerchant_trade)
		out += "  (SSmerchant_trade not initialized)\n\n"
		return jointext(out, "")
	var/list/sorted_ids = list()
	for(var/realm_id in SSmerchant_trade.realms)
		sorted_ids += realm_id
	sortTim(sorted_ids, GLOBAL_PROC_REF(chronicle_realm_hail_sort))
	var/total_hails = 0
	for(var/realm_id in SSmerchant_trade.hails_by_realm)
		total_hails += SSmerchant_trade.hails_by_realm[realm_id]
	out += chronicle_kv("Total successful hails", "[total_hails]")
	out += "  Realm           | Hails | Avg dock (m) | Favor earned\n"
	for(var/realm_id in sorted_ids)
		var/datum/foreign_realm/realm = SSmerchant_trade.realms[realm_id]
		var/realm_name = realm ? realm.name : realm_id
		var/hails = SSmerchant_trade.hails_by_realm[realm_id] || 0
		var/list/durations = SSmerchant_trade.dock_durations_by_realm[realm_id]
		var/avg_min = "  -"
		if(LAZYLEN(durations))
			var/total_ds = 0
			for(var/d in durations)
				total_ds += d
			avg_min = "[round((total_ds / length(durations)) / 600, 0.1)]"
		var/favor = SSmerchant_trade.favor_earned_by_realm[realm_id] || 0
		var/padded = realm_name
		while(length(padded) < 15)
			padded = "[padded] "
		out += "  [padded] | [chronicle_pad_left("[hails]", 5)] | [chronicle_pad_left(avg_min, 12)] | [favor]\n"
	out += "\n"
	return jointext(out, "")

/proc/chronicle_realm_hail_sort(a, b)
	if(!SSmerchant_trade)
		return 0
	var/ca = SSmerchant_trade.hails_by_realm[a] || 0
	var/cb = SSmerchant_trade.hails_by_realm[b] || 0
	return cb - ca

/proc/chronicle_pad_left(text, width)
	var/padded = "[text]"
	while(length(padded) < width)
		padded = " [padded]"
	return padded

/proc/chronicle_pad_right(text, width)
	var/padded = "[text]"
	while(length(padded) < width)
		padded = "[padded] "
	return padded

/proc/chronicle_section_navigator_buckets()
	var/list/out = list()
	if(!SSmerchant_trade)
		out += chronicle_section_header("Navigator Buckets")
		out += "  (SSmerchant_trade not initialized)\n\n"
		return jointext(out, "")
	out += chronicle_section_header("Navigator Buckets — Real Market")
	out += "  Bucket               | Sold   | Ship Relieved\n"
	for(var/bucket in SSmerchant_trade.pool_capacity)
		var/sold = SSmerchant_trade.lifetime_pool_credited[bucket] || 0
		var/relieved = SSmerchant_trade.lifetime_pool_relieved[bucket] || 0
		out += "  [chronicle_pad_right(bucket, 20)] | [chronicle_pad_left("[sold]", 6)] | [relieved]\n"
	out += "\n"
	out += chronicle_section_header("Navigator Buckets — Black Market")
	out += "  Bucket               | Sold\n"
	for(var/bucket in SSmerchant_trade.bm_pool_capacity)
		var/sold = SSmerchant_trade.lifetime_bm_pool_credited[bucket] || 0
		out += "  [chronicle_pad_right(bucket, 20)] | [sold]\n"
	out += "\n"
	return jointext(out, "")

/proc/chronicle_section_banking()
	var/list/out = list()
	out += chronicle_section_header("Banking & Stockpile")
	out += chronicle_kv("Mammons circulating", "[GLOB.azure_round_stats[STATS_MAMMONS_HELD]]")
	out += chronicle_kv("Mammons deposited", "[GLOB.azure_round_stats[STATS_MAMMONS_DEPOSITED]]")
	out += chronicle_kv("Mammons withdrawn", "[GLOB.azure_round_stats[STATS_MAMMONS_WITHDRAWN]]")
	out += chronicle_kv("Stockpile exports value", "[GLOB.azure_round_stats[STATS_STOCKPILE_EXPORTS_VALUE]]")
	out += chronicle_kv("Stockpile imports value", "[GLOB.azure_round_stats[STATS_STOCKPILE_IMPORTS_VALUE]]")
	out += chronicle_kv("Stockpile revenue", "[GLOB.azure_round_stats[STATS_STOCKPILE_REVENUE]]")
	out += chronicle_kv("Stockpile expanses (sold to)", "[GLOB.azure_round_stats[STATS_STOCKPILE_EXPANSES]]")
	out += chronicle_kv("Bathmatron vault revenue", "[GLOB.azure_round_stats[STATS_BATHMATRON_VAULT_TOTAL_REVENUE]]")
	out += chronicle_kv("Noble estates revenue", "[GLOB.azure_round_stats[STATS_NOBLE_INCOME_TOTAL]]")
	out += chronicle_kv("Loans issued", "[GLOB.azure_round_stats[STATS_LOANS_ISSUED]]")
	out += chronicle_kv("Loans defaulted", "[GLOB.azure_round_stats[STATS_LOANS_DEFAULTED]]")
	out += "\n"
	return jointext(out, "")

/proc/chronicle_section_contracts()
	var/list/out = list()
	out += chronicle_section_header("Guild Contracts")
	out += chronicle_kv("Generated (total / pool / rumor / def)", "[GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED]] / [GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED_POOL]] / [GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED_RUMOR]] / [GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED_DEFENSE]]")
	out += chronicle_kv("Taken (total / pool / rumor / def)", "[GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN]] / [GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN_POOL]] / [GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN_RUMOR]] / [GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN_DEFENSE]]")
	out += chronicle_kv("Completed (total / pool / rumor / def)", "[GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED]] / [GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED_POOL]] / [GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED_RUMOR]] / [GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED_DEFENSE]]")
	out += chronicle_kv("Abandoned / Rerolled", "[GLOB.azure_round_stats[STATS_CONTRACTS_ABANDONED]] / [GLOB.azure_round_stats[STATS_CONTRACTS_REROLLED]]")
	out += chronicle_kv("Mammons paid / taxed / forfeited", "[GLOB.azure_round_stats[STATS_CONTRACT_MAMMONS_PAID]] / [GLOB.azure_round_stats[STATS_CONTRACT_MAMMONS_TAXED]] / [GLOB.azure_round_stats[STATS_CONTRACT_MAMMONS_FORFEITED]]")
	out += "\n"
	return jointext(out, "")

/proc/chronicle_section_events()
	var/list/out = list()
	out += chronicle_section_header("Econ Events & Blockades")
	out += chronicle_kv("Econ events fired / expired", "[GLOB.azure_round_stats[STATS_ECON_EVENTS_FIRED]] / [GLOB.azure_round_stats[STATS_ECON_EVENTS_EXPIRED]]")
	out += chronicle_kv("Urgent orders spawned", "[GLOB.azure_round_stats[STATS_URGENT_ORDERS_SPAWNED]]")
	out += chronicle_kv("Shortages ended", "[GLOB.azure_round_stats[STATS_SHORTAGES_ENDED]]")
	out += chronicle_kv("Blockades fired / cleared", "[GLOB.azure_round_stats[STATS_BLOCKADES_FIRED]] / [GLOB.azure_round_stats[STATS_BLOCKADES_CLEARED]]")
	out += chronicle_kv("Blockade contracts failed", "[GLOB.azure_round_stats[STATS_BLOCKADE_CONTRACTS_FAILED]]")
	out += chronicle_kv("Blockade rewards paid", "[GLOB.azure_round_stats[STATS_BLOCKADE_REWARDS_PAID]]")
	out += "\n"
	return jointext(out, "")

/proc/chronicle_section_favors()
	var/list/out = list()
	out += chronicle_section_header("Royal Favors & Merchant Favor")
	out += chronicle_kv("Standing orders fulfilled / expired / petitioned", "[GLOB.azure_round_stats[STATS_STANDING_ORDERS_FULFILLED]] / [GLOB.azure_round_stats[STATS_STANDING_ORDERS_EXPIRED]] / [GLOB.azure_round_stats[STATS_STANDING_ORDERS_PETITIONED]]")
	out += chronicle_kv("Petition pledge spent", "[GLOB.azure_round_stats[STATS_PETITION_PLEDGE_SPENT]]")
	out += chronicle_kv("Pledge generated / consumed", "[GLOB.azure_round_stats[STATS_PLEDGE_GENERATED]] / [GLOB.azure_round_stats[STATS_PLEDGE_CONSUMED]]")
	out += chronicle_kv("Rumor points generated / consumed", "[GLOB.azure_round_stats[STATS_RUMOR_POINTS_GENERATED]] / [GLOB.azure_round_stats[STATS_RUMOR_POINTS_CONSUMED]]")
	if(SSmerchant_trade)
		out += chronicle_kv("Merchant favor (current / peak)", "[SSmerchant_trade.merchant_favor] / [SSmerchant_trade.merchant_favor_high]")
		out += chronicle_kv("  from send-offs", "[SSmerchant_trade.favor_from_sendoffs]")
		out += chronicle_kv("  from navigator", "[SSmerchant_trade.favor_from_navigator]")
		out += chronicle_kv("  from goldface", "[SSmerchant_trade.favor_from_goldface]")
		out += chronicle_kv("  from silverface", "[SSmerchant_trade.favor_from_silverface]")
		out += chronicle_kv("  penalties (dishonor)", "[SSmerchant_trade.favor_penalties]")
	out += "\n"
	return jointext(out, "")

/proc/chronicle_section_combat()
	var/list/out = list()
	out += chronicle_section_header("Combat")
	out += chronicle_kv("Total deaths / Noble / Humen", "[GLOB.azure_round_stats[STATS_DEATHS]] / [GLOB.azure_round_stats[STATS_NOBLE_DEATHS]] / [GLOB.azure_round_stats[STATS_HUMEN_DEATHS]]")
	out += chronicle_kv("Revivals (Astrata / Lux)", "[GLOB.azure_round_stats[STATS_ASTRATA_REVIVALS]] / [GLOB.azure_round_stats[STATS_LUX_REVIVALS]]")
	out += chronicle_kv("Crits / Parries / Yields / Warcries", "[GLOB.azure_round_stats[STATS_CRITS_MADE]] / [GLOB.azure_round_stats[STATS_PARRIES]] / [GLOB.azure_round_stats[STATS_YIELDS]] / [GLOB.azure_round_stats[STATS_WARCRIES]]")
	out += chronicle_kv("People Smitten / Ankles Broken / Moat Fallers", "[GLOB.azure_round_stats[STATS_PEOPLE_SMITTEN]] / [GLOB.azure_round_stats[STATS_ANKLES_BROKEN]] / [GLOB.azure_round_stats[STATS_MOAT_FALLERS]]")
	out += "\n"
	return jointext(out, "")
