/datum/mindlink/coven
	var/list/mob/living/members = list()

/datum/mindlink/coven/New(list/mob/living/new_members)
	src.members = new_members
	for(var/mob/living/M in members)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mindlink/coven/Destroy()
	for(var/mob/living/M in members)
		UnregisterSignal(M, COMSIG_MOB_SAY)
	members.Cut()
	return ..()

/datum/mindlink/coven/handle_speech(mob/living/speaker, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(!message || !active) return

	// Break logic
	if(findtext(message, ",mst", 1, 5))
		to_chat(members, span_notice("The coven web is severed by [speaker]."))
		speech_args[SPEECH_MESSAGE] = null
		qdel(src)
		return

	// Speech logic
	if(findtext(message, ",y", 1, 3))
		message = trim(copytext(message, 3))
		message = span_centcomradio("[message]")
		var/formatted = "The voice of [speaker] echoes, \"<i>[capitalize(message)]</i>\"."
		
		for(var/mob/living/M in members)
			// Slightly more secretive!
			M.playsound_local(M, 'sound/magic/mindlink.ogg', 75, TRUE)
			if(M == speaker) continue
			M.audible_message(formatted, runechat_message = message, custom_spans = list("mindlink", "italic"))
		
		speaker.log_talk(message, LOG_SAY, tag="Coven Link")
		speech_args[SPEECH_MESSAGE] = null
