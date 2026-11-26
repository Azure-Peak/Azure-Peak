/proc/estate_choice_name(estate_id)
	if(estate_id == ESTATE_LANDLESS)
		return "Landless"
	var/datum/economic_region/region = GLOB.economic_regions[estate_id]
	if(region)
		return region.name
	var/datum/estate_realm/realm = GLOB.estate_realms[estate_id]
	return realm?.name

/proc/estate_good_names(list/estate_goods, weight)
	var/list/good_ids = list()
	for(var/good_id in estate_goods)
		if(estate_goods[good_id] == weight)
			good_ids += good_id
	return trade_good_names(good_ids)

/datum/noble_estate
	var/region_id = TRADE_REGION_KINGSFIELD
	var/rank = NOBLE_RANK_NONE
	var/pay_rank = NOBLE_RANK_NONE
	var/coin_override = 0
	var/undelivered_days = 0
	var/undelivered_gifts = 0
	var/unsent_parcels = 0
	var/unsent_gifts = 0

/datum/noble_estate/proc/daily_income()
	var/coin = coin_override
	if(!coin)
		switch(max(rank, pay_rank))
			if(NOBLE_RANK_ROYAL)
				coin = ESTATE_COIN_ROYAL
			if(NOBLE_RANK_PEER)
				coin = ESTATE_COIN_PEER
			if(NOBLE_RANK_GENTRY)
				coin = ESTATE_COIN_GENTRY
	if(get_realm())
		coin = whole_mammon(coin * (1 - ESTATE_FOREIGN_ATC_FEE))
	return coin

/datum/noble_estate/proc/parcels_per_day()
	var/parcels = 0
	switch(max(rank, pay_rank))
		if(NOBLE_RANK_ROYAL)
			parcels = ESTATE_PARCELS_ROYAL
		if(NOBLE_RANK_PEER)
			parcels = ESTATE_PARCELS_PEER
		if(NOBLE_RANK_GENTRY)
			parcels = ESTATE_PARCELS_GENTRY
	if(get_realm())
		parcels *= 1 - ESTATE_FOREIGN_ATC_FEE
	return parcels

/datum/noble_estate/proc/get_region()
	if(max(rank, pay_rank) == NOBLE_RANK_NONE || region_id == ESTATE_LANDLESS || GLOB.estate_realms[region_id])
		return null
	return GLOB.economic_regions[region_id] || GLOB.economic_regions[TRADE_REGION_KINGSFIELD]

/datum/noble_estate/proc/get_realm()
	if(max(rank, pay_rank) == NOBLE_RANK_NONE)
		return null
	return GLOB.estate_realms[region_id]

/datum/noble_estate/proc/estate_name()
	var/datum/economic_region/region = get_region()
	if(region)
		return region.name
	var/datum/estate_realm/realm = get_realm()
	return realm?.name

/datum/controller/subsystem/economy/proc/estate_region_pref(mob/living/H, client/C)
	var/datum/preferences/prefs = C?.prefs || H.client?.prefs || GLOB.preferences_datums[ckey(H.mind?.key)]
	var/region_id = prefs?.estate_region
	if(!estate_choice_name(region_id))
		return TRADE_REGION_KINGSFIELD
	return region_id

/datum/controller/subsystem/economy/proc/register_estate(mob/living/H, rank = NOBLE_RANK_NONE, coin_override = 0, grant_now = TRUE, client/C, pay_rank = NOBLE_RANK_NONE)
	if(!H)
		return
	var/datum/noble_estate/E = estates[H]
	var/is_new = !E
	if(is_new)
		E = new()
		E.region_id = estate_region_pref(H, C)
		estates[H] = E
	var/was_ranked = E.rank > NOBLE_RANK_NONE
	E.rank = max(E.rank, rank)
	E.pay_rank = max(E.pay_rank, pay_rank)
	if(!was_ranked && E.rank > NOBLE_RANK_NONE)
		var/estate_name = E.estate_name()
		if(estate_name)
			record_featured_object_stat(FEATURED_STATS_ESTATES, estate_name)
	if(ishuman(H))
		var/mob/living/carbon/human/human = H
		human.noble_rank = E.rank
	if(coin_override)
		E.coin_override = coin_override
	if(is_new && grant_now)
		SStreasury.grant_estate_income(H, E.daily_income(), TRUE)

/datum/controller/subsystem/economy/proc/pay_estates()
	var/gift_today = (ECONOMY_DAY % ESTATE_GIFT_INTERVAL) == 0
	var/ship_today = (ECONOMY_DAY % ESTATE_FOREIGN_INTERVAL) == 0
	for(var/mob/living/H as anything in estates.Copy())
		if(QDELETED(H))
			estates -= H
			continue
		var/datum/noble_estate/E = estates[H]
		var/datum/estate_realm/realm = E.get_realm()
		if(realm)
			if(HAS_TRAIT(H, TRAIT_OUTLAW))
				continue
			E.undelivered_days++
			if(gift_today)
				E.undelivered_gifts++
			if(ship_today)
				deliver_estate(H, E, E.undelivered_days, E.undelivered_gifts)
			continue
		var/datum/economic_region/region = E.get_region()
		if(!region)
			SStreasury.grant_estate_income(H, E.daily_income())
			continue
		if(HAS_TRAIT(H, TRAIT_OUTLAW))
			continue
		if(region.is_region_blockaded)
			E.undelivered_days++
			send_ooc_note("<b>MEISTER:</b> The route to your estate is blockaded, the parcel is lost and income will be held until it is cleared.", name = H.real_name)
			continue
		deliver_estate(H, E, 1 + E.undelivered_days, gift_today ? 1 : 0, 1)

/datum/controller/subsystem/economy/proc/release_estate_backlogs()
	for(var/mob/living/H as anything in estates)
		var/datum/noble_estate/E = estates[H]
		if(!E.undelivered_days || QDELETED(H) || HAS_TRAIT(H, TRAIT_OUTLAW))
			continue
		var/datum/economic_region/region = E.get_region()
		if(!region || region.is_region_blockaded)
			continue
		deliver_estate(H, E, E.undelivered_days, 0, 0)

/datum/controller/subsystem/economy/proc/estate_parcel(list/estate_goods)
	var/list/goods = list()
	var/list/valid = list()
	for(var/good_id in estate_goods)
		var/datum/trade_good/tg = GLOB.trade_goods[good_id]
		if(tg?.item_type && good_steady_price(good_id) > 0)
			valid[good_id] = estate_goods[good_id]
	if(!length(valid))
		return goods
	var/good_id = pickweight(valid)
	var/datum/trade_good/tg = GLOB.trade_goods[good_id]
	var/count = ESTATE_PARCEL_VALUE / good_steady_price(good_id)
	var/whole = round(count)
	goods[tg.item_type] = max(1, whole + prob((count - whole) * 100))
	return goods

/datum/controller/subsystem/economy/proc/deliver_estate(mob/living/H, datum/noble_estate/E, days, gifts, parcel_days = days)
	E.undelivered_days = 0
	E.undelivered_gifts = 0
	var/datum/economic_region/region = E.get_region()
	var/datum/estate_realm/realm = E.get_realm()
	SStreasury.grant_estate_income(H, E.daily_income() * days)
	var/parcel_count = E.parcels_per_day() * parcel_days
	var/parcels = round(parcel_count) + prob((parcel_count - round(parcel_count)) * 100) + E.unsent_parcels
	gifts += E.unsent_gifts
	var/obj/item/roguemachine/mastermail/hermes = SSroguemachine.hermailermaster
	if(QDELETED(hermes))
		E.unsent_parcels = parcels
		E.unsent_gifts = gifts
		if(parcels || gifts)
			send_ooc_note("<b>MEISTER:</b> HERMES is down. Your estates' tribute will not arrive until it is restored.", name = H.real_name)
		return
	E.unsent_parcels = 0
	E.unsent_gifts = 0
	var/list/parcel_goods = region ? region.estate_goods : realm.estate_goods
	var/list/gift_pool = region ? region.gifts : realm.gifts
	var/list/items = list()
	for(var/i in 1 to parcels)
		var/list/goods = estate_parcel(parcel_goods)
		for(var/path in goods)
			for(var/j in 1 to goods[path])
				items += new path()
	if(length(gift_pool))
		for(var/i in 1 to gifts)
			var/gift_type = pick(gift_pool)
			var/obj/item/gift = new gift_type()
			gift.mark_as_gift()
			items += gift
	if(!length(items))
		return
	var/list/deliveries = list()
	var/obj/item/storage/roguebag/estate/sack = new_estate_sack(deliveries)
	for(var/obj/item/I as anything in items)
		if(SEND_SIGNAL(sack, COMSIG_TRY_STORAGE_INSERT, I, null, TRUE, FALSE))
			continue
		sack = new_estate_sack(deliveries)
		if(!SEND_SIGNAL(sack, COMSIG_TRY_STORAGE_INSERT, I, null, TRUE, FALSE))
			deliveries += I
	var/sender = realm ? realm.sender : "[E.estate_name()] Estate"
	for(var/obj/item/delivery as anything in deliveries)
		if(istype(delivery, /obj/item/storage/roguebag/estate) && !length(delivery.contents))
			qdel(delivery)
			continue
		if(!deliver_mail(delivery, H.real_name, sender))
			qdel(delivery)
	if(realm)
		send_ooc_note("<b>MEISTER:</b> ATC has remitted rent from your [realm.name] estate to the HERMES.", name = H.real_name)

/datum/controller/subsystem/economy/proc/new_estate_sack(list/deliveries)
	var/obj/item/storage/roguebag/estate/sack = new()
	deliveries += sack
	return sack
