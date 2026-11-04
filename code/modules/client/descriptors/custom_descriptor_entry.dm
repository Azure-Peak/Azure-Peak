/datum/custom_descriptor_entry
	var/prefix_type = CUSTOM_PREFIX_HAS_A
	var/content_text = "feature"


/// Cleans user-entered descriptor text. Keeps the player's capitalization, but strips HTML,
/// surrounding whitespace and trailing punctuation so the examine sentence still ends cleanly.
/proc/sanitize_custom_descriptor_text(text)
	text = trim(STRIP_HTML_SIMPLE("[text]", PREVENT_CHARACTER_TRIM_LOSS(CUSTOM_DESCRIPTOR_TEXT_LENGTH)))
	while(length(text) && (copytext(text, length(text)) in list(".", ",", ";", ":", "!", "?")))
		text = trim_right(copytext(text, 1, length(text)))
	return text
