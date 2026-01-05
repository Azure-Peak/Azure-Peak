#define GARRISON_CROWN_COLOR "#C2A245"

/obj/item/clothing/head/roguetown/crown/serpcrown
	name = "Crown of Azuria"
	article = "the"
	desc = "Heavy is the head that wears this."
	icon_state = "serpcrown"
	//dropshrink = 0
	dynamic_hair_suffix = null
	sellprice = 200
	resistance_flags = FIRE_PROOF | ACID_PROOF
	anvilrepair = /datum/skill/craft/armorsmithing
	visual_replacement = /obj/item/clothing/head/roguetown/crown/fakecrown
	var/listening = TRUE
	var/speaking = TRUE
	var/loudmouth_listening = TRUE
	var/garrisonline = TRUE
	var/messagereceivedsound = 'sound/misc/scom.ogg'
	var/hearrange = 0 // Only hearable by wearer
	is_important = TRUE

/obj/item/clothing/head/roguetown/crown/serpcrown/Initialize()
	. = ..()
	if(SSroguemachine.crown)
		qdel(src)
	else
		SSroguemachine.crown = src
		SSroguemachine.scomm_machines += src
	become_hearing_sensitive()

/obj/item/clothing/head/roguetown/crown/serpcrown/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_HEAD)
		ADD_TRAIT(user, TRAIT_GARRISON_ITEM, "[ref(src)]")

/obj/item/clothing/head/roguetown/crown/serpcrown/dropped(mob/living/user)
	..()
	REMOVE_TRAIT(user, TRAIT_GARRISON_ITEM, "[ref(src)]")

/obj/item/clothing/head/roguetown/crown/serpcrown/proc/anti_stall()
	src.visible_message(span_danger("The Crown of Azuria crumbles to dust, the ashes spiriting away in the direction of the Keep."))
	SSroguemachine.scomm_machines -= src
	SSroguemachine.crown = null //Do not harddel.
	qdel(src) //Anti-stall

/obj/item/clothing/head/roguetown/crown/serpcrown/attack_right(mob/living/carbon/human/user)
	user.changeNext_move(CLICK_CD_MELEE)
	visible_message(span_notice ("[user] presses their hands against their crown."))
	var/input_text = input(user, "Enter your ducal message:", "Crown SCOM")
	if(input_text)
		var/usedcolor = user.voice_color
		if(user.voicecolor_override)
			usedcolor = user.voicecolor_override
		user.whisper(input_text)
		if(length(input_text) > 100)
			input_text = "<small>[input_text]</small>"
		if(!garrisonline)
			for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
				S.repeat_message(input_text, src, usedcolor)
			for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
				S.repeat_message(input_text, src, usedcolor)
			for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines)
				S.repeat_message(input_text, src, usedcolor)
			SSroguemachine.crown?.repeat_message(input_text, src, usedcolor)

			GLOB.broadcast_list += list(list(
			"message"   = input_text,
			"tag"		= "The Crown of Azuria",
			"timestamp" = station_time_timestamp("hh:mm:ss")
			))

		if(garrisonline)
			input_text = "<big><span style='color: [GARRISON_CROWN_COLOR]'>[input_text]</span></big>" // Prettying up for Garrison line
			for(var/obj/item/scomstone/bad/garrison/S in SSroguemachine.scomm_machines)
				S.repeat_message(input_text, src, usedcolor)
			for(var/obj/item/scomstone/garrison/S in SSroguemachine.scomm_machines)
				S.repeat_message(input_text, src, usedcolor)
			for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
				if(S.garrisonline)
					S.repeat_message(input_text, src, usedcolor)
			SSroguemachine.crown?.repeat_message(input_text, src, usedcolor)

/obj/item/clothing/head/roguetown/crown/serpcrown/attack_self(mob/living/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	garrisonline = !garrisonline
	to_chat(user, span_info("I [garrisonline ? "connect the crown to the garrison SCOMline" : "connect the crown to the general SCOMline"]"))

/obj/item/clothing/head/roguetown/crown/serpcrown/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(loudmouth_listening)
		to_chat(user, span_info("I quell the Loudmouth's prattling on the scomstone. It may be muted entirely still."))
		loudmouth_listening = FALSE
	else
		listening = !listening
		speaking = !speaking
		to_chat(user, span_info("I [speaking ? "unmute" : "mute"] the crown's SCOM capabilities."))
		if(listening)
			loudmouth_listening = TRUE
	update_icon()

/obj/item/clothing/head/roguetown/crown/serpcrown/proc/repeat_message(message, atom/A, tcolor, message_language)
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, messagereceivedsound, 100, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null

/obj/item/clothing/head/roguetown/crown/serpcrown/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	if(istype(loc, /obj/item))
		var/obj/item/I = loc
		I.send_speech(message, hearrange, I, , spans, message_language=language)
	else
		send_speech(message, hearrange, src, , spans, message_language=language)

/obj/item/clothing/head/roguetown/crown/serpcrown/Destroy()
	lose_hearing_sensitivity()
	return ..()


#undef GARRISON_CROWN_COLOR
