/datum/bill_of_fare_line
	var/uid
	var/name
	var/price = 0
	var/linked
	var/list/vessel_prices

/datum/bill_of_fare_line/New(uid, name, price, linked, list/vessel_prices)
	src.uid = uid
	src.name = name
	src.price = price
	src.linked = linked
	src.vessel_prices = vessel_prices

GLOBAL_LIST_EMPTY(bill_of_fare_vessels)

/proc/get_bill_of_fare_vessels()
	if(!length(GLOB.bill_of_fare_vessels))
		for(var/vessel_type in BILL_OF_FARE_VESSELS)
			var/datum/bill_of_fare_vessel/vessel = new vessel_type
			GLOB.bill_of_fare_vessels[vessel.key] = vessel
	return GLOB.bill_of_fare_vessels

/proc/is_bill_of_fare_vessel(key)
	var/list/vessels = get_bill_of_fare_vessels()
	return istext(key) && !isnull(vessels[key])

/proc/clean_bill_of_fare_price(value)
	if(!isnum(value))
		return 0
	return clamp(round(value, 1), 0, BILL_OF_FARE_MAX_PRICE)

/proc/clean_bill_of_fare_vessel_prices(list/raw)
	var/list/prices = list()
	if(!islist(raw))
		return prices
	for(var/key in get_bill_of_fare_vessels())
		var/value = raw[key]
		if(isnum(value))
			prices[key] = clean_bill_of_fare_price(value)
	return prices

/datum/bill_of_fare_vessel
	abstract_type = /datum/bill_of_fare_vessel
	var/key
	var/label
	var/container_type
	var/icon_file
	var/icon_state
	var/fill_file
	var/fill_state
	var/fill_under = FALSE
	var/top_state

/datum/bill_of_fare_vessel/proc/ui_entry()
	var/obj/item/reagent_containers/container = container_type
	return list(
		"key" = key,
		"label" = label,
		"capacity" = initial(container.volume),
		"icon" = "[icon_file]",
		"icon_state" = icon_state,
		"fill_icon" = "[fill_file]",
		"fill_state" = fill_state,
		"fill_under" = fill_under,
		"top_state" = top_state,
	)

/datum/bill_of_fare_vessel/cup
	key = "cup"
	label = "Cup"
	container_type = /obj/item/reagent_containers/glass/cup/wooden
	icon_file = 'modular/Neu_Food/icons/cookware/cup.dmi'
	icon_state = "wooden"
	fill_file = 'modular/Neu_Food/icons/cookware/cup.dmi'
	fill_state = "wooden_filling"

/datum/bill_of_fare_vessel/bottle
	key = "bottle"
	label = "Bottle"
	container_type = /obj/item/reagent_containers/glass/bottle
	icon_file = 'icons/roguetown/items/cooking.dmi'
	icon_state = "clear_bottle1"
	fill_file = 'icons/obj/reagentfillings.dmi'
	fill_state = "clear_bottle1100"
	fill_under = TRUE
	top_state = "clear_bottle1_cork"

/datum/bill_of_fare_column
	abstract_type = /datum/bill_of_fare_column
	var/key
	var/label
	var/cap
	var/catalog_key
	var/catalog_root
	var/noun_one
	var/noun_many
	var/export_tag
	var/uses_vessels = FALSE
	var/list/lines = list()

/datum/bill_of_fare_column/proc/get_catalog()
	return list()

/datum/bill_of_fare_column/proc/link_data(list/row, linked_type)
	return

/datum/bill_of_fare_column/proc/count_text()
	var/count = length(lines)
	return "[count] [count == 1 ? noun_one : noun_many]"

/datum/bill_of_fare_column/proc/find_line(uid)
	for(var/datum/bill_of_fare_line/line as anything in lines)
		if(line.uid == uid)
			return line

/datum/bill_of_fare_column/proc/rows()
	var/list/rows = list()
	for(var/datum/bill_of_fare_line/line as anything in lines)
		var/list/row = list(
			"uid" = line.uid,
			"name" = line.name,
			"linked" = !!line.linked,
		)
		if(uses_vessels)
			row["prices"] = line.vessel_prices || list()
		else
			row["price"] = line.price
		if(line.linked)
			link_data(row, line.linked)
		rows += list(row)
	return rows

/datum/bill_of_fare_column/food
	key = "food"
	label = "Food"
	cap = BILL_OF_FARE_MAX_FOOD
	catalog_key = "food"
	catalog_root = /obj/item/reagent_containers/food/snacks
	noun_one = "dish"
	noun_many = "dishes"
	export_tag = "F"

/datum/bill_of_fare_column/food/get_catalog()
	return get_bill_of_fare_foods()

/datum/bill_of_fare_column/food/link_data(list/row, linked_type)
	var/obj/item/food_type = linked_type
	row["icon"] = "[initial(food_type.icon)]"
	row["icon_state"] = initial(food_type.icon_state)
	row["desc"] = initial(food_type.desc)

/datum/bill_of_fare_column/drink
	key = "drink"
	label = "Drink"
	cap = BILL_OF_FARE_MAX_DRINK
	catalog_key = "drink"
	catalog_root = /datum/reagent
	noun_one = "drink"
	noun_many = "drinks"
	export_tag = "D"
	uses_vessels = TRUE

/datum/bill_of_fare_column/drink/get_catalog()
	return get_bill_of_fare_drinks()

/datum/bill_of_fare_column/drink/link_data(list/row, linked_type)
	var/datum/reagent/drink_type = linked_type
	row["color"] = initial(drink_type.color)

/datum/component/bill_of_fare
	can_transfer = TRUE
	var/title = ""
	var/notes = ""
	var/list/columns = list()
	var/next_uid = 1
	// This might feel a bit too handholdy, but I believe sincerely our playerbase and certainly other playerbase are base creatures who would troll people by writing over menus if they weren't mechnaically stopped from doing so
	var/datum/weakref/author_mind
	var/author_ckey
	var/author_name
	var/author_job
	var/signature_mode = BILL_OF_FARE_SIGN_NAME
	var/pen_name = ""
	var/open_to_all = FALSE
	COOLDOWN_DECLARE(import_cooldown)

/datum/component/bill_of_fare/Initialize()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	for(var/column_type in BILL_OF_FARE_COLUMNS)
		var/datum/bill_of_fare_column/column = new column_type
		columns[column.key] = column

/datum/component/bill_of_fare/PostTransfer()
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/bill_of_fare/RegisterWithParent()
	if(isitem(parent))
		RegisterSignal(parent, COMSIG_ITEM_ATTACK_SELF, PROC_REF(on_attack_self))
	else
		RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	RegisterSignal(parent, COMSIG_PARENT_ATTACKBY, PROC_REF(on_attackby))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_examine))
	update_parent_name()

/datum/component/bill_of_fare/proc/update_parent_name()
	var/atom/host = parent
	if(!length(title))
		host.name = initial(host.name)
		return
	var/shown_title = title
	if(length_char(shown_title) > BILL_OF_FARE_NAME_TITLE_LEN)
		shown_title = "[trim(copytext_char(shown_title, 1, BILL_OF_FARE_NAME_TITLE_LEN))]..."
	host.name = "Bill of Fare: [shown_title]"

/datum/component/bill_of_fare/UnregisterFromParent()
	UnregisterSignal(parent, list(COMSIG_ITEM_ATTACK_SELF, COMSIG_ATOM_ATTACK_HAND, COMSIG_PARENT_ATTACKBY, COMSIG_PARENT_EXAMINE))

/datum/component/bill_of_fare/proc/on_attack_self(datum/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(open), user)
	return COMPONENT_NO_INTERACT

/datum/component/bill_of_fare/proc/on_attack_hand(datum/source, mob/user)
	SIGNAL_HANDLER
	INVOKE_ASYNC(src, PROC_REF(open), user)
	return COMPONENT_NO_ATTACK_HAND

/datum/component/bill_of_fare/proc/on_attackby(datum/source, obj/item/tool, mob/user, params)
	SIGNAL_HANDLER
	if(!istype(tool, /obj/item/natural/feather) && !istype(tool, /obj/item/natural/thorn))
		return
	INVOKE_ASYNC(src, PROC_REF(open), user)
	return COMPONENT_NO_AFTERATTACK

/datum/component/bill_of_fare/proc/on_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!has_writing())
		return
	if(!user.can_read(parent, TRUE))
		examine_list += "I have no idea what it says."
		return
	if(length(title))
		examine_list += "It is headed \"[title]\"."
	var/signed_by = signature()
	if(signed_by)
		examine_list += "This Bill of Fare was written by [signed_by]."
	var/list/counts = list()
	for(var/key in columns)
		var/datum/bill_of_fare_column/column = columns[key]
		if(length(column.lines))
			counts += column.count_text()
	if(length(counts))
		examine_list += "It lists [english_list(counts)]."

/datum/component/bill_of_fare/proc/open(mob/user)
	if(!user.can_read(parent))
		return
	if(holds_writing_tool(user) && !may_edit(user))
		to_chat(user, span_warning("This is written by another person."))
	var/datum/tgui/ui = SStgui.get_open_ui(user, src)
	if(ui)
		ui.send_full_update()
		return
	ui_interact(user)

/datum/component/bill_of_fare/proc/has_writing()
	if(length(title) || length(notes))
		return TRUE
	for(var/key in columns)
		var/datum/bill_of_fare_column/column = columns[key]
		if(length(column.lines))
			return TRUE
	return FALSE

/datum/component/bill_of_fare/proc/holds_writing_tool(mob/user)
	return !!(user.is_holding_item_of_type(/obj/item/natural/feather) || user.is_holding_item_of_type(/obj/item/natural/thorn))

/datum/component/bill_of_fare/proc/can_write(mob/user)
	if(!user.can_read(parent, TRUE) || !holds_writing_tool(user))
		return FALSE
	return may_edit(user)

/datum/component/bill_of_fare/proc/is_claimed()
	return !isnull(author_mind)

/datum/component/bill_of_fare/proc/is_author(mob/user)
	return !!(user?.mind && IS_WEAKREF_OF(user.mind, author_mind))

/datum/component/bill_of_fare/proc/may_edit(mob/user)
	if(!user?.mind)
		return FALSE
	return !is_claimed() || open_to_all || is_author(user)

/datum/component/bill_of_fare/proc/claim(mob/user)
	if(is_claimed() || !user?.mind)
		return
	author_mind = WEAKREF(user.mind)
	author_ckey = user.ckey
	author_name = user.real_name
	author_job = user.job
	log_paper("[key_name(user)] signed [parent] as its author")

/datum/component/bill_of_fare/proc/signature()
	if(!is_claimed() || open_to_all)
		return null
	if(signature_mode == BILL_OF_FARE_SIGN_JOB && length(author_job))
		return "the [author_job]"
	if(signature_mode == BILL_OF_FARE_SIGN_PEN && length(pen_name))
		return pen_name
	return author_name

/datum/component/bill_of_fare/proc/get_column(key)
	if(!istext(key))
		return
	return columns[key]

/datum/component/bill_of_fare/proc/log_write(mob/user, field, text)
	log_paper("[key_name(user)] wrote on [parent] ([field]): [text]")

/datum/component/bill_of_fare/ui_state(mob/user)
	return GLOB.human_adjacent_state

/datum/component/bill_of_fare/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BillOfFare")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/component/bill_of_fare/ui_static_data(mob/user)
	var/list/column_info = list()
	for(var/key in columns)
		var/datum/bill_of_fare_column/column = columns[key]
		column_info += list(list(
			"key" = column.key,
			"label" = column.label,
			"cap" = column.cap,
			"catalog" = column.catalog_key,
			"vessels" = column.uses_vessels,
		))
	var/list/vessel_info = list()
	var/list/vessels = get_bill_of_fare_vessels()
	for(var/key in vessels)
		var/datum/bill_of_fare_vessel/vessel = vessels[key]
		vessel_info += list(vessel.ui_entry())
	var/list/data = list(
		"columns" = column_info,
		"vessels" = vessel_info,
		"max_price" = BILL_OF_FARE_MAX_PRICE,
		"title_len" = BILL_OF_FARE_TITLE_LEN,
		"line_len" = BILL_OF_FARE_LINE_LEN,
		"notes_len" = BILL_OF_FARE_NOTES_LEN,
		"pen_name_len" = BILL_OF_FARE_PEN_NAME_LEN,
		"import_len" = BILL_OF_FARE_IMPORT_MAX_LEN,
		"picker_rows" = BILL_OF_FARE_PICKER_ROWS,
	)
	if(can_write(user))
		data["catalogs"] = get_bill_of_fare_ui_catalogs()
	return data

/datum/component/bill_of_fare/proc/make_line(datum/bill_of_fare_column/column, name, linked_type, list/params)
	if(!column.uses_vessels)
		return new /datum/bill_of_fare_line(next_uid++, name, clean_bill_of_fare_price(params["price"]), linked_type)
	var/list/prices = clean_bill_of_fare_vessel_prices(params["prices"])
	if(!length(prices))
		return null
	return new /datum/bill_of_fare_line(next_uid++, name, 0, linked_type, prices)

/datum/component/bill_of_fare/ui_data(mob/user)
	var/list/rows = list()
	for(var/key in columns)
		var/datum/bill_of_fare_column/column = columns[key]
		rows[key] = column.rows()
	var/author = is_author(user)
	return list(
		"title" = title,
		"notes" = notes,
		"can_edit" = can_write(user),
		"rows" = rows,
		"export" = export_text(),
		"signature" = signature(),
		"claimed" = is_claimed(),
		"open_to_all" = open_to_all,
		"is_author" = author,
		"foreign_hand" = holds_writing_tool(user) && !may_edit(user),
		"signature_mode" = author ? signature_mode : null,
		"pen_name" = author ? pen_name : null,
		"author_name" = author ? author_name : null,
		"author_job" = author ? author_job : null,
	)

/datum/component/bill_of_fare/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	var/mob/user = ui.user
	if(!can_write(user))
		return
	switch(action)
		if("set_title")
			var/clean = bill_of_fare_clean_text(user, params["text"], BILL_OF_FARE_TITLE_LEN)
			if(isnull(clean))
				return
			title = clean
			log_write(user, "title", clean)
		if("set_notes")
			var/clean = bill_of_fare_clean_text(user, params["text"], BILL_OF_FARE_NOTES_LEN, TRUE)
			if(isnull(clean))
				return
			notes = clean
			log_write(user, "notes", clean)
		if("add_linked")
			var/datum/bill_of_fare_column/column = get_column(params["column"])
			if(!column || length(column.lines) >= column.cap)
				return
			var/list/index = column.get_catalog()
			var/id = params["id"]
			if(!isnum(id) || id != round(id, 1) || id < 1 || id > length(index))
				return
			var/linked_type = index[id]
			var/datum/bill_of_fare_line/line = make_line(column, index[linked_type], linked_type, params)
			if(!line)
				return
			column.lines += line
		if("add_written")
			var/datum/bill_of_fare_column/column = get_column(params["column"])
			if(!column || length(column.lines) >= column.cap)
				return
			var/clean = bill_of_fare_clean_text(user, params["text"], BILL_OF_FARE_LINE_LEN)
			if(!length(clean))
				return
			var/datum/bill_of_fare_line/line = make_line(column, clean, null, params)
			if(!line)
				return
			column.lines += line
			log_write(user, column.key, clean)
		if("rename")
			var/datum/bill_of_fare_column/column = get_column(params["column"])
			var/datum/bill_of_fare_line/line = column?.find_line(params["uid"])
			if(!line)
				return
			var/clean = bill_of_fare_clean_text(user, params["text"], BILL_OF_FARE_LINE_LEN)
			if(isnull(clean))
				return
			if(!length(clean))
				if(!line.linked)
					return
				var/list/index = column.get_catalog()
				clean = index[line.linked]
			line.name = clean
			log_write(user, column.key, clean)
		if("set_price")
			var/datum/bill_of_fare_column/column = get_column(params["column"])
			var/datum/bill_of_fare_line/line = column?.find_line(params["uid"])
			if(!line)
				return
			var/value = params["value"]
			if(!column.uses_vessels)
				if(!isnum(value))
					return
				line.price = clean_bill_of_fare_price(value)
			else
				var/vessel_key = params["vessel"]
				if(!is_bill_of_fare_vessel(vessel_key))
					return
				if(isnum(value))
					line.vessel_prices[vessel_key] = clean_bill_of_fare_price(value)
				else
					if(isnull(line.vessel_prices[vessel_key]) || length(line.vessel_prices) <= 1)
						return
					line.vessel_prices -= vessel_key
		if("remove")
			var/datum/bill_of_fare_column/column = get_column(params["column"])
			var/datum/bill_of_fare_line/line = column?.find_line(params["uid"])
			if(!line)
				return
			column.lines -= line
		if("import")
			if(!COOLDOWN_FINISHED(src, import_cooldown))
				to_chat(user, span_warning("I need a moment."))
				return
			COOLDOWN_START(src, import_cooldown, BILL_OF_FARE_IMPORT_COOLDOWN)
			if(!import_text(user, params["text"]))
				return
		if("set_signature")
			if(!is_author(user))
				return
			var/mode = params["mode"]
			switch(mode)
				if(BILL_OF_FARE_SIGN_NAME)
					signature_mode = mode
				if(BILL_OF_FARE_SIGN_JOB)
					if(!length(author_job))
						return
					signature_mode = mode
				if(BILL_OF_FARE_SIGN_PEN)
					var/clean = bill_of_fare_clean_text(user, params["text"], BILL_OF_FARE_PEN_NAME_LEN)
					if(!length(clean))
						return
					pen_name = clean
					signature_mode = mode
					log_write(user, "pen name", clean)
				else
					return
		if("set_open")
			if(!is_author(user))
				return
			open_to_all = !!params["open"]
			log_paper("[key_name(user)] [open_to_all ? "opened" : "closed"] [parent] to other writers")
		else
			return
	claim(user)
	update_parent_name()
	var/atom/host = parent
	host.update_icon()
	return TRUE
