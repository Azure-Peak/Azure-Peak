/*
	Miauw's big Say() rewrite.
	This file has the basic atom/movable level speech procs.
	And the base of the send_speech() proc, which is the core of saycode.
*/
GLOBAL_LIST_INIT(freqtospan, list(
	"[FREQ_SCIENCE]" = "sciradio",
	"[FREQ_MEDICAL]" = "medradio",
	"[FREQ_ENGINEERING]" = "engradio",
	"[FREQ_SUPPLY]" = "suppradio",
	"[FREQ_SERVICE]" = "servradio",
	"[FREQ_SECURITY]" = "secradio",
	"[FREQ_COMMAND]" = "comradio",
	"[FREQ_AI_PRIVATE]" = "aiprivradio",
	"[FREQ_SYNDICATE]" = "syndradio",
	"[FREQ_CENTCOM]" = "centcomradio",
	"[FREQ_CTF_RED]" = "redteamradio",
	"[FREQ_CTF_BLUE]" = "blueteamradio"
	))

/atom/movable/proc/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null, message_range = 7, message_mode = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	send_speech(message, message_range, src, , spans, message_language=language, message_mode = message_mode)

/atom/movable/proc/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	SEND_SIGNAL(src, COMSIG_MOVABLE_HEAR, args)

/atom/movable/proc/can_speak()
	return TRUE

/atom/movable/proc/send_speech(message, range = 7, obj/source = src, bubble_type, list/spans, datum/language/message_language = null, message_mode)
	var/rendered = compose_message(src, message_language, message, , spans, message_mode)
	for(var/atom/movable/hearing_movable as anything in get_hearers_in_view(range, source))
		if(!hearing_movable) // Should not get nulls, but just in case.
			stack_trace("somehow theres a null returned from get_hearers_in_view() in send_speech!")
			continue

		hearing_movable.Hear(rendered, src, message_language, message, , spans, message_mode)

/atom/movable/proc/compose_message(atom/movable/speaker, datum/language/message_language, raw_message, radio_freq, list/spans, message_mode, face_name = FALSE)
	//This proc uses text() because it is faster than appending strings. Thanks BYOND.
	//Basic span
	var/spanpart1 = "<span class='[radio_freq ? get_radio_span(radio_freq) : "say"]'>"
	//Start name span.
	var/spanpart2 = "<span class='name'>"
	//Radio freq/name display
	var/freqpart = radio_freq ? "\[[get_radio_name(radio_freq)]\] " : ""
	//Speaker name
	var/namepart = "[speaker.GetVoice()]"
	if(speaker.get_alt_name())
		namepart = "[speaker.get_alt_name()]"
	var/colorpart = "<span style='text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>"
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		if(face_name)
			namepart = "[H.get_face_name()]" //So "fake" speaking like in hallucinations does not give the speaker away if disguised
		if(H.voice_color)
			colorpart = "<span style='color:#[H.voice_color];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>"
	if(speaker.voicecolor_override)
		colorpart = "<span style='color:#[speaker.voicecolor_override];text-shadow:-1px -1px 0 #000,1px -1px 0 #000,-1px 1px 0 #000,1px 1px 0 #000;'>"
	//End name span.
	var/endspanpart = "</span></span>"

	var/list/processed_spans = handle_language_spans(length(spans) ? spans.Copy() : null)

	//Message
	var/messagepart = " <span class='message'>[lang_treat(speaker, message_language, raw_message, processed_spans, message_mode)]</span></span>"

	var/arrowpart = ""

	if(istype(src,/mob/living))
		var/atom/movable/tocheck = src
		// Check relay instead.
		if(isdullahan(src))
			var/mob/living/carbon/human = src
			var/datum/species/dullahan/dullahan = human.dna.species
			if(dullahan.headless)
				tocheck = dullahan.my_head
		var/turf/speakturf = get_turf(speaker)
		var/turf/sourceturf = get_turf(tocheck)
		if(istype(speakturf) && istype(sourceturf) && !(speakturf in get_hear(7, sourceturf)))
			switch(get_dir(src,speaker))
				if(NORTH)
					arrowpart = " ⇑"
				if(SOUTH)
					arrowpart = " ⇓"
				if(EAST)
					arrowpart = " ⇒"
				if(WEST)
					arrowpart = " ⇐"
				if(NORTHWEST)
					arrowpart = " ⇖"
				if(NORTHEAST)
					arrowpart = " ⇗"
				if(SOUTHWEST)
					arrowpart = " ⇙"
				if(SOUTHEAST)
					arrowpart = " ⇘"
			if(speakturf.z > sourceturf.z)
				arrowpart += " ⇈"
			if(speakturf.z < sourceturf.z)
				arrowpart += " ⇊"

			var/hidden = TRUE
			if(HAS_TRAIT(src, TRAIT_KEENEARS))
				if(ishuman(speaker) && ishuman(src))
					var/mob/living/carbon/human/HS = speaker
					var/mob/living/carbon/human/HL = src
					if(length(HL.mind?.known_people))
						if(HS.real_name in HL.mind?.known_people)	//We won't recognise people we don't know w/ Keen Ears
							hidden = FALSE
					else
						hidden = TRUE
				else
					hidden = FALSE
			else
				hidden = TRUE
			if(hidden)
				if(ishuman(speaker))
					var/mob/living/carbon/human/human = speaker
					namepart = human.get_alt_name(TRUE)
				else if(isliving(speaker))
					var/mob/living/L = speaker
					namepart = "Unknown [(L.gender == FEMALE) ? "Woman" : "Man"]"
				else
					namepart = "Unknown"
			spanpart1 = "<span class='smallyell'>"

	var/languageicon = ""
	if(message_language && show_language_icon())
		var/datum/language/D = GLOB.language_datum_instances[message_language]
		if(istype(D) && D.display_icon(src))
			languageicon = SPAN_TOOLTIP_DANGEROUS_HTML("<b>[D.name]</b>[D.desc ? "<br>" + D.desc : ""]", "<span style=\"position: relative; bottom: 4px;\">[D.get_icon()] </span>")

	return "[spanpart1][spanpart2][colorpart][freqpart][languageicon][compose_track_href(speaker, namepart)][namepart][compose_job(speaker, message_language, raw_message, radio_freq)][arrowpart][endspanpart][messagepart]"

/atom/movable/proc/handle_language_spans(list/spans)
	return spans

/mob/handle_language_spans(list/spans)
	if(client?.prefs?.no_language_fonts)
		for(var/language_span in LANGUAGE_SPANS)
			spans -= language_span
	return spans

/atom/movable/proc/show_language_icon()
	return TRUE

/mob/show_language_icon(list/spans)
	if(client?.prefs?.no_language_icon)
		return FALSE
	return TRUE

/atom/movable/proc/show_redflash()
	return TRUE

/mob/show_redflash()
	if(client?.prefs?.no_redflash)
		return FALSE
	return TRUE

/atom/movable/proc/compose_track_href(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/compose_job(atom/movable/speaker, message_langs, raw_message, radio_freq)
	return ""

/atom/movable/proc/say_mod(input, message_mode)
	var/ending = copytext(input, length(input))
	if(copytext(input, length(input) - 1) == "!!")
		return verb_yell
	else if(ending == "?")
		return verb_ask
	else if(ending == "!")
		return verb_exclaim
	else
		return verb_say

/atom/movable/proc/say_quote(input, list/spans=list(speech_span), message_mode)
	if(!input)
		input = "..."

	if(copytext(input, length(input) - 1) == "!!")
		spans |= SPAN_YELL

	input = parsemarkdown_basic(input, limited = TRUE, barebones = TRUE)
	var/spanned = attach_spans(input, spans)
	if(isliving(src))
		var/mob/living/L = src
		if(L.cmode)
			return "— \"[spanned]\""
	return "[say_mod(input, message_mode)], \"[spanned]\""

/atom/movable/proc/quoteless_say_quote(input, list/spans = list(speech_span), message_mode)
	input = parsemarkdown_basic(input, limited = TRUE, barebones = TRUE)
	var/pos = findtext(input, "*")
	return pos? copytext(input, pos + 1) : input

/atom/movable/proc/check_language_hear(language)
	return FALSE

/atom/movable/proc/lang_treat(atom/movable/speaker, datum/language/language, raw_message, list/spans, message_mode, no_quote = FALSE)
	if(has_language(language) || check_language_hear(language))
		var/atom/movable/AM = speaker.GetSource()
		if(AM) //Basically means "if the speaker is virtual"
			return no_quote ? AM.quoteless_say_quote(raw_message, spans, message_mode) : AM.say_quote(raw_message, spans, message_mode)
		else
			return no_quote ? speaker.quoteless_say_quote(raw_message, spans, message_mode) : speaker.say_quote(raw_message, spans, message_mode)
	else if(language)
		var/atom/movable/AM = speaker.GetSource()
		var/datum/language/D = GLOB.language_datum_instances[language]
		raw_message = D.scramble(raw_message)
		if(AM)
			return no_quote ? AM.quoteless_say_quote(raw_message, spans, message_mode) : AM.say_quote(raw_message, spans, message_mode)
		else
			return no_quote ? speaker.quoteless_say_quote(raw_message, spans, message_mode) : speaker.say_quote(raw_message, spans, message_mode)
	else
		return "makes a strange sound."

/proc/get_radio_span(freq)
	var/returntext = GLOB.freqtospan["[freq]"]
	if(returntext)
		return returntext
	return "radio"

/proc/get_radio_name(freq)
	return freq
/* 	var/returntext = GLOB.reverseradiochannels["[freq]"]
	if(returntext)
		return returntext
	return "[copytext("[freq]", 1, 4)].[copytext("[freq]", 4, 5)]" */

/proc/attach_spans(input, list/spans)
	return "[message_spans_start(spans)][input]</span>"

/proc/message_spans_start(list/spans)
	var/output = "<span class='"
	for(var/S in spans)
		output = "[output][S] "
	output = "[output]'>"
	return output

/proc/say_test(text)
	if(copytext(text, length(text) - 1) == "!!")
		return "3"
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "1"
	if (ending == "!")
		return "2"
	return "0"

/atom/movable/proc/GetVoice()
	return "[src]"	//Returns the atom's name, prepended with 'The' if it's not a proper noun

/atom/movable/proc/IsVocal()
	return 1

/atom/movable/proc/get_alt_name()

//HACKY VIRTUALSPEAKER STUFF BEYOND THIS POINT
//these exist mostly to deal with the AIs hrefs and job stuff.

/atom/movable/proc/GetJob() //Get a job, you lazy butte

/atom/movable/proc/GetSource()

/atom/movable/proc/GetRadio()

//VIRTUALSPEAKERS
/atom/movable/virtualspeaker
	var/job
	var/atom/movable/source
	var/obj/item/radio/radio

INITIALIZE_IMMEDIATE(/atom/movable/virtualspeaker)
/atom/movable/virtualspeaker/Initialize(mapload, atom/movable/M, radio)
	. = ..()
	radio = radio
	source = M
	if (istype(M))
		name = M.GetVoice()
		verb_say = M.verb_say
		verb_ask = M.verb_ask
		verb_exclaim = M.verb_exclaim
		verb_yell = M.verb_yell

	// The mob's job identity
	if(ishuman(M))
		// Humans use their job as seen on the crew manifest. This is so the AI
		// can know their job even if they don't carry an ID.
		var/datum/data/record/findjob = find_record("name", name, GLOB.data_core.general)
		if(findjob)
			job = findjob.fields["rank"]
		else
			job = "Unknown"
	else if(iscarbon(M))  // Carbon nonhuman
		job = "No ID"
	else if(isobj(M))  // Cold, emotionless machines
		job = "Machine"
	else  // Unidentifiable mob
		job = "Unknown"

/atom/movable/virtualspeaker/GetJob()
	return job

/atom/movable/virtualspeaker/GetSource()
	return source
