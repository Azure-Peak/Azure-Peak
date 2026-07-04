/obj/item/speakerinq
	name = "secret whisperer"
	desc = "Sweet secrets whispered so freely, it looks like you could fit it onto your ring finger."
	var/speaking = TRUE
	sellprice = 20
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "scomite"
	gripped_intents = null
	dropshrink = 0.75
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	slot_flags = ITEM_SLOT_MOUTH|ITEM_SLOT_HIP|ITEM_SLOT_RING
	possible_item_intents = list(INTENT_GENERIC)
	sleeved = 'icons/roguetown/clothing/onmob/neck.dmi'
	grid_width = 32
	grid_height = 32
	var/fakename = "psydonian signet ring"
	var/active_equipped = FALSE //For our examine texts

/obj/item/speakerinq/get_examine_highlight_status()
	// If we are wearing it on our ring slot, it looks like a psydonian ring. Disguised...
	if(active_equipped)
		return null
	// Otherwise, it's an undisguised and OBVIOUSLY weird and WRONG device. Very obvious.
	else
		return list(EXAMINEHIGHLIGHT_HERESYSEVERITY_VERYODD, HERESYDESC_INQUIS_WHISPERER)

/obj/item/speakerinq/get_mechanics_examine(mob/user)
    . = ..()
    . += span_info("A special enchantment conceals this object from the gazes of the masses-whom-need-not-know your work. While worn as a ring, this will look like a regular psydonian signet ring.")
    . += span_info("Wearing it on your hip or leaving it in the open will make it examinable as a quite-obviously weird object that most will reasonably act on, due to its concerningly odd nature.")

/obj/item/speakerinq/proc/repeat_message(message, atom/A, tcolor, message_language)
	if(!ismob(loc))
		return
	if(tcolor)
		voicecolor_override = tcolor
	if(speaking && message)
		var/mob/living/carbon/human/wearer = loc
		wearer.playsound_local(wearer, 'sound/vo/mobs/rat/rat_life.ogg', 50, TRUE)
		say(message, language = message_language)
	voicecolor_override = null

/obj/item/speakerinq/say(message, bubble_type, list/spans = list(), sanitize = TRUE, datum/language/language = null, ignore_spam = FALSE, forced = null)
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


/obj/item/speakerinq/equipped(mob/user, slot)
	. = ..()
	switch(slot)
		if(SLOT_RING)
			name = fakename
			active_equipped = TRUE
	return TRUE


/obj/item/speakerinq/dropped(mob/user, silent)
	. = ..()
	name = initial(name)
	active_equipped = FALSE
	sleeved = null
	mob_overlay_icon = null

/obj/item/speakerinq/Destroy()
	SSroguemachine.scomm_machines -= src
	return ..()

/obj/item/speakerinq/Initialize()
	. = ..()
	icon_state = "scomite_active"
	update_icon()
	SSroguemachine.scomm_machines += src

/obj/item/speakerinq/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	speaking = !speaking
	to_chat(user, span_info("I [speaking ? "unsilence" : "silence"] the whisperer."))
	if(speaking)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = "[initial(icon_state)]"
	update_icon()

