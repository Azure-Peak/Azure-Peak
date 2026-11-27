/obj/structure/roguemachine/steward
	name = "nerve master"
	desc = "A magitech device connected to the arteries of Azuria's royal treasury. When unlocked with the proper key, it can sway the fate of an entire kingdom's \
	finances. Stewards traditionally use these machines to export stockpiled goods for coinage, to pay-and-tax all accounts registered through the MEISTER, and to \
	import supplies for taskings-a-plenty."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "steward_machine"
	density = TRUE
	blade_dulling = DULLING_BASH
	max_integrity = 0
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
	var/locked = FALSE
	var/keycontrol = "steward"
	var/datum/steward_front_panel/front_panel
	var/datum/steward_treasury_panel/treasury_panel
	var/list/excluded_jobs = list("Wretch","Vagabond","Adventurer")
	var/list/daily_payments = list()
	var/residency_print_cooldown = 0
	var/datum/steward_ledger_panel/ledger_panel
	var/list/petition_view = list()
	var/list/caravan_view = list()
	var/list/caravan_sell = list()

/obj/structure/roguemachine/steward/Initialize(mapload)
	. = ..()
	if(SStreasury.steward_machine == null) //The "only one" mapped in Nerve Master at map start
		SStreasury.steward_machine = src
	setup_default_payments()

/obj/structure/roguemachine/steward/Destroy()
	QDEL_NULL(front_panel)
	QDEL_NULL(treasury_panel)
	QDEL_NULL(ledger_panel)
	return ..()

//	For competence of life I will allow you,
//	That lack of means enforce you not to evil:
/obj/structure/roguemachine/steward/proc/setup_default_payments()
	daily_payments["Marshal"] = 60 //Garrison
	daily_payments["Knight"] = 40
	daily_payments["Sergeant"] = 40
	daily_payments["Man at Arms"] = 30
	daily_payments["Warden"] = 20
	daily_payments["Veteran"] = 20
	daily_payments["Squire"] = 10
	daily_payments["Seneschal"] = 40 //Manor-House
	daily_payments["Servant"] = 20
	daily_payments["Head Physician"] = 20 //Doctors
	daily_payments["Apothecary"] = 10
	daily_payments["Court Magician"] = 40 //University
	daily_payments["Archivist"] = 20
	daily_payments["Magicians Associate"] = 10
	enforce_wage_floors()

/obj/structure/roguemachine/steward/proc/enforce_wage_floors()
	for(var/job in daily_payments)
		var/floor = SStreasury.get_wage_floor(job)
		if(floor > 0 && (daily_payments[job] || 0) < floor)
			daily_payments[job] = floor
	for(var/job in SStreasury.enumerate_wage_floored_jobs())
		if(isnull(daily_payments[job]))
			daily_payments[job] = SStreasury.get_wage_floor(job)

/proc/has_fiscal_authority(mob/user)
	if(!user)
		return FALSE
	if(user.job == "Steward" || user.job == "Clerk" || user.job == "Grand Duke")
		return TRUE
	if(SSticker.regentmob && user == SSticker.regentmob)
		return TRUE
	return FALSE



/obj/structure/roguemachine/steward/attackby(obj/item/P, mob/user, params)
	if(istype(P, /obj/item/roguekey))
		var/obj/item/roguekey/K = P
		if(K.lockid == keycontrol || istype(K, /obj/item/roguekey/lord) || istype(K, /obj/item/roguekey/skeleton)) //Master key
			locked = !locked
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			(locked) ? (icon_state = "steward_machine_off") : (icon_state = "steward_machine")
			update_icon()
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
				(locked) ? (icon_state = "steward_machine_off") : (icon_state = "steward_machine")
				update_icon()
				return
		to_chat(user, span_warning("Wrong key."))
		return
	if(istype(P, /obj/item/roguecoin/aalloy))
		return
	if(istype(P, /obj/item/roguecoin/inqcoin))
		return
	if(istype(P, /obj/item/roguecoin))
		record_round_statistic(STATS_MAMMONS_DEPOSITED, P.get_real_price())
		SStreasury.mint(SStreasury.discretionary_fund, P.get_real_price(), "NERVE MASTER deposit", null, LEDGER_CROWN_REV_OTHER)
		qdel(P)
		playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
		return
	return ..()


/obj/structure/roguemachine/steward/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(locked)
		to_chat(user, span_warning("It's locked."))
		return
	user.changeNext_move(CLICK_CD_INTENTCAP)
	playsound(loc, 'sound/misc/keyboard_enter.ogg', 100, FALSE, -1)
	open_front_tgui(user)

/obj/structure/roguemachine/steward/proc/open_steward_window(mob/user, window)
	switch(window)
		if("front")
			open_front_tgui(user)
		if("trade")
			open_trade_tgui(user)
		if("treasury")
			open_treasury_tgui(user)
		if("ledger")
			open_ledger_tgui(user)

/obj/structure/roguemachine/steward/proc/push_open_windows()
	SStgui.update_uis(src)
	for(var/datum/panel as anything in list(front_panel, treasury_panel, ledger_panel))
		if(panel)
			SStgui.update_uis(panel)

/obj/structure/roguemachine/steward/proc/print_residency_letter(mob/user)
	if(world.time < residency_print_cooldown)
		say("You just printed a letter. Wait [DisplayTimeText(residency_print_cooldown - world.time)] and try again.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/obj/item/citizenry_letter/letter = new(get_turf(src))
	letter.issuer_name = user.real_name
	letter.issuer_year = CALENDAR_EPOCH_YEAR
	residency_print_cooldown = world.time + RESIDENCY_PRINT_COOLDOWN
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	say("Letter of Citizenry issued, signed by [user.real_name].")

/obj/structure/roguemachine/steward/proc/sequestration_state()
	return list(
		"active" = SStreasury.is_in_receivership() ? TRUE : FALSE,
		"in_arrears" = (SStreasury.treasury_state == TREASURY_IN_ARREARS) ? TRUE : FALSE,
		"debt" = SStreasury.treasury_debt,
		"state_label" = bankruptcy_state_label(SStreasury.treasury_state),
	)

/obj/structure/roguemachine/steward/proc/job_filter(advj, j, compact = FALSE)
	if(advj in excluded_jobs)
		return "Adventurer"
	if(j in excluded_jobs)
		return "Adventurer"
	if(compact && j)
		return j
	else if(!compact && advj && j)
		return "[j] ([advj])"
	else if(j)
		return j
	else if(advj)
		return advj
