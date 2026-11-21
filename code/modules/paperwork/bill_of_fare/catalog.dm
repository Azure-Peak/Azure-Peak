GLOBAL_LIST_EMPTY(bill_of_fare_catalogs)

/datum/bill_of_fare_catalog
	var/list/index = list()
	var/list/by_id = list()
	var/list/by_name = list()
	var/list/icon_files = list()
	var/list/icon_slots = list()
	var/list/entries = list()

/datum/bill_of_fare_catalog/New(datum/bill_of_fare_column/column)
	var/list/seen = list()
	var/list/raw = column.build_raw_catalog()
	for(var/entry_type in raw)
		var/entry_name = raw[entry_type]
		if(!istext(entry_name))
			continue
		entry_name = trim(replacetext(entry_name, "|", ""))
		if(!length(entry_name))
			continue
		var/lower = LOWER_TEXT(entry_name)
		if(seen[lower])
			continue
		seen[lower] = TRUE
		index[entry_type] = capitalize(entry_name)
	for(var/i in 1 to length(index))
		var/entry_type = index[i]
		by_id[column.item_id(entry_type)] = entry_type
		by_name[LOWER_TEXT(index[entry_type])] = entry_type
		entries += list(column.catalog_entry(src, i, entry_type))

/datum/bill_of_fare_catalog/proc/icon_slot(icon_file)
	var/slot = icon_slots[icon_file]
	if(!slot)
		icon_files += icon_file
		slot = length(icon_files)
		icon_slots[icon_file] = slot
	return slot

/datum/bill_of_fare_catalog/proc/picker_data()
	return list(
		"icon_files" = icon_files,
		"entries" = entries,
	)

/datum/bill_of_fare_column/proc/get_catalog()
	RETURN_TYPE(/datum/bill_of_fare_catalog)
	var/datum/bill_of_fare_catalog/catalog = GLOB.bill_of_fare_catalogs[key]
	if(!catalog)
		catalog = new(src)
		GLOB.bill_of_fare_catalogs[key] = catalog
	return catalog

/datum/bill_of_fare_column/proc/catalog_name(linked_type)
	return get_catalog().index[linked_type]

/datum/bill_of_fare_column/proc/catalog_type_at(id)
	var/list/index = get_catalog().index
	if(!isnum(id) || id != round(id, 1) || id < 1 || id > length(index))
		return null
	return index[id]

/datum/bill_of_fare_column/proc/item_id(linked_type)
	return copytext("[linked_type]", length("[catalog_root]") + 2)

/datum/bill_of_fare_column/proc/find_by_id(id)
	if(!istext(id))
		return null
	return get_catalog().by_id[trim(id)]

/datum/bill_of_fare_column/proc/find_by_name(catalog_name)
	if(!istext(catalog_name))
		return null
	return get_catalog().by_name[LOWER_TEXT(trim(catalog_name))]

/datum/bill_of_fare_column/proc/build_raw_catalog()
	return list()

/datum/bill_of_fare_column/proc/catalog_entry(datum/bill_of_fare_catalog/catalog, id, entry_type)
	return list(id, catalog.index[entry_type], null, null, null)

/datum/bill_of_fare_column/food/build_raw_catalog()
	var/list/raw = list()
	for(var/obj/item/food_type as anything in subtypesof(catalog_root))
		if(is_abstract(food_type))
			continue
		raw[food_type] = initial(food_type.name)
	return raw

/datum/bill_of_fare_column/food/catalog_entry(datum/bill_of_fare_catalog/catalog, id, entry_type)
	var/obj/item/food_type = entry_type
	return list(id, catalog.index[entry_type], catalog.icon_slot("[initial(food_type.icon)]"), initial(food_type.icon_state), null)

/datum/bill_of_fare_column/drink/build_raw_catalog()
	var/list/drink_types = list()
	for(var/base_type in BILL_OF_FARE_DRINK_BASES)
		drink_types += subtypesof(base_type)
	drink_types += BILL_OF_FARE_DRINK_EXACT
	var/list/raw = list()
	for(var/datum/reagent/drink_type as anything in drink_types)
		if(is_abstract(drink_type))
			continue
		raw[drink_type] = initial(drink_type.name)
	return raw

/datum/bill_of_fare_column/drink/catalog_entry(datum/bill_of_fare_catalog/catalog, id, entry_type)
	var/datum/reagent/drink_type = entry_type
	return list(id, catalog.index[entry_type], null, null, initial(drink_type.color))

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
