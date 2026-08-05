/datum/escrow_order
	var/commissioner_name
	var/datum/weakref/commissioner_ref
	var/smith_name
	var/list/recipe_quantities = list()
	var/deposited = 0
	var/list/delivered_items = list()
	var/list/delivered_counts = list()
	var/status = "open"
	var/day_posted = 0
	var/day_claimed = 0
	var/commissioner_note = ""
	var/list/cached_required_counts
	var/list/cached_lines
	var/list/cached_materials

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
	if(cached_required_counts)
		return cached_required_counts
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
	cached_required_counts = out
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
	var/budget = 0
	var/list/material_prices
	var/list/derived_material_prices
	var/percent_margin = 70
	var/flat_margin = 5
	var/item_cap_per_order = 3
	var/list/orders = list()
	var/list/manifests = list()
	var/list/manifest_deposits = list()
	var/list/catalog
	var/list/cached_catalog_data
	var/list/cached_categories
	var/list/cached_ingots
	var/catalog_view_dirty = TRUE
	var/list/priority_material_types = list(
		/obj/item/ingot,
		/obj/item/natural/hide,
		/obj/item/grown/log,
		/obj/item/natural/wood,
		/obj/item/roguegear,
	)
	var/list/excluded_materials = list(
		/obj/item/ingot/aalloy,
		/obj/item/ingot/drow,
	)
	var/list/excluded_material_parents = list()
	var/list/default_disabled_materials = list(
		/obj/item/ingot/blacksteel,
		/obj/item/ingot/silver,
		/obj/item/ingot/silverblessed,
		/obj/item/ingot/silverblessed/bullion,
		/obj/item/ingot/steelholy,
		/obj/item/ingot/lithmyc,
		/obj/item/ingot/purifiedaalloy,
	)
	var/list/disabled_materials = list()
	var/list/allowed_categories = list(
		ITEM_CAT_ARMOR_HELMETS,
		ITEM_CAT_ARMOR_CHESTPIECES,
		ITEM_CAT_ARMOR_LEGS,
		ITEM_CAT_ARMOR_NECK,
		ITEM_CAT_ARMOR_BOOTS,
		ITEM_CAT_ARMOR_GLOVES,
		ITEM_CAT_ARMOR_MASKS,
		ITEM_CAT_ARMOR_BRACERS,
		ITEM_CAT_ARMOR_BELTS,
		ITEM_CAT_ARMOR_BARDING,
		ITEM_CAT_ARMOR_LIGHT,
		ITEM_CAT_WEAPONS_SWORDS,
		ITEM_CAT_WEAPONS_DAGGERS,
		ITEM_CAT_WEAPONS_AXES,
		ITEM_CAT_WEAPONS_POLEARMS,
		ITEM_CAT_WEAPONS_MACES,
		ITEM_CAT_WEAPONS_FLAILS,
		ITEM_CAT_WEAPONS_SHIELDS,
		ITEM_CAT_WEAPONS_AMMO,
		ITEM_CAT_TOOLS_COOKWARE,
		ITEM_CAT_TOOLS_FIELD,
		ITEM_CAT_TOOLS_WORKSHOP,
		ITEM_CAT_TOOLS_SUNDRIES,
		ITEM_CAT_TOOLS_ROGUE,
		ITEM_CAT_VALUABLES_RINGS,
		ITEM_CAT_VALUABLES_HOLY,
		ITEM_CAT_COMPONENTS,
		ITEM_CAT_SMITHING_MISC,
		ITEM_CAT_ENG_MACHINERY,
		ITEM_CAT_ENG_CONSTRUCTION,
		ITEM_CAT_ENG_COMBAT,
		ITEM_CAT_ENG_TRIGGERS,
		ITEM_CAT_ENG_MISC,
	)
	var/list/group_order = list("Armor", "Weapons", "Tools", "Valuables", "Decoration", "Engineering", "Other")

/obj/structure/roguemachine/escrow/Initialize()
	. = ..()
	init_material_prices()
	disabled_materials = default_disabled_materials?.Copy() || list()
	rebuild_catalog()
	update_icon()

/obj/structure/roguemachine/escrow/proc/toggle_material_enabled(path)
	if(!path || path_is_excluded(path))
		return FALSE
	if(path in disabled_materials)
		disabled_materials -= path
	else
		disabled_materials += path
	rebuild_catalog()
	return TRUE

/obj/structure/roguemachine/escrow/proc/init_material_prices()
	material_prices = list()
	for(var/path in GLOB.material_baseline_prices)
		if(path_is_excluded_parent(path))
			continue
		var/baseline = GLOB.material_baseline_prices[path]
		if(baseline <= 0)
			continue
		material_prices[path] = max(1, round(baseline * PRICING_ENGINE_COMMISSIONER_MARKUP))
	derived_material_prices = list()
	for(var/path in GLOB.derived_sellprices)
		if(path in material_prices)
			continue
		if(path_is_excluded_parent(path))
			continue
		var/derived = GLOB.derived_sellprices[path]
		if(derived <= 0)
			continue
		derived_material_prices[path] = max(1, round(derived * PRICING_ENGINE_COMMISSIONER_MARKUP))

/obj/structure/roguemachine/escrow/proc/path_is_excluded_parent(path)
	if(!length(excluded_material_parents))
		return FALSE
	for(var/parent in excluded_material_parents)
		if(ispath(path, parent))
			return TRUE
	return FALSE

/obj/structure/roguemachine/escrow/proc/get_material_price(path)
	if(material_prices && (path in material_prices))
		return material_prices[path]
	if(derived_material_prices && (path in derived_material_prices))
		return derived_material_prices[path]
	return 0

/obj/structure/roguemachine/escrow/proc/has_material_price(path)
	if(material_prices && (path in material_prices))
		return TRUE
	if(derived_material_prices && (path in derived_material_prices))
		return TRUE
	return FALSE

/obj/structure/roguemachine/escrow/Destroy()
	orders?.Cut()
	manifests?.Cut()
	manifest_deposits?.Cut()
	return ..()

/obj/structure/roguemachine/escrow/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Any commissioner may build a manifest of smithing or engineering recipes and deposit coin into the machine. Submitting the manifest posts an order with the coin held in escrow.")
	. += span_info("A smith can claim an open order, deliver the finished items back into the machine, and collect the escrowed pay once every item has been delivered. An order that has been claimed cannot be cancelled by the commissioner.")
	. += span_info("A guild member may adjust material prices and margins through the machine's panel.")

/obj/structure/roguemachine/escrow/proc/rebuild_catalog()
	catalog = list()
	var/anvil_allowed = !length(allowed_categories) || (ITEM_CAT_SMITHING_MISC in allowed_categories)
	for(var/datum/anvil_recipe/AR in GLOB.anvil_recipes)
		if(AR.hides_from_books || !AR.name || !AR.created_item || !AR.req_bar)
			continue
		if(!(AR.req_bar in material_prices))
			continue
		if(!anvil_allowed && !(AR.display_category in allowed_categories))
			continue
		if(recipe_uses_excluded_material(AR))
			continue
		if(recipe_uses_disabled_material(AR))
			continue
		catalog += AR
	for(var/datum/crafting_recipe/CR in GLOB.crafting_recipes)
		if(CR.hides_from_books || !CR.name || !CR.result || !CR.display_category)
			continue
		if(length(allowed_categories) && !(CR.display_category in allowed_categories))
			continue
		if(!recipe_has_only_raw_materials(CR))
			continue
		if(recipe_uses_excluded_material(CR))
			continue
		if(recipe_uses_disabled_material(CR))
			continue
		catalog += CR
	prune_unused_material_prices()
	dirty_catalog_view()

/obj/structure/roguemachine/escrow/proc/recipe_uses_disabled_material(datum/recipe)
	if(!length(disabled_materials))
		return FALSE
	if(istype(recipe, /datum/anvil_recipe))
		var/datum/anvil_recipe/AR = recipe
		if(AR.req_bar in disabled_materials)
			return TRUE
		if(islist(AR.additional_items))
			for(var/path in AR.additional_items)
				if(path in disabled_materials)
					return TRUE
	else if(istype(recipe, /datum/crafting_recipe))
		var/datum/crafting_recipe/CR = recipe
		if(islist(CR.reqs))
			for(var/path in CR.reqs)
				if(path in disabled_materials)
					return TRUE
	return FALSE

/obj/structure/roguemachine/escrow/proc/recipe_uses_excluded_material(datum/recipe)
	if(!length(excluded_materials) && !length(excluded_material_parents))
		return FALSE
	if(istype(recipe, /datum/anvil_recipe))
		var/datum/anvil_recipe/AR = recipe
		if(path_is_excluded(AR.req_bar))
			return TRUE
		if(islist(AR.additional_items))
			for(var/path in AR.additional_items)
				if(path_is_excluded(path))
					return TRUE
	else if(istype(recipe, /datum/crafting_recipe))
		var/datum/crafting_recipe/CR = recipe
		if(islist(CR.reqs))
			for(var/path in CR.reqs)
				if(path_is_excluded(path))
					return TRUE
	return FALSE

/obj/structure/roguemachine/escrow/proc/path_is_excluded(path)
	if(!path)
		return FALSE
	if(path in excluded_materials)
		return TRUE
	return path_is_excluded_parent(path)

/obj/structure/roguemachine/escrow/proc/recipe_has_only_raw_materials(datum/crafting_recipe/CR)
	if(!islist(CR.reqs) || !length(CR.reqs))
		return FALSE
	for(var/path in CR.reqs)
		if(!has_material_price(path))
			return FALSE
	return TRUE

/obj/structure/roguemachine/escrow/proc/prune_unused_material_prices()
	var/list/used = list()
	for(var/datum/R in catalog)
		if(istype(R, /datum/anvil_recipe))
			var/datum/anvil_recipe/AR = R
			if(AR.req_bar)
				used[AR.req_bar] = TRUE
			if(islist(AR.additional_items))
				for(var/path in AR.additional_items)
					used[path] = TRUE
		else if(istype(R, /datum/crafting_recipe))
			var/datum/crafting_recipe/CR = R
			if(islist(CR.reqs))
				for(var/path in CR.reqs)
					used[path] = TRUE
	for(var/path in material_prices.Copy())
		if(path in disabled_materials)
			continue
		if(!(path in used))
			material_prices -= path

/obj/structure/roguemachine/escrow/proc/dirty_catalog_view()
	catalog_view_dirty = TRUE
	update_static_data_for_all_viewers()

/obj/structure/roguemachine/escrow/proc/rebuild_catalog_view()
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
			"materials" = recipe_materials(R),
		))
	cached_catalog_data = catalog_data
	cached_categories = cats
	cached_ingots = ingots
	catalog_view_dirty = FALSE

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
	if(istype(recipe, /datum/crafting_recipe))
		var/datum/crafting_recipe/CR = recipe
		return CR.display_category || ITEM_CAT_MISCELLANEOUS
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
		total += get_material_price(AR.req_bar)
		if(islist(AR.additional_items))
			for(var/path in AR.additional_items)
				total += get_material_price(path)
	else if(istype(recipe, /datum/crafting_recipe))
		var/datum/crafting_recipe/CR = recipe
		if(islist(CR.reqs))
			for(var/path in CR.reqs)
				total += get_material_price(path) * CR.reqs[path]
	return total

/obj/structure/roguemachine/escrow/proc/recipe_materials(datum/recipe)
	var/list/tally = list()
	if(istype(recipe, /datum/anvil_recipe))
		var/datum/anvil_recipe/AR = recipe
		if(AR.req_bar)
			tally[AR.req_bar] = (tally[AR.req_bar] || 0) + 1
		if(islist(AR.additional_items))
			for(var/path in AR.additional_items)
				tally[path] = (tally[path] || 0) + 1
	else if(istype(recipe, /datum/crafting_recipe))
		var/datum/crafting_recipe/CR = recipe
		if(islist(CR.reqs))
			for(var/path in CR.reqs)
				tally[path] = (tally[path] || 0) + CR.reqs[path]
	var/list/sorted_paths = list()
	for(var/path in tally)
		var/qty = tally[path]
		var/inserted = FALSE
		for(var/i in 1 to length(sorted_paths))
			if(tally[sorted_paths[i]] < qty)
				sorted_paths.Insert(i, path)
				inserted = TRUE
				break
		if(!inserted)
			sorted_paths += path
	var/list/out = list()
	for(var/path in sorted_paths)
		var/atom/A = path
		out += list(list(
			"name" = initial(A.name),
			"qty" = tally[path],
		))
	return out

/obj/structure/roguemachine/escrow/proc/recipe_price(datum/recipe)
	var/base = recipe_material_cost(recipe)
	return round(base * (1 + percent_margin / 100)) + flat_margin

/obj/structure/roguemachine/escrow/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguecoin/aalloy) || istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		var/key = escrow_key(user)
		if(!key)
			return
		manifest_deposits[key] = (manifest_deposits[key] || 0) + P.get_real_price()
		qdel(P)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		update_user_ui(user)
		return

	if(ishuman(user))
		try_smith_deliver(P, user)

/obj/structure/roguemachine/escrow/proc/escrow_key(mob/user)
	if(!user || !user.real_name)
		return null
	return user.real_name

/obj/structure/roguemachine/escrow/proc/try_smith_deliver(obj/item/I, mob/user)
	var/key = escrow_key(user)
	if(!key)
		return
	for(var/datum/escrow_order/O in orders)
		if(O.status != "claimed" || O.smith_name != key)
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
		ui.set_autoupdate(FALSE)

/// Refresh only the acting user's UI (dynamic data) for changes that touch nobody else.
/obj/structure/roguemachine/escrow/proc/update_user_ui(mob/user)
	var/datum/tgui/ui = SStgui.get_open_ui(user, src)
	ui?.send_update()

/obj/structure/roguemachine/escrow/proc/is_guild_member(mob/user)
	if(!ishuman(user))
		return FALSE
	for(var/obj/item/roguekey/K in user.GetAllContents())
		if(K.lockid in keycontrol)
			return TRUE
	return FALSE

/obj/structure/roguemachine/escrow/proc/reject_order(datum/escrow_order/O, mob/user, reason = "")
	if(!O || O.status == "complete")
		return
	var/key = escrow_key(user)
	if(O.status == "claimed" && key != O.smith_name && !is_guild_member(user))
		return
	if(O.status == "open" && !is_guild_member(user))
		return
	orders -= O
	var/payout = O.deposited
	O.deposited = 0
	budget -= payout
	var/turf/T = get_turf(src)
	for(var/obj/item/I in O.delivered_items)
		I.forceMove(T)
	O.delivered_items.Cut()
	if(payout > 0 && O.commissioner_name)
		manifest_deposits[O.commissioner_name] = (manifest_deposits[O.commissioner_name] || 0) + payout
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
			if(O.deposited > 0 && O.commissioner_name)
				manifest_deposits[O.commissioner_name] = (manifest_deposits[O.commissioner_name] || 0) + O.deposited
			notify_commissioner(O, "Your unclaimed commission at [src] has expired. [O.deposited]m has been returned to your deposit.")
			O.deposited = 0
		else if(O.status == "claimed" && O.day_claimed && GLOB.dayspassed - O.day_claimed >= ESCROW_CLAIM_EXPIRY_DAYS)
			for(var/obj/item/I in O.delivered_items)
				I.forceMove(T)
			O.delivered_items.Cut()
			O.delivered_counts.Cut()
			O.status = "open"
			O.smith_name = null
			O.day_claimed = 0
			notify_commissioner(O, "The claim on your commission at [src] has expired; the order is open again for new smiths.")

/obj/structure/roguemachine/escrow/ui_static_data(mob/user)
	var/list/data = list()
	if(catalog_view_dirty || isnull(cached_catalog_data))
		rebuild_catalog_view()
	data["catalog"] = cached_catalog_data
	data["categories"] = cached_categories
	data["ingots"] = cached_ingots
	data["group_order"] = group_order
	data["percent_margin"] = percent_margin
	data["flat_margin"] = flat_margin
	data["item_cap_per_order"] = item_cap_per_order

	var/list/materials_data = list()
	for(var/path in material_prices)
		var/atom/A = path
		materials_data += list(list(
			"path" = "[path]",
			"name" = initial(A.name),
			"price" = material_prices[path],
			"priority" = is_priority_material(path) ? TRUE : FALSE,
			"enabled" = (path in disabled_materials) ? FALSE : TRUE,
		))
	data["materials"] = materials_data
	return data

/// Build the parts of an order's UI payload that never change after posting.
/obj/structure/roguemachine/escrow/proc/build_order_cache(datum/escrow_order/O)
	var/list/order_lines = list()
	var/list/mat_tally = list()
	for(var/datum/R in O.recipe_quantities)
		var/recipe_qty = O.recipe_quantities[R]
		order_lines += list(list(
			"name" = recipe_name(R),
			"qty" = recipe_qty,
		))
		for(var/list/m in recipe_materials(R))
			mat_tally[m["name"]] = (mat_tally[m["name"]] || 0) + (m["qty"] * recipe_qty)
	var/list/order_materials = list()
	for(var/mname in mat_tally)
		order_materials += list(list(
			"name" = mname,
			"qty" = mat_tally[mname],
		))
	O.cached_lines = order_lines
	O.cached_materials = order_materials

/obj/structure/roguemachine/escrow/ui_data(mob/user)
	prune_expired_orders()
	var/list/data = list()
	data["can_read"] = (ishuman(user) && user.can_read(src, TRUE)) ? TRUE : FALSE
	data["is_guildmaster"] = is_guild_member(user) ? TRUE : FALSE
	var/user_key = escrow_key(user)
	data["budget"] = budget
	data["my_deposit"] = (user_key && manifest_deposits[user_key]) || 0
	data["my_manifest_items"] = user_key ? manifest_item_count(user_key) : 0
	data["has_active_order"] = (user_key && has_active_order(user_key)) ? TRUE : FALSE

	var/list/manifest_data = list()
	var/list/cart = user_key ? manifests[user_key] : null
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
		if(isnull(O.cached_lines))
			build_order_cache(O)
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
			"lines" = O.cached_lines,
			"materials" = O.cached_materials,
			"fulfillment" = fulfillment,
			"done_count" = done_count,
			"needed_count" = needed_count,
			"is_commissioner" = (user_key && user_key == O.commissioner_name) ? TRUE : FALSE,
			"is_smith" = (user_key && user_key == O.smith_name) ? TRUE : FALSE,
			"is_fulfilled" = (needed_count > 0 && done_count >= needed_count) ? TRUE : FALSE,
			"days_left" = days_left,
			"expiry_label" = expiry_label,
			"note" = O.commissioner_note,
		))
	data["orders"] = orders_data
	return data

/obj/structure/roguemachine/escrow/proc/is_priority_material(path)
	for(var/parent in priority_material_types)
		if(ispath(path, parent))
			return TRUE
	return FALSE

/obj/structure/roguemachine/escrow/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	if(is_guild_member(usr))
		switch(action)
			if("set_percent_margin")
				var/n = text2num(params["value"])
				if(isnum(n))
					percent_margin = clamp(round(n), 0, 500)
					dirty_catalog_view()
				return FALSE
			if("set_flat_margin")
				var/n = text2num(params["value"])
				if(isnum(n))
					flat_margin = max(0, round(n))
					dirty_catalog_view()
				return FALSE
			if("set_material_price")
				var/path = text2path(params["path"])
				var/n = text2num(params["value"])
				if(path && (path in material_prices) && isnum(n))
					material_prices[path] = max(0, round(n))
					dirty_catalog_view()
				return FALSE
			if("toggle_material")
				var/path = text2path(params["path"])
				if(path)
					toggle_material_enabled(path)
				return FALSE
			if("set_item_cap")
				var/n = text2num(params["value"])
				if(isnum(n))
					item_cap_per_order = clamp(round(n), 1, 10)
					update_static_data_for_all_viewers()
				return FALSE

	switch(action)
		if("manifest_inc")
			var/datum/R = locate(params["ref"]) in catalog
			if(R)
				manifest_change(usr, R, text2num(params["delta"]) || 1)
			update_user_ui(usr)
			return FALSE
		if("manifest_dec")
			var/datum/R = locate(params["ref"]) in catalog
			if(R)
				manifest_change(usr, R, -(text2num(params["delta"]) || 1))
			update_user_ui(usr)
			return FALSE
		if("manifest_remove")
			var/datum/R = locate(params["ref"]) in catalog
			var/usr_key = escrow_key(usr)
			var/list/cart = usr_key ? manifests[usr_key] : null
			if(R && cart)
				cart -= R
			update_user_ui(usr)
			return FALSE
		if("submit_manifest")
			submit_manifest(usr, params["note"])
			return TRUE
		if("refund_deposit")
			refund_deposit(usr)
			update_user_ui(usr)
			return FALSE
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
			if(!is_guild_member(usr))
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
	var/key = escrow_key(user)
	if(!key || !R)
		return
	if(!manifests[key])
		manifests[key] = list()
	var/list/cart = manifests[key]
	var/newval = (cart[R] || 0) + delta
	if(newval <= 0)
		cart -= R
	else
		cart[R] = min(newval, 50)

/obj/structure/roguemachine/escrow/proc/manifest_total(mob/user)
	var/total = 0
	var/key = escrow_key(user)
	var/list/cart = key ? manifests[key] : null
	if(!cart)
		return 0
	for(var/k in cart)
		total += recipe_price(k) * cart[k]
	return total

/obj/structure/roguemachine/escrow/proc/has_active_order(key)
	if(!key)
		return FALSE
	for(var/datum/escrow_order/O in orders)
		if(O.commissioner_name == key && (O.status == "open" || O.status == "claimed"))
			return TRUE
	return FALSE

/obj/structure/roguemachine/escrow/proc/manifest_item_count(key)
	var/total = 0
	if(!key)
		return 0
	var/list/cart = manifests[key]
	if(!cart)
		return 0
	for(var/k in cart)
		total += cart[k]
	return total

/obj/structure/roguemachine/escrow/proc/submit_manifest(mob/user, note = "")
	var/key = escrow_key(user)
	if(!key)
		return
	var/list/cart = manifests[key]
	if(!length(cart))
		return
	if(has_active_order(key))
		to_chat(user, span_warning("You already have an active commission here - finish or cancel it before posting another."))
		return
	if(manifest_item_count(key) > item_cap_per_order)
		to_chat(user, span_warning("This commission asks for more than [item_cap_per_order] item\s - trim the manifest or raise the cap."))
		return
	var/total = manifest_total(user)
	var/deposit = manifest_deposits[key] || 0
	if(deposit < total)
		to_chat(user, span_warning("Not enough deposited. Need [total]mm, have [deposit]mm."))
		return
	var/datum/escrow_order/O = new()
	O.commissioner_name = key
	O.commissioner_ref = WEAKREF(user)
	O.day_posted = GLOB.dayspassed
	if(note)
		O.commissioner_note = copytext(sanitize(note), 1, 200)
	for(var/k in cart)
		O.recipe_quantities[k] = cart[k]
	O.deposited = total
	orders += O
	budget += total
	manifest_deposits[key] = deposit - total
	manifests -= key
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	to_chat(user, span_notice("Your commission has been posted."))
	update_icon()

/obj/structure/roguemachine/escrow/proc/refund_deposit(mob/user)
	var/key = escrow_key(user)
	if(!key)
		return
	var/deposit = manifest_deposits[key] || 0
	if(deposit <= 0)
		return
	manifest_deposits[key] = 0
	budget2change(deposit, user)
	playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/escrow/proc/cancel_order(datum/escrow_order/O, mob/user)
	if(!O || O.status != "open" || escrow_key(user) != O.commissioner_name)
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
	if(!is_guild_member(user))
		to_chat(user, span_warning("Only a member of the crafter's guild may claim a commission."))
		return
	O.status = "claimed"
	O.smith_name = escrow_key(user)
	O.day_claimed = GLOB.dayspassed
	to_chat(user, span_notice("You claim [O.commissioner_name]'s commission."))
	notify_commissioner(O, "[user.real_name] has claimed your commission at [src].")

/obj/structure/roguemachine/escrow/proc/release_order(datum/escrow_order/O, mob/user, forced = FALSE)
	if(!O || O.status != "claimed")
		return
	if(!forced && escrow_key(user) != O.smith_name)
		return
	var/turf/T = get_turf(src)
	for(var/obj/item/I in O.delivered_items)
		I.forceMove(T)
	O.delivered_items.Cut()
	O.delivered_counts.Cut()
	O.status = "open"
	O.smith_name = null
	O.day_claimed = 0
	if(forced)
		notify_commissioner(O, "The guildmaster has released the stalled claim on your commission at [src].")

/obj/structure/roguemachine/escrow/proc/settle_partial_order(datum/escrow_order/O, mob/user)
	if(!O || O.status != "claimed" || escrow_key(user) != O.smith_name)
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
	if(commissioner_refund > 0 && O.commissioner_name)
		manifest_deposits[O.commissioner_name] = (manifest_deposits[O.commissioner_name] || 0) + commissioner_refund
	playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
	to_chat(user, span_notice("Settled partial commission: you collect [smith_payout]m. [commissioner_refund]m has been returned to [O.commissioner_name]'s deposit."))
	notify_commissioner(O, "Your commission at [src] was partially fulfilled ([done_count]/[needed_count]). Items have been left at the docks; [commissioner_refund]m has been returned to your deposit.")
	update_icon()

/obj/structure/roguemachine/escrow/proc/complete_order(datum/escrow_order/O, mob/user)
	if(!O || O.status != "claimed" || escrow_key(user) != O.smith_name)
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
	if(!O || O.status != "complete" || escrow_key(user) != O.commissioner_name)
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
	icon_state = "streetvendor1"
	if(length(orders))
		set_light(1, 1, 1, l_color = "#f1c94b")
	else
		set_light(0)

/obj/structure/roguemachine/escrow/tailor
	name = "TAILORING COMMISSIONER"
	desc = "A brass-plated commission board for the weavers' and tailors' guild. Coin held in escrow until the work is delivered."
	keycontrol = list("tailor", "crafterguild", "craftermaster")
	allowed_categories = list(
		ITEM_CAT_GARMENT_COMMON,
		ITEM_CAT_GARMENT_FINE,
		ITEM_CAT_TAILOR_MISC,
		ITEM_CAT_CLOTH_MASK,
		ITEM_CAT_ARMOR_LIGHT,
		ITEM_CAT_ARMOR_HELMETS,
		ITEM_CAT_ARMOR_CHESTPIECES,
		ITEM_CAT_ARMOR_LEGS,
		ITEM_CAT_ARMOR_NECK,
		ITEM_CAT_ARMOR_BOOTS,
		ITEM_CAT_ARMOR_GLOVES,
		ITEM_CAT_ARMOR_BRACERS,
		ITEM_CAT_ARMOR_BELTS,
		ITEM_CAT_ARMOR_BARDING,
	)
	group_order = list("Garments", "Armor", "Other")
	priority_material_types = list(
		/obj/item/natural/hide,
		/obj/item/natural/silk,
		/obj/item/natural/cloth,
		/obj/item/natural/fibers,
		/obj/item/natural/fur,
	)
	default_disabled_materials = list()
	excluded_material_parents = list(
		/obj/item/ingot,
		/obj/item/roguegear,
	)

/obj/structure/roguemachine/escrow/tailor/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("This commissioner accepts tailoring and garment work only.")
