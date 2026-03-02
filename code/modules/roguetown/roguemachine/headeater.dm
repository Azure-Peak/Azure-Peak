// Ported from Vanderlin Gaffer PR. But this is meant to be a machine for lowpop headhunting that gives you such a poor price you'd rather sell to the merchant.
/obj/structure/roguemachine/headeater
	name = "HEADEATER"
	desc = "A machine that indulges in humenity's oldest profession; killing. The heads of Dendor's creechers, goblins, and ambushers go in, and coins-a-plenty come \
	out. The automation comes at a steep cost, however, as over half of each head's price will be taxed to the Merchant's Guild. You could likely garner a much fairer \
	price by directly selling such heads to a Merchant, instead."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "headeater"
	density = FALSE
	blade_dulling = DULLING_BASH
	pixel_y = 32
	var/return_ratio = 0.45 // 45% cost should make it enticing enough to sell to merchant probably? Upped from 40 to account for taxation
	var/topay = 0

/obj/structure/roguemachine/headeater/examine()
	. = ..()
	. += span_info("Left-click to deposit a head into the machine, and right-click to deposit all heads in front of the machine.")

/obj/structure/roguemachine/headeater/attackby(obj/item/H, mob/user, params)
	. = ..()
	if(!istype(H, /obj/item/natural/head) && !istype(H, /obj/item/bodypart/head))
		to_chat(user, span_danger("It seems uninterested by [H]"))
		return
	eathead(H, user)

/obj/structure/roguemachine/headeater/proc/tax(amount)
	var/tax_rate = SStreasury.tax_value
	var/tax_amt = round(amount * tax_rate)
	var/net_amount = amount - tax_amt

	if(tax_amt > 0)
		SStreasury.give_money_treasury(tax_amt, "headeater tax - [src.name]")
		record_round_statistic(STATS_TAXES_COLLECTED, tax_amt)

	return round(net_amount)
	
/obj/structure/roguemachine/headeater/proc/eathead(obj/item/H, mob/user, supress_message = FALSE, paynow = TRUE)
	if(istype(H, /obj/item/bodypart/head))
		var/obj/item/bodypart/head/E = H
		if(E.sellprice > 0)
			if(!supress_message)
				to_chat(user, span_danger("the [src] consumes [E] spitting out coins in its place!"))
			if(paynow)
				budget2change(E.sellprice * return_ratio, user)
			else
				topay += E.sellprice * return_ratio
			E.forceMove(src)
			return

	if(istype(H, /obj/item/natural/head))
		var/obj/item/natural/head/A = H
		if(A.sellprice > 0)
			if(!supress_message)
				to_chat(user, span_danger("the [src] consumes [A] spitting out coins in its place!"))
			if(paynow)
				budget2change(tax(A.sellprice * return_ratio, user))
			else
				topay += A.sellprice * return_ratio
			A.forceMove(src)
			return

/obj/structure/roguemachine/headeater/attack_right(mob/user)
	if(ishuman(user))
		for(var/obj/I in get_turf(src))
			if(istype(I, /obj/item/natural/head))
				eathead(I, user, TRUE, FALSE)
			if(istype(I, /obj/item/bodypart/head))
				eathead(I, user, TRUE, FALSE)
	if(topay > 0)
		topay = tax(topay)
		to_chat(user, span_danger("The [src] spits out [topay] mammons!"))
		budget2change(topay, user)
		topay = 0
