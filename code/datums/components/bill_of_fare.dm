/datum/bill_of_fare_line
	var/uid
	var/name
	var/price = 0
	var/linked

/datum/bill_of_fare_line/New(uid, name, price, linked)
	src.uid = uid
	src.name = name
	src.price = price
	src.linked = linked

/datum/bill_of_fare_column
	abstract_type = /datum/bill_of_fare_column
	var/key
	var/label
	var/cap
	var/catalog_key
	var/noun_one
	var/noun_many
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
			"price" = line.price,
			"linked" = !!line.linked,
		)
		if(line.linked)
			link_data(row, line.linked)
		rows += list(row)
	return rows

/datum/bill_of_fare_column/food
	key = "food"
	label = "Food"
	cap = BILL_OF_FARE_MAX_FOOD
	catalog_key = "food"
	noun_one = "dish"
	noun_many = "dishes"

/datum/bill_of_fare_column/food/get_catalog()
	return get_bill_of_fare_foods()

/datum/bill_of_fare_column/food/link_data(list/row, linked_type)
	var/obj/item/food_type = linked_type
	row["icon"] = "[initial(food_type.icon)]"
	row["icon_state"] = initial(food_type.icon_state)
	row["desc"] = initial(food_type.desc)

/datum/bill_of_fare_column/food/provisions
	key = "provisions"
	label = "Provisions"
	cap = BILL_OF_FARE_MAX_PROVISIONS
	noun_one = "provision"
	noun_many = "provisions"

/datum/bill_of_fare_column/drink
	key = "drink"
	label = "Drink"
	cap = BILL_OF_FARE_MAX_DRINK
	catalog_key = "drink"
	noun_one = "drink"
	noun_many = "drinks"

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

/datum/component/bill_of_fare/proc/can_write(mob/user)
	if(!user.can_read(parent, TRUE))
		return FALSE
	return !!(user.is_holding_item_of_type(/obj/item/natural/feather) || user.is_holding_item_of_type(/obj/item/natural/thorn))

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
		))
	var/list/data = list(
		"columns" = column_info,
		"max_price" = BILL_OF_FARE_MAX_PRICE,
		"title_len" = BILL_OF_FARE_TITLE_LEN,
		"line_len" = BILL_OF_FARE_LINE_LEN,
		"notes_len" = BILL_OF_FARE_NOTES_LEN,
		"search_min" = BILL_OF_FARE_SEARCH_MIN,
		"search_results" = BILL_OF_FARE_SEARCH_RESULTS,
	)
	if(can_write(user))
		data["catalogs"] = list(
			"food" = catalog_pairs(get_bill_of_fare_foods()),
			"drink" = catalog_pairs(get_bill_of_fare_drinks()),
		)
	return data

/datum/component/bill_of_fare/proc/catalog_pairs(list/index)
	var/list/pairs = list()
	for(var/i in 1 to length(index))
		pairs += list(list(i, index[index[i]]))
	return pairs

/datum/component/bill_of_fare/ui_data(mob/user)
	var/list/rows = list()
	for(var/key in columns)
		var/datum/bill_of_fare_column/column = columns[key]
		rows[key] = column.rows()
	return list(
		"title" = title,
		"notes" = notes,
		"can_edit" = can_write(user),
		"rows" = rows,
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
			column.lines += new /datum/bill_of_fare_line(next_uid++, index[linked_type], 0, linked_type)
		if("add_written")
			var/datum/bill_of_fare_column/column = get_column(params["column"])
			if(!column || length(column.lines) >= column.cap)
				return
			var/clean = bill_of_fare_clean_text(user, params["text"], BILL_OF_FARE_LINE_LEN)
			if(!length(clean))
				return
			column.lines += new /datum/bill_of_fare_line(next_uid++, clean, 0, null)
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
			var/value = params["value"]
			if(!line || !isnum(value))
				return
			line.price = clamp(round(value, 1), 0, BILL_OF_FARE_MAX_PRICE)
		if("remove")
			var/datum/bill_of_fare_column/column = get_column(params["column"])
			var/datum/bill_of_fare_line/line = column?.find_line(params["uid"])
			if(!line)
				return
			column.lines -= line
		else
			return
	var/atom/host = parent
	host.update_icon()
	return TRUE
