/obj/structure/roguemachine/scrapper
	name = "scrapper"
	desc = "A brass-trimmed contraption with a hopper above and an iron strongbox beneath. The scrapper pays in coin and recycle the materials. The owner sets the rate. Can take a sack of junk and work through it, or be fed items one by one."
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
	var/seed_budget = 0
	var/list/material_prices = list()
	var/list/material_caps = list()
	var/list/material_held = list()
	var/list/material_advertise = list()
	var/list/material_enabled = list()
	var/list/bark_candidates = list()
	var/bark_dirty = TRUE
	var/next_bark = 0
	var/recycle_sound = 'sound/misc/smelter_fin.ogg'

/obj/structure/roguemachine/scrapper/Initialize()
	. = ..()
	populate_defaults()
	if(seed_budget > 0)
		budget = seed_budget
	next_bark = world.time + SCRAPPER_BARK_INTERVAL
	START_PROCESSING(SSobj, src)

/obj/structure/roguemachine/scrapper/Destroy()
	STOP_PROCESSING(SSobj, src)
	material_prices?.Cut()
	material_caps?.Cut()
	material_held?.Cut()
	material_advertise?.Cut()
	return ..()

/obj/structure/roguemachine/scrapper/proc/populate_defaults()
	return

/obj/structure/roguemachine/scrapper/proc/material_name(path)
	if(!path)
		return ""
	var/atom/A = path
	return capitalize(initial(A.name))

/obj/structure/roguemachine/scrapper/proc/identify_material(obj/item/I)
	if(!I)
		return null
	if((I.type in material_prices) && material_enabled[I.type])
		return I.type
	if(I.smeltresult && (I.smeltresult in material_prices) && material_enabled[I.smeltresult])
		return I.smeltresult
	if(I.sewrepair && I.salvage_result && (I.salvage_result in material_prices) && material_enabled[I.salvage_result])
		return I.salvage_result
	return null

/obj/structure/roguemachine/scrapper/proc/is_keyholder(mob/user)
	if(!ishuman(user))
		return FALSE
	for(var/obj/item/roguekey/K in user.GetAllContents())
		if(K.lockid in keycontrol)
			return TRUE
	return FALSE

/obj/structure/roguemachine/scrapper/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("The proprietor lists per-material prices, capacities, and which wares to call out. Coins fed into the machine fund the coffer; when it runs dry, the scrapper turns away offers.")
	. += span_info("Strike with an item to offer it. The scrapper weighs by what it would smelt down to.")

/obj/structure/roguemachine/scrapper/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid in keycontrol)
			to_chat(user, span_notice("I rattle the lock to confirm my standing with the machine."))
			SStgui.update_uis(src)
			return
		to_chat(user, span_warning("Wrong key."))
		return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/KR = P
		for(var/obj/item/roguekey/KE in KR)
			if(KE.lockid in keycontrol)
				to_chat(user, span_notice("I rattle the lock to confirm my standing with the machine."))
				SStgui.update_uis(src)
				return

	if(istype(P, /obj/item/roguecoin/aalloy) || istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		if(!is_keyholder(user))
			to_chat(user, span_warning("Only the proprietor may fund the machine."))
			return
		budget += P.get_real_price()
		bark_dirty = TRUE
		qdel(P)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		SStgui.update_uis(src)
		return

	if(!ishuman(user))
		return
	if(istype(P, /obj/item/storage) && !istype(P, /obj/item/storage/keyring))
		var/processed = 0
		var/hit_broke = FALSE
		var/hit_full = FALSE
		for(var/obj/item/SI in P.contents.Copy())
			switch(try_recycle(SI, user, TRUE))
				if(SCRAPPER_RECYCLE_OK)
					processed++
				if(SCRAPPER_RECYCLE_BROKE)
					hit_broke = TRUE
				if(SCRAPPER_RECYCLE_FULL)
					hit_full = TRUE
		if(processed)
			playsound(loc, recycle_sound, 100, FALSE, -1)
			playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
			var/tail = hit_broke ? " The scrapper ran dry before I finished." : ""
			to_chat(user, span_notice("[src] works through [P] and takes [processed] item\s.[tail]"))
			SStgui.update_uis(src)
		else if(hit_broke)
			playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			to_chat(user, span_warning("[src]'s coffer hasn't the coin to take anything from [P]."))
		else if(hit_full)
			playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			to_chat(user, span_warning("[src]'s hoppers are too full to take anything from [P]."))
		else
			to_chat(user, span_warning("[src] finds nothing worth taking in [P]."))
		return
	try_recycle(P, user)

/obj/structure/roguemachine/scrapper/proc/try_recycle(obj/item/I, mob/user, silent = FALSE)
	if(I.is_important)
		if(!silent)
			to_chat(user, span_warning("[src] sees no worth in [I]."))
		return SCRAPPER_RECYCLE_WORTHLESS
	var/path = identify_material(I)
	if(!path)
		if(!silent)
			to_chat(user, span_warning("[src] sees no worth in [I]."))
		return SCRAPPER_RECYCLE_WORTHLESS
	var/units = 1
	if(I.salvage_result == path)
		units = I.salvage_amount
		if(units <= 0)
			if(!silent)
				to_chat(user, span_warning("[src] sees no worth in [I]."))
			return SCRAPPER_RECYCLE_WORTHLESS
	var/unit_price = material_prices[path] || 0
	if(unit_price <= 0)
		if(!silent)
			to_chat(user, span_warning("[src] is not taking [material_name(path)] today."))
		return SCRAPPER_RECYCLE_WORTHLESS
	var/total_price = unit_price * units
	var/cap = material_caps[path] || 0
	var/held = material_held[path] || 0
	if(cap > 0 && held + units > cap)
		if(!silent)
			to_chat(user, span_warning("[src]'s [material_name(path)] hopper has no room for that."))
			playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return SCRAPPER_RECYCLE_FULL
	if(budget < total_price)
		if(!silent)
			to_chat(user, span_warning("[src]'s coffer hasn't the coin for that."))
			playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return SCRAPPER_RECYCLE_BROKE
	material_held[path] = held + units
	budget -= total_price
	bark_dirty = TRUE
	qdel(I)
	for(var/i in 1 to units)
		new path(src)
	budget2change(total_price, user)
	if(!silent)
		playsound(loc, recycle_sound, 100, FALSE, -1)
		playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
		var/cap_text = cap > 0 ? "[max(0, cap - material_held[path])] / [cap] left" : "no cap"
		var/units_text = units > 1 ? " ([units] units)" : ""
		to_chat(user, span_notice("[material_name(path)] weighed and paid: [total_price]m[units_text]. [cap_text]."))
		SStgui.update_uis(src)
	return SCRAPPER_RECYCLE_OK

/obj/structure/roguemachine/scrapper/proc/rebuild_bark_candidates()
	bark_candidates = list()
	for(var/path in material_prices)
		if(!material_enabled[path])
			continue
		if(!material_advertise[path])
			continue
		var/price = material_prices[path] || 0
		if(price <= 0)
			continue
		if(budget < price)
			continue
		var/cap = material_caps[path] || 0
		var/held = material_held[path] || 0
		if(cap > 0 && held >= cap)
			continue
		bark_candidates += path
	bark_dirty = FALSE

/obj/structure/roguemachine/scrapper/process()
	if(world.time < next_bark)
		return
	next_bark = world.time + SCRAPPER_BARK_INTERVAL
	if(obj_broken)
		return
	if(bark_dirty)
		rebuild_bark_candidates()
	if(!length(bark_candidates))
		return
	var/pick = pick(bark_candidates)
	var/price = material_prices[pick]
	var/cap = material_caps[pick] || 0
	var/held = material_held[pick] || 0
	var/left_text = cap > 0 ? "[cap - held] left" : "no cap"
	say("Rags and scrap! [material_name(pick)] paid at [price]m a piece! [left_text]!")

/obj/structure/roguemachine/scrapper/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/scrapper/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	ui_interact(user)

/obj/structure/roguemachine/scrapper/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		ui = new(user, src, "Scrapper", name)
		ui.open()

/obj/structure/roguemachine/scrapper/proc/items_count_for(path)
	var/n = 0
	for(var/obj/item/I in contents)
		if(I.type == path || I.smeltresult == path || I.salvage_result == path)
			n++
	return n

/obj/structure/roguemachine/scrapper/ui_data(mob/user)
	var/list/data = list()
	data["budget"] = budget
	data["is_keyholder"] = is_keyholder(user) ? TRUE : FALSE
	var/total_items = 0
	var/list/rows = list()
	for(var/path in material_prices)
		var/cap = material_caps[path] || 0
		var/held = material_held[path] || 0
		var/items = items_count_for(path)
		total_items += items
		rows += list(list(
			"path" = "[path]",
			"name" = material_name(path),
			"price" = material_prices[path] || 0,
			"cap" = cap,
			"held" = held,
			"items" = items,
			"left" = cap > 0 ? max(0, cap - held) : -1,
			"advertise" = material_advertise[path] ? TRUE : FALSE,
			"enabled" = material_enabled[path] ? TRUE : FALSE,
		))
	data["materials"] = rows
	data["total_items"] = total_items
	return data

/obj/structure/roguemachine/scrapper/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!is_keyholder(usr))
		return
	switch(action)
		if("set_price")
			var/path = text2path(params["path"])
			var/n = text2num(params["value"])
			if(path && (path in material_prices) && isnum(n))
				material_prices[path] = max(0, round(n))
				bark_dirty = TRUE
			return TRUE
		if("set_cap")
			var/path = text2path(params["path"])
			var/n = text2num(params["value"])
			if(path && (path in material_prices) && isnum(n))
				material_caps[path] = max(0, round(n))
				bark_dirty = TRUE
			return TRUE
		if("toggle_advertise")
			var/path = text2path(params["path"])
			if(path && (path in material_prices))
				material_advertise[path] = !material_advertise[path]
				bark_dirty = TRUE
			return TRUE
		if("toggle_enable")
			var/path = text2path(params["path"])
			if(path && (path in material_prices))
				material_enabled[path] = !material_enabled[path]
				bark_dirty = TRUE
			return TRUE
		if("dump_held")
			var/path = text2path(params["path"])
			if(path && (path in material_held))
				var/turf/T = get_turf(src)
				for(var/obj/item/I in contents)
					if(I.type == path || I.smeltresult == path || I.salvage_result == path)
						I.forceMove(T)
				material_held[path] = 0
				bark_dirty = TRUE
			return TRUE
		if("dump_all")
			var/turf/T = get_turf(src)
			for(var/obj/item/I in contents)
				I.forceMove(T)
			for(var/path in material_held)
				material_held[path] = 0
			bark_dirty = TRUE
			return TRUE
		if("withdraw")
			if(budget <= 0)
				return TRUE
			var/amount = budget
			budget = 0
			bark_dirty = TRUE
			budget2change(amount, usr)
			playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
			to_chat(usr, span_notice("I withdraw [amount]m from the coffer."))
			return TRUE

/obj/structure/roguemachine/scrapper/obj_break(damage_flag)
	..()
	var/turf/T = get_turf(src)
	if(budget > 0)
		budget2change(budget, custom_turf = T)
		budget = 0
		bark_dirty = TRUE
	for(var/obj/item/I in contents)
		I.forceMove(T)
	for(var/path in material_held)
		material_held[path] = 0
	update_icon()

/obj/structure/roguemachine/scrapper/smith
	name = "smith's scrapper"
	desc = "A brass-trimmed contraption with a hopper above and an iron strongbox beneath. Takes whatever a smith can smelt back into ingots."
	seed_budget = 50

/obj/structure/roguemachine/scrapper/smith/populate_defaults()
	material_prices = list(
		/obj/item/ingot/iron = 8,
		/obj/item/ingot/copper = 4,
		/obj/item/ingot/bronze = 10,
		/obj/item/ingot/steel = 14,
		/obj/item/ingot/silver = 60,
		/obj/item/ingot/gold = 50,
		/obj/item/ingot/blacksteel = 80,
	)
	var/list/defaults_on = list(/obj/item/ingot/iron, /obj/item/ingot/steel)
	material_caps[/obj/item/ingot/iron] = 10
	material_caps[/obj/item/ingot/copper] = 5
	material_caps[/obj/item/ingot/bronze] = 5
	material_caps[/obj/item/ingot/steel] = 10
	material_caps[/obj/item/ingot/silver] = 4
	material_caps[/obj/item/ingot/gold] = 4
	material_caps[/obj/item/ingot/blacksteel] = 3
	for(var/path in material_prices)
		material_held[path] = 0
		material_enabled[path] = (path in defaults_on)
		material_advertise[path] = (path in defaults_on)

/obj/structure/roguemachine/scrapper/tailor
	name = "rag-picker"
	desc = "A brass-trimmed contraption with a hopper above and an iron strongbox beneath. Takes whatever a tailor can rework into fabrics."
	seed_budget = 50
	recycle_sound = 'sound/foley/cloth_rip.ogg'

/obj/structure/roguemachine/scrapper/tailor/populate_defaults()
	material_prices = list(
		/obj/item/natural/fibers = 1,
		/obj/item/natural/cloth = 2,
		/obj/item/natural/silk = 2,
		/obj/item/natural/hide = 5,
		/obj/item/natural/hide/cured = 2,
		/obj/item/natural/fur = 8,
	)
	var/list/defaults_on = list(/obj/item/natural/fibers, /obj/item/natural/cloth, /obj/item/natural/silk, /obj/item/natural/hide, /obj/item/natural/hide/cured, /obj/item/natural/fur)
	material_caps[/obj/item/natural/fibers] = 10
	material_caps[/obj/item/natural/cloth] = 10
	material_caps[/obj/item/natural/silk] = 10
	material_caps[/obj/item/natural/hide] = 8
	material_caps[/obj/item/natural/hide/cured] = 12
	material_caps[/obj/item/natural/fur] = 3
	for(var/path in material_prices)
		material_held[path] = 0
		material_enabled[path] = (path in defaults_on)
		material_advertise[path] = (path in defaults_on)

#undef SCRAPPER_BARK_INTERVAL
#undef SCRAPPER_RECYCLE_OK
#undef SCRAPPER_RECYCLE_WORTHLESS
#undef SCRAPPER_RECYCLE_FULL
#undef SCRAPPER_RECYCLE_BROKE
