#define MAMMON_PER_FORCE 1 

/obj/structure/roguemachine/vaultbank
	name = "\improper JAWBANK"
	desc = "A biomechanical obselisk that collects and secures the treasury of the Grand Duchy of Azuria. Throttle it with a strike to spill that which is rightfully yours."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "jawbank"
	density = TRUE
	blade_dulling = DULLING_BASH
	obj_flags = CAN_BE_HIT
	animate_dmg = TRUE
	attacked_sound = list("sound/combat/hits/onmetal/metalimpact (1).ogg", "sound/combat/hits/onmetal/metalimpact (2).ogg")
	var/datum/fund/linked_fund
	var/fund_warned = FALSE
	var/alert_jobs = list("Grand Duke", "Steward", "Clerk")
	var/alert_location = "The Vault"
	var/bash_floor = 1500
	var/hits_since_lump = 0
	var/lump_hit_threshold = 10
	var/lump_payout = 200
	var/drilling = FALSE
	var/has_reported = FALSE
	var/drilltime = 0
	var/og_treasury
	var/total_extorted = 0
	var/shaker = FALSE
	var/whineline = 0
	var/anguish = 0
	var/feedme = 0
	var/knockitoff = 0
	var/knockedoffbefore = 0
	var/drillgoal = 100

/obj/structure/roguemachine/vaultbank/Initialize()
	..()
	enforce_placement()

/obj/structure/roguemachine/vaultbank/proc/enforce_placement()
	var/area/A = GLOB.areas_by_type[/area/rogue/indoors/town/vault]
	var/obj/structure/roguemachine/RM = src
	for(RM in A)
		if(!istype(RM))
			qdel(src)

/obj/structure/roguemachine/vaultbank/proc/get_fund_id()
	return "crown"

/obj/structure/roguemachine/vaultbank/proc/get_linked_fund()
	if(linked_fund)
		return linked_fund
	if(!SStreasury || !SStreasury.discretionary_fund)
		return null
	linked_fund = SStreasury.resolve_fund_by_id(get_fund_id())
	if(!linked_fund && !fund_warned)
		fund_warned = TRUE
		var/msg = "[src] at [AREACOORD(src)] could not resolve linked fund (id '[get_fund_id()]'). Bashing and deposits will fail."
		log_admin(msg)
		message_admins(msg)
	return linked_fund

/obj/structure/roguemachine/vaultbank/update_icon()
	if(drilling)
		return
	var/datum/fund/F = get_linked_fund()
	if(!F || !F.balance)
		icon_state = "[initial(icon_state)]_empty"
	else
		icon_state = initial(icon_state)

	..()

/obj/structure/roguemachine/vaultbank/proc/feedme(obj/structure/roguemachine/vaultbank)
	feedme = rand(1,12)

	if(!prob(50))
		return

	switch(feedme)
		if(1)
			src.say("MORE. MORE. MORE.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(2)
			src.say("I WILL KEEP IT SAFE.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(3)
			src.say("I WILL TREASURE THAT.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(4)
			src.say("MORE FOR THE DUCHY. MORE FOR ME.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(5)
			src.say("TENS, HUNDREDS, THOUSANDS.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(6)
			src.say("THERE IS NO SAFER PLACE FOR IT.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(7)
			src.say("I'M AROUND YOUR BEST INTEREST.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(8)
			src.say("IT WILL NEVER BE ENOUGH.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(9)
			src.say("ANOTHER HANDFUL. ANOTHER ZENNY.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(10)
			src.say("A LITTLE RICHER. NONE THE POORER.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		if(11)
			src.say("EARNINGS SAVED. EARNINGS GIVEN.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		else
			src.say("YOUR TREASURED TREASURY. ALWAYS SAFE WITH ME.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)


/obj/structure/roguemachine/vaultbank/proc/whine(obj/structure/roguemachine/vaultbank)
	whineline = rand(1,12)

	if(!prob(50))
		return

	switch(whineline)
		if(1)
			src.say("YOU SWING LIKE A PAUPER.")
			playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
		if(2)
			src.say("I AM TELLING THE NERVEMASTER.")
			playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
		if(3)
			src.say("THEY'LL HEAR YOU.")
			playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
		if(4)
			src.say("STOP THAT.")
			playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
		if(5)
			src.say("THAT IS THE DUCHY'S COIN.")
			playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
		if(6)
			src.say("YOU LOWLYFE.")
			playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
		if(7)
			src.say("THAT'S NOT YOURS.")
			playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
		if(8)
			src.say("THIS ISN'T A PROPER WITHDRAWAL.")
			playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
		if(9)
			src.say("I AM INSURED FOR THIS. ARE YOU?")
			playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
		if(10)
			src.say("YOU WON'T BREAK THIS BANK.")
			playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
		if(11)
			src.say("KEEP TRYING.")
			playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)
		else
			src.say("QUIT IT.")
			playsound(src, 'sound/misc/gold_license.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/vaultbank/proc/anguish(obj/structure/roguemachine/vaultbank)
	anguish = rand(1,12)

	if(!prob(50))
		return

	switch(anguish)
		if(1)
			src.say("NO MORE OF THIS.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
		if(2)
			src.say("GIVE IT UP.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
		if(3)
			src.say("THE TREASURY REMAINS.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
		if(4)
			src.say("I STAY PUT.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
		if(5)
			src.say("CEASE.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
		if(6)
			src.say("LEAVE.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
		if(7)
			src.say("GO AWAY.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
		if(8)
			src.say("THEFT.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
		if(9)
			src.say("BE SMARTER THAN THIS.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
		if(10)
			src.say("YOU'RE A FOOL.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
		if(11)
			src.say("WHEN DOES THIS END?")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
		else
			src.say("NOT YOUR COIN.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)

/obj/structure/roguemachine/vaultbank/proc/resetlump(obj/structure/roguemachine/vaultbank)
	og_treasury = null
	total_extorted = null
	hits_since_lump = 0
	update_icon()

/obj/structure/roguemachine/vaultbank/proc/gethit(obj/structure/roguemachine/vaultbank)
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+2, time = 0.5)
	animate(pixel_x = oldx-2, time = 0.5)
	animate(pixel_x = oldx, time = 0.5)

/obj/structure/roguemachine/vaultbank/proc/shaking(obj/structure/roguemachine/vaultbank)
	var/oldx = pixel_x
	animate(src, pixel_x = oldx+1, time = 0.5)
	animate(pixel_x = oldx-1, time = 0.5)
	animate(pixel_x = oldx, time = 0.5)
	if(shaker == TRUE)
		spawn(2)
			shaking(src)

/obj/structure/roguemachine/vaultbank/proc/drill(obj/structure/roguemachine/vaultbank)
	if(!drilling)
		return
	var/datum/fund/F = get_linked_fund()
	if(!F)
		drilling = FALSE
		return
	if(drilltime >= drillgoal) // Our timer's cap. Drillgoal is the number we're aiming for.
		new /obj/item/coveter(loc)
		loc.visible_message(span_warning("The [src] hisses open, <b>finally broken.</b>"))
		playsound(src, 'sound/misc/DrillDone.ogg', 70, TRUE)
		icon_state = "[initial(icon_state)]_empty"
		var/turf/T = get_turf(src)
		var/full_drain = F.balance
		budget2change(full_drain, custom_turf = T)
		SStreasury.burn(F, full_drain, "Vaultbank fully drilled")
		playsound(src, 'sound/misc/jawbankhit.ogg', 70, TRUE)
		shaker = FALSE
		drilling = FALSE
		has_reported = FALSE
		knockitoff = 0 // Reset the knock counter.
		knockedoffbefore = 0 // And reset this, too.
		drilltime = 0 // Reset the timer, they broke it open.
		return
	var/doneness = round(drilltime / drillgoal * 100)
	if(F.balance == 0)
		drilltime = drillgoal
		drill(src)
	loc.visible_message(span_warning("A horrible scraping sound emanates from the Crown as it does its work... (<b>[doneness]%</b>)"))
	if(!has_reported)
		if(F.balance >= 3000) // Adjustable. Mainly for GROSS WEALTH.
			if(drilltime >= 50) // Adjust this as you like. Currently, it'll alert once half-way done.
				src.say("DUCHY ALERTED.")
				playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
				send_ooc_note("A parasite of the Freefolk is breaking [src]! Location: [alert_location]", job = alert_jobs)
				has_reported = TRUE
		else
			src.say("DUCHY ALERTED.")
			playsound(src, 'sound/misc/jawbankanguish.ogg', 100, FALSE, -1)
			send_ooc_note("A parasite of the Freefolk is breaking [src]! Location: [alert_location]", job = alert_jobs)
			has_reported = TRUE

	playsound(src, 'sound/misc/TheDrill.ogg', 50, TRUE)
	spawn(100) // The time it takes to complete an interval. If you adjust this, please adjust the sound too. It's 'about' perfect at 100. Anything less It'll start overlapping.
		var/datum/fund/F2 = get_linked_fund()
		if(!F2)
			return
		var/taken = min(rand(5, 20), F2.balance)
		anguish()
		var/turf/T = get_turf(src)
		budget2change(taken, custom_turf = T)
		SStreasury.burn(F2, taken, "Vaultbank drill tick")
		visible_message(span_danger("The Crown just drilled [taken] mammon out of [src]!"))
		drilltime += 3 // Adjust this to increase or decrease how long it'll take to drill open.
		drill(src)

/obj/structure/roguemachine/vaultbank/attackby(obj/item/I, mob/living/user, params)
	. = ..()
	var/datum/fund/F = get_linked_fund()
	if(!F)
		to_chat(user, span_warning("[src] sits inert - its coffers are unbound. Notify staff."))
		return
	if(istype(I, /obj/item/coveter))
		var/mob/living/carbon/human/H = user
		if(!HAS_TRAIT(H, TRAIT_FREEMAN))
			to_chat(user, "<font color='red'>I don't know what I'm doing with this thing!</font>")
			return
		if(F.balance < 50)
			to_chat(user, "<font color='red'>These fools are completely broke. We'll get nothing out of this...</font>")
			return
		user.visible_message(span_warning("[user] is mounting the Crown onto [src]!"))
		if(!do_after(user, 5 SECONDS))
			return
		if(F.balance >= 3000 | !has_reported | !knockedoffbefore)
			loc.visible_message(span_notice("The amount of coin within the treasury slows down [src]'s reaction time!"))
		if(drilling)
			return
		user.visible_message(span_warning("[user] mounts the Crown atop [src]!"))
		icon_state = "[initial(icon_state)]_crown"
		has_reported = FALSE
		drilling = TRUE
		shaker = TRUE
		shaking(src)
		drill(src)
		qdel(I)
		message_admins("[usr.key] has applied the Crustacean to [src].")
		return

	if(istype(I, /obj/item/roguecoin/aalloy))
		return
	if(istype(I, /obj/item/roguecoin/inqcoin))
		return
	if(istype(I, /obj/item/roguecoin))
		var/value = I.get_real_price()
		user.visible_message(span_notice("[user] inserts [value] mammon into [src]."))
		SStreasury.mint(F, value, "JAWBANK Deposit")
		update_icon()
		qdel(I)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		feedme()
		return

	if (!istype(I, /obj/item/rogueweapon))
		return

	user.changeNext_move(CLICK_CD_INTENTCAP)
	gethit(src)
	if (drilling)
		playsound(src, 'sound/misc/drillhit.ogg', 70, TRUE)
		knockitoff += 1
		visible_message(span_info("The covetous crab is knocked slightly more loose from [src]! <b>[knockitoff]</b>!"))
		if(knockitoff >= 10) // DISMOUNT THAT CRAB
			playsound(src, 'sound/misc/bug.ogg', 70, TRUE)
			message_admins("[usr.key] has knocked the Crustacean off of [src].")
			visible_message(span_warning("The crab falls off of [src]!"))
			knockedoffbefore = 1
			new /obj/item/coveter(loc)
			icon_state = "[initial(icon_state)]"
			knockitoff = 0
			drilling = FALSE
			shaker = FALSE
		return

	addtimer(CALLBACK(src, PROC_REF(resetlump)), 1 MINUTES, TIMER_UNIQUE | TIMER_OVERRIDE)

	var/bashable = max(0, F.balance - bash_floor)
	if(bashable <= 0)
		playsound(src, 'sound/misc/machineno.ogg', 70, TRUE)
		src.say("YOU'VE TAKEN ENOUGH.")
		return

	var/extorted = round(I.force * MAMMON_PER_FORCE * rand(60, 140) / 100)
	extorted = max(extorted, 1)
	extorted = min(extorted, bashable)

	playsound(src, 'sound/misc/jawbankhit.ogg', 70, TRUE)
	var/turf/budget_turf = get_turf(src)
	budget2change(extorted, custom_turf = budget_turf)
	SStreasury.burn(F, extorted, "Vaultbank knock-loose")
	visible_message(span_danger("[src] coughed up [extorted] mammon!"))
	playsound(src, 'sound/misc/coindispense.ogg', 70, TRUE)
	announce_robbery(extorted)
	total_extorted += extorted
	hits_since_lump += 1
	whine()

	if(hits_since_lump >= lump_hit_threshold)
		hits_since_lump = 0
		var/post_hit_bashable = max(0, F.balance - bash_floor)
		if(post_hit_bashable <= 0)
			return
		var/lumpsum = min(lump_payout, post_hit_bashable)
		budget2change(lumpsum, custom_turf = budget_turf)
		SStreasury.burn(F, lumpsum, "Vaultbank knock-loose lump-sum")
		visible_message(span_notice("[src] just spat up a total of [lumpsum] mammon - <b>A lump sum!</b>"))
		playsound(src, 'sound/misc/coindispense.ogg', 70, TRUE)
		anguish()
		announce_robbery(lumpsum)
		send_ooc_note("Someone knocked a lump-sum loose from [src] at [alert_location]!", job = alert_jobs)

	update_icon()
	return ..()

/obj/structure/roguemachine/vaultbank/examine(mob/user)
	. += ..()
	var/datum/fund/F = get_linked_fund()
	if(F)
		. += span_notice("[F.name] currently sits at: [F.balance] mammon.")
	else
		. += span_warning("This jawbank is unbound to any treasury. Notify staff.")
	. += span_info("Only [get_authority_label()] may withdraw or draft writs of loan from this jawbank.")
	. += span_info("Strike it with any weapon to throttle coins loose - heavier strikes are louder and more reliable. The whole realm hears the chime when coin spills.")

/obj/structure/roguemachine/vaultbank/proc/get_authority_label()
	return "the Steward, Clerk, Grand Duke, or Regent"

/obj/structure/roguemachine/vaultbank/proc/announce_robbery(amount)
	loud_message("A loud clattering of coins spilling onto stone echoes", hearing_distance = 14)

/obj/structure/roguemachine/vaultbank/proc/can_issue_loan(mob/user)
	if(!user)
		return FALSE
	if(user.job == "Steward" || user.job == "Clerk" || user.job == "Grand Duke")
		return TRUE
	if(SSticker.regentmob && user == SSticker.regentmob)
		return TRUE
	return FALSE

/obj/structure/roguemachine/vaultbank/proc/can_withdraw(mob/user, amount)
	return can_issue_loan(user)

/obj/structure/roguemachine/vaultbank/proc/can_accept_indenture(mob/user)
	return can_issue_loan(user)

/obj/structure/roguemachine/vaultbank/proc/get_faction_label()
	return "the Crown"

/obj/structure/roguemachine/vaultbank/attack_hand(mob/user)
	if(!can_issue_loan(user))
		return ..()
	if(!user.canUseTopic(src, BE_CLOSE))
		return ..()
	open_management_tgui(user)

/obj/structure/roguemachine/vaultbank/proc/open_management_tgui(mob/user)
	var/datum/tgui/ui = SStgui.try_update_ui(user, src, null)
	if(!ui)
		ui = new(user, src, "JawbankPanel")
		ui.open()

/obj/structure/roguemachine/vaultbank/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/vaultbank/ui_interact(mob/user, datum/tgui/ui)
	SStgui.try_update_ui(user, src, ui)

/obj/structure/roguemachine/vaultbank/ui_static_data(mob/user)
	var/list/data = list()
	data["fund_name"] = get_linked_fund()?.name || "Unbound"
	data["fund_id"] = get_fund_id()
	data["faction_label"] = get_faction_label()
	data["bash_floor"] = bash_floor
	return data

/obj/structure/roguemachine/vaultbank/ui_data(mob/user)
	var/list/data = list()
	var/datum/fund/F = get_linked_fund()
	data["balance"] = F?.balance || 0
	data["can_withdraw"] = can_withdraw(user) ? TRUE : FALSE
	data["can_issue_loan"] = can_issue_loan(user) ? TRUE : FALSE
	data["can_accept_indenture"] = can_accept_indenture(user) ? TRUE : FALSE
	data["day"] = GLOB.dayspassed
	data["max_issuance_day"] = SStreasury.loan_max_issuance_day
	return data

/obj/structure/roguemachine/vaultbank/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(!can_issue_loan(usr))
		return TRUE
	if(!usr.canUseTopic(src, BE_CLOSE))
		return TRUE
	switch(action)
		if("withdraw")
			return TRUE
		if("issue_personal")
			return TRUE
		if("issue_indenture")
			return TRUE

/obj/structure/roguemachine/vaultbank/church
	name = "\improper CHURCH JAWBANK"
	desc = "A biomechanical obselisk that hoards the alms and indulgences of Eora's faithful. Throttle it with a strike to spill that which is rightfully yours."
	alert_jobs = list("Bishop", "Martyr", "Acolyte")
	alert_location = "the Church"
	bash_floor = 500
	lump_payout = 100

/obj/structure/roguemachine/vaultbank/church/get_fund_id()
	return "church"

/obj/structure/roguemachine/vaultbank/church/get_faction_label()
	return "the Church of Azuria"

/obj/structure/roguemachine/vaultbank/church/can_issue_loan(mob/user)
	if(!user)
		return FALSE
	return user.job == "Bishop" || user.job == "Martyr"

/obj/structure/roguemachine/vaultbank/church/get_authority_label()
	return "the Bishop or Martyr"

/obj/structure/roguemachine/vaultbank/church/enforce_placement()
	return

/obj/structure/roguemachine/vaultbank/merchant
	name = "\improper MERCHANT JAWBANK"
	desc = "A biomechanical obselisk that secures the coffers of the Azurian Trading Company. Throttle it with a strike to spill that which is rightfully yours."
	alert_jobs = list("Merchant", "Shophand")
	alert_location = "the Merchant's quarter"
	bash_floor = 500
	lump_payout = 100

/obj/structure/roguemachine/vaultbank/merchant/get_fund_id()
	return "merchant"

/obj/structure/roguemachine/vaultbank/merchant/get_faction_label()
	return "the Azurian Trading Company"

/obj/structure/roguemachine/vaultbank/merchant/can_issue_loan(mob/user)
	if(!user)
		return FALSE
	return user.job == "Merchant"

/obj/structure/roguemachine/vaultbank/merchant/get_authority_label()
	return "the Merchant"

/obj/structure/roguemachine/vaultbank/merchant/enforce_placement()
	return

/obj/structure/roguemachine/vaultbank/bathhouse
	name = "\improper BATHHOUSE JAWBANK"
	desc = "A biomechanical obselisk that secures the takings of the Azurian Bathhouse. Throttle it with a strike to spill that which is rightfully yours."
	alert_jobs = list("Bathmaster", "Bathhouse Attendant")
	alert_location = "the Bathhouse"
	bash_floor = 500
	lump_payout = 100

/obj/structure/roguemachine/vaultbank/bathhouse/get_fund_id()
	return "bathhouse"

/obj/structure/roguemachine/vaultbank/bathhouse/get_faction_label()
	return "the Bathhouse"

/obj/structure/roguemachine/vaultbank/bathhouse/can_issue_loan(mob/user)
	if(!user)
		return FALSE
	return user.job == "Bathmaster"

/obj/structure/roguemachine/vaultbank/bathhouse/get_authority_label()
	return "the Bathmaster"

/obj/structure/roguemachine/vaultbank/bathhouse/enforce_placement()
	return

#undef MAMMON_PER_FORCE
