#define DRUGRADE_MONEYA				(1<<0)
#define DRUGRADE_MONEYB 	      	(1<<1)
#define DRUGRADE_WINE 	          	(1<<2)
#define DRUGRADE_WEAPONS 	      	(1<<3)
#define DRUGRADE_CLOTHES 	      	(1<<4)
#define DRUGRADE_NOTAX				(1<<5)

/obj/structure/roguemachine/drugmachine
	name = "PURITY"
	desc = "You want to destroy your life."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "purity"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	light_outer_range = 6
	light_color = "#ff13d8ff"
	var/list/held_items = list()
	var/locked = FALSE
	var/budget = 0
	var/secret_budget = 0
	var/recent_payments = 0
	var/last_payout = 0
	var/drugrade_flags

/obj/structure/roguemachine/drugmachine/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == "nightman")
			locked = !locked
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			update_icon()
			return attack_hand(user)
		else
			to_chat(user, span_warning("Wrong key."))
			return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		for(var/obj/item/roguekey/KE in K.keys)
			if(KE.lockid == "nightman")
				locked = !locked
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				update_icon()
				return attack_hand(user)
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
	..()

/obj/structure/roguemachine/drugmachine/process()
	if(recent_payments)
		if(world.time > last_payout + rand(6 MINUTES,8 MINUTES))
			var/amt = recent_payments * 0.10
			if(drugrade_flags & DRUGRADE_MONEYA)
				amt = recent_payments * 0.25
			if(drugrade_flags & DRUGRADE_MONEYB)
				amt = recent_payments * 0.50
			recent_payments = 0
			send_ooc_note("<b>Income from PURITY:</b> [amt]", job = "Bathmaster")
			secret_budget += amt
			last_payout = world.time

/obj/structure/roguemachine/drugmachine/Topic(href, href_list)
	. = ..()
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/human_mob = usr
	if(href_list["buy"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/O = text2path(href_list["buy"])
		if(held_items[O]["PRICE"])
			var/tax_amt = FLOOR(SStreasury.tax_value * held_items[O]["PRICE"], 1)
			var/full_price = held_items[O]["PRICE"] + tax_amt
			if(drugrade_flags & DRUGRADE_NOTAX)
				full_price = held_items[O]["PRICE"]
			if(budget >= full_price)
				budget -= full_price
				record_round_statistic(STATS_PURITY_VALUE_SPENT, full_price)
				recent_payments += held_items[O]["PRICE"]
				if(!(drugrade_flags & DRUGRADE_NOTAX))
					SStreasury.give_money_treasury(tax_amt, "purity import tax")
					record_featured_stat(FEATURED_STATS_TAX_PAYERS, human_mob, tax_amt)
					record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
				else
					record_round_statistic(STATS_TAXES_EVADED, tax_amt)
			else
				say("Not enough!")
				return
		var/obj/item/I = new O(get_turf(src))
		human_mob.put_in_hands(I)
	if(href_list["change"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		if(budget > 0)
			budget2change(budget, usr)
			budget = 0
	if(href_list["secrets"])
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		var/list/options = list()
		options += "Withdraw Cut"
		if(drugrade_flags & DRUGRADE_NOTAX)
			options += "Enable Paying Taxes"
		else
			options += "Stop Paying Taxes"
		if(!(drugrade_flags & DRUGRADE_MONEYA))
			options += "Unlock 25% Cut (30)"
		else
			if(!(drugrade_flags & DRUGRADE_MONEYB))
				options += "Unlock 50% Cut (105)"
		var/select = input(usr, "Please select an option.", "", null) as null|anything in options
		if(!select)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		switch(select)
			if("Withdraw Cut")
				if(secret_budget < 1)
					say("There is no mammon to move, Master.")
					return
				options = list("To Bank (Taxed)", "Direct")
				select = input(usr, "Please select an option.", "", null) as null|anything in options
				if(!select)
					return
				if(!usr.canUseTopic(src, BE_CLOSE) || locked)
					return
				if(secret_budget < 1)
					say("There is no mammon to move, Master.")
					return
				switch(select)
					if("To Bank (Taxed)")
						var/mob/living/carbon/human/H = usr
						if(!(SStreasury.generate_money_account(floor(secret_budget), H))) //We returned false on executing the transfer
							say("I could not put your cut in your account, Master. My apologies.")
							return
						secret_budget = 0
					if("Direct")
						budget2change(floor(secret_budget), usr)
						secret_budget = 0
			if("Enable Paying Taxes")
				drugrade_flags &= ~DRUGRADE_NOTAX
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			if("Stop Paying Taxes")
				drugrade_flags |= DRUGRADE_NOTAX
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			if("Unlock 25% Cut (30)")
				if(drugrade_flags & DRUGRADE_MONEYA)
					return
				if(budget < 30)
					say("Ask again when you're serious.")
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					return
				budget -= 30
				drugrade_flags |= DRUGRADE_MONEYA
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			if("Unlock 50% Cut (105)")
				if(drugrade_flags & DRUGRADE_MONEYB)
					return
				if(budget < 105)
					say("Ask again when you're serious.")
					playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
					return
				budget -= 105
				drugrade_flags |= DRUGRADE_MONEYB
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	return attack_hand(usr)

/obj/structure/roguemachine/drugmachine/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	if(locked)
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	if(canread)
		contents = "<center>PURITY - In the name of pleasure.<BR>"
		contents += "<a href='?src=[REF(src)];change=1'>MAMMON LOADED:</a> [budget]<BR>"
	else
		contents = "<center>[stars("PURITY - In the name of pleasure.")]<BR>"
		contents += "<a href='?src=[REF(src)];change=1'>[stars("MAMMON LOADED:")]</a> [budget]<BR>"


	var/mob/living/carbon/human/H = user
	if(H.job == "Bathmaster")
		if(canread)
			contents += "<a href='?src=[REF(src)];secrets=1'>Secrets</a><BR>"
			contents += "Mammon Washing: [recent_payments] -- Your cut, Master! [secret_budget]<BR>"
		else
			contents += "<a href='?src=[REF(src)];secrets=1'>[stars("Secrets")]</a><BR>"
			contents += "[stars("Mammon Washing:")] [recent_payments] -- [stars("Your cut, Master!")] [secret_budget]<BR>"

	contents += "</center>"

	for(var/I in held_items)
		var/price = FLOOR(held_items[I]["PRICE"] + (SStreasury.tax_value * held_items[I]["PRICE"]), 1)
		var/namer = held_items[I]["NAME"]
		if(!price)
			price = "0"
		if(!namer)
			held_items[I]["NAME"] = "thing"
			namer = "thing"
		if(canread)
			contents += "[namer] + [price] <a href='?src=[REF(src)];buy=[I]'>BUY</a>"
		else
			contents += "[stars(namer)] + [stars(price)] <a href='?src=[REF(src)];buy=[I]'>[stars("BUY")]</a>"
		contents += "<BR>"

	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 400)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/drugmachine/obj_break(damage_flag)
	..()
	budget2change(budget)
	set_light(0)
	update_icon()
	icon_state = "streetvendor0"

/obj/structure/roguemachine/drugmachine/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = "#1b7bf1")
	add_overlay(mutable_appearance(icon, "vendor-drug"))


/obj/structure/roguemachine/drugmachine/Destroy()
	set_light(0)
	STOP_PROCESSING(SSroguemachine, src)
	return ..()

/obj/structure/roguemachine/drugmachine/Initialize()
	. = ..()
	START_PROCESSING(SSroguemachine, src)
	update_icon()
	held_items[/obj/item/reagent_containers/powder/spice] = list("PRICE" = rand(41,55),"NAME" = "chuckledust")
	held_items[/obj/item/reagent_containers/powder/ozium] = list("PRICE" = rand(6,15),"NAME" = "ozium")
	held_items[/obj/item/reagent_containers/powder/moondust] = list("PRICE" = rand(13,25),"NAME" = "moondust")
	held_items[/obj/item/clothing/mask/cigarette/rollie/cannabis] = list("PRICE" = rand(12,18),"NAME" = "swampweed zig")
	held_items[/obj/item/clothing/mask/cigarette/rollie/nicotine] = list("PRICE" = rand(5,10),"NAME" = "zig")
	// azure peak addition start - lipstick
	held_items[/obj/item/lipstick] = list("PRICE" = rand(33,50),"NAME" = "red lipstick")
	held_items[/obj/item/lipstick/jade] = list("PRICE" = rand(33,50),"NAME" = "jade lipstick")
	held_items[/obj/item/lipstick/purple] = list("PRICE" = rand(33,50),"NAME" = "purple lipstick")
	held_items[/obj/item/lipstick/black] = list("PRICE" = rand(33,50),"NAME" = "black lipstick")
	//azure peak addition - zigbox
	held_items[/obj/item/quiver/zigs] = list("PRICE" = rand(5,10), "NAME" = "zigbox, empty")
	held_items[/obj/item/reagent_containers/glass/bottle/alchemical/fermented_crab] = list("PRICE" = rand(50,70), "NAME" = "fermented crab")
	// azure peak addition end

#undef DRUGRADE_MONEYA
#undef DRUGRADE_MONEYB
#undef DRUGRADE_WINE
#undef DRUGRADE_WEAPONS
#undef DRUGRADE_CLOTHES
#undef DRUGRADE_NOTAX
