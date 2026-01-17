/datum/roguestock/bounty/treasure
	name = "Collectable Treasures"
	desc = "Treasures are minted for 80% of its value, which is deposited into the treasury. </br>Lesser weapons, clothes, and ores are excluded. </br> Insertions worth at least 30 mammons will always be depositable. </br> Statues, gemstones, utensils and rings will always deposit, regardless of value."
	item_type = /obj
	payout_price = 70
	mint_item = TRUE
	percent_bounty = TRUE

/datum/roguestock/bounty/treasure/get_payout_price(obj/item/I)
	if(!I)
		return ..()
	var/bounty_percent = (payout_price/100) * I.get_real_price()
	bounty_percent = round(bounty_percent)
	if(bounty_percent < 1)
		return 0
	return bounty_percent

/* Non-Ideal but a way to replicate old vault mechanics:
	- Ores are not accepted.
	- Items that are important to round-critical roles, events, or mmechanics are not accepted.
	- Statues, gemstones, cupwear, cookwear, utensils and candles will always be allowed.
	- Certain standalone items that don't meet the threshold, but are still intended to be sold off as low-tier dungeon loot - like decrepit and ancient items - will always be allowed.
	- Otherwise, anything with a standing value of thirty mammons or above can be redeemed at the Stockpile.
*/
/datum/roguestock/bounty/treasure/check_item(obj/I)
	if(!I)
		return
	if(istype(I, /obj/item))
		var/obj/item/W = I
		if(W.is_important)
			return FALSE
	if(istype(I, /obj/item/rogueore))
		return FALSE
	if(istype(I, /obj/item/bodypart/head))
		return FALSE // Thats the HEADEATER's job.
	if(istype(I, /obj/item/natural/head))
		return FALSE  // Thats the HEADEATER's job.
	if(istype(I, /obj/item/storage))
		return FALSE //Anti-Exploit fix
	if(I.get_real_price() > 0)
		if(istype(I, /obj/item/reagent_containers/glass/cup)) //As Randall explained, these statements allow any item in the codepath to be sold, regardless of their value.
			return TRUE
		if(istype(I, /obj/item/cooking/platter)) //This, for example, means any item that's considered a 'platter' - or a derivative of such - to be sold for some dosh.
			return TRUE
		if(istype(I, /obj/item/kitchen/fork)) //Keep this in mind for later, if you ever wish to add or remove things from this list.
			return TRUE
		if(istype(I, /obj/item/kitchen/spoon))
			return TRUE
		if(istype(I, /obj/item/candle))
			return TRUE
		if(istype(I, /obj/item/roguestatue))
			return TRUE
		if(istype(I, /obj/item/roguegem))
			return TRUE
		if(istype(I, /obj/item/roguecoin/aalloy)) //Can't find a way to make these sellable to the Stockpile. If someone finds a fix, feel free to implement it.
			return TRUE
		if(istype(I, /obj/item/clothing/ring))
			return TRUE
		if(istype(I, /obj/item/reagent_containers/glass/bowl/aalloy))
			return TRUE
		if(istype(I, /obj/item/cooking/pan/aalloy))
			return TRUE
		if(istype(I, /obj/item/reagent_containers/glass/bucket/pot/aalloy))
			return TRUE
		if(istype(I, /obj/item/reagent_containers/glass/bucket/pot/teapot))
			return TRUE
		if(istype(I, /obj/item/tablecloth/silk)) //Standalone items that meet the price minimum can still be listed here, to 'brute-force' their redeemability in case of glitches.
			return TRUE
	if(I.get_real_price() >= 30) //The numerical value here determines how much mammons an item needs to be worth, at the minimum, to be automatically accepted into the Stockpile.
		return TRUE
