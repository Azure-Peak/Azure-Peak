GLOBAL_DATUM(economic_chronicle, /datum/economic_chronicle)

/proc/get_economic_chronicle()
	if(!GLOB.economic_chronicle)
		GLOB.economic_chronicle = new /datum/economic_chronicle()
	return GLOB.economic_chronicle

/datum/economic_chronicle

/datum/economic_chronicle/ui_state(mob/user)
	return GLOB.always_state

/datum/economic_chronicle/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "EconomicChronicle", "Realm Economics")
		ui.open()
		ui.set_autoupdate(FALSE)

/datum/economic_chronicle/ui_static_data(mob/user)
	var/list/data = list()
	data["treasury_balance"] = SStreasury ? SStreasury.discretionary_fund?.balance : 0
	data["treasury"] = build_treasury_snapshot()
	data["economy"] = build_economy_snapshot()
	data["ships"] = build_ship_activity_snapshot()
	data["buckets"] = build_navigator_bucket_snapshot()
	data["contracts"] = build_contracts_snapshot()
	data["royal_favors"] = build_royal_favors_snapshot()
	return data

/datum/economic_chronicle/proc/build_treasury_snapshot()
	var/list/poll = list(
		"total" = GLOB.azure_round_stats[STATS_POLL_TAX_COLLECTED] || 0,
		"noble" = GLOB.azure_round_stats[STATS_POLL_TAX_NOBLE] || 0,
		"clergy" = GLOB.azure_round_stats[STATS_POLL_TAX_CLERGY] || 0,
		"inquisition" = GLOB.azure_round_stats[STATS_POLL_TAX_INQUISITION] || 0,
		"courtier" = GLOB.azure_round_stats[STATS_POLL_TAX_COURTIER] || 0,
		"garrison" = GLOB.azure_round_stats[STATS_POLL_TAX_GARRISON] || 0,
		"guilds" = GLOB.azure_round_stats[STATS_POLL_TAX_GUILDS] || 0,
		"merchant" = GLOB.azure_round_stats[STATS_POLL_TAX_MERCHANT] || 0,
		"burgher" = GLOB.azure_round_stats[STATS_POLL_TAX_BURGHER] || 0,
		"adventurer" = GLOB.azure_round_stats[STATS_POLL_TAX_ADVENTURER] || 0,
		"mercenary" = GLOB.azure_round_stats[STATS_POLL_TAX_MERCENARY] || 0,
		"peasant" = GLOB.azure_round_stats[STATS_POLL_TAX_PEASANT] || 0,
	)
	var/contract_levy = GLOB.azure_round_stats[STATS_REVENUE_CONTRACT_LEVY] || 0
	var/headeater_levy = GLOB.azure_round_stats[STATS_REVENUE_HEADEATER_LEVY] || 0
	var/import_tariff = GLOB.azure_round_stats[STATS_REVENUE_IMPORT_TARIFF] || 0
	var/export_duty = GLOB.azure_round_stats[STATS_REVENUE_EXPORT_DUTY] || 0
	var/royal_taxes_total = GLOB.azure_round_stats[STATS_TAXES_COLLECTED] || 0
	var/other_fees = max(0, royal_taxes_total - (contract_levy + headeater_levy + import_tariff + export_duty))
	var/list/royal = list(
		"total" = royal_taxes_total,
		"contract_levy" = contract_levy,
		"headeater_levy" = headeater_levy,
		"import_tariff" = import_tariff,
		"export_duty" = export_duty,
		"other_fees" = other_fees,
	)
	var/exempt_contract = GLOB.azure_round_stats[STATS_EXEMPTED_CONTRACT_LEVY] || 0
	var/exempt_headeater = GLOB.azure_round_stats[STATS_EXEMPTED_HEADEATER_LEVY] || 0
	var/exempt_import = GLOB.azure_round_stats[STATS_EXEMPTED_IMPORT_TARIFF] || 0
	var/exempt_export = GLOB.azure_round_stats[STATS_EXEMPTED_EXPORT_DUTY] || 0
	var/exempt_fine = GLOB.azure_round_stats[STATS_EXEMPTED_FINE] || 0
	var/exempt_poll = GLOB.azure_round_stats[STATS_EXEMPTED_POLL_TAX] || 0
	var/exempt_total = exempt_contract + exempt_headeater + exempt_import + exempt_export + exempt_fine + exempt_poll
	var/list/exempt = list(
		"total" = exempt_total,
		"contract" = exempt_contract,
		"headeater" = exempt_headeater,
		"import" = exempt_import,
		"export" = exempt_export,
		"fines" = exempt_fine,
		"poll_tax" = exempt_poll,
	)
	var/list/standing = list(
		"revenue" = GLOB.azure_round_stats[STATS_STANDING_ORDER_REVENUE] || 0,
		"fulfilled" = GLOB.azure_round_stats[STATS_STANDING_ORDERS_FULFILLED] || 0,
		"expired" = GLOB.azure_round_stats[STATS_STANDING_ORDERS_EXPIRED] || 0,
		"petitioned" = GLOB.azure_round_stats[STATS_STANDING_ORDERS_PETITIONED] || 0,
		"petition_pledge_spent" = GLOB.azure_round_stats[STATS_PETITION_PLEDGE_SPENT] || 0,
	)
	var/banditry_losses = GLOB.azure_round_stats[STATS_BANDITRY_LOSSES] || 0
	var/total_revenue = (GLOB.azure_round_stats[STATS_STARTING_TREASURY] || 0) + (GLOB.azure_round_stats[STATS_RURAL_TAXES_COLLECTED] || 0) + royal_taxes_total + (GLOB.azure_round_stats[STATS_FINES_INCOME] || 0) + poll["total"] + (GLOB.azure_round_stats[STATS_STOCKPILE_EXPORTS_VALUE] || 0) + (GLOB.azure_round_stats[STATS_STOCKPILE_REVENUE] || 0) + standing["revenue"]
	var/total_expenses = (GLOB.azure_round_stats[STATS_WAGES_PAID] || 0) + (GLOB.azure_round_stats[STATS_DIRECT_TREASURY_TRANSFERS] || 0) + (GLOB.azure_round_stats[STATS_STOCKPILE_IMPORTS_VALUE] || 0) + banditry_losses
	var/taxable_activity = royal_taxes_total + (GLOB.azure_round_stats[STATS_TAXES_EVADED] || 0)
	var/effective_tax_rate = taxable_activity > 0 ? round((royal_taxes_total / taxable_activity) * 100, 0.1) : null
	var/all_revenue_streams = royal_taxes_total + (GLOB.azure_round_stats[STATS_FINES_INCOME] || 0) + poll["total"] + exempt_total
	var/exemption_share = all_revenue_streams > 0 ? round((exempt_total / all_revenue_streams) * 100, 0.1) : null
	return list(
		"starting" = GLOB.azure_round_stats[STATS_STARTING_TREASURY] || 0,
		"rural_taxes" = GLOB.azure_round_stats[STATS_RURAL_TAXES_COLLECTED] || 0,
		"poll" = poll,
		"royal" = royal,
		"exempt" = exempt,
		"fines_income" = GLOB.azure_round_stats[STATS_FINES_INCOME] || 0,
		"stockpile_exports" = GLOB.azure_round_stats[STATS_STOCKPILE_EXPORTS_VALUE] || 0,
		"stockpile_revenue" = GLOB.azure_round_stats[STATS_STOCKPILE_REVENUE] || 0,
		"stockpile_direct_imports" = GLOB.azure_round_stats[STATS_STOCKPILE_DIRECT_IMPORTS] || 0,
		"standing" = standing,
		"shortages_ended" = GLOB.azure_round_stats[STATS_SHORTAGES_ENDED] || 0,
		"wages_paid" = GLOB.azure_round_stats[STATS_WAGES_PAID] || 0,
		"treasury_transfers" = GLOB.azure_round_stats[STATS_DIRECT_TREASURY_TRANSFERS] || 0,
		"stockpile_imports" = GLOB.azure_round_stats[STATS_STOCKPILE_IMPORTS_VALUE] || 0,
		"banditry_losses" = banditry_losses,
		"banditry_owed" = GLOB.azure_round_stats[STATS_BANDITRY_DEBT_OUTSTANDING] || 0,
		"treasury_debt_repaid" = GLOB.azure_round_stats[STATS_TREASURY_DEBT_REPAID] || 0,
		"treasury_debt_owed" = GLOB.azure_round_stats[STATS_TREASURY_DEBT_OUTSTANDING] || 0,
		"bankruptcy_count" = GLOB.azure_round_stats[STATS_BANKRUPTCY_DECLARED] || 0,
		"arrears_count" = GLOB.azure_round_stats[STATS_ARREARS_DECLARED] || 0,
		"forfeiture_amount" = GLOB.azure_round_stats[STATS_FORFEITURE_AMOUNT] || 0,
		"forfeiture_count" = GLOB.azure_round_stats[STATS_FORFEITURE_COUNT] || 0,
		"total_revenue" = total_revenue,
		"total_expenses" = total_expenses,
		"net_treasury" = total_revenue - total_expenses,
		"trade_balance" = (GLOB.azure_round_stats[STATS_STOCKPILE_EXPORTS_VALUE] || 0) - (GLOB.azure_round_stats[STATS_STOCKPILE_IMPORTS_VALUE] || 0),
		"foreign_trade_volume" = (GLOB.azure_round_stats[STATS_TRADE_VALUE_EXPORTED] || 0) + (GLOB.azure_round_stats[STATS_TRADE_VALUE_EXPORTED_BM] || 0) + (GLOB.azure_round_stats[STATS_TRADE_VALUE_IMPORTED] || 0),
		"effective_tax_rate" = effective_tax_rate,
		"exemption_share" = exemption_share,
		"taxes_evaded" = GLOB.azure_round_stats[STATS_TAXES_EVADED] || 0,
	)

/datum/economic_chronicle/proc/build_economy_snapshot()
	var/trade_exported_real = GLOB.azure_round_stats[STATS_TRADE_VALUE_EXPORTED] || 0
	var/trade_exported_bm = GLOB.azure_round_stats[STATS_TRADE_VALUE_EXPORTED_BM] || 0
	return list(
		"mammons_held" = GLOB.azure_round_stats[STATS_MAMMONS_HELD] || 0,
		"mammons_deposited" = GLOB.azure_round_stats[STATS_MAMMONS_DEPOSITED] || 0,
		"mammons_withdrawn" = GLOB.azure_round_stats[STATS_MAMMONS_WITHDRAWN] || 0,
		"noble_income" = GLOB.azure_round_stats[STATS_NOBLE_INCOME_TOTAL] || 0,
		"bathmatron_vault" = GLOB.azure_round_stats[STATS_BATHMATRON_VAULT_TOTAL_REVENUE] || 0,
		"sold_to_stockpile" = GLOB.azure_round_stats[STATS_STOCKPILE_EXPANSES] || 0,
		"taxes_evaded" = GLOB.azure_round_stats[STATS_TAXES_EVADED] || 0,
		"trade_exported_real" = trade_exported_real,
		"trade_exported_bm" = trade_exported_bm,
		"trade_exported_total" = trade_exported_real + trade_exported_bm,
		"trade_imported" = GLOB.azure_round_stats[STATS_TRADE_VALUE_IMPORTED] || 0,
		"merchant_levy_collected" = SSmerchant_trade ? SSmerchant_trade.merchant_levy_collected : 0,
		"merchant_levy_taxed" = SSmerchant_trade ? SSmerchant_trade.merchant_levy_taxed : 0,
		"gnome_margin" = SSmerchant_trade ? SSmerchant_trade.gnome_margin_collected : 0,
		"favor_from_sendoffs" = SSmerchant_trade ? SSmerchant_trade.favor_from_sendoffs : 0,
		"favor_from_navigator" = SSmerchant_trade ? SSmerchant_trade.favor_from_navigator : 0,
		"favor_from_goldface" = SSmerchant_trade ? SSmerchant_trade.favor_from_goldface : 0,
		"favor_from_silverface" = SSmerchant_trade ? SSmerchant_trade.favor_from_silverface : 0,
		"favor_penalties" = SSmerchant_trade ? SSmerchant_trade.favor_penalties : 0,
		"favor_high" = SSmerchant_trade ? SSmerchant_trade.merchant_favor_high : 0,
		"goldface" = GLOB.azure_round_stats[STATS_GOLDFACE_VALUE_SPENT] || 0,
		"silverface" = GLOB.azure_round_stats[STATS_SILVERFACE_VALUE_SPENT] || 0,
		"copperface" = GLOB.azure_round_stats[STATS_COPPERFACE_VALUE_SPENT] || 0,
		"purity" = GLOB.azure_round_stats[STATS_PURITY_VALUE_SPENT] || 0,
		"peddler" = GLOB.azure_round_stats[STATS_PEDDLER_REVENUE] || 0,
	)

/datum/economic_chronicle/proc/build_ship_activity_snapshot()
	var/list/realms = list()
	var/total_hails = 0
	if(SSmerchant_trade)
		for(var/realm_id in SSmerchant_trade.hails_by_realm)
			total_hails += SSmerchant_trade.hails_by_realm[realm_id]
		for(var/realm_id in SSmerchant_trade.realms)
			var/datum/foreign_realm/realm = SSmerchant_trade.realms[realm_id]
			var/realm_name = realm ? realm.name : realm_id
			var/hails = SSmerchant_trade.hails_by_realm[realm_id] || 0
			var/list/durations = SSmerchant_trade.dock_durations_by_realm[realm_id]
			var/avg_min = null
			if(LAZYLEN(durations))
				var/total_ds = 0
				for(var/d in durations)
					total_ds += d
				avg_min = round((total_ds / length(durations)) / 600, 0.1)
			var/favor = SSmerchant_trade.favor_earned_by_realm[realm_id] || 0
			realms += list(list(
				"name" = realm_name,
				"hails" = hails,
				"avg_dock_min" = avg_min,
				"favor_earned" = favor,
			))
	sortTim(realms, GLOBAL_PROC_REF(cmp_realm_hails_desc))
	return list(
		"realms" = realms,
		"total_hails" = total_hails,
	)

/datum/economic_chronicle/proc/build_navigator_bucket_snapshot()
	var/list/real = list()
	var/list/bm = list()
	if(SSmerchant_trade)
		for(var/bucket in SSmerchant_trade.pool_capacity)
			real += list(list(
				"name" = bucket,
				"sold" = SSmerchant_trade.lifetime_pool_credited[bucket] || 0,
				"relieved" = SSmerchant_trade.lifetime_pool_relieved[bucket] || 0,
			))
		for(var/bucket in SSmerchant_trade.bm_pool_capacity)
			bm += list(list(
				"name" = bucket,
				"sold" = SSmerchant_trade.lifetime_bm_pool_credited[bucket] || 0,
			))
	return list(
		"real" = real,
		"black_market" = bm,
	)

/datum/economic_chronicle/proc/build_contracts_snapshot()
	return list(
		"generated_total" = GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED] || 0,
		"generated_pool" = GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED_POOL] || 0,
		"generated_rumor" = GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED_RUMOR] || 0,
		"generated_defense" = GLOB.azure_round_stats[STATS_CONTRACTS_GENERATED_DEFENSE] || 0,
		"taken_total" = GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN] || 0,
		"taken_pool" = GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN_POOL] || 0,
		"taken_rumor" = GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN_RUMOR] || 0,
		"taken_defense" = GLOB.azure_round_stats[STATS_CONTRACTS_TAKEN_DEFENSE] || 0,
		"completed_total" = GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED] || 0,
		"completed_pool" = GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED_POOL] || 0,
		"completed_rumor" = GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED_RUMOR] || 0,
		"completed_defense" = GLOB.azure_round_stats[STATS_CONTRACTS_COMPLETED_DEFENSE] || 0,
		"abandoned" = GLOB.azure_round_stats[STATS_CONTRACTS_ABANDONED] || 0,
		"rerolled" = GLOB.azure_round_stats[STATS_CONTRACTS_REROLLED] || 0,
		"mammons_paid" = GLOB.azure_round_stats[STATS_CONTRACT_MAMMONS_PAID] || 0,
		"mammons_taxed" = GLOB.azure_round_stats[STATS_CONTRACT_MAMMONS_TAXED] || 0,
		"mammons_forfeited" = GLOB.azure_round_stats[STATS_CONTRACT_MAMMONS_FORFEITED] || 0,
	)

/datum/economic_chronicle/proc/build_royal_favors_snapshot()
	var/pledge_gen = GLOB.azure_round_stats[STATS_PLEDGE_GENERATED] || 0
	var/pledge_con = GLOB.azure_round_stats[STATS_PLEDGE_CONSUMED] || 0
	var/rumor_gen = GLOB.azure_round_stats[STATS_RUMOR_POINTS_GENERATED] || 0
	var/rumor_con = GLOB.azure_round_stats[STATS_RUMOR_POINTS_CONSUMED] || 0
	return list(
		"pledge_generated" = pledge_gen,
		"pledge_consumed" = pledge_con,
		"pledge_unused" = max(0, pledge_gen - pledge_con),
		"rumor_generated" = rumor_gen,
		"rumor_consumed" = rumor_con,
		"rumor_unused" = max(0, rumor_gen - rumor_con),
	)
