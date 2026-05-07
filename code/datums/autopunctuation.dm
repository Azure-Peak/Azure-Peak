GLOBAL_LIST_INIT(autopunctuation_formatting_chars, list("+" = TRUE, "|" = TRUE, "_" = TRUE))
GLOBAL_LIST_INIT(autopunctuation_ending_chars, list("." = TRUE, "!" = TRUE, "?" = TRUE, "-" = TRUE, "~" = TRUE, "," = TRUE, ":" = TRUE, ";" = TRUE, "\"" = TRUE, "'" = TRUE))

//All non-capitalized 'i' surrounded with whitespace (aka, 'hello >i< am a cat')
GLOBAL_DATUM_INIT(noncapital_i, /regex, regex(@"\b[i]\b", "g"))

/// Ensures sentences end in appropriate punctuation (a period if none exist) and that all whitespace-bounded 'i' characters are capitalized.
/// If the sentence ends in chat-flavored markdown for bolds, italics or underscores and does not have a preceding period, exclamation mark or other flavored sentence terminator, add a period.
/// (e.g: 'Borgs are rogue' becomes 'Borgs are rogue.', '+BORGS ARE ROGUE+ becomes '+BORGS ARE ROGUE+.', '+Borgs are rogue~+' is untouched.)
/proc/autopunct_bare(input_text)
	var/final_text_char
	for(var/index = length(input_text), index > 0, index--)
		var/current_char = copytext(input_text, index, index + 1)
		if(current_char == " ")
			continue
		if(GLOB.autopunctuation_formatting_chars[current_char])
			continue
		final_text_char = current_char
		break

	if(final_text_char && !GLOB.autopunctuation_ending_chars[final_text_char])
		input_text += "."

	input_text = replacetext(input_text, GLOB.noncapital_i, "I")
	return input_text
