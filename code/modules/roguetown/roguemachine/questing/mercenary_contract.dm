GLOBAL_LIST_EMPTY(merc_contracts)
GLOBAL_LIST_EMPTY(merc_contract_items)
GLOBAL_LIST_EMPTY(merc_contract_cooldowns)
GLOBAL_LIST_EMPTY(merc_days_served)

GLOBAL_LIST_INIT(merc_hirer_categories, list(
	MERC_HIRER_TOWNER = list("label" = "Towners", "stipend" = MERC_STIPEND_TOWNER, "payer" = "the Burghers of the realm"),
	MERC_HIRER_OUTLAW = list("label" = "Outlaws", "stipend" = MERC_STIPEND_OUTLAW, "payer" = "a Mysterious Benefactor", "by_mail" = TRUE),
	MERC_HIRER_INQUISITION = list("label" = "The Inquisition", "stipend" = MERC_STIPEND_INQUISITION, "payer" = "Otava"),
))

/proc/get_merc_hirer_category(mob/living/hirer)
	if(HAS_TRAIT(hirer, TRAIT_OUTLAW))
		return MERC_HIRER_OUTLAW
	if(HAS_TRAIT(hirer, TRAIT_INQUISITION))
		return MERC_HIRER_INQUISITION
	if(hirer.job in GLOB.tavern_positions)
		return null
	if((hirer.job in GLOB.burgher_positions) || (hirer.job in GLOB.peasant_positions))
		return MERC_HIRER_TOWNER
	return null

/proc/pay_merc_contract_bonuses(datum/quest/Q, list/shares)
	var/contract_label = Q.quest_type
	var/mob/living/holder = Q.quest_receiver_reference?.resolve()
	for(var/mob/living/payee as anything in shares)
		if(!get_merc_contract(payee))
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
	var/hirer_category
	var/day_timer_id
	var/presence_timer_id
	var/day_started_at
	var/last_presence_check
	var/presence_time = 0

/datum/merc_contract/New(mob/living/merc, mob/living/hirer, datum/fellowship/F, obj/item/merc_contract/item, days)
	merc_ref = WEAKREF(merc)
	hirer_ref = WEAKREF(hirer)
	fellowship_ref = WEAKREF(F)
	item_ref = WEAKREF(item)
	merc_name = merc.real_name
	hirer_name = hirer.real_name
	src.days = days
	hirer_category = get_merc_hirer_category(hirer)
	day_timer_id = addtimer(CALLBACK(src, PROC_REF(on_day_passed)), MERC_CONTRACT_DAY_LENGTH, TIMER_STOPPABLE | TIMER_LOOP)
	day_started_at = world.time
	last_presence_check = world.time
	presence_timer_id = addtimer(CALLBACK(src, PROC_REF(check_presence)), MERC_CONTRACT_PRESENCE_INTERVAL, TIMER_STOPPABLE | TIMER_LOOP)
	RegisterSignal(F, COMSIG_PARENT_QDELETING, PROC_REF(on_fellowship_deleted))
	RegisterSignal(merc, COMSIG_PARENT_QDELETING, PROC_REF(on_merc_deleted))
	GLOB.merc_contracts += src
	if(ishuman(merc))
		SSroguemachine.mercenary_statue?.sync_mercenary_status(merc, "Contracted")
	if(F.payout_mode != FELLOWSHIP_PAYOUT_SPLIT)
		F.payout_mode = FELLOWSHIP_PAYOUT_SPLIT
		F.notify_members("A sellsword is under contract. Contract rewards will now be split evenly among fellowship members.")
		F.push_updates()
	log_quest(hirer.ckey, hirer.mind, hirer, "Hire mercenary [merc.ckey] \\ [merc_name] for [days] day\s")
	log_quest(merc.ckey, merc.mind, merc, "Hired by [hirer.ckey] \\ [hirer_name] for [days] day\s")

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
	INVOKE_ASYNC(src, PROC_REF(end_contract))

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
	if(merc_dead || hirer_dead)
		presence = null
	if(days_served >= days)
		pay_day(presence)
		complete_term()
	else if(merc_dead || hirer_dead)
		end_by_death(merc_dead ? merc_name : hirer_name)
	else
		pay_day(presence)

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

/datum/merc_contract/proc/is_merc_dead()
	var/mob/living/merc = merc_ref?.resolve()
	return !merc || merc.stat == DEAD

/datum/merc_contract/proc/can_end_early()
	return days_served >= 1 || is_merc_dead()

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
	desc = "An official looking document issued by the Mercenary's Guild for hiring mercenaries. The leadership of a fellowship may sign it to take the sellsword into their fellowship for the amount of days written on it."
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
		. += span_info("[merc_name] is hired by [contract.hirer_name] for [contract.days] day\s.")
		. += span_info("The hirer can use it in hand to end the contract early once the first day has passed, or at any time if [merc_name] is dead.")
		if(contract.hirer_category)
			. += span_info("[merc_name] has spent [round(contract.get_presence_share() * 100)]% of this dae with their employer. [round(MERC_CONTRACT_PRESENCE_SHARE * 100)]% is needed for the dae's pay.")
		return
	. += span_info("Hire mercenary [merc_name] for [days] day\s.")
	. += span_info("Use it in hand to choose the number of days. Hand it to a fellowship leader to be hired.")
	. += span_info("While hired, contract rewards are split evenly among the fellowship, and the Mercenary's Guild adds [round(MERC_CONTRACT_SHARE_BONUS * 100)]% to your share of contracts held by someone else.")
	. += span_info("Pay per day by employer:")
	for(var/category in GLOB.merc_hirer_categories)
		var/list/terms = GLOB.merc_hirer_categories[category]
		. += span_info("- [terms["label"]]: [terms["stipend"]] mammon from [terms["payer"]]")
	. += span_info("- Anyone else: nothing extra")
	. += span_info("To receive the stipend, spend at least [round(MERC_CONTRACT_PRESENCE_SHARE * 100)]% of each dae within [MERC_CONTRACT_PRESENCE_RANGE] tiles of your employer or a member of their fellowship.")

/obj/item/merc_contract/attack_self(mob/user)
	var/mob/living/L = user
	if(!istype(L))
		return
	if(contract)
		if(contract.hirer_ref?.resolve() == L)
			try_end_early(L)
			return
		to_chat(L, span_warning("This contract has already been signed."))
		return
	if(merc_ref?.resolve() == L)
		choose_days(L)
		return
	try_hire(L)

/obj/item/merc_contract/proc/try_end_early(mob/living/hirer)
	if(!contract.can_end_early())
		to_chat(hirer, span_warning("You can end the contract in [merc_contract_time_text(timeleft(contract.day_timer_id))]."))
		return
	if(tgui_alert(hirer, "End your contract with [merc_name] early?", "Mercenary Contract", list("Yes", "No")) != "Yes")
		return
	if(QDELETED(src) || !contract)
		return
	contract.end_early()

/obj/item/merc_contract/proc/choose_days(mob/living/merc)
	var/list/options = list()
	for(var/i in 1 to MERC_CONTRACT_MAX_DAYS)
		options += "[i]"
	var/choice = tgui_input_list(merc, "How many days will you hire yourself out for?", "Mercenary Contract", options, "[days]")
	if(!choice || contract || QDELETED(src))
		return
	days = text2num(choice)
	to_chat(merc, span_notice("The contract now offers your sword for [days] day\s."))

/obj/item/merc_contract/proc/try_hire(mob/living/hirer)
	var/mob/living/carbon/human/merc = merc_ref?.resolve()
	var/failure = hire_failure_reason(hirer, merc)
	if(failure)
		to_chat(hirer, span_warning(failure))
		return
	if(offered_by)
		to_chat(hirer, span_warning("Wait for [merc_name] to answer."))
		return
	if(tgui_alert(hirer, "Hire [merc_name] for [days] day\s? They will join your fellowship.", "Mercenary Contract", list("Yes", "No")) != "Yes")
		return
	failure = hire_failure_reason(hirer, merc)
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
	offer.desc = "[hirer.real_name] wants to hire you for [days] day\s.[pay_text] Click to answer."
	offered_by = WEAKREF(hirer)
	offer_timer_id = addtimer(CALLBACK(src, PROC_REF(expire_offer)), MERC_CONTRACT_ACCEPT_TIMEOUT, TIMER_STOPPABLE)
	to_chat(hirer, span_notice("You offer the contract to [merc_name]."))
	to_chat(merc, span_notice("[hirer.real_name] wants to hire you for [days] day\s.[pay_text] Click the alert to answer."))

/obj/item/merc_contract/proc/prompt_offer(mob/living/merc)
	var/mob/living/hirer = offered_by?.resolve()
	if(prompt_open || !hirer || merc != merc_ref?.resolve())
		return
	prompt_open = TRUE
	var/choice = tgui_alert(merc, "[hirer.real_name] wants to hire you for [days] day\s.[merc_offer_pay_text(hirer)]", "Contract Offer", list("Accept", "Reject"), timeleft(offer_timer_id))
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
	return " [capitalize(terms["payer"])] will pay you [terms["stipend"]] mammon a day."

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
	contract = new /datum/merc_contract(merc, hirer, F, src, days)
	name = "signed mercenary contract: [merc_name]"
	to_chat(hirer, span_notice("You hire [merc_name] for [days] day\s."))
	to_chat(merc, span_notice("[hirer.real_name] has hired you for [days] day\s."))

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
	var/turf/hirer_turf = get_turf(hirer)
	var/turf/merc_turf = get_turf(merc)
	if(!hirer_turf || !merc_turf || hirer_turf.z != merc_turf.z || get_dist(hirer_turf, merc_turf) > MERC_CONTRACT_RANGE)
		return "[merc_name] needs to be nearby."
	return null

/atom/movable/screen/alert/merc_contract_offer
	name = "Contract Offer"
	desc = "Someone wants to hire you. Click to answer."
	var/datum/weakref/item_ref

/atom/movable/screen/alert/merc_contract_offer/Click()
	var/obj/item/merc_contract/item = item_ref?.resolve()
	if(item)
		INVOKE_ASYNC(item, TYPE_PROC_REF(/obj/item/merc_contract, prompt_offer), usr)
	return TRUE
