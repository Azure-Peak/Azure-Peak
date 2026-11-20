GLOBAL_LIST_EMPTY(bill_of_fare_foods)
GLOBAL_LIST_EMPTY(bill_of_fare_drinks)
GLOBAL_LIST_EMPTY(bill_of_fare_ui_catalogs)

/proc/get_bill_of_fare_ui_catalogs()
	if(!length(GLOB.bill_of_fare_ui_catalogs))
		var/list/icon_files = list()
		var/list/icon_slots = list()
		var/list/food_entries = list()
		var/list/food_index = get_bill_of_fare_foods()
		for(var/i in 1 to length(food_index))
			var/obj/item/food_type = food_index[i]
			var/icon_file = "[initial(food_type.icon)]"
			if(isnull(icon_slots[icon_file]))
				icon_files += icon_file
				icon_slots[icon_file] = length(icon_files)
			food_entries += list(list(i, food_index[food_type], icon_slots[icon_file], initial(food_type.icon_state)))
		var/list/drink_entries = list()
		var/list/drink_index = get_bill_of_fare_drinks()
		for(var/i in 1 to length(drink_index))
			var/datum/reagent/drink_type = drink_index[i]
			drink_entries += list(list(i, drink_index[drink_type], initial(drink_type.color)))
		GLOB.bill_of_fare_ui_catalogs = list(
			"icon_files" = icon_files,
			"food" = food_entries,
			"drink" = drink_entries,
		)
	return GLOB.bill_of_fare_ui_catalogs

/proc/get_bill_of_fare_foods()
	if(!length(GLOB.bill_of_fare_foods))
		var/list/raw = list()
		for(var/obj/item/reagent_containers/food/snacks/food_type as anything in subtypesof(/obj/item/reagent_containers/food/snacks))
			if(is_abstract(food_type))
				continue
			raw[food_type] = initial(food_type.name)
		GLOB.bill_of_fare_foods = build_bill_of_fare_index(raw)
	return GLOB.bill_of_fare_foods

/proc/get_bill_of_fare_drinks()
	if(!length(GLOB.bill_of_fare_drinks))
		var/list/drink_types = list()
		for(var/base_type in BILL_OF_FARE_DRINK_BASES)
			drink_types += subtypesof(base_type)
		drink_types += BILL_OF_FARE_DRINK_EXACT
		var/list/raw = list()
		for(var/datum/reagent/drink_type as anything in drink_types)
			if(is_abstract(drink_type))
				continue
			raw[drink_type] = initial(drink_type.name)
		GLOB.bill_of_fare_drinks = build_bill_of_fare_index(raw)
	return GLOB.bill_of_fare_drinks

/proc/build_bill_of_fare_index(list/raw)
	var/list/index = list()
	var/list/seen = list()
	for(var/entry_type in raw)
		var/entry_name = raw[entry_type]
		if(!istext(entry_name))
			continue
		entry_name = trim(replacetext(entry_name, "|", ""))
		if(!length(entry_name))
			continue
		var/key = lowertext(entry_name)
		if(seen[key])
			continue
		seen[key] = TRUE
		index[entry_type] = capitalize(entry_name)
	return index

/proc/bill_of_fare_clean_text(mob/user, text, limit, multiline = FALSE)
	if(!istext(text))
		return ""
	text = copytext_char(text, 1, limit + 1)
	text = replacetext(text, BILL_OF_FARE_CARRIAGE_RETURN, "")
	text = replacetext(text, "|", "")
	if(multiline)
		var/list/text_lines = splittext(text, "\n")
		if(length(text_lines) > BILL_OF_FARE_NOTES_MAX_LINES)
			text = jointext(text_lines.Copy(1, BILL_OF_FARE_NOTES_MAX_LINES + 1), "\n")
	else
		text = replacetext(text, "\n", " ")
	text = trim(STRIP_HTML_SIMPLE(text, length(text) + 1))
	if(CHAT_FILTER_CHECK(text))
		to_chat(user, span_warning("I can't write that."))
		return null
	return text
