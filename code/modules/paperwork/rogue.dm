/obj/item/paper/scroll
	name = "papyrus"
	icon_state = "scroll"
	var/open = FALSE
	slot_flags = null
	dropshrink = 0.6
	firefuel = 30 SECONDS
	sellprice = 2
	textper = 108
	maxlen = 2000
	throw_range = 3


/obj/item/paper/scroll/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/thorn) || istype(P, /obj/item/natural/feather))
		if(!open)
			to_chat(user, span_warning("Open me."))
			return
	if(P.get_sharpness())
		to_chat(user, span_warning("[user] tears [src]."))
		new /obj/item/paper(get_turf(src))
		new /obj/item/paper(get_turf(src))
		qdel(src)
		return
	..()

/obj/item/paper/scroll/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.3,"sx" = 0,"sy" = -1,"nx" = 13,"ny" = -1,"wx" = 4,"wy" = 0,"ex" = 7,"ey" = -1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 2,"sflip" = 0,"wflip" = 0,"eflip" = 8)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,"sx" = 0,"sy" = 0,"nx" = 13,"ny" = 1,"wx" = 0,"wy" = 2,"ex" = 5,"ey" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 63,"wturn" = -27,"eturn" = 63,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/paper/scroll/attack_self(mob/user)
	if(mailer)
		user.visible_message(span_notice("[user] opens the missive from [mailer]."))
		mailer = null
		mailedto = null
		update_icon()
		return
	if(!open)
		attack_right(user)
		return
	..()
	user.update_inv_hands()

/obj/item/paper/scroll/read(mob/user)
	if(!open)
		to_chat(user, span_info("Open me."))
		return
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		return
	/*font-size: 125%;*/
	if(in_range(user, src) || isobserver(user))
		user.hud_used.reads.icon_state = "scroll"
		user.hud_used.reads.show()
		user.hud_used.reads.maptext = MAPTEXT_LEGIBLE(info)
		user.hud_used.reads.maptext_width = 230
		user.hud_used.reads.maptext_height = 200
		user.hud_used.reads.maptext_y = 150
		user.hud_used.reads.maptext_x = 120
		onclose(user, "reading", src)
	else
		return span_warning("I'm too far away to read it.")

/obj/item/paper/scroll/Initialize()
	open = FALSE
	update_icon_state()
	..()

/obj/item/paper/scroll/rmb_self(mob/user)
	attack_right(user)
	return

/obj/item/paper/scroll/attack_right(mob/user)
	if(open)
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(src, 'sound/items/scroll_close.ogg', 100, FALSE)
	else
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(src, 'sound/items/scroll_open.ogg', 100, FALSE)
	update_icon_state()
	user.update_inv_hands()

/obj/item/paper/scroll/update_icon_state()
	if(mailer)
		icon_state = "scroll_prep"
		open = FALSE
		name = "missive"
		slot_flags |= ITEM_SLOT_HIP
		throw_range = 7
		return
	throw_range = initial(throw_range)
	if(open)
		if(info)
			icon_state = "scrollwrite"
		else
			icon_state = "scroll"
		name = initial(name)
	else
		icon_state = "scroll_closed"
		name = "scroll"

//Fake reskin of a scroll for the dwarf mercs -- just a fluffy toy
/obj/item/paper/scroll/grudge
	name = "Book of Grudges"
	desc = "A copy you've taken with you. Unfortunately the dampness of Azuria made it unreadable. You can still add new entries, however. It looks bulky enough to act as a mild blunt weapon."
	icon_state ="grudge_closed"
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	grid_width = 32
	grid_height = 32
	force = 10
	possible_item_intents = list(/datum/intent/mace/strike)

/obj/item/paper/scroll/grudge/update_icon_state()
	if(open)
		if(info)
			icon_state = "grudgewrite"
		else
			icon_state = "grudge"
	else
		icon_state = "grudge_closed"

/obj/item/paper/scroll/grudge/attack_right(mob/user)
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	update_icon_state()
	user.update_inv_hands()


/obj/item/paper/scroll/cargo
	name = "shipping order"
	icon_state = "contractunsigned"
	var/signedname
	var/signedjob
	var/list/orders = list()
	open = TRUE
	textper = 150

/obj/item/paper/scroll/cargo/Destroy()
	for(var/datum/supply_pack/SO in orders)
		orders -= SO
	return ..()

/obj/item/paper/scroll/cargo/examine(mob/user)
	. = ..()
//	if(signedname)
//		. += "It was signed by [signedname] the [signedjob]."

	//for each order, add up total price and display orders

/obj/item/paper/scroll/cargo/update_icon_state()
	if(open)
		if(signedname)
			icon_state = "contractsigned"
		else
			icon_state = "contractunsigned"
		name = initial(name)
	else
		icon_state = "scroll_closed"
		name = "scroll"


/obj/item/paper/scroll/cargo/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/natural/feather))
		if(user.is_literate() && open)
			if(signedname)
				to_chat(user, span_warning("[signedname]"))
				return
			switch(alert("Sign your name?",,"Yes","No"))
				if("Yes")
					if(user.mind && user.mind.assigned_role)
						if(do_after(user, 20, target = src))
							signedname = user.real_name
							signedjob = user.mind.assigned_role
							icon_state = "contractsigned"
							user.visible_message(span_notice("[user] signs the [src]."))
							update_icon_state()
							playsound(src, 'sound/items/write.ogg', 100, FALSE)
							rebuild_info()
				if("No")
					return

/obj/item/paper/scroll/cargo/proc/rebuild_info()
	info = null
	info += "<h2>Shipping Order</h2>"
	info += "<hr/>"

	if(orders.len)
		info += "Orders: <br/>"
		info += "<ul>"
		for(var/datum/supply_pack/A in orders)
			info += "<li>[A.name]</li><br/>"
		info += "</ul>"

	info += "<br/></font>"

	if(signedname)
		info += "SIGNED,<br/>"
		info += "<font face=\"[FOUNTAIN_PEN_FONT]\" color=#27293f>[signedname] the [signedjob] of Azure Peak</font>"

/obj/item/paper/inqslip
	name = "inquisition slip"
	var/base_icon_state = "slip"
	dropshrink = 0.75
	icon_state = "slip"
	obj_flags = CAN_BE_HIT
	var/signed
	var/mob/living/carbon/signee
	var/marquevalue = 2
	var/sealed
	var/waxed
	var/sliptype = 1
	var/obj/item/inqarticles/indexer/paired

/obj/item/paper/inqslip/read(mob/user)
	if(!user.client || !user.hud_used)
		return
	if(!user.hud_used.reads)
		return
	if(!user.can_read(src))
		return
	if(in_range(user, src) || isobserver(user))
		if(waxed)
			to_chat(user, span_notice("This writ has been signed by [signee.real_name], sealed with redtallow, and can now be mailed back through the Hermes. The Archbishop will be pleased with this one."))
		if(signed)
			to_chat(user, span_notice("This writ has been signed by [signee.real_name], and can now be mailed back through the Hermes. Sealing it with redtallow would garner more favor from the Archbishop."))
		else if(signee)
			to_chat(user, span_notice("This writ is intended to be signed by [signee.real_name]."))
		else
			to_chat(user, span_notice("This writ has not yet been signed."))

/obj/item/paper/inqslip/accusation
	name = "accusation"
	desc = "A writ of religious suspicion, printed on Otavan parchment: one signed not in ink, but blood. Press the accusation against your own bleeding wound in order to obtain a signature. Then pair it with an INDEXER full of the accused's blood. Once done, it is ready to be mailed back to Otava. Fold and seal it, it's only proper."
	marquevalue = 4
	sliptype = 0

/obj/item/paper/inqslip/confession
	name = "confession"
	base_icon_state = "confession"
	marquevalue = 6
	desc = "A writ of religious guilt, printed on Otavan parchment: one signed not in ink, but blood. Press the confession against a suspect's bleeding wound, in order to obtain their signature. Once done, it is ready to be mailed back to Otava. Fold and seal it, it's only proper."
	sliptype = 2

/obj/item/paper/inqslip/arrival
	name = "arrival slip"
	desc = "A writ of arrival, printed on Otavan parchment: one signed not in ink, but blood. Intended for one person and one person only. Press the slip against one's own weeping wounds in order to obtain a fitting signature. Once done, it is ready to be mailed back to Otava."

/obj/item/paper/inqslip/arrival/ortho
	marquevalue = 4

/obj/item/paper/inqslip/arrival/inq
	marquevalue = 10

/obj/item/paper/inqslip/arrival/abso
	marquevalue = 6

/obj/item/paper/inqslip/proc/attemptsign(mob/user, mob/living/carbon/human/M)
	if(sliptype == 2)
		if(paired)
			if(paired.subject != user)
				to_chat(M, span_warning("Why am I trying to make them sign this with the wrong [paired] paired with it?"))
				return
			else if(alert(user, "SIGN THE CONFESSION?", "CONFIRM OR DENY", "YES", "NO") != "NO")
				signed = TRUE
				signee = user
				update_icon()
		else if(alert(user, "SIGN THE CONFESSION?", "CONFIRM OR DENY", "YES", "NO") != "NO")
			signed = TRUE
			signee = user
			update_icon()
		else
			return
	else if(alert(user, "SIGN THE SLIP?", "CONFIRM OR DENY", "YES", "NO") != "NO")
		signed = TRUE
		signee = user
		update_icon()
	else
		return

/obj/item/paper/inqslip/attack(mob/living/carbon/human/M, mob/user)
	if(sealed)
		return
	if(signed)
		to_chat(user, span_warning("It's already been signed."))
		return
	if(paired && !paired.full)
		to_chat(user, span_warning("I should seperate [paired] from [src] before signing it."))
		return
	if(sliptype != 2)
		if(M != user)
			to_chat(user, span_warning("This is meant to be signed by the holder."))
			return
	if(!M.get_bleed_rate())
		to_chat(user, span_warning("It must be signed in blood."))
		return
	if(sliptype == 1)
		if(signee == M)
			attemptsign(user)
		else
			to_chat(user, span_warning("This slip isn't meant for me."))
	else if(!sliptype)
		attemptsign(user)
	else
		attemptsign(M, user)

/obj/item/paper/inqslip/attack_self(mob/user)
	if(!signed)
		to_chat(user, span_warning("It hasn't been signed yet. Why would I seal it?"))
		return
	if(waxed)
		to_chat(user, span_notice("It's been sealed. It's ready to send back to Otava."))
		return
	else if(!sealed)
		sealed = TRUE
		update_icon()
	else
		sealed = FALSE
		update_icon()

/obj/item/paper/inqslip/attack_right(mob/user)
	. = ..()
	if(paired)
		if(!user.get_active_held_item())
			user.put_in_active_hand(paired, user.active_hand_index)
			paired = null
			update_icon()
		return TRUE

/obj/item/paper/inqslip/update_icon_state()
	. = ..()
	throw_range = initial(throw_range)
	if(!sealed)
		if(paired)
			if(!paired.full)
				icon_state = "[base_icon_state]_indexer"
			else
				icon_state = "[base_icon_state]_indexer[signed ? "_signed" : "_blood"]"
				if(paired.cursedblood)
					icon_state = "[icon_state]_c"
		else
			icon_state = "[base_icon_state][signed ? "_signed" : ""]"
	else
		if(!waxed)
			icon_state = "[base_icon_state]_unsealed"
		else
			icon_state = "[base_icon_state]_sealed"
	return

/obj/item/paper/inqslip/arrival/equipped(mob/user, slot, initial)
	. = ..()
	if(!signee)
		signee = user

/obj/item/paper/inqslip/attacked_by(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/clothing/ring/signet))
		var/obj/item/clothing/ring/signet/S = I
		if(waxed)
			to_chat(user,  span_warning("It's already wax-sealed."))
			return
		if(S.tallowed && sealed)
			waxed = TRUE
			update_icon()
			S.tallowed = FALSE
			S.update_icon()
			playsound(src, 'sound/items/inqslip_sealed.ogg', 75, TRUE, 4)
			marquevalue += 2
		else if(S.tallowed && !sealed)
			to_chat(user,  span_warning("I need to fold the [src] first."))
		else
			to_chat(user,  span_warning("The ring hasn't been waxed."))

	if(sliptype != 1)
		if(istype(I, /obj/item/inqarticles/indexer))
			var/obj/item/inqarticles/indexer/Q = I
			if(paired)
				return
			if(!Q.subject)
				if(signed)
					to_chat(user, span_warning("I should fill [Q] before pairing it with [src]."))
					return
				else
					paired = Q
					user.transferItemToLoc(Q, src, TRUE)
					update_icon()
			else if(Q.subject && Q.full)
				if(sliptype == 2)
					if(Q.subject == signee)
						paired = Q
						user.transferItemToLoc(Q, src, TRUE)
						update_icon()
					else
						if(signed)
							to_chat(user, span_warning("[Q] doesn't contain the blood of the one who signed [src]."))
						else
							to_chat(user, span_warning("I should get a signature before pairing [Q] with [src]."))
						return
				else
					paired = Q
					user.transferItemToLoc(Q, src, TRUE)
					update_icon()
			else
				to_chat(user,  span_warning("[Q] isn't completely full."))

/obj/item/paper/inqslip/attack_right(mob/user)
	. = ..()

/obj/item/paper/scroll/sell_price_changes
	name = "updated purchasing prices"
	icon_state = "contractsigned"

	var/list/sell_prices
	var/writers_name
	var/faction

/obj/item/paper/scroll/sell_price_changes/New(loc, list/prices, faction_name)
	. = ..()

	faction = faction_name
	if(!faction)
		faction = pick("Heartfelt", "Hammerhold", "Grenzelhoft", "Kingsfield")		//add more as time goes, idk

	sell_prices = prices
	if(!length(sell_prices))
		sell_prices = generated_test_data()
	writers_name = pick( world.file2list("strings/rt/names/human/humnorm.txt") )
	rebuild_info()

/obj/item/paper/scroll/sell_price_changes/update_icon_state()
	if(open)
		icon_state = "contractsigned"
		name = initial(name)
	else
		icon_state = "scroll_closed"
		name = "scroll"


/obj/item/paper/scroll/sell_price_changes/proc/rebuild_info()
	info = null
	info += "<div style='vertical-align:top'>"
	info += "<h2 style='color:#06080F;font-family:\"Segoe Script\"'>Purchasing Prices</h2>"
	info += "<hr/>"

	if(sell_prices.len)
		info += "<ul>"
		for(var/atom/type_path as anything in sell_prices)
			var/list/prices = sell_prices[type_path]
			info += "<li style='color:#06080F;font-size:9px;font-family:\"Segoe Script\"'>[initial(type_path.name)] [prices[1]] > [prices[2]] mammons</li><br/>"
		info += "</ul>"

	info += "<br/></font>"

	info += "<font size=\"2\" face=\"[FOUNTAIN_PEN_FONT]\" color=#27293f>[writers_name] Shipwright of [faction]</font>"

	info += "</div>"

/obj/item/paper/scroll/sell_price_changes/proc/generated_test_data()

	var/list/prices = list()
	for(var/i = 1 to rand(2, 4))
		var/datum/supply_pack/pack = pick(SSmerchant.supply_packs)
		if(islist(pack.contains))
			continue
		var/path = pack.contains
		if(!path)
			continue
		prices |= path
		var/starting_rand  = rand(100, 50)
		prices[path] = list("[starting_rand]", "[round(starting_rand * 0.5, 1)]")
	sell_prices = prices
