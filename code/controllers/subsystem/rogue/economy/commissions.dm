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

/datum/controller/subsystem/economy/proc/deliver_commission(datum/commission_order/order)
	commission_orders -= order
	var/area/warehouse = GLOB.areas_by_type[/area/rogue/indoors/town/warehouse]
	if(!warehouse)
		return
	var/list/turfs = list()
	for(var/turf/T in warehouse)
		turfs += T
	if(!length(turfs))
		return
	var/turf/drop = pick(turfs)
	var/obj/structure/closet/crate/chest/steward/crate = new(drop)
	crate.name = lowertext(order.commission.name)
	for(var/path in order.commission.contains)
		for(var/i in 1 to (order.commission.contains[path] || 1))
			new path(crate)
	playsound(drop, 'sound/misc/hiss.ogg', 100, FALSE, -1)

/datum/controller/subsystem/economy/proc/restock_commissions()
	for(var/datum/royal_commission/C as anything in GLOB.royal_commissions)
		C.restock()
