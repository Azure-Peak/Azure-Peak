/datum/roguestock/bounty/treasure
	name = "Collectable Treasures"
	desc = "Treasures are minted for 80% of their value and deposited into the depositor's account. </br>Lesser weapons, clothes, and ores are excluded. </br> Insertions worth at least 30 mammons will always be depositable. </br> Statues, gemstones, utensils and rings will always deposit, regardless of value."
	item_type = /obj
	payout_price = 60
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
		return FALSE // Anti-exploitation fix.
	if(istype(I, /obj/item/clothing/ring/signet/triumph))
		return FALSE // Prevents 'free coinage' exploitage.
	if(istype(I, /obj/item/clothing/ring/gold/triumph))
		return FALSE // Ditto, going down.
	if(istype(I, /obj/item/clothing/ring/diamond/triumph))
		return FALSE
	if(istype(I, /obj/item/clothing/neck/roguetown/ornateamulet/noble/triumph))
		return FALSE
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross/g/triumph))
		return FALSE
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross/inhumen/g/triumph))
		return FALSE
	if(istype(I, /obj/item/clothing/head/roguetown/circlet/triumph))
		return FALSE
	if(istype(I, /obj/item/clothing/mask/rogue/lordmask/triumph))
		return FALSE
	if(istype(I, /obj/item/clothing/mask/rogue/facemask/goldmask/triumph))
		return FALSE
	if(istype(I, /obj/item/clothing/mask/rogue/facemask/goldmaskc/triumph))
		return FALSE
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry/skysugarbase))
		return FALSE
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/skysugarslab))
		return FALSE
	if(istype(I, /obj/item/reagent_containers/powder/starsugar/skysugar))
		return FALSE
	if(istype(I, /obj/item/reagent_containers/food/snacks/allspice))
		return FALSE
	if(istype(I, /obj/item/rogueweapon/scabbard))
		return FALSE // If you have to sell your decorated scabbards for ozium-money, you'll have to barter.
	if(istype(I, /obj/item/ingot/avantyne))
		return FALSE //Do you think the Police Department'd purchase a fresh baggie of crack from you?
	if(istype(I, /obj/item/ingot/component/threadavantyne))
		return FALSE
	if(istype(I, /obj/item/ingot/component/berserkswordgrip))
		return FALSE //Components for a superweapon - shouldn't accidentally be sellable, in most cases. The glut crystal can always be smelted back down into a proper blood diamond, if profit's on one's mind.
	if(istype(I, /obj/item/ingot/component/berserkswordblade))
		return FALSE
	if(istype(I, /obj/item/ingot/component/heapofrawiron))
		return FALSE
	if(istype(I, /obj/item/ingot/component/glutcrystal))
		return FALSE
	if(istype(I, /obj/item/ingot/component/zizo))
		return FALSE //Same reason as the Avantyne stuff.
	if(istype(I, /obj/item/ingot/component/graggar))
		return FALSE
	if(istype(I, /obj/item/ingot/component/matthios))
		return FALSE
	if(istype(I, /obj/item/ingot/component/baotha))
		return FALSE
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
		if(istype(I, /obj/item/recipe_book/survival)) //Encourages less littering, and diagetically teaches new players how the Stockpile works. Gives five mammons or less.
			return TRUE
	return FALSE
