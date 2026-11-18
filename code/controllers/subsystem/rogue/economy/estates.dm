/datum/noble_estate
	var/region_id = TRADE_REGION_KINGSFIELD
	var/tier = ESTATE_TIER_NONE
	var/coin_override = 0
	var/undelivered_days = 0
	var/undelivered_gifts = 0

/datum/noble_estate/proc/daily_income()
	if(coin_override)
		return coin_override
	switch(tier)
		if(ESTATE_TIER_LORD)
			return ESTATE_COIN_LORD
		if(ESTATE_TIER_HIGH)
			return ESTATE_COIN_HIGH
		if(ESTATE_TIER_NORMAL)
			return ESTATE_COIN_NORMAL
	return 0

/datum/noble_estate/proc/parcels_per_day()
	switch(tier)
		if(ESTATE_TIER_LORD)
			return ESTATE_PARCELS_LORD
		if(ESTATE_TIER_HIGH)
			return ESTATE_PARCELS_HIGH
		if(ESTATE_TIER_NORMAL)
			return ESTATE_PARCELS_NORMAL
	return 0

/datum/noble_estate/proc/get_region()
	if(tier == ESTATE_TIER_NONE)
		return null
	return GLOB.economic_regions[region_id] || GLOB.economic_regions[TRADE_REGION_KINGSFIELD]

/datum/controller/subsystem/economy/proc/estate_region_pref(mob/living/H, client/C)
	var/datum/preferences/prefs = C?.prefs || H.client?.prefs || GLOB.preferences_datums[ckey(H.mind?.key)]
	var/region_id = prefs?.estate_region
	if(!region_id || !GLOB.economic_regions[region_id])
		return TRADE_REGION_KINGSFIELD
	return region_id

/datum/controller/subsystem/economy/proc/register_estate(mob/living/H, tier = ESTATE_TIER_NONE, coin_override = 0, grant_now = TRUE, client/C)
	if(!H)
		return
	var/datum/noble_estate/E = estates[H]
	var/is_new = !E
	if(is_new)
		E = new()
		E.region_id = estate_region_pref(H, C)
		estates[H] = E
	E.tier = max(E.tier, tier)
	if(coin_override)
		E.coin_override = coin_override
	if(is_new && grant_now)
		SStreasury.grant_estate_income(H, E.daily_income(), TRUE)

/datum/controller/subsystem/economy/proc/pay_estates()
	var/gift_today = (ECONOMY_DAY % ESTATE_GIFT_INTERVAL) == 0
	for(var/mob/living/H as anything in estates.Copy())
		if(QDELETED(H))
			estates -= H
			continue
		var/datum/noble_estate/E = estates[H]
		var/datum/economic_region/region = E.get_region()
		if(!region)
			SStreasury.grant_estate_income(H, E.daily_income())
			continue
		if(HAS_TRAIT(H, TRAIT_OUTLAW))
			continue
		if(region.is_region_blockaded)
			E.undelivered_days++
			if(gift_today)
				E.undelivered_gifts++
			send_ooc_note("<b>MEISTER:</b> [region.name] is raided. Your estate income will not be delivered.", name = H.real_name)
			continue
		deliver_estate(H, E, 1 + E.undelivered_days, (gift_today ? 1 : 0) + E.undelivered_gifts)

/datum/controller/subsystem/economy/proc/release_estate_backlogs()
	for(var/mob/living/H as anything in estates)
		var/datum/noble_estate/E = estates[H]
		if(!E.undelivered_days || QDELETED(H) || HAS_TRAIT(H, TRAIT_OUTLAW))
			continue
		var/datum/economic_region/region = E.get_region()
		if(!region || region.is_region_blockaded)
			continue
		deliver_estate(H, E, E.undelivered_days, E.undelivered_gifts)

/datum/controller/subsystem/economy/proc/deliver_estate(mob/living/H, datum/noble_estate/E, days, gifts)
	E.undelivered_days = 0
	E.undelivered_gifts = 0
	var/datum/economic_region/region = E.get_region()
	SStreasury.grant_estate_income(H, E.daily_income() * days)
	var/obj/item/smallDelivery/parcel = new()
	parcel.name = "estate parcel"
	for(var/i in 1 to E.parcels_per_day() * days)
		var/list/goods = region.estate_parcel()
		for(var/path in goods)
			for(var/j in 1 to goods[path])
				new path(parcel)
	if(length(region.gifts))
		for(var/i in 1 to gifts)
			var/gift_type = pick(region.gifts)
			var/obj/item/gift = new gift_type(parcel)
			gift.AddComponent(/datum/component/unsellable)
	if(!length(parcel.contents))
		qdel(parcel)
		return
	if(!deliver_mail(parcel, H.real_name, "[region.name] Estate"))
		parcel.forceMove(get_turf(H))
