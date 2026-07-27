/obj/item/listeningdevice
	name = "listener"
	desc = "An ever-attentive ear..."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "listenstone"
	dropshrink = 0.6
	gripped_intents = null
	possible_item_intents = list(INTENT_GENERIC)
	force = 10
	throwforce = 10
	alpha = 255
	w_class = WEIGHT_CLASS_SMALL
	experimental_inhand = FALSE
	grid_width = 32
	grid_height = 32
	var/label = null
	var/inqdesc = null
	var/hidden = FALSE
	layer = TURF_LAYER
	plane = WALL_PLANE
	var/active = FALSE
	var/datum/status_effect/bugged/effect

/obj/item/listeningdevice/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		desc = inqdesc
	else
		desc = initial(desc)

/obj/item/listeningdevice/Initialize()
	. = ..()
	become_hearing_sensitive()
	inqdesc = "An ever-attentive ear... [span_notice("This ear hasn't been bent. It's unlabelled.")]"

/obj/item/listeningdevice/Destroy()
	lose_hearing_sensitivity()
	return ..()

/obj/item/listeningdevice/attack_self(mob/living/user)
	var/input = input(user, "SIX LETTERS", "BEND AN EAR")
	if(!input)
		label = null
		inqdesc = "An ever-attentive ear... [span_notice("This ear hasn't been bent. It's unlabelled.")]"
		desc = inqdesc
		return
	label = uppertext(trim(input, 7))
	inqdesc = "An ever-attentive ear... [span_notice("This ear's been bent. It's labelled as [label].")]"
	desc = inqdesc
	return

/obj/item/listeningdevice/attack_right(mob/living/user)
	if(!hidden)
		alpha = 30
		name = "thing"
		desc = "What is that thing?.."
		hidden = TRUE
		return TRUE
	alpha = 255
	name = initial(name)
	desc = initial(desc)
	hidden = FALSE
	return TRUE

/obj/item/listeningdevice/MiddleClick(mob/user)
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	playsound(loc, 'sound/misc/bug.ogg', 50, FALSE, -1)
	active = !active
	if(active)
		icon_state = "[initial(icon_state)]_active"
	else
		icon_state = initial(icon_state)
	to_chat(user, span_info("I [active ? "undeafen" : "deafen"] the Listener."))
	update_icon()
	return

/obj/item/listeningdevice/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode, original_message)
	if(!active)
		return
	if(!ishuman(speaker))
		return
	var/mob/living/carbon/human/H = speaker
	var/usedcolor = H.voice_color
	if(H.voicecolor_override)
		usedcolor = H.voicecolor_override
	if(!raw_message)
		return
	if(length(raw_message) > 100)
		raw_message = "<small>[raw_message]</small>"
	for(var/obj/item/speakerinq/S in SSroguemachine.scomm_machines)
		S.name = label ? "#[label]" : "#NOTSET"
		S.repeat_message(raw_message, src, usedcolor, message_language)
		S.name = (S.fakename)
