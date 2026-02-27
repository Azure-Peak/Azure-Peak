/obj/structure/roguemachine/mail/paired_hermes
	name = "clandestine tube"
	desc = "A crude pneumatic tube. It seems to connect somewhere nearby."
	obfuscated = TRUE
	var/next_send_time = 0
	var/notify_bathhouse = FALSE
	/// This tube's identity for pairing
	var/tube_id
	/// The tube_id of the tube this one sends to
	var/target_tube_id

/obj/structure/roguemachine/mail/paired_hermes/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right-click to access the terminal. Letters sent through the tube are free.")
	. += span_info("Insert a prewritten letter or package directly to send it through the tube for free.")

/obj/structure/roguemachine/mail/paired_hermes/attack_right(mob/user)
	ui_interact(user)

/obj/structure/roguemachine/mail/paired_hermes/ui_static_data(mob/user)
	var/list/data = ..()
	data["has_tube"] = TRUE
	return data

/// Find the paired tube by matching our target_tube_id to their tube_id.
/obj/structure/roguemachine/mail/paired_hermes/proc/find_paired_tube()
	for(var/obj/structure/roguemachine/mail/paired_hermes/tube in SSroguemachine.hermailers)
		if(tube.tube_id == target_tube_id)
			return tube
	return null

/// Send an item through the tube to the paired tube. Returns TRUE on success.
/obj/structure/roguemachine/mail/paired_hermes/proc/send_through_tube(obj/item/I, mob/user, sender_name = "Anonymous")
	if(world.time < next_send_time)
		to_chat(user, span_warning("The tube's mechanism is still resetting."))
		return FALSE
	var/obj/structure/roguemachine/mail/paired_hermes/target = find_paired_tube()
	if(!target)
		to_chat(user, span_warning("The tube rumbles but nothing happens. It doesn't seem connected to anything."))
		return FALSE
	I.forceMove(target)
	playsound(target, 'sound/misc/hiss.ogg', 100, FALSE, -1)
	visible_message(span_warning("[user] sends something."))
	playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
	if(target.notify_bathhouse)
		send_ooc_note("A message from <b>[sender_name]</b> has arrived at the bathhouse terminal.", job = GLOB.bathhouse_positions)
	next_send_time = world.time + 1 MINUTES
	return TRUE

/obj/structure/roguemachine/mail/paired_hermes/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(action == "send_tube")
		var/mob/user = usr
		var/content = params["content"]
		var/sentfrom = params["sender"]
		if(!sentfrom)
			sentfrom = "Anonymous"
		if(length(content) > 2000)
			to_chat(user, span_warning("Letter too long."))
			return TRUE
		var/obj/item/paper/P = new
		P.info += content
		P.mailer = sentfrom
		P.mailedto = "Clandestine Tube"
		P.update_icon()
		if(!send_through_tube(P, user, sentfrom))
			qdel(P)
		return TRUE
	return ..()

/obj/structure/roguemachine/mail/paired_hermes/attack_hand(mob/user)
	for(var/obj/item/I in contents)
		if(istype(I, /obj/item/paper) || istype(I, /obj/item/smallDelivery))
			user.put_in_hands(I)
			to_chat(user, span_notice("A letter tumbles out."))
			return
	..()

/obj/structure/roguemachine/mail/paired_hermes/attackby(obj/item/P, mob/user, params)
	if(!istype(P, /obj/item/paper) && !istype(P, /obj/item/smallDelivery))
		return ..()
	if(world.time < next_send_time)
		to_chat(user, span_warning("The tube's mechanism is still resetting."))
		return
	if(alert(user, "Send through the tube?",,"YES","NO") != "YES")
		return
	var/sentfrom = input(user, "Who is this from? (Leave blank to send anonymously)", "ROGUETOWN", null)
	if(!sentfrom)
		sentfrom = "Anonymous"
	P.mailer = sentfrom
	P.mailedto = "Clandestine Tube"
	P.update_icon()
	send_through_tube(P, user, sentfrom)

/obj/structure/roguemachine/mail/paired_hermes/cove
	name = "clandestine tube"
	desc = "A crude pneumatic tube. It seems to connect somewhere nearby."
	tube_id = "smuggler_cove"
	target_tube_id = "smuggler_bathhouse"

/obj/structure/roguemachine/mail/paired_hermes/cove/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_OUTLAW))
		. += span_info("This tube connects to the bathhouse. Useful for getting messages to the staff there.")

/obj/structure/roguemachine/mail/paired_hermes/bathhouse
	name = "discreet terminal"
	desc = "A well-maintained pneumatic tube concealed behind lacquered paneling."
	tube_id = "smuggler_bathhouse"
	target_tube_id = "smuggler_cove"
	notify_bathhouse = TRUE

/obj/structure/roguemachine/mail/paired_hermes/bathhouse/examine(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = ishuman(user) ? user : null
	if(HAS_TRAIT(user, TRAIT_OUTLAW) || (H && (H.job in GLOB.bathhouse_positions)))
		. += span_info("This tube connects to a smuggler's hideout along the coast.")
