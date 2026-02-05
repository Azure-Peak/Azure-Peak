#define NORMAL_SCOM_TRANSMISSION_DELAY 15 SECONDS
#define NORMAL_SCOM_PER_MESSAGE_DELAY 15 SECONDS
#define CHEESE_QUIET_TIME 2 MINUTES // How long stuffing a slice of cheese in quieten the SCOM

/obj/structure/roguemachine/scomm
	name = "SCOM"
	desc = "The Supernatural Communication Optical Machine is a wonder of magic and technology, able to transmit and receive messages across long distance. There's a button in the MIDDLE for making private jabberline connections."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "scomm1"
	density = FALSE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	pixel_y = 32
	anchored = TRUE
	verb_say = "squeaks"
	var/next_decree = 0
	var/listening = TRUE
	var/speaking = TRUE
	var/loudmouth_listening = TRUE
	var/dictating = FALSE
	var/scom_number
	var/scom_tag
	var/obj/structure/roguemachine/scomm/calling = null
	var/obj/structure/roguemachine/scomm/called_by = null
	/// Last time the SCOM sent a message. Used to check delay
	var/last_message = 0
	/// Whether this is a receive only SCOM, that cannot transmit any messages. Uses this for any kind of SCOM that is out of town and is not actionable
	var/receive_only = FALSE
	var/spawned_rat = FALSE
	var/garrisonline = FALSE
	/// Track whether it was cheesed recently
	var/last_cheese = 0

/obj/structure/roguemachine/scomm/OnCrafted(dirin, mob/user)
	. = ..()
	loc = user.loc
	pixel_y = 0
	switch(dirin)
		if(NORTH)
			pixel_y = 32
		if(SOUTH)
			pixel_y = -32
		if(EAST)
			pixel_x = 32
		if(WEST)
			pixel_x = -32

/obj/structure/roguemachine/scomm/r
	pixel_y = 0
	pixel_x = 32

/obj/structure/roguemachine/scomm/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/roguemachine/scomm/receive_only
	name = "RCOM"
	desc = "The Receiving Communication Optical Machine is a much cheaper, ubiquitous version of the SCOM, designed only to receive message over long distance. They are oft found outside of the town, especially in older ruins."
	receive_only = TRUE

/obj/structure/roguemachine/scomm/receive_only/r
	pixel_y = 0
	pixel_x = 32

/obj/structure/roguemachine/scomm/receive_only/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/roguemachine/scomm/examine(mob/user)
	. = ..()
	. += span_small("The normal line has a delay of [NORMAL_SCOM_TRANSMISSION_DELAY / 10] seconds. The premium garrison line does not suffer from this limitation.")
	. += span_smallnotice("You see some rats inside scurrying about! Maybe they'd like a slice of cheese?")
	if(scom_number)
		. += span_smallnotice("Its designation is #[scom_number][scom_tag ? ", labeled as [scom_tag]" : ""].")
	. += "<a href='?src=[REF(src)];directory=1'>Directory</a>"
	. += "<b>THE LAWS OF THE LAND:</b>"
	if(!length(GLOB.laws_of_the_land))
		. += span_danger("The land has no laws! <b>We are doomed!</b>")
		return
	if(!user.is_literate())
		. += span_warning("Uhhh... I can't read them...")
		return
	for(var/i in 1 to length(GLOB.laws_of_the_land))
		. += span_small("[i]. [GLOB.laws_of_the_land[i]]")

/obj/structure/roguemachine/scomm/Topic(href, href_list)
	..()

	if(!usr)
		return

	if(href_list["directory"])
		view_directory(usr)

/obj/structure/roguemachine/scomm/proc/view_directory(mob/user)
	var/dat
	for(var/obj/structure/roguemachine/scomm/X in SSroguemachine.scomm_machines)
		dat += "#[X.scom_number] [X.scom_tag]<br>"

	var/datum/browser/popup = new(user, "scom_directory", "<center>RAT REGISTER</center>", 387, 420)
	popup.set_content(dat)
	popup.open(FALSE)

/obj/structure/roguemachine/scomm/process()
	if(world.time <= next_decree)
		return
	next_decree = world.time + rand(3 MINUTES, 8 MINUTES)
	if(!GLOB.lord_decrees.len)
		return
	if(!speaking)
		return
	say("The [SSticker.rulertype] Decrees: [pick(GLOB.lord_decrees)]", spans = list("info"))

/obj/structure/roguemachine/scomm/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(called_by && !calling)
		calling = called_by
		calling.say("Jabberline fused.", spans = list("info"))
		say("Jabberline fused.", spans = list("info"))
		update_icon()
		return
	if(calling)
		listening = !listening
		to_chat(user, span_info("I [listening ? "unmute" : "mute"] the input on the SCOM."))
		return
	if(loudmouth_listening)
		to_chat(user, span_info("I quell the Loudmouth's prattling on the SCOM. It may be muted entirely still."))
		loudmouth_listening = FALSE
	else
		listening = !listening
		speaking = listening
		to_chat(user, span_info("I [speaking ? "unmute" : "mute"] the SCOM."))
		if(listening)
			loudmouth_listening = TRUE
	update_icon()

/obj/structure/roguemachine/scomm/attackby(obj/item/W, mob/user, params)
	. = ..()
	if(istype(W, /obj/item/reagent_containers/food/snacks/rogue/cheddarslice))
		to_chat(user, span_smallnotice("You stuffs a piece of cheese into the SCOM discreetly, quietening the rats for a while..."))
		last_cheese = world.time
		qdel(W)

/obj/structure/roguemachine/scomm/attack_right(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(called_by && !calling)
		called_by.say("Jabberline refused.", spans = list("info"))
		say("Jabberline refused.", spans = list("info"))
		called_by.calling = null
		called_by = null
		return
	if(calling)
		speaking = !speaking
		to_chat(user, span_info("I [speaking ? "unmute" : "mute"] the output on the SCOM."))
		return
	var/canread = user.can_read(src, TRUE)
	var/contents
	contents += "<center>[uppertext(SSticker.rulertype)]'S DECREES<BR>"
	contents += "-----------<BR><BR></center>"
	for(var/i = GLOB.lord_decrees.len to 1 step -1)
		contents += "[i]. <span class='info'>[GLOB.lord_decrees[i]]</span><BR>"
	if(!canread)
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 220)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/scomm/MiddleClick(mob/living/carbon/human/user)
	if(.)
		return
	if(HAS_TRAIT(user, TRAIT_GARRISON_ITEM))
		if(alert("Would you like to swap lines or connect to a jabberline?",, "swap", "jabberline") != "jabberline")
			garrisonline = !garrisonline
			to_chat(user, span_info("I [garrisonline ? "connect to the garrison SCOMline" : "connect to the general SCOMLINE"]"))
			playsound(loc, 'sound/misc/garrisonscom.ogg', 100, FALSE, -1)
			update_icon()
			return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(calling)
		calling.say("Jabberline severed.", spans = list("info"))
		if(calling.calling == src || calling.called_by == src)
			var/obj/structure/roguemachine/scomm/old_calling = calling
			old_calling.called_by = null
			old_calling.calling = null
			old_calling.speaking = old_calling.listening
			old_calling.update_icon()
		calling = null
		called_by = null
		speaking = listening
		to_chat(user, span_info("I cut the jabberline."))
		say("Jabberline severed.", spans = list("info"))
		update_icon()
	else
		say("Input SCOM designation.", spans = list("info"))
		var/nightcall = input(user, "Input the number you have been provided with.", "INTERFACING") as null|num
		if(!nightcall)
			return
		if(nightcall == scom_number)
			to_chat(user, span_warning("Nothing but rats squeaking back at you."))
			playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
			return
		if(SSroguemachine.scomm_machines.len < nightcall)
			say("There are no rats running this jabberline.", spans = list("info"))
			return
		var/obj/structure/roguemachine/scomm/S = SSroguemachine.scomm_machines[nightcall]
		if(istype(S, /obj/structure/roguemachine/scomm/receive_only))
			say("The RCOM has no rats to answer jabberlines.")
			return
		if(istype(S, /obj/item/scomstone))
			say("The jabberline's rats cannot travel to SCOMstones.") //Check prevents a runtime and leaves room to potentially make scomstones callable by ID later.
			playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
			return
		if(!S)
			to_chat(user, span_warning("Nothing but rats squeaking back at you."))
			playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
			return
		if(S.calling || S.called_by)
			say("This jabberline's rats are occupied.", spans = list("info"))
			return
		if(!S.speaking)
			say("This jabberline's rats have been gagged.", spans = list("info"))
			return
		calling = S
		S.called_by = src
		update_icon()

		for(var/i in 1 to 10)
			if(!calling)
				update_icon()
				return
			if(calling.calling == src)
				return
			calling.ring_ring()
			ring_ring()
			sleep(30)
		say("This jabberline's rats are exhausted.", spans = list("info"))
		calling.called_by = null
		calling = null
		update_icon()

/obj/structure/roguemachine/scomm/receive_only/MiddleClick(mob/living/carbon/human/user)
	to_chat(user, span_warning("The RCOM has no rats to send - it can only receive messages."))
	return

/obj/structure/roguemachine/scomm/obj_break(damage_flag)
	..()
	calling?.say("Jabberline severed.", spans = list("info"))
	calling?.speaking = calling?.listening
	calling?.called_by = null
	calling?.calling = null
	called_by = null
	calling = null
	speaking = FALSE
	listening = FALSE
	update_icon()
	icon_state = "[icon_state]-br"

/obj/structure/roguemachine/scomm/Initialize()
	. = ..()
	START_PROCESSING(SSroguemachine, src)
	become_hearing_sensitive()
	update_icon()
	SSroguemachine.scomm_machines += src
	scom_number = SSroguemachine.scomm_machines.len

/obj/structure/roguemachine/scomm/update_icon()
	if(obj_broken)
		set_light(0)
		return
	if(garrisonline)
		icon_state = "scomm2"
		return
	if(calling)
		icon_state = "scomm2"
	else if(listening)
		icon_state = "scomm1"
	else
		icon_state = "scomm0"
	if(listening)
		if(!loudmouth_listening)
			icon_state = "scomm3"

/obj/structure/roguemachine/scomm/Destroy()
	lose_hearing_sensitivity()
	SSroguemachine.scomm_machines -= src
	STOP_PROCESSING(SSroguemachine, src)
	set_light(0)
	return ..()

/obj/structure/roguemachine/scomm/proc/ring_ring()
	playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+1, time = 0.5)
	animate(pixel_x = oldx-1, time = 0.5)
	animate(pixel_x = oldx, time = 0.5)

/obj/structure/roguemachine/scomm/proc/repeat_message(message, atom/A, tcolor, message_language, list/tspans, broadcaster_tag)
	// The SCOM just do not work silently if cheesed
	if(last_cheese && (last_cheese + CHEESE_QUIET_TIME >= world.time))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		playsound(loc, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
		say(message, language = message_language)
	voicecolor_override = null

/obj/structure/roguemachine/scomm/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(speaker.loc != loc)
		return
	if(!ishuman(speaker))
		return
	if(!listening)
		return
	if(receive_only)
		to_chat(speaker, span_warning("This RCOM is receive only!"))
		return
	if(last_cheese && (last_cheese + CHEESE_QUIET_TIME >= world.time))
		to_chat(speaker, span_warning("The rats seems to be busy nibbling on something!"))
		return
	if(world.time < last_message + NORMAL_SCOM_PER_MESSAGE_DELAY)
		var/time_remaining = round((last_message + NORMAL_SCOM_PER_MESSAGE_DELAY - world.time) / 10)
		to_chat(speaker, span_warning("The SCOM's rats are still recovering. Wait [time_remaining] more second[time_remaining != 1 ? "s" : ""]."))
		return
	var/mob/living/carbon/human/H = speaker
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	// Update last message time
	last_message = world.time
	// Feedback to indicate successful sending
	playsound(src, 'sound/vo/mobs/rat/rat_life.ogg', 100, TRUE, -1)
	if(raw_message)
		if(calling)
			if(calling.calling == src)
				calling.repeat_message(raw_message, src, usedcolor, message_language)
			return
		if(length(raw_message) > 100) //When these people talk too much, put that shit in slow motion, yeah
			raw_message = "<small>[raw_message]</small>"

		// Build message prefix with SCOM location.
		var/message_affix = ""
		if(scom_number)
			message_affix = "- [scom_tag ? "([scom_tag])" : ""]"
		if(message_affix)
			raw_message = "[raw_message][message_affix]"

		if(garrisonline)
			raw_message = "<span style='color: [GARRISON_SCOM_COLOR]'>[raw_message]</span>" //Prettying up for Garrison line
			for(var/obj/item/scomstone/garrison/S in SSroguemachine.scomm_machines)
				S.repeat_message(raw_message, src, usedcolor, message_language)
			for(var/obj/item/scomstone/bad/garrison/S in SSroguemachine.scomm_machines)
				S.repeat_message(raw_message, src, usedcolor, message_language)
			for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
				if(S.garrisonline)
					S.repeat_message(raw_message, src, usedcolor, message_language)
			SSroguemachine.crown?.repeat_message(raw_message, src, usedcolor, message_language)
			return
		else
			addtimer(CALLBACK(src, PROC_REF(repeat_message_scom), raw_message, usedcolor, message_language), NORMAL_SCOM_TRANSMISSION_DELAY)

// Repeat message for normal SCOM. Meant to be used in a callback with delay
/obj/structure/roguemachine/scomm/proc/repeat_message_scom(raw_message, usedcolor, message_language)
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		if(!S.calling)
			S.repeat_message(raw_message, src, usedcolor, message_language)
	for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(raw_message, src, usedcolor, message_language)
	for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines)
		S.repeat_message(raw_message, src, usedcolor, message_language)//make the listenstone hear scom
	SSroguemachine.crown?.repeat_message(raw_message, src, usedcolor, message_language)

/obj/structure/roguemachine/scomm/proc/dictate_laws()
	if(dictating)
		return
	dictating = TRUE
	repeat_message("THE LAWS OF THE LAND ARE...", tcolor = COLOR_RED)
	INVOKE_ASYNC(src, PROC_REF(dictation))

/obj/structure/roguemachine/scomm/proc/dictation()
	if(!length(GLOB.laws_of_the_land))
		sleep(2)
		repeat_message("THE LAND HAS NO LAWS!", tcolor = COLOR_RED)
		dictating = FALSE
		return
	for(var/i in 1 to length(GLOB.laws_of_the_land))
		sleep(2)
		repeat_message("[i]. [GLOB.laws_of_the_land[i]]", tcolor = COLOR_RED)
	dictating = FALSE

/proc/scom_announce(message)
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		if(S.speaking)
			S.say(message, spans = list("info"))

#undef NORMAL_SCOM_TRANSMISSION_DELAY
#undef NORMAL_SCOM_PER_MESSAGE_DELAY
#undef CHEESE_QUIET_TIME
