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

/proc/is_bill_of_fare_writing_tool(obj/item/tool)
	return istype(tool, /obj/item/natural/feather) || istype(tool, /obj/item/natural/thorn)

/proc/bill_of_fare_icon_state(atom/host)
	var/datum/component/bill_of_fare/menu = host.GetComponent(/datum/component/bill_of_fare)
	return menu?.has_writing() ? "paperwrite" : "paper"

/proc/bill_of_fare_mechanics_examine()
	return list(
		span_info("A Bill of Fare is signed by the first person to write on it. Only they can change what it says, unless they let anyone else write on it."),
		span_info("A new bill of fare can be made by crafting with a piece of paper."),
	)

/proc/clean_bill_of_fare_price(value)
	if(!isnum(value))
		return 0
	return clamp(round(value, 1), 0, BILL_OF_FARE_MAX_PRICE)

/datum/bill_of_fare_column
	abstract_type = /datum/bill_of_fare_column
	var/key
	var/label
	var/cap
	var/catalog_root
	var/noun_one
	var/noun_many
	var/export_tag
	var/list/lines = list()

/datum/bill_of_fare_column/proc/link_data(list/row, linked_type)
	return

/datum/bill_of_fare_column/proc/count_text()
	var/count = length(lines)
	return "[count] [count == 1 ? noun_one : noun_many]"

/datum/bill_of_fare_column/proc/is_full()
	return length(lines) >= cap

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
	catalog_root = /obj/item/reagent_containers/food/snacks
	noun_one = "dish"
	noun_many = "dishes"
	export_tag = "F"

/datum/bill_of_fare_column/food/link_data(list/row, linked_type)
	var/obj/item/food_type = linked_type
	row["icon"] = "[initial(food_type.icon)]"
	row["icon_state"] = initial(food_type.icon_state)
	row["desc"] = initial(food_type.desc)

/datum/bill_of_fare_column/drink
	key = "drink"
	label = "Drink"
	cap = BILL_OF_FARE_MAX_DRINK
	catalog_root = /datum/reagent
	noun_one = "drink"
	noun_many = "drinks"
	export_tag = "D"

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
	if(!is_bill_of_fare_writing_tool(tool))
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
	INVOKE_ASYNC(src, PROC_REF(open), user)

/datum/component/bill_of_fare/proc/open(mob/user)
	if(!user.can_read(parent))
		return
	if(foreign_hand(user))
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
	for(var/obj/item/held in user.held_items)
		if(is_bill_of_fare_writing_tool(held))
			return TRUE
	return FALSE

/datum/component/bill_of_fare/proc/foreign_hand(mob/user)
	return holds_writing_tool(user) && !may_edit(user)

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
	var/list/catalogs = list()
	for(var/key in columns)
		var/datum/bill_of_fare_column/column = columns[key]
		column_info += list(list(
			"key" = column.key,
			"label" = column.label,
			"cap" = column.cap,
		))
		catalogs[key] = column.get_catalog().picker_data()
	var/list/data = list(
		"columns" = column_info,
		"cup" = list(
			"icon" = "[BILL_OF_FARE_CUP_ICON]",
			"icon_state" = BILL_OF_FARE_CUP_STATE,
			"fill_state" = BILL_OF_FARE_CUP_FILL_STATE,
		),
		"max_price" = BILL_OF_FARE_MAX_PRICE,
		"title_len" = BILL_OF_FARE_TITLE_LEN,
		"line_len" = BILL_OF_FARE_LINE_LEN,
		"notes_len" = BILL_OF_FARE_NOTES_LEN,
		"pen_name_len" = BILL_OF_FARE_PEN_NAME_LEN,
		"import_len" = BILL_OF_FARE_IMPORT_MAX_LEN,
		"picker_rows" = BILL_OF_FARE_PICKER_ROWS,
	)
	if(can_write(user))
		data["catalogs"] = catalogs
	return data

/datum/component/bill_of_fare/proc/add_line(datum/bill_of_fare_column/column, name, linked_type, price)
	if(column.is_full())
		return null
	var/datum/bill_of_fare_line/line = new(next_uid++, name, clean_bill_of_fare_price(price), linked_type)
	column.lines += line
	return line

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
		"foreign_hand" = foreign_hand(user),
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
			var/linked_type = column?.catalog_type_at(params["id"])
			if(!linked_type || !add_line(column, column.catalog_name(linked_type), linked_type, params["price"]))
				return
		if("add_written")
			var/datum/bill_of_fare_column/column = get_column(params["column"])
			if(!column)
				return
			var/clean = bill_of_fare_clean_text(user, params["text"], BILL_OF_FARE_LINE_LEN)
			if(!length(clean) || !add_line(column, clean, null, params["price"]))
				return
			log_write(user, column.key, clean)
		if("rename", "set_price", "remove")
			var/datum/bill_of_fare_column/column = get_column(params["column"])
			var/datum/bill_of_fare_line/line = column?.find_line(params["uid"])
			if(!line || !edit_line(user, action, column, line, params))
				return
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

/datum/component/bill_of_fare/proc/edit_line(mob/user, action, datum/bill_of_fare_column/column, datum/bill_of_fare_line/line, list/params)
	switch(action)
		if("rename")
			var/clean = bill_of_fare_clean_text(user, params["text"], BILL_OF_FARE_LINE_LEN)
			if(isnull(clean))
				return FALSE
			if(!length(clean))
				if(!line.linked)
					return FALSE
				clean = column.catalog_name(line.linked)
			line.name = clean
			log_write(user, column.key, clean)
		if("set_price")
			var/value = params["value"]
			if(!isnum(value))
				return FALSE
			line.price = clean_bill_of_fare_price(value)
		if("remove")
			column.lines -= line
	return TRUE
