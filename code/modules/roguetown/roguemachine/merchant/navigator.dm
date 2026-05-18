#define EXPORT_TIME 2 MINUTES
#define EXPORT_TIME_TESTING 5 SECONDS

/obj/item/roguemachine/navigator
	name = "navigator"
	desc = "A machine that attracts the attention of trading balloons."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "ballooner"
	density = TRUE
	blade_dulling = DULLING_BASH
	var/next_airlift
	max_integrity = 0
	anchored = TRUE
	w_class = WEIGHT_CLASS_GIGANTIC
	/// A fixed tax on all items sold through the balloon that overrides queens tax. Used for blackmarket
	var/fixed_tax = 0
	/// Motto displayed at the top of the vendor interface
	var/motto = "NAVIGATOR - Your goods, airborne."
	/// When TRUE, Crown export duty is collected on seller gross AND on the Merchant's levy.
	var/pay_taxes = TRUE
	/// When TRUE, the Merchant's levy is collected from seller gross.
	var/pay_merchant_share = TRUE
	/// Jobs whose members may right-click to inspect dodge tallies.
	var/list/profit_id = list("Merchant", "Shophand")
	/// Running tally of Crown export duty actually collected via this specific navigator.
	var/duty_collected_here = 0
	/// Running tally of duty owed but dodged. Only shown to Merchant/Shophand.
	var/duty_evaded_here = 0
	/// Running tally of Merchant levy actually collected via this specific navigator.
	var/levy_collected_here = 0

/obj/item/roguemachine/navigator/examine()
	. = ..()
	var/export_time = EXPORT_TIME
	#ifdef LOCALTEST
	export_time = EXPORT_TIME_TESTING
	#endif
	. += span_notice("This machine attracts trading balloons every [DisplayTimeText(export_time)]. Goods are sucked into the air and mammons are dropped after tax has been collected.")

/obj/item/roguemachine/navigator/get_mechanics_examine(mob/user)
	. = ..()
	. += span_info("Drop items on the tiles around the navigator. Trading balloons arrive periodically and lift the goods away, leaving mammon in change on this tile.")
	if(fixed_tax > 0)
		. += span_info("This navigator charges a fixed handler's fee of [fixed_tax * 100]% before any Crown duty. Smuggler-grade.")
	else
		. += span_info("The Crown's export duty is applied to the payout at the prevailing rate.")
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.job in profit_id)
			. += span_info("Crown duty: <b>[pay_taxes ? "PAYING" : "DODGING"]</b>. Merchant's levy: <b>[pay_merchant_share ? "COLLECTING" : "WAIVED"]</b>.")

// 70% taxation and rip off to encourage people to risk it with merchant / others
/obj/item/roguemachine/navigator/smuggler
	name = "battered navigator"
	desc = "A crudely repaired navigator bolted to the hull of a leaky boat. It stinks of brine and contraband."
	motto = "NAVIGA??R - - ████ ██████ █████████ - FREEDOM OF TRANSACTION.."
	fixed_tax = 0.7
	pay_taxes = FALSE
	pay_merchant_share = FALSE

/obj/item/roguemachine/navigator/private
	name = "private navigator"
	desc = "A navigator kept under the Merchant's own roof."
	motto = "NAVIGATOR - Proprietor's berth."
	pay_taxes = TRUE
	pay_merchant_share = FALSE

/obj/item/roguemachine/navigator/smuggler/examine(mob/user)
	. = ..()
	. += span_notice("The rates here are disastrous. Having a facilitator from the bathhouse nearby might improve them to 100%.")
	if(fixed_tax <= 0.5)
		. += span_notice("A facilitator is present. Current handler's fee: [fixed_tax * 100]%.")
	else
		. += span_warning("No facilitator present. Current handler's fee: [fixed_tax * 100]%.")

/obj/item/roguemachine/navigator/smuggler/process()
	if(!anchored)
		return TRUE
	// Only check bathhouse staff proximity on export tick, not every SSroguemachine fire
	if(world.time > next_airlift)
		var/bath_nearby = FALSE
		for(var/mob/living/carbon/human/H in range(7, src))
			if(H.stat != DEAD && (H.job in GLOB.bathhouse_positions))
				bath_nearby = TRUE
				break
		fixed_tax = bath_nearby ? 0.0 : 0.7
	return ..()

/obj/structure/roguemachine/balloon_pad
	name = ""
	desc = ""
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = ""
	density = FALSE
	layer = BELOW_OBJ_LAYER
	anchored = TRUE

/obj/item/roguemachine/navigator/attack_hand(mob/living/user)
	if(!anchored)
		return ..()
	user.changeNext_move(CLICK_CD_INTENTCAP)

	var/contents

	contents += "<center>[motto]<BR>"
	contents += "--------------<BR>"
	if(fixed_tax > 0)
		contents += "HANDLER'S FEE: [fixed_tax * 100] %<BR>"
	contents += "Next Balloon: [time2text((next_airlift - world.time), "mm:ss")]<BR>"

	var/duty_rate = SStreasury.get_tax_rate(TAX_CATEGORY_EXPORT_DUTY)
	var/levy_rate = SSmerchant_trade ? SSmerchant_trade.merchant_levy_percent : 0
	var/merchant_only = FALSE
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		merchant_only = (H.job in profit_id)
	contents += "Crown Export Duty: <b>[round(duty_rate * 100)]%</b>"
	if(merchant_only && !pay_taxes)
		contents += " <font color='#c84'><b>(DODGING)</b></font>"
	contents += "<br>"
	contents += "Merchant's Levy: <b>[levy_rate]%</b>"
	if(merchant_only && !pay_merchant_share)
		contents += " <font color='#c84'><b>(WAIVED)</b></font>"
	contents += "<br>"
	if(merchant_only)
		contents += "<font color='#8a8'>Crown paid: [duty_collected_here]m</font> &middot; <font color='#c84'>Crown evaded: [duty_evaded_here]m</font><br>"
		contents += "<font color='#8a8'>Levy paid: [levy_collected_here]m</font><br>"
	contents += "</center><BR>"

	if(!user.can_read(src, TRUE))
		contents = stars(contents)
	var/datum/browser/popup = new(user, "VENDORTHING", "", 370, 300)
	popup.set_content(contents)
	popup.open()

/obj/item/roguemachine/navigator/attack_right(mob/user)
	if(!anchored || !ishuman(user))
		return ..()
	var/mob/living/carbon/human/H = user
	if(!(H.job in profit_id))
		to_chat(H, span_warning("Only a Merchant may tamper with the Navigator's toll."))
		return
	if(!H.canUseTopic(src, BE_CLOSE))
		return
	var/list/options = list()
	options += (pay_taxes ? "Stop paying Crown duty" : "Resume paying Crown duty")
	options += (pay_merchant_share ? "Waive Merchant's levy" : "Resume Merchant's levy")
	var/select = input(H, "Adjust the Navigator's toll clasp.", "Navigator") as null|anything in options
	if(!select || !H.canUseTopic(src, BE_CLOSE))
		return
	switch(select)
		if("Stop paying Crown duty")
			pay_taxes = FALSE
		if("Resume paying Crown duty")
			pay_taxes = TRUE
		if("Waive Merchant's levy")
			pay_merchant_share = FALSE
		if("Resume Merchant's levy")
			pay_merchant_share = TRUE
	to_chat(H, span_notice("The Navigator's toll clasp clicks. Crown duty: <b>[pay_taxes ? "PAYING" : "DODGING"]</b>. Merchant's levy: <b>[pay_merchant_share ? "COLLECTING" : "WAIVED"]</b>."))
	playsound(loc, 'sound/misc/gold_misc.ogg', 80, FALSE, -1)

/obj/item/roguemachine/navigator/update_icon()
	if(!anchored)
		w_class = WEIGHT_CLASS_BULKY
		set_light(0)
		return
	w_class = WEIGHT_CLASS_GIGANTIC
	set_light(2, 2, 2, l_color = "#1b7bf1")

/obj/item/roguemachine/navigator/Initialize()
	. = ..()
	if(anchored)
		START_PROCESSING(SSroguemachine, src)
	update_icon()
	for(var/X in GLOB.alldirs)
		var/T = get_step(src, X)
		if(!T)
			continue
		new /obj/structure/roguemachine/balloon_pad(T)

/obj/item/roguemachine/navigator/Destroy()
	STOP_PROCESSING(SSroguemachine, src)
	set_light(0)
	return ..()

/obj/item/roguemachine/navigator/process()
	if(!anchored)
		return TRUE
	var/export_time = EXPORT_TIME
	#ifdef LOCALTEST
		export_time = EXPORT_TIME_TESTING
	#endif
	if(world.time > next_airlift)
		next_airlift = world.time + export_time
		var/play_sound = FALSE
		for(var/D in GLOB.alldirs)
			var/budgie = 0
			var/turf/T = get_step(src, D)
			if(!T)
				continue
			var/obj/structure/roguemachine/balloon_pad/E = locate() in T
			if(!E)
				continue
			for(var/obj/I in T)
				if(I.anchored || !isturf(I.loc) || istype(I, /obj/item/roguecoin)|| istype(I, /obj/structure/handcart))
					continue
				if(isitem(I))
					var/obj/item/IT = I
					if(IT.atc_sealed)
						continue
				var/prize = I.get_real_price() * (1 - fixed_tax)
				if(prize >= 1)
					play_sound=TRUE
					budgie += prize
					I.visible_message(span_warning("[I] is sucked into the air!"))
					qdel(I)
			budgie = round(budgie)
			record_round_statistic(STATS_TRADE_VALUE_EXPORTED, budgie)
			if(budgie > 0)
				play_sound = TRUE
				settle_export(budgie)
		if(play_sound)
			playsound(src.loc, 'sound/misc/hiss.ogg', 100, FALSE, -1)

/// Parallel-bites payout. Crown duty and Merchant levy both come off gross; the levy is
/// itself subject to Crown income duty so the producer's tax base doesn't shrink because
/// the Merchant exists. Producer net drops on src tile, levy drops on the tile facing src.dir.
/obj/item/roguemachine/navigator/proc/settle_export(gross)
	var/duty_rate = SStreasury.get_tax_rate(TAX_CATEGORY_EXPORT_DUTY)
	var/levy_pct = SSmerchant_trade ? SSmerchant_trade.merchant_levy_percent : 0
	var/levy = pay_merchant_share ? round(gross * levy_pct / 100) : 0
	var/duty_on_gross = round(gross * duty_rate)
	var/duty_on_levy = round(levy * duty_rate)
	var/total_duty = duty_on_gross + duty_on_levy
	var/producer_net = gross - duty_on_gross - levy
	if(producer_net < 0)
		producer_net = 0
	var/merchant_net = levy - duty_on_levy
	if(merchant_net < 0)
		merchant_net = 0
	if(pay_taxes)
		if(duty_on_gross > 0)
			SStreasury.mint(SStreasury.discretionary_fund, duty_on_gross, "[TAX_CATEGORY_EXPORT_DUTY] ([src.name])")
			SStreasury.apply_concordat_tithe(gross, TAX_CATEGORY_EXPORT_DUTY, "[src.name]")
		if(duty_on_levy > 0)
			SStreasury.mint(SStreasury.discretionary_fund, duty_on_levy, "[TAX_CATEGORY_EXPORT_DUTY] (levy income, [src.name])")
			SStreasury.apply_concordat_tithe(levy, TAX_CATEGORY_EXPORT_DUTY, "levy income ([src.name])")
		if(total_duty > 0)
			record_round_statistic(STATS_TAXES_COLLECTED, total_duty)
			record_round_statistic(STATS_REVENUE_EXPORT_DUTY, total_duty)
			duty_collected_here += total_duty
			if(SSmerchant_trade)
				SSmerchant_trade.merchant_levy_taxed += duty_on_levy
	else
		if(total_duty > 0)
			record_round_statistic(STATS_TAXES_EVADED, total_duty)
			duty_evaded_here += total_duty
		merchant_net = levy
	if(merchant_net > 0)
		SStreasury.mint(SStreasury.merchant_fund, merchant_net, "Merchant's levy ([src.name])")
		levy_collected_here += merchant_net
		if(SSmerchant_trade)
			SSmerchant_trade.merchant_levy_collected += merchant_net
	var/turf/producer_turf = get_turf(src)
	if(producer_net > 0)
		budget2change(producer_net, custom_turf = producer_turf)
	var/list/parts = list("[gross] gross")
	if(levy > 0)
		parts += "[levy] merchant"
	if(total_duty > 0)
		parts += "[total_duty] taxed"
	parts += "[producer_net] net"
	visible_message(span_info("[src] chimes: \"[parts.Join(", ")].\""))

#undef EXPORT_TIME
#undef EXPORT_TIME_TESTING
