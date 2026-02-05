// MATTHIAN SCOMCOIN

/obj/item/mattcoin
	name = "rontz ring"
	icon_state = "mattcoin"
	desc = "A faded coin with a ruby laid into its center."
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP|ITEM_SLOT_NECK|ITEM_SLOT_RING
	obj_flags = null
	icon = 'icons/roguetown/items/misc.dmi'
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	muteinmouth = TRUE
	var/listening = TRUE
	var/speaking = TRUE
	sellprice = 0
	grid_width = 32
	grid_height = 32

/obj/item/mattcoin/Initialize()
	. = ..()
	become_hearing_sensitive()
	update_icon()
	SSroguemachine.scomm_machines += src
	name = pick("rontz ring", "gold ring")

/obj/item/mattcoin/pickup(mob/living/user)
	if(!HAS_TRAIT(user, TRAIT_COMMIE))
		to_chat(user, "The coin turns to ash in my hands!")
		playsound(loc, 'sound/items/firesnuff.ogg', 100, FALSE, -1)
		qdel(src)
	..()

/obj/item/mattcoin/doStrip(mob/stripper, mob/owner)
	if(!(stripper?.mind.has_antag_datum(/datum/antagonist/bandit))) //You're not a bandit, you can't strip the bandit coin
		to_chat(stripper, "[src] turns to ash in my hands!")
		playsound(stripper.loc, 'sound/items/firesnuff.ogg', 100, FALSE, -1)
		qdel(src)
		return FALSE
	. = ..()

/obj/item/mattcoin/attack_right(mob/living/carbon/human/user)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	var/input_text = input(user, "Enter your message:", "Message")
	if(input_text)
		var/usedcolor = user.voice_color
		if(user.voicecolor_override)
			usedcolor = user.voicecolor_override
		user.whisper(input_text)
		if(length(input_text) > 100)
			input_text = "<small>[input_text]</small>"
		for(var/obj/item/mattcoin/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src, usedcolor)

/obj/item/mattcoin/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/coindispense.ogg', 100, FALSE, -1)
	listening = !listening
	speaking = !speaking
	to_chat(user, span_info("I [speaking ? "unmute" : "mute"] the Matthian-SCOMstone"))
	update_icon()

/obj/item/mattcoin/Destroy()
	lose_hearing_sensitivity()
	SSroguemachine.scomm_machines -= src
	return ..()

/obj/item/mattcoin/proc/repeat_message(message, atom/A, tcolor, message_language)
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, 'sound/foley/coins1.ogg', 20, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null


/obj/item/mattcoin/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
	if(!can_speak())
		return
	if(message == "" || !message)
		return
	spans |= speech_span
	if(!language)
		language = get_default_language()
	if(istype(loc, /obj/item))
		var/obj/item/I = loc
		I.send_speech(message, 0, I, , spans, message_language=language)
	else
		send_speech(message, 0, src, , spans, message_language=language)
