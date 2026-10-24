/datum/ghost_letter
	var/sender
	var/recipient
	var/content
	var/unread = TRUE

/datum/ghost_letter/New(from_whom, to_whom, body)
	. = ..()
	sender = from_whom
	recipient = to_whom
	content = body

/proc/mail_key(mob/M)
	if(!M?.ckey || !M.real_name)
		return null
	return "[M.ckey]-[M.real_name]"

/proc/deliver_ghost(mob/dead/observer/G, sender, recipient, content, sender_log)
	var/box_key = mail_key(G)
	if(!box_key)
		return FALSE
	var/list/box = SSroguemachine.ghost_mailboxes[box_key]
	if(!box)
		box = list()
		SSroguemachine.ghost_mailboxes[box_key] = box
	box += new /datum/ghost_letter(sender, recipient, content)
	to_chat(G, span_biginfo("A new letter has arrived for you. Touch a HERMES to read it."))
	G.playsound_local(G, 'sound/misc/mail.ogg', 100, FALSE, -1)
	log_game("GHOST MAIL: letter from [sender_log || "unknown sender"] delivered to the ghost of [recipient] ([key_name(G)]).")
	return TRUE

/datum/pending_mail
	var/obj/item/letter
	var/deliver_at
	var/recipient
	var/sender
	var/sender_ckey
	var/sender_desc
	var/link

/datum/pending_mail/New(obj/item/parcel, from_whom, to_whom, posted_by, delay)
	. = ..()
	letter = parcel
	sender = from_whom
	recipient = to_whom
	sender_ckey = posted_by
	deliver_at = world.time + delay

/datum/pending_mail/Destroy(force)
	if(!QDELETED(letter))
		qdel(letter)
	letter = null
	return ..()

/datum/pending_mail/proc/deliver()
	var/desc = "letter from [sender_desc] to [recipient] ([mail_recipient_desc(recipient)])"
	if(QDELETED(letter))
		log_game("GHOST MAIL: [desc] was destroyed in transit.")
		return FALSE
	var/obj/item/L = letter
	letter = null
	if(deliver_mail(L, recipient, sender, sender_desc))
		var/client/C = GLOB.directory[sender_ckey]
		if(C && isobserver(C.mob))
			to_chat(C.mob, span_notice("My letter to [recipient] has reached the HERMES."))
		log_game("GHOST MAIL: [desc] delivered.")
		message_admins("GHOST MAIL: [desc] has arrived.[link]")
		return TRUE
	var/atom/fallback = SSroguemachine.hermailermaster
	if(!fallback && length(SSroguemachine.hermailers))
		fallback = SSroguemachine.hermailers[1]
	var/turf/T = fallback ? get_turf(fallback) : null
	if(T)
		L.forceMove(T)
	else
		qdel(L)
	log_game("GHOST MAIL: undeliverable [desc].")
	message_admins("GHOST MAIL: [desc] could not be delivered[T ? ", it spilled out at [ADMIN_VERBOSEJMP(T)]" : " and was lost"].")
	return FALSE


/// The ghost-facing HERMES. Owns the ghost UI and post/read logic, so it is not tied to any machine on the map.
GLOBAL_DATUM_INIT(ghost_hermes, /datum/ghost_hermes, new)

/datum/ghost_hermes
	var/list/last_post = list()

/datum/ghost_hermes/proc/enabled()
	return CONFIG_GET(flag/ghost_letters)

/datum/ghost_hermes/proc/mailbox(mob/user)
	var/box_key = mail_key(user)
	if(!box_key)
		return null
	return SSroguemachine.ghost_mailboxes[box_key]

/datum/ghost_hermes/proc/has_unread(mob/user)
	for(var/datum/ghost_letter/GL as anything in mailbox(user))
		if(GL.unread)
			return TRUE
	return FALSE

/datum/ghost_hermes/proc/read_letters(mob/user)
	var/list/box = mailbox(user)
	if(!length(box))
		return FALSE
	var/body = ""
	for(var/i = length(box), i >= 1, i--)
		var/datum/ghost_letter/GL = box[i]
		body += "<b>From [GL.sender], to [GL.recipient]</b><br>"
		body += GL.content
		GL.unread = FALSE
		if(i > 1)
			body += "<hr>"
	return show_parchment(user, body, "ghostmail")

/datum/ghost_hermes/proc/can_post(mob/dead/observer/user, feedback = FALSE)
	if(!isobserver(user) || !user.ckey)
		return FALSE
	if(!enabled())
		if(feedback)
			to_chat(user, span_warning("The machine is deaf to the dead."))
		return FALSE
	var/last = last_post[user.ckey]
	if(last && world.time < last + GHOST_LETTER_COOLDOWN)
		if(feedback)
			var/wait = last + GHOST_LETTER_COOLDOWN - world.time
			to_chat(user, span_warning("My grip on the world is spent. I could try again in [round(wait / 600) + 1] minute\s."))
		return FALSE
	return TRUE

/// Entry point for the ghost HUD button: unread letters are shown first, otherwise the post UI opens.
/datum/ghost_hermes/proc/open(mob/dead/observer/user)
	if(!enabled())
		to_chat(user, span_warning("The machine is deaf to the dead."))
		return
	if(has_unread(user) && read_letters(user))
		return
	if(can_post(user, feedback = TRUE))
		ui_interact(user)

/datum/ghost_hermes/proc/post(mob/dead/observer/user, list/params)
	if(!can_post(user, feedback = TRUE))
		return FALSE
	var/content = params["content"]
	if(!length(content))
		to_chat(user, span_warning("There is nothing written on it."))
		return FALSE
	if(length(content) > 2000)
		to_chat(user, span_warning("Letter too long."))
		return FALSE
	var/obj/item/paper/P = build_sanitized_letter(null, params["recipient"], content)
	var/target = P.mailedto
	var/sender = P.mailer
	if(!mail_exists(target))
		to_chat(user, span_warning(mail_fail_msg(target)))
		qdel(P)
		return FALSE
	var/datum/pending_mail/PM = new(P, sender, target, user.ckey, rand(GHOST_LETTER_DELAY_MIN, GHOST_LETTER_DELAY_MAX))
	SSroguemachine.pending_letters += PM
	last_post[user.ckey] = world.time
	PM.sender_desc = key_name(user)
	PM.link = log_mail_send(user, target, list("content" = P.info), ghost_send = TRUE)
	to_chat(user, span_notice("The letter slips away into the pipes. It will reach them when it reaches them."))
	return TRUE

/datum/ghost_hermes/ui_state(mob/user)
	return GLOB.observer_state

/datum/ghost_hermes/ui_status(mob/user, datum/ui_state/state)
	if(!can_post(user))
		return UI_CLOSE
	return UI_INTERACTIVE

/datum/ghost_hermes/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Hermes", "HERMES")
		ui.open()

/datum/ghost_hermes/ui_static_data(mob/user)
	var/list/data = list()
	data["ghost_mode"] = TRUE
	data["delay_min"] = GHOST_LETTER_DELAY_MIN
	data["delay_max"] = GHOST_LETTER_DELAY_MAX
	return data

/datum/ghost_hermes/ui_data(mob/user)
	var/list/data = list()
	data["letter_count"] = length(mailbox(user))
	return data

/datum/ghost_hermes/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	var/mob/dead/observer/user = usr
	if(!isobserver(user))
		return TRUE
	switch(action)
		if("send_letter")
			post(user, params)
		if("read_letters")
			read_letters(user)
	return TRUE
