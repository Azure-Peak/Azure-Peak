//SCOMSTONE                 SCOMSTONE

/obj/item/scomstone
	name = "scomstone"
	icon_state = "ring_scom"
	desc = "A heavy ring made of metal. There is a gem embedded in the center - dim, but alive."
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
	var/cooldown = 60 SECONDS
	var/on_cooldown = FALSE
	var/listening = TRUE
	var/speaking = TRUE
	var/loudmouth_listening = TRUE
	var/messagereceivedsound = 'sound/misc/scom.ogg'
	var/scomstone_number
	var/hearrange = 1 // change to 0 if you want your special scomstone to be only hearable by wearer
	drop_sound = 'sound/foley/coinphy (1).ogg'
	sellprice = 100
	grid_width = 32
	grid_height = 32

/obj/item/scomstone/attack_right(mob/living/carbon/human/user)
	if(on_cooldown)
		to_chat(user, span_warning("The gemstone inside the ring radiates heat. It's still cooling down from its last use."))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	visible_message(span_notice ("[user] presses their ring against their mouth."))
	var/input_text = input(user, "Enter your message:", "Message")
	if(!input_text)
		return
	var/usedcolor = user.voice_color
	if(user.voicecolor_override)
		usedcolor = user.voicecolor_override
	user.whisper(input_text)
	if(length(input_text) > 100) //When these people talk too much, put that shit in slow motion, yeah
		input_text = "<small>[input_text]</small>"
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor)
	for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor)
	for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines) //make the listenstone hear scomstone
		S.repeat_message(input_text, src, usedcolor)
	SSroguemachine.crown?.repeat_message(input_text, src, usedcolor)
	on_cooldown = TRUE
	addtimer(CALLBACK(src, PROC_REF(reset_cooldown), user), cooldown)

	//Log message to global broadcast list.
	GLOB.broadcast_list += list(list(
	"message"   = input_text,
	"tag"		= "SCOMSTONE #[scomstone_number]",
	"timestamp" = station_time_timestamp("hh:mm:ss")
	))

/obj/item/scomstone/proc/reset_cooldown(mob/living/carbon/human/user)
	to_chat(user, span_notice("[src] is ready for use again."))
	playsound(loc, 'sound/misc/machineyes.ogg', 100, FALSE, -1)
	on_cooldown = FALSE

/obj/item/scomstone/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(loudmouth_listening)
		to_chat(user, span_info("I quell the Loudmouth's prattling on the scomstone. It may be muted entirely still."))
		loudmouth_listening = FALSE
	else
		listening = !listening
		speaking = !speaking
		to_chat(user, span_info("I [speaking ? "unmute" : "mute"] the scomstone."))
		if(listening)
			loudmouth_listening = TRUE
		update_icon()

/obj/item/scomstone/Destroy()
	SSroguemachine.scomm_machines -= src
	lose_hearing_sensitivity()
	return ..()

/obj/item/scomstone/Initialize()
	. = ..()
	become_hearing_sensitive()
	update_icon()
	SSroguemachine.scomm_machines += src
	scomstone_number = SSroguemachine.scomm_machines.len

/obj/item/scomstone/examine(mob/user)
	. = ..()
	if(scomstone_number)
		. += "Its designation is #[scomstone_number]."

/obj/item/scomstone/proc/repeat_message(message, atom/A, tcolor, message_language)
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, messagereceivedsound, 100, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null


/obj/item/scomstone/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
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

/obj/item/scomstone/bad
	name = "serfstone"
	desc = "A rusty shoddily-made metal ring. The gem embedded within is barely holding on."
	icon_state = "ring_serfscom"
	listening = FALSE
	sellprice = 20

/obj/item/scomstone/bad/attack_right(mob/user)
	return

// garrison scoms/listenstones

/obj/item/scomstone/garrison
	name = "crownstone"
	icon_state = "ring_crownscom"
	desc = "A lavish golden ring with the mark of the Crown. Heavy and garish. The gem embedded flickering in excitement."
	var/garrisonline = TRUE
	messagereceivedsound = 'sound/misc/garrisonscom.ogg'
	hearrange = 0
	sellprice = 100

/obj/item/scomstone/garrison/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_RING)
		ADD_TRAIT(user, TRAIT_GARRISON_ITEM, "[ref(src)]")

/obj/item/scomstone/garrison/dropped(mob/living/user)
	..()
	REMOVE_TRAIT(user, TRAIT_GARRISON_ITEM, "[ref(src)]")

/obj/item/scomstone/garrison/attack_right(mob/living/carbon/human/user)
	user.changeNext_move(CLICK_CD_INTENTCAP)
	if(on_cooldown)
		to_chat(user, span_warning("The gemstone inside the ring radiates heat. It's still cooling down from its last use."))
		playsound(loc, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	if(!get_location_accessible(user, BODY_ZONE_PRECISE_MOUTH, grabs = TRUE))
		to_chat(user, span_warning("My mouth is covered!"))
		return
	visible_message(span_notice ("[user] presses their ring against their mouth."))
	var/input_text = input(user, "Enter your message:", "Message")
	if(!input_text)
		return
	var/usedcolor = user.voice_color
	if(user.voicecolor_override)
		usedcolor = user.voicecolor_override
	user.whisper(input_text)
	if(length(input_text) > 100) //When these people talk too much, put that shit in slow motion, yeah
		input_text = "<small>[input_text]</small>"
	playsound(loc, 'sound/misc/garrisonscom.ogg', 100, FALSE, -1)
	if(garrisonline)
		input_text = "<big><span style='color: [GARRISON_SCOM_COLOR]'>[input_text]</span></big>" //Prettying up for Garrison line
		for(var/obj/item/scomstone/bad/garrison/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src, usedcolor)
		for(var/obj/item/scomstone/garrison/S in SSroguemachine.scomm_machines)
			S.repeat_message(input_text, src, usedcolor)
		for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
			if(S.garrisonline)
				S.repeat_message(input_text, src, usedcolor)
		SSroguemachine.crown?.repeat_message(input_text, src, usedcolor)
		on_cooldown = TRUE
		addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), cooldown)
		return
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor)
	for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor)
	for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(input_text, src, usedcolor)
	SSroguemachine.crown?.repeat_message(input_text, src, usedcolor)
	on_cooldown = TRUE

	//Log messages that aren't sent on the garrison line.
	GLOB.broadcast_list += list(list(
	"message"   = input_text,
	"tag"		= "CROWNSTONE #[scomstone_number]",
	"timestamp" = station_time_timestamp("hh:mm:ss")
	))

	addtimer(CALLBACK(src, PROC_REF(reset_cooldown)), cooldown)

/obj/item/scomstone/garrison/attack_self(mob/living/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	garrisonline = !garrisonline
	to_chat(user, span_info("I [garrisonline ? "connect to the garrison SCOMline" : "connect to the general SCOMline"]"))
	update_icon()

/obj/item/scomstone/garrison/update_icon()
	icon_state = "[initial(icon_state)][garrisonline ? "_on" : ""]"

/obj/item/scomstone/bad/garrison
	name = "houndstone"
	desc = "A basic metal ring. It has a well-cut, dismal gem embedded - bearing the mark of the Crown."
	icon_state = "ring_houndscom"
	listening = FALSE
	sellprice = 20
	messagereceivedsound = 'sound/misc/garrisonscom.ogg'
	hearrange = 0

/obj/item/scomstone/bad/garrison/equipped(mob/living/user, slot)
	. = ..()
	if(slot == SLOT_RING)
		ADD_TRAIT(user, TRAIT_GARRISON_ITEM, "[ref(src)]")

/obj/item/scomstone/bad/garrison/dropped(mob/living/user)
	..()
	REMOVE_TRAIT(user, TRAIT_GARRISON_ITEM, "[ref(src)]")
