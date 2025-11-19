#define TAB_ROUSMAIN 1
#define TAB_SCOMLOG 2
#define TAB_MANAGESCOMS 3

/obj/structure/roguemachine/crier
	name = "rous master"
	desc = "A magitech device intended for the town crier. Can broadcast communications throughout the town and manage the streetpipe network."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "crier_machine"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/current_tab = TAB_ROUSMAIN
	var/locked = FALSE
	var/keycontrol = "crier"
	var/total_payments = 0 // Central storage of all broadcaster payments.

/obj/structure/roguemachine/crier/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == keycontrol || istype(K, /obj/item/roguekey/lord))
			locked = !locked
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			return
		else
			to_chat(user, span_warning("Wrong key."))
			return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		if(!K.contents.len)
			return
		var/list/keysy = K.contents.Copy()
		for(var/obj/item/roguekey/KE in keysy)
			if(KE.lockid == keycontrol)
				locked = !locked
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				return
		to_chat(user, span_warning("Wrong key."))
		return

/obj/structure/roguemachine/crier/Topic(href, href_list)
	. = ..()
	if(!usr.canUseTopic(src, BE_CLOSE) || locked)
		return
	if(href_list["switchtab"])
		current_tab = text2num(href_list["switchtab"])
	if(href_list["togglehorn"])
		var/obj/structure/broadcast_horn/paid/H = locate(href_list["togglehorn"])
		if(H && (H in SSroguemachine.broadcaster_machines))
			H.is_locked = !H.is_locked
			to_chat(usr, span_notice("You [H.is_locked ? "lock" : "unlock"] [H]."))
	if(href_list["withdraw"])
		if(total_payments <= 0)
			to_chat(usr, span_warning("No mammon to withdraw."))
			return

		var/amount = total_payments
		total_payments = 0

		while(amount >= 5)
			new /obj/item/roguecoin/silver(get_turf(src))
			amount -= 5
		while(amount >= 1)
			new /obj/item/roguecoin/copper(get_turf(src))
			amount -= 1
		to_chat(usr, span_notice("You withdraw the broadcaster payments."))

	return attack_hand(usr)

/obj/structure/roguemachine/crier/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(locked)
		to_chat(user, span_warning("It's locked. Of course."))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	switch(current_tab)
		if(TAB_ROUSMAIN)
			contents += "<center>ROUS MASTER<BR>"
			contents += "Total stored mammon: [total_payments]<br><br>"
			contents += "<a href='?src=\ref[src];withdraw=1'>Withdraw All</a><br>"
			contents += "--------------<BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_SCOMLOG]'>\[Broadcast Log\]</a><BR>"
			contents += "<a href='?src=\ref[src];switchtab=[TAB_MANAGESCOMS]'>\[Manage Broadcasters\]</a><BR>"
			contents += "</center>"
	
		if(TAB_SCOMLOG)
			contents += "<center><b>BROADCAST LOG</b></center><hr>"
			if(!length(GLOB.broadcast_list))
				contents += "<i>No broadcasts logged yet.</i><br>"
			else
				// Show most recent first
				for(var/i = length(GLOB.broadcast_list), i > 0, i--)
					var/entry = GLOB.broadcast_list[i]
					var/msg = entry["message"]
					var/tag = entry["tag"]
					var/time = entry["timestamp"]

					contents += "[tag ? " ( [tag] )" : ""] broadcasted at [time]:<br>"
					contents += "[msg]<br><hr>"

			contents += "<br><a href='?src=\ref[src];switchtab=[TAB_ROUSMAIN]'>\[Back\]</a>"

		if(TAB_MANAGESCOMS)
			contents += "<center><b>Manage Broadcasters</b></center><hr>"

			if(!length(SSroguemachine.broadcaster_machines))
				contents += "<i>No broadcasters found.</i><br>"
			else
				for(var/obj/structure/broadcast_horn/paid/H in SSroguemachine.broadcaster_machines)
					var/locked_text = H.is_locked ? "Locked" : "Unlocked"
					contents += "Streetpipe [H.broadcaster_tag ? " ( [H.broadcaster_tag] )" : ""] "
					contents += "<span style='float:right;'>[locked_text] <a href='?src=\ref[src];togglehorn=\ref[H]'>\[Toggle\]</a></span><br>"
			contents += "<br><a href='?src=\ref[src];switchtab=[TAB_ROUSMAIN]'>\[Back\]</a>"

	if(!canread)
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 400, 500)
	popup.set_content(contents)
	popup.open()

#undef TAB_ROUSMAIN
#undef TAB_SCOMLOG
#undef TAB_MANAGESCOMS
