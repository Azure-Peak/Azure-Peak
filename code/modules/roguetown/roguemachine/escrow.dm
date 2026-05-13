#define ESCROW_OPEN_EXPIRY_DAYS 3
#define ESCROW_CLAIM_EXPIRY_DAYS 1
#define ESCROW_PARTIAL_HAIRCUT_PERCENT 20
#define ESCROW_DURABILITY_FLOOR 0.8

/datum/escrow_order
	var/commissioner_ckey
	var/commissioner_name
	var/datum/weakref/commissioner_ref
	var/smith_ckey
	var/smith_name
	var/list/recipe_quantities = list()
	var/deposited = 0
	var/list/delivered_items = list()
	var/list/delivered_counts = list()
	var/status = "open"
	var/day_posted = 0
	var/day_claimed = 0
	var/commissioner_note = ""

/datum/escrow_order/proc/label()
	var/list/parts = list()
	for(var/key in recipe_quantities)
		var/name_str
		if(istype(key, /datum/anvil_recipe))
			var/datum/anvil_recipe/AR = key
			name_str = AR.name
		else if(istype(key, /datum/crafting_recipe))
			var/datum/crafting_recipe/CR = key
			name_str = CR.name
		parts += "[name_str] x[recipe_quantities[key]]"
	return jointext(parts, ", ")

/datum/escrow_order/proc/required_result_counts()
	var/list/out = list()
	for(var/key in recipe_quantities)
		var/want = recipe_quantities[key]
		var/result_path
		if(istype(key, /datum/anvil_recipe))
			var/datum/anvil_recipe/AR = key
			result_path = AR.created_item
			want *= max(1, AR.createditem_num)
		else if(istype(key, /datum/crafting_recipe))
			var/datum/crafting_recipe/CR = key
			if(islist(CR.result))
				var/list/rl = CR.result
				if(length(rl))
					result_path = rl[1]
			else
				result_path = CR.result
		if(!result_path)
			continue
		out[result_path] = (out[result_path] || 0) + want
	return out

/datum/escrow_order/proc/is_fulfilled()
	var/list/needed = required_result_counts()
	if(!length(needed))
		return FALSE
	for(var/path in needed)
		if((delivered_counts[path] || 0) < needed[path])
			return FALSE
	return TRUE

/datum/escrow_order/proc/try_accept_item(obj/item/I)
	if(I.max_integrity > 0 && I.obj_integrity < I.max_integrity * ESCROW_DURABILITY_FLOOR)
		return "damaged"
	var/list/needed = required_result_counts()
	for(var/path in needed)
		if(I.type != path)
			continue
		if((delivered_counts[path] || 0) < needed[path])
			delivered_counts[path] = (delivered_counts[path] || 0) + 1
			delivered_items += I
			return TRUE
	return FALSE

/obj/structure/roguemachine/escrow
	name = "COMMISSIONER"
	desc = "A brass-plated contraption with a coin slot above and an iron strongbox beneath. The guild posts and fulfills smithing or engineering work here, coin held in escrow until the job is done."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	integrity_failure = 0.1
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/list/keycontrol = list("crafterguild", "craftermaster")
	var/locked = TRUE
	var/budget = 0
	var/list/material_prices = list(
		/obj/item/ingot/copper = 12,
		/obj/item/ingot/bronze = 18,
		/obj/item/ingot/iron = 20,
		/obj/item/ingot/steel = 30,
		/obj/item/ingot/steelholy = 120,
		/obj/item/ingot/blacksteel = 100,
		/obj/item/ingot/silver = 100,
		/obj/item/ingot/silverblessed = 200,
		/obj/item/ingot/silverblessed/bullion = 200,
		/obj/item/ingot/gold = 80,
		/obj/item/ingot/lithmyc = 250,
		/obj/item/ingot/purifiedaalloy = 500,
		/obj/item/grown/log/tree/small = 3,
		/obj/item/natural/wood/plank = 5,
		/obj/item/roguegear = 8,
		/obj/item/natural/glass = 6,
	)
	var/percent_margin = 20
	var/flat_margin = 0
	var/list/orders = list()
	var/list/manifests = list()
	var/list/manifest_deposits = list()
	var/list/catalog

/obj/structure/roguemachine/escrow/Initialize()
	. = ..()
	rebuild_catalog()
	update_icon()

/obj/structure/roguemachine/escrow/Destroy()
	orders?.Cut()
	manifests?.Cut()
	manifest_deposits?.Cut()
	return ..()

/obj/structure/roguemachine/escrow/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Any commissioner may build a manifest of smithing or engineering recipes and deposit coin into the machine. Submitting the manifest posts an order with the coin held in escrow.")
	. += span_info("A smith can claim an open order, deliver the finished items back into the machine, and collect the escrowed pay once every item has been delivered. An order that has been claimed cannot be cancelled by the commissioner.")
	. += span_info("Unlocked with the guildmaster's key, material prices and margins can be adjusted.")

/obj/structure/roguemachine/escrow/proc/rebuild_catalog()
	catalog = list()
	for(var/datum/anvil_recipe/AR in GLOB.anvil_recipes)
		if(AR.hides_from_books || !AR.name || !AR.created_item || !AR.req_bar)
			continue
		if(!(AR.req_bar in material_prices))
			continue
		catalog += AR
	for(var/datum/crafting_recipe/roguetown/engineering/CR in GLOB.crafting_recipes)
		if(CR.hides_from_books || !CR.name || !CR.result)
			continue
		catalog += CR

/obj/structure/roguemachine/escrow/proc/recipe_name(datum/recipe)
	if(istype(recipe, /datum/anvil_recipe))
		var/datum/anvil_recipe/AR = recipe
		return AR.name
	var/datum/crafting_recipe/CR = recipe
	return CR.name

/obj/structure/roguemachine/escrow/proc/recipe_category(datum/recipe)
	if(istype(recipe, /datum/anvil_recipe))
		var/datum/anvil_recipe/AR = recipe
		return AR.display_category || ITEM_CAT_SMITHING_MISC
	if(istype(recipe, /datum/crafting_recipe/roguetown/engineering))
		var/datum/crafting_recipe/roguetown/engineering/CR = recipe
		return CR.display_category || ITEM_CAT_ENG_MISC
	return ITEM_CAT_SMITHING_MISC

/obj/structure/roguemachine/escrow/proc/recipe_primary_ingot(datum/recipe)
	if(istype(recipe, /datum/anvil_recipe))
		var/datum/anvil_recipe/AR = recipe
		return AR.req_bar
	if(istype(recipe, /datum/crafting_recipe))
		var/datum/crafting_recipe/CR = recipe
		if(!islist(CR.reqs))
			return null
		var/best_path
		var/best_qty = 0
		for(var/path in CR.reqs)
			if(!(path in material_prices))
				continue
			var/qty = CR.reqs[path]
			if(qty > best_qty)
				best_qty = qty
				best_path = path
		return best_path
	return null

/obj/structure/roguemachine/escrow/proc/recipe_material_cost(datum/recipe)
	var/total = 0
	if(istype(recipe, /datum/anvil_recipe))
		var/datum/anvil_recipe/AR = recipe
		total += material_prices[AR.req_bar] || 0
		if(islist(AR.additional_items))
			for(var/path in AR.additional_items)
				total += material_prices[path] || 0
	else if(istype(recipe, /datum/crafting_recipe))
		var/datum/crafting_recipe/CR = recipe
		if(islist(CR.reqs))
			for(var/path in CR.reqs)
				total += (material_prices[path] || 0) * CR.reqs[path]
	return total

/obj/structure/roguemachine/escrow/proc/recipe_price(datum/recipe)
	var/base = recipe_material_cost(recipe)
	return round(base * (1 + percent_margin / 100)) + flat_margin

/obj/structure/roguemachine/escrow/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid in keycontrol)
			toggle_lock(user)
			return
		to_chat(user, span_warning("Wrong key."))
		return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/KR = P
		for(var/obj/item/roguekey/KE in KR)
			if(KE.lockid in keycontrol)
				toggle_lock(user)
				return

	if(!locked)
		return ..()

	if(istype(P, /obj/item/roguecoin/aalloy) || istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		if(!user.ckey)
			return
		manifest_deposits[user.ckey] = (manifest_deposits[user.ckey] || 0) + P.get_real_price()
		qdel(P)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		SStgui.update_uis(src)
		return

	if(ishuman(user))
		try_smith_deliver(P, user)

/obj/structure/roguemachine/escrow/proc/toggle_lock(mob/user)
	locked = !locked
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	update_icon()
	SStgui.update_uis(src)

/obj/structure/roguemachine/escrow/proc/try_smith_deliver(obj/item/I, mob/user)
	for(var/datum/escrow_order/O in orders)
		if(O.status != "claimed" || O.smith_ckey != user.ckey)
			continue
		var/result = O.try_accept_item(I)
		if(result == "damaged")
			to_chat(user, span_warning("[src] refuses [I] - the work is too damaged to deliver. Mend it first."))
			return
		if(result)
			I.forceMove(src)
			playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("[src] accepts [I]."))
			SStgui.update_uis(src)
			return
	to_chat(user, span_warning("[src] has no order waiting for [I]."))

/obj/structure/roguemachine/escrow/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/escrow/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	ui_interact(user)

/obj/structure/roguemachine/escrow/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		ui = new(user, src, "Commissioner", name)
		ui.open()

/obj/structure/roguemachine/escrow/proc/is_guildmaster(mob/user)
	if(!ishuman(user))
		return FALSE
	for(var/obj/item/roguekey/K in user.GetAllContents())
		if(K.lockid in keycontrol)
			return TRUE
	return FALSE

/obj/structure/roguemachine/escrow/proc/reject_order(datum/escrow_order/O, mob/user, reason = "")
	if(!O || O.status == "complete")
		return
	if(O.status == "claimed" && user.ckey != O.smith_ckey && !is_guildmaster(user))
		return
	if(O.status == "open" && !is_guildmaster(user))
		return
	orders -= O
	var/payout = O.deposited
	O.deposited = 0
	budget -= payout
	var/turf/T = get_turf(src)
	for(var/obj/item/I in O.delivered_items)
		I.forceMove(T)
	O.delivered_items.Cut()
	if(payout > 0)
		manifest_deposits[O.commissioner_ckey] = (manifest_deposits[O.commissioner_ckey] || 0) + payout
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/clean_reason = reason ? copytext(sanitize(reason), 1, 200) : ""
	var/say_msg = "[user.real_name] rejects [O.commissioner_name]'s commission ([O.label()])"
	if(clean_reason)
		say_msg += ": \"[clean_reason]\""
	say_msg += "."
	say(say_msg)
	var/notify_msg = "[user.real_name] has rejected your commission at [src]. [payout]m has been returned to your deposit."
	if(clean_reason)
		notify_msg += " Reason: \"[clean_reason]\""
	notify_commissioner(O, notify_msg)
	update_icon()

/obj/structure/roguemachine/escrow/proc/prune_expired_orders()
	var/turf/T = get_turf(src)
	for(var/datum/escrow_order/O in orders.Copy())
		if(O.status == "open" && GLOB.dayspassed - O.day_posted >= ESCROW_OPEN_EXPIRY_DAYS)
			orders -= O
			budget -= O.deposited
			if(O.deposited > 0)
				manifest_deposits[O.commissioner_ckey] = (manifest_deposits[O.commissioner_ckey] || 0) + O.deposited
			notify_commissioner(O, "Your unclaimed commission at [src] has expired. [O.deposited]m has been returned to your deposit.")
			O.deposited = 0
		else if(O.status == "claimed" && O.day_claimed && GLOB.dayspassed - O.day_claimed >= ESCROW_CLAIM_EXPIRY_DAYS)
			for(var/obj/item/I in O.delivered_items)
				I.forceMove(T)
			O.delivered_items.Cut()
			O.delivered_counts.Cut()
			O.status = "open"
			O.smith_ckey = null
			O.smith_name = null
			O.day_claimed = 0
			notify_commissioner(O, "The claim on your commission at [src] has expired; the order is open again for new smiths.")

/obj/structure/roguemachine/escrow/ui_data(mob/user)
	prune_expired_orders()
	var/list/data = list()
	data["locked"] = locked ? TRUE : FALSE
	data["can_read"] = (ishuman(user) && user.can_read(src, TRUE)) ? TRUE : FALSE
	data["is_guildmaster"] = is_guildmaster(user) ? TRUE : FALSE
	data["budget"] = budget
	data["my_deposit"] = manifest_deposits[user.ckey] || 0
	data["percent_margin"] = percent_margin
	data["flat_margin"] = flat_margin

	var/list/catalog_data = list()
	var/list/cats = list()
	var/list/ingots = list()
	for(var/datum/R in catalog)
		var/cat = recipe_category(R)
		if(!(cat in cats))
			cats += cat
		var/primary_ingot = recipe_primary_ingot(R)
		var/ingot_name = ""
		if(primary_ingot)
			var/atom/AP = primary_ingot
			ingot_name = initial(AP.name)
			if(!(ingot_name in ingots))
				ingots += ingot_name
		catalog_data += list(list(
			"ref" = "\ref[R]",
			"name" = recipe_name(R),
			"category" = cat,
			"price" = recipe_price(R),
			"ingot" = ingot_name,
		))
	data["catalog"] = catalog_data
	data["categories"] = cats
	data["ingots"] = ingots

	var/list/manifest_data = list()
	var/list/cart = manifests[user.ckey]
	var/manifest_total = 0
	if(cart)
		for(var/datum/R in cart)
			var/qty = cart[R]
			var/unit = recipe_price(R)
			var/line_total = unit * qty
			manifest_total += line_total
			manifest_data += list(list(
				"ref" = "\ref[R]",
				"name" = recipe_name(R),
				"category" = recipe_category(R),
				"qty" = qty,
				"unit_price" = unit,
				"line_total" = line_total,
			))
	data["manifest"] = manifest_data
	data["manifest_total"] = manifest_total

	var/list/orders_data = list()
	for(var/datum/escrow_order/O in orders)
		var/is_commissioner = (user.ckey == O.commissioner_ckey)
		var/is_smith = (user.ckey == O.smith_ckey)
		var/list/order_lines = list()
		for(var/datum/R in O.recipe_quantities)
			order_lines += list(list(
				"name" = recipe_name(R),
				"qty" = O.recipe_quantities[R],
			))
		var/list/needed = O.required_result_counts()
		var/list/fulfillment = list()
		var/done_count = 0
		var/needed_count = 0
		for(var/path in needed)
			var/want = needed[path]
			var/have = O.delivered_counts[path] || 0
			done_count += min(have, want)
			needed_count += want
			var/atom/A = path
			fulfillment += list(list(
				"name" = initial(A.name),
				"have" = have,
				"want" = want,
			))
		var/days_left = 0
		var/expiry_label = ""
		if(O.status == "open")
			days_left = max(0, ESCROW_OPEN_EXPIRY_DAYS - (GLOB.dayspassed - O.day_posted))
			expiry_label = "expires in"
		else if(O.status == "claimed" && O.day_claimed)
			days_left = max(0, ESCROW_CLAIM_EXPIRY_DAYS - (GLOB.dayspassed - O.day_claimed))
			expiry_label = "claim expires in"
		orders_data += list(list(
			"ref" = "\ref[O]",
			"commissioner_name" = O.commissioner_name,
			"smith_name" = O.smith_name || "",
			"deposited" = O.deposited,
			"status" = O.status,
			"lines" = order_lines,
			"fulfillment" = fulfillment,
			"done_count" = done_count,
			"needed_count" = needed_count,
			"is_commissioner" = is_commissioner ? TRUE : FALSE,
			"is_smith" = is_smith ? TRUE : FALSE,
			"is_fulfilled" = O.is_fulfilled() ? TRUE : FALSE,
			"days_left" = days_left,
			"expiry_label" = expiry_label,
			"note" = O.commissioner_note,
		))
	data["orders"] = orders_data

	var/list/materials_data = list()
	for(var/path in material_prices)
		var/atom/A = path
		materials_data += list(list(
			"path" = "[path]",
			"name" = initial(A.name),
			"price" = material_prices[path],
		))
	data["materials"] = materials_data
	return data

/obj/structure/roguemachine/escrow/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	if(is_guildmaster(usr))
		switch(action)
			if("set_percent_margin")
				var/n = text2num(params["value"])
				if(isnum(n))
					percent_margin = clamp(round(n), 0, 500)
				return TRUE
			if("set_flat_margin")
				var/n = text2num(params["value"])
				if(isnum(n))
					flat_margin = max(0, round(n))
				return TRUE
			if("set_material_price")
				var/path = text2path(params["path"])
				var/n = text2num(params["value"])
				if(path && (path in material_prices) && isnum(n))
					material_prices[path] = max(0, round(n))
				return TRUE
			if("toggle_lock")
				toggle_lock(usr)
				return TRUE

	if(!locked)
		return

	switch(action)
		if("manifest_inc")
			var/datum/R = locate(params["ref"]) in catalog
			if(R)
				manifest_change(usr, R, text2num(params["delta"]) || 1)
			return TRUE
		if("manifest_dec")
			var/datum/R = locate(params["ref"]) in catalog
			if(R)
				manifest_change(usr, R, -(text2num(params["delta"]) || 1))
			return TRUE
		if("manifest_remove")
			var/datum/R = locate(params["ref"]) in catalog
			var/list/cart = manifests[usr.ckey]
			if(R && cart)
				cart -= R
			return TRUE
		if("submit_manifest")
			submit_manifest(usr, params["note"])
			return TRUE
		if("refund_deposit")
			refund_deposit(usr)
			return TRUE
		if("cancel_order")
			var/datum/escrow_order/O = locate(params["ref"]) in orders
			if(O)
				cancel_order(O, usr)
			return TRUE
		if("claim_order")
			var/datum/escrow_order/O = locate(params["ref"]) in orders
			if(O)
				claim_order(O, usr)
			return TRUE
		if("release_order")
			var/datum/escrow_order/O = locate(params["ref"]) in orders
			if(O)
				release_order(O, usr)
			return TRUE
		if("complete_order")
			var/datum/escrow_order/O = locate(params["ref"]) in orders
			if(O)
				complete_order(O, usr)
			return TRUE
		if("collect_order")
			var/datum/escrow_order/O = locate(params["ref"]) in orders
			if(O)
				collect_order(O, usr)
			return TRUE
		if("force_release_order")
			if(!is_guildmaster(usr))
				return TRUE
			var/datum/escrow_order/O = locate(params["ref"]) in orders
			if(O)
				release_order(O, usr, TRUE)
			return TRUE
		if("reject_order")
			var/datum/escrow_order/O = locate(params["ref"]) in orders
			if(O)
				reject_order(O, usr, params["reason"])
			return TRUE
		if("settle_partial")
			var/datum/escrow_order/O = locate(params["ref"]) in orders
			if(O)
				settle_partial_order(O, usr)
			return TRUE

/obj/structure/roguemachine/escrow/proc/manifest_change(mob/user, datum/R, delta)
	if(!user.ckey || !R)
		return
	if(!manifests[user.ckey])
		manifests[user.ckey] = list()
	var/list/cart = manifests[user.ckey]
	var/newval = (cart[R] || 0) + delta
	if(newval <= 0)
		cart -= R
	else
		cart[R] = min(newval, 50)

/obj/structure/roguemachine/escrow/proc/manifest_total(mob/user)
	var/total = 0
	var/list/cart = manifests[user.ckey]
	if(!cart)
		return 0
	for(var/key in cart)
		total += recipe_price(key) * cart[key]
	return total

/obj/structure/roguemachine/escrow/proc/submit_manifest(mob/user, note = "")
	var/list/cart = manifests[user.ckey]
	if(!length(cart))
		return
	var/total = manifest_total(user)
	var/deposit = manifest_deposits[user.ckey] || 0
	if(deposit < total)
		to_chat(user, span_warning("Not enough deposited. Need [total]mm, have [deposit]mm."))
		return
	var/datum/escrow_order/O = new()
	O.commissioner_ckey = user.ckey
	O.commissioner_name = user.real_name
	O.commissioner_ref = WEAKREF(user)
	O.day_posted = GLOB.dayspassed
	if(note)
		O.commissioner_note = copytext(sanitize(note), 1, 200)
	for(var/key in cart)
		O.recipe_quantities[key] = cart[key]
	O.deposited = total
	orders += O
	budget += total
	manifest_deposits[user.ckey] = deposit - total
	manifests -= user.ckey
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	to_chat(user, span_notice("Your commission has been posted."))
	update_icon()

/obj/structure/roguemachine/escrow/proc/refund_deposit(mob/user)
	var/deposit = manifest_deposits[user.ckey] || 0
	if(deposit <= 0)
		return
	manifest_deposits[user.ckey] = 0
	budget2change(deposit, user)
	playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/escrow/proc/cancel_order(datum/escrow_order/O, mob/user)
	if(!O || O.status != "open" || user.ckey != O.commissioner_ckey)
		return
	orders -= O
	var/payout = O.deposited
	O.deposited = 0
	budget -= payout
	budget2change(payout, user)
	playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
	update_icon()

/obj/structure/roguemachine/escrow/proc/claim_order(datum/escrow_order/O, mob/user)
	if(!O || O.status != "open")
		return
	if(!is_guildmaster(user))
		to_chat(user, span_warning("Only a member of the crafter's guild may claim a commission."))
		return
	O.status = "claimed"
	O.smith_ckey = user.ckey
	O.smith_name = user.real_name
	O.day_claimed = GLOB.dayspassed
	to_chat(user, span_notice("You claim [O.commissioner_name]'s commission."))
	notify_commissioner(O, "[user.real_name] has claimed your commission at [src].")

/obj/structure/roguemachine/escrow/proc/release_order(datum/escrow_order/O, mob/user, forced = FALSE)
	if(!O || O.status != "claimed")
		return
	if(!forced && user.ckey != O.smith_ckey)
		return
	var/turf/T = get_turf(src)
	for(var/obj/item/I in O.delivered_items)
		I.forceMove(T)
	O.delivered_items.Cut()
	O.delivered_counts.Cut()
	O.status = "open"
	O.smith_ckey = null
	O.smith_name = null
	O.day_claimed = 0
	if(forced)
		notify_commissioner(O, "The guildmaster has released the stalled claim on your commission at [src].")

/obj/structure/roguemachine/escrow/proc/settle_partial_order(datum/escrow_order/O, mob/user)
	if(!O || O.status != "claimed" || user.ckey != O.smith_ckey)
		return
	var/list/needed = O.required_result_counts()
	var/done_count = 0
	var/needed_count = 0
	for(var/path in needed)
		var/want = needed[path]
		var/have = O.delivered_counts[path] || 0
		done_count += min(have, want)
		needed_count += want
	if(done_count <= 0)
		to_chat(user, span_warning("Nothing has been delivered yet. Release the claim instead."))
		return
	if(done_count >= needed_count)
		complete_order(O, user)
		return
	var/progress_ratio = done_count / needed_count
	var/smith_payout = round(O.deposited * progress_ratio * (100 - ESCROW_PARTIAL_HAIRCUT_PERCENT) / 100)
	var/commissioner_refund = O.deposited - smith_payout
	var/turf/T = get_turf(src)
	for(var/obj/item/I in O.delivered_items)
		I.forceMove(T)
	O.delivered_items.Cut()
	orders -= O
	budget -= O.deposited
	O.deposited = 0
	if(smith_payout > 0)
		budget2change(smith_payout, user)
	if(commissioner_refund > 0)
		manifest_deposits[O.commissioner_ckey] = (manifest_deposits[O.commissioner_ckey] || 0) + commissioner_refund
	playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
	to_chat(user, span_notice("Settled partial commission: you collect [smith_payout]m. [commissioner_refund]m has been returned to [O.commissioner_name]'s deposit."))
	notify_commissioner(O, "Your commission at [src] was partially fulfilled ([done_count]/[needed_count]). Items have been left at the docks; [commissioner_refund]m has been returned to your deposit.")
	update_icon()

/obj/structure/roguemachine/escrow/proc/complete_order(datum/escrow_order/O, mob/user)
	if(!O || O.status != "claimed" || user.ckey != O.smith_ckey)
		return
	if(!O.is_fulfilled())
		to_chat(user, span_warning("The order is not yet complete."))
		return
	O.status = "complete"
	var/payout = O.deposited
	O.deposited = 0
	budget -= payout
	budget2change(payout, user)
	playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
	notify_commissioner(O, "Your commission at [src] is ready for collection: [O.label()].")
	update_icon()

/obj/structure/roguemachine/escrow/proc/collect_order(datum/escrow_order/O, mob/user)
	if(!O || O.status != "complete" || user.ckey != O.commissioner_ckey)
		return
	var/turf/T = get_turf(src)
	for(var/obj/item/I in O.delivered_items)
		I.forceMove(T)
	O.delivered_items.Cut()
	orders -= O
	update_icon()

/obj/structure/roguemachine/escrow/proc/notify_commissioner(datum/escrow_order/O, message)
	if(!O || !O.commissioner_ref)
		return
	var/mob/M = O.commissioner_ref.resolve()
	if(!M)
		return
	to_chat(M, span_notice("<b>[message]</b>"))

/obj/structure/roguemachine/escrow/obj_break(damage_flag)
	..()
	var/turf/T = get_turf(src)
	for(var/datum/escrow_order/O in orders)
		for(var/obj/item/I in O.delivered_items)
			I.forceMove(T)
	orders.Cut()
	manifests.Cut()
	var/spill = budget
	for(var/ck in manifest_deposits)
		spill += manifest_deposits[ck]
	manifest_deposits.Cut()
	budget = 0
	budget2change(spill, custom_turf = T)
	update_icon()

/obj/structure/roguemachine/escrow/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	icon_state = locked ? "streetvendor1" : "streetvendor0"
	if(length(orders))
		set_light(1, 1, 1, l_color = "#f1c94b")
	else
		set_light(0)
