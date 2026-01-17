GLOBAL_LIST_EMPTY(mindlinks)

/datum/mindlink
	var/mob/living/owner
	var/mob/living/target
	var/active = TRUE

/datum/mindlink/New(mob/living/owner, mob/living/target)
	src.owner = owner
	src.target = target
	
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(target, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mindlink/Destroy()
	UnregisterSignal(owner, COMSIG_MOB_SAY)
	UnregisterSignal(target, COMSIG_MOB_SAY)
	owner = null
	target = null
	return ..()

/datum/mindlink/proc/handle_speech(mob/living/speaker, list/speech_args)
	SIGNAL_HANDLER
	
	var/message = speech_args[SPEECH_MESSAGE]
	if(!message)
		return
	
	// Check for the ,y prefix
	if(findtext(message, ",y", 1, 3))
		message = trim(copytext(message, 3))
		var/mob/living/recipient = (speaker == owner ? target : owner)
		
		to_chat(speaker, span_purple("You project your thoughts to [recipient]: \"[message]\""))
		to_chat(recipient, span_purple("[speaker] projects their thoughts to you: \"[message]\""))
		recipient.playsound_local(recipient, 'sound/magic/message.ogg', 100)
		speaker.log_talk(message, LOG_SAY, tag="mindlink (to [recipient])")
		
		speech_args[SPEECH_MESSAGE] = null // Prevent the normal speech from happening
