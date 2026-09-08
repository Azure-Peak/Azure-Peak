/datum/species
	var/amtfail = 0

#define REGEX_FULLWORD 1
#define REGEX_STARTWORD 2
#define REGEX_ENDWORD 3
#define REGEX_ANY 4

/*
	Applies the universal accent code, alongside autopunctuating and trimming.
	autopunct and do_trim are on for speech, while the emote quote path turns them off so the quoted words are
	left exactly as typed.
*/
/proc/apply_accent_pipeline(message, autopunct = TRUE, do_trim = TRUE)
	message = treat_message_accent_fullword(message, strings("accent_universal.json", "universal"))

	if(autopunct)
		message = autopunct_bare(message)
	if(do_trim)
		message = trim(message)

	return message

/*
	The emote version of the say escape brackets, working the other way around where it applies the
	speaker's accent ONLY to text inside "quotes" in a me/subtle emote and
	leaves the rest of the emote alone.
*/
/proc/accent_emote_quotes(message)
	// Stop early for messages with no quotes to handle.
	if(!message)
		return message
	if(!findtext(message, "\"") && !findtext(message, "&#34;") && !findtext(message, "&quot;"))
		return message

	// Built once. Matches an opening quote in any of its three forms
	var/static/regex/quote_regex = regex(@{"(&#34;|&quot;|")([\S\s\n]*?)(&#34;|&quot;|")"})
	var/search_pos = 1

	while(quote_regex.Find(message, search_pos))
		var/match_at = quote_regex.index
		var/match_len = length(quote_regex.match)
		var/open_quote = quote_regex.group[1]
		var/inner_text = quote_regex.group[2]
		var/close_quote = quote_regex.group[3]
		// Accent only the text inside the quotes.
		var/accented = apply_accent_pipeline(inner_text, autopunct = FALSE, do_trim = FALSE)
		// Keep the same quote marks that were matched, whichever form they arrived in.
		var/rebuilt = "[open_quote][accented][close_quote]"
		// Put the accented text (with its quotes) back into the message.
		message = copytext(message, 1, match_at) + rebuilt + copytext(message, match_at + match_len)

		// Move past what we just wrote so we don't scan it again.
		search_pos = match_at + length(rebuilt)
	return message

/datum/species/proc/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	speech_args[SPEECH_MESSAGE] = apply_accent_pipeline(message)

/proc/get_value_from_accent(key, list/accent_list)
	if (!key)
		return
	if (!accent_list)
		return
	var/value = accent_list[key]
	if (!value)
		value = accent_list[LOWER_TEXT(key)]
	if (!value)
		value = accent_list[uppertext(key)]
	if (!value)
		value = accent_list[capitalize(key)]
	return value

/*
	full word replacement proc for accents that only iterates through each word in the chat message instead of every entry in the json
	only applies the universal accent since that's the only one we have
*/
/proc/treat_message_accent_fullword(message, list/universal)
	if(!message)
		return
	if(!universal)
		return message
	if(message[1] == "*")
		return message
	message = "[message]"
	var/list/message_words = splittext_char(message, regex("\[^(&#39;|\\w)\]+"))
	for (var/key in message_words)
		var/value = get_value_from_accent(key, universal)
		if (!value)
			continue
		if (islist(value))
			value = pick(value)
		message = replacetextEx(message, regex("\\b[uppertext(key)]\\b|\\A[uppertext(key)]\\b|\\b[uppertext(key)]\\Z|\\A[uppertext(key)]\\Z", "(\\w+)/g"), uppertext(value))
		message = replacetextEx(message, regex("\\b[capitalize(key)]\\b|\\A[capitalize(key)]\\b|\\b[capitalize(key)]\\Z|\\A[capitalize(key)]\\Z", "(\\w+)/g"), capitalize(value))
		message = replacetextEx(message, regex("\\b[key]\\b|\\A[key]\\b|\\b[key]\\Z|\\A[key]\\Z", "(\\w+)/g"), value)
	return message

#undef REGEX_FULLWORD
#undef REGEX_STARTWORD
#undef REGEX_ENDWORD
#undef REGEX_ANY
