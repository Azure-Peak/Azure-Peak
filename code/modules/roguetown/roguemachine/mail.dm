/obj/structure/roguemachine/mail
	name = "HERMES"
	desc = "Carrier zads have fallen severely out of fashion ever since the advent of this hydropneumatic mail system. The first letter every 5 minutes is free; thereafter, feed it coinage."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mail"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/coin_loaded = 0
	var/inqcoins = 0
	var/inqonly = FALSE // Has the Inquisitor locked Marque-spending for lessers?
	var/keycontrol = "puritan"
	var/static/list/last_free_send = list()
	var/static/list/ghost_sends = list()
	var/allow_ghosts = TRUE
	var/cat_current = "1"
	var/list/all_category = list(
		"✤ RELIQUARY ✤",
		"✤ SUPPLIES ✤",
		"✤ ARTICLES ✤",
		"✤ EQUIPMENT ✤",
		"✤ WARDROBE ✤"
	)
	var/list/category = list(
		"✤ SUPPLIES ✤",
		"✤ ARTICLES ✤",
		"✤ EQUIPMENT ✤",
		"✤ WARDROBE ✤"
	)
	var/list/inq_category = list("✤ RELIQUARY ✤")
	var/ournum
	var/mailtag
	var/obfuscated = FALSE

/obj/structure/roguemachine/mail/Initialize(mapload)
	. = ..()
	SSroguemachine.hermailers += src
	ournum = SSroguemachine.hermailers.len
	name = "[name] #[ournum]"
	update_icon()

/obj/structure/roguemachine/mail/Destroy()
	set_light(0)
	SSroguemachine.hermailers -= src
	return ..()

/obj/structure/roguemachine/mail/proc/free_send_ready(mob/user)
	if(!user || !user.ckey)
		return FALSE
	var/last = last_free_send[user.ckey]
	if(!last)
		return TRUE
	return world.time >= last + HERMES_FREE_COOLDOWN

/obj/structure/roguemachine/mail/proc/free_send_remaining(mob/user)
	if(!user || !user.ckey)
		return 0
	var/last = last_free_send[user.ckey]
	if(!last)
		return 0
	var/remaining = (last + HERMES_FREE_COOLDOWN) - world.time
	return max(0, remaining)

/obj/structure/roguemachine/mail/proc/mark_free_send(mob/user)
	if(!user || !user.ckey)
		return
	last_free_send[user.ckey] = world.time

/obj/structure/roguemachine/mail/proc/ghosts_allowed()
	return allow_ghosts && CONFIG_GET(flag/ghost_letters)

/obj/structure/roguemachine/mail/proc/ghost_mailbox(mob/user)
	var/box_key = mail_key(user)
	if(!box_key)
		return null
	return SSroguemachine.ghost_mailboxes[box_key]

/obj/structure/roguemachine/mail/proc/ghost_unread(mob/user)
	for(var/datum/ghost_letter/GL as anything in ghost_mailbox(user))
		if(GL.unread)
			return TRUE
	return FALSE

/obj/structure/roguemachine/mail/proc/read_mail(mob/user)
	var/list/box = ghost_mailbox(user)
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

/obj/structure/roguemachine/mail/proc/can_ghost_mail(mob/dead/observer/user, feedback = FALSE)
	if(!isobserver(user) || !user.ckey)
		return FALSE
	if(!ghosts_allowed())
		if(feedback)
			to_chat(user, span_warning("The machine is deaf to the dead."))
		return FALSE
	var/last = ghost_sends[user.ckey]
	if(last && world.time < last + GHOST_LETTER_COOLDOWN)
		if(feedback)
			var/wait = last + GHOST_LETTER_COOLDOWN - world.time
			to_chat(user, span_warning("My grip on the world is spent. I could try again in [round(wait / 600) + 1] minute\s."))
		return FALSE
	return TRUE

/obj/structure/roguemachine/mail/attack_ghost(mob/dead/observer/user)
	if(!in_range(src, user) || !ghosts_allowed())
		return ..()
	if(!ghost_unread(user) && can_ghost_mail(user, feedback = TRUE))
		ui_interact(user)
		return TRUE
	if(read_mail(user))
		return TRUE
	return ..()

/obj/structure/roguemachine/mail/attack_hand(mob/user)
	if(SSroguemachine.hermailermaster && ishuman(user))
		var/obj/item/roguemachine/mastermail/M = SSroguemachine.hermailermaster
		var/mob/living/carbon/human/H = user
		var/addl_mail = FALSE
		for(var/obj/item/I in M.contents)
			if(I.mailedto == H.real_name)
				if(!addl_mail)
					I.forceMove(src.loc)
					user.put_in_hands(I)
					addl_mail = TRUE
				else
					say("You have additional mail available.")
					break
		if(!any_additional_mail(M, H.real_name))
			if(!addl_mail && H.has_status_effect(/datum/status_effect/ugotmail)) // we apparently got mail, but never got mail (hint: it was stolen by someone with access to the master mailer)
				to_chat(user, span_notice("I look inside the machine and find no letter, how strange."))
			H.remove_status_effect(/datum/status_effect/ugotmail)
	if(!ishuman(user))
		return
	if (user.mind?.has_bomb) //for TRAIT_EXPLOSIVE_SUPPLY. One bomb per one day.
		var/mob/living/carbon/human/H = user
		H.mind?.has_bomb = FALSE
		var/bomb_type
		var/static/list/bomb_type_list = list(/obj/item/tntstick,
		/obj/item/impact_grenade/explosion,
		/obj/item/impact_grenade/smoke/poison_gas,
		/obj/item/impact_grenade/smoke/fire_gas,
		/obj/item/impact_grenade/smoke/healing_gas,
		)
		var/bonus = 0
		if(H.STALUC > 10)
			bonus = 10 * (H.STALUC - 10)
		if(prob(90 - bonus))
			bomb_type = /obj/item/bomb
		else
			bomb_type = pick(bomb_type_list)
		var/obj/item/S = new bomb_type(get_turf(H))
		H.put_in_hands(S)
		if(HAS_TRAIT(H, TRAIT_BOMBER_EXPERT))	//additional random second bomb.
			bomb_type_list |= /obj/item/bomb
			bomb_type = pick(bomb_type_list)
			var/obj/item/B = new bomb_type(get_turf(H))
			H.put_in_hands(B)
	if(user.mind?.has_drug_delivery) //for TRAIT_DRUG_SUPPLY. One delivery per day.
		var/mob/living/carbon/human/H = user
		H.mind.has_drug_delivery = FALSE
		var/static/list/common_drug_list = list(
			/obj/item/reagent_containers/powder/spice,
			/obj/item/reagent_containers/powder/moondust,
			/obj/item/reagent_containers/powder/starsugar
		)
		var/static/list/rare_drug_list = list(
			/obj/item/reagent_containers/powder/moondust_purest,
			/obj/item/reagent_containers/powder/herozium
		)
		var/drug_type
		if(prob(20))
			drug_type = pick(rare_drug_list)
		else
			drug_type = pick(common_drug_list)
		var/obj/item/D = new drug_type(get_turf(H))
		H.put_in_hands(D)
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		if(!coin_loaded && !inqcoins)
			to_chat(user, span_notice("It needs a Marque."))
			return
		user.changeNext_move(CLICK_CD_MELEE)
		display_marquette(usr)

/obj/structure/roguemachine/mail/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Right click to access the terminal for writing letters or purchasing supplies.")
	. += span_info("Insert coins to purchase supplies or send a letters.")
	. += span_info("Left click with a paper or package to send a prewritten letter for free.")
	. += span_info("You can wrap an item in paper to create a mailable package.")
	if(isobserver(user) && ghosts_allowed())
		. += span_info("Mail from beyond the borders can also be received.")
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		. += span_info("<br>The MARQUETTE can be accessed via a secret compartment fitted within the HERMES. Load a Marque to access it.")
		. += span_info("You can send arrival slips, accusation slips, fully loaded INDEXERs or confessions here.")
		. += span_info("Properly sign them. Include an INDEXER where needed. Stamp them for two additional Marques.")

/obj/structure/roguemachine/mail/attack_right(mob/user)
	. = ..()
	if(.)
		return
	if(!coin_loaded && !free_send_ready(user))
		var/wait_ds = free_send_remaining(user)
		var/mins = round(wait_ds / 600) + 1
		to_chat(user, span_warning("No free letter ready ([mins] minute\s to refresh) and no coin loaded."))
		return
	if(inqcoins)
		to_chat(user, span_warning("The machine doesn't respond."))
		return
	ui_interact(user)

/obj/structure/roguemachine/mail/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/mail/ui_status(mob/user, datum/ui_state/state)
	if(isobserver(user))
		if(!can_ghost_mail(user))
			return UI_CLOSE
		return in_range(src, user) ? UI_INTERACTIVE : UI_UPDATE
	return ..()

/obj/structure/roguemachine/mail/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Hermes", "HERMES")
		ui.open()

/obj/structure/roguemachine/mail/ui_static_data(mob/user)
	var/list/data = list()
	data["paper_cost"] = 1
	data["quill_cost"] = 5
	data["letter_cost"] = 1
	data["ghost_mode"] = isobserver(user) ? TRUE : FALSE
	data["delay_min"] = GHOST_LETTER_DELAY_MIN
	data["delay_max"] = GHOST_LETTER_DELAY_MAX
	return data

/obj/structure/roguemachine/mail/ui_data(mob/user)
	var/list/data = list()
	data["balance"] = coin_loaded
	data["free_send_ready"] = free_send_ready(user) ? TRUE : FALSE
	data["free_send_remaining_ds"] = free_send_remaining(user)
	data["letter_count"] = isobserver(user) ? length(ghost_mailbox(user)) : 0
	return data

/obj/structure/roguemachine/mail/proc/log_mail_send(mob/user, sender_name, recipient_name, ghost_send = FALSE, content)
	if(!user)
		return
	var/what = ghost_send ? "posted GHOST mail (delayed)" : "sent mail"
	user.log_message("[what] via [name]/[(loc)] from [sender_name] to [recipient_name]", LOG_GAME)
	var/link = archive_letter(sender_name, recipient_name, content, key_name(user))
	message_admins("[key_name(user)] [what] via [name]/[(loc)] from [sender_name] to [recipient_name][link]")
	return link

/proc/show_parchment(mob/user, body, window = "parchment")
	if(!user?.client)
		return FALSE
	user << browse_rsc('html/book.png')
	var/dat = {"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
		<html><head><style type=\"text/css\">
		body { background-image:url('book.png');background-repeat: repeat; }</style></head><body scroll=yes>"}
	dat += body
	dat += "</body></html>"
	user << browse(dat, "window=[window];size=500x400;can_close=1;can_minimize=0;can_maximize=0;can_resize=1;titlebar=1;border=0")
	return TRUE

/datum/letter_record
	var/sender
	var/recipient
	var/content
	var/sender_key

/datum/letter_record/New(from_whom, to_whom, body, posted_by)
	. = ..()
	sender = from_whom
	recipient = to_whom
	content = body
	sender_key = posted_by

/datum/letter_record/proc/show_letter(mob/user)
	return show_parchment(user, "<b>From [sender], to [recipient]</b> (sent by [sender_key])<hr>[content]", "letterlog")

/proc/archive_letter(sender, recipient, content, sender_key)
	if(!content)
		return ""
	SSroguemachine.letter_archive += new /datum/letter_record(sender, recipient, content, sender_key)
	return " <a href='?_src_=holder;[HrefToken(TRUE)];read_letter=[length(SSroguemachine.letter_archive)]'>\[Read Letter\]</a>"

/proc/find_mail_box(destination)
	if(!destination || !findtext(destination, "#"))
		return null
	var/wanted = text2num(copytext(destination, findtext(destination, "#") + 1))
	for(var/obj/structure/roguemachine/mail/X in SSroguemachine.hermailers)
		if(X.ournum == wanted)
			return X
	return null

/proc/find_mail_human(destination)
	if(!destination)
		return null
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.real_name == destination)
			return H
	return null

/proc/find_mail_ghost(destination)
	if(!destination)
		return null
	for(var/mob/dead/observer/G in GLOB.dead_mob_list)
		if(G.ckey && G.real_name == destination)
			return G
	return null

/proc/mail_fail_msg(destination)
	return findtext(destination, "#") ? "Cannot send it. Bad number?" : "There's no one by that name to receive it."

/proc/mail_exists(destination)
	if(!destination)
		return FALSE
	if(findtext(destination, "#"))
		return find_mail_box(destination) ? TRUE : FALSE
	return (find_mail_human(destination) || find_mail_ghost(destination)) ? TRUE : FALSE

/proc/stamp_mail(obj/item/I, destination, sender)
	I.mailer = sender
	I.mailedto = destination
	I.update_icon()

/proc/deliver_mail(obj/item/I, destination, sender)
	if(QDELETED(I) || !destination)
		return FALSE
	if(findtext(destination, "#"))
		var/obj/structure/roguemachine/mail/box = find_mail_box(destination)
		if(!box)
			return FALSE
		stamp_mail(I, destination, sender)
		I.forceMove(box.loc)
		box.say("New mail!")
		playsound(box, 'sound/misc/hiss.ogg', 100, FALSE, -1)
		return TRUE
	var/mob/living/carbon/human/H = find_mail_human(destination)
	if(I.type == /obj/item/paper && (!H || H.stat == DEAD))
		var/mob/dead/observer/G = find_mail_ghost(destination)
		if(G)
			var/obj/item/paper/P = I
			deliver_ghost(G, sender, destination, P.info)
			qdel(I)
			return TRUE
	var/obj/item/roguemachine/mastermail/master = SSroguemachine.hermailermaster
	if(!master)
		return FALSE
	stamp_mail(I, destination, sender)
	I.forceMove(master.loc)
	var/datum/component/storage/STR = master.GetComponent(/datum/component/storage)
	STR.handle_item_insertion(I, prevent_warning = TRUE)
	master.new_mail = TRUE
	master.update_icon()
	send_ooc_note("New letter from <b>[sender].</b>", name = destination)
	if(H)
		H.apply_status_effect(/datum/status_effect/ugotmail)
		H.playsound_local(H, 'sound/misc/mail.ogg', 100, FALSE, -1)
	return TRUE

/obj/structure/roguemachine/mail/proc/build_sanitized_letter(mob/user, sender, recipient, content)
	var/obj/item/paper/P = new
	var/parsed_content = parsemarkdown(html_encode(content), user)
	P.info += "<font face=\"[FOUNTAIN_PEN_FONT]\" color=#14103f>[parsed_content]</font>"
	P.mailer = sanitize(sender)
	P.mailedto = sanitize(recipient)
	P.reload_fields()
	P.update_icon()
	return P

/obj/structure/roguemachine/mail/proc/ghost_post(mob/dead/observer/user, list/params)
	if(!can_ghost_mail(user, feedback = TRUE))
		return FALSE
	var/content = params["content"]
	if(!length(content))
		to_chat(user, span_warning("There is nothing written on it."))
		return FALSE
	if(length(content) > 2000)
		to_chat(user, span_warning("Letter too long."))
		return FALSE
	var/obj/item/paper/P = build_sanitized_letter(null, params["sender"], params["recipient"], content)
	if(!P.mailer)
		P.mailer = "Anonymous"
	var/target = P.mailedto
	var/sender = P.mailer
	if(!mail_exists(target))
		to_chat(user, span_warning(mail_fail_msg(target)))
		qdel(P)
		return FALSE
	var/datum/pending_mail/PM = new(P, sender, target, user.ckey, rand(GHOST_LETTER_DELAY_MIN, GHOST_LETTER_DELAY_MAX))
	SSroguemachine.pending_letters += PM
	ghost_sends[user.ckey] = world.time
	PM.link = log_mail_send(user, sender, target, TRUE, P.info)
	playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
	to_chat(user, span_notice("The letter slips away into the pipes. It will reach them when it reaches them."))
	return TRUE

/obj/structure/roguemachine/mail/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	var/mob/user = usr
	if(isobserver(user))
		switch(action)
			if("send_letter")
				ghost_post(user, params)
			if("read_letters")
				read_mail(user)
		return TRUE
	switch(action)
		if("buy_paper")
			if(coin_loaded >= 1)
				coin_loaded -= 1
				var/obj/item/paper/papier = new(get_turf(src))
				user.put_in_hands(papier)
				playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				if(coin_loaded <= 0)
					update_icon()
			return TRUE
		if("buy_quill")
			if(coin_loaded >= 5)
				coin_loaded -= 5
				var/obj/item/natural/feather/quill = new(get_turf(src))
				user.put_in_hands(quill)
				playsound(src, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				if(coin_loaded <= 0)
					update_icon()
			return TRUE
		if("send_letter")
			var/is_free = free_send_ready(user)
			if(!is_free && coin_loaded < 1)
				to_chat(user, span_warning("No free letter ready and no coin loaded. Wait the cooldown or insert a coin."))
				return TRUE
			if(!params["recipient"])
				return TRUE
			var/content = params["content"]
			if(length(content) > 2000)
				to_chat(user, span_warning("Letter too long."))
				return TRUE
			var/obj/item/paper/P = build_sanitized_letter(user, params["sender"], params["recipient"], content)
			var/send2place = P.mailedto
			var/sentfrom = P.mailer
			if(!mail_exists(send2place))
				to_chat(user, span_warning(mail_fail_msg(send2place)))
				qdel(P)
				return TRUE
			var/body = P.info
			if(!deliver_mail(P, send2place, sentfrom))
				to_chat(user, span_warning("The master of mails has perished?"))
				qdel(P)
				return TRUE
			log_mail_send(user, sentfrom, send2place, FALSE, body)
			visible_message(span_warning("[user] sends something."))
			playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			if(is_free)
				mark_free_send(user)
				to_chat(user, span_notice("Your free letter has been sent. Another may be sent in [HERMES_FREE_COOLDOWN / 600] minute\s."))
			else
				SStreasury.mint(SStreasury.discretionary_fund, 1, "Mail Income")
				record_round_statistic(STATS_TAXES_COLLECTED, 1)
				coin_loaded -= 1
				if(coin_loaded <= 0)
					update_icon()
			return TRUE
		if("refund")
			if(coin_loaded > 0)
				budget2change(coin_loaded, user)
				playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
				coin_loaded = 0
				update_icon()
			return TRUE

/obj/structure/roguemachine/mail/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/merctoken))
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			if(H.mind.assigned_role != "Mercenary")
				to_chat(H, "<span class='warning'>This is of no use to me - I may give this to a mercenary so they may send it themselves.</span>")
				return
			if(H.mind.assigned_role == "Mercenary")
				if(H.tokenclaimed == TRUE)
					to_chat(H, "<span class='warning'>I have already received my commendation. There's always next week to look forward to!</span>")
					return
			var/obj/item/merctoken/C = P
			if(C.signed == 1)
				qdel(C)
				visible_message("<span class='warning'>[H] sends something.</span>")
				playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
				sleep(20)
				playsound(loc, 'sound/misc/triumph.ogg', 100, FALSE, -1)
				playsound(src.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
				H.visible_message("<span class='warning'>A trinket comes tumbling down from the machine. Proof of your distinction.</span>")
				H.adjust_triumphs(3)
				H.tokenclaimed = TRUE
				switch(H.merctype)
					if(0)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal(src.loc)
					if(1)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/atgervi(src.loc)
					if(2)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/blackoak(src.loc)
					if(3)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/condottiero(src.loc)
					if(4)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/desertrider(src.loc)
					if(5)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/forlorn(src.loc)
					if(6)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/freifechter(src.loc)
					if(7)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/grenzelhoft(src.loc)
					if(8)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/grudgebearer(src.loc)
					if(9)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal(src.loc) // NOT CURRENTLY IMPLEMENTED
					if(10)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/routier(src.loc)
					if(11)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/steppesman(src.loc)
					if(12)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/underdweller(src.loc)
					if(13)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/vaquero(src.loc)
					if(14)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal(src.loc) // NOT CURRENTLY IMPLEMENTED
					if(15)
						new /obj/item/clothing/neck/roguetown/luckcharm/mercmedal/anthrax(src.loc)
			if(C.signed == 0)
				to_chat(H, "<span class='warning'>I cannot send an unsigned token.</span>")
				return
	if(HAS_TRAIT(user, TRAIT_INQUISITION))
		if(istype(P, /obj/item/roguekey))
			var/obj/item/roguekey/K = P
			if(K.lockid == keycontrol) // Inquisitor's Key
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				for(var/obj/structure/roguemachine/mail/everyhermes in SSroguemachine.hermailers)
					everyhermes.inqlock()
				to_chat(user, span_warning("I [inqonly ? "enable" : "disable"] the Puritan's Lock."))
				return display_marquette(user)
			to_chat(user, span_warning("Wrong key."))
			return
		if(istype(P, /obj/item/storage/keyring))
			var/obj/item/storage/keyring/K = P
			if(!K.contents.len)
				return
			var/list/keysy = K.contents.Copy()
			for(var/obj/item/roguekey/KE in keysy)
				if(KE.lockid == keycontrol)
					playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
					for(var/obj/structure/roguemachine/mail/everyhermes in SSroguemachine.hermailers)
						everyhermes.inqlock()
					to_chat(user, span_warning("I [inqonly ? "enable" : "disable"] the Puritan's Lock."))
					return display_marquette(user)

	if(istype(P, /obj/item/inqarticles/bmirror))
		if((HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN)))
			var/obj/item/inqarticles/bmirror/I = P
			if(I.broken && !I.bloody)
				visible_message(span_warning("[user] sends something."))
				budget2change(2, user, "MARQUE")
				qdel(I)
				record_round_statistic(STATS_MARQUES_MADE, 2)
				playsound(loc, 'sound/misc/otavanlament.ogg', 100, FALSE, -1)
				playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			else
				if(!I.broken)
					to_chat(user, (span_warning("It isn't broken.")))
				if(I.broken)
					to_chat(user, (span_warning("Clean it first.")))

	if(istype(P, /obj/item/inqarticles/litany))
		if((HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN)))
			var/obj/item/inqarticles/litany/I = P
			visible_message(span_warning("[user] sends something."))
			budget2change(6, user, "MARQUE") //Orthodoxist-centric. The number represents how much marques are restored to the Marquette upon refunding it.
			qdel(I) //Design idea's that it costs 3/4ths of an Orthodoxist's free marque payout (8, in this case), and allows them to bless one weapon of their choosing.
			record_round_statistic(STATS_MARQUES_MADE, 6) //It deletes itself after use, but can alternatively be saved to be refunded if an Absolver arrives later.
			playsound(loc, 'sound/misc/otavanlament.ogg', 100, FALSE, -1)
			playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)

	if(istype(P, /obj/item/paper/inqslip/confession))
		if((HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN)))
			var/obj/item/paper/inqslip/confession/I = P
			if(I.signee && I.signed)
				var/no
				var/accused
				var/stopfarming
				var/bonuses = 4
				var/cursedblood
				var/indexed
				var/selfreport
				var/correct
				if(HAS_TRAIT(I.signee, TRAIT_INQUISITION))
					selfreport = TRUE
				if(HAS_TRAIT(I.signee, TRAIT_CABAL) || HAS_TRAIT(I.signee, TRAIT_HORDE) || HAS_TRAIT(I.signee, TRAIT_DEPRAVED) || HAS_TRAIT(I.signee, TRAIT_FREEMAN))
					correct = TRUE
				if(I.signee.name in GLOB.excommunicated_players)
					correct = TRUE
				if(I.paired)
					if(HAS_TRAIT(I.paired.subject, TRAIT_INQUISITION))
						selfreport = TRUE
						indexed = TRUE
					if(I.paired.subject && I.paired.full && !selfreport)
						if(I.paired.cursedblood)
							if(HAS_TRAIT(I.paired.subject.mind, TRAIT_CBLOOD))
								stopfarming = TRUE
							else
								ADD_TRAIT(I.paired.subject.mind, TRAIT_CBLOOD, "mail")
								cursedblood = TRUE
								if(GLOB.cursedsamples.len)
									GLOB.cursedsamples += ", [I.paired.subject.mind]"
								else
									GLOB.cursedsamples += "[I.paired.subject.mind]"
						if(GLOB.indexed)
							if(HAS_TRAIT(I.paired.subject.mind, TRAIT_INDEXED))
								indexed = TRUE
							if(!indexed)
								ADD_TRAIT(I.paired.subject.mind, TRAIT_INDEXED, "mail")
								if(GLOB.indexed.len)
									GLOB.indexed += ", [I.signee]"
								else
									GLOB.indexed += "[I.signee]"
				if(GLOB.accused && !selfreport)
					if(HAS_TRAIT(I.signee.mind, TRAIT_ACCUSED))
						accused = TRUE
				if(GLOB.confessors && !selfreport)
					if(HAS_TRAIT(I.signee.mind, TRAIT_CONFESSED))
						no = TRUE
					if(!no)
						ADD_TRAIT(I.signee.mind, TRAIT_CONFESSED, "mail")
						if(GLOB.confessors.len)
							GLOB.confessors += ", [I.signee]"
						else
							GLOB.confessors += "[I.signee]"
				if(no | selfreport)
					if(I.paired)
						qdel(I.paired)
					qdel(I)
					visible_message(span_warning("[user] sends something."))
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
					if(no)
						to_chat(user, span_notice("They've already confessed."))
					else if(stopfarming)
						to_chat(user, span_notice("We already have a sample of their accursed blood."))
					if(selfreport)
						to_chat(user, span_notice("Why was that confession signed by an inquisition member? What?"))
					if(indexed)
						visible_message(span_warning("[user] recieves something."))
						var/obj/item/inqarticles/indexer/replacement = new /obj/item/inqarticles/indexer/
						user.put_in_hands(replacement)
					return
				else
					if(!correct)
						if(cursedblood)
							bonuses = bonuses + bonuses * I.paired.cursedblood
							if(I.waxed)
								bonuses += 4
							budget2change(bonuses, user, "MARQUE")
							record_round_statistic(STATS_MARQUES_MADE, bonuses)
						if(I.paired && !indexed && !correct && !cursedblood)
							if(I.waxed)
								bonuses += 4
						budget2change(bonuses, user, "MARQUE")
						record_round_statistic(STATS_MARQUES_MADE, bonuses)
					else
						if(I.paired && !indexed && !cursedblood)
							I.marquevalue += bonuses
						if(cursedblood)
							bonuses = bonuses + bonuses * I.paired.cursedblood
							I.marquevalue += bonuses
						if(accused)
							I.marquevalue -= 4
						budget2change(I.marquevalue, user, "MARQUE")
						record_round_statistic(STATS_MARQUES_MADE, I.marquevalue)
					if(I.paired)
						qdel(I.paired)
					qdel(I)
					visible_message(span_warning("[user] sends something."))
					playsound(loc, 'sound/misc/otavanlament.ogg', 100, FALSE, -1)
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			return

	if(istype(P, /obj/item/inqarticles/indexer))
		if((HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN)))
			to_chat(user, span_warning("It needs to be paired with a slip or confession."))
			return

	if(istype(P, /obj/item/paper/inqslip/arrival))
		if((HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN)))
			var/obj/item/paper/inqslip/arrival/I = P
			if(I.signee && I.signed)
				message_admins("INQ ARRIVAL: [user.real_name] ([user.ckey]) has just arrived as a [user.job], earning [I.marquevalue] Marques.")
				log_game("INQ ARRIVAL: [user.real_name] ([user.ckey]) has just arrived as a [user.job], earning [I.marquevalue] Marques.")
				budget2change(I.marquevalue, user, "MARQUE")
				record_round_statistic(STATS_MARQUES_MADE, I.marquevalue)
				qdel(I)
				visible_message(span_warning("[user] sends something."))
				playsound(loc, 'sound/misc/otavasent.ogg', 100, FALSE, -1)
				playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			return

	if(istype(P, /obj/item/paper/inqslip/accusation))
		if(HAS_TRAIT(user, TRAIT_INQUISITION) || HAS_TRAIT(user, TRAIT_PURITAN))
			var/obj/item/paper/inqslip/accusation/I = P
			var/has_signature = !!I.signee
			var/has_indexer = I.paired && I.paired.full && I.paired.subject
			if(has_signature || has_indexer)
				var/no
				var/specialno
				var/stopfarming
				var/indexed
				var/bonuses = 0
				var/correct
				var/cursedblood
				var/selfreport

				if(has_signature && has_indexer)
					bonuses = 4

				if(has_indexer)
					if(HAS_TRAIT(I.paired.subject, TRAIT_INQUISITION))
						selfreport = TRUE
					if(HAS_TRAIT(I.paired.subject, TRAIT_CABAL) || HAS_TRAIT(I.paired.subject, TRAIT_HORDE) || HAS_TRAIT(I.paired.subject, TRAIT_DEPRAVED) || HAS_TRAIT(I.paired.subject, TRAIT_FREEMAN))
						correct = TRUE
					if(I.paired.subject.name in GLOB.excommunicated_players)
						correct = TRUE
					if(GLOB.indexed && !selfreport)
						if(HAS_TRAIT(I.paired.subject.mind, TRAIT_INDEXED))
							indexed = TRUE
						if(!indexed && !selfreport)
							ADD_TRAIT(I.paired.subject.mind, TRAIT_INDEXED, "mail")
							if(GLOB.indexed.len)
								GLOB.indexed += ", [I.paired.subject]"
							else
								GLOB.indexed += "[I.paired.subject]"

					if(I.paired.cursedblood)
						if(HAS_TRAIT(I.paired.subject.mind, TRAIT_CBLOOD))
							stopfarming = TRUE
						if(!stopfarming)
							cursedblood = TRUE
							ADD_TRAIT(I.paired.subject.mind, TRAIT_CBLOOD, "mail")
							if(GLOB.cursedsamples.len)
								GLOB.cursedsamples += ", [I.paired.subject.mind]"
							else
								GLOB.cursedsamples += "[I.paired.subject.mind]"

					if(GLOB.accused && !selfreport)
						if(HAS_TRAIT(I.paired.subject.mind, TRAIT_ACCUSED))
							no = TRUE
						if(!no)
							ADD_TRAIT(I.paired.subject.mind, TRAIT_ACCUSED, "mail")
							if(GLOB.accused.len)
								GLOB.accused += ", [I.paired.subject]"
							else
								GLOB.accused += "[I.paired.subject]"

					if(GLOB.confessors && !selfreport)
						if(HAS_TRAIT(I.paired.subject.mind, TRAIT_CONFESSED))
							no = TRUE
							specialno = TRUE

					if(cursedblood)
						bonuses = bonuses + bonuses * I.paired.cursedblood
						if(I.waxed)
							bonuses += 4
						budget2change(bonuses, user, "MARQUE")
						record_round_statistic(STATS_MARQUES_MADE, bonuses)

					if(no || selfreport || stopfarming)
						qdel(I.paired)
						qdel(I)
						visible_message(span_warning("[user] sends something."))
						playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
						if(!cursedblood)
							visible_message(span_warning("[user] recieves something."))
							var/obj/item/inqarticles/indexer/replacement = new /obj/item/inqarticles/indexer/
							user.put_in_hands(replacement)
							if(specialno)
								to_chat(user, span_notice("They've confessed."))
							else if(selfreport)
								to_chat(user, span_notice("Why are we accusing our own? What have we come to?"))
							else if(stopfarming)
								to_chat(user, span_notice("We've already collected a sample of their accursed blood."))
							else
								to_chat(user, span_notice("They've already been accused."))
						return

					if(!indexed && !correct && !cursedblood)
						I.marquevalue += bonuses
						budget2change(I.marquevalue, user, "MARQUE")
						record_round_statistic(STATS_MARQUES_MADE, I.marquevalue)

					if(correct && !indexed)
						I.marquevalue += bonuses
						budget2change(I.marquevalue, user, "MARQUE")
						record_round_statistic(STATS_MARQUES_MADE, I.marquevalue)

					var/obj/item/paper/inquisition_report/R = new
					var/id = generate_inquisition_id()
					R.report_id = id
					R.name = "haemological report (#[id])"
					R.fill_report(I.paired.subject, user)
					user.put_in_hands(R)

					qdel(I.paired)
					qdel(I)
					visible_message(span_warning("[user] sends something."))
					visible_message(span_warning("[user] receives a mysterious piece of parchment, after a few minutes..."))
					playsound(loc, 'sound/misc/otavanlament.ogg', 100, FALSE, -1)
					playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
					return

			else
				if(I.paired && !I.paired.full)
					to_chat(user, span_warning("[I.paired] needs to be full of the accused's blood."))
				else
					to_chat(user, span_warning("[I] requires either a signature, or an INDEXER with their blood."))
				return

	if(istype(P, /obj/item/paper) || istype(P, /obj/item/smallDelivery))
		if(inqcoins)
			to_chat(user, span_warning("The machine doesn't respond."))
			return
		if(alert(user, "Send Mail?",,"YES","NO") == "YES")
			var/send2place = sanitize(input(user, "Where to? (Person or #number)", "ROGUETOWN", null))
			var/sentfrom = sanitize(input(user, "Who is this from? (Leave blank to send anonymously)", "ROGUETOWN", null))
			if(!sentfrom)
				sentfrom = "Anonymous"
			if(!send2place)
				return
			if(!mail_exists(send2place))
				to_chat(user, span_warning(mail_fail_msg(send2place)))
				return
			var/obj/item/paper/letter = istype(P, /obj/item/paper) ? P : null
			var/body = letter?.info
			if(!deliver_mail(P, send2place, sentfrom))
				to_chat(user, span_warning("The master of mails has perished?"))
				return
			if(!findtext(send2place, "#"))
				playsound(src.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)
			log_mail_send(user, sentfrom, send2place, FALSE, body)
			visible_message(span_warning("[user] sends something."))
			playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
			return

	if(istype(P, /obj/item/roguecoin/aalloy))
		return

	if(istype(P, /obj/item/roguecoin/inqcoin))
		if(HAS_TRAIT(user, TRAIT_INQUISITION))
			if(coin_loaded && !inqcoins)
				return
			var/obj/item/roguecoin/M = P
			coin_loaded = TRUE
			inqcoins += M.quantity
			update_icon()
			qdel(M)
			playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
			return display_marquette(usr)
		else
			return

	if(istype(P, /obj/item/roguecoin))
		var/obj/item/roguecoin/C = P
		var/coin_value = C.get_real_price()
		if(coin_value <= 0)
			return
		coin_loaded += coin_value
		qdel(C)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		update_icon()
		ui_interact(user)
		return
	..()

/obj/structure/roguemachine/mail/r
	pixel_y = 0
	pixel_x = 32

/obj/structure/roguemachine/mail/l
	pixel_y = 0
	pixel_x = -32

/obj/structure/roguemachine/mail/update_icon()
	cut_overlays()
	if(coin_loaded)
		if(inqcoins > 0)
			add_overlay(mutable_appearance(icon, "mail-i"))
			set_light(1, 1, 1, l_color = "#ffffff")
		else
			add_overlay(mutable_appearance(icon, "mail-f"))
			set_light(1, 1, 1, l_color = "#1b7bf1")
	else
		add_overlay(mutable_appearance(icon, "mail-s"))
		set_light(1, 1, 1, l_color = "#ff0d0d")

/obj/structure/roguemachine/mail/examine(mob/user)
	. = ..()
	. += "<a href='?src=[REF(src)];directory=1'>Directory:</a> [mailtag]"

/obj/structure/roguemachine/mail/proc/view_directory(mob/user)
	var/dat
	for(var/obj/structure/roguemachine/mail/X in SSroguemachine.hermailers)
		if(X.obfuscated)
			continue
		if(X.mailtag)
			dat += "#[X.ournum] [X.mailtag]<br>"
		else
			dat += "#[X.ournum] [capitalize(get_area_name(X))]<br>"

	var/datum/browser/popup = new(user, "hermes_directory", "<center>HERMES DIRECTORY</center>", 387, 420)
	popup.set_content(dat)
	popup.open(FALSE)

/obj/item/roguemachine/mastermail
	name = "MASTER OF MAILS"
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "mailspecial"
	pixel_y = 32
	max_integrity = 0
	density = FALSE
	blade_dulling = DULLING_BASH
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
	var/new_mail

/obj/item/roguemachine/mastermail/update_icon()
	cut_overlays()
	if(new_mail)
		icon_state = "mailspecial-get"
	else
		icon_state = "mailspecial"
	set_light(1, 1, 1, l_color = "#ff0d0d")

/obj/item/roguemachine/mastermail/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/storage/concrete/roguetown/mailmaster)

/obj/item/roguemachine/mastermail/attack_hand(mob/user)
	var/datum/component/storage/CP = GetComponent(/datum/component/storage)
	if(CP)
		if(new_mail)
			new_mail = FALSE
			update_icon()
		CP.rmb_show(user)
		return TRUE

/obj/item/roguemachine/mastermail/Initialize(mapload)
	. = ..()
	SSroguemachine.hermailermaster = src
	update_icon()

/obj/item/roguemachine/mastermail/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/paper))
		var/obj/item/paper/PA = P
		if(!PA.mailer && !PA.mailedto && PA.cached_mailer && PA.cached_mailedto)
			PA.mailer = PA.cached_mailer
			PA.mailedto = PA.cached_mailedto
			PA.cached_mailer = null
			PA.cached_mailedto = null
			PA.update_icon()
			to_chat(user, span_warning("I carefully re-seal the letter and place it back in the machine, no one will know."))
		if(PA.mailer && PA.mailedto)
			for(var/mob/living/carbon/human/H in GLOB.human_list)
				if(H.real_name == PA.mailedto && !H.has_status_effect(/datum/status_effect/ugotmail)) // quietly readd the status if they tried to check their mail while the letter was being spied on
					H.apply_status_effect(/datum/status_effect/ugotmail)
		P.forceMove(loc)
		var/datum/component/storage/STR = GetComponent(/datum/component/storage)
		STR.handle_item_insertion(P, prevent_warning=TRUE)
	..()

/obj/item/roguemachine/mastermail/Destroy()
	set_light(0)
	SSroguemachine.hermailers -= src
	var/datum/component/storage/STR = GetComponent(/datum/component/storage)
	if(STR)
		var/list/things = STR.contents()
		for(var/obj/item/I in things)
			STR.remove_from_storage(I, get_turf(src))
	return ..()

/obj/structure/roguemachine/mail/proc/any_additional_mail(obj/item/roguemachine/mastermail/M, name)
	for(var/obj/item/I in M.contents)
		if(I.mailedto == name)
			return TRUE
	return FALSE


/*
	INQUISITION INTERACTIONS - START
*/

/obj/structure/roguemachine/mail/proc/inqlock()
	inqonly = !inqonly

/obj/structure/roguemachine/mail/proc/decreaseremaining(datum/inqports/PA)
	PA.remaining -= 1
	PA.name = "[initial(PA.name)] ([PA.remaining]/[PA.maximum]) - ᛉ [PA.marquescost] ᛉ"
	if(!PA.remaining)
		PA.name = "[initial(PA.name)] (OUT OF STOCK) - ᛉ [PA.marquescost] ᛉ"
	return

/obj/structure/roguemachine/mail/proc/display_marquette(mob/user)
	var/contents
	contents = "<center>✤ ── L'INQUISITION MARQUETTE D'OTAVA ── ✤<BR>"
	contents += "POUR L'ÉRADICATION DE L'HÉRÉSIE, TANT QUE PSYDON ENDURE.<BR>"
	if(HAS_TRAIT(user, TRAIT_PURITAN))
		contents += "✤ ── <a href='?src=[REF(src)];locktoggle=1]'> PURITAN'S LOCK: [inqonly ? "OUI":"NON"]</a> ── ✤<BR>"
	else
		contents += "✤ ── PURITAN'S LOCK: [inqonly ? "OUI":"NON"] ── ✤<BR>"
	contents += "ᛉ <a href='?src=[REF(src)];eject=1'>MARQUES LOADED: [inqcoins]</a>ᛉ<BR>"

	if(cat_current == "1")
		contents += "<BR> <table style='width: 100%' line-height: 40px;'>"
/*		if(HAS_TRAIT(user, TRAIT_PURITAN))
			for(var/i = 1, i <= inq_category.len, i++)
				contents += "<tr>"
				contents += "<td style='width: 100%; text-align: center;'>\
					<a href='?src=[REF(src)];changecat=[inq_category[i]]'>[inq_category[i]]</a>\
					</td>"
				contents += "</tr>"*/
		for(var/i = 1, i <= category.len, i++)
			contents += "<tr>"
			contents += "<td style='width: 100%; text-align: center;'>\
				<a href='?src=[REF(src)];changecat=[category[i]]'>[category[i]]</a>\
				</td>"
			contents += "</tr>"
		contents += "</table>"
	else
		contents += "<center>[cat_current]<BR></center>"
		contents += "<center><a href='?src=[REF(src)];changecat=1'>\[RETURN\]</a><BR><BR></center>"
		contents += "<center>"
		var/list/items = list()
		for(var/pack in GLOB.inqsupplies)
			var/datum/inqports/PA = pack
			if(all_category[PA.category] == cat_current && PA.name)
				items += GLOB.inqsupplies[pack]
				if(PA.name == "Seizing Garrote" && !HAS_TRAIT(user, TRAIT_BLACKBAGGER))
					items -= GLOB.inqsupplies[pack]
		for(var/pack in sortNames(items, order=0))
			var/datum/inqports/PA = pack
			var/name = uppertext(PA.name)
			if(inqonly && !HAS_TRAIT(user, TRAIT_PURITAN) || (PA.maximum && !PA.remaining) || inqcoins < PA.marquescost)
				contents += "[name]<BR>"
			else
				contents += "<a href='?src=[REF(src)];buy=[PA.type]'>[name]</a><BR>"
		contents += "</center>"
	var/datum/browser/popup = new(user, "VENDORTHING", "", 500, 600)
	popup.set_content(contents)
	if(inqcoins == 0)
		popup.close()
		return
	else
		popup.open()

/obj/structure/roguemachine/mail/Topic(href, href_list)
	..()
	if(!usr.canUseTopic(src, BE_CLOSE))
		return
	if(href_list["directory"])
		view_directory(usr)
		return
	if(href_list["eject"])
		if(inqcoins <= 0)
			return
		coin_loaded = FALSE
		update_icon()
		budget2change(inqcoins, usr, "MARQUE")
		inqcoins = 0

	if(href_list["changecat"])
		cat_current = href_list["changecat"]

	if(href_list["locktoggle"])
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		for(var/obj/structure/roguemachine/mail/everyhermes in SSroguemachine.hermailers)
			everyhermes.inqlock()

	if(href_list["buy"])
		var/path = text2path(href_list["buy"])
		var/datum/inqports/PA = GLOB.inqsupplies[path]

		inqcoins -= PA.marquescost
		if(PA.maximum)
			decreaseremaining(PA)
		visible_message(span_warning("[usr] sends something."))
		if(!inqcoins)
			coin_loaded = FALSE
			update_icon()
		playsound(loc, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		var/area/A = GLOB.areas_by_type[/area/rogue/indoors/inq/import]
		if(!A)
			return
		var/list/turfs = list()
		for(var/turf/T in A)
			turfs += T
		var/turf/T = pick(turfs)
		var/pathi = pick(PA.item_type)
		playsound(T, 'sound/misc/disposalflush.ogg', 100, FALSE, -1)
		new pathi(get_turf(T))

	return display_marquette(usr)

/*
	INQUISITION INTERACTIONS - END
*/
