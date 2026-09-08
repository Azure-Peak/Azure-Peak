/datum/language_segment
	var/datum/language/language
	var/text

/datum/language_segment/New(language, text)
	src.language = language
	src.text = text

/proc/parse_language_segments(message, datum/language/default_language)
	if(!message || !findtext(message, ","))
		return null

	var/list/segments
	var/found_marker = FALSE
	var/message_length = length(message)
	var/base_start = 1
	var/search_from = 1

	while(search_from <= message_length)
		var/marker = findtext(message, ",", search_from)
		if(!marker)
			break
		search_from = marker + 1

		if(copytext(message, marker + 2, marker + 3) != "(")
			continue
		var/datum/language/segment_language = GLOB.language_types_by_key[LOWER_TEXT(copytext(message, marker + 1, marker + 2))]
		if(!segment_language)
			continue

		found_marker = TRUE
		var/text_start = marker + 3
		var/text_end = find_language_segment_close(message, text_start)

		var/base_text = copytext(message, base_start, marker)
		if(base_text)
			LAZYADD(segments, new /datum/language_segment(default_language, base_text))
		var/segment_text = copytext(message, text_start, text_end)
		if(segment_text)
			LAZYADD(segments, new /datum/language_segment(segment_language, segment_text))

		if(!text_end)
			return segments

		base_start = text_end + 1
		search_from = base_start

	if(!found_marker)
		return null

	var/trailing_text = copytext(message, base_start)
	if(trailing_text)
		LAZYADD(segments, new /datum/language_segment(default_language, trailing_text))
	return segments

/proc/find_language_segment_close(message, start)
	var/depth = 1
	var/scan = start
	while(TRUE)
		var/next_close = findtext(message, ")", scan)
		if(!next_close)
			return 0
		var/next_open = findtext(message, "(", scan, next_close)
		if(next_open)
			depth++
			scan = next_open + 1
			continue
		depth--
		if(!depth)
			return next_close
		scan = next_close + 1

/// Proc to stitch the msg.
/proc/build_language_segments(list/segments, datum/language/default_language)
	var/message = ""
	for(var/datum/language_segment/segment as anything in segments)
		if(segment.language && segment.language != default_language)
			message += ",[initial(segment.language.key)]([segment.text])"
		else
			message += segment.text
	return message

/proc/strip_language_segments(message)
	var/list/segments = parse_language_segments(message, null)
	if(!segments)
		return message
	var/stripped = ""
	for(var/datum/language_segment/segment as anything in segments)
		stripped += segment.text
	return stripped
