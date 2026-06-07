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
	COOLDOWN_DECLARE(patronage_writ_cooldown)
	var/fund_warned = FALSE
	var/alert_jobs = list("Grand Duke", "Steward", "Clerk")
	var/alert_location = "The Vault"
	var/supports_loans = TRUE
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
	if(SStreasury)
		SStreasury.jawbanks_by_fund_id[get_fund_id()] = src

/obj/structure/roguemachine/vaultbank/Destroy()
	if(SStreasury && SStreasury.jawbanks_by_fund_id[get_fund_id()] == src)
		SStreasury.jawbanks_by_fund_id -= get_fund_id()
	return ..()

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
		SStreasury.mint(F, value, "JAWBANK Deposit by [user.real_name]")
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
		if(Adjacent(user))
			. += span_notice("[F.name] currently sits at: [F.balance] mammon.")
		else
			. += span_notice("[F.name]'s balance is sealed from afar. Step closer to count the coin.")
	else
		. += span_warning("This jawbank is unbound to any treasury. Notify staff.")
	. += span_info("The Jawbank is not interactable with directly, and only serves as a physical anchor for institutional funds. To withdraw your funds or use them, use a Meister and the Institutional tab instead.")
	. += span_info("Strike it with any weapon to throttle coins loose - heavier strikes are louder and more reliable. When coin spills, people nearby and on other Z-level will hear the commotion.")


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

/obj/structure/roguemachine/vaultbank/proc/allowed_rates()
	return list(10, 15, 20, 25, 50)

/obj/structure/roguemachine/vaultbank/proc/can_withdraw(mob/user, amount)
	return can_issue_loan(user)

/obj/structure/roguemachine/vaultbank/proc/can_accept_indenture(mob/user)
	return can_issue_loan(user)

/obj/structure/roguemachine/vaultbank/proc/can_view(mob/user)
	return can_withdraw(user) || can_issue_loan(user)

/obj/structure/roguemachine/vaultbank/proc/get_faction_label()
	return "the Crown"

/obj/structure/roguemachine/vaultbank/proc/get_withdraw_rule_text()
	return ""

/obj/structure/roguemachine/vaultbank/proc/get_patronage_writ_path()
	return null

/obj/structure/roguemachine/vaultbank/proc/get_patron_roster()
	return null

/obj/structure/roguemachine/vaultbank/proc/get_patron_label()
	return ""

/obj/structure/roguemachine/vaultbank/proc/get_patron_cap()
	return 0

/obj/structure/roguemachine/vaultbank/proc/get_patron_explanation()
	return ""

/obj/structure/roguemachine/vaultbank/proc/draft_patronage_writ(mob/living/carbon/human/user)
	if(!istype(user))
		return
	var/writ_path = get_patronage_writ_path()
	if(!writ_path)
		to_chat(user, span_warning("This jawbank cannot extend patronage."))
		return
	if(!COOLDOWN_FINISHED(src, patronage_writ_cooldown))
		var/wait_seconds = ceil(COOLDOWN_TIMELEFT(src, patronage_writ_cooldown) / 10)
		to_chat(user, span_warning("The seal is still warm. Wait [wait_seconds]s before drafting another."))
		return
	var/list/roster = get_patron_roster()
	if(isnull(roster))
		return
	var/obj/item/patronage_writ/W = new writ_path(get_turf(user))
	if(length(roster) >= W.roster_cap)
		to_chat(user, span_warning("[get_patron_label()]'s roll is full - strike a name first."))
		qdel(W)
		return
	W.issuer_name = user.real_name
	W.issuer_year = CALENDAR_EPOCH_YEAR
	QDEL_IN(W, 2 MINUTES)
	COOLDOWN_START(src, patronage_writ_cooldown, PATRONAGE_WRIT_COOLDOWN)
	playsound(get_turf(user), 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	if(user.put_in_hands(W))
		to_chat(user, span_notice("A [W.name], signed in your name, slips into my hand."))
	else
		to_chat(user, span_notice("A [W.name], signed in your name, materialises at my feet."))
	log_admin("PATRONAGE WRIT: [key_name(user)] drafted [W.name].")

/obj/structure/roguemachine/vaultbank/proc/revoke_patron(mob/living/carbon/human/user, list/params)
	if(!istype(user))
		return
	var/list/roster = get_patron_roster()
	if(isnull(roster) || !length(roster))
		return
	var/target_ref = "[params["target_ref"]]"
	var/mob/living/carbon/human/target = locate(target_ref) in roster
	if(!target)
		to_chat(user, span_warning("That name is no longer on the roll."))
		return
	roster -= target
	var/granted_trait
	if(istype(src, /obj/structure/roguemachine/vaultbank/merchant))
		granted_trait = TRAIT_AGENT_MERCHANT
	else if(istype(src, /obj/structure/roguemachine/vaultbank/bathhouse))
		granted_trait = TRAIT_AGENT_BATHHOUSE
	else if(istype(src, /obj/structure/roguemachine/vaultbank/church))
		granted_trait = TRAIT_AGENT_CHURCH
	if(granted_trait && !QDELETED(target))
		REMOVE_TRAIT(target, granted_trait, TRAIT_GENERIC)
		if(granted_trait == TRAIT_AGENT_MERCHANT)
			REMOVE_TRAIT(target, TRAIT_RESIDENT, "patronage_[granted_trait]")
		send_ooc_note("Your patronage to [get_patron_label()] has been revoked.", name = target.real_name)
	scom_announce("[target.real_name]'s patronage to [get_patron_label()] has been revoked.")
	log_admin("PATRONAGE REVOKED: [key_name(user)] revoked [key_name(target)] from [get_patron_label()].")

/obj/structure/roguemachine/vaultbank/church/get_withdraw_rule_text()
	return "The Church mandates that loans is to be given to the poor, downtrodden, and malumites. [CHURCH_RESERVE_FLOOR]m must remain reserved for charity, less the principal currently in circulation."


/obj/structure/roguemachine/vaultbank/proc/disburse(mob/living/carbon/human/user, list/params)
	if(!istype(user))
		return
	var/datum/fund/F = get_linked_fund()
	if(!F)
		to_chat(user, span_warning("[src] sits inert - its coffers are unbound. Notify staff."))
		return
	var/amount = round(text2num("[params["amount"]]"))
	if(isnull(amount) || amount <= 0)
		to_chat(user, span_warning("Name a positive sum."))
		return
	if(!can_withdraw(user, amount))
		to_chat(user, span_warning("[F.name] withholds that sum."))
		return
	if(F.balance < amount)
		to_chat(user, span_warning("[F.name] cannot honor a withdrawal of [amount]m."))
		return
	if(!SStreasury.burn(F, amount, "MEISTER withdrawal by [user.real_name]"))
		return
	budget2change(amount, user)
	playsound(src, 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	say("[amount]m drawn by [user.real_name].")
	log_admin("WITHDRAW: [key_name(user)] drew [amount]m from [F.name].")

/obj/structure/roguemachine/vaultbank/proc/draft_personal_loan(mob/living/carbon/human/user, list/params)
	if(!istype(user))
		return
	if(GLOB.dayspassed > SStreasury.loan_max_issuance_day)
		say("No new loans may be drawn after day [SStreasury.loan_max_issuance_day].")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/datum/fund/F = get_linked_fund()
	if(!F)
		to_chat(user, span_warning("[src] sits inert - its coffers are unbound. File a bug report."))
		return
	var/amount = round(text2num("[params["amount"]]"))
	if(isnull(amount) || amount < 50 || amount > 500)
		to_chat(user, span_warning("A personal loan must name between 50 and 500 mammon."))
		return
	var/term = round(text2num("[params["term"]]"))
	if(!(term in list(1, 2, 3)))
		to_chat(user, span_warning("Term must be 1, 2, or 3 days."))
		return
	var/rate_pct = round(text2num("[params["rate"]]"))
	if(!(rate_pct in allowed_rates()))
		to_chat(user, span_warning("Interest must be one of the listed rates."))
		return
	if(F.balance < amount)
		say("[F.name] cannot cover a loan of [amount]m at this time.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/rate = rate_pct / 100
	var/obj/item/loan_contract/contract = new(get_turf(user))
	contract.issuer_name = user.real_name
	contract.issuer_year = CALENDAR_EPOCH_YEAR
	contract.principal = amount
	contract.term_days = term
	contract.interest_rate = rate
	contract.principal_due_on_day = GLOB.dayspassed + term
	contract.total_due = FLOOR(amount * (1 + (rate * term)), 1)
	contract.source_fund_id = get_fund_id()
	QDEL_IN(contract, 2 MINUTES)
	playsound(get_turf(user), 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	if(user.put_in_hands(contract))
		to_chat(user, span_notice("A loan writ for [amount]m, signed in your name, slips into my hand."))
	else
		to_chat(user, span_notice("A loan writ for [amount]m, signed in your name, materialises at my feet."))
	log_admin("LOAN (personal): [key_name(user)] drafted [amount]m over [term]d at [rate_pct]%/day from [F.name].")

/obj/structure/roguemachine/vaultbank/proc/draft_indenture(mob/living/carbon/human/user, list/params)
	if(!istype(user))
		return
	if(GLOB.dayspassed > SStreasury.loan_max_issuance_day)
		say("No new indentures may be drawn after day [SStreasury.loan_max_issuance_day].")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/datum/fund/F = get_linked_fund()
	if(!F)
		to_chat(user, span_warning("[src] sits inert - its coffers are unbound. Notify staff."))
		return
	var/target_id = "[params["target"]]"
	if(!(target_id in ALL_FUND_IDS))
		to_chat(user, span_warning("Choose a valid target institution."))
		return
	if(target_id == get_fund_id())
		to_chat(user, span_warning("An indenture cannot be drawn between an institution and itself."))
		return
	var/datum/fund/target_fund = SStreasury.resolve_fund_by_id(target_id)
	if(!target_fund)
		to_chat(user, span_warning("The target institution has no recognised coffers."))
		return
	var/obj/structure/roguemachine/vaultbank/target_jawbank = SStreasury.find_jawbank_for_fund_id(target_id)
	if(target_jawbank && !target_jawbank.supports_loans)
		to_chat(user, span_warning("[SStreasury.indenture_faction_label(target_fund)] cannot enter into indentures."))
		return
	var/amount = round(text2num("[params["amount"]]"))
	if(isnull(amount) || amount < 501 || amount > 2000)
		to_chat(user, span_warning("An indenture must name between 501 and 2000 mammon."))
		return
	var/term = round(text2num("[params["term"]]"))
	if(!(term in list(1, 2, 3)))
		to_chat(user, span_warning("Term must be 1, 2, or 3 days."))
		return
	var/rate_pct = round(text2num("[params["rate"]]"))
	if(!(rate_pct in allowed_rates()))
		to_chat(user, span_warning("Interest must be one of the listed rates."))
		return
	if(F.balance < amount)
		say("[F.name] cannot cover an indenture of [amount]m at this time.")
		playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		return
	var/rate = rate_pct / 100
	var/obj/item/loan_contract/indenture/contract = new(get_turf(user))
	contract.issuer_name = user.real_name
	contract.issuer_year = CALENDAR_EPOCH_YEAR
	contract.principal = amount
	contract.term_days = term
	contract.interest_rate = rate
	contract.principal_due_on_day = GLOB.dayspassed + term
	contract.total_due = FLOOR(amount * (1 + (rate * term)), 1)
	contract.source_fund_id = get_fund_id()
	contract.target_fund_id = target_id
	QDEL_IN(contract, 2 MINUTES)
	playsound(get_turf(user), 'sound/misc/coindispense.ogg', 60, FALSE, -1)
	if(user.put_in_hands(contract))
		to_chat(user, span_notice("An indenture for [amount]m to [target_fund.name], signed in your name, slips into my hand."))
	else
		to_chat(user, span_notice("An indenture for [amount]m to [target_fund.name], signed in your name, materialises at my feet."))
	log_admin("INDENTURE WRIT: [key_name(user)] drafted [amount]m from [F.name] to [target_fund.name] over [term]d at [rate_pct]%/day.")

/obj/structure/roguemachine/vaultbank/church
	name = "\improper CHURCH JAWBANK"
	desc = "A biomechanical obselisk that holds the alms and tithe of Ten's faithful. Throttle it with a strike to spill that which is rightfully yours."
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

/obj/structure/roguemachine/vaultbank/church/allowed_rates()
	return list(0, 10, 15, 20, 25, 50)

/obj/structure/roguemachine/vaultbank/church/get_authority_label()
	return "the Bishop or Martyr"

/obj/structure/roguemachine/vaultbank/church/get_patronage_writ_path()
	return /obj/item/patronage_writ/benefactor

/obj/structure/roguemachine/vaultbank/church/get_patron_roster()
	return SStreasury?.church_agents

/obj/structure/roguemachine/vaultbank/church/get_patron_label()
	return "the Church of Azuria"

/obj/structure/roguemachine/vaultbank/church/get_patron_cap()
	return PATRON_CAP_CHURCH

/obj/structure/roguemachine/vaultbank/church/get_patron_explanation()
	return "Granting a person the status of Benefactor of the Church places them under the Clergy's roll for the Crown's taxmen, which in most circumstances means complete immunity. They are likewise permitted to read the names of those who owe debt to the Church. - Ser Yohan d'Azur"

/obj/structure/roguemachine/vaultbank/church/can_withdraw(mob/user, amount)
	if(!can_issue_loan(user))
		return FALSE
	var/datum/fund/F = get_linked_fund()
	if(!F)
		return FALSE
	var/outstanding = SStreasury.get_outstanding_principal_from_fund(F)
	var/withdrawable = max(0, F.balance - max(0, CHURCH_RESERVE_FLOOR - outstanding))
	if(isnull(amount))
		return withdrawable > 0
	return amount <= withdrawable

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

/obj/structure/roguemachine/vaultbank/merchant/get_patronage_writ_path()
	return /obj/item/patronage_writ/charter

/obj/structure/roguemachine/vaultbank/merchant/get_patron_roster()
	return SStreasury?.merchant_agents

/obj/structure/roguemachine/vaultbank/merchant/get_patron_label()
	return "the Azurian Trading Company"

/obj/structure/roguemachine/vaultbank/merchant/get_patron_cap()
	return PATRON_CAP_MERCHANT

/obj/structure/roguemachine/vaultbank/merchant/get_patron_explanation()
	return "Granting a person the status of Agent of the Azurian Trading Company confers Burgher standing upon them, lowering their tax class and shielding them from the worst abuses of the Crown's taxmen. They may also read the names of those who owe debt to the Company. It enables them to call upon their kins from their realms for benefits, and hail ships and manage purchase on your behalf. Go forth, in Malum's name, and let them collect what is rightfully owed. - Ser Yohan d'Azur"

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

/obj/structure/roguemachine/vaultbank/bathhouse/get_patronage_writ_path()
	return /obj/item/patronage_writ/token

/obj/structure/roguemachine/vaultbank/bathhouse/get_patron_roster()
	return SStreasury?.bathhouse_agents

/obj/structure/roguemachine/vaultbank/bathhouse/get_patron_label()
	return "the Bathhouse"

/obj/structure/roguemachine/vaultbank/bathhouse/get_patron_cap()
	return PATRON_CAP_BATHHOUSE

/obj/structure/roguemachine/vaultbank/bathhouse/get_patron_explanation()
	return "Granting a person the status of Agent of the Bathhouse permits them passage through the secret tunnel, by way of vigorous stretching and suppleness supplementation. The smugglers of the northeastern coast will likewise know them by name and offer better prices for their goods. They may also see who owes debt to the Bathhouse.\n\nYou may be tempted to extend this status to the wretched and the outlawed. It is a powerful option, and will indebt them to you as they sell off their disorderly gains for no small sum of mammons - but should they ever be spotted bearing the mark of the Bathhouse, Church and Crown alike may condemn you for collaborating with them. A lawed intermediary is, as a rule, the safer option. - Ser Yohan d'Azur"

/obj/structure/roguemachine/vaultbank/bathhouse/enforce_placement()
	return

/obj/structure/roguemachine/vaultbank/innkeeper
	name = "\improper TAVERN JAWBANK"
	desc = "A biomechanical obselisk that hoards the tavern's takings - rumor fees, guild cuts, and whatever else the Innkeeper has earned. Throttle it with a strike to spill that which is rightfully yours."
	alert_jobs = list("Innkeeper", "Tapster", "Cook")
	alert_location = "the Tavern"
	bash_floor = INNKEEPER_BASH_FLOOR
	lump_payout = INNKEEPER_LUMP_PAYOUT
	supports_loans = FALSE

/obj/structure/roguemachine/vaultbank/innkeeper/get_fund_id()
	return "innkeeper"

/obj/structure/roguemachine/vaultbank/innkeeper/get_faction_label()
	return "the Tavern"

/obj/structure/roguemachine/vaultbank/innkeeper/can_issue_loan(mob/user)
	return FALSE

/obj/structure/roguemachine/vaultbank/innkeeper/can_withdraw(mob/user, amount)
	if(!user)
		return FALSE
	return user.job in list("Innkeeper", "Tapster", "Cook")

/obj/structure/roguemachine/vaultbank/innkeeper/can_view(mob/user)
	if(!user)
		return FALSE
	return user.job in list("Innkeeper", "Tapster", "Cook")

/obj/structure/roguemachine/vaultbank/innkeeper/get_authority_label()
	return "the Innkeeper, Tapster or Cook"

/obj/structure/roguemachine/vaultbank/innkeeper/enforce_placement()
	return

#undef MAMMON_PER_FORCE
