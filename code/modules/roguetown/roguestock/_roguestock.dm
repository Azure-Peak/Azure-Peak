/datum/roguestock
	var/name = ""
	var/desc = ""
	var/item_type = null
	/// Units currently held in the local stockpile. Replaces the legacy `held_items` list.
	var/stockpile_amount = 0
	var/payout_price = 1
	var/withdraw_price = 1
	var/withdraw_disabled = FALSE
	var/demand = 100
	// If the type of item is a mint item it will be reminted into coins
	var/mint_item = FALSE
	var/export_price = 1
	// Limit for stockpile. Only accounted for if it is not mint_item
	var/stockpile_limit = 100 // Limit beyond which the stockpile will just eat your things for free. Very high limit just to be safe you should define it directly.
	//how many of the items are consumed/spawned when exporting/importing
	var/importexport_amt = 10
	var/import_only = FALSE //for importing crackers, etc
	var/export_only = FALSE
	var/stable_price = FALSE
	var/percent_bounty = FALSE
	var/category = "Raw Materials" // Category for the stockpile

/datum/roguestock/New()
	..()
	if(!stable_price)
		demand = rand(60,140)
	return

/datum/roguestock/proc/get_payout_price(obj/item/I) //treasures modify this based on the price of the treasure
	return payout_price

/datum/roguestock/proc/check_item(obj/item/I) //for checking monster heads if they belong to monsters and other stuff
	if(import_only) //so you can't submit crackers to stockpile
		return FALSE
	//To stop people selling half-eaten food and rotten meat to the stockpile
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/food = I
		if(food.eat_effect == /datum/status_effect/debuff/rotfood)
			return FALSE
		if(food.bitecount > 0)
			return FALSE
		if(food.slices_num && food.slices_num < initial(food.slices_num)) // prevent selling partly-sliced butter
			return FALSE
	return TRUE

/datum/roguestock/proc/get_export_price()
	var/spread = SStreasury.trade_spread
	var/amount = round((export_price*importexport_amt) * (demand/100))
	amount = amount - round(spread*amount)
	return max(amount, 0)

/datum/roguestock/proc/get_import_price()
	var/spread = SStreasury.trade_spread
	var/amount = round((export_price*importexport_amt) * (demand/100))
	amount = amount + round(spread*amount)
	return max(amount, 5)

/datum/roguestock/proc/lower_demand()
	if(stable_price)
		return
	demand = max(demand-3,10)

/datum/roguestock/proc/raise_demand()
	if(stable_price)
		return
	demand = min(demand+1,200)

/datum/roguestock/proc/demand2word()
	switch(demand)
		if(160 to 200)
			return "Scarce"
		if(130 to 160)
			return "High"
		if(110 to 130)
			return "Growing"
		if(90 to 110)
			return "Normal"
		if(70 to 90)
			return "Falling"
		if(40 to 70)
			return "Low"
		if(1 to 40)
			return "Excess"
