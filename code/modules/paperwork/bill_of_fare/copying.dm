#define BOF_NOT_A_MENU "That is not a bill of fare."
#define BOF_TOO_LONG "That is too long."
#define BOF_BAD_LINE(line_number) "Line [line_number] of that is not right."

/proc/bill_of_fare_parse_price(price_text)
	if(!istext(price_text))
		return null
	price_text = trim(price_text)
	var/digits = length(price_text)
	if(!digits || digits > BILL_OF_FARE_IMPORT_PRICE_DIGITS)
		return null
	for(var/i in 1 to digits)
		var/code = text2ascii(price_text, i)
		if(code < text2ascii("0") || code > text2ascii("9"))
			return null
	return clean_bill_of_fare_price(text2num(price_text))

/proc/bill_of_fare_name_list(list/names)
	if(length(names) <= BILL_OF_FARE_IMPORT_REPORT_NAMES)
		return english_list(names)
	var/list/shown = names.Copy(1, BILL_OF_FARE_IMPORT_REPORT_NAMES + 1)
	shown += "[length(names) - BILL_OF_FARE_IMPORT_REPORT_NAMES] more"
	return english_list(shown)

/datum/component/bill_of_fare/proc/export_text()
	var/list/out = list(BILL_OF_FARE_EXPORT_HEADER)
	if(length(title))
		out += "T|[title]"
	for(var/key in columns)
		var/datum/bill_of_fare_column/column = columns[key]
		for(var/datum/bill_of_fare_line/line as anything in column.lines)
			var/item_id = line.linked ? column.item_id(line.linked) : ""
			var/item_name = line.linked ? "[column.catalog_name(line.linked)]" : ""
			out += "[column.export_tag]|[line.name]|[line.price]|[item_id]|[item_name]"
	if(length(notes))
		for(var/note_line in splittext(notes, "\n"))
			out += "N|[note_line]"
	return jointext(out, "\n")

/datum/component/bill_of_fare/proc/import_text(mob/user, text)
	var/list/report = list(
		"unlinked" = list(),
		"overflow" = 0,
		"notes_cut" = FALSE,
	)
	var/parsed = parse_import(user, text, report)
	if(isnull(parsed))
		return FALSE
	if(istext(parsed))
		to_chat(user, span_warning(parsed))
		return FALSE
	apply_import(parsed)
	to_chat(user, span_notice("I copy the menu onto [parent]."))
	for(var/report_line in import_report_lines(report))
		to_chat(user, span_warning(report_line))
	log_paper("[key_name(user)] copied a bill of fare onto [parent]: [replacetext(export_text(), "\n", " / ")]")
	return TRUE

/datum/component/bill_of_fare/proc/import_report_lines(list/report)
	var/list/out = list()
	var/list/unlinked = report["unlinked"]
	if(length(unlinked))
		out += "Recipe not found, kept as written: [bill_of_fare_name_list(unlinked)]."
	var/overflow = report["overflow"]
	if(overflow)
		out += "No room, removed: [overflow] [overflow == 1 ? "line" : "lines"]."
	if(report["notes_cut"])
		out += "Notes too long, trimmed."
	return out

/datum/component/bill_of_fare/proc/parse_import(mob/user, text, list/report)
	if(!istext(text))
		return BOF_NOT_A_MENU
	if(length(text) > BILL_OF_FARE_IMPORT_MAX_LEN * 4)
		return BOF_TOO_LONG
	text = replacetext(text, BILL_OF_FARE_CARRIAGE_RETURN, "")
	if(length_char(text) > BILL_OF_FARE_IMPORT_MAX_LEN)
		return BOF_TOO_LONG
	var/list/lines = splittext(text, "\n")
	if(length(lines) > BILL_OF_FARE_IMPORT_MAX_LINES)
		return BOF_TOO_LONG
	if(trim(lines[1]) != BILL_OF_FARE_EXPORT_HEADER)
		return BOF_NOT_A_MENU

	var/list/by_tag = list()
	var/list/parsed_columns = list()
	for(var/key in columns)
		var/datum/bill_of_fare_column/column = columns[key]
		by_tag[column.export_tag] = column
		parsed_columns[key] = list()

	var/new_title = ""
	var/title_seen = FALSE
	var/list/note_lines = list()
	for(var/line_number in 2 to length(lines))
		var/raw_line = lines[line_number]
		if(!length(trim(raw_line)))
			continue
		var/list/fields = splittext(raw_line, "|")
		for(var/field in fields)
			if(length(field) > BILL_OF_FARE_IMPORT_FIELD_LEN)
				return BOF_BAD_LINE(line_number)
		var/line_tag = trim(fields[1])
		if(line_tag == "T")
			if(title_seen || length(fields) != 2)
				return BOF_BAD_LINE(line_number)
			title_seen = TRUE
			new_title = bill_of_fare_clean_text(user, fields[2], BILL_OF_FARE_TITLE_LEN)
			if(isnull(new_title))
				return null
			continue
		if(line_tag == "N")
			if(length(fields) != 2)
				return BOF_BAD_LINE(line_number)
			note_lines += fields[2]
			continue
		var/datum/bill_of_fare_column/column = by_tag[line_tag]
		if(!column)
			return BOF_BAD_LINE(line_number)
		var/row = parse_import_row(user, column, fields, report)
		if(isnull(row))
			return null
		if(!islist(row))
			return BOF_BAD_LINE(line_number)
		var/list/rows = parsed_columns[column.key]
		if(length(rows) >= column.cap)
			report["overflow"]++
			continue
		rows += list(row)

	var/joined_notes = jointext(note_lines, "\n")
	if(length(note_lines) > BILL_OF_FARE_NOTES_MAX_LINES || length_char(joined_notes) > BILL_OF_FARE_NOTES_LEN)
		report["notes_cut"] = TRUE
	var/new_notes = bill_of_fare_clean_text(user, joined_notes, BILL_OF_FARE_NOTES_LEN, TRUE)
	if(isnull(new_notes))
		return null
	return list(
		"title" = new_title,
		"notes" = new_notes,
		"columns" = parsed_columns,
	)

/datum/component/bill_of_fare/proc/parse_import_row(mob/user, datum/bill_of_fare_column/column, list/fields, list/report)
	if(length(fields) != 5)
		return FALSE
	var/price = bill_of_fare_parse_price(fields[3])
	if(isnull(price))
		return FALSE
	var/item_id = trim(fields[4])
	var/item_name = trim(fields[5])
	var/linked_type = column.find_by_id(item_id) || column.find_by_name(item_name)
	var/row_name = bill_of_fare_clean_text(user, fields[2], BILL_OF_FARE_LINE_LEN)
	if(isnull(row_name))
		return null
	if(!length(row_name))
		if(linked_type)
			row_name = column.catalog_name(linked_type)
		else
			row_name = bill_of_fare_clean_text(user, item_name, BILL_OF_FARE_LINE_LEN)
			if(isnull(row_name))
				return null
			if(!length(row_name))
				return FALSE
	if(!linked_type && (length(item_id) || length(item_name)))
		var/list/unlinked = report["unlinked"]
		unlinked += row_name
	return list(
		"name" = row_name,
		"linked" = linked_type,
		"price" = price,
	)

/datum/component/bill_of_fare/proc/apply_import(list/parsed)
	title = parsed["title"]
	notes = parsed["notes"]
	var/list/parsed_columns = parsed["columns"]
	for(var/key in columns)
		var/datum/bill_of_fare_column/column = columns[key]
		column.lines = list()
		for(var/list/row as anything in parsed_columns[key])
			add_line(column, row["name"], row["linked"], row["price"])

#undef BOF_NOT_A_MENU
#undef BOF_TOO_LONG
#undef BOF_BAD_LINE
