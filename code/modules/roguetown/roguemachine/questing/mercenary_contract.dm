GLOBAL_LIST_EMPTY(merc_contracts)

/proc/get_merc_contract(mob/living/merc)
	for(var/datum/merc_contract/contract as anything in GLOB.merc_contracts)
		if(contract.merc_ref?.resolve() == merc)
			return contract
	return null

/proc/grant_merc_contract(mob/living/carbon/human/merc)
	var/obj/item/merc_contract/item = new(get_turf(merc))
	item.bind_to(merc)
	if(!merc.equip_to_slot_if_possible(item, SLOT_IN_BACKPACK, disable_warning = TRUE))
		merc.put_in_hands(item)
	return item

/datum/merc_contract
	var/datum/weakref/merc_ref
	var/datum/weakref/hirer_ref
	var/datum/weakref/fellowship_ref
	var/datum/weakref/item_ref
	var/merc_name
	var/hirer_name
	var/days
	var/started_at
	var/term_timer_id

/datum/merc_contract/New(mob/living/merc, mob/living/hirer, datum/fellowship/F, obj/item/merc_contract/item, days)
	merc_ref = WEAKREF(merc)
	hirer_ref = WEAKREF(hirer)
	fellowship_ref = WEAKREF(F)
	item_ref = WEAKREF(item)
	merc_name = merc.real_name
	hirer_name = hirer.real_name
	src.days = days
	started_at = world.time
	term_timer_id = addtimer(CALLBACK(src, PROC_REF(complete_term)), days * MERC_CONTRACT_DAY_LENGTH, TIMER_STOPPABLE)
	GLOB.merc_contracts += src
	log_quest(hirer.ckey, hirer.mind, hirer, "Hire mercenary [merc.ckey] \\ [merc_name] for [days] day\s")
	log_quest(merc.ckey, merc.mind, merc, "Hired by [hirer.ckey] \\ [hirer_name] for [days] day\s")

/datum/merc_contract/Destroy()
	if(term_timer_id)
		deltimer(term_timer_id)
		term_timer_id = null
	GLOB.merc_contracts -= src
	return ..()

/datum/merc_contract/proc/complete_term()
	term_timer_id = null
	var/mob/living/merc = merc_ref?.resolve()
	var/mob/living/hirer = hirer_ref?.resolve()
	if(merc)
		to_chat(merc, span_notice("Your contract with [hirer_name] is complete."))
		log_quest(merc.ckey, merc.mind, merc, "Contract with [hirer_name] complete")
	if(hirer)
		to_chat(hirer, span_notice("Your contract with [merc_name] is complete."))
	end_contract()

/datum/merc_contract/proc/end_contract()
	var/obj/item/merc_contract/item = item_ref?.resolve()
	if(item)
		qdel(item)
	var/mob/living/carbon/human/merc = merc_ref?.resolve()
	if(istype(merc))
		grant_merc_contract(merc)
	qdel(src)

/obj/item/merc_contract
	name = "mercenary writ"
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

/obj/item/merc_contract/Destroy()
	clear_offer()
	contract = null
	return ..()

/obj/item/merc_contract/proc/bind_to(mob/living/merc)
	merc_ref = WEAKREF(merc)
	merc_name = merc.real_name

/obj/item/merc_contract/examine(mob/user)
	. = ..()
	if(contract)
		. += span_info("[merc_name] is hired by [contract.hirer_name] for [contract.days] day\s.")
		return
	. += span_info("Hire mercenary [merc_name] for [days] day\s.")

/obj/item/merc_contract/attack_self(mob/user)
	var/mob/living/L = user
	if(!istype(L))
		return
	if(contract)
		to_chat(L, span_warning("This writ has already been signed."))
		return
	if(merc_ref?.resolve() == L)
		choose_days(L)
		return
	try_hire(L)

/obj/item/merc_contract/proc/choose_days(mob/living/merc)
	var/list/options = list()
	for(var/i in 1 to MERC_CONTRACT_MAX_DAYS)
		options += "[i]"
	var/choice = tgui_input_list(merc, "How many days will you hire yourself out for?", "Mercenary Writ", options, "[days]")
	if(!choice || contract || QDELETED(src))
		return
	days = text2num(choice)
	to_chat(merc, span_notice("The writ now offers your sword for [days] day\s."))

/obj/item/merc_contract/proc/try_hire(mob/living/hirer)
	var/mob/living/carbon/human/merc = merc_ref?.resolve()
	var/failure = hire_failure_reason(hirer, merc)
	if(failure)
		to_chat(hirer, span_warning(failure))
		return
	if(offered_by)
		to_chat(hirer, span_warning("Wait for [merc_name] to answer."))
		return
	if(tgui_alert(hirer, "Hire [merc_name] for [days] day\s? They will join your fellowship.", "Mercenary Writ", list("Yes", "No")) != "Yes")
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
	offer.desc = "[hirer.real_name] wants to hire you for [days] day\s. Click to accept."
	offered_by = WEAKREF(hirer)
	offer_timer_id = addtimer(CALLBACK(src, PROC_REF(expire_offer)), MERC_CONTRACT_ACCEPT_TIMEOUT, TIMER_STOPPABLE)
	to_chat(hirer, span_notice("You offer the writ to [merc_name]."))
	to_chat(merc, span_notice("[hirer.real_name] wants to hire you for [days] day\s. Click the alert to accept."))

/obj/item/merc_contract/proc/expire_offer()
	offer_timer_id = null
	var/mob/living/hirer = offered_by?.resolve()
	clear_offer()
	if(hirer)
		to_chat(hirer, span_warning("[merc_name] did not accept."))

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
		return
	var/failure = hire_failure_reason(hirer, merc)
	if(failure)
		to_chat(merc, span_warning(failure))
		to_chat(hirer, span_warning(failure))
		return
	var/datum/fellowship/F = hirer.current_fellowship
	if(merc.current_fellowship != F && !F.add_member(merc))
		to_chat(hirer, span_warning("[merc_name] could not join your fellowship."))
		return
	contract = new /datum/merc_contract(merc, hirer, F, src, days)
	name = "signed mercenary writ"
	to_chat(hirer, span_notice("You hire [merc_name] for [days] day\s."))
	to_chat(merc, span_notice("[hirer.real_name] has hired you for [days] day\s."))

/obj/item/merc_contract/proc/hire_failure_reason(mob/living/hirer, mob/living/merc)
	if(contract)
		return "This writ has already been signed."
	if(QDELETED(merc) || merc.stat == DEAD)
		return "[merc_name] is dead or gone."
	if(get_merc_contract(merc))
		return "[merc_name] is already hired."
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
	desc = "Someone wants to hire you. Click to accept."
	var/datum/weakref/item_ref

/atom/movable/screen/alert/merc_contract_offer/Click()
	var/obj/item/merc_contract/item = item_ref?.resolve()
	item?.accept_offer(usr)
	return TRUE
