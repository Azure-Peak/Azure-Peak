GLOBAL_LIST_EMPTY(bill_of_fare_foods)
GLOBAL_LIST_EMPTY(bill_of_fare_drinks)

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
		entry_name = trim(entry_name)
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
	if(!multiline)
		text = replacetext(text, "\n", " ")
	text = copytext_char(text, 1, limit + 1)
	text = trim(STRIP_HTML_SIMPLE(text, length(text) + 1))
	if(CHAT_FILTER_CHECK(text))
		to_chat(user, span_warning("I can't write that."))
		return null
	return text
