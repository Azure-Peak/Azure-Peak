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
	if(coin_override)
		return coin_override
	switch(max(rank, pay_rank))
		if(NOBLE_RANK_ROYAL)
			return ESTATE_COIN_ROYAL
		if(NOBLE_RANK_PEER)
			return ESTATE_COIN_PEER
		if(NOBLE_RANK_GENTRY)
			return ESTATE_COIN_GENTRY
	return 0

/datum/noble_estate/proc/parcels_per_day()
	switch(max(rank, pay_rank))
		if(NOBLE_RANK_ROYAL)
			return ESTATE_PARCELS_ROYAL
		if(NOBLE_RANK_PEER)
			return ESTATE_PARCELS_PEER
		if(NOBLE_RANK_GENTRY)
			return ESTATE_PARCELS_GENTRY
	return 0

/datum/noble_estate/proc/get_region()
	if(rank == NOBLE_RANK_NONE && pay_rank == NOBLE_RANK_NONE)
		return null
	return GLOB.economic_regions[region_id] || GLOB.economic_regions[TRADE_REGION_KINGSFIELD]

/datum/controller/subsystem/economy/proc/estate_region_pref(mob/living/H, client/C)
	var/datum/preferences/prefs = C?.prefs || H.client?.prefs || GLOB.preferences_datums[ckey(H.mind?.key)]
	var/region_id = prefs?.estate_region
	if(!region_id || !GLOB.economic_regions[region_id])
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
	E.rank = max(E.rank, rank)
	E.pay_rank = max(E.pay_rank, pay_rank)
	if(ishuman(H))
		var/mob/living/carbon/human/human = H
		human.noble_rank = E.rank
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
	var/parcels = E.parcels_per_day() * days + E.unsent_parcels
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
	var/list/items = list()
	for(var/i in 1 to parcels)
		var/list/goods = region.estate_parcel()
		for(var/path in goods)
			for(var/j in 1 to goods[path])
				items += new path()
	if(length(region.gifts))
		for(var/i in 1 to gifts)
			var/gift_type = pick(region.gifts)
			var/obj/item/gift = new gift_type()
			gift.mark_as_gift()
			items += gift
	if(!length(items))
		return
	var/list/deliveries = list()
	var/obj/item/storage/roguebag/sack = new_estate_sack(deliveries)
	for(var/obj/item/I as anything in items)
		if(SEND_SIGNAL(sack, COMSIG_TRY_STORAGE_INSERT, I, null, TRUE, FALSE))
			continue
		sack = new_estate_sack(deliveries)
		if(!SEND_SIGNAL(sack, COMSIG_TRY_STORAGE_INSERT, I, null, TRUE, FALSE))
			deliveries += I
	for(var/obj/item/delivery as anything in deliveries)
		if(istype(delivery, /obj/item/storage/roguebag) && !length(delivery.contents))
			qdel(delivery)
			continue
		if(!deliver_mail(delivery, H.real_name, "[region.name] Estate"))
			qdel(delivery)

/datum/controller/subsystem/economy/proc/new_estate_sack(list/deliveries)
	var/obj/item/storage/roguebag/sack = new()
	sack.name = "estate sack"
	deliveries += sack
	return sack
