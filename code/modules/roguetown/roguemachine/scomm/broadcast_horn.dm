#define TOWNER_BROADCAST_COST 1
#define NON_TOWNER_BROADCAST_COST 5

/obj/structure/broadcast_horn
	name = "\improper Streetpipe"
	desc = "Also known as the People's Mouth, so long as the people can afford the ratfeed to pay for it."
	icon_state = "broadcaster_crass"
	icon = 'icons/roguetown/misc/machines.dmi'
	blade_dulling = DULLING_BASH
	max_integrity = 0
	density = TRUE
	anchored = TRUE
	flags_1 = HEAR_1
	speech_span = SPAN_ORATOR
	var/listening = FALSE
	var/speech_color = null
	var/loudmouth = FALSE
	var/broadcaster_tag

/obj/structure/broadcast_horn/examine(mob/user)
	. = ..()
	if(listening)
		. += span_info("There's a faint skittering coming out of it.")
	else
		. += span_info("The rats within are quiet.")
	if(broadcaster_tag)
		. += span_info("It's[broadcaster_tag ? " labeled as [broadcaster_tag]" : ""].")

/obj/structure/broadcast_horn/redstone_triggered()
	toggle_horn()

/obj/structure/broadcast_horn/proc/toggle_horn()
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	if(listening)
		visible_message(span_notice("[src]'s whine stills."))
		listening = FALSE
	else
		listening = TRUE
		visible_message(span_notice("[src] squeaks alive."))

/obj/structure/broadcast_horn/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(!ishuman(speaker))
		return
	if(!listening)
		return
	var/turf/step_turf = get_step(get_turf(src), src.dir)
	if(get_turf(speaker) != step_turf)
		return
	var/mob/living/carbon/human/H = speaker
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	var/list/tspans = list()
	if(!raw_message)
		return
	if(length(raw_message) > 100)
		raw_message = "<small>[raw_message]</small>"
	tspans |= speech_span
	if(speech_color)
		raw_message = "<span style='color: [speech_color]'>[raw_message]</span>"

	//Log the broadcast here
	GLOB.broadcast_list += list(list(
		"message"   = raw_message,
		"tag"       = broadcaster_tag,
		"timestamp" = station_time_timestamp("hh:mm:ss")
	))

	//Forward to all listeners
	for(var/obj/structure/roguemachine/scomm/S in SSroguemachine.scomm_machines)
		if(!S.calling && (!loudmouth || S.loudmouth_listening))
			S.repeat_message(raw_message, src, usedcolor, message_language, tspans)
	for(var/obj/item/scomstone/S in SSroguemachine.scomm_machines)
		if(!loudmouth || S.loudmouth_listening)
			S.repeat_message(raw_message, src, usedcolor, message_language, tspans)
	for(var/obj/item/listenstone/S in SSroguemachine.scomm_machines)
		if(!loudmouth || S.loudmouth_listening)
			S.repeat_message(raw_message, src, usedcolor, message_language, tspans)
	var/obj/item/clothing/head/roguetown/crown/serpcrown/crowne = SSroguemachine.crown
	if(crowne && (!loudmouth || crowne.loudmouth_listening))
		crowne.repeat_message(raw_message, src, usedcolor, message_language, tspans)
	if(istype(src, /obj/structure/broadcast_horn/paid))
		listening = FALSE
		playsound(src, 'sound/misc/machinelong.ogg', 100, FALSE, -1)

/obj/structure/broadcast_horn/loudmouth
	name = "\improper Golden Mouth"
	desc = "The Loudmouth's own gleaming horn, its surface engraved with the ducal crest."
	icon_state = "broadcaster"
	speech_color = COLOR_ASSEMBLY_GOLD
	broadcaster_tag = "Golden Mouth"
	loudmouth = TRUE

/obj/structure/broadcast_horn/loudmouth/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	toggle_horn()

/obj/structure/broadcast_horn/loudmouth/guest
	name = "\improper Silver Tongue"
	desc = "A guest's horn. Not as gaudy as the Loudmouth's own, but still a fine piece of craftsmanship. "
	broadcaster_tag = "Silver Tongue"
	icon_state = "broadcaster_crass"
	speech_color = COLOR_ASSEMBLY_GURKHA

/obj/structure/broadcast_horn/paid
	name = "\improper Streetpipe"
	desc = "Also known as the People's Mouth, so long as the people can afford the ratfeed to pay for it."
	icon_state = "broadcaster_crass"
	icon = 'icons/roguetown/misc/machines.dmi'
	var/is_locked = FALSE

/obj/structure/broadcast_horn/paid/examine()
	. = ..()
	. += span_info("A noble, yeoman, churchman, retinue member, or courtier can use this for a zenny. Others must insert a ziliqua.")

/obj/structure/broadcast_horn/paid/proc/get_broadcast_cost(mob/user)
	var/datum/job/user_job = SSjob.GetJob(user.job)
	if(!user_job)
		return NON_TOWNER_BROADCAST_COST
	if(user_job.department_flag & (NOBLEMEN|BURGHERS|GARRISON|CHURCHMEN|COURTIERS|RETINUE))
		return TOWNER_BROADCAST_COST
	if(HAS_TRAIT(user, TRAIT_NOBLE))
		// Noble privilege! 
		return TOWNER_BROADCAST_COST
	return NON_TOWNER_BROADCAST_COST

/obj/structure/broadcast_horn/paid/attackby(obj/item/P, mob/user, params)
	// Handle locking/unlocking with crier key
	if(istype(P, /obj/item/roguekey/crier))
		is_locked = !is_locked
		listening = FALSE
		playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		say(is_locked ? "Streetpipe has been locked." : "Streetpipe has been unlocked.")
		return

	// Handle coin payment
	if(istype(P, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = P
		if(is_locked)
			say("Streetpipe is locked. Consult the crier.")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return

		if(listening)
			say("Coin already loaded.")
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		
		var/cost = get_broadcast_cost(user)

		if(C.get_real_price() != cost)
			to_chat(user, span_warning("Invalid payment! Insert coin worth [cost] mammon."))
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return

		listening = TRUE
		qdel(C)

		// Route payments to rousmaster
		for(var/obj/structure/roguemachine/crier/Crier in world)
			Crier.total_payments += cost
			break // Safety. Prevents a runtime if more than 1 rousmaster exists.

		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		return

	..()

/obj/structure/broadcast_horn/Initialize()
	. = ..()
	become_hearing_sensitive()
	SSroguemachine.broadcaster_machines += src

/obj/structure/broadcast_horn/Destroy()
	lose_hearing_sensitivity()
	return ..()

#undef TOWNER_BROADCAST_COST
#undef NON_TOWNER_BROADCAST_COST
