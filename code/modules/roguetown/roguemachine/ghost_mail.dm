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

/proc/deliver_ghost(mob/dead/observer/G, sender, recipient, content)
	var/box_key = mail_key(G)
	if(!box_key)
		return FALSE
	var/list/box = SSroguemachine.ghost_mailboxes[box_key]
	if(!box)
		box = list()
		SSroguemachine.ghost_mailboxes[box_key] = box
	box += new /datum/ghost_letter(sender, recipient, content)
	to_chat(G, span_biginfo("New letter from <b>[sender].</b> Touch a HERMES to read it."))
	G.playsound_local(G, 'sound/misc/mail.ogg', 100, FALSE, -1)
	log_game("GHOST MAIL: letter from [sender] delivered to the ghost of [recipient] ([G.ckey]).")
	return TRUE

/datum/pending_mail
	var/obj/item/letter
	var/deliver_at
	var/recipient
	var/sender
	var/sender_ckey
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
	var/desc = "letter from [sender] (posted by [sender_ckey]) to [recipient]"
	if(QDELETED(letter))
		log_game("GHOST MAIL: [desc] was destroyed in transit.")
		return FALSE
	var/obj/item/L = letter
	letter = null
	if(deliver_mail(L, recipient, sender))
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
