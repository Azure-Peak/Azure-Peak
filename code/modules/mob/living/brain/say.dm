/mob/living/brain/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	return

/mob/living/brain/radio(message, message_mode, list/spans, language)
	return ..()

/mob/living/brain/lingcheck()
	return LINGHIVE_NONE

/mob/living/brain/treat_message(message, language, capitalize_message = TRUE)
	if(capitalize_message)
		message = capitalize(message)
	return message
