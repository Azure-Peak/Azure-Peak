#define POTION_VIAL "vials"
#define POTION_BOTTLE "bottles"

/obj/structure/roguemachine/potionseller
	name = "POTION SELLER"
	desc = "The stomach of this thing can been stuffed with fluids for you to buy. Its strongest potions might be too much for you to handle."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	density = TRUE
	blade_dulling = DULLING_BASH
	integrity_failure = 0.1
	max_integrity = 0
	debris = list(/obj/item/grown/log/tree/small, /obj/item/roguegear, /obj/item/natural/glass)
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/list/held_items = list()
	var/locked = TRUE
	var/budget = 0
	var/wgain = 0
	var/is_crafted = FALSE
	var/keycontrol = "physician" // Yep I am defaulting it to Physician to avoid confusion with default key being merchant
	var/max_storage_amount = 1000
	var/vials_held = 10
	var/bottles_held = 5
	var/dispensing_bottle_type = POTION_VIAL

/obj/structure/roguemachine/potionseller/crafted
	is_crafted = TRUE
	max_integrity = 100

/obj/structure/roguemachine/potionseller/examine(mob/user)
	. = ..()
	. += span_smallnotice("Can be unlocked with a [keycontrol] key.")
	. += span_smallnotice("You can add reagents and alchemical vials to this machine by interacting with it while unlocked.")

// For university mage
/obj/structure/roguemachine/potionseller/university
	keycontrol = "university"

/obj/structure/roguemachine/potionseller/Initialize()
	. = ..()
	if(!reagents)
		create_reagents(max_storage_amount)
		reagents.flags |= NO_REACT
		reagents.flags &= ~OPENCONTAINER
	if(is_crafted) // spawn a key
		var/obj/item/roguekey/key = new /obj/item/roguekey/physician(get_turf(src))
		key.lockid = "random_potion_peddler_id_[rand(1,999)]" // I know, not foolproof
		key.name = "potion seller key"
		keycontrol = key.lockid
	update_icon()

/obj/structure/roguemachine/potionseller/Destroy()
	if(reagents)
		qdel(reagents)
		reagents = null
	if(budget > 0)
		budget2change(budget)
		budget = 0
	set_light(0)
	return ..()

/obj/structure/roguemachine/potionseller/proc/insert(obj/item/P, mob/living/user)
	if(!istype(P, /obj/item/reagent_containers/glass))
		to_chat(user, span_warning("Not a valid container."))
		return
	
	var/obj/item/reagent_containers/B = P

	if(istype(B, /obj/item/reagent_containers/glass/bottle))
		if(!B.reagents.total_volume)
			if(B.type == /obj/item/reagent_containers/glass/bottle/alchemical)
				to_chat(user, span_smallnotice("I add \the [P] to the vial receptacle."))
				vials_held++
			
			else if(B.type == /obj/item/reagent_containers/glass/bottle || /obj/item/reagent_containers/glass/bottle/rogue)
				to_chat(user, span_smallnotice("I add \the [P] to the bottle receptacle."))
				bottles_held++

			else
				to_chat(user, span_warning("This container isn't accepted by the machine's receptacle."))
				return
			qdel(B)
			playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
			return attack_hand(user)
	if(!B.reagents.total_volume)
		to_chat(user, span_warning("Nothing to add."))
		return
	
	if(reagents.maximum_volume < B.reagents.total_volume + reagents.total_volume)
		to_chat(user, span_warning("Machine is filled to the lid."))
		return

	for(var/datum/reagent/to_add in B.reagents.reagent_list)
		var/already_exists = FALSE
		if(length(reagents.reagent_list))
			for(var/datum/reagent/existing in reagents.reagent_list)
				if(existing.type == to_add.type)
					already_exists = TRUE
					break
		if(!already_exists)
			held_items[to_add.type] = list()
			held_items[to_add.type]["NAME"] = to_add.name
			held_items[to_add.type]["PRICE"] = 0
		B.reagents.trans_to(src, B.reagents.total_volume, transfered_by = user)
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)

/obj/structure/roguemachine/potionseller/attackby(obj/item/P, mob/user, params)
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

	if(istype(P, /obj/item/reagent_containers))
		if(!locked)
			insert(P, user)
		else
			to_chat(user, span_warning("The vendor is locked!"))
			return
	
	..()

/obj/structure/roguemachine/potionseller/proc/dispense(mob/living/user, datum/reagent/R, quantity, price = 0)
	if(!user || !ismob(user) || !user.Adjacent(src))
		return

	if(!R)
		to_chat(user, span_warning("No reagent selected."))
		return 

	quantity = round(quantity)
	if(quantity <= 0)
		to_chat(user, span_warning("The machine cannot pour such a small amount!"))
		return

	if(vials_held <= 0)
		say("I AM ALL OUT OF VIALS, TRAVELER")
		return

	var/current_amount = reagents.get_reagent_amount(R.type)
	if(current_amount <= 0)
		return 

	if(quantity <= 0)
		return

	// Create the vial
	var/obj/item/reagent_containers/glass/bottle/B = null
	if(dispensing_bottle_type == POTION_BOTTLE)
		if(bottles_held <= 0)
			say("I AM ALL OUT OF BOTTLES")
			return
		B = new /obj/item/reagent_containers/glass/bottle(src.loc)
		bottles_held--
	else
		if(vials_held <= 0)
			say("I AM ALL OUT OF VIALS")
			return
		B = new /obj/item/reagent_containers/glass/bottle/alchemical(src.loc)
		vials_held--

	// Handle strange edge case
	if(!B)
		to_chat(span_warning("Nothing falls out! Something's broken!"))

	if(quantity > B.volume)
		quantity = B.volume
	if(quantity > current_amount)
		quantity = current_amount

	B.reagents.add_reagent(R.type, quantity)
	
	playsound(loc, 'sound/misc/potionseller.ogg', 100, TRUE, -1)

	reagents.remove_reagent(R.type, quantity, FALSE)
	if(current_amount - quantity <= 0)
		reagents.del_reagent(R.type)
		held_items -= R.type
		update_icon()

	user.put_in_hands(B)

	// Second price check to make sure machine doesn't overcharge
	var/capped_price = price * quantity	
	if(capped_price > 0)
		budget -= capped_price
		wgain += capped_price
		record_round_statistic(STATS_PEDDLER_REVENUE, capped_price)

	return attack_hand(user)

/obj/structure/roguemachine/potionseller/Topic(href, href_list)
	. = ..()

	// BUY: customer mode
	if(href_list["buy"])
		var/datum/reagent/R = locate(href_list["buy"]) in held_items
		if(!R || !ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE) || !locked)
			return

		var/price = held_items[R.type]["PRICE"]
		var/volume = reagents.get_reagent_amount(R.type)
		if(volume <= 0)
			return

		var/quantity
		if(price > 0)
			var/budget_vol = max(0, round(budget / price))
			if(budget_vol <= 0)
				say("MY POTIONS ARE TOO EXPENSIVE FOR YOU, TRAVELER")
				return
			quantity = input(usr,"How many drams to buy (can afford up to [budget_vol])?", "\The [held_items[R.type]["NAME"]]") as num|null
		else
			quantity = input(usr,
				"How many drams to pour?", "\The [held_items[R.type]["NAME"]]") as num|null

		if(isnull(quantity) || !usr.Adjacent(src))
			return

		// First price check to see if user can actually afford it
		var/total_price = price * quantity
		if(total_price > budget && price > 0)
			say("MY POTIONS ARE TOO EXPENSIVE FOR YOU, TRAVELER")
			return

		dispense(usr, R, quantity, price)		
		return

	// RETRIEVE: owner mode
	if(href_list["retrieve"])
		var/datum/reagent/R = locate(href_list["retrieve"]) in held_items
		if(!R || !ishuman(usr) || !usr.canUseTopic(src, BE_CLOSE) || locked)
			return

		var/quantity = input(usr,"How many drams to pour?", "\The [held_items[R.type]["NAME"]]") as num|null

		if(isnull(quantity) || !usr.Adjacent(src))
			return

		quantity = round(quantity)
		if(quantity > 0)
			dispense(usr, R, quantity)
		return


	if(href_list["change"])
		if(!usr.canUseTopic(src, BE_CLOSE) || !locked)
			return
		if(ishuman(usr) && budget > 0)
			budget2change(budget, usr)
			budget = 0

	if(href_list["withdrawgain"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(ishuman(usr) && wgain > 0)
			budget2change(wgain, usr)
			wgain = 0

	if(href_list["remove_vial"])
		if(!usr.canUseTopic(src, BE_CLOSE))
			return
		if(ishuman(usr))
			if(vials_held <= 0)
				to_chat(usr, span_warning("No vials left to remove."))
				return
			var/obj/item/reagent_containers/glass/bottle/alchemical/B = new /obj/item/reagent_containers/glass/bottle/alchemical(src.loc)
			usr.put_in_hands(B)
			vials_held--

	if(href_list["remove_bottle"])
		if(!usr.canUseTopic(src, BE_CLOSE))
			return
		if(ishuman(usr))
			if(bottles_held <= 0)
				to_chat(usr, span_warning("No bottles left to remove."))
				return
			var/obj/item/reagent_containers/glass/bottle/B = new /obj/item/reagent_containers/glass/bottle(src.loc)
			usr.put_in_hands(B)
			bottles_held--

	if(href_list["switch_bottle_type"])
		if(!usr.canUseTopic(src, BE_CLOSE))
			return
		if(ishuman(usr))
			if(dispensing_bottle_type == POTION_VIAL)
				dispensing_bottle_type = POTION_BOTTLE
			else
				dispensing_bottle_type = POTION_VIAL

	if(href_list["setname"])
		var/datum/reagent/R = locate(href_list["setname"]) in held_items
		if(!R || !usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(ishuman(usr))
			var/prename = held_items[R.type]["NAME"]
			var/newname = input(usr, "SET A NEW NAME FOR THIS POTION", src, prename)
			if(newname)
				held_items[R.type]["NAME"] = newname

	if(href_list["setprice"])
		var/datum/reagent/R = locate(href_list["setprice"]) in held_items
		if(!R || !usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(ishuman(usr))
			var/preprice = held_items[R.type]["PRICE"]
			var/newprice = input(usr,"SET A NEW PRICE FOR THIS POTION PER DRAM (0 IS FREE)", src, preprice) as null|num

			if(isnull(newprice))
				return

			if(newprice <= 0)
				held_items[R.type]["PRICE"] = 0
			else if(newprice < 0.1)
				return attack_hand(usr)
			else
				held_items[R.type]["PRICE"] = round(newprice, 0.1)

	return attack_hand(usr)

/obj/structure/roguemachine/potionseller/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	if(canread)
		contents = "<center>POTION SELLER, FIRST ITERATION<BR>"
		contents += "Currently dispensing: <a href='?src=[REF(src)];switch_bottle_type=1'>[dispensing_bottle_type]</a><BR>"

		if(locked)
			contents += "<a href='?src=[REF(src)];change=1'>Stored Mammon:</a> [budget]<BR>"
			contents += "Vials remaining: [vials_held] | Bottles remaining: [bottles_held]<BR>"
		else
			contents += "<a href='?src=[REF(src)];withdrawgain=1'>Stored Profits:</a> [wgain]<BR>"
			contents += "<a href='?src=[REF(src)];remove_vial=1'>Vials remaining:</a>[vials_held] | <a href='?src=[REF(src)];remove_bottle=1'>Bottles remaining:</a>[bottles_held]<BR>"
	else
		contents = "<center>[stars("POTION SELLER, FIRST ITERATION")]<BR>"
		
		if(locked)
			contents += "<a href='?src=[REF(src)];change=1'>[stars("Stored Mammon:")]</a> [budget]<BR>"
		else
			contents += "<a href='?src=[REF(src)];withdrawgain=1'>[stars("Stored Profits:")]</a> [wgain]<BR>"

	contents += "</center>"
	
	if(!held_items.len)
		contents += "<center>NO REAGENTS INSERTED</center><BR>"
	else
		for(var/I in held_items)
			var/price = held_items[I]["PRICE"]
			var/namer = held_items[I]["NAME"]
			var/volume = reagents.get_reagent_amount(I)
			if(volume < 1) // do not sell reagents less than 1 dram
				continue
			if(!namer)
				held_items[I]["NAME"] = "thing"
				namer = "thing"
			if(locked)
				var/buy = !price ? "TAKE" : "BUY"
				price = !price ? "FREE" : "[price] per dram"
				if(canread)
					contents += "[namer] ([volume] [UNIT_FORM_STRING(volume)]) - [price] <a href='?src=[REF(src)];buy=[REF(I)]'>[buy]</a>"
				else
					contents += "[stars(namer)] - [stars(price)] <a href='?src=[REF(src)];buy=[REF(I)]'>[stars("[buy]")]</a>"
			else
				if(canread)
					contents += "<a href='?src=[REF(src)];setname=[REF(I)]'>[namer]</a> ([volume] [UNIT_FORM_STRING(volume)]) - <a href='?src=[REF(src)];setprice=[REF(I)]'>[price] per dram</a> <a href='?src=[REF(src)];retrieve=[REF(I)]'>TAKE</a>"
				else
					contents += "<a href='?src=[REF(src)];setname=[REF(I)]'>[stars(namer)]</a> - <a href='?src=[REF(src)];setprice=[REF(I)]'>[price] [stars("per dram")]</a> <a href='?src=[REF(src)];retrieve=[REF(I)]'>[stars("TAKE")]</a>"
			contents += "<BR>"

	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 300)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/potionseller/obj_break(damage_flag)
	..()
	held_items = list()
	reagents.clear_reagents()
	if(budget > 0)
		budget2change(budget)
		budget = 0
	set_light(0)
	update_icon()
	icon_state = "streetvendor0"

/obj/structure/roguemachine/potionseller/update_icon()
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

#undef POTION_BOTTLE
#undef POTION_VIAL
