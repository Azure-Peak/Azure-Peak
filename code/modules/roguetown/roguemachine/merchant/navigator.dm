#define EXPORT_TIME 2 MINUTES
#define EXPORT_TIME_TESTING 5 SECONDS

/obj/item/roguemachine/navigator
	name = "navigator"
	desc = "A machine that attracts the attention of trading balloons."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "ballooner"
	density = TRUE
	blade_dulling = DULLING_BASH
	var/next_airlift
	max_integrity = 0
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
	/// A fixed tax on all items sold through the balloon that overrides queens tax. Used for blackmarket
	var/fixed_tax = 0
	var/grants_passive_favor = TRUE
	var/accepts_unmintable = FALSE
	/// Motto displayed at the top of the vendor interface
	var/motto = "NAVIGATOR - Your goods, airborne."
	/// When TRUE, Crown export duty is collected on seller gross AND on the Merchant's levy.
	var/pay_taxes = TRUE
	/// When TRUE, the Merchant's levy is collected from seller gross.
	var/pay_merchant_share = TRUE
	/// Jobs whose members may right-click to inspect dodge tallies.
	var/list/profit_id = list("Merchant", "Shophand")
	/// Running tally of Crown export duty actually collected via this specific navigator.
	var/duty_collected_here = 0
	/// Running tally of duty owed but dodged. Only shown to Merchant/Shophand.
	var/duty_evaded_here = 0
	/// Running tally of Merchant levy actually collected via this specific navigator.
	var/levy_collected_here = 0

/obj/item/roguemachine/navigator/examine()
	. = ..()
	var/export_time = EXPORT_TIME
	#ifdef LOCALTEST
	export_time = EXPORT_TIME_TESTING
	#endif
	. += span_notice("This machine attracts trading balloons every [DisplayTimeText(export_time)]. Goods are sucked into the air and mammons are dropped after tax has been collected.")

/obj/item/roguemachine/navigator/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Drop items on the tiles around the navigator. Trading balloons arrive periodically and lift the goods away, leaving mammon in change on this tile.")
	if(fixed_tax > 0)
		. += span_info("This navigator charges a fixed handler's fee of [fixed_tax * 100]% before any Crown duty. Smuggler-grade.")
	else
		. += span_info("The Crown's export duty is applied to the payout at the prevailing rate.")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.job in profit_id)
			. += span_info("Crown duty: <b>[pay_taxes ? "PAYING" : "DODGING"]</b>. Merchant's levy: <b>[pay_merchant_share ? "COLLECTING" : "WAIVED"]</b>.")

// 70% taxation and rip off to encourage people to risk it with merchant / others
/obj/item/roguemachine/navigator/smuggler
	name = "battered navigator"
	desc = "A crudely repaired navigator bolted to the hull of a leaky boat. It stinks of brine and contraband."
	motto = "NAVIGA??R - - ████ ██████ █████████ - FREEDOM OF TRANSACTION.."
	fixed_tax = 0.5
	pay_taxes = FALSE
	pay_merchant_share = FALSE
	grants_passive_favor = FALSE
	accepts_unmintable = TRUE

/obj/item/roguemachine/navigator/private
	name = "private navigator"
	desc = "A navigator kept under the Merchant's own roof."
	motto = "NAVIGATOR - Proprietor's berth."
	pay_taxes = TRUE
	pay_merchant_share = FALSE

/obj/item/roguemachine/navigator/smuggler/examine(mob/user)
	. = ..()
	. += span_notice("The rates here are disastrous. Having a facilitator from the bathhouse nearby might improve them to 100%.")
	. += span_notice("The handler asks no questions about provenance. Goods the legitimate market refuses to mint move through here all the same.")
	if(fixed_tax <= 0)
		. += span_notice("A facilitator is present. Current handler's fee: [fixed_tax * 100]%.")
	else
		. += span_warning("No facilitator present. Current handler's fee: [fixed_tax * 100]%.")

/obj/item/roguemachine/navigator/smuggler/process()
	if(!anchored)
		return TRUE
	if(world.time > next_airlift)
		var/bath_nearby = FALSE
		for(var/mob/living/carbon/human/H in range(7, src))
			if(H.stat != DEAD && (H.job in GLOB.bathhouse_positions))
				bath_nearby = TRUE
				break
		fixed_tax = bath_nearby ? 0.0 : 0.5
	return ..()

/obj/item/roguemachine/navigator/proc/get_market_saturation(category)
	if(!SSmerchant_trade || !category)
		return 1
	return SSmerchant_trade.get_saturation_factor(category)

/obj/item/roguemachine/navigator/proc/get_market_demand(category)
	if(!SSmerchant_trade || !category)
		return 1
	return SSmerchant_trade.get_demand_multiplier(category)

/obj/item/roguemachine/navigator/proc/credit_pool(category, base_price)
	if(!SSmerchant_trade || !category || base_price <= 0)
		return
	SSmerchant_trade.pool_consumed[category] = (SSmerchant_trade.pool_consumed[category] || 0) + base_price
	var/demand = SSmerchant_trade.pending_ship_demand[category] || 0
	var/drain = min(demand, base_price)
	if(drain > 0)
		SSmerchant_trade.pending_ship_demand[category] = demand - drain
		SSmerchant_trade.pending_ship_demand_satisfied[category] = (SSmerchant_trade.pending_ship_demand_satisfied[category] || 0) + drain

/obj/item/roguemachine/navigator/smuggler/get_market_saturation(category)
	if(!SSmerchant_trade || !category)
		return 1
	return SSmerchant_trade.get_bm_saturation_factor(category)

/obj/item/roguemachine/navigator/smuggler/get_market_demand(category)
	if(!SSmerchant_trade || !category)
		return 1
	return SSmerchant_trade.get_bm_demand_multiplier(category)

/obj/item/roguemachine/navigator/smuggler/credit_pool(category, base_price)
	if(!SSmerchant_trade || !category || base_price <= 0)
		return
	SSmerchant_trade.bm_pool_consumed[category] = (SSmerchant_trade.bm_pool_consumed[category] || 0) + base_price

/obj/structure/roguemachine/balloon_pad
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = ""
	density = FALSE
	layer = BELOW_OBJ_LAYER
	anchored = TRUE

/obj/item/roguemachine/navigator/attack_hand(mob/living/user)
	if(!anchored)
		return ..()
	user.changeNext_move(CLICK_CD_INTENTCAP)
	ui_interact(user)

/obj/item/roguemachine/navigator/attack_right(mob/user)
	if(!anchored)
		return ..()
	ui_interact(user)

/obj/item/roguemachine/navigator/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/item/roguemachine/navigator/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Navigator")
		ui.open()

/obj/item/roguemachine/navigator/ui_data(mob/user)
	return build_navigator_data(user)

/obj/item/roguemachine/navigator/proc/build_navigator_data(mob/user)
	var/list/data = list()
	data["motto"] = motto
	var/remaining = max(0, next_airlift - world.time)
	data["next_airlift_seconds"] = round(remaining / 10)
	data["handler_fee_percent"] = round(fixed_tax * 100)
	data["duty_rate"] = SStreasury ? SStreasury.get_tax_rate(TAX_CATEGORY_EXPORT_DUTY) : 0
	data["pay_taxes"] = pay_taxes
	data["levy_rate"] = SSmerchant_trade ? SSmerchant_trade.merchant_levy_percent : 0
	data["pay_merchant_share"] = pay_merchant_share
	data["duty_collected_here"] = duty_collected_here
	data["duty_evaded_here"] = duty_evaded_here
	data["levy_collected_here"] = levy_collected_here
	var/is_prop = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		is_prop = (H.job in profit_id)
	data["is_proprietor"] = is_prop
	data["is_smuggler"] = FALSE
	data["facilitator_present"] = FALSE
	data["is_readable"] = user ? user.can_read(src, TRUE) : TRUE
	data["market_data"] = build_navigator_market_data()
	return data

/obj/item/roguemachine/navigator/proc/build_navigator_market_data()
	var/list/data = list(
		"categories" = list(),
		"pop_snapshot" = 0,
		"category_count" = 0,
	)
	if(!SSmerchant_trade)
		return data
	data["pop_snapshot"] = SSmerchant_trade.pool_pop_snapshot
	var/list/rows = list()
	for(var/cat in SSmerchant_trade.pool_capacity)
		var/cap = SSmerchant_trade.pool_capacity[cat] || 0
		var/consumed = SSmerchant_trade.pool_consumed[cat] || 0
		var/fill_ratio = cap > 0 ? min(1, consumed / cap) : 0
		var/refused = SSmerchant_trade.get_saturation_factor(cat) <= 0
		var/demand_mult = SSmerchant_trade.get_demand_multiplier(cat)
		var/pending = SSmerchant_trade.pending_ship_demand[cat] || 0
		rows += list(list(
			"category" = cat,
			"capacity" = cap,
			"consumed" = consumed,
			"fill_ratio" = fill_ratio,
			"refused" = refused,
			"demand_mult" = demand_mult,
			"pending_ship_demand" = pending,
		))
	data["categories"] = rows
	data["category_count"] = length(rows)
	data["theme_dispatch"] = build_market_theme_dispatch(SSmerchant_trade.pool_theme_jitters)
	return data

/obj/item/roguemachine/navigator/smuggler/build_navigator_data(mob/user)
	var/list/data = ..()
	data["is_smuggler"] = TRUE
	data["duty_rate"] = 0
	data["pay_taxes"] = FALSE
	data["duty_collected_here"] = 0
	data["duty_evaded_here"] = 0
	data["facilitator_present"] = (fixed_tax <= 0)
	data["market_data"] = build_navigator_market_data()
	return data

/obj/item/roguemachine/navigator/smuggler/build_navigator_market_data()
	var/list/data = list(
		"categories" = list(),
		"pop_snapshot" = 0,
		"category_count" = 0,
	)
	if(!SSmerchant_trade)
		return data
	data["pop_snapshot"] = SSmerchant_trade.pool_pop_snapshot
	var/list/rows = list()
	for(var/cat in SSmerchant_trade.bm_pool_capacity)
		var/cap = SSmerchant_trade.bm_pool_capacity[cat] || 0
		var/consumed = SSmerchant_trade.bm_pool_consumed[cat] || 0
		var/fill_ratio = cap > 0 ? min(1, consumed / cap) : 0
		var/refused = SSmerchant_trade.get_bm_saturation_factor(cat) <= 0
		rows += list(list(
			"category" = cat,
			"capacity" = cap,
			"consumed" = consumed,
			"fill_ratio" = fill_ratio,
			"refused" = refused,
			"demand_mult" = 1.0,
			"pending_ship_demand" = 0,
		))
	data["categories"] = rows
	data["category_count"] = length(rows)
	return data

/obj/item/roguemachine/navigator/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = usr
	if(!istype(H))
		return TRUE
	if(!H.canUseTopic(src, BE_CLOSE))
		return TRUE
	if(!(H.job in profit_id))
		to_chat(H, span_warning("Only a Merchant may tamper with the Navigator's toll."))
		return TRUE
	switch(action)
		if("toggle_duty")
			pay_taxes = !pay_taxes
			to_chat(H, span_notice("The Navigator's toll clasp clicks. Crown duty: <b>[pay_taxes ? "PAYING" : "DODGING"]</b>."))
			playsound(loc, 'sound/misc/gold_misc.ogg', 80, FALSE, -1)
			return TRUE
		if("toggle_levy")
			pay_merchant_share = !pay_merchant_share
			to_chat(H, span_notice("The Navigator's toll clasp clicks. Merchant's levy: <b>[pay_merchant_share ? "COLLECTING" : "WAIVED"]</b>."))
			playsound(loc, 'sound/misc/gold_misc.ogg', 80, FALSE, -1)
			return TRUE

/obj/item/roguemachine/navigator/update_icon()
	if(!anchored)
		w_class = WEIGHT_CLASS_BULKY
		set_light(0)
		return
	w_class = WEIGHT_CLASS_GIGANTIC
	set_light(2, 2, 2, l_color = "#1b7bf1")

/obj/item/roguemachine/navigator/Initialize()
	. = ..()
	if(anchored)
		START_PROCESSING(SSroguemachine, src)
	update_icon()
	for(var/X in GLOB.alldirs)
		var/T = get_step(src, X)
		if(!T)
			continue
		new /obj/structure/roguemachine/balloon_pad(T)

/obj/item/roguemachine/navigator/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	set_light(0)
	return ..()

/obj/item/roguemachine/navigator/process()
	if(!anchored)
		return TRUE
	var/export_time = EXPORT_TIME
	#ifdef LOCALTEST
		export_time = EXPORT_TIME_TESTING
	#endif
	if(world.time > next_airlift)
		next_airlift = world.time + export_time
		var/play_sound = FALSE
		var/refused_announced = FALSE
		var/list/penalty_categories = list()
		var/list/boost_categories = list()
		for(var/D in GLOB.alldirs)
			var/budgie = 0
			var/turf/T = get_step(src, D)
			if(!T)
				continue
			var/obj/structure/roguemachine/balloon_pad/E = locate() in T
			if(!E)
				continue
			for(var/obj/I in T)
				if(I.anchored || !isturf(I.loc) || istype(I, /obj/item/roguecoin)|| istype(I, /obj/structure/handcart))
					continue
				if(isitem(I))
					var/obj/item/IT = I
					if(IT.atc_sealed)
						continue
					if(IT.unmintable && !accepts_unmintable)
						continue
				var/base_price = I.get_real_price()
				var/category = (GLOB.derived_categories && GLOB.derived_categories[I.type]) || ITEM_CAT_MISCELLANEOUS
				var/saturation_mult = get_market_saturation(category)
				var/demand_mult = get_market_demand(category)
				var/prize = round(base_price * saturation_mult * demand_mult * (1 - fixed_tax))
				if(prize >= 1)
					play_sound=TRUE
					budgie += prize
					credit_pool(category, base_price)
					I.visible_message(span_warning("[I] is sucked into the air!"))
					if(category)
						if(saturation_mult < 0.6 && !(category in penalty_categories))
							penalty_categories += category
						if(demand_mult > 1.15 && !(category in boost_categories))
							boost_categories += category
					qdel(I)
				else if(base_price > 0)
					if(!refused_announced)
						refused_announced = TRUE
						I.visible_message(span_warning("[I] is refused by the balloon - the market is choked."))
			budgie = round(budgie)
			record_round_statistic(STATS_TRADE_VALUE_EXPORTED, budgie)
			if(budgie > 0)
				play_sound = TRUE
				settle_export(budgie)
		if(play_sound)
			playsound(src.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		if(length(penalty_categories))
			visible_message(span_warning("The balloon reports a glut - prices on [english_list(penalty_categories)] have been cut short."))
		if(length(boost_categories))
			visible_message(span_notice("The balloon reports eager buyers - prices on [english_list(boost_categories)] were lifted higher."))

/// Parallel-bites payout. Crown duty and Merchant levy both come off gross; the levy is
/// itself subject to Crown income duty so the producer's tax base doesn't shrink because
/// the Merchant exists. Producer net drops on src tile, levy drops on the tile facing src.dir.
/obj/item/roguemachine/navigator/proc/settle_export(gross)
	var/duty_rate = SStreasury.get_tax_rate(TAX_CATEGORY_EXPORT_DUTY)
	var/levy_pct = SSmerchant_trade ? SSmerchant_trade.merchant_levy_percent : 0
	var/levy = pay_merchant_share ? round(gross * levy_pct / 100) : 0
	var/duty_on_gross = round(gross * duty_rate)
	var/duty_on_levy = round(levy * duty_rate)
	var/total_duty = duty_on_gross + duty_on_levy
	var/producer_net = gross - duty_on_gross - levy
	if(producer_net < 0)
		producer_net = 0
	var/merchant_net = levy - duty_on_levy
	if(merchant_net < 0)
		merchant_net = 0
	if(pay_taxes)
		if(duty_on_gross > 0)
			SStreasury.mint(SStreasury.discretionary_fund, duty_on_gross, "[TAX_CATEGORY_EXPORT_DUTY] ([src.name])")
			SStreasury.apply_concordat_tithe(gross, TAX_CATEGORY_EXPORT_DUTY, "[src.name]")
		if(duty_on_levy > 0)
			SStreasury.mint(SStreasury.discretionary_fund, duty_on_levy, "[TAX_CATEGORY_EXPORT_DUTY] (levy income, [src.name])")
			SStreasury.apply_concordat_tithe(levy, TAX_CATEGORY_EXPORT_DUTY, "levy income ([src.name])")
		if(total_duty > 0)
			record_round_statistic(STATS_TAXES_COLLECTED, total_duty)
			record_round_statistic(STATS_REVENUE_EXPORT_DUTY, total_duty)
			duty_collected_here += total_duty
			if(SSmerchant_trade)
				SSmerchant_trade.merchant_levy_taxed += duty_on_levy
	else
		if(total_duty > 0)
			record_round_statistic(STATS_TAXES_EVADED, total_duty)
			duty_evaded_here += total_duty
		merchant_net = levy
	if(merchant_net > 0)
		SStreasury.mint(SStreasury.merchant_fund, merchant_net, "Merchant's levy ([src.name])")
		levy_collected_here += merchant_net
		if(SSmerchant_trade)
			SSmerchant_trade.merchant_levy_collected += merchant_net
			SSmerchant_trade.log_fund_movement("Navigator levy ([src.name])", merchant_net)
	if(gross > 0 && SSmerchant_trade && grants_passive_favor)
		var/passive = round(gross * FAVOR_PASSIVE_TRADE_FRACTION)
		SSmerchant_trade.adjust_merchant_favor(passive)
		SSmerchant_trade.favor_from_navigator += passive
	var/turf/producer_turf = get_turf(src)
	if(producer_net > 0)
		budget2change(producer_net, custom_turf = producer_turf)
	var/list/parts = list("[gross] gross")
	if(levy > 0)
		parts += "[levy] merchant"
	if(total_duty > 0)
		parts += "[total_duty] taxed"
	parts += "[producer_net] net"
	visible_message(span_info("[src] chimes: \"[parts.Join(", ")].\""))

#undef EXPORT_TIME
#undef EXPORT_TIME_TESTING
