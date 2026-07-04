#define UPGRADE_NOTAX		(1<<0)
#define PURITY_PUBLIC_MARGIN 0.5

/obj/structure/roguemachine/bathvend
	name = "BRASSFACE"
	desc = "A brass-faced cabinet wrought of Eora's hearth, that the lonely and weary may take comfort within."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "brassface"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/locked = FALSE
	var/budget = 0
	var/upgrade_flags
	var/current_cat = ""
	var/search_query = ""
	var/static/search_result_cap = 30
	var/lockid = "nightman"
	var/motto = "BRASSFACE - Sweet Dreams for Cheap."
	var/seedy_addendum = "Sweet, sweet, addiction. Love in the veins, comfort in my heart."
	/// Public variants ignore lock state and can be used by anyone.
	var/is_public = FALSE
	/// Public-tier margin tacked onto base price. Captured to bathhouse_fund on purchase.
	var/extra_fee = 0
	/// Jobs allowed to see Secrets panel and toggle proprietor-only state.
	var/list/profit_id = list("Bathmaster", "Bathhouse Attendant")
	/// Running tally of Crown import tariff actually collected via this specific machine.
	var/tariff_collected_here = 0
	/// Running tally of Crown import tariff that WOULD have been owed but was dodged.
	var/tariff_evaded_here = 0
	/// Running tally of Church bathhouse tithe collected via this machine while the
	/// Ordinance was in force.
	var/church_tithe_collected_here = 0
	var/list/categories = list(
		"Alcohols",
		"Discreet Zads",
		"Drugs",
		"Exotic Apparel",
		"Instruments",
		"Cosmetics",
		"Roguery",
		"Smokes",
	)

/obj/structure/roguemachine/bathvend/Initialize()
	. = ..()
	update_icon()

/obj/structure/roguemachine/bathvend/examine(mob/user)
	. = ..()
	if(!seedy_addendum)
		return
	var/mob/living/carbon/human/H = user
	if(!istype(H))
		return
	var/in_the_know = (H.job in profit_id) || (H.patron?.type == /datum/patron/inhumen/baotha)
	if(!in_the_know)
		return
	. += "<span class='info'><b style='color:pink'>[seedy_addendum]</b></span>"

/obj/structure/roguemachine/bathvend/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = "#1b7bf1")
	add_overlay(mutable_appearance(icon, "vendor-merch"))

/// Single source of truth for displayed and billed prices. Display-time and buy-time
/// both route through here so a mid-session edict rate change can never desync the
/// quoted price from the charged price.
/obj/structure/roguemachine/bathvend/proc/compute_pack_price(datum/supply_pack/PA)
	var/cost = PA.cost + PA.cost * extra_fee
	if(!(upgrade_flags & UPGRADE_NOTAX))
		cost += compute_pack_tax(PA)
	return round(cost)

/obj/structure/roguemachine/bathvend/proc/compute_pack_tax(datum/supply_pack/PA)
	return round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * PA.cost)

/obj/structure/roguemachine/bathvend/proc/serialize_pack(datum/supply_pack/PA, tariff_active)
	var/base = round(PA.cost + PA.cost * extra_fee)
	var/tariff = tariff_active ? compute_pack_tax(PA) : 0
	return list(
		"ref" = "[PA.type]",
		"name" = PA.name,
		"category" = PA.group,
		"qty" = PA.no_name_quantity ? 1 : PA.contains.len,
		"price_base" = base,
		"price_tariff" = tariff,
		"price" = base + tariff,
		"contraband" = PA.contraband ? TRUE : FALSE,
	)

/obj/structure/roguemachine/bathvend/proc/pack_visible_to(datum/supply_pack/PA, can_see_contraband)
	if(!(PA.group in categories))
		return FALSE
	if(PA.not_in_public && is_public)
		return FALSE
	if(PA.contraband && !can_see_contraband)
		return FALSE
	return TRUE

/obj/structure/roguemachine/bathvend/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(is_public)
			to_chat(user, span_warning("This is a public vendor. Keys won't work here."))
			return
		if(K.lockid == lockid || istype(K, /obj/item/roguekey/skeleton))
			locked = !locked
			playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
			update_icon()
			to_chat(user, span_notice("[src] [locked ? "locks" : "unlocks"]."))
			if(locked)
				SStgui.close_uis(src)
			return
		to_chat(user, span_warning("Wrong key."))
		return
	if(istype(P, /obj/item/storage/keyring))
		if(is_public)
			to_chat(user, span_warning("This is a public vendor. Keys won't work here."))
			return
		var/right_key = FALSE
		for(var/obj/item/roguekey/KE in P.contents)
			if(KE.lockid == lockid || istype(KE, /obj/item/roguekey/skeleton))
				right_key = TRUE
				locked = !locked
				playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
				update_icon()
				to_chat(user, span_notice("[src] [locked ? "locks" : "unlocks"]."))
				if(locked)
					SStgui.close_uis(src)
				break
		if(!right_key)
			to_chat(user, span_warning("Wrong key."))
		return
	if(istype(P, /obj/item/roguecoin/aalloy))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		budget += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)
	..()

/obj/structure/roguemachine/bathvend/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/bathvend/ui_interact(mob/user, datum/tgui/ui)
	if(!ishuman(user))
		return
	if(locked && !is_public)
		to_chat(user, span_warning("It's locked. Of course."))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		playsound(loc, 'sound/misc/gold_menu.ogg', 100, FALSE, -1)
		ui = new(user, src, "Brassface", name)
		ui.open()

/obj/structure/roguemachine/bathvend/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_FAST)
	ui_interact(user)

/obj/structure/roguemachine/bathvend/ui_data(mob/user)
	var/list/data = list()
	var/mob/living/carbon/human/H = user
	var/can_read = istype(H) ? H.can_read(src, TRUE) : FALSE
	var/is_proprietor = istype(H) && (H.job in profit_id)
	var/dodging = (upgrade_flags & UPGRADE_NOTAX) ? TRUE : FALSE
	var/ordinance_active = SStreasury.bathhouse_ordinance_active ? TRUE : FALSE
	// Contraband visibility: behind the locked counter to the Bathmaster/Attendant.
	// The public PURITY never exposes contraband regardless of who's standing there.
	var/can_see_contraband = is_proprietor && !is_public

	data["motto"] = motto
	data["budget"] = budget
	data["locked"] = locked ? TRUE : FALSE
	data["is_public"] = is_public ? TRUE : FALSE
	data["is_proprietor"] = is_proprietor ? TRUE : FALSE
	data["can_read"] = can_read ? TRUE : FALSE
	data["can_see_contraband"] = can_see_contraband ? TRUE : FALSE
	data["tariff_rate_pct"] = round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * 100)
	data["tariff_paid"] = tariff_collected_here
	data["tariff_evaded"] = tariff_evaded_here
	data["church_tithe_paid"] = church_tithe_collected_here
	data["dodging"] = dodging
	data["ordinance_active"] = ordinance_active
	data["tithe_rate_pct"] = round(BATHHOUSE_BRASSFACE_TITHE_RATE * 100)

	data["categories"] = categories.Copy()
	data["current_category"] = current_cat
	data["search"] = search_query
	data["search_mode"] = (search_query != "") ? TRUE : FALSE
	data["result_cap"] = search_result_cap

	var/list/packs_data = list()
	var/total_matches = 0
	var/tariff_active = !(upgrade_flags & UPGRADE_NOTAX)
	if(search_query != "")
		var/needle = lowertext(search_query)
		var/list/matches = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(!pack_visible_to(PA, can_see_contraband))
				continue
			if(findtext(lowertext(PA.name), needle) || findtext(lowertext(PA.group), needle))
				matches += PA
		total_matches = length(matches)
		var/shown = 0
		for(var/datum/supply_pack/PA in sortNames(matches))
			if(shown >= search_result_cap)
				break
			shown++
			packs_data += list(serialize_pack(PA, tariff_active))
	else if(current_cat)
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.group != current_cat)
				continue
			if(!pack_visible_to(PA, can_see_contraband))
				continue
			pax += PA
		total_matches = length(pax)
		for(var/datum/supply_pack/PA in sortNames(pax))
			packs_data += list(serialize_pack(PA, tariff_active))
	data["packs"] = packs_data
	data["total_matches"] = total_matches
	return data

/obj/structure/roguemachine/bathvend/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	if(locked && !is_public)
		return
	var/mob/living/carbon/human/H = usr
	switch(action)
		if("changecat")
			var/cat = "[params["category"]]"
			if(cat == "")
				current_cat = ""
			else if(cat in categories)
				current_cat = cat
				search_query = ""
			return TRUE
		if("set_search")
			search_query = "[params["search"]]"
			return TRUE
		if("clear_search")
			search_query = ""
			return TRUE
		if("change")
			if(budget > 0)
				budget2change(budget, usr)
				budget = 0
			return TRUE
		if("buy")
			return handle_buy(H, params)
		if("secrets")
			return handle_secrets(H, params)

/obj/structure/roguemachine/bathvend/proc/handle_buy(mob/living/carbon/human/H, list/params)
	var/path = text2path(params["ref"])
	if(!ispath(path, /datum/supply_pack))
		message_admins("silly MOTHERFUCKER [usr.key] IS TRYING TO BUY A [path] WITH THE [src.name]")
		return TRUE
	var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
	if(!PA)
		return TRUE
	var/is_proprietor = (H.job in profit_id)
	var/can_see_contraband = is_proprietor && !is_public
	if(!pack_visible_to(PA, can_see_contraband))
		return TRUE
	var/cost = compute_pack_price(PA)
	var/tax_amt = compute_pack_tax(PA)
	if(budget < cost)
		say("Not enough!")
		return TRUE
	budget -= cost
	on_purchase(PA, cost, tax_amt, H)
	for(var/pathi in PA.contains)
		new pathi(get_turf(H))
	return TRUE

/// Tariff routing: when the Ordinance is in force, the Crown's import tariff is
/// diverted to the Church as a bathhouse tithe at BATHHOUSE_BRASSFACE_TITHE_RATE.
/// When the Ordinance is broken, the tariff flows to the Crown's discretionary fund
/// as standard import duty. The NOTAX upgrade dodges both.
/obj/structure/roguemachine/bathvend/proc/on_purchase(datum/supply_pack/PA, cost, tax_amt, mob/living/carbon/human/buyer)
	if(upgrade_flags & UPGRADE_NOTAX)
		record_round_statistic(STATS_TAXES_EVADED, tax_amt)
		tariff_evaded_here += tax_amt
		return
	if(SStreasury.bathhouse_ordinance_active)
		var/bathhouse_tithe = SStreasury.compute_bathhouse_tithe(cost, BATHHOUSE_BRASSFACE_TITHE_RATE)
		if(bathhouse_tithe > 0)
			SStreasury.mint(SStreasury.church_fund, bathhouse_tithe, "Ordinance of the Baths tithe ([src.name])")
			church_tithe_collected_here += bathhouse_tithe
		return
	SStreasury.mint(SStreasury.discretionary_fund, tax_amt, "[TAX_CATEGORY_IMPORT_TARIFF] ([src.name])")
	record_featured_stat(FEATURED_STATS_TAX_PAYERS, buyer, tax_amt)
	record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
	record_round_statistic(STATS_REVENUE_IMPORT_TARIFF, tax_amt)
	tariff_collected_here += tax_amt

/obj/structure/roguemachine/bathvend/proc/handle_secrets(mob/living/carbon/human/H, list/params)
	if(!(H.job in profit_id))
		return TRUE
	var/option = "[params["option"]]"
	switch(option)
		if("toggle_tax")
			upgrade_flags ^= UPGRADE_NOTAX
			playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
			if(upgrade_flags & UPGRADE_NOTAX)
				playsound(loc, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
			return TRUE
	return TRUE

/obj/structure/roguemachine/bathvend/obj_break(damage_flag)
	..()
	var/turf/T = get_turf(src)
	budget2change(budget, custom_turf = T)
	set_light(0)
	update_icon()
	icon_state = "goldvendor0"

/obj/structure/roguemachine/bathvend/Destroy()
	set_light(0)
	return ..()

/obj/structure/roguemachine/bathvend/public
	name = "PURITY"
	desc = "A pillar of the bathhouse's solace, in Eora's name."
	icon_state = "purity"
	light_outer_range = 6
	light_color = "#ff13d8ff"
	is_public = TRUE
	locked = FALSE
	motto = "PURITY - Solace for the Lonely and Weary."
	profit_id = list("Bathmaster")
	seedy_addendum = "You want to destroy your life."
	extra_fee = PURITY_PUBLIC_MARGIN
	categories = list(
		"Drugs",
		"Smokes",
		"Cosmetics",
	)
	var/recent_payments = 0
	var/last_payout = 0

/obj/structure/roguemachine/bathvend/public/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = "#1b7bf1")
	add_overlay(mutable_appearance(icon, "vendor-drug"))

/obj/structure/roguemachine/bathvend/public/Initialize()
	. = ..()
	START_PROCESSING(SSroguemachine, src)

/obj/structure/roguemachine/bathvend/public/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	return ..()

/obj/structure/roguemachine/bathvend/public/process()
	if(!recent_payments)
		return
	if(world.time < last_payout + rand(6 MINUTES, 8 MINUTES))
		return
	var/amt = round(recent_payments * extra_fee)
	recent_payments = 0
	last_payout = world.time
	if(amt > 0)
		SStreasury.mint(SStreasury.bathhouse_fund, amt, "PURITY margin")
	send_ooc_note("<b>Income from PURITY (deposited to Bathhouse Fund):</b> [amt]", job = "Bathmaster")

/obj/structure/roguemachine/bathvend/public/obj_break(damage_flag)
	..()
	icon_state = "streetvendor0"

/obj/structure/roguemachine/bathvend/public/on_purchase(datum/supply_pack/PA, cost, tax_amt, mob/living/carbon/human/buyer)
	..()
	// Base cost (pre-tariff) is what feeds the wash; this keeps the kickback proportional
	// to the actual sale rather than to whatever tariff regime is currently in force.
	recent_payments += PA.cost
	record_round_statistic(STATS_PURITY_VALUE_SPENT, cost)


#undef UPGRADE_NOTAX
#undef PURITY_PUBLIC_MARGIN

SUBSYSTEM_DEF(BMtreasury)
	name = "BMtreasury"
	wait = 60 SECONDS // this should not need to run very often.
	priority = FIRE_PRIORITY_WATER_LEVEL
	var/treasury_value = 0
	var/multiple_item_penalty = 0.7
	var/interest_rate = 0.15 // Bit more interest, since it's gonna be much harder for the BMaster to get valuables.
	var/next_treasury_check = 0
	var/list/vault_accounting = list()

/datum/controller/subsystem/BMtreasury/proc/add_to_vault(var/obj/item/I)
	if(I.get_real_price() <= 0 || istype(I, /obj/item/roguecoin) || istype(I, /obj/item/storage))
		return
	if(I.type in vault_accounting)
		vault_accounting[I.type] *= multiple_item_penalty
	else
		vault_accounting[I.type] = I.get_real_price()
	return (vault_accounting[I.type]*interest_rate)

/datum/controller/subsystem/BMtreasury/fire()
	if(!(world.time > next_treasury_check)) // Skip this fire if it's not time for another check.
		return

	next_treasury_check = world.time + 6 MINUTES
	tick_vault_income()

/datum/controller/subsystem/BMtreasury/proc/tick_vault_income()
	var/obj/structure/roguemachine/vaultbank/jawbank = SStreasury.find_jawbank_for_fund_id("bathhouse")
	if(!jawbank)
		return 0

	vault_accounting = list()
	var/amt_to_generate = 0

	// Still absolutely sucks; Effectively looking through absolutely everything in range to find a couple floors; then again on things on bricks to calculate their value.
	// Alternatively could check the jawbank's area and iterate through the things within; in area == in world; so that'd be probably worse.
	// Best way I think would be to add things to a list on area Entered and remove it on area Exit for the purposes of collection-- right now I'm just working on the world loops.
	for(var/turf/open/floor/rogue/churchbrick/bathbrick in RANGE_TURFS(5, jawbank))
		for(var/obj/item/item in bathbrick.contents)
			if(!isturf(item.loc)) // This shouldn't pick up things that aren't on the turf anyway-- should always be false.
				continue
			amt_to_generate += add_to_vault(item)

		for(var/obj/structure/closet/closet in bathbrick.contents)
			for(var/obj/item/item in closet)
				amt_to_generate += add_to_vault(item)

	amt_to_generate = round(amt_to_generate, 1)
	var/tithe = SStreasury.compute_bathhouse_tithe(amt_to_generate, BATHHOUSE_VAULT_TITHE_RATE)
	if(tithe > 0 && SStreasury.church_fund)
		amt_to_generate -= tithe
		SStreasury.church_fund.balance += tithe
	if(SStreasury.bathhouse_fund)
		SStreasury.bathhouse_fund.balance += amt_to_generate
	send_ooc_note("Regular income to the Bathhouse Fund: +[amt_to_generate][tithe > 0 ? " (after [tithe]m tithe to the Church)" : ""]", job = "Bathmaster")
	record_round_statistic(STATS_BATHMATRON_VAULT_TOTAL_REVENUE, amt_to_generate)
	return amt_to_generate
