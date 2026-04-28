/obj/structure/roguemachine/atm
	name = "MEISTER"
	desc = "A magitech apparatus with a mouth that stores and withdraws currency for accounts managed by the Grand Duchy of Azuria."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "atm"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/mammonsiphoned = 0
	var/drilling = FALSE
	var/drilled = FALSE
	var/has_reported = FALSE
	var/location_tag

/obj/structure/roguemachine/atm/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Left-click with an open hand to check your personal account. If you don't already have an account, left-clicking the MEISTER will make one for you with a single mechanical jab.")
	. += span_info("Deposits are safe from taxation. Income taxes apply at the moment mammon is earned - contract completions, headeater turn-ins, and other Crown-levied events.")

/obj/structure/roguemachine/atm/attack_hand(mob/user)
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(HAS_TRAIT(user, TRAIT_OUTLAW) || HAS_TRAIT(user, TRAIT_TECHNOPHOBE))
		if(HAS_TRAIT(user, TRAIT_OUTLAW))
			to_chat(H, span_warning("The machine rejects you, sensing your status as an outlaw in these lands."))
		else
			to_chat(H, span_warning("Why would I?"))
		return
	if(drilled)
		if(HAS_TRAIT(H, TRAIT_NOBLE))
			if(!HAS_TRAIT(H, TRAIT_FREEMAN))
				var/def_zone = "[(H.active_hand_index == 2) ? "r" : "l" ]_arm"
				playsound(src, 'sound/items/beartrap.ogg', 100, TRUE)
				to_chat(user, "<font color='red'>The meister craves my Noble blood!</font>")
				loc.visible_message(span_warning("The meister snaps onto [H]'s arm!"))
				H.Stun(80)
				H.apply_damage(50, BRUTE, def_zone)
				H.emote("agony")
				spawn(5)
				say("Blueblood for the Freefolk!")
				playsound(src, 'sound/vo/mobs/ghost/laugh (5).ogg', 100, TRUE)
				return	
	if(SStreasury.has_account(H))
		var/poll_category = SStreasury.get_poll_tax_category(H)
		var/poll_rate = poll_category ? SStreasury.get_poll_tax_rate_for(H, poll_category) : 0
		var/poll_exempt = poll_category ? SStreasury.is_poll_tax_charter_exempt(H, poll_category) : FALSE
		if(!poll_category)
			to_chat(H, span_info("<b>MEISTER:</b> There is no poll tax for your class."))
		else if(poll_exempt && poll_rate >= 0)
			to_chat(H, span_info("<b>MEISTER:</b> You are exempt from poll tax by decree."))
		else if(poll_rate > 0)
			to_chat(H, span_info("<b>MEISTER:</b> Poll tax for your class ([SStreasury.get_poll_tax_category_pretty_name(poll_category)]) is [poll_rate]m per day."))
		else if(poll_rate < 0)
			to_chat(H, span_info("<b>MEISTER:</b> The Crown extends a [-poll_rate]m daily subsidy to your class ([SStreasury.get_poll_tax_category_pretty_name(poll_category)])."))
		else
			to_chat(H, span_info("<b>MEISTER:</b> No poll tax is currently levied on your class ([SStreasury.get_poll_tax_category_pretty_name(poll_category)]). Advance payment may be made at a presumed rate of [POLL_TAX_ADVANCE_FALLBACK_RATE]m per day."))
		var/amt = SStreasury.get_balance(H)
		var/datum/loan/active_loan = SStreasury.get_loan_for(H)
		if(!amt && !active_loan)
			say("Your balance is nothing.")
			return
		if(amt < 0)
			say("Your balance is NEGATIVE.")
			return
		var/list/choicez = list()
		if(active_loan)
			if(active_loan.defaulted)
				choicez += "REPAY DEBT ([active_loan.get_remaining_due()]m owed to the Crown)"
			else
				choicez += "REPAY LOAN ([active_loan.get_remaining_due()]m due, [active_loan.days_until_due()]d left)"
		if(amt > 0 && poll_category && !poll_exempt && poll_rate >= 0)
			var/existing_advance = SStreasury.poll_tax_advance_days[H] || 0
			var/advance_rate = poll_rate > 0 ? poll_rate : POLL_TAX_ADVANCE_FALLBACK_RATE
			var/rate_suffix = poll_rate > 0 ? "m/d" : "m/d presumed"
			choicez += "ADVANCE POLL TAX ([advance_rate][rate_suffix], [existing_advance]d held)"
		if(amt > 10)
			choicez += "GOLD"
		if(amt > 5)
			choicez += "SILVER"
		if(amt > 0)
			choicez += "BRONZE"
		if(!length(choicez))
			say("Your balance is nothing.")
			return
		var/selection = input(user, "Make a Selection", src) as null|anything in choicez
		if(!selection)
			return
		if(active_loan && (copytext(selection, 1, 11) == "REPAY LOAN" || copytext(selection, 1, 11) == "REPAY DEBT"))
			if(!Adjacent(user))
				return
			// Re-resolve in case of dialog churn.
			active_loan = SStreasury.get_loan_for(H)
			if(!active_loan)
				say("No active loan on record.")
				return
			var/outstanding = active_loan.get_remaining_due()
			amt = SStreasury.get_balance(H)
			var/max_payable = min(outstanding, amt)
			if(max_payable <= 0)
				say("You have nothing to repay the loan with.")
				playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
				return
			var/pay_amt = input(user, "Repay how much? Outstanding: [outstanding]m. Your balance: [amt]m. (Maximum [max_payable]m)", src, max_payable) as null|num
			if(isnull(pay_amt))
				return
			pay_amt = round(pay_amt)
			if(pay_amt < 1)
				return
			if(!Adjacent(user))
				return
			pay_amt = min(pay_amt, max_payable)
			var/paid = SStreasury.repay_loan(H, pay_amt)
			if(!paid)
				playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
				say("The ledger refused the transfer.")
				return
			playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
			if(!SStreasury.get_loan_for(H))
				say("Loan repaid in full. [paid]m transferred to the Crown.")
			else
				var/datum/loan/still = SStreasury.get_loan_for(H)
				say("[paid]m transferred. [still.get_remaining_due()]m remains.")
			return
		if(copytext(selection, 1, 18) == "ADVANCE POLL TAX ")
			if(!Adjacent(user))
				return
			poll_category = SStreasury.get_poll_tax_category(H)
			if(!poll_category)
				say("The Crown does not tax your class.")
				return
			if(SStreasury.is_poll_tax_charter_exempt(H, poll_category))
				say("Your class is exempt from poll tax by decree.")
				return
			var/eff_rate = SStreasury.get_poll_tax_rate_for(H, poll_category)
			var/presumed_rate = FALSE
			if(eff_rate <= 0)
				// No rate set — permit advance at the presumed fallback so proactive
				// payers can settle up front even when the Crown is lazy.
				eff_rate = POLL_TAX_ADVANCE_FALLBACK_RATE
				presumed_rate = TRUE
			amt = SStreasury.get_balance(H)
			if(amt <= 0)
				say("Your balance is nothing.")
				playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
				return
			var/existing_advance = SStreasury.poll_tax_advance_days[H] || 0
			var/advance_remaining = POLL_TAX_MAX_ADVANCE_DAYS - existing_advance
			if(advance_remaining <= 0)
				say("You already hold the maximum of [POLL_TAX_MAX_ADVANCE_DAYS] days of advance.")
				playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
				return
			var/max_days = min(floor(amt / eff_rate), advance_remaining)
			if(max_days < 1)
				say("You cannot afford a single day at [eff_rate]m.")
				playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
				return
			var/days_to_advance = input(user, "Pay advance on how many days of poll tax? ([eff_rate]m/d[presumed_rate ? " presumed" : ""]) Your balance: [amt]m. (Maximum [max_days] day[max_days == 1 ? "" : "s"]; cap of [POLL_TAX_MAX_ADVANCE_DAYS] days of advance, you hold [existing_advance].)", src, max_days) as null|num
			if(isnull(days_to_advance))
				return
			days_to_advance = round(days_to_advance)
			if(days_to_advance < 1)
				return
			if(!Adjacent(user))
				return
			days_to_advance = min(days_to_advance, max_days)
			if(!SStreasury.poll_tax_pay_advance(H, days_to_advance))
				playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
				say("The ledger refused the advance.")
				return
			playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
			say("[days_to_advance] day[days_to_advance == 1 ? "" : "s"] of Poll Tax advanced for [H.real_name].")
			return
		amt = SStreasury.get_balance(H)
		var/mod = 1
		if(selection == "GOLD")
			mod = 10
		if(selection == "SILVER")
			mod = 5
		var/coin_amt = input(user, "There is [SStreasury.discretionary_fund.balance] mammon in the treasury. You may withdraw [floor(amt/mod)] [selection] COINS from your account.", src) as null|num
		coin_amt = round(coin_amt)
		if(coin_amt < 1)
			return
		// checks the maximum coin limit before deducting balance; prevents stacks of >=20
		var/max_coins = 20
		if(coin_amt > max_coins)
			to_chat(user, span_warning("Maximum withdrawal limit exceeded. You can only withdraw up to [max_coins] coins at once."))
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		amt = SStreasury.get_balance(H)
		if(!Adjacent(user))
			return
		if((coin_amt*mod) > amt)
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		if(!SStreasury.withdraw_money_account(coin_amt*mod, H))
			playsound(src, 'sound/misc/machineno.ogg', 100, FALSE, -1)
			return
		record_round_statistic(STATS_MAMMONS_WITHDRAWN, coin_amt * mod)
		budget2change(coin_amt*mod, user, selection)
	else
		to_chat(user, span_warning("The machine bites my finger."))
		if(!drilled)
			icon_state = "atm-b"
		if(H.show_redflash())
			H.flash_fullscreen("redflash3")
		playsound(H, 'sound/combat/hits/bladed/genstab (1).ogg', 100, FALSE, -1)
		SStreasury.create_bank_account(H)
		if(H.mind)
			var/datum/job/target_job = SSjob.GetJob(H.mind.assigned_role)
			if(target_job && target_job.noble_income)
				SStreasury.noble_incomes[H] = target_job.noble_income
		spawn(5)
			say("New account created.")
			playsound(src, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)

/*
/obj/structure/roguemachine/atm/attack_right(mob/user)
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
*/

/obj/structure/roguemachine/atm/attackby(obj/item/P, mob/user, params)
	if(ishuman(user))
		if(istype(P, /obj/item/roguecoin/aalloy))	
			return	
		
		if(istype(P, /obj/item/roguecoin/inqcoin))
			return		

		if(istype(P, /obj/item/roguecoin))
			var/mob/living/carbon/human/H = user
			if(SStreasury.has_account(H))

				if(SStreasury.generate_money_account(P.get_real_price(), H))
					record_round_statistic(STATS_MAMMONS_DEPOSITED, P.get_real_price())
				qdel(P)
				playsound(src, 'sound/misc/coininsert.ogg', 100, FALSE, -1)
				SStreasury.clear_poll_tax_debt(H)
				return

		if(istype(P, /obj/item/coveter))
			var/mob/living/carbon/human/H = user
			if(!HAS_TRAIT(H, TRAIT_FREEMAN))
				to_chat(user, "<font color='red'>I don't know what I'm doing with this thing!</font>")
				return
			var/can_anyone_know = FALSE
			for(var/mob/living/carbon/human/HJ in GLOB.player_list)
				if(HJ.job == "Steward" || HJ.job == "Grand Duke")
					can_anyone_know = TRUE
			if(!can_anyone_know)
				to_chat(user, span_info("There is no one important for the transaction to flow through."))
				return
			if(SStreasury.discretionary_fund.balance <50)
				to_chat(user, "<font color='red'>These fools are completely broke. We'll get nothing out of this...</font>")
				return
			if(mammonsiphoned >499)
				to_chat(user, "<font color='red'>This one has already been siphoned dry...</font>")
				return
			else
				user.visible_message(span_warning("[user] is mounting the Crown onto the meister!"))
				if(do_after(user, 50))
					if(!drilling)
						user.visible_message(span_warning("[user] mounts the Crown atop the meister!"))
						icon_state = "crown_meister"
						has_reported = FALSE
						drilling = TRUE
						drill(src)
						qdel(P)
						message_admins("[usr.key] has applied the Crustacean to a MEISTER.")
						return
		else
			say("No account found. Submit your fingers for inspection.")
	return ..()

/obj/structure/roguemachine/atm/examine(mob/user)
	. = ..()
	. += span_notice("Current Crown levies:")
	. += span_smallnotice("Contract levy: [round(SStreasury.get_tax_rate(TAX_CATEGORY_CONTRACT_LEVY) * 100)]%")
	. += span_smallnotice("Headeater levy: [round(SStreasury.get_tax_rate(TAX_CATEGORY_HEADEATER_LEVY) * 100)]%")
	. += span_smallnotice("Import tariff: [round(SStreasury.get_tax_rate(TAX_CATEGORY_IMPORT_TARIFF) * 100)]%")
	. += span_smallnotice("Export duty: [round(SStreasury.get_tax_rate(TAX_CATEGORY_EXPORT_DUTY) * 100)]%")


/obj/structure/roguemachine/atm/proc/drill(obj/structure/roguemachine/atm)
	if(!drilling)
		return
	if(SStreasury.discretionary_fund.balance <50)
		new /obj/item/coveter(loc)
		loc.visible_message(span_warning("The Crown grinds to a halt as the last of the treasury spills from the meister!"))
		playsound(src, 'sound/misc/DrillDone.ogg', 70, TRUE)
		icon_state = "atm"
		drilling = FALSE
		has_reported = FALSE
		return
	if(mammonsiphoned >199) // The cap variable for siphoning. 
		new /obj/item/coveter(loc)
		loc.visible_message(span_warning("Maximum withdrawal reached! The meister weeps."))
		playsound(src, 'sound/misc/DrillDone.ogg', 70, TRUE)
		icon_state = "meister_broken"
		drilled = TRUE
		drilling = FALSE
		has_reported = FALSE
		return
	else
		loc.visible_message(span_warning("A horrible scraping sound emanates from the Crown as it does its work..."))
		if(!has_reported)
			send_ooc_note("A parasite of the Freefolk is draining a Meister! Location: [location_tag ? location_tag : "Unknown"]", job = list("Grand Duke", "Steward", "Clerk"))
			has_reported = TRUE
		playsound(src, 'sound/misc/TheDrill.ogg', 70, TRUE)
		spawn(100) // The time it takes to complete an interval. If you adjust this, please adjust the sound too. It's 'about' perfect at 100. Anything less It'll start overlapping.
			loc.visible_message(span_warning("The meister spills its bounty!"))
			SStreasury.burn(SStreasury.discretionary_fund, 20, "ATM drill - Freefolk")
			mammonsiphoned += 20
			budget2change(20, null, "SILVER")
			playsound(src, 'sound/misc/coindispense.ogg', 70, TRUE)
			drill(src)

/obj/structure/roguemachine/atm/attack_right(mob/living/carbon/human/user)
	if(drilling)
		to_chat(user,"<font color='yellow'>I begin dismounting the Crown from the meister...</font>" )
		if(do_after(user, 30, src))
			if(!drilling)
				return
			new /obj/item/coveter(loc)
			user.visible_message(span_warning("[user] dismounts the Crown!"))
			icon_state = "atm"
			drilling = !drilling
	else
		return

/obj/item/coveter
	name = "Covetous Crown"
	desc = "A Crown which craves the brow of miesters and the vault's jawbank; it could be also be mounted upon a restrained person's head to drain their miester account in a pinch."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "crown_object"
	force = 10
	throwforce = 10
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_NORMAL
	obj_flags = CAN_BE_HIT
	var/is_active
	var/needed_cycles
	var/slow_drain = 10
	var/slow_delay = 10
	var/fast_drain = 50
	var/static/list/fast_effects =	list("agony","crunch","whimper","cry","silence")
	var/static/list/slow_effects =	list("whimper","cry","silence")
	sellprice = 100

/obj/item/coveter/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	. = ..()
	if(!proximity_flag)	//Not adjacent
		return
	if(!ishuman(target)) //We're not robbing goats with this
		return
	if(is_active)		//We're already draining
		to_chat(user,span_info("It's already extracting!"))
		return
	var/mob/living/carbon/human/H = target
	if(!H.client)	//The target's DCed or bugged out or is an NPC
		return
	if(H.stat)	//They're dead
		to_chat(user,span_info("Their blood is still. You need someone living for this."))
		return
	if(!H.restrained())
		to_chat(user,span_info("They need to be restrained."))
		return
	if(H.head)
		to_chat(user,span_info("Their head is covered."))
		return
	if(SStreasury.has_account(H))
		if(SStreasury.get_balance(H) > 0)
			var/turf/T = get_turf(H)
			var/sum
			var/choice = alert(user,"How would you like to take it? Fast and Loud or Slow and Quiet?","CHOOSE","Fast","Slow","Nevermind")
			switch(choice)
				if("Fast")
					is_active = TRUE
					needed_cycles = round(SStreasury.get_balance(H) / fast_drain)
					if(needed_cycles == 0)	//If you have less than 50 mammon, you'll still get drained at least once.
						needed_cycles = 1
					user.visible_message(span_warn("[user] hastily shoves \the [src] into [H]'s forehead!"))
					playsound(H, 'sound/combat/hits/pick/genpick (1).ogg', 100)
					playsound(src, 'sound/misc/TheDrill.ogg', 70, TRUE)
					to_chat(H,span_info("<font color ='red'>Sharp claws dig into your skull. There's a warmth trickling down your head.</font>"))
					for(var/i = 1,i<=needed_cycles,i++)
						if(do_after(user, 25))
							SStreasury.burn(SStreasury.get_account(H), fast_drain, "Coveter Crown - Freefolk")
							sum += fast_drain
							new /obj/item/roguecoin/gold(T, fast_drain / 10)
							if(prob(needed_cycles*2))
								drain_effect_fast(H)
							if(i == needed_cycles)	//Last cycle.
								playsound(src, 'sound/misc/DrillDone.ogg', 70, TRUE)
								is_active = FALSE
								to_chat(H,span_info("<font color ='red'>You feel very drained.</font>"))
								send_ooc_note("A parasite of the Freefolk has siphoned [H.real_name] of [sum] from the Nervemaster's veins.", job = list("Grand Duke", "Steward", "Clerk"))
						else
							is_active = FALSE
							if(sum)
								send_ooc_note("A parasite of the Freefolk has siphoned [H.real_name] of [sum] from the Nervemaster's veins.", job = list("Grand Duke", "Steward", "Clerk"))
							break
				if("Slow")
					is_active = TRUE
					needed_cycles = round(SStreasury.get_balance(H) / slow_drain)
					if(needed_cycles == 0)	//If you have less than 10 mammon, you'll still get drained at least once.
						needed_cycles = 1
					user.visible_message(span_warn("[user] carefully and methodically aligns \the [src] with [H]'s forehead..."))
					to_chat(H,span_info("Tiny claws prick into your head. There's a trickling warmth running down your cheeks."))
					playsound(H, 'sound/gore/flesh_eat_01.ogg', 100)
					var/obj/item/bodypart/head = H.get_bodypart(BODY_ZONE_HEAD)
					head.add_wound(/datum/wound/slash)
					head.update_disabled()
					H.apply_damage(10, BRUTE, head)
					for(var/i = 1,i<=needed_cycles,i++)
						if(do_after(user, 10))
							SStreasury.burn(SStreasury.get_account(H), slow_drain, "Coveter Crown - Freefolk")
							sum += slow_drain
							new /obj/item/roguecoin/gold(T, slow_drain / 10)
							if(prob(needed_cycles*2))
								drain_effect_fast(H)
							if(i == needed_cycles)	//Last cycle.
								is_active = FALSE
								send_ooc_note("A parasite of the Freefolk has siphoned [H.real_name] of [sum] from the Nervemaster's veins.", job = list("Grand Duke", "Steward", "Clerk"))
						else
							is_active = FALSE
							if(sum)
								send_ooc_note("A parasite of the Freefolk has siphoned [H.real_name] of [sum] from the Nervemaster's veins.", job = list("Grand Duke", "Steward", "Clerk"))
							break
				if("Nevermind")
					return
				else
					return
		else
			to_chat(user,span_info("They have nothing for us to take."))
			return

	else
		to_chat(user,span_info("Their blood is unsoiled by the [SSticker.realm_type_short]'s Nervemaster. There is nothing to take."))
		return

/obj/item/coveter/proc/drain_effect_fast(mob/living/carbon/human/H)
	var/consequence = pick(fast_effects)
	var/obj/item/bodypart/head = H.get_bodypart(BODY_ZONE_HEAD)
	switch(consequence)
		if("crunch")
			playsound(src.loc, 'sound/items/beartrap.ogg', 300, TRUE, -1)
			visible_message(span_info("<font color ='red'>It pierces bone as it extracts!</font>"))
			head.add_wound(/datum/wound/fracture)
			head.update_disabled()
			H.apply_damage(50, BRUTE, head)
			H.emote("agony")
		if("agony")
			H.apply_damage(10, BRUTE, head)
			H.emote("agony")
		if("whimper")
			H.apply_damage(10, BRUTE, head)
			H.emote("whimper")
		if("cry")
			H.apply_damage(10, BRUTE, head)
			H.emote("cry")
		if("silence")
			return
		else
			return

/obj/item/coveter/proc/drain_effect_slow(mob/living/carbon/human/H)
	var/consequence = pick(slow_effects)
	switch(consequence)
		if("whimper")
			H.emote("whimper")
		if("cry")
			H.emote("cry")
		if("silence")
			return
		else
			return
