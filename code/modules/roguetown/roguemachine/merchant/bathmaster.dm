#define UPGRADE_NOTAX		(1<<0)

/obj/structure/roguemachine/bathvend
	name = "BRASSFACE"
	desc = "Sweet, sweet, addiction. Love in the veins, comfort in my heart."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "brassface"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/list/held_items = list()
	var/locked = FALSE
	var/budget = 0
	var/upgrade_flags
	var/current_cat = "1"
	var/lockid = "nightman"
	var/list/categories = list(
		"Alcohols", 
		"Drugs",
		"Exotic Apparel",
		"Instruments",
		"Cosmetics",
		"Roguery",
		"Smokes",
		)

/obj/structure/roguemachine/bathvend/Initialize()
	. = ..()
	SSBMtreasury.brassface = src
	update_icon()

/obj/structure/roguemachine/bathvend/update_icon()
	cut_overlays()
	if(obj_broken)
		set_light(0)
		return
	set_light(1, 1, 1, l_color = "#1b7bf1")
	add_overlay(mutable_appearance(icon, "vendor-merch"))

/// Single source of truth for displayed and billed prices. Display-time and buy-time
/// both route through here so a mid-session edict rate change can never desync the
/// quoted price from the charged price.
/obj/structure/roguemachine/bathvend/proc/compute_pack_price(datum/supply_pack/PA)
	var/cost = PA.cost
	if(!(upgrade_flags & UPGRADE_NOTAX))
		cost += compute_pack_tax(PA)
	return round(cost)

/obj/structure/roguemachine/bathvend/proc/compute_pack_tax(datum/supply_pack/PA)
	return round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * PA.cost)


/obj/structure/roguemachine/bathvend/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == lockid)
			locked = !locked
			playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
			update_icon()
			return attack_hand(user)
		else
			to_chat(user, span_warning("Wrong key."))
			return
	if(istype(P, /obj/item/storage/keyring))
		var/obj/item/storage/keyring/K = P
		for(var/obj/item/roguekey/KE in K.keys)
			if(KE.lockid == lockid)
				locked = !locked
				playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
				update_icon()
				return attack_hand(user)
	if(istype(P, /obj/item/roguecoin))
		budget += P.get_real_price()
		qdel(P)
		update_icon()
		playsound(loc, 'sound/misc/machinevomit.ogg', 100, TRUE, -1)
		return attack_hand(user)
	..()

/obj/structure/roguemachine/bathvend/Topic(href, href_list)
	. = ..()
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/human_mob = usr
	if(!usr.canUseTopic(src, BE_CLOSE) || locked)
		return
	if(href_list["buy"])
		var/mob/M = usr
		var/path = text2path(href_list["buy"])
		if(!ispath(path, /datum/supply_pack))
			message_admins("silly MOTHERFUCKER [usr.key] IS TRYING TO BUY A [path] WITH THE BRASSFACE")
			return
		var/datum/supply_pack/PA = SSmerchant.supply_packs[path]
		var/cost = compute_pack_price(PA)
		var/tax_amt = compute_pack_tax(PA)
		if(budget >= cost)
			budget -= cost
			if(!(upgrade_flags & UPGRADE_NOTAX))
				SStreasury.mint(SStreasury.discretionary_fund, tax_amt, "[TAX_CATEGORY_IMPORT_TARIFF] (brassface)")
				record_featured_stat(FEATURED_STATS_TAX_PAYERS, human_mob, tax_amt)
				record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)
				record_round_statistic(STATS_REVENUE_IMPORT_TARIFF, tax_amt)
			else
				record_round_statistic(STATS_TAXES_EVADED, tax_amt)
		else
			say("Not enough!")
			return
		var/shoplength = PA.contains.len
		var/l
		for(l=1,l<=shoplength,l++)
			var/pathi = pick(PA.contains)
			new pathi(get_turf(M))
	if(href_list["change"])
		if(budget > 0)
			budget2change(budget, usr)
			budget = 0
	if(href_list["changecat"])
		current_cat = href_list["changecat"]
	if(href_list["secrets"])
		var/list/options = list()
		if(upgrade_flags & UPGRADE_NOTAX)
			options += "Enable Paying Taxes"
		else
			options += "Stop Paying Taxes"
		var/select = input(usr, "Please select an option.", "", null) as null|anything in options
		if(!select)
			return
		if(!usr.canUseTopic(src, BE_CLOSE) || locked)
			return
		switch(select)
			if("Enable Paying Taxes")
				upgrade_flags &= ~UPGRADE_NOTAX
				playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
			if("Stop Paying Taxes")
				upgrade_flags |= UPGRADE_NOTAX
				playsound(loc, 'sound/misc/gold_misc.ogg', 100, FALSE, -1)
				playsound(loc, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
	return attack_hand(usr)

/obj/structure/roguemachine/bathvend/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!ishuman(user))
		return
	if(locked)
		to_chat(user, span_warning("It's locked. Of course."))
		return
	user.changeNext_move(CLICK_CD_FAST)
	playsound(loc, 'sound/misc/gold_menu.ogg', 100, FALSE, -1)
	var/canread = user.can_read(src, TRUE)
	var/contents
	contents = "<center>BRASSFACE - Sweet Dreams for Cheap<BR>"
	contents += "<a href='?src=[REF(src)];change=1'>MAMMON LOADED:</a> [budget]<BR>"

	var/mob/living/carbon/human/H = user
	if(H.job in list("Bathmaster","Bathhouse Attendant"))
		if(canread)
			contents += "<a href='?src=[REF(src)];secrets=1'>Secrets</a>"
		else
			contents += "<a href='?src=[REF(src)];secrets=1'>[stars("Secrets")]</a>"

	contents += "</center><BR>"

	if(current_cat == "1")
		contents += "<center>"
		for(var/X in categories)
			contents += "<a href='?src=[REF(src)];changecat=[X]'>[X]</a><BR>"
		contents += "</center>"
	else
		contents += "<center>[current_cat]<BR></center>"
		contents += "<center><a href='?src=[REF(src)];changecat=1'>\[RETURN\]</a><BR><BR></center>"
		var/list/pax = list()
		for(var/pack in SSmerchant.supply_packs)
			var/datum/supply_pack/PA = SSmerchant.supply_packs[pack]
			if(PA.group == current_cat)
				pax += PA
		for(var/datum/supply_pack/PA in sortNames(pax))
			var/costy = compute_pack_price(PA)
			contents += "[PA.name] [PA.contains.len > 1?"x[PA.contains.len]":""] - ([costy])<a href='?src=[REF(src)];buy=[PA.type]'>BUY</a><BR>"

	if(!canread)
		contents = stars(contents)

	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 600)
	popup.set_content(contents)
	popup.open()

/obj/structure/roguemachine/bathvend/obj_break(damage_flag)
	..()
	var/turf/T = get_turf(src)
	budget2change(budget, custom_turf = T)
	set_light(0)
	update_icon()
	icon_state = "goldvendor0"

/obj/structure/roguemachine/bathvend/Destroy()
	set_light(0)
	SSBMtreasury.brassface = null // Clear our reference from the bath treasury subsystem.
	return ..()


#undef UPGRADE_NOTAX

SUBSYSTEM_DEF(BMtreasury)
	name = "BMtreasury"
	wait = 60 SECONDS // this should not need to run very often.
	priority = FIRE_PRIORITY_WATER_LEVEL
	var/treasury_value = 0
	var/multiple_item_penalty = 0.7
	var/interest_rate = 0.15 // Bit more interest, since it's gonna be much harder for the BMaster to get valuables.
	var/next_treasury_check = 0
	var/list/vault_accounting = list()
	/// The reference to the map's brassface, populated when it initializes.
	var/obj/structure/roguemachine/bathvend/brassface

/datum/controller/subsystem/BMtreasury/proc/add_to_vault(var/obj/item/I)
	if(I.get_real_price() <= 0 || istype(I, /obj/item/roguecoin) || istype(I, /obj/item/storage))
		return
	if(I.type in vault_accounting)
		vault_accounting[I.type] *= multiple_item_penalty
	else
		vault_accounting[I.type] = I.get_real_price()
	return (vault_accounting[I.type]*interest_rate)

/datum/controller/subsystem/BMtreasury/fire()
	if(!brassface) // If there's no brassface there's no point in calculating the money it would be collecting.
		return

	if(!(world.time > next_treasury_check)) // Skip this fire if it's not time for another check.
		return

	next_treasury_check = world.time + rand(5 MINUTES, 8 MINUTES) // If we are going through with our check, set the time for the next one 5-8 minutes in the future.

	vault_accounting = list()
	var/amt_to_generate = 0

	// Still absolutely sucks; Effectively looking through absolutely everything in range to find a couple floors; then again on things on bricks to calculate their value.
	// Alternatively could check the brassface's area and iterate through the things within; in area == in world; so that'd be probably worse.
	// Best way I think would be to add things to a list on area Entered and remove it on area Exit for the purposes of collection-- right now I'm just working on the world loops.
	for(var/turf/open/floor/rogue/churchbrick/bathbrick in RANGE_TURFS(5, brassface))
		for(var/obj/item/item in bathbrick.contents)
			if(!isturf(item.loc)) // This shouldn't pick up things that aren't on the turf anyway-- should always be false.
				continue
			amt_to_generate += add_to_vault(item)

		for(var/obj/structure/closet/closet in bathbrick.contents)
			for(var/obj/item/item in closet)
				amt_to_generate += add_to_vault(item)

	amt_to_generate = round(amt_to_generate, 1)
	brassface.budget += amt_to_generate // goes directly into BRASSFACE rather than into any account.
	send_ooc_note("Income from smuggling hoard to the BRASSFACE: +[amt_to_generate]", job = "Bathmaster")
	record_round_statistic(STATS_BATHMATRON_VAULT_TOTAL_REVENUE, amt_to_generate)


/datum/controller/subsystem/BMtreasury/Destroy()
	brassface = null // If this somehow gets deleted, clean up the reference.
	return ..()
