//Speech verbs.


//Because of how classic keys work, we need to use a custom verb to show the typing indicator. 
//Otherwise when you press enter, it will open up the input box.
/mob/verb/say_typing_indicator()
	set name = "say_indicator"
	set hidden = TRUE
	set category = "IC"
	
	display_typing_indicator()
	var/message = input(usr, "", "say") as text|null
	// If they don't type anything just drop the message.
	clear_typing_indicator()
	if(!length(message))
		return
	return say_verb(message)

/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"
	set hidden = 1

	if(!length(message))
		return
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, "<span class='danger'>Speech is currently admin-disabled.</span>")
		return
	clear_typing_indicator()		// clear it immediately!

	say(message)

///Whisper verb
/mob/verb/whisper_verb(message as text)
	set name = "Whisper"
	set category = "IC"
	set hidden = 1

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return
	whisper(message)

///whisper a message
/mob/proc/whisper(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	say(message, language) //only living mobs actually whisper, everything else just talks


/mob/verb/me_typing_indicator()
	set name = "me_indicator"
	set hidden = TRUE
	set category = "IC"

	display_typing_indicator()
	var/message = input(usr, "", "me") as text|null
	// If they don't type anything just drop the message.
	clear_typing_indicator()		// clear it immediately!
	if(!length(message))
		return
	return me_verb(message)

///The me emote verb
///The me emote verb
/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"
	set hidden = 1
#ifndef MATURESERVER
	return
#endif
	// If they don't type anything just drop the message.
	clear_typing_indicator()
	if(!length(message))
		return
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return
	message = trim(copytext_char(sanitize(message), 1, MAX_MESSAGE_LEN))
	message = parsemarkdown_basic(message, limited = TRUE, barebones = TRUE)
	if(check_subtler(message, FALSE))
		return
	usr.emote("me",1,message,TRUE, custom_me = TRUE)

/mob/verb/me_big_verb_indicator()
	set name = "me_big_indicator"
	set category = "IC"
	set hidden = 1

	display_typing_indicator()
	var/message = input(usr, "", "me") as message|null
	// If they don't type anything just drop the message.
	clear_typing_indicator()
	if(!length(message))
		return
	return me_big_verb(message)

///The me emote verb
/mob/verb/me_big_verb(message as message)
	set name = "Me(big)"
	set category = "IC"
	set hidden = 1
#ifndef MATURESERVER
	return
#endif
	// If they don't type anything just drop the message.
	clear_typing_indicator()
	if(!length(message))
		return
	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return
	message = trim(copytext_char(html_encode(message), 1, MAX_MESSAGE_BIGME))
	message = parsemarkdown_basic(message, limited = TRUE, barebones = TRUE)
	if(check_subtler(message, FALSE))
		return
	usr.emote("me",1,message,TRUE, custom_me = TRUE)

///Speak as a dead person (ghost etc)
/mob/proc/say_dead(message)

	return // RTCHANGE

///Check if this message is an emote
/mob/proc/check_emote(message, forced)
	if(copytext_char(message, 1, 2) == "*")
		emote(copytext_char(message, 2), intentional = !forced, custom_me = TRUE)
		return 1

/mob/proc/check_whisper(message, forced)
	if(copytext_char(message, 1, 2) == "+")
		var/text = copytext(message, 2)
		var/boldcheck = findtext_char(text, "+")	//Check for a *second* + in the text, implying the message is meant to have something formatted as bold (+text+)
		if (boldcheck != 0)
			return 0
		whisper(copytext_char(message, boldcheck ? 1 : 2),sanitize = FALSE)//already sani'd
		return 1

///Check if the mob has a hivemind channel
/mob/proc/hivecheck()
	return 0

///Check if the mob has a ling hivemind
/mob/proc/lingcheck()
	return LINGHIVE_NONE

/**
  * Get the mode of a message
  *
  * Result can be
  * * MODE_WHISPER (Quiet speech)
  * * MODE_HEADSET (Common radio channel)
  * * A department radio (lots of values here)
  */
/mob/proc/get_message_mode(message)
	var/key = copytext_char(message, 1, 2)
	if(key == "#")
		return MODE_WHISPER
	else if(key == ";")
		return MODE_HEADSET
	else if(key == "%")
		return MODE_SING
	else if(length(message) > 2 && (key in GLOB.department_radio_prefixes))
		var/key_symbol = lowertext(copytext_char(message, 2, 3))
		return GLOB.department_radio_keys[key_symbol]
