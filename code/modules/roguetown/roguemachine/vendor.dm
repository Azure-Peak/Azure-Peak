/obj/structure/roguemachine/vendor
	name = "PEDDLER"
	desc = "A half-alive magitech vending machine. The stomach of this thing can be stuffed with fun things to buy."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.1
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/list/held_items = list()
	var/locked = TRUE
	var/budget = 0
	var/wgain = 0
	var/keycontrol = "merchant"
	var/next_hawk = 0
	var/will_hawk = TRUE
	var/max_items = 30

/obj/structure/roguemachine/vendor/proc/get_group_items(var/param)
	// Accepts either:
	// - an object/ref (e.g. REF(rep) from attack_hand links), or
	// - a key string in the form "type_name"
	// Returns a list of held_items keys (actual obj/item refs) that match the group.

	var/obj/item/rep
	// try to resolve param to a held item first (safe for REF strings)
	if(param)
		rep = locate(param) in held_items
	// if param was already an object
	if(!rep && istype(param, /obj/item))
		rep = param

	var/key
	if(rep)
		var/namer = held_items[rep]["NAME"] || rep.name
		key = "[rep.type]_[namer]"
	else
		key = param

	var/list/matches = list()
	for(var/obj/item/O in held_items)
		var/oname = held_items[O]["NAME"] || O.name
		if("[O.type]_[oname]" == key)
			matches += O

	return matches

/obj/structure/roguemachine/vendor/proc/insert(obj/item/P, mob/living/user)
	if(P.w_class <= WEIGHT_CLASS_BULKY)
		if(held_items.len < max_items)
			var/price_to_set = 0

			for(var/obj/item/I in held_items)
				if(I.name == P.name)
					price_to_set = held_items[I]["PRICE"]
					break

			held_items[P] = list()
			held_items[P]["NAME"] = P.name
			held_items[P]["PRICE"] = price_to_set

			P.forceMove(src)
			playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
			return attack_hand(user)
		else
			to_chat(user, span_warning("Full."))
			return

/obj/structure/roguemachine/vendor/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguecoin/aalloy))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		budget += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == keycontrol)
			locked = !locked
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			update_icon()
			return attack_hand(user)
		else
			if(!locked)
				insert(P, user)
			else
				to_chat(user, span_warning("Wrong key."))
				return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		for(var/obj/item/roguekey/KE in K)
			if(KE.lockid == keycontrol)
				locked = !locked
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				update_icon()
				return attack_hand(user)
	if(!locked)
		insert(P, user)
	..()

/obj/structure/roguemachine/vendor/Topic(href, href_list)
	. = ..()
	// defensive checks
	if(!usr || !ishuman(usr))
		return

	// BUY
	if(href_list["buy"])
		// ensure caller has permission; buying usually requires machine locked
		if(!usr.canUseTopic(src, BE_CLOSE) || !locked)
			return

		var/keyorref = href_list["buy"]
		var/list/matches = get_group_items(keyorref)
		if(!length(matches))
			return

		// pick one item from the group to vend
		var/obj/item/O = matches[1]
		var/price = held_items[O]["PRICE"] || 0

		// if price > 0, charge buyer; price == 0 is free
		if(price > 0 && ishuman(usr))
			if(budget >= price)
				budget -= price
				wgain += price
			else
				say("NO MONEY NO HONEY!")
				return

		record_round_statistic(STATS_PEDDLER_REVENUE, held_items[O]["PRICE"])
		// remove one instance and deliver it
		held_items -= O
		if(!usr.put_in_hands(O))
			O.forceMove(get_turf(src))
		update_icon()

	// RETRIEVE (take out of vendor by owner/operator; usually only when unlocked)
	if(href_list["retrieve"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return

		var/keyorref = href_list["retrieve"]
		var/list/matches = get_group_items(keyorref)
		if(!length(matches))
			return

		var/obj/item/O = matches[1]
		held_items -= O
		if(!usr.put_in_hands(O))
			O.forceMove(get_turf(src))
		update_icon()

	// CHANGE (convert budget to change for player) - keep original permission logic
	if(href_list["change"])
		if(!usr.canUseTopic(src, BE_CLOSE) || !locked)
			return
		if(ishuman(usr) && budget > 0)
			budget2change(budget, usr)
			budget = 0

	// WITHDRAW GAIN (owner withdraws stored profit when unlocked)
	if(href_list["withdrawgain"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(ishuman(usr) && wgain > 0)
			budget2change(wgain, usr)
			wgain = 0

	// SET NAME (apply name to the whole group)
	if(href_list["setname"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return

		var/keyorref = href_list["setname"]
		var/list/matches = get_group_items(keyorref)
		if(!length(matches))
			return

		var/prename = held_items[matches[1]]["NAME"]
		var/newname = input(usr, "SET A NEW NAME FOR THIS PRODUCT", src, prename)
		// explicit null check: input returns null on cancel; empty string allowed? we block empty.
		if(newname != null && newname != "")
			for(var/obj/item/I in matches)
				held_items[I]["NAME"] = newname
			update_icon()

	// SET PRICE (apply price to the whole group)
	if(href_list["setprice"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return

		var/keyorref = href_list["setprice"]
		var/list/matches = get_group_items(keyorref)
		if(!length(matches))
			return

		var/preprice = held_items[matches[1]]["PRICE"] || 0
		var/newprice = input(usr, "SET A NEW PRICE FOR THIS PRODUCT", src, preprice) as null|num
		// explicit null check so 0 is accepted
		if(newprice != null)
			// validation: no negative prices, no decimals
			if(newprice < 0 || findtext(num2text(newprice), "."))
				return attack_hand(usr)
			for(var/obj/item/I in matches)
				held_items[I]["PRICE"] = newprice
			update_icon()

	// redraw UI with updated groups / counts
	return attack_hand(usr)

/obj/structure/roguemachine/vendor/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents

	if(canread)
		contents = "<center>THE PEDDLER, THIRD ITERATION<BR>"
		if(locked)
			contents += "<a href='?src=[REF(src)];change=1'>Stored Mammon:</a> [budget]<BR>"
		else
			contents += "<a href='?src=[REF(src)];withdrawgain=1'>Stored Profits:</a> [wgain]<BR>"
	else
		contents = "<center>[stars("THE PEDDLER, THIRD ITERATION")]<BR>"
		if(locked)
			contents += "<a href='?src=[REF(src)];change=1'>[stars("Stored Mammon:")]</a> [budget]<BR>"
		else
			contents += "<a href='?src=[REF(src)];withdrawgain=1'>[stars("Stored Profits:")]</a> [wgain]<BR>"

	contents += "</center>"

	var/list/groups = list()
	for(var/obj/item/I in held_items)
		var/namer = held_items[I]["NAME"] || "thing"
		var/key = "[I.type]_[namer]"
		if(!groups[key])
			groups[key] = list("REP" = I, "COUNT" = 0, "PRICE" = held_items[I]["PRICE"])
		groups[key]["COUNT"] += 1

	// render groups
	for(var/key in groups)
		var/obj/item/rep = groups[key]["REP"]
		var/namer = held_items[rep]["NAME"]
		var/price = groups[key]["PRICE"]
		var/count = groups[key]["COUNT"]

		if(locked)
			if(canread)
				contents += "[icon2html(rep, user)] [namer] x[count] - [price] <a href='?src=[REF(src)];buy=[REF(rep)]'>BUY</a>"
			else
				contents += "[icon2html(rep, user)] [stars(namer)] x[count] - [price] <a href='?src=[REF(src)];buy=[REF(rep)]'>[stars("BUY")]</a>"
		else
			if(canread)
				contents += "[icon2html(rep, user)] <a href='?src=[REF(src)];setname=[REF(rep)]'>[namer]</a> x[count] - <a href='?src=[REF(src)];setprice=[REF(rep)]'>[price]</a> <a href='?src=[REF(src)];retrieve=[REF(rep)]'>TAKE</a>"
			else
				contents += "[icon2html(rep, user)] <a href='?src=[REF(src)];setname=[REF(rep)]'>[stars(namer)]</a> x[count] - <a href='?src=[REF(src)];setprice=[REF(rep)]'>[price]</a> <a href='?src=[REF(src)];retrieve=[REF(rep)]'>[stars("TAKE")]</a>"

		contents += "<BR>"

	var/datum/browser/popup = new(user, "VENDORTHING", "", 450, 350)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/vendor/obj_break(damage_flag)
	..()
	for(var/obj/item/I in held_items)
		I.forceMove(src.loc)
		held_items -= I
	budget2change(budget)
	set_light(0)
	update_icon()
	icon_state = "streetvendor0"

/obj/structure/roguemachine/vendor/Initialize()
	. = ..()
	update_icon()
	START_PROCESSING(SSroguemachine, src)

/obj/structure/roguemachine/vendor/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	if(!locked)
		icon_state = "streetvendor0"
		return
	else
		icon_state = "streetvendor1"
	if(held_items.len)
		set_light(1, 1, 1, l_color = "#1b7bf1")
		add_overlay(mutable_appearance(icon, "vendor-gen"))

/obj/structure/roguemachine/vendor/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	for(var/obj/item/I in held_items)
		I.forceMove(src.loc)
		held_items -= I
	set_light(0)
	return ..()

/obj/structure/roguemachine/vendor/process()
	if(obj_broken)
		return
	if(!will_hawk)
		return
	if(world.time > next_hawk)
		next_hawk = world.time + rand(1 MINUTES, 2 MINUTES)
		if(length(held_items))
			var/obj/item/I = pick(held_items)
			var/namer = held_items[I]["NAME"]
			namer = capitalize(namer)

			if(!findtext(namer, "s", -1)) // doesn't already end with "s"
				for(var/obj/item/O in held_items)
					if(O == I)
						continue
					if(O.type == I.type && (held_items[O]["NAME"]) == held_items[I]["NAME"])
						namer += "s" //add a plural s!
						break

			say("[namer] for sale! [held_items[I]["PRICE"]] mammons!")

/obj/structure/roguemachine/vendor/centcom
	name = "LANDLORD"
	desc = "Give this thing money, and you will immediately buy a neat property in the capital."
	max_integrity = 0
	icon_state = "streetvendor1"
	keycontrol = "dhjlashfdg"
	var/list/cachey = list()

/obj/structure/roguemachine/vendor/centcom/attack_hand(mob/living/user)
	return

/obj/structure/roguemachine/vendor/centcom/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguecoin))
		if(!cachey[user])
			cachey[user] = list()
		cachey[user]["moneydonate"] += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)

		if(cachey[user]["moneydonate"] > 99)
			if(!cachey[user]["trisawarded"])
				cachey[user]["trisawarded"] = 1
				user.adjust_triumphs(1)
				say("[user] has purchased a prole dwelling.")
				playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(cachey[user]["moneydonate"] > 499)
			if(cachey[user]["trisawarded"] < 2)
				cachey[user]["trisawarded"] = 2
				user.adjust_triumphs(1)
				say("[user] has been upgraded to a space in a serf apartment.")
				playsound(src, pick('sound/misc/machinetalk.ogg'), 100, FALSE, -1)
		if(cachey[user]["moneydonate"] > 999)
			if(cachey[user]["trisawarded"] < 3)
				cachey[user]["trisawarded"] = 3
				user.adjust_triumphs(1)
				say("[user] HAS BEEN UPGRADED TO A NOBLE BEDCHAMBER!")
				playsound(src, 'sound/misc/machinelong.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/vendor/inn
	keycontrol = "tavern"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/bathhouse
	keycontrol = "nightman"

/obj/structure/roguemachine/vendor/inn/Initialize()
	. = ..()

	// Add room keys with a price of 20
	for (var/X in list(/obj/item/roguekey/roomi, /obj/item/roguekey/roomii, /obj/item/roguekey/roomiii, /obj/item/roguekey/roomiv, /obj/item/roguekey/roomv, /obj/item/roguekey/roomvi))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 20

	// Add fancy keys with a price of 100
	for (var/Y in list(/obj/item/storage/keyring/innfancyi, /obj/item/storage/keyring/innfancyii, /obj/item/storage/keyring/innfancyiii, /obj/item/storage/keyring/innfancyiv, /obj/item/storage/keyring/innfancyv))
		var/obj/Q = new Y(src)
		held_items[Q] = list()
		held_items[Q]["NAME"] = Q.name
		held_items[Q]["PRICE"] = 100

	// Add penthouse suite key
	for (var/Z in list(/obj/item/storage/keyring/innhunt))
		var/obj/F = new Z(src)
		held_items[F] = list()
		held_items[F]["NAME"] = F.name
		held_items[F]["PRICE"] = 200

	update_icon()

/obj/structure/roguemachine/vendor/merchant
	keycontrol = "merchant"

/obj/structure/roguemachine/vendor/merchant/Initialize()
	. = ..()
	for(var/X in list(/obj/item/roguekey/apartments/stall1,/obj/item/roguekey/apartments/stall2,/obj/item/roguekey/apartments/stall3))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 10
	update_icon()

/obj/structure/roguemachine/vendor/stablemaster
	keycontrol = "stablemaster"

/obj/structure/roguemachine/vendor/stablemaster/Initialize()
	. = ..()
	for(var/X in list(/obj/item/roguekey/apartments/stablemaster_1,/obj/item/roguekey/apartments/stablemaster_2,/obj/item/roguekey/apartments/stablemaster_3,/obj/item/roguekey/apartments/stablemaster_4,/obj/item/roguekey/apartments/stablemaster_5))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 100 // relatively expensive, but cheaper than importing a whole mount
	update_icon()

/obj/structure/roguemachine/vendor/church_bedroomset_one //contains the keys to the church bedrooms, better visually than having them on a table
	keycontrol = "priest"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/church_bedroomset_one/Initialize()
	. = ..()

	for (var/X in list(/obj/item/roguekey/church/roomi, /obj/item/roguekey/church/roomii, /obj/item/roguekey/church/roomiii, /obj/item/roguekey/church/roomiv, /obj/item/roguekey/church/roomv))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 0

/obj/structure/roguemachine/vendor/church_bedroomset_two //contains the keys to the church bedrooms, better visually than having them on a table
	keycontrol = "priest"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/church_bedroomset_two/Initialize()
	. = ..()

	for (var/X in list(/obj/item/roguekey/church/roomvi, /obj/item/roguekey/church/roomvii, /obj/item/roguekey/church/roomviii, /obj/item/roguekey/church/roomix, /obj/item/roguekey/church/roomx, /obj/item/roguekey/church/roomxi, /obj/item/roguekey/church/roomxii, /obj/item/roguekey/church/roomxiii, /obj/item/roguekey/church/roomxiv))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 0

/obj/structure/roguemachine/vendor/keep_knights
	keycontrol = "lord"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/keep_knights/Initialize()
	. = ..()

	for (var/X in list(/obj/item/roguekey/manor/knight, /obj/item/roguekey/manor/knight/two, /obj/item/roguekey/manor/knight/three, /obj/item/roguekey/manor/knight/four))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 0

/obj/structure/roguemachine/vendor/keep_princes
	keycontrol = "lord"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/keep_princes/Initialize()
	. = ..()

	for (var/X in list(/obj/item/roguekey/heir/one, /obj/item/roguekey/heir/two))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 0

/obj/structure/roguemachine/vendor/keep_councillors
	keycontrol = "lord"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/keep_councillors/Initialize()
	. = ..()

	for (var/X in list(/obj/item/roguekey/manor/councillor, /obj/item/roguekey/manor/councillor/two, /obj/item/roguekey/manor/councillor/three))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 0

/obj/structure/roguemachine/vendor/keep_guests
	keycontrol = "lord"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/keep_guests/Initialize()
	. = ..()

	for (var/X in list(/obj/item/roguekey/manor/guest, /obj/item/roguekey/manor/guest/two, /obj/item/roguekey/manor/guest/three, /obj/item/roguekey/manor/guest/four))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 0

/obj/structure/roguemachine/vendor/keep_squire
	keycontrol = "lord"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/keep_squire/Initialize()
	. = ..()

	for (var/X in list(/obj/item/roguekey/manor/squire, /obj/item/roguekey/manor/squire/two, /obj/item/roguekey/manor/squire/three, /obj/item/roguekey/manor/squire/four))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 0


/obj/structure/roguemachine/vendor/keep_servant
	keycontrol = "lord"
	will_hawk = FALSE

/obj/structure/roguemachine/vendor/keep_servant/Initialize()
	. = ..()

	for (var/X in list(/obj/item/roguekey/manor/servant, /obj/item/roguekey/manor/servant/two, /obj/item/roguekey/manor/servant/three, /obj/item/roguekey/manor/servant/four, /obj/item/roguekey/manor/servant/five, /obj/item/roguekey/manor/servant/six))
		var/obj/P = new X(src)
		held_items[P] = list()
		held_items[P]["NAME"] = P.name
		held_items[P]["PRICE"] = 0
