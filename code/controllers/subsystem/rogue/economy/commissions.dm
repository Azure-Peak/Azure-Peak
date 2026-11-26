/datum/commission_order
	var/datum/royal_commission/commission
	var/arrive_at

/datum/controller/subsystem/economy/proc/commission_blocker(datum/royal_commission/C)
	if(C.stock <= 0)
		return "The Royal Armoury takes no more [C.name] commissions today."
	var/price = C.get_price()
	if(SStreasury.discretionary_fund.balance < price)
		return "The Treasury can't afford this. It has [format_mammon(SStreasury.discretionary_fund.balance)]m and needs [format_mammon(price)]m."
	return null

/datum/controller/subsystem/economy/proc/place_commission(mob/user, datum/royal_commission/C)
	var/blocker = commission_blocker(C)
	if(blocker)
		if(user)
			to_chat(user, span_warning(blocker))
		return FALSE
	var/price = C.get_price()
	if(!SStreasury.burn(SStreasury.discretionary_fund, price, "Royal Commission: [C.name]", LEDGER_CROWN_EXP_COMMISSIONS))
		if(user)
			to_chat(user, span_warning("The Treasury can't afford this. It has [format_mammon(SStreasury.discretionary_fund.balance)]m and needs [format_mammon(price)]m."))
		return FALSE
	C.stock--
	var/datum/commission_order/order = new()
	order.commission = C
	order.arrive_at = world.time + COMMISSION_LEAD_TIME
	commission_orders += order
	addtimer(CALLBACK(src, PROC_REF(deliver_commission), order), COMMISSION_LEAD_TIME)
	log_game("ROYAL COMMISSION [C.name] placed by [user ? key_name(user) : "system"] (-[format_mammon(price)]m)")
	if(user)
		to_chat(user, span_notice("The Royal Armoury accepted the commission. The [C.name] will arrive at the warehouse in [DisplayTimeText(COMMISSION_LEAD_TIME)]."))
	return TRUE

/datum/controller/subsystem/economy/proc/warehouse_drop_turf()
	var/area/warehouse = GLOB.areas_by_type[/area/rogue/indoors/town/warehouse]
	if(!warehouse)
		return null
	var/list/turfs = list()
	for(var/turf/T in warehouse)
		if(isopenturf(T) && !is_blocked_turf(T))
			turfs += T
	if(!length(turfs))
		return null
	return pick(turfs)

/datum/controller/subsystem/economy/proc/deliver_commission(datum/commission_order/order)
	commission_orders -= order
	if(SStreasury.steward_machine)
		SStgui.update_uis(SStreasury.steward_machine)
	var/turf/drop = warehouse_drop_turf()
	if(!drop)
		return
	var/obj/structure/closet/crate/chest/steward/crate = new(drop)
	crate.name = LOWER_TEXT(order.commission.name)
	for(var/path in order.commission.contains)
		for(var/i in 1 to (order.commission.contains[path] || 1))
			new path(crate)
	playsound(drop, 'sound/misc/hiss.ogg', 100, FALSE, -1)

/datum/controller/subsystem/economy/proc/restock_commissions()
	for(var/datum/royal_commission/C as anything in GLOB.royal_commissions)
		C.restock()

/datum/controller/subsystem/economy/proc/local_commission_blocker(datum/crown_import/D)
	if(D.stock <= 0)
		return "None left today."
	var/price = D.get_import_price()
	if(SStreasury.discretionary_fund.balance < price)
		return "The Treasury can't afford this. It has [format_mammon(SStreasury.discretionary_fund.balance)]m and needs [format_mammon(price)]m."
	return null

/datum/controller/subsystem/economy/proc/place_local_commission(mob/user, datum/crown_import/D)
	var/blocker = local_commission_blocker(D)
	if(blocker)
		if(user)
			to_chat(user, span_warning(blocker))
		return FALSE
	var/price = D.get_import_price()
	if(!SStreasury.burn(SStreasury.discretionary_fund, price, "imported [D.name]", LEDGER_CROWN_EXP_IMPORTS))
		if(user)
			to_chat(user, span_warning("The Treasury can't afford this. It has [format_mammon(SStreasury.discretionary_fund.balance)]m and needs [format_mammon(price)]m."))
		return FALSE
	D.stock--
	SStreasury.total_import += price
	record_round_statistic(STATS_STOCKPILE_IMPORTS_VALUE, price)
	record_treasury_expense(TREASURY_FLOW_IMPORT, treasury_role_of(user), price)
	var/turf/drop = warehouse_drop_turf()
	if(drop)
		for(var/i in 1 to D.import_amt)
			new D.item_type(drop)
			record_material_flow(MATERIAL_FLOW_IN, MATERIAL_SOURCE_LOCAL_IMPORT, D.item_type, 1)
		playsound(drop, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	log_game("LOCAL COMMISSION [D.name] placed by [user ? key_name(user) : "system"] (-[format_mammon(price)]m)")
	if(user)
		to_chat(user, span_notice("The [D.name] is delivered to the warehouse."))
	return TRUE
