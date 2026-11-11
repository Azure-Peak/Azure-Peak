GLOBAL_LIST_EMPTY(merc_contracts)
GLOBAL_LIST_EMPTY(merc_contract_items)
GLOBAL_LIST_EMPTY(merc_contract_cooldowns)
GLOBAL_LIST_EMPTY(merc_days_served)

GLOBAL_LIST_INIT(merc_hirer_categories, list(
	MERC_HIRER_TOWNER = list("label" = "Burghers and Peasants, except the Innkeeper, Tapster and Cook","stipend" = MERC_STIPEND_TOWNER, "payer" = "the Burghers of the realm"),
	MERC_HIRER_OUTLAW = list("label" = "Outlaws", "stipend" = MERC_STIPEND_OUTLAW, "payer" = "a Mysterious Benefactor", "by_mail" = TRUE),
	MERC_HIRER_INQUISITION = list("label" = "The Inquisition", "stipend" = MERC_STIPEND_INQUISITION, "payer" = "Otava"),
	MERC_HIRER_UNIVERSITY = list("label" = "The University ([english_list(POLL_LEVY_SCHOLAR_JOBS)])", "stipend" = MERC_STIPEND_UNIVERSITY, "payer" = "the University of Azuria"),
))

/proc/get_merc_hirer_category(mob/living/hirer)
	if(HAS_TRAIT(hirer, TRAIT_OUTLAW))
		return MERC_HIRER_OUTLAW
	if(HAS_TRAIT(hirer, TRAIT_INQUISITION))
		return MERC_HIRER_INQUISITION
	if(hirer.job in POLL_LEVY_SCHOLAR_JOBS)
		return MERC_HIRER_UNIVERSITY
	if(hirer.job in GLOB.tavern_positions)
		return null
	if((hirer.job in GLOB.burgher_positions) || (hirer.job in GLOB.peasant_positions))
		return MERC_HIRER_TOWNER
	return null

/proc/pay_merc_contract_bonuses(datum/quest/Q, list/shares)
	var/contract_label = Q.quest_type
	var/mob/living/holder = Q.quest_receiver_reference?.resolve()
	for(var/mob/living/payee as anything in shares)
		if(!get_merc_contract(payee) && !(WEAKREF(payee) in Q.contracted_mercs))
			continue
		if(payee == holder || payee.real_name == Q.quest_receiver_name)
			continue
		var/bonus = round(shares[payee] * MERC_CONTRACT_SHARE_BONUS)
		var/datum/fund/account = SStreasury.get_account(payee)
		if(bonus <= 0 || !account)
			continue
		SStreasury.mint(account, bonus, "Mercenary's Guild bonus - [contract_label]", "the Mercenary's Guild", LEDGER_CITIZEN_CONTRACTS)
		to_chat(payee, span_notice("The Mercenary's Guild adds [bonus] mammon to your share."))
		log_quest(payee.ckey, payee.mind, payee, "Mercenary's Guild bonus [bonus] on [contract_label]")

/proc/get_merc_medal_type(merctype)
	switch(merctype)
		if(1)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/atgervi
		if(2)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/blackoak
		if(3)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/condottiero
		if(4)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/desertrider
		if(5)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/forlorn
		if(6)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/freifechter
		if(7)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/grenzelhoft
		if(8)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/grudgebearer
		if(10)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/routier
		if(11)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/steppesman
		if(12)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/underdweller
		if(13)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/vaquero
		if(15)
			return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/anthrax
	return /obj/item/clothing/neck/roguetown/luckcharm/mercmedal

/proc/mail_merc_cash(mob/living/merc, amount, sender)
	var/list/coins = list()
	var/gold = floor(amount / 10)
	while(gold > 0)
		var/stack = min(gold, 20)
		coins += new /obj/item/roguecoin/gold(null, stack)
		gold -= stack
	var/copper = amount % 10
	if(copper)
		coins += new /obj/item/roguecoin/copper(null, copper)
	var/obj/item/storage/belt/rogue/pouch/cloth/pouch = new
	var/obj/item/smallDelivery/package = new
	for(var/obj/item/roguecoin/coin as anything in coins)
		if(!SEND_SIGNAL(pouch, COMSIG_TRY_STORAGE_INSERT, coin, null, TRUE, TRUE))
			coin.forceMove(package)
	pouch.forceMove(package)
	package.name = "[weightclass2text(pouch.w_class)] package"
	package.w_class = pouch.w_class
	package.grid_height = pouch.grid_height
	package.grid_width = pouch.grid_width
	package.icon_state = "deliverypackage[min(pouch.w_class, 5)]"
	if(!deliver_mail(package, merc.real_name, sender, "merc contract stipend"))
		package.forceMove(get_turf(merc))
		merc.put_in_hands(package)

/proc/get_merc_contract(mob/living/merc)
	for(var/datum/merc_contract/contract as anything in GLOB.merc_contracts)
		if(contract.merc_ref?.resolve() == merc)
			return contract
	return null

/proc/get_fellowship_merc_contract(datum/fellowship/F)
	for(var/datum/merc_contract/contract as anything in GLOB.merc_contracts)
		if(contract.fellowship_ref?.resolve() == F)
			return contract
	return null

/proc/advance_merc_contracts_one_day()
	for(var/datum/merc_contract/contract as anything in GLOB.merc_contracts.Copy())
		contract.on_day_passed()
	for(var/datum/mind/merc_mind as anything in GLOB.merc_contract_cooldowns)
		GLOB.merc_contract_cooldowns[merc_mind] -= MERC_CONTRACT_DAY_LENGTH

/proc/merc_contract_time_text(real_time)
	return "[station_duration_text(real_time)] ([DisplayTimeText(real_time, 1)])"

/proc/clear_unsigned_merc_contracts(mob/living/merc)
	for(var/obj/item/merc_contract/item as anything in GLOB.merc_contract_items.Copy())
		if(!item.contract && item.merc_ref?.resolve() == merc)
			qdel(item)

/proc/merc_contract_cooldown_left(mob/living/merc)
	if(!merc?.mind)
		return 0
	return max(0, (GLOB.merc_contract_cooldowns[merc.mind] || 0) - world.time)

/proc/grant_merc_contract(mob/living/carbon/human/merc, in_hand = FALSE)
	clear_unsigned_merc_contracts(merc)
	var/obj/item/merc_contract/item = new(get_turf(merc))
	item.bind_to(merc)
	if(in_hand || !merc.equip_to_slot_if_possible(item, SLOT_IN_BACKPACK, disable_warning = TRUE))
		merc.put_in_hands(item)
	return item

/proc/merc_meister_data(mob/living/carbon/human/merc)
	if(!istype(SSjob.GetJob(merc.job), /datum/job/roguetown/mercenary))
		return null
	var/datum/merc_contract/contract = get_merc_contract(merc)
	var/cooldown = merc_contract_cooldown_left(merc)
	return list(
		"hired_by" = contract?.hirer_name,
		"days" = contract?.days,
		"days_served" = contract?.days_served,
		"cooldown_text" = cooldown ? merc_contract_time_text(cooldown) : null,
	)

/datum/merc_contract
	var/datum/weakref/merc_ref
	var/datum/weakref/hirer_ref
	var/datum/weakref/fellowship_ref
	var/datum/weakref/item_ref
	var/merc_name
	var/hirer_name
	var/days
	var/days_served = 0
	var/rate = 0
	var/datum/fund/hold
	var/unpaid = FALSE
	var/hirer_category
	var/day_timer_id
	var/presence_timer_id
	var/day_started_at
	var/last_presence_check
	var/presence_time = 0

/datum/merc_contract/New(mob/living/merc, mob/living/hirer, datum/fellowship/F, obj/item/merc_contract/item, days, rate)
	merc_ref = WEAKREF(merc)
	hirer_ref = WEAKREF(hirer)
	fellowship_ref = WEAKREF(F)
	item_ref = WEAKREF(item)
	merc_name = merc.real_name
	hirer_name = hirer.real_name
	src.days = days
	src.rate = rate
	if(rate)
		take_hold(hirer)
	hirer_category = get_merc_hirer_category(hirer)
	day_timer_id = addtimer(CALLBACK(src, PROC_REF(on_day_passed)), MERC_CONTRACT_DAY_LENGTH, TIMER_STOPPABLE | TIMER_LOOP | TIMER_DELETE_ME)
	day_started_at = world.time
	last_presence_check = world.time
	presence_timer_id = addtimer(CALLBACK(src, PROC_REF(on_presence_tick)), MERC_CONTRACT_PRESENCE_INTERVAL, TIMER_STOPPABLE | TIMER_LOOP)
	RegisterSignal(F, COMSIG_PARENT_QDELETING, PROC_REF(on_fellowship_deleted))
	RegisterSignal(merc, COMSIG_PARENT_QDELETING, PROC_REF(on_merc_deleted))
	GLOB.merc_contracts += src
	if(ishuman(merc))
		SSroguemachine.mercenary_statue?.sync_mercenary_status(merc, "Contracted")
	if(F.payout_mode != FELLOWSHIP_PAYOUT_SPLIT)
		F.payout_mode = FELLOWSHIP_PAYOUT_SPLIT
		F.notify_members("A sellsword is under contract. Contract rewards will now be split evenly among fellowship members.")
		F.push_updates()
	log_quest(hirer.ckey, hirer.mind, hirer, "Hire mercenary [merc.ckey] \\ [merc_name] for [days] day\s at [src.rate] a day")
	log_quest(merc.ckey, merc.mind, merc, "Hired by [hirer.ckey] \\ [hirer_name] for [days] day\s at [src.rate] a day")

/datum/merc_contract/Destroy()
	if(day_timer_id)
		deltimer(day_timer_id)
		day_timer_id = null
	if(presence_timer_id)
		deltimer(presence_timer_id)
		presence_timer_id = null
	var/datum/fellowship/F = fellowship_ref?.resolve()
	if(F)
		UnregisterSignal(F, COMSIG_PARENT_QDELETING)
	var/mob/living/merc = merc_ref?.resolve()
	if(merc)
		UnregisterSignal(merc, COMSIG_PARENT_QDELETING)
	release_hold()
	GLOB.merc_contracts -= src
	if(F && !QDELETED(F))
		F.push_updates()
	return ..()

/datum/merc_contract/proc/on_fellowship_deleted(datum/source)
	SIGNAL_HANDLER
	var/mob/living/merc = merc_ref?.resolve()
	var/mob/living/hirer = hirer_ref?.resolve()
	if(merc)
		to_chat(merc, span_notice("Your fellowship has disbanded. Your contract with [hirer_name] is over."))
	if(hirer)
		to_chat(hirer, span_notice("Your fellowship has disbanded. Your contract with [merc_name] is over."))
	INVOKE_ASYNC(src, PROC_REF(end_with_day_paid))

/datum/merc_contract/proc/end_with_day_paid()
	pay_rate()
	end_contract()

/datum/merc_contract/proc/on_merc_deleted(datum/source)
	SIGNAL_HANDLER
	var/mob/living/hirer = hirer_ref?.resolve()
	if(hirer)
		to_chat(hirer, span_notice("[merc_name] is gone. Your contract with them is over."))
		log_quest(hirer.ckey, hirer.mind, hirer, "Contract with mercenary [merc_name] ended, mercenary gone")
	INVOKE_ASYNC(src, PROC_REF(end_contract))

/datum/merc_contract/proc/on_day_passed()
	days_served++
	credit_served_day()
	check_presence()
	var/presence = get_presence_share()
	presence_time = 0
	day_started_at = world.time
	var/mob/living/merc = merc_ref?.resolve()
	var/mob/living/hirer = hirer_ref?.resolve()
	var/merc_dead = merc?.stat == DEAD
	var/hirer_dead = hirer?.stat == DEAD
	pay_rate()
	if(merc_dead || hirer_dead)
		presence = null
	if(days_served >= days)
		pay_day(presence)
		complete_term()
	else if(merc_dead || hirer_dead)
		end_by_death(merc_dead ? merc_name : hirer_name)
	else
		pay_day(presence)
		refresh_hold()

/datum/merc_contract/proc/on_presence_tick()
	check_presence()
	if(unpaid)
		refresh_hold()

/datum/merc_contract/proc/end_by_death(dead_name)
	var/mob/living/merc = merc_ref?.resolve()
	var/mob/living/hirer = hirer_ref?.resolve()
	var/message = span_notice("With [dead_name]'s death, the thread of transaction is severed. The contract has been completed early.")
	if(merc)
		to_chat(merc, message)
		log_quest(merc.ckey, merc.mind, merc, "Contract with [hirer_name] completed early by [dead_name]'s death")
	if(hirer)
		to_chat(hirer, message)
	pay_day(null)
	end_contract()

/datum/merc_contract/proc/check_presence()
	var/elapsed = world.time - last_presence_check
	last_presence_check = world.time
	if(is_with_employer())
		presence_time += elapsed

/datum/merc_contract/proc/get_presence_share()
	return presence_time / max(world.time - day_started_at, 1)

/datum/merc_contract/proc/is_with_employer()
	var/mob/living/merc = merc_ref?.resolve()
	var/turf/merc_turf = get_turf(merc)
	if(!merc_turf)
		return FALSE
	var/mob/living/hirer = hirer_ref?.resolve()
	if(is_near_merc(hirer, merc_turf))
		return TRUE
	var/datum/fellowship/F = fellowship_ref?.resolve()
	for(var/mob/living/member as anything in F?.get_members())
		if(member != merc && member != hirer && is_near_merc(member, merc_turf))
			return TRUE
	return FALSE

/datum/merc_contract/proc/is_near_merc(mob/living/member, turf/merc_turf)
	var/turf/member_turf = get_turf(member)
	if(!member_turf)
		return FALSE
	return max(abs(member_turf.x - merc_turf.x), abs(member_turf.y - merc_turf.y)) <= MERC_CONTRACT_PRESENCE_RANGE

/datum/merc_contract/proc/pay_day(presence)
	if(!hirer_category)
		return
	var/list/terms = GLOB.merc_hirer_categories[hirer_category]
	var/stipend = terms?["stipend"]
	var/mob/living/merc = merc_ref?.resolve()
	if(!stipend || !merc)
		return
	var/payer = terms["payer"]
	var/presence_text = isnull(presence) ? "presence waived on death" : "[round(presence * 100)]% with employer"
	if(!isnull(presence) && presence < MERC_CONTRACT_PRESENCE_SHARE)
		to_chat(merc, span_warning("Your stipend from [payer] is not paid. You spent too little of the dae with your employer."))
		log_quest(merc.ckey, merc.mind, merc, "Contract stipend withheld by [payer], [presence_text] (day [days_served] of [days] with [hirer_name])")
		return
	var/datum/fund/account = SStreasury.get_account(merc)
	if(account && !terms["by_mail"])
		SStreasury.mint(account, stipend, "Mercenary contract with [hirer_name]", payer, LEDGER_CITIZEN_CONTRACTS)
		to_chat(merc, span_notice("You receive [stipend] mammon from [payer] for your contract with [hirer_name]."))
	else
		mail_merc_cash(merc, stipend, capitalize(payer))
		to_chat(merc, span_notice("You receive [stipend] mammon by HERMES from [payer] for your contract with [hirer_name]."))
	log_quest(merc.ckey, merc.mind, merc, "Contract stipend [stipend] from [payer], [presence_text] (day [days_served] of [days] with [hirer_name])")

/datum/merc_contract/proc/take_hold(mob/living/hirer)
	hold = new /datum/fund("[merc_name] contract hold", null, 0, CURRENCY_MAMMON)
	SStreasury.register_auxiliary_fund(hold)
	if(!hold_next_day())
		rate = 0

/datum/merc_contract/proc/hold_next_day()
	if(!hold)
		return FALSE
	var/needed = rate - hold.balance
	if(needed <= 0)
		return TRUE
	var/mob/living/hirer = hirer_ref?.resolve()
	var/datum/fund/account = SStreasury.get_account(hirer)
	if(!account || !SStreasury.transfer(account, hold, needed, "Mercenary contract hold - [merc_name]", SStreasury.escrow_account(account), LEDGER_CITIZEN_ESCROW))
		return FALSE
	to_chat(hirer, span_notice("[needed] mammon is held from your MEISTER account for [merc_name]'s rate this dae."))
	return TRUE

/datum/merc_contract/proc/refresh_hold()
	if(!rate)
		return
	var/was_unpaid = unpaid
	unpaid = !hold_next_day()
	if(unpaid == was_unpaid)
		return
	var/mob/living/merc = merc_ref?.resolve()
	var/mob/living/hirer = hirer_ref?.resolve()
	if(unpaid)
		if(merc)
			to_chat(merc, span_warning("[hirer_name] cannot cover your rate for this dae. You can end the contract now with End Mercenary Contract."))
			log_quest(merc.ckey, merc.mind, merc, "Contract rate [rate] not covered by [hirer_name] (day [days_served + 1] of [days])")
		if(hirer)
			to_chat(hirer, span_warning("Your MEISTER account cannot cover [merc_name]'s rate for this dae. They can end the contract until it is covered."))
		return
	if(merc)
		to_chat(merc, span_notice("[hirer_name] has covered your rate for this dae."))
		log_quest(merc.ckey, merc.mind, merc, "Contract rate [rate] covered late by [hirer_name] (day [days_served + 1] of [days])")

/datum/merc_contract/proc/pay_rate()
	var/mob/living/merc = merc_ref?.resolve()
	if(!merc || !hold)
		return
	var/amount = min(rate, hold.balance)
	if(amount <= 0)
		return
	var/datum/fund/account = SStreasury.get_account(merc)
	if(account)
		SStreasury.transfer(hold, account, amount, "Mercenary contract with [hirer_name]", LEDGER_CITIZEN_ESCROW, SStreasury.escrow_account(account))
		to_chat(merc, span_notice("You receive [amount] mammon from [hirer_name] for your contract."))
	else
		SStreasury.burn(hold, amount, "Mercenary contract with [hirer_name]", LEDGER_CITIZEN_COIN_OUT)
		mail_merc_cash(merc, amount, hirer_name)
		to_chat(merc, span_notice("You receive [amount] mammon by HERMES from [hirer_name] for your contract."))
	log_quest(merc.ckey, merc.mind, merc, "Contract rate [amount] from [hirer_name] (day [days_served] of [days])")

/datum/merc_contract/proc/release_hold()
	if(!hold)
		return
	var/mob/living/hirer = hirer_ref?.resolve()
	var/datum/fund/account = SStreasury.get_account(hirer)
	var/amount = hold.balance
	if(amount > 0 && SStreasury.transfer(hold, account, amount, "Mercenary contract hold returned - [merc_name]", LEDGER_CITIZEN_ESCROW, SStreasury.escrow_account(account)))
		to_chat(hirer, span_notice("[amount] mammon held for [merc_name]'s rate returns to your MEISTER account."))
		log_quest(hirer.ckey, hirer.mind, hirer, "Contract hold [amount] returned from [merc_name]")
	SStreasury.retire_fund(hold, "Mercenary contract hold forfeited")
	hold = null

/datum/merc_contract/proc/is_merc_dead()
	var/mob/living/merc = merc_ref?.resolve()
	return !merc || merc.stat == DEAD

/datum/merc_contract/proc/can_end_early()
	return days_served >= 1 || is_merc_dead()

/datum/merc_contract/proc/can_merc_end_early()
	return unpaid || days_served >= 1

/datum/merc_contract/proc/end_early_by_merc()
	var/mob/living/merc = merc_ref?.resolve()
	var/mob/living/hirer = hirer_ref?.resolve()
	var/was_unpaid = unpaid
	if(merc)
		to_chat(merc, span_notice("You end your contract with [hirer_name]. The dae in progress is not paid."))
		log_quest(merc.ckey, merc.mind, merc, "End contract with [hirer_name] early[was_unpaid ? " while unpaid" : ""]")
	if(hirer)
		to_chat(hirer, span_warning("[merc_name] has ended your contract early."))
		log_quest(hirer.ckey, hirer.mind, hirer, "Contract ended early by mercenary [merc_name][was_unpaid ? " while unpaid" : ""]")
	end_contract()

/datum/merc_contract/proc/held_amount()
	return hold?.balance || 0

/datum/merc_contract/proc/time_left()
	return max(0, timeleft(day_timer_id)) + max(0, days - days_served - 1) * MERC_CONTRACT_DAY_LENGTH

/datum/merc_contract/proc/end_early()
	var/mob/living/merc = merc_ref?.resolve()
	var/mob/living/hirer = hirer_ref?.resolve()
	var/merc_dead = is_merc_dead()
	if(merc)
		if(merc_dead)
			to_chat(merc, span_notice("[hirer_name] has ended your contract."))
		else
			to_chat(merc, span_warning("[hirer_name] has ended your contract early. You cannot take a new contract for [merc_contract_time_text(MERC_CONTRACT_DAY_LENGTH)]."))
		log_quest(merc.ckey, merc.mind, merc, "Contract ended early by [hirer_name][merc_dead ? " while dead" : ""]")
	if(hirer)
		to_chat(hirer, span_notice("You end your contract with [merc_name]."))
		log_quest(hirer.ckey, hirer.mind, hirer, "End contract with mercenary [merc_name] early[merc_dead ? " while they are dead" : ""]")
	if(merc_dead)
		pay_day(null)
	pay_rate()
	end_contract(merc_dead ? 0 : world.time + MERC_CONTRACT_DAY_LENGTH)

/datum/merc_contract/proc/admin_complete()
	if(day_timer_id)
		deltimer(day_timer_id)
		day_timer_id = null
	log_admin("[key_name(usr)] completed the mercenary contract of [merc_name] with [hirer_name].")
	complete_term()

/datum/merc_contract/proc/complete_term()
	var/mob/living/merc = merc_ref?.resolve()
	var/mob/living/hirer = hirer_ref?.resolve()
	if(merc)
		to_chat(merc, span_notice("Your contract with [hirer_name] is complete."))
		log_quest(merc.ckey, merc.mind, merc, "Contract with [hirer_name] complete")
	if(hirer)
		to_chat(hirer, span_notice("Your contract with [merc_name] is complete."))
	end_contract()

/datum/merc_contract/proc/end_contract(cooldown_until = 0)
	if(QDELETED(src))
		return
	var/obj/item/merc_contract/item = item_ref?.resolve()
	if(item)
		qdel(item)
	var/mob/living/carbon/human/merc = merc_ref?.resolve()
	if(istype(merc))
		if(cooldown_until && merc.mind)
			GLOB.merc_contract_cooldowns[merc.mind] = cooldown_until
		SSroguemachine.mercenary_statue?.sync_mercenary_status(merc, "Available")
		to_chat(merc, span_notice("Visit a MEISTER to print a new mercenary contract."))
	qdel(src)

/datum/merc_contract/proc/credit_served_day()
	var/mob/living/carbon/human/merc = merc_ref?.resolve()
	if(!istype(merc) || !merc.mind)
		return
	GLOB.merc_days_served[merc.mind] = (GLOB.merc_days_served[merc.mind] || 0) + 1
	award_medal(merc)

/datum/merc_contract/proc/award_medal(mob/living/carbon/human/merc)
	var/total_days = GLOB.merc_days_served[merc.mind] || 0
	if(total_days < MERC_CONTRACT_MEDAL_DAYS || merc.tokenclaimed)
		return
	merc.tokenclaimed = TRUE
	merc.adjust_triumphs(MERC_CONTRACT_MEDAL_TRIUMPHS)
	var/medal_type = get_merc_medal_type(merc.merctype)
	var/obj/item/medal = new medal_type(get_turf(merc))
	if(!deliver_mail(medal, merc.real_name, "the Mercenary's Guild", "merc contract medal"))
		merc.put_in_hands(medal)
	to_chat(merc, span_notice("The Mercenary's Guild sends you a medal for your service."))
	log_quest(merc.ckey, merc.mind, merc, "Mercenary medal for [total_days] days served in total")

/obj/item/merc_contract
	name = "mercenary contract"
	desc = "An official looking document issued by the Mercenary's Guild for hiring mercenaries. The leadership of a fellowship may sign it to take the sellsword into their fellowship for the amount of daes written on it."
	icon = 'icons/clothing/mercmedals.dmi'
	icon_state = "merctoken"
	lefthand_file = 'icons/mob/inhands/misc/food_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/misc/food_righthand.dmi'
	w_class = WEIGHT_CLASS_TINY
	dropshrink = 0.5
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_MOUTH
	resistance_flags = INDESTRUCTIBLE | LAVA_PROOF | FIRE_PROOF | UNACIDABLE | ACID_PROOF
	var/datum/weakref/merc_ref
	var/merc_name
	var/days = 1
	var/rate = 0
	var/datum/merc_contract/contract
	var/datum/weakref/offered_by
	var/offer_timer_id
	var/prompt_open = FALSE

/obj/item/merc_contract/Initialize(mapload)
	. = ..()
	GLOB.merc_contract_items += src

/obj/item/merc_contract/Destroy()
	GLOB.merc_contract_items -= src
	clear_offer()
	contract = null
	return ..()

/obj/item/merc_contract/proc/bind_to(mob/living/merc)
	merc_ref = WEAKREF(merc)
	merc_name = merc.real_name
	name = "mercenary contract: [merc_name]"

/obj/item/merc_contract/examine(mob/user)
	. = ..()
	if(contract)
		for(var/line in signed_lines())
			. += span_info(line)
		return
	. += span_info("Hire mercenary [merc_name] for [terms_text()].")
	. += span_info("Use it in hand to choose the number of daes and the daily rate. Hand it to a fellowship leader to be hired.")
	for(var/line in rule_lines())
		. += span_info(line)

/obj/item/merc_contract/proc/signed_lines()
	. = list()
	. += "[merc_name] is hired by [contract.hirer_name] for [contract.days] dae\s."
	. += "The contract ends in [merc_contract_time_text(contract.time_left())]."
	if(contract.rate)
		. += "[contract.hirer_name] pays [contract.rate] mammon a dae. [contract.held_amount()] mammon is held for this dae."
		if(contract.unpaid)
			. += "[contract.hirer_name] has not covered this dae's rate. [merc_name] can end the contract now."
	. += "The hirer can use it in hand to end the contract early once the first dae has passed, or at any time if [merc_name] is dead."
	. += "[merc_name] can end it with End Mercenary Contract once the first dae has passed, or at any time while a dae's rate is not covered."
	if(contract.hirer_category)
		. += "[merc_name] has spent [round(contract.get_presence_share() * 100)]% of this dae with their employer. [round(MERC_CONTRACT_PRESENCE_SHARE * 100)]% is needed for the dae's pay."

/obj/item/merc_contract/proc/rule_lines()
	. = list()
	. += "A mercenary may ask for a daily rate from the hirer. It is held from the hirer's MEISTER account one dae at a time at the start of each dae, and paid at the end of the dae."
	. += "If the hirer cannot cover the next dae, the mercenary is told and can end the contract immediately without penalty."
	. += "A mercenary can end their own contract with the \"End Mercenary Contract\" verb once the first dae has passed. They give up their rate and stipend for the dae in progress, but do not have to wait to be hired again."
	. += "If the hirer ends the contract early, the dae in progress is still paid."
	. += "While hired, contract rewards are split evenly among the fellowship, and the Mercenary's Guild adds [round(MERC_CONTRACT_SHARE_BONUS * 100)]% to your share of contracts held by someone else."
	. += "Certain roles give you a stipend from an external funder."
	. += "Stipend per dae by employer:"
	for(var/category in GLOB.merc_hirer_categories)
		var/list/terms = GLOB.merc_hirer_categories[category]
		. += "- [terms["label"]]: [terms["stipend"]] mammon from [terms["payer"]]"
	. += "- Anyone else: nothing extra"
	. += "To receive the stipend, spend at least [round(MERC_CONTRACT_PRESENCE_SHARE * 100)]% of each dae within [MERC_CONTRACT_PRESENCE_RANGE] tiles of your employer or a member of their fellowship."

/obj/item/merc_contract/proc/offer_lines()
	. = list("They will join your fellowship.")
	if(rate)
		. += "[rate] mammon will be held from your MEISTER account at the start of each dae, and paid at the end of it."
		. += "If you cannot cover a dae, [merc_name] can end the contract."

/obj/item/merc_contract/attack_self(mob/user)
	if(isliving(user))
		ui_interact(user)

/obj/item/merc_contract/ui_state(mob/user)
	return GLOB.hands_state

/obj/item/merc_contract/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MercContract")
		ui.open()

/obj/item/merc_contract/ui_static_data(mob/user)
	return list(
		"merc_name" = merc_name,
		"max_days" = MERC_CONTRACT_MAX_DAYS,
		"max_rate" = MERC_CONTRACT_MAX_RATE,
		"days_prompt" = "How many daes will you hire yourself out for?",
		"rate_prompt" = "What rate will you ask for per dae? It is held from their MEISTER account every dae. Leave it at 0 to ask for nothing. Asking for a rate will prevent you from being hired by anyone without a MEISTER account.",
		"rules" = rule_lines(),
	)

/obj/item/merc_contract/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/merc = merc_ref?.resolve()
	data["signed"] = !!contract
	data["is_merc"] = user == merc
	if(contract)
		data["status_lines"] = signed_lines()
		data["is_hirer"] = contract.hirer_ref?.resolve() == user
		data["end_early_wait"] = contract.can_end_early() ? null : "You can end the contract in [merc_contract_time_text(timeleft(contract.day_timer_id))]."
		return data
	data["headline"] = "Hire mercenary [merc_name] for [terms_text()]."
	data["days"] = days
	data["rate"] = rate
	data["can_edit"] = can_edit_terms()
	if(user != merc)
		var/datum/fund/account = SStreasury.get_account(user)
		data["balance"] = account?.balance
		data["offer_lines"] = offer_lines()
		data["hire_blocker"] = offered_by ? "Wait for [merc_name] to answer." : hire_failure_reason(user, merc)
	return data

/obj/item/merc_contract/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/living/user = usr
	if(!istype(user))
		return
	switch(action)
		if("set_days")
			if(user != merc_ref?.resolve() || !can_edit_terms())
				return
			days = clamp(round(text2num("[params["days"]]")), 1, MERC_CONTRACT_MAX_DAYS)
			return TRUE
		if("set_rate")
			if(user != merc_ref?.resolve() || !can_edit_terms())
				return
			rate = clamp(round(text2num("[params["rate"]]")), 0, MERC_CONTRACT_MAX_RATE)
			return TRUE
		if("offer")
			if(contract || user == merc_ref?.resolve())
				return
			try_hire(user)
			return TRUE
		if("end_early")
			if(contract?.hirer_ref?.resolve() != user)
				return
			INVOKE_ASYNC(src, PROC_REF(try_end_early), user)
			return TRUE

/obj/item/merc_contract/proc/try_end_early(mob/living/hirer)
	if(!contract.can_end_early())
		to_chat(hirer, span_warning("You can end the contract in [merc_contract_time_text(timeleft(contract.day_timer_id))]."))
		return
	if(tgui_alert(hirer, "End your contract with [merc_name] early?", "Mercenary Contract", list("Yes", "No")) != "Yes")
		return
	if(QDELETED(src) || !contract)
		return
	contract.end_early()

/obj/item/merc_contract/proc/terms_text()
	if(rate)
		return "[days] dae\s at [rate] mammon a dae"
	return "[days] dae\s"

/obj/item/merc_contract/proc/can_edit_terms()
	return !QDELETED(src) && !contract && !offered_by

/obj/item/merc_contract/proc/try_hire(mob/living/hirer)
	var/mob/living/carbon/human/merc = merc_ref?.resolve()
	var/failure = offered_by ? "Wait for [merc_name] to answer." : hire_failure_reason(hirer, merc)
	if(failure)
		to_chat(hirer, span_warning(failure))
		return
	offer_to(merc, hirer)

/obj/item/merc_contract/proc/offer_to(mob/living/merc, mob/living/hirer)
	var/atom/movable/screen/alert/merc_contract_offer/offer = merc.throw_alert("merc_contract_offer", /atom/movable/screen/alert/merc_contract_offer, new_master = src, timeout_override = MERC_CONTRACT_ACCEPT_TIMEOUT)
	if(!offer)
		return
	offer.item_ref = WEAKREF(src)
	var/pay_text = merc_offer_pay_text(hirer)
	offer.desc = "[hirer.real_name] wants to hire you for [terms_text()].[pay_text] Click to answer."
	offered_by = WEAKREF(hirer)
	offer_timer_id = addtimer(CALLBACK(src, PROC_REF(expire_offer)), MERC_CONTRACT_ACCEPT_TIMEOUT, TIMER_STOPPABLE)
	to_chat(hirer, span_notice("You offer the contract to [merc_name]."))
	to_chat(merc, span_notice("[hirer.real_name] wants to hire you for [terms_text()].[pay_text] Click the alert to answer."))

/obj/item/merc_contract/proc/prompt_offer(mob/living/merc)
	var/mob/living/hirer = offered_by?.resolve()
	if(prompt_open || !hirer || merc != merc_ref?.resolve())
		return
	prompt_open = TRUE
	var/choice = tgui_alert(merc, "[hirer.real_name] wants to hire you for [terms_text()].[merc_offer_pay_text(hirer)]", "Contract Offer", list("Accept", "Reject"), timeleft(offer_timer_id))
	prompt_open = FALSE
	if(QDELETED(src) || offered_by?.resolve() != hirer)
		return
	if(choice == "Accept")
		accept_offer(merc)
	else if(choice == "Reject")
		reject_offer(merc)

/obj/item/merc_contract/proc/reject_offer(mob/living/merc)
	if(merc != merc_ref?.resolve())
		return
	var/mob/living/hirer = offered_by?.resolve()
	clear_offer()
	if(hirer)
		to_chat(hirer, span_warning("[merc_name] turns down your offer. The contract returns to them."))
	to_chat(merc, span_notice("You turn down the offer. The contract returns to you."))
	return_to_merc()

/obj/item/merc_contract/proc/return_to_merc()
	var/mob/living/merc = merc_ref?.resolve()
	if(!merc || contract || loc == merc)
		return
	if(ismob(loc))
		var/mob/holder = loc
		holder.temporarilyRemoveItemFromInventory(src, force = TRUE)
	forceMove(get_turf(merc))
	merc.put_in_hands(src)

/obj/item/merc_contract/proc/merc_offer_pay_text(mob/living/hirer)
	var/category = get_merc_hirer_category(hirer)
	if(!category)
		return ""
	var/list/terms = GLOB.merc_hirer_categories[category]
	return " [capitalize(terms["payer"])] will pay you [terms["stipend"]] mammon a dae."

/obj/item/merc_contract/proc/expire_offer()
	offer_timer_id = null
	var/mob/living/hirer = offered_by?.resolve()
	clear_offer()
	if(hirer)
		to_chat(hirer, span_warning("[merc_name] did not accept. The contract returns to them."))
	return_to_merc()

/obj/item/merc_contract/proc/clear_offer()
	if(offer_timer_id)
		deltimer(offer_timer_id)
		offer_timer_id = null
	offered_by = null
	var/mob/living/merc = merc_ref?.resolve()
	merc?.clear_alert("merc_contract_offer")

/obj/item/merc_contract/proc/accept_offer(mob/living/merc)
	if(merc != merc_ref?.resolve())
		return
	var/mob/living/hirer = offered_by?.resolve()
	clear_offer()
	if(!hirer)
		return_to_merc()
		return
	var/failure = hire_failure_reason(hirer, merc)
	if(failure)
		to_chat(merc, span_warning(failure))
		to_chat(hirer, span_warning(failure))
		return_to_merc()
		return
	var/datum/fellowship/F = hirer.current_fellowship
	if(merc.current_fellowship != F && !F.add_member(merc))
		to_chat(hirer, span_warning("[merc_name] could not join your fellowship."))
		return_to_merc()
		return
	contract = new /datum/merc_contract(merc, hirer, F, src, days, rate)
	name = "signed mercenary contract: [merc_name]"
	to_chat(hirer, span_notice("You hire [merc_name] for [terms_text()]."))
	to_chat(merc, span_notice("[hirer.real_name] has hired you for [terms_text()]."))

/obj/item/merc_contract/proc/hire_failure_reason(mob/living/hirer, mob/living/merc)
	if(contract)
		return "This contract has already been signed."
	if(QDELETED(merc) || merc.stat == DEAD)
		return "[merc_name] is dead or gone."
	if(get_merc_contract(merc))
		return "[merc_name] is already hired."
	var/cooldown = merc_contract_cooldown_left(merc)
	if(cooldown)
		return "[merc_name] cannot take a new contract for [merc_contract_time_text(cooldown)]."
	var/datum/fellowship/F = hirer.current_fellowship
	if(!F || !F.is_leader(hirer))
		return "Only a fellowship leader can hire a sellsword."
	if(merc.current_fellowship && merc.current_fellowship != F)
		return "[merc_name] must leave their fellowship first."
	if(merc.current_fellowship != F && length(F.get_members()) >= FELLOWSHIP_MAX_MEMBERS)
		return "Your fellowship is full."
	if(rate)
		if(HAS_TRAIT(hirer, TRAIT_OUTLAW))
			return "An outlaw cannot pay through the MEISTER."
		var/datum/fund/account = SStreasury.get_account(hirer)
		if(!account || account.balance < rate)
			return "[hirer.real_name] needs [rate] mammon in a MEISTER account to cover the first dae of [merc_name]'s rate."
	var/turf/hirer_turf = get_turf(hirer)
	var/turf/merc_turf = get_turf(merc)
	if(!hirer_turf || !merc_turf || hirer_turf.z != merc_turf.z || get_dist(hirer_turf, merc_turf) > MERC_CONTRACT_RANGE)
		return "[merc_name] needs to be nearby."
	return null

/mob/living/carbon/human/proc/mercenary_end_contract()
	set name = "End Mercenary Contract"
	set category = "RoleUnique.Mercenary"
	set desc = "End the contract you are hired under."
	var/datum/merc_contract/contract = get_merc_contract(src)
	if(!contract)
		to_chat(src, span_warning("You are not under contract."))
		return
	if(!contract.can_merc_end_early())
		to_chat(src, span_warning("You can end the contract in [merc_contract_time_text(timeleft(contract.day_timer_id))]."))
		return
	if(tgui_alert(src, "End your contract with [contract.hirer_name] early? You give up the rate and the stipend for the dae in progress.", "Mercenary Contract", list("Yes", "No")) != "Yes")
		return
	if(QDELETED(contract) || !contract.can_merc_end_early())
		return
	contract.end_early_by_merc()

/atom/movable/screen/alert/merc_contract_offer
	name = "Contract Offer"
	desc = "Someone wants to hire you. Click to answer."
	var/datum/weakref/item_ref

/atom/movable/screen/alert/merc_contract_offer/Click()
	var/obj/item/merc_contract/item = item_ref?.resolve()
	if(item)
		INVOKE_ASYNC(item, TYPE_PROC_REF(/obj/item/merc_contract, prompt_offer), usr)
	return TRUE
